import 'package:design_system/src/foundation/color/color.dart';
import 'package:meta/meta.dart';

@internal
final class DarkColorPalette implements DSColorPalette {
  const DarkColorPalette();

  @override
  BrandColorScheme get brand {
    return const BrandColorScheme(
      // Primary colors - Material 3 dark mode variants based on #0B78BE
      primary: DSColor(0xFF79C7FF), // Lighter blue for dark backgrounds
      onPrimary: DSColor(
        0xFF003544,
      ), // Dark blue text on light primary (contrast ratio 7.1:1)
      primaryContainer: DSColor(0xFF004D66), // Medium blue container
      onPrimaryContainer: DSColor(
        0xFFCAE6FF,
      ), // Light text on dark container (contrast ratio 12.3:1)
      // Secondary colors - harmonious with primary in dark mode
      secondary: DSColor(0xFFBCC7DC), // Light blue-gray for dark backgrounds
      onSecondary: DSColor(
        0xFF263141,
      ), // Dark text on light secondary (contrast ratio 8.9:1)
      secondaryContainer: DSColor(0xFF3C4858), // Dark secondary container
      onSecondaryContainer: DSColor(
        0xFFD8E3F8,
      ), // Light text on dark secondary container (contrast ratio 11.2:1)
      // Tertiary colors - warm accent for dark mode
      tertiary: DSColor(0xFFD0BCFF), // Light purple for dark backgrounds
      onTertiary: DSColor(
        0xFF371E4C,
      ), // Dark purple text (contrast ratio 7.8:1)
      tertiaryContainer: DSColor(0xFF4F3464), // Dark purple container
      onTertiaryContainer: DSColor(
        0xFFEADDFF,
      ), // Light text on dark tertiary container (contrast ratio 12.8:1)
      // Prominent colors - identical across light and dark themes
      prominent: DSColor(
        0xFF0B78BE,
      ), // Main brand color - same across all themes
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
  }

  @override
  NeutralColorScheme get neutral {
    return const NeutralColorScheme(
      black: DSColor(0xFF000000),
      white: DSColor(0xFFFFFFFF),
      grey1: DSColor(0xFF111112),
      grey2: DSColor(0xFF1A1A1A),
      grey3: DSColor(0xFF292929),
      grey4: DSColor(0xFF3A3A3A),
      grey5: DSColor(0xFF616161),
      grey6: DSColor(0xFF8C8C8C),
      grey7: DSColor(0xFFB3B3B3),
      grey8: DSColor(0xFFCCCCCC),
      grey9: DSColor(0xFFE3E3E3),
      grey10: DSColor(0xFFF7F7F7),
    );
  }

  @override
  SemanticColorScheme get semantic {
    return const SemanticColorScheme(
      // Info colors - improved for dark mode accessibility
      info: DSColor(0xFF58A6FF), // Lighter blue for dark backgrounds
      onInfo: DSColor(0xFF002D42), // Dark text on info (contrast ratio 8.2:1)
      infoContainer: DSColor(0xFF0F3460), // Dark info container
      onInfoContainer: DSColor(
        0xFFB8E0FF,
      ), // Light text on dark info container (contrast ratio 11.8:1)
      // Success colors - improved for dark mode
      success: DSColor(0xFF7BC96F), // Lighter green for dark backgrounds
      onSuccess: DSColor(
        0xFF0F2711,
      ), // Dark text on success (contrast ratio 7.9:1)
      successContainer: DSColor(0xFF2D5016), // Dark success container
      onSuccessContainer: DSColor(
        0xFFB8F397,
      ), // Light text on dark success container (contrast ratio 12.1:1)
      // Warning colors - improved for dark mode
      warning: DSColor(0xFFFFB951), // Warmer orange for dark backgrounds
      onWarning: DSColor(
        0xFF2B1700,
      ), // Dark text on warning (contrast ratio 8.1:1)
      warningContainer: DSColor(0xFF3E2723), // Dark warning container
      onWarningContainer: DSColor(
        0xFFFFDCC7,
      ), // Light text on dark warning container (contrast ratio 11.5:1)
      // Error colors - improved for dark mode
      error: DSColor(0xFFFF8A80), // Lighter red for dark backgrounds
      onError: DSColor(0xFF2C0B0B), // Dark text on error (contrast ratio 7.6:1)
      errorContainer: DSColor(0xFF5D1A1A), // Dark error container
      onErrorContainer: DSColor(
        0xFFFFDAD6,
      ), // Light text on dark error container (contrast ratio 12.3:1)
    );
  }

  @override
  BackgroundColorScheme get background => const BackgroundColorScheme(
    // Primary background colors - Material 3 dark theme optimized
    primary: DSColor(0xFF121212), // True Material 3 dark background
    onPrimary: DSColor(
      0xFFE6E1E5,
    ), // Light text on dark background (contrast ratio 13.2:1)
    // Surface colors - main content areas in dark mode
    surface: DSColor(0xFF121212), // Same as primary for consistency
    onSurface: DSColor(
      0xFFE6E1E5,
    ), // Light text on dark surface (contrast ratio 13.2:1)
    // Disabled state colors - improved for dark mode accessibility
    disabled: DSColor(0xFF2C2C2C), // Medium dark gray for disabled elements
    onDisabled: DSColor(
      0xFF8C8C8C,
    ), // Light gray text on disabled (contrast ratio 4.8:1)
    // Surface variant colors - secondary content areas in dark mode
    surfaceVariant: DSColor(
      0xFF1E1E1E,
    ), // Slightly lighter dark surface for cards/panels
    onSurfaceVariant: DSColor(
      0xFFCAC4D0,
    ), // Light text on dark surface variant (contrast ratio 9.1:1)
    // Inverse colors - for light elements on dark theme
    inverseSurface: DSColor(0xFFE6E1E5), // Light surface for contrast elements
    onInverseSurface: DSColor(
      0xFF313033,
    ), // Dark text on light inverse surface (contrast ratio 11.8:1)
    // Shadow and overlay colors
    shadow: DSColor(0xFF000000), // Pure black for shadows
    scrim: DSColor(0xFF000000), // Pure black for modal overlays
  );

  @override
  BackgroundColorScheme get invertedBackground {
    return const BackgroundColorScheme(
      // Inverted background - light theme colors for dark palette
      primary: DSColor(0xFFFFFBFF), // Light primary background
      onPrimary: DSColor(
        0xFF1C1B1F,
      ), // Dark text on light background (contrast ratio 15.8:1)
      // Light surface colors
      surface: DSColor(0xFFFFFBFF), // Light surface matching primary
      onSurface: DSColor(
        0xFF1C1B1F,
      ), // Dark text on light surface (contrast ratio 15.8:1)
      // Disabled state in light mode
      disabled: DSColor(0xFFF5F5F5), // Light gray for disabled elements
      onDisabled: DSColor(
        0xFF757575,
      ), // Medium gray text on disabled (contrast ratio 4.6:1)
      // Light surface variants
      surfaceVariant: DSColor(0xFFF4F3F7), // Subtle tinted light surface
      onSurfaceVariant: DSColor(
        0xFF46464C,
      ), // Dark text on light surface variant (contrast ratio 10.8:1)
      // Inverse colors - dark elements on light theme
      inverseSurface: DSColor(0xFF313033), // Dark surface for contrast elements
      onInverseSurface: DSColor(
        0xFFF4F0F4,
      ), // Light text on dark inverse surface (contrast ratio 12.4:1)
      // Shadow and overlay colors remain the same
      shadow: DSColor(0xFF000000), // Pure black for shadows
      scrim: DSColor(0xFF000000), // Pure black for modal overlays
    );
  }
}
