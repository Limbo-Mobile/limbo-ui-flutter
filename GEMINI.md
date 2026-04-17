# Limbo UI Flutter — Project Documentation

## Project Overview
`limbo_ui_flutter` is a reusable UI component library extracted from the Limbo
e-commerce app, compatible with both iOS and Android. It follows Clean Architecture
and SOLID principles to provide a consistent design system and a library of
production-ready widgets that are fully decoupled from application routing,
repositories, and state management.

### Core Technologies
- **Framework:** Flutter (>=3.0.0)
- **Language:** Dart (^3.2.3)
- **Key Dependencies:**
  - Minimal UI dependencies
- **Design Tokens:** `LimboColors` and `LimboTextStyles` (no external config system needed).

---

## Project Structure
```
lib/
├── limbo_ui_flutter.dart        # Main entry point — single import for consumers
└── src/
    ├── core/                    # Foundation systems
    │   ├── limbo_colors.dart    # Color palette (all colors centralised here)
    │   ├── limbo_text_styles.dart # Pre-defined TextStyle constants
    │   └── limbo_validators.dart  # Reusable form validators
    └── components/              # Reusable UI components
        ├── app_bar/             # LimboAppBar
        ├── button/              # LimboButton, LimboCategoryButton
        ├── category/            # Filter, Order, Category title, Circle grid
        ├── form/                # LimboFormField
        ├── item/                # LimboItemCard, LimboItemsGrid
        ├── navigation/          # LimboTabBar
        ├── picker/              # LimboColorPicker
        └── search/              # LimboSearchWidget
```

---

## Key Systems

### 1. Color System (`LimboColors`)
All colors are defined as `static const` in `limbo_colors.dart`.
**Never hardcode colors in component files.** Always reference `LimboColors.*`.

```dart
// ✅ Correct
color: LimboColors.primary

// ❌ Wrong
color: Color(0xFF19b4b3)
color: Colors.teal
```

### 2. Text Styles (`LimboTextStyles`)
Pre-defined styles for common use cases. For typography beyond these, use
explicit font names — never use default `TextStyle` for
user-visible text without a font family.

```dart
// ✅ Correct
style: LimboTextStyles.button
style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: LimboColors.black)

// ❌ Wrong
style: TextStyle(fontSize: 14)   // no font family = system default
```

### 3. Validators (`LimboValidators`)
All form validation must use `LimboValidators`. Never write inline regex
or ad-hoc validators inside widget files.

```dart
// ✅ Correct
LimboFormField(
  validator: LimboValidators.email,
)

LimboFormField(
  validator: LimboValidators.compose([
    LimboValidators.required,
    LimboValidators.minLength(8),
  ]),
)

// ❌ Wrong
validator: (v) => v!.isEmpty ? 'Required' : null,
```

### 4. `LimboButton` — Async Safety
Use `LimboButton` for **all** async actions. It has built-in `isLoading` and
`disabled` states that automatically block double-clicks and show a spinner.

```dart
// ✅ Correct
LimboButton(
  onPressed: _handleSubmit,
  isLoading: _isSubmitting,
  disabled: !_formIsValid,
  child: const Text('Confirmar'),
)

// ❌ Wrong — creates double-click risk
ElevatedButton(onPressed: _handleSubmit, child: Text('Confirmar'))
```

### 5. Dynamic Widgets — The Decoupling Rule
All widgets must be **data-agnostic**. They receive data via constructor
parameters, never from hardcoded lists or app-level singletons.

```dart
// ✅ Correct — app defines the tabs
LimboTabBar(tabs: [
  LimboTabItem(text: 'Para ti', icon: Icons.star_sharp),
  LimboTabItem(text: 'Ofertas', icon: Icons.local_offer),
])

// ❌ Wrong — tab data hardcoded inside the widget
```

Navigation must **always** be handled via callbacks — never call `context.push`
or any router method inside a package widget.

```dart
// ✅ Correct
LimboCategoryButton(
  label: 'Hombre',
  image: AssetImage('assets/hombre.jpg'),
  onTap: () => context.push('/category/hombre'),
)

// ❌ Wrong
onTap: () => context.push(AppRoutes.categoryRoute) // app route inside package
```

---

## Building and Running

### Install Dependencies
```bash
flutter pub get
```

### Run Static Analysis
```bash
flutter analyze
# Expected: No issues found!
```

### Run Tests
```bash
flutter test
```

---

## Development Conventions

| Rule | Detail |
|---|---|
| **Clean Architecture** | Keep validation logic in `LimboValidators`, UI in `components/`. No business logic inside widgets. |
| **SOLID** | Favor composition over inheritance. Widgets receive everything they need via constructor. |
| **Colors** | Always use `LimboColors.*`. No hardcoded `Color(0x...)` values outside `limbo_colors.dart`. |
| **Fonts** | Use `LimboTextStyles` or set `fontFamily`. Never rely on system default font. |
| **Validation** | Always use `LimboValidators`. Never write inline validators in widget files. |
| **Async Actions** | Always use `LimboButton` with `isLoading` for async operations. |
| **Routing** | Use `onTap` / `VoidCallback` parameters. Never import `go_router` or any router in this package. |
| **Naming** | All public classes start with `Limbo`. Private helpers use `_` prefix. |
| **Strings** | Use single quotes `'...'` throughout (enforced by linter). |
| **print** | Never use `print()`. Use `debugPrint()` in debug-only code paths. |
| **Testing** | Add a widget test for every new component. Add a unit test for every new validator. |

---

## Component Reference

### Core
| Export | Description |
|---|---|
| `LimboColors` | Full color palette |
| `LimboTextStyles` | Pre-defined text styles (`button`, `auth`) |
| `LimboValidators` | Form validators (`email`, `password`, `phone`, `required`, `compose`, ...) |

### Components
| Export | Key Parameters |
|---|---|
| `LimboButton` | `onPressed`, `child`, `disabled`, `isLoading`, `backgroundColor`, `widthSize` |
| `LimboCategoryButton` | `label`, `image` (ImageProvider), `onTap` |
| `LimboAppBar` | `title`, `titleWidget`, `content` |
| `LimboFormField` | `controller`, `hintText`, `icon`, `validator`, `isPassword` |
| `LimboTabBar` | `tabs` (List\<LimboTabItem\>), `labelColor`, `textScale` |
| `LimboCategoryTitle` | `category`, `size` |
| `LimboOptionsTitle` | `name` |
| `LimboCircleItemGrid` | `items` (List\<ImageProvider\>), `onItemTap`, `crossAxisCount` |
| `LimboFilterWidget` | `sections` (List\<LimboFilterSection\>), `rangeMin`, `rangeMax`, `currencySymbol` |
| `LimboColorFilterGrid` | `colors`, `selectedColor`, `onColorChanged`, `crossAxisCount` |
| `LimboOrderWidget` | `options` (List\<LimboSortOption\>), `initialSelection`, `onOptionSelected` |
| `LimboItemCard` | `item` (LimboItemData), `onTap` |
| `LimboItemsGrid` | `items`, `onItemTap`, `crossAxisCount`, `itemHeight` |
| `LimboColorPicker` | `colors`, `selectedColor`, `onChangeColor` |
| `LimboSearchWidget` | `recentSearches`, `allProducts`, `onSearch`, `onRemoveRecentSearch` |
