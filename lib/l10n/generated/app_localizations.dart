import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Label for section where user can add extra notes about the advertising panel
  ///
  /// In en, this message translates to:
  /// **'Additional comments'**
  String get adPanelAdditionalComments;

  /// Label for camera section associated with an advertising panel
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get adPanelCamera;

  /// Checkbox option to report an advertisement issue
  ///
  /// In en, this message translates to:
  /// **'Advertisement issue'**
  String get adPanelCheckboxObjectAdvertisementIssue;

  /// Checkbox option to report a campaign issue
  ///
  /// In en, this message translates to:
  /// **'Campaign issue'**
  String get adPanelCheckboxObjectCampaignIssue;

  /// Checkbox option to report a damage issue
  ///
  /// In en, this message translates to:
  /// **'Damage issue'**
  String get adPanelCheckboxObjectDamageIssue;

  /// Checkbox option to report a cleaning issue
  ///
  /// In en, this message translates to:
  /// **'Cleaning issue'**
  String get adPanelCheckboxObjectCleanIssue;

  /// Checkbox option to report a poster issue
  ///
  /// In en, this message translates to:
  /// **'Poster issue'**
  String get adPanelCheckboxObjectPosterIssue;

  /// Checkbox option to report a lighting issue
  ///
  /// In en, this message translates to:
  /// **'Lighting issue'**
  String get adPanelCheckboxObjectLighteningIssue;

  /// Checkbox option to report a maintenance issue
  ///
  /// In en, this message translates to:
  /// **'Maintenance issue'**
  String get adPanelCheckboxObjectMaintenanceIssue;

  /// Hint text for optional comment field
  ///
  /// In en, this message translates to:
  /// **'Add comment [optional]'**
  String get adPanelCommentHint;

  /// Label showing how far the ad panel is from the user
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String adPanelDistanceAway(double distance);

  /// Message shown when no advertising panels exist
  ///
  /// In en, this message translates to:
  /// **'There are currently no advertising panels available.'**
  String get adPanelEmptyDescription;

  /// Title shown when there are no advertising panels
  ///
  /// In en, this message translates to:
  /// **'No advertising panel'**
  String get adPanelEmptyTitle;

  /// Title shown for generic error state
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get adPanelErrorTitle;

  /// Label showing the side number of an advertising panel
  ///
  /// In en, this message translates to:
  /// **'Side: {faceNumber}'**
  String adPanelFaceLabel(int faceNumber);

  /// Shows number of sides an advertising panel has
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sides} =1{1 side} other{{count} sides}}'**
  String adPanelFaceCount(int count);

  /// Section title for sides and campaigns
  ///
  /// In en, this message translates to:
  /// **'Sides & Campaigns'**
  String get adPanelFacesAndCampaigns;

  /// Label for gallery section
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get adPanelGallery;

  /// Label for images section
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get adPanelImages;

  /// Message shown when multiple advertising panels are found at a location
  ///
  /// In en, this message translates to:
  /// **'{count} advertising panels found at this location'**
  String adPanelMultiplePanelsFound(int count);

  /// Button text to clear filters when no results are found
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get adPanelNoResultClearFilters;

  /// Message suggesting adjustments when no results are found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get adPanelNoResultDescription;

  /// Title shown when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get adPanelNoResultTitle;

  /// Subtitle guiding users to view advertising panels
  ///
  /// In en, this message translates to:
  /// **'Click to view the advertising panels'**
  String get adPanelPanelSubtitle;

  /// Title showing advertising panel with unique key
  ///
  /// In en, this message translates to:
  /// **'Advertising panel: {panelKey}'**
  String adPanelPanelTitle(String panelKey);

  /// Button label to refresh advertising panels
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adPanelRefresh;

  /// Shows currently running campaign on the panel
  ///
  /// In en, this message translates to:
  /// **'Running campaign: {campaign}'**
  String adPanelRunningCampaign(String campaign);

  /// Hint text for search input
  ///
  /// In en, this message translates to:
  /// **'Search advertising panels...'**
  String get adPanelSearchHint;

  /// Label showing search radius in kilometers
  ///
  /// In en, this message translates to:
  /// **'{radius} km'**
  String adPanelSearchRadiusLabel(String radius);

  /// Message showing number of advertising panels found
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No advertising panels found} =1{1 advertising panel found} other{{count} advertising panels found}}'**
  String adPanelSearchResultCount(int count);

  /// Message showing number of advertising panels found within a radius
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No advertising panels found within {radius} km} =1{1 advertising panel found within {radius} km} other{{count} advertising panels found within {radius} km}}'**
  String adPanelSearchResultCountWithRadius(int count, String radius);

  /// Button label to view advertising panel details
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get adPanelSeeDetails;

  /// Prompt to select image source
  ///
  /// In en, this message translates to:
  /// **'Select an image source'**
  String get adPanelSelectImageSource;

  /// Tooltip for switching to list view
  ///
  /// In en, this message translates to:
  /// **'Show list view'**
  String get adPanelShowListViewTooltip;

  /// Tooltip for switching to map view
  ///
  /// In en, this message translates to:
  /// **'Show map view'**
  String get adPanelShowMapViewTooltip;

  /// Tooltip for sort options
  ///
  /// In en, this message translates to:
  /// **'Sort options'**
  String get adPanelSortTooltip;

  /// Subtitle for sorting option by distance
  ///
  /// In en, this message translates to:
  /// **'Sort by distance from your current location'**
  String get adPanelSortDistanceSubtitle;

  /// Title for sorting option by distance
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get adPanelSortDistanceTitle;

  /// Subtitle for sorting option by recently edited panels
  ///
  /// In en, this message translates to:
  /// **'Sort by recently edited panels'**
  String get adPanelSortEditedSubtitle;

  /// Title for sorting option by recently edited panels
  ///
  /// In en, this message translates to:
  /// **'Recently edited'**
  String get adPanelSortEditedTitle;

  /// Subtitle for sorting option by object number
  ///
  /// In en, this message translates to:
  /// **'Sort by object number in ascending order'**
  String get adPanelSortObjectNumberSubtitle;

  /// Title for sorting option by object number
  ///
  /// In en, this message translates to:
  /// **'Object number'**
  String get adPanelSortObjectNumberTitle;

  /// Subtitle for sorting option by street name
  ///
  /// In en, this message translates to:
  /// **'Sort by street name in alphabetical order'**
  String get adPanelSortStreetSubtitle;

  /// Title for sorting option by street name
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get adPanelSortStreetTitle;

  /// Label for sorting options section
  ///
  /// In en, this message translates to:
  /// **'Sort options'**
  String get adPanelSortingOptions;

  /// Tooltip for submitting updates to ad panels
  ///
  /// In en, this message translates to:
  /// **'Submit changes'**
  String get adPanelSubmitUpdateTooltip;

  /// Success message shown after ad panel updates
  ///
  /// In en, this message translates to:
  /// **'Your changes have been successfully updated'**
  String get adPanelUpdateSuccess;

  /// Displays the current app version
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// Name of the company
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get companyName;

  /// Copyright notice text
  ///
  /// In en, this message translates to:
  /// **'© 2025 Global Ops. All rights reserved.'**
  String get copyright;

  /// Label prompting user to select a language
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get localeSelectLanguage;

  /// Button text to allow location access
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get locationPermissionAllow;

  /// Message shown when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'This feature requires location access. Please grant permission.'**
  String get locationPermissionDeniedDescription;

  /// Title when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Location permission needed'**
  String get locationPermissionDeniedTitle;

  /// Error message when permission status cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Could not retrieve permission status'**
  String get locationPermissionFailure;

  /// Message when limited location access is granted
  ///
  /// In en, this message translates to:
  /// **'You have granted limited location access. Some features may not work as expected.'**
  String get locationPermissionLimitedDescription;

  /// Title for limited location access
  ///
  /// In en, this message translates to:
  /// **'Limited location access'**
  String get locationPermissionLimitedTitle;

  /// Button text to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get locationPermissionOpenSettings;

  /// Message when location permission is permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permission has been permanently denied. Please open settings to allow it.'**
  String get locationPermissionPermanentlyDeniedDescription;

  /// Title when location permission is permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get locationPermissionPermanentlyDeniedTitle;

  /// Message for provisional location access
  ///
  /// In en, this message translates to:
  /// **'You have provisional location access. Confirm to grant full access.'**
  String get locationPermissionProvisionalDescription;

  /// Title for provisional location access
  ///
  /// In en, this message translates to:
  /// **'Provisional location access'**
  String get locationPermissionProvisionalTitle;

  /// Message when location access is restricted
  ///
  /// In en, this message translates to:
  /// **'Location access is restricted on this device or by parental controls.'**
  String get locationPermissionRestrictedDescription;

  /// Title when location access is restricted
  ///
  /// In en, this message translates to:
  /// **'Location restricted'**
  String get locationPermissionRestrictedTitle;

  /// Label for a negative response option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Label for a positive response option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Button text to navigate back to home when route not found
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get routeNotFoundButton;

  /// Message shown when a page/route cannot be found
  ///
  /// In en, this message translates to:
  /// **'Oops! The page you are looking for\\nis not found.'**
  String get routeNotFoundMessage;

  /// Title shown when a page/route cannot be found
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get routeNotFoundTitle;

  /// Setting option to select application language
  ///
  /// In en, this message translates to:
  /// **'Application language'**
  String get settingAppLanguage;

  /// Setting option to change password
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingChangePassword;

  /// Label showing current logged-in user
  ///
  /// In en, this message translates to:
  /// **'Current user'**
  String get settingCurrentUser;

  /// Setting option to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingDeleteAccount;

  /// Title for delete account confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete account confirmation'**
  String get settingDeleteAccountConfirmation;

  /// Prompt warning about irreversible account deletion
  ///
  /// In en, this message translates to:
  /// **'Account deletion is irreversible. Are you sure you want to delete your account?'**
  String get settingDeleteAccountConfirmationPrompt;

  /// Title for language settings section
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguageSectionTitle;

  /// Toggle setting for location-based search
  ///
  /// In en, this message translates to:
  /// **'Location-based search'**
  String get settingLocationBasedSearch;

  /// Description of location-based search feature
  ///
  /// In en, this message translates to:
  /// **'Enable this feature to find advertising panels within a selected radius from your current location.'**
  String get settingLocationBasedSearchDescription;

  /// Setting option to log out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingLogout;

  /// Title for logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Logout confirmation'**
  String get settingLogoutConfirmation;

  /// Prompt asking the user to confirm logout
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get settingLogoutConfirmationPrompt;

  /// Title for search criteria settings section
  ///
  /// In en, this message translates to:
  /// **'Search criteria'**
  String get settingSearchCriteriaSectionTitle;

  /// Title for user management settings section
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get settingUserManagementSectionTitle;

  /// Label for contacting support in splash error
  ///
  /// In en, this message translates to:
  /// **'contact support'**
  String get splashContactSupport;

  /// Error message shown on splash screen when setup fails
  ///
  /// In en, this message translates to:
  /// **'Restart the app again or try later. If the problem persists'**
  String get splashErrorMessage;

  /// Title for error on splash screen
  ///
  /// In en, this message translates to:
  /// **'We encountered a problem during setup 😵‍💫💻'**
  String get splashErrorTitle;

  /// Message shown during production setup on splash screen
  ///
  /// In en, this message translates to:
  /// **'Warming up the engine...'**
  String get splashProdMessage;

  /// Message shown when staging setup completes
  ///
  /// In en, this message translates to:
  /// **'Setup is complete 🚀'**
  String get splashStagingDoneMessage;

  /// Message shown during dependency retrieval in staging
  ///
  /// In en, this message translates to:
  /// **'Retrieving all dependencies 🎯'**
  String get splashStagingPostRegisterMessage;

  /// Message shown when services are registering in staging
  ///
  /// In en, this message translates to:
  /// **'Registering the services ⬇️'**
  String get splashStagingRegisteringMessage;

  /// Message shown at the start of staging setup
  ///
  /// In en, this message translates to:
  /// **'Warming up the app 🔥'**
  String get splashStagingStartMessage;

  /// Error message when network connection fails
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again'**
  String get errorNetworkConnection;

  /// Error message when uploaded image exceeds size limit
  ///
  /// In en, this message translates to:
  /// **'Image file is too large. Maximum size is 10MB'**
  String get errorImageSizeExceeded;

  /// Message shown when a file upload is cancelled
  ///
  /// In en, this message translates to:
  /// **'Upload was cancelled'**
  String get errorUploadCancelled;

  /// Message shown when user tries an action without proper permissions
  ///
  /// In en, this message translates to:
  /// **'Access denied. Check your account settings'**
  String get errorPermissionDenied;

  /// Message shown when user selects an invalid file
  ///
  /// In en, this message translates to:
  /// **'Invalid file. Select a valid file'**
  String get errorInvalidFile;

  /// Error message when cloud storage service fails
  ///
  /// In en, this message translates to:
  /// **'Storage service error. Try again later'**
  String get errorStorageService;

  /// Error message when an unknown issue occurs during file upload
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during upload'**
  String get errorUploadUnknown;

  /// Message shown when validation fails on user input
  ///
  /// In en, this message translates to:
  /// **'Check the data and try again'**
  String get errorValidationFailed;

  /// Message when server is down or unavailable
  ///
  /// In en, this message translates to:
  /// **'Server is temporarily unavailable. Try again later'**
  String get errorServerUnavailable;

  /// Message shown when user session has expired
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again'**
  String get errorSessionExpired;

  /// Message shown when app update fails unexpectedly
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during update'**
  String get errorUpdateFailed;

  /// Generic unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String errorUnexpected(String error);

  /// Message shown when user tries to update ad panels without permission
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to update these panels'**
  String get errorAdPanelUpdatePermissionDenied;

  /// Message shown when locale settings cannot be read from storage
  ///
  /// In en, this message translates to:
  /// **'Storage error: Unable to read locale settings'**
  String get errorLocaleStorageFailure;

  /// Message shown when locale data fails validation
  ///
  /// In en, this message translates to:
  /// **'Invalid locale data detected'**
  String get errorLocaleValidationFailure;

  /// Message shown when no locale is set
  ///
  /// In en, this message translates to:
  /// **'No locale preference found, using default settings'**
  String get errorLocaleNotFound;

  /// Message shown when loading locale settings fails unexpectedly
  ///
  /// In en, this message translates to:
  /// **'Unexpected error while loading locale settings'**
  String get errorLocaleLoadUnknown;

  /// Message shown when saving locale settings fails
  ///
  /// In en, this message translates to:
  /// **'Unable to save locale settings'**
  String get errorLocaleCacheFailure;

  /// Message when updating app services fails
  ///
  /// In en, this message translates to:
  /// **'Unable to update application services. Please restart the app'**
  String get errorLocaleServiceLocatorFailure;

  /// Message shown when setting intl configuration fails
  ///
  /// In en, this message translates to:
  /// **'Unable to set internationalization settings'**
  String get errorLocaleIntlFailure;

  /// Message shown when locale changes but notification fails
  ///
  /// In en, this message translates to:
  /// **'Locale updated but notification failed'**
  String get errorLocaleStreamFailure;

  /// Message shown when locale update has invalid format
  ///
  /// In en, this message translates to:
  /// **'Invalid locale format provided'**
  String get errorLocaleUpdateValidationFailure;

  /// Message shown when locale update fails unexpectedly
  ///
  /// In en, this message translates to:
  /// **'Unexpected error while updating locale'**
  String get errorLocaleUpdateUnknown;

  /// Message shown when an action requires login
  ///
  /// In en, this message translates to:
  /// **'User is not signed in. Please log in to continue'**
  String get errorUserNotSignedIn;

  /// Message shown when user enters wrong password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again'**
  String get errorWrongPassword;

  /// Message shown when user needs to re-login due to security requirements
  ///
  /// In en, this message translates to:
  /// **'Recent login required. Please sign in again to continue'**
  String get errorRecentLoginRequired;

  /// Generic network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again'**
  String get errorNetwork;

  /// Message shown when API request limit is exceeded
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait and try again later'**
  String get errorTooManyRequests;

  /// Message shown when login credentials are invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials provided'**
  String get errorInvalidCredential;

  /// Message shown when user account is disabled
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Contact support for assistance'**
  String get errorUserDisabled;

  /// Message shown when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get errorMissingEmail;

  /// Message shown when authentication state is invalid
  ///
  /// In en, this message translates to:
  /// **'Authentication state error. Please try logging in again'**
  String get errorAuthState;

  /// Title for delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// Subtitle warning for account deletion
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. Once you delete your account, all your data will be permanently removed.'**
  String get deleteAccountSubtitle;

  /// Message shown after account deletion succeeds
  ///
  /// In en, this message translates to:
  /// **'You have successfully deleted your account.'**
  String get deleteAccountSuccess;

  /// Generic submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Title for update password screen
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordTitle;

  /// Instructions for updating password
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password which must be at least 6 characters long and at most 12 characters long.'**
  String get updatePasswordSubtitle;

  /// Message shown when password update succeeds
  ///
  /// In en, this message translates to:
  /// **'You have successfully updated your password.'**
  String get updatePasswordSuccess;

  /// Label for current password input
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// Label for new password input
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Message shown when password strength is insufficient
  ///
  /// In en, this message translates to:
  /// **'New password is too weak. Please choose a stronger password'**
  String get errorWeakPassword;

  /// Generic close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Generic retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title shown while ad panel update is in progress
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get adPanelUpdatingTitle;

  /// Message shown while updating ad panels
  ///
  /// In en, this message translates to:
  /// **'Please wait while we process your request'**
  String get adPanelUpdatingDescription;

  /// Title shown while images are being compressed
  ///
  /// In en, this message translates to:
  /// **'Compressing Images'**
  String get adPanelCompressingImagesTitle;

  /// Message shown when compressing multiple images
  ///
  /// In en, this message translates to:
  /// **'Please wait, your ({currentFileIndex}/{totalFiles}) image file is being prepared for upload'**
  String adPanelCompressingImagesDescription(
    int currentFileIndex,
    int totalFiles,
  );

  /// Title shown while images are being uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploading Images...'**
  String get adPanelUploadingImagesTitle;

  /// Message shown when uploading multiple images
  ///
  /// In en, this message translates to:
  /// **'Please wait, your ({currentFileIndex}/{totalFiles}) image file is being uploaded'**
  String adPanelUploadingImagesDescription(
    int currentFileIndex,
    int totalFiles,
  );

  /// Title shown while ad panels are being updated
  ///
  /// In en, this message translates to:
  /// **'Updating panels...'**
  String get adPanelUpdatingPanelsTitle;

  /// Message shown while updating ad panels
  ///
  /// In en, this message translates to:
  /// **'Please wait while we update your ad panels'**
  String get adPanelUpdatingPanelsDescription;

  /// Warning message when images are being compressed and user tries to exit.
  ///
  /// In en, this message translates to:
  /// **'Images are being compressed. Please wait until the process is complete.'**
  String get adPanelUpdateExistWarningCompressingImages;

  /// Warning message when images are being uploaded and user tries to exit.
  ///
  /// In en, this message translates to:
  /// **'Images are being uploaded. Please wait until the process is complete.'**
  String get adPanelUpdateExistWarningUploadingImages;

  /// Warning message when panels are being updated and user tries to exit.
  ///
  /// In en, this message translates to:
  /// **'Ad Panels are being updated. Please wait until the process is complete.'**
  String get adPanelUpdateExistWarningUpdatingPanels;

  /// Warning message shown when user tries to exit while having unsaved changes
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave without saving?'**
  String get adPanelUpdateExistWarningUnsavedChanges;

  /// Warning title shown when user tries to exit while having unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get adPanelUpdateExistWarningTitleUnsavedChanges;

  /// Warning title shown when user tries to exit while having unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get adPanelUpdateProcessingWarningTitleUnsavedChanges;

  /// Warning title shown when user tries to add an image that exceeds the maximum allowed size
  ///
  /// In en, this message translates to:
  /// **'Only 3 photos are allowed'**
  String get adPanelAllowedImageMaxLengthTitle;

  /// Warning message shown when user tries to add an image that exceeds the maximum allowed size
  ///
  /// In en, this message translates to:
  /// **'You can add more photos by removing existing ones.'**
  String get adPanelAllowedImageMaxLengthMessage;

  /// Title shown when image update fails for ad panels
  ///
  /// In en, this message translates to:
  /// **'Upload Failure'**
  String get adPanelImageUpdateFailureTitle;

  /// Message shown when image update fails for ad panels
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All files} =1{1 file} other{{count} failed to upload. Please try uploading the failed files again.}}'**
  String adPanelImageUpdateFailureMessage(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
