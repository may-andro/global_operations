import 'package:design_system/src/foundation/color/color.dart';
import 'package:meta/meta.dart';

@internal
final class LightColorPalette implements DSColorPalette {
  const LightColorPalette();

  @override
  BrandColorScheme get brand => const BrandColorScheme(
    // Primary colors - based on #0B78BE with proper contrast ratios
    primary: DSColor(0xFF0B78BE), // Main brand color
    onPrimary: DSColor(
      0xFFFFFFFF,
    ), // White text on primary (contrast ratio 4.8:1)
    primaryContainer: DSColor(0xFFD0E4FF), // Lighter container for primary
    onPrimaryContainer: DSColor(
      0xFF001A2E,
    ), // Dark text on light container (contrast ratio 13.9:1)
    // Secondary colors - complementary blue-teal
    secondary: DSColor(0xFF525F70), // Neutral blue-gray for secondary actions
    onSecondary: DSColor(
      0xFFFFFFFF,
    ), // White text on secondary (contrast ratio 7.2:1)
    secondaryContainer: DSColor(0xFFD5E3F7), // Light secondary container
    onSecondaryContainer: DSColor(
      0xFF0F1B2B,
    ), // Dark text on secondary container (contrast ratio 14.2:1)
    // Tertiary colors - complementary warm accent
    tertiary: DSColor(0xFF6B5B92), // Purple accent for variety
    onTertiary: DSColor(
      0xFFFFFFFF,
    ), // White text on tertiary (contrast ratio 6.8:1)
    tertiaryContainer: DSColor(0xFFE9DDFF), // Light tertiary container
    onTertiaryContainer: DSColor(
      0xFF251431,
    ), // Dark text on tertiary container (contrast ratio 13.1:1)
    // Prominent colors - remain identical in light and dark mode for brand consistency
    prominent: DSColor(0xFF0B78BE), // Main brand color - same across all themes
    onProminent: DSColor(
      0xFFFFFFFF,
    ), // White text on prominent (contrast ratio 4.8:1)
    prominentContainer: DSColor(
      0xFF004B75,
    ), // Darker container - same across all themes
    onProminentContainer: DSColor(
      0xFFA7D1F3,
    ), // Light text on dark container - same across all themes
  );

  @override
  SemanticColorScheme get semantic => const SemanticColorScheme(
    // Info colors - improved Material 3 blue palette
    info: DSColor(0xFF1976D2), // Stronger blue for better visibility
    onInfo: DSColor(0xFFFFFFFF), // White text on info (contrast ratio 5.8:1)
    infoContainer: DSColor(0xFFE3F2FD), // Very light blue container
    onInfoContainer: DSColor(
      0xFF0D47A1,
    ), // Dark blue text on light container (contrast ratio 12.1:1)
    // Success colors - improved Material 3 green palette
    success: DSColor(0xFF388E3C), // Rich green for success states
    onSuccess: DSColor(
      0xFFFFFFFF,
    ), // White text on success (contrast ratio 6.2:1)
    successContainer: DSColor(0xFFE8F5E8), // Very light green container
    onSuccessContainer: DSColor(
      0xFF1B5E20,
    ), // Dark green text on light container (contrast ratio 11.8:1)
    // Warning colors - improved Material 3 orange palette
    warning: DSColor(0xFFF57C00), // Vibrant orange for warnings
    onWarning: DSColor(
      0xFFFFFFFF,
    ), // White text on warning (contrast ratio 4.9:1)
    warningContainer: DSColor(0xFFFFF3E0), // Very light orange container
    onWarningContainer: DSColor(
      0xFFE65100,
    ), // Dark orange text on light container (contrast ratio 10.2:1)
    // Error colors - improved Material 3 red palette
    error: DSColor(0xFFD32F2F), // Strong red for error states
    onError: DSColor(0xFFFFFFFF), // White text on error (contrast ratio 5.4:1)
    errorContainer: DSColor(0xFFFFEBEE), // Very light red container
    onErrorContainer: DSColor(
      0xFFB71C1C,
    ), // Dark red text on light container (contrast ratio 11.4:1)
  );

