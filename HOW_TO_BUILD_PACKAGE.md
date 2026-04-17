# How to Build a Flutter UI Package
#### A complete walkthrough based on `limbo-ui-flutter`

---

## What is a Flutter Package?

A **Flutter package** is a reusable library of widgets/logic with no `main.dart` entry point. It is consumed by apps via `pubspec.yaml` dependency, exactly like `provider` or `flutter_bloc`.

> [!NOTE]
> This guide documents every command and decision used to build `limbo-ui-flutter` — a widget library extracted from the Limbo e-commerce app, structured identically to `base-ui-flutter`.

---

## Step 1 — Scaffold the Package

```bash
# Run from your workspace root (e.g. f:\TimeToBright)
flutter create --template=package --project-name=limbo_ui_flutter .\limbo-ui-flutter
```

**What this does:**
- `--template=package` → generates a package (no `android/`, `ios/`, `main.dart`)
- `--project-name=limbo_ui_flutter` → the Dart package name (snake_case, used in imports)
- `.\limbo-ui-flutter` → folder name (can use hyphens — this is just a directory)

**Files generated:**
```
limbo-ui-flutter/
├── lib/
│   └── limbo_ui_flutter.dart   ← main export file (auto-generated)
├── test/
│   └── limbo_ui_flutter_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## Step 2 — Create the Folder Structure

Mirror the structure used in `base-ui-flutter`:

```powershell
New-Item -ItemType Directory -Force -Path `
  "lib\src\core", `
  "lib\src\components\button", `
  "lib\src\components\navigation", `
  "lib\src\components\app_bar", `
  "lib\src\components\form", `
  "lib\src\components\search", `
  "lib\src\components\category", `
  "lib\src\components\item", `
  "lib\src\components\picker", `
  "example\lib", `
  "test"
```

**Resulting structure:**
```
lib/
├── limbo_ui_flutter.dart        ← barrel export (public API)
└── src/
    ├── core/
    │   ├── limbo_colors.dart    ← color palette
    │   └── limbo_text_styles.dart
    └── components/
        ├── button/
        ├── navigation/
        ├── app_bar/
        ├── form/
        ├── category/
        ├── item/
        ├── picker/
        └── search/
```

> [!IMPORTANT]
> All source files go inside `src/`. Only `limbo_ui_flutter.dart` is public. This pattern is the same used in `base-ui-flutter`.

---

## Step 3 — Configure `pubspec.yaml`

```yaml
name: limbo_ui_flutter
description: "Reusable UI component library extracted from the Limbo e-commerce app."
version: 0.0.1

environment:
  sdk: ^3.2.3
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
```

> [!TIP]
> Keep dependencies minimal. Only add what every consuming app will need. Router packages (`go_router`, `flutter_bloc`) must **NOT** be package dependencies — see Step 4.

---

## Step 4 — The Decoupling Rule

The original Limbo widgets had hard-coded navigation:
```dart
// ❌ BEFORE — tight coupling to app internals
onTap: () => context.push(AppRoutes.categoryRoute); // go_router
```

In the package, replace with **callbacks**:
```dart
// ✅ AFTER — fully portable
final VoidCallback? onTap;
// ...
onTap: () {
  HapticFeedback.lightImpact();
  onTap?.call();   // consuming app handles navigation
}
```

The same rule applies to:
- `ImageProvider` instead of `AssetImage('path/string')` — lets apps pass network images too
- Data models defined **in the package** (`LimboItemData`) instead of referencing app-internal models (`ItemModel`)
- Repository calls moved to callbacks (`onSearch`, `onRemoveRecentSearch`)

---

## Step 5 — Write the Core Files

### `lib/src/core/limbo_colors.dart`
```dart
class LimboColors {
  LimboColors._();  // private constructor → no instances
  static const Color primary = Color(0xFF19b4b3);
  // ...
}
```

### `lib/src/core/limbo_text_styles.dart`
```dart
class LimboTextStyles {
  LimboTextStyles._();
  static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
}
```

---

## Step 6 — Write Components

Each component file follows the pattern:
1. Import only `flutter` and internal package imports
2. Prefix class names with `Limbo` to avoid conflicts
3. Add a doc comment with a usage example

