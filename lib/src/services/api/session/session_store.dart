import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal key/value contract used by [SessionStore], so session logic can be
/// unit-tested without the secure-storage platform plugin.
abstract class TokenStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// [TokenStorage] backed by the platform keychain / keystore.
class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  const SecureTokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Persists the access/refresh token pair and the access-token expiry.
///
/// Keys are fixed (`token`, `refreshToken`, `tokenExpiresAt`) because the
/// HTTP layer and the host app share them.
class SessionStore {
  static const String accessKey = 'token';
  static const String refreshKey = 'refreshToken';
  static const String expiresAtKey = 'tokenExpiresAt';

  final TokenStorage _storage;

  const SessionStore(this._storage);

  /// Store on top of the platform secure storage.
  factory SessionStore.secure([FlutterSecureStorage? storage]) =>
      SessionStore(SecureTokenStorage(storage));

  Future<String?> readAccessToken() => _storage.read(accessKey);
  Future<String?> readRefreshToken() => _storage.read(refreshKey);

  Future<DateTime?> readExpiresAt() async {
    final raw = await _storage.read(expiresAtKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  /// Saves a pair returned by login / verify / google / refresh endpoints.
  ///
  /// [refreshToken] and [expiresInSeconds] are optional so a legacy payload
  /// without them still stores the access token (and clears stale values).
  Future<void> save({
    required String accessToken,
    String? refreshToken,
    int? expiresInSeconds,
    DateTime? now,
  }) async {
    await _storage.write(accessKey, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(refreshKey, refreshToken);
    }
    if (expiresInSeconds != null) {
      final expiresAt = (now ?? DateTime.now()).add(
        Duration(seconds: expiresInSeconds),
      );
      await _storage.write(expiresAtKey, expiresAt.toIso8601String());
    } else {
      await _storage.delete(expiresAtKey);
    }
  }

  /// Saves the `token` / `refresh_token` / `expires_in` fields of an auth
  /// payload. Throws when the payload has no access token.
  Future<void> saveFromPayload(Map<String, dynamic> payload) {
    final token = payload['token'];
    if (token is! String || token.isEmpty) {
      throw ArgumentError('La respuesta de autenticación no incluye "token"');
    }
    final refresh = payload['refresh_token'];
    final expires = payload['expires_in'];
    return save(
      accessToken: token,
      refreshToken: refresh is String ? refresh : null,
      expiresInSeconds: expires is num ? expires.toInt() : null,
    );
  }

  Future<void> clear() async {
    await _storage.delete(accessKey);
    await _storage.delete(refreshKey);
    await _storage.delete(expiresAtKey);
  }

  /// True when the access token is missing an expiry, expired, or expires
  /// within [threshold].
  Future<bool> isExpiringWithin(Duration threshold, {DateTime? now}) async {
    final expiresAt = await readExpiresAt();
    if (expiresAt == null) return false;
    return expiresAt.isBefore((now ?? DateTime.now()).add(threshold));
  }
}
