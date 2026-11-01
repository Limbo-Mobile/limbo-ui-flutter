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
export 'src/components/button/limbo_category_card.dart';
export 'src/components/button/limbo_back_button.dart';
export 'src/components/button/limbo_category_circle.dart';
export 'src/components/button/limbo_social_button.dart';

// ── Navigation ────────────────────────────────────────────────────────────────
// Exports: LimboTabBar, LimboTabItem
export 'src/components/navigation/limbo_home_tab_bar.dart';
export 'src/components/navigation/limbo_liquid_glass_navigation_bar.dart';

// ── AppBar ────────────────────────────────────────────────────────────────────
export 'src/components/app_bar/limbo_app_bar.dart';
export 'src/components/app_bar/limbo_page_header.dart';

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

// ── Filter ────────────────────────────────────────────────────────────────────
export 'src/components/filter/limbo_segmented_control.dart';

// ── Picker ────────────────────────────────────────────────────────────────────
export 'src/components/picker/limbo_color_picker.dart';

// ── Search ────────────────────────────────────────────────────────────────────
export 'src/components/search/limbo_search_widget.dart';

// ── Premium design tokens & components ────────────────────────────────────────
export 'src/core/limbo_tokens.dart';
export 'src/components/motion/limbo_pressable.dart';
export 'src/components/motion/limbo_reveal.dart';
export 'src/components/feedback/limbo_skeleton.dart';
export 'src/components/feedback/limbo_empty_state.dart';
export 'src/components/feedback/limbo_snack.dart';
export 'src/components/feedback/limbo_sheet.dart';
export 'src/components/feedback/limbo_review_editor.dart';
export 'src/components/list/limbo_menu_tile.dart';
export 'src/components/list/limbo_key_value_row.dart';
export 'src/components/card/limbo_card.dart';
export 'src/components/status/limbo_countdown.dart';
export 'src/components/status/limbo_success_check.dart';
export 'src/components/form/limbo_code_input.dart';
export 'src/components/status/limbo_status_chip.dart';
export 'src/components/status/limbo_timeline.dart';
export 'src/components/misc/limbo_avatar.dart';
export 'src/components/misc/limbo_favorite_button.dart';
export 'src/components/misc/limbo_expandable_tile.dart';
export 'src/components/misc/limbo_rating_stars.dart';
export 'src/components/image/limbo_network_image.dart';
export 'src/components/image/limbo_image_viewer.dart';
export 'src/components/image/limbo_photo_strip.dart';
export 'src/components/image/limbo_photo_thumbs.dart';

// ── API Service Layer ─────────────────────────────────────────────────────────
export 'src/services/api/api_service.dart';
export 'src/services/api/dio_client.dart';
export 'src/services/api/models/api_exception.dart';
export 'src/services/api/models/multipart_file_data.dart';
export 'src/services/api/utils/api_error_handler.dart';
export 'src/services/api/utils/api_logger.dart';
export 'src/services/api/utils/api_response_handler.dart';
export 'src/services/api/interceptors/auth_interceptor.dart';
export 'src/services/api/session/session_refresher.dart';
export 'src/services/api/session/session_store.dart';
export 'src/services/api/interceptors/logging_interceptor.dart';
export 'src/services/api/repositories/http_repository.dart';
export 'src/services/api/repositories/multipart_repository.dart';
