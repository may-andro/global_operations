// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get adPanelAdditionalComments => 'Aanvullende opmerkingen';

  @override
  String get adPanelCamera => 'Camera';

  @override
  String get adPanelCheckboxObjectAdvertisementIssue => 'Advertentieprobleem';

  @override
  String get adPanelCheckboxObjectCampaignIssue => 'Campagneprobleem';

  @override
  String get adPanelCheckboxObjectDamageIssue => 'Schadeprobleem';

  @override
  String get adPanelCheckboxObjectCleanIssue => 'Schoonmaakprobleem';

  @override
  String get adPanelCheckboxObjectPosterIssue => 'Posterprobleem';

  @override
  String get adPanelCheckboxObjectLighteningIssue => 'Verlichtingsprobleem';

  @override
  String get adPanelCheckboxObjectMaintenanceIssue => 'Onderhoudsprobleem';

  @override
  String get adPanelCommentHint => 'Opmerking toevoegen [optioneel]';

  @override
  String adPanelDistanceAway(double distance) {
    return '$distance km verwijderd';
  }

  @override
  String get adPanelEmptyDescription =>
      'Er zijn momenteel geen advertentiepanelen beschikbaar.';

  @override
  String get adPanelEmptyTitle => 'Geen advertentiepaneel';

  @override
  String get adPanelErrorTitle => 'Er is iets misgegaan';

  @override
  String adPanelFaceLabel(int faceNumber) {
    return 'Zijde: $faceNumber';
  }

  @override
  String adPanelFaceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zijden',
      one: '1 zijde',
      zero: 'Geen zijden',
    );
    return '$_temp0';
  }

  @override
  String get adPanelFacesAndCampaigns => 'Zijden & Campagnes';

  @override
  String get adPanelGallery => 'Galerij';

  @override
  String get adPanelImages => 'Afbeeldingen';

  @override
  String adPanelMultiplePanelsFound(int count) {
    return '$count advertentiepanelen gevonden op deze locatie';
  }

  @override
  String get adPanelNoResultClearFilters => 'Filters wissen';

  @override
  String get adPanelNoResultDescription =>
      'Probeer uw zoekopdracht of filters aan te passen';

  @override
  String get adPanelNoResultTitle => 'Geen resultaten gevonden';

  @override
  String get adPanelPanelSubtitle =>
      'Klik om de advertentiepanelen te bekijken';

  @override
  String adPanelPanelTitle(String panelKey) {
    return 'Advertentiepaneel: $panelKey';
  }

  @override
  String get adPanelRefresh => 'Vernieuwen';

  @override
  String adPanelRunningCampaign(String campaign) {
    return 'Lopende campagne: $campaign';
  }

  @override
  String get adPanelSearchHint => 'Zoek advertentiepanelen...';

  @override
  String adPanelSearchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count advertentiepanelen gevonden',
      one: '1 advertentiepaneel gevonden',
      zero: 'Geen advertentiepanelen gevonden',
    );
    return '$_temp0';
  }

  @override
  String adPanelSearchResultCountWithRadius(int count, String radius) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count advertentiepanelen gevonden binnen $radius km',
      one: '1 advertentiepaneel gevonden binnen $radius km',
      zero: 'Geen advertentiepanelen gevonden binnen $radius km',
    );
    return '$_temp0';
  }

  @override
  String get adPanelSeeDetails => 'Bekijk details';

  @override
  String get adPanelSelectImageSource => 'Selecteer een afbeeldingsbron';

  @override
  String get adPanelShowListViewTooltip => 'Toon lijstweergave';

  @override
  String get adPanelShowMapViewTooltip => 'Toon kaartweergave';

  @override
  String get adPanelSortTooltip => 'Sorteeropties';

  @override
  String get adPanelSortDistanceSubtitle =>
      'Sorteren op afstand vanaf uw huidige locatie';

  @override
  String get adPanelSortDistanceTitle => 'Afstand';

  @override
  String get adPanelSortEditedSubtitle => 'Sorteren op recent bewerkte panelen';

  @override
  String get adPanelSortEditedTitle => 'Recent bewerkt';

  @override
  String get adPanelSortObjectNumberSubtitle =>
      'Sorteren op objectnummer in oplopende volgorde';

  @override
  String get adPanelSortObjectNumberTitle => 'Objectnummer';

  @override
  String get adPanelSortStreetSubtitle =>
      'Sorteren op straatnaam in alfabetische volgorde';

  @override
  String get adPanelSortStreetTitle => 'Straat';

  @override
  String get adPanelSortingOptions => 'Sorteeropties';

  @override
  String get adPanelSubmitUpdateTooltip => 'Wijzigingen indienen';

  @override
  String get adPanelUpdateSuccess => 'Uw wijzigingen zijn succesvol bijgewerkt';

  @override
  String appVersion(String version) {
    return 'Versie $version';
  }

  @override
  String get companyName => 'Global';

  @override
  String get copyright => '© 2025 Global Ops. Alle rechten voorbehouden.';

  @override
  String get localeSelectLanguage => 'Kies uw taal';

  @override
  String get locationPermissionAllow => 'Locatie toestaan';

  @override
  String get locationPermissionDeniedDescription =>
      'Deze functie vereist toegang tot locatie. Geef toestemming.';

  @override
  String get locationPermissionDeniedTitle => 'Locatie-toestemming nodig';

  @override
  String get locationPermissionFailure => 'Kon toestemmingsstatus niet ophalen';

  @override
  String get locationPermissionLimitedDescription =>
      'U heeft beperkte locatietoegang verleend. Sommige functies werken mogelijk niet zoals verwacht.';

  @override
  String get locationPermissionLimitedTitle => 'Beperkte locatietoegang';

  @override
  String get locationPermissionOpenSettings => 'Open app-instellingen';

  @override
  String get locationPermissionPermanentlyDeniedDescription =>
      'Locatie-toestemming is permanent geweigerd. Open instellingen om deze toe te staan.';

  @override
  String get locationPermissionPermanentlyDeniedTitle =>
      'Locatie-toestemming vereist';

  @override
  String get locationPermissionProvisionalDescription =>
      'U heeft voorlopige locatietoegang. Bevestig om volledige toegang te verlenen.';

  @override
  String get locationPermissionProvisionalTitle => 'Voorlopige locatietoegang';

  @override
  String get locationPermissionRestrictedDescription =>
      'Locatietoegang is beperkt op dit apparaat of door ouderlijk toezicht.';

  @override
  String get locationPermissionRestrictedTitle => 'Locatie beperkt';

  @override
  String get no => 'Nee';

  @override
  String get yes => 'Ja';

  @override
  String get routeNotFoundButton => 'Ga naar Home';

  @override
  String get routeNotFoundMessage =>
      'Oeps! De pagina die u zoekt\\nis niet gevonden.';

  @override
  String get routeNotFoundTitle => 'Pagina Niet Gevonden';

  @override
  String get settingAppLanguage => 'Applicatietaal';

  @override
  String get settingChangePassword => 'Wachtwoord wijzigen';

  @override
  String get settingCurrentUser => 'Huidige gebruiker';

  @override
  String get settingDeleteAccount => 'Account verwijderen';

  @override
  String get settingDeleteAccountConfirmation =>
      'Bevestiging account verwijderen';

  @override
  String get settingDeleteAccountConfirmationPrompt =>
      'Accountverwijdering is onomkeerbaar. Weet u zeker dat u uw account wilt verwijderen?';

  @override
  String get settingLanguageSectionTitle => 'Taal';

  @override
  String get settingLocationBasedSearch => 'Locatiegebaseerd zoeken';

  @override
  String get settingLocationBasedSearchDescription =>
      'Schakel deze functie in om reclamepanelen te vinden binnen een geselecteerde straal vanaf uw huidige locatie.';

  @override
  String get settingLogout => 'Uitloggen';

  @override
  String get settingLogoutConfirmation => 'Bevestiging uitloggen';

  @override
  String get settingLogoutConfirmationPrompt => 'Wilt u uitloggen?';

  @override
  String get settingSearchCriteriaSectionTitle => 'Zoekcriteria';

  @override
  String get settingUserManagementSectionTitle => 'Gebruikersbeheer';

  @override
  String get splashContactSupport => 'contacteer support';

  @override
  String get splashErrorMessage =>
      'Herstart de app opnieuw of probeer het later. Als het probleem aanhoudt';

  @override
  String get splashErrorTitle =>
      'We hebben een probleem ondervonden tijdens de setup 😵‍💫💻';

  @override
  String get splashProdMessage => 'De motor opwarmen...';

  @override
  String get splashStagingDoneMessage => 'De setup is voltooid 🚀';

  @override
  String get splashStagingPostRegisterMessage =>
      'Alle afhankelijkheden ophalen 🎯';

  @override
  String get splashStagingRegisteringMessage => 'De services registreren ⬇️';

  @override
  String get splashStagingStartMessage => 'De app opwarmen 🔥';

  @override
  String get errorNetworkConnection =>
      'Controleer uw internetverbinding en probeer het opnieuw';

  @override
  String get errorImageSizeExceeded =>
      'Afbeeldingsbestand is te groot. Maximale grootte is 10MB';

  @override
  String get errorUploadCancelled => 'Upload werd geannuleerd';

  @override
  String get errorPermissionDenied =>
      'Toegang geweigerd. Controleer uw accountinstellingen';

  @override
  String get errorInvalidFile =>
      'Ongeldig bestand. Selecteer een geldig bestand';

  @override
  String get errorStorageService =>
      'Opslagservice fout. Probeer het later opnieuw';

  @override
  String get errorUploadUnknown =>
      'Er is een onverwachte fout opgetreden tijdens het uploaden';

  @override
  String get errorValidationFailed =>
      'Controleer de gegevens en probeer het opnieuw';

  @override
  String get errorServerUnavailable =>
      'Server is tijdelijk niet beschikbaar. Probeer het later opnieuw';

  @override
  String get errorSessionExpired => 'Sessie verlopen. Log opnieuw in';

  @override
  String get errorUpdateFailed =>
      'Er is een onverwachte fout opgetreden bij het bijwerken';

  @override
  String errorUnexpected(String error) {
    return 'Er is een onverwachte fout opgetreden: $error';
  }

  @override
  String get errorAdPanelUpdatePermissionDenied =>
      'U heeft geen toestemming om deze panelen bij te werken';

  @override
  String get errorLocaleStorageFailure =>
      'Opslagfout: Kan taalinstellingen niet lezen';

  @override
  String get errorLocaleValidationFailure =>
      'Ongeldige taalgegevens gedetecteerd';

  @override
  String get errorLocaleNotFound =>
      'Geen taalvoorkeur gevonden, standaardinstellingen gebruiken';

  @override
  String get errorLocaleLoadUnknown =>
      'Onverwachte fout bij het laden van taalinstellingen';

  @override
  String get errorLocaleCacheFailure => 'Kan taalinstellingen niet opslaan';

  @override
  String get errorLocaleServiceLocatorFailure =>
      'Kan applicatieservices niet bijwerken. Herstart de app';

  @override
  String get errorLocaleIntlFailure =>
      'Kan internationalisatie-instellingen niet instellen';

  @override
  String get errorLocaleStreamFailure => 'Taal bijgewerkt maar melding mislukt';

  @override
  String get errorLocaleUpdateValidationFailure =>
      'Ongeldig taalformaat opgegeven';

  @override
  String get errorLocaleUpdateUnknown =>
      'Onverwachte fout bij het bijwerken van taal';

  @override
  String get errorUserNotSignedIn =>
      'Gebruiker is niet ingelogd. Log in om door te gaan';

  @override
  String get errorWrongPassword => 'Onjuist wachtwoord. Probeer het opnieuw';

  @override
  String get errorRecentLoginRequired =>
      'Recente login vereist. Log opnieuw in om door te gaan';

  @override
  String get errorNetwork =>
      'Netwerkfout. Controleer uw verbinding en probeer het opnieuw';

  @override
  String get errorTooManyRequests =>
      'Te veel verzoeken. Wacht even en probeer het later opnieuw';

  @override
  String get errorInvalidCredential => 'Ongeldige inloggegevens opgegeven';

  @override
  String get errorUserDisabled =>
      'Dit account is uitgeschakeld. Neem contact op met support voor hulp';

  @override
  String get errorMissingEmail => 'E-mailadres is vereist';

  @override
  String get errorAuthState =>
      'Authenticatiestatus fout. Probeer opnieuw in te loggen';

  @override
  String get deleteAccountTitle => 'Account Verwijderen';

  @override
  String get deleteAccountSubtitle =>
      'Deze actie is onomkeerbaar. Zodra u uw account verwijdert, worden al uw gegevens permanent verwijderd.';

  @override
  String get deleteAccountSuccess => 'U heeft uw account succesvol verwijderd.';

  @override
  String get submit => 'Indienen';

  @override
  String get updatePasswordTitle => 'Wachtwoord Bijwerken';

  @override
  String get updatePasswordSubtitle =>
      'Voer uw nieuwe wachtwoord in dat minimaal 6 tekens en maximaal 12 tekens lang moet zijn.';

  @override
  String get updatePasswordSuccess =>
      'U heeft uw wachtwoord succesvol bijgewerkt.';

  @override
  String get currentPassword => 'Huidig Wachtwoord';

  @override
  String get newPassword => 'Nieuw Wachtwoord';

  @override
  String get errorWeakPassword =>
      'Nieuw wachtwoord is te zwak. Kies een sterker wachtwoord';

  @override
  String get close => 'Sluiten';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get adPanelUpdatingTitle => 'Bezig met bijwerken...';

  @override
  String get adPanelUpdatingDescription =>
      'Even geduld terwijl we uw verzoek verwerken';

  @override
  String get adPanelUploadingImagesTitle => 'Afbeeldingen uploaden...';

  @override
  String adPanelUploadingImagesDescription(
    int currentFileIndex,
    int totalFiles,
  ) {
    return 'Even geduld, uw ($currentFileIndex/$totalFiles) afbeeldingsbestand wordt geüpload';
  }

  @override
  String get adPanelUpdatingPanelsTitle => 'Panelen bijwerken...';

  @override
  String get adPanelUpdatingPanelsDescription =>
      'Even geduld terwijl we uw reclamepanelen bijwerken';

  @override
  String get adPanelUpdateExistWarningUploadingImages =>
      'Afbeeldingen worden geüpload. Wacht tot het proces is voltooid.';

  @override
  String get adPanelUpdateExistWarningUpdatingPanels =>
      'Advertentiepalen worden bijgewerkt. Wacht tot het proces is voltooid.';

  @override
  String get adPanelUpdateExistWarningUnsavedChanges =>
      'Je hebt niet-opgeslagen wijzigingen. Weet je zeker dat je wilt afsluiten zonder op te slaan?';

  @override
  String get adPanelUpdateExistWarningTitleUnsavedChanges =>
      'Niet-opgeslagen wijzigingen';

  @override
  String get adPanelUpdateProcessingWarningTitleUnsavedChanges =>
      'Bezig met verwerken...';

  @override
  String get adPanelAllowedImageMaxLengthTitle =>
      'Er zijn slechts 3 foto\'s toegestaan';

  @override
  String get adPanelAllowedImageMaxLengthMessage =>
      'Je kunt meer foto\'s toevoegen door bestaande te verwijderen.';

  @override
  String get adPanelImageUpdateFailureTitle => 'Upload mislukt';

  @override
  String adPanelImageUpdateFailureMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count bestanden konden niet worden geüpload. Probeer de mislukte bestanden opnieuw te uploaden.',
      one: '1 bestand',
      zero: 'Alle bestanden',
    );
    return '$_temp0';
  }

  @override
  String get imageCompressionTitle => 'Afbeeldingen comprimeren';

  @override
  String get imageCompressionFailureTitle =>
      'Fout bij comprimeren van afbeeldingen';

  @override
  String get imageCompressionMessage =>
      'Afbeeldingen worden gecomprimeerd. Even wachten tot het proces is voltooid.';

  @override
  String get errorDecodingFile =>
      'Kan het geselecteerde bestand niet decoderen. Probeer een ander bestand.';

  @override
  String get errorProcessingFile =>
      'Er is een probleem opgetreden bij het verwerken van het bestand. Probeer het opnieuw.';

  @override
  String get errorUnknownFile =>
      'Er is een onbekende fout opgetreden met het bestand.';

  @override
  String get adPanelSearchRadiusTitle => 'Selecteer de zoekradius';

  @override
  String get adPanelSearchRadiusLocationUpdateDescription =>
      'Nieuwe advertentiepaneel worden bijgewerkt wanneer beweging van de gebruiker wordt gedetecteerd.';

  @override
  String get adPanelSearchRadiusNoLocationUpdateDescription =>
      'Nieuwe panelen worden niet bijgewerkt wanneer beweging van de gebruiker wordt gedetecteerd.';

  @override
  String adPanelSearchRadiusLabel(String radius) {
    return 'Radius: $radius km';
  }

  @override
  String get errorEmptyPassword => 'Wachtwoord mag niet leeg zijn';

  @override
  String get errorPasswordTooSmall =>
      'Wachtwoord moet minimaal 6 tekens bevatten';

  @override
  String get errorPasswordTooLarge =>
      'Wachtwoord mag niet meer dan 12 tekens bevatten';

  @override
  String get password => 'Wachtwoord';

  @override
  String get email => 'E-mail';

  @override
  String get errorInvalidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get errorEmptyEmail => 'E-mail mag niet leeg zijn';

  @override
  String get resetPasswordTitle => 'Wachtwoord vergeten?';

  @override
  String get resetPasswordSubtitle =>
      'Vul hieronder je e-mailadres in en we sturen je instructies om je wachtwoord te resetten.';

  @override
  String get resetPasswordSuccessMessage =>
      'Wachtwoord-e-mail succesvol verzonden. Controleer je inbox.';
}
