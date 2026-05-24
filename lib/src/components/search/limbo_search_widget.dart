import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A self-contained search bar using Flutter's [SearchAnchor] API.
///
/// The widget manages suggestions internally. Persistence of recent searches
/// is handled externally via [recentSearches], [onSearch], and
/// [onRemoveRecentSearch] callbacks.
///
/// ```dart
/// LimboSearchWidget(
///   recentSearches: _recents,
///   allProducts: ['Camisa azul', 'Pantalón jean'],
///   onSearch: (q) async { await repo.save(q); setState(() {}); },
///   onRemoveRecentSearch: (q) async { await repo.remove(q); setState(() {}); },
///   onBack: () => Navigator.pop(context),
/// )
/// ```
class LimboSearchWidget extends StatefulWidget {
  final List<String> recentSearches;
  final List<String> allProducts;
  final Future<void> Function(String query) onSearch;
  final Future<void> Function(String term) onRemoveRecentSearch;
  final VoidCallback? onBack;
  final String hintText;

  const LimboSearchWidget({
    super.key,
    required this.recentSearches,
    required this.allProducts,
    required this.onSearch,
    required this.onRemoveRecentSearch,
    this.onBack,
    this.hintText = '\u00bfQu\u00e9 est\u00e1s buscando?',
  });

  @override
  State<LimboSearchWidget> createState() => _LimboSearchWidgetState();
}

class _LimboSearchWidgetState extends State<LimboSearchWidget> {
  final SearchController _searchController = SearchController();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }
    setState(() {
      _suggestions = widget.allProducts
          .where((p) => p.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _handleSearch(String query) async {
    if (query.trim().isEmpty) return;
    await widget.onSearch(query);
    _searchController.closeView(query);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      viewBackgroundColor: Colors.white,
      viewHintText: '',
      headerTextStyle: const TextStyle(color: Colors.black),
      headerHintStyle: TextStyle(color: LimboColors.icons),
      dividerColor: Colors.transparent,
      viewShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      viewOnSubmitted: _handleSearch,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll(
              EdgeInsets.only(right: 0, left: 16)),
          backgroundColor:
              WidgetStatePropertyAll(LimboColors.backgroundObject),
          elevation: const WidgetStatePropertyAll(0),
          hintText: widget.hintText,
          hintStyle: WidgetStatePropertyAll(
              TextStyle(color: LimboColors.icons)),
          trailing: [
            Container(
              decoration: BoxDecoration(
                color: LimboColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.search, color: Colors.white, size: 28),
            ),
          ],
          onTap: () => controller.openView(),
        );
      },
      suggestionsBuilder: (context, controller) {
        if (controller.text.isEmpty) {
          return [
            _RecentSearchesView(
              recentSearches: widget.recentSearches,
              onSearch: _handleSearch,
              onRemove: widget.onRemoveRecentSearch,
            ),
          ];
        }
        return _suggestions.map((s) => ListTile(
              title: Text(s),
              onTap: () => _handleSearch(s),
              leading: const Icon(Icons.search, color: Colors.grey),
            ));
      },
      viewLeading: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            color: LimboColors.primary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
      ),
      viewTrailing: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: LimboColors.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: IconButton(
            onPressed: () => _handleSearch(_searchController.text),
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}

/// Inline recent-searches panel used inside [LimboSearchWidget].
class _RecentSearchesView extends StatelessWidget {
  final List<String> recentSearches;
  final Future<void> Function(String) onSearch;
  final Future<void> Function(String) onRemove;

  const _RecentSearchesView({
    required this.recentSearches,
    required this.onSearch,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Sin b\u00fasquedas recientes',
            style: TextStyle(color: LimboColors.gray),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Recientes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        ...recentSearches.map(
          (term) => ListTile(
            leading: Icon(Icons.history, color: LimboColors.icons),
            title: Text(term),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => onRemove(term),
            ),
            onTap: () => onSearch(term),
          ),
        ),
      ],
    );
  }
}
