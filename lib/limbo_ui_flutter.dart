/// limbo_ui_flutter — Reusable UI component library for Limbo.
///
/// Import this single file to access all public components:
/// ```dart
/// import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';
/// ```

library limbo_ui_flutter;

// ── Core ──────────────────────────────────────────────────────────────────────
export 'src/core/limbo_colors.dart';
export 'src/core/limbo_text_styles.dart';
export 'src/core/limbo_validators.dart';
export 'src/core/limbo_configuration.dart';
export 'src/core/limbo_typography.dart';


// ── Button ────────────────────────────────────────────────────────────────────
export 'src/components/button/limbo_button.dart';
export 'src/components/button/limbo_category_button.dart';

// ── Navigation ────────────────────────────────────────────────────────────────
// Exports: LimboTabBar, LimboTabItem
export 'src/components/navigation/limbo_home_tab_bar.dart';

// ── AppBar ────────────────────────────────────────────────────────────────────
export 'src/components/app_bar/limbo_app_bar.dart';

// ── Form ──────────────────────────────────────────────────────────────────────
export 'src/components/form/limbo_form_field.dart';

// ── Category ──────────────────────────────────────────────────────────────────
// Exports: LimboSortOption, LimboOrderWidget
//          LimboFilterColor, LimboFilterSection, LimboFilterWidget, LimboColorFilterGrid
//          LimboCategoryTitle, LimboOptionsTitle, LimboCircleItemGrid
export 'src/components/category/limbo_category_title.dart';
export 'src/components/category/limbo_options_title.dart';
export 'src/components/category/limbo_circle_item_grid.dart';
export 'src/components/category/limbo_filter_widget.dart';
export 'src/components/category/limbo_order_widget.dart';

// ── Item ──────────────────────────────────────────────────────────────────────
export 'src/components/item/limbo_item_card.dart';
export 'src/components/item/limbo_items_grid.dart';

// ── Picker ────────────────────────────────────────────────────────────────────
export 'src/components/picker/limbo_color_picker.dart';

// ── Search ────────────────────────────────────────────────────────────────────
export 'src/components/search/limbo_search_widget.dart';