```dart
import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// Brief description.
///
/// ```dart
/// LimboButton(onPressed: () {}, child: Text('OK'))
/// ```
class LimboButton extends StatelessWidget {
  // ...
}
```

**Components created:**

| Class | File | Source |
|---|---|---|
| `LimboColors` | `core/limbo_colors.dart` | `Limbo/core/theme/app_colors.dart` |
| `LimboTextStyles` | `core/limbo_text_styles.dart` | `Limbo/core/theme/app_text_styles.dart` |
| `LimboButton` | `button/limbo_button.dart` | `core/widgets/custom_button.dart` |
| `LimboCategoryButton` | `button/limbo_category_button.dart` | `home/widgets/category_button.dart` |
| `LimboHomeTabBar` | `navigation/limbo_home_tab_bar.dart` | `home/widgets/navigation_button.dart` |
| `LimboAppBar` | `app_bar/limbo_app_bar.dart` | `core/widgets/custom_app_bar.dart` |
| `LimboFormField` | `form/limbo_form_field.dart` | `core/widgets/form_field.dart` |
| `LimboCategoryTitle` | `category/limbo_category_title.dart` | `category/widgets/category_title.dart` |
| `LimboOptionsTitle` | `category/limbo_options_title.dart` | `category/widgets/options_title.dart` |
| `LimboCircleItemGrid` | `category/limbo_circle_item_grid.dart` | `category/widgets/circle_item_grid.dart` |
| `LimboFilterWidget` | `category/limbo_filter_widget.dart` | `category/widgets/filter_widget.dart` |
| `LimboOrderWidget` | `category/limbo_order_widget.dart` | `category/widgets/order_widget.dart` |
| `LimboItemCard` | `item/limbo_item_card.dart` | `core/widgets/items/item_card.dart` |
| `LimboItemsGrid` | `item/limbo_items_grid.dart` | `core/widgets/items/items_grid.dart` |
| `LimboColorPicker` | `picker/limbo_color_picker.dart` | `core/widgets/color_picker.dart` |
| `LimboSearchWidget` | `search/limbo_search_widget.dart` | `search/widgets/search_widget.dart` |

---

## Step 7 — Write the Barrel Export File

`lib/limbo_ui_flutter.dart` is the **only public file**. It re-exports everything:

```dart
library limbo_ui_flutter;

// Core
export 'src/core/limbo_colors.dart';
export 'src/core/limbo_text_styles.dart';

// Button
export 'src/components/button/limbo_button.dart';
export 'src/components/button/limbo_category_button.dart';

// Navigation
export 'src/components/navigation/limbo_home_tab_bar.dart';

// ... (one export per component file)
```

Consuming apps use a single import:
```dart
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';
```

---

## Step 8 — Install Dependencies

```bash
flutter pub get
```

Expected output: `Got dependencies` with no errors.

---

## Step 9 — Run Static Analysis

```bash
flutter analyze
```

Expected: `No issues found!`

**Issues we fixed during this build:**

| Issue | Fix |
|---|---|
| Auto-generated `Calculator` test | Replaced with real smoke tests for `LimboColors` / `LimboTextStyles` |
| `prefer_const_constructors` (4×) | Added `const` keyword to static widget trees |
| `deprecated_member_use` — `Radio(groupValue/onChanged)` | Replaced `Radio` widget with an `AnimatedContainer` dot indicator |
| `deprecated_member_use` — `Color.value` in test | Replaced with `Color.toARGB32()` |

---

## Step 10 — Run Tests

```bash
flutter test
```

---

## How to Use This Package in Another App

### Option A — Local path dependency (during development)
```yaml
# In your app's pubspec.yaml
dependencies:
  limbo_ui_flutter:
    path: ../limbo-ui-flutter
```

### Option B — Git dependency
```yaml
dependencies:
  limbo_ui_flutter:
    git:
      url: https://github.com/your-org/limbo-ui-flutter.git
      ref: main
```

Then import and use:
```dart
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';

// In your widget:
LimboButton(
  onPressed: () => doSomething(),
  backgroundColor: LimboColors.primary,
  child: const Text('Confirmar', style: LimboTextStyles.button),
)
```

---

## Key Differences vs. `base-ui-flutter`

| | `base-ui-flutter` | `limbo-ui-flutter` |
|---|---|---|
| **Domain** | Focus / AI assistant app | Limbo e-commerce app |
| **Prefix** | `Focus` | `Limbo` |
| **Fonts** | Montserrat, Mulish, GoogleSans (bundled) | Configurable via LimboConfiguration |
| **Config system** | `BaseUIConfiguration` singleton | Direct `LimboColors` / `LimboTextStyles` |
| **Components** | Chat, Voice, MFA, Trip | ItemCard, Filter, Search, Category |

---

## Final Package Structure

```
limbo-ui-flutter/
├── lib/
│   ├── limbo_ui_flutter.dart
│   └── src/
│       ├── core/
│       │   ├── limbo_colors.dart
│       │   └── limbo_text_styles.dart
│       └── components/
│           ├── app_bar/limbo_app_bar.dart
│           ├── button/
│           │   ├── limbo_button.dart
│           │   └── limbo_category_button.dart
│           ├── category/
│           │   ├── limbo_category_title.dart
│           │   ├── limbo_circle_item_grid.dart
│           │   ├── limbo_filter_widget.dart
│           │   ├── limbo_options_title.dart
│           │   └── limbo_order_widget.dart
│           ├── form/limbo_form_field.dart
│           ├── item/
│           │   ├── limbo_item_card.dart
│           │   └── limbo_items_grid.dart
│           ├── navigation/limbo_home_tab_bar.dart
│           ├── picker/limbo_color_picker.dart
│           └── search/limbo_search_widget.dart
├── test/
│   └── limbo_ui_flutter_test.dart
├── pubspec.yaml
└── analysis_options.yaml
```