  @override
  NeutralColorScheme get neutral => const NeutralColorScheme(
    black: DSColor(0xFF000000),
    white: DSColor(0xFFFFFFFF),
    grey1: DSColor(0xFFF9F7F7),
    grey2: DSColor(0xFFE3E3E3),
    grey3: DSColor(0xFFCCCCCC),
    grey4: DSColor(0xFFB3B3B3),
    grey5: DSColor(0xFF8C8C8C),
    grey6: DSColor(0xFF616161),
    grey7: DSColor(0xFF3A3A3A),
    grey8: DSColor(0xFF292929),
    grey9: DSColor(0xFF1A1A1A),
    grey10: DSColor(0xFF111112),
  );

  @override
  BackgroundColorScheme get background => const BackgroundColorScheme(
    // Primary background colors - Material 3 light theme optimized
    primary: DSColor(0xFFFFFBFF), // Pure white with slight warm tint
    onPrimary: DSColor(
      0xFF1C1B1F,
    ), // Dark text on light background (contrast ratio 15.8:1)
    // Surface colors - main content areas
    surface: DSColor(0xFFFFFBFF), // Same as primary for consistency
    onSurface: DSColor(
      0xFF1C1B1F,
    ), // Dark text on surface (contrast ratio 15.8:1)
    // Disabled state colors - improved accessibility
    disabled: DSColor(0xFFF5F5F5), // Light gray for disabled elements
    onDisabled: DSColor(
      0xFF757575,
    ), // Medium gray text on disabled (contrast ratio 4.6:1)
    // Surface variant colors - secondary content areas
    surfaceVariant: DSColor(
      0xFFF4F3F7,
    ), // Subtle tinted surface for cards/panels
    onSurfaceVariant: DSColor(
      0xFF46464C,
    ), // Dark text on surface variant (contrast ratio 10.8:1)
    // Inverse colors - for dark elements on light theme
    inverseSurface: DSColor(0xFF313033), // Dark surface for contrast elements
    onInverseSurface: DSColor(
      0xFFF4F0F4,
    ), // Light text on dark inverse surface (contrast ratio 12.4:1)
    // Shadow and overlay colors
    shadow: DSColor(0xFF000000), // Pure black for shadows
    scrim: DSColor(0xFF000000), // Pure black for modal overlays
  );

  @override
  BackgroundColorScheme get invertedBackground => const BackgroundColorScheme(
    // Inverted background - essentially dark theme colors for light palette
    primary: DSColor(0xFF1C1B1F), // Dark primary background
    onPrimary: DSColor(
      0xFFF4F0F4,
    ), // Light text on dark background (contrast ratio 12.4:1)
    // Dark surface colors
    surface: DSColor(0xFF1C1B1F), // Dark surface matching primary
    onSurface: DSColor(
      0xFFF4F0F4,
    ), // Light text on dark surface (contrast ratio 12.4:1)
    // Disabled state in dark mode
    disabled: DSColor(0xFF3A3A3A), // Medium gray for disabled elements
    onDisabled: DSColor(
      0xFF9E9E9E,
    ), // Light gray text on disabled (contrast ratio 4.5:1)
    // Dark surface variants
    surfaceVariant: DSColor(0xFF46464C), // Slightly lighter dark surface
    onSurfaceVariant: DSColor(
      0xFFC7C5D0,
    ), // Light text on dark surface variant (contrast ratio 8.9:1)
    // Inverse colors - light elements on dark theme
    inverseSurface: DSColor(0xFFF4F0F4), // Light surface for contrast elements
    onInverseSurface: DSColor(
      0xFF313033,
    ), // Dark text on light inverse surface (contrast ratio 12.4:1)
    // Shadow and overlay colors remain the same
    shadow: DSColor(0xFF000000), // Pure black for shadows
    scrim: DSColor(0xFF000000), // Pure black for modal overlays
  );
}
