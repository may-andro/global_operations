// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get adPanelAdditionalComments => 'Additional comments';

  @override
  String get adPanelCamera => 'Camera';

  @override
  String get adPanelCheckboxObjectAdvertisementIssue => 'Advertisement issue';

  @override
  String get adPanelCheckboxObjectCampaignIssue => 'Campaign issue';

  @override
  String get adPanelCheckboxObjectDamageIssue => 'Damage issue';

  @override
  String get adPanelCheckboxObjectCleanIssue => 'Cleaning issue';

  @override
  String get adPanelCheckboxObjectPosterIssue => 'Poster issue';

  @override
  String get adPanelCheckboxObjectLighteningIssue => 'Lighting issue';

  @override
  String get adPanelCheckboxObjectMaintenanceIssue => 'Maintenance issue';

  @override
  String get adPanelCommentHint => 'Add comment [optional]';

  @override
  String adPanelDistanceAway(double distance) {
    return '$distance km away';
  }

  @override
  String get adPanelEmptyDescription =>
      'There are currently no advertising panels available.';

  @override
  String get adPanelEmptyTitle => 'No advertising panel';

  @override
  String get adPanelErrorTitle => 'Something went wrong';

  @override
  String adPanelFaceLabel(int faceNumber) {
    return 'Side: $faceNumber';
  }

  @override
  String adPanelFaceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sides',
      one: '1 side',
      zero: 'No sides',
    );
    return '$_temp0';
  }

  @override
  String get adPanelFacesAndCampaigns => 'Sides & Campaigns';

  @override
  String get adPanelGallery => 'Gallery';

  @override
  String get adPanelImages => 'Images';

  @override
  String adPanelMultiplePanelsFound(int count) {
    return '$count advertising panels found at this location';
  }

  @override
  String get adPanelNoResultClearFilters => 'Clear filters';

  @override
  String get adPanelNoResultDescription =>
      'Try adjusting your search or filters';

  @override
  String get adPanelNoResultTitle => 'No results found';

  @override
  String get adPanelPanelSubtitle => 'Click to view the advertising panels';

  @override
  String adPanelPanelTitle(String panelKey) {
    return 'Advertising panel: $panelKey';
  }

  @override
  String get adPanelRefresh => 'Refresh';

  @override
  String adPanelRunningCampaign(String campaign) {
    return 'Running campaign: $campaign';
  }

  @override
  String get adPanelSearchHint => 'Search advertising panels...';

  @override
  String adPanelSearchRadiusLabel(String radius) {
    return '$radius km';
  }

  @override
  String adPanelSearchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count advertising panels found',
      one: '1 advertising panel found',
      zero: 'No advertising panels found',
    );
    return '$_temp0';
  }

  @override
  String adPanelSearchResultCountWithRadius(int count, String radius) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count advertising panels found within $radius km',
      one: '1 advertising panel found within $radius km',
      zero: 'No advertising panels found within $radius km',
    );
    return '$_temp0';
  }

  @override
  String get adPanelSeeDetails => 'View details';

  @override
  String get adPanelSelectImageSource => 'Select an image source';

  @override
  String get adPanelShowListViewTooltip => 'Show list view';

  @override
  String get adPanelShowMapViewTooltip => 'Show map view';

  @override
  String get adPanelSortTooltip => 'Sort options';

  @override
  String get adPanelSortDistanceSubtitle =>
      'Sort by distance from your current location';

  @override
  String get adPanelSortDistanceTitle => 'Distance';

  @override
  String get adPanelSortEditedSubtitle => 'Sort by recently edited panels';

  @override
  String get adPanelSortEditedTitle => 'Recently edited';

  @override
  String get adPanelSortObjectNumberSubtitle =>
      'Sort by object number in ascending order';

  @override
  String get adPanelSortObjectNumberTitle => 'Object number';

  @override
  String get adPanelSortStreetSubtitle =>
      'Sort by street name in alphabetical order';

  @override
  String get adPanelSortStreetTitle => 'Street';

  @override
  String get adPanelSortingOptions => 'Sort options';

  @override
  String get adPanelSubmitUpdateTooltip => 'Submit changes';

  @override
  String get adPanelUpdateSuccess =>
      'Your changes have been successfully updated';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get companyName => 'Global';

  @override
  String get copyright => '© 2025 Global Ops. All rights reserved.';

  @override
  String get localeSelectLanguage => 'Choose your language';

  @override
  String get locationPermissionAllow => 'Allow location';

  @override
  String get locationPermissionDeniedDescription =>
      'This feature requires location access. Please grant permission.';

  @override
  String get locationPermissionDeniedTitle => 'Location permission needed';

  @override
  String get locationPermissionFailure =>
      'Could not retrieve permission status';

  @override
  String get locationPermissionLimitedDescription =>
      'You have granted limited location access. Some features may not work as expected.';

  @override
  String get locationPermissionLimitedTitle => 'Limited location access';

  @override
  String get locationPermissionOpenSettings => 'Open app settings';

  @override
  String get locationPermissionPermanentlyDeniedDescription =>
      'Location permission has been permanently denied. Please open settings to allow it.';

  @override
  String get locationPermissionPermanentlyDeniedTitle =>
      'Location permission required';

  @override
  String get locationPermissionProvisionalDescription =>
      'You have provisional location access. Confirm to grant full access.';

  @override
  String get locationPermissionProvisionalTitle =>
      'Provisional location access';

  @override
  String get locationPermissionRestrictedDescription =>
      'Location access is restricted on this device or by parental controls.';

  @override
  String get locationPermissionRestrictedTitle => 'Location restricted';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get routeNotFoundButton => 'Go to Home';

  @override
  String get routeNotFoundMessage =>
      'Oops! The page you are looking for\\nis not found.';

  @override
  String get routeNotFoundTitle => 'Page Not Found';

  @override
  String get settingAppLanguage => 'Application language';

  @override
  String get settingChangePassword => 'Change password';

  @override
  String get settingCurrentUser => 'Current user';

  @override
  String get settingDeleteAccount => 'Delete account';

  @override
  String get settingDeleteAccountConfirmation => 'Delete account confirmation';

  @override
  String get settingDeleteAccountConfirmationPrompt =>
      'Account deletion is irreversible. Are you sure you want to delete your account?';

  @override
  String get settingLanguageSectionTitle => 'Language';

  @override
  String get settingLocationBasedSearch => 'Location-based search';

  @override
  String get settingLocationBasedSearchDescription =>
      'Enable this feature to find advertising panels within a selected radius from your current location.';

  @override
  String get settingLogout => 'Logout';

  @override
  String get settingLogoutConfirmation => 'Logout confirmation';

  @override
  String get settingLogoutConfirmationPrompt => 'Do you want to logout?';

  @override
  String get settingSearchCriteriaSectionTitle => 'Search criteria';

  @override
  String get settingUserManagementSectionTitle => 'User management';

  @override
  String get splashContactSupport => 'contact support';

  @override
  String get splashErrorMessage =>
      'Restart the app again or try later. If the problem persists';

  @override
  String get splashErrorTitle =>
      'We encountered a problem during setup 😵‍💫💻';

  @override
  String get splashProdMessage => 'Warming up the engine...';

  @override
  String get splashStagingDoneMessage => 'Setup is complete 🚀';

  @override
  String get splashStagingPostRegisterMessage =>
      'Retrieving all dependencies 🎯';

  @override
  String get splashStagingRegisteringMessage => 'Registering the services ⬇️';

  @override
  String get splashStagingStartMessage => 'Warming up the app 🔥';

  @override
  String get errorNetworkConnection =>
      'Check your internet connection and try again';

  @override
  String get errorImageSizeExceeded =>
      'Image file is too large. Maximum size is 10MB';

  @override
  String get errorUploadCancelled => 'Upload was cancelled';

  @override
  String get errorPermissionDenied =>
      'Access denied. Check your account settings';

  @override
  String get errorInvalidFile => 'Invalid file. Select a valid file';

  @override
  String get errorStorageService => 'Storage service error. Try again later';

  @override
  String get errorUploadUnknown => 'An unexpected error occurred during upload';

  @override
  String get errorValidationFailed => 'Check the data and try again';

  @override
  String get errorServerUnavailable =>
      'Server is temporarily unavailable. Try again later';

  @override
  String get errorSessionExpired => 'Session expired. Please log in again';

  @override
  String get errorUpdateFailed => 'An unexpected error occurred during update';

  @override
  String errorUnexpected(String error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String get errorAdPanelUpdatePermissionDenied =>
      'You do not have permission to update these panels';

  @override
  String get errorLocaleStorageFailure =>
      'Storage error: Unable to read locale settings';

  @override
  String get errorLocaleValidationFailure => 'Invalid locale data detected';

  @override
  String get errorLocaleNotFound =>
      'No locale preference found, using default settings';

  @override
  String get errorLocaleLoadUnknown =>
      'Unexpected error while loading locale settings';

  @override
  String get errorLocaleCacheFailure => 'Unable to save locale settings';

  @override
  String get errorLocaleServiceLocatorFailure =>
      'Unable to update application services. Please restart the app';

  @override
  String get errorLocaleIntlFailure =>
      'Unable to set internationalization settings';

  @override
  String get errorLocaleStreamFailure =>
      'Locale updated but notification failed';

  @override
  String get errorLocaleUpdateValidationFailure =>
      'Invalid locale format provided';

  @override
  String get errorLocaleUpdateUnknown =>
      'Unexpected error while updating locale';

  @override
  String get errorUserNotSignedIn =>
      'User is not signed in. Please log in to continue';

  @override
  String get errorWrongPassword => 'Incorrect password. Please try again';

  @override
  String get errorRecentLoginRequired =>
      'Recent login required. Please sign in again to continue';

  @override
  String get errorNetwork =>
      'Network error. Please check your connection and try again';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please wait and try again later';

  @override
  String get errorInvalidCredential => 'Invalid credentials provided';

  @override
  String get errorUserDisabled =>
      'This account has been disabled. Contact support for assistance';

  @override
  String get errorMissingEmail => 'Email address is required';

  @override
  String get errorAuthState =>
      'Authentication state error. Please try logging in again';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountSubtitle =>
      'This action is irreversible. Once you delete your account, all your data will be permanently removed.';

  @override
  String get deleteAccountSuccess =>
      'You have successfully deleted your account.';

  @override
  String get submit => 'Submit';

  @override
  String get updatePasswordTitle => 'Update Password';

  @override
  String get updatePasswordSubtitle =>
      'Please enter your new password which must be at least 6 characters long and at most 12 characters long.';

  @override
  String get updatePasswordSuccess =>
      'You have successfully updated your password.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get errorWeakPassword =>
      'New password is too weak. Please choose a stronger password';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get adPanelUpdatingTitle => 'Updating...';

  @override
  String get adPanelUpdatingDescription =>
      'Please wait while we process your request';

  @override
  String get adPanelCompressingImagesTitle => 'Compressing Images';

  @override
  String adPanelCompressingImagesDescription(
    int currentFileIndex,
    int totalFiles,
  ) {
    return 'Please wait, your ($currentFileIndex/$totalFiles) image file is being prepared for upload';
  }

  @override
  String get adPanelUploadingImagesTitle => 'Uploading Images...';

  @override
  String adPanelUploadingImagesDescription(
    int currentFileIndex,
    int totalFiles,
  ) {
    return 'Please wait, your ($currentFileIndex/$totalFiles) image file is being uploaded';
  }

  @override
  String get adPanelUpdatingPanelsTitle => 'Updating panels...';

  @override
  String get adPanelUpdatingPanelsDescription =>
      'Please wait while we update your ad panels';

  @override
  String get adPanelUpdateExistWarningCompressingImages =>
      'Images are being compressed. Please wait until the process is complete.';

  @override
  String get adPanelUpdateExistWarningUploadingImages =>
      'Images are being uploaded. Please wait until the process is complete.';

  @override
  String get adPanelUpdateExistWarningUpdatingPanels =>
      'Ad Panels are being updated. Please wait until the process is complete.';

  @override
  String get adPanelUpdateExistWarningUnsavedChanges =>
      'You have unsaved changes. Are you sure you want to leave without saving?';

  @override
  String get adPanelUpdateExistWarningTitleUnsavedChanges => 'Unsaved Changes';

  @override
  String get adPanelUpdateProcessingWarningTitleUnsavedChanges =>
      'Processing...';

  @override
  String get adPanelAllowedImageMaxLengthTitle => 'Only 3 photos are allowed';

  @override
  String get adPanelAllowedImageMaxLengthMessage =>
      'You can add more photos by removing existing ones.';

  @override
  String get adPanelImageUpdateFailureTitle => 'Upload Failure';

  @override
  String adPanelImageUpdateFailureMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count failed to upload. Please try uploading the failed files again.',
      one: '1 file',
      zero: 'All files',
    );
    return '$_temp0';
  }
}
