import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('da'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BILSKYEN - Car Marketplace'**
  String get appTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'BILSKYEN'**
  String get brandName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue exploring amazing cars.'**
  String get signInSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @enterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordHint;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to start your journey with the ultimate car marketplace.'**
  String get signUpSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullName;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullNameHint;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPasswordHint;

  /// No description provided for @pleaseEnterPasswordRegister.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPasswordRegister;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTerms;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logInLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logInLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPasswordSubtitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email, the reset token you received, and your new password.'**
  String get resetPasswordDescription;

  /// No description provided for @resetToken.
  ///
  /// In en, this message translates to:
  /// **'RESET TOKEN'**
  String get resetToken;

  /// No description provided for @pasteTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the token from your email'**
  String get pasteTokenHint;

  /// No description provided for @pleaseEnterResetToken.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reset token'**
  String get pleaseEnterResetToken;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get newPassword;

  /// No description provided for @atLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Chars;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmPasswordHint;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navMyListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get navMyListings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SETTINGS'**
  String get accountSettings;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @savedVehicles.
  ///
  /// In en, this message translates to:
  /// **'Saved Vehicles'**
  String get savedVehicles;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @supportAndLegal.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & LEGAL'**
  String get supportAndLegal;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @helpSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help & Support coming soon'**
  String get helpSupportComingSoon;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy coming soon'**
  String get privacyPolicyComingSoon;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service coming soon'**
  String get termsComingSoon;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// No description provided for @signInToManage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your listings, save favorites, and access your profile.'**
  String get signInToManage;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @verifiedUser.
  ///
  /// In en, this message translates to:
  /// **'Verified User'**
  String get verifiedUser;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSelectionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language selection coming soon'**
  String get languageSelectionComingSoon;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @danish.
  ///
  /// In en, this message translates to:
  /// **'Dansk'**
  String get danish;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account. This action cannot be undone. Enter your password to confirm.'**
  String get deleteAccountConfirm;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @followSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @alwaysLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Always use light theme'**
  String get alwaysLightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @alwaysDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get alwaysDarkTheme;

  /// No description provided for @whatAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingFor;

  /// No description provided for @featuredVehicle.
  ///
  /// In en, this message translates to:
  /// **'Featured Vehicle'**
  String get featuredVehicle;

  /// No description provided for @noFeaturedVehicles.
  ///
  /// In en, this message translates to:
  /// **'No featured vehicles available'**
  String get noFeaturedVehicles;

  /// No description provided for @sponsoredByBilskyenPremium.
  ///
  /// In en, this message translates to:
  /// **'Sponsored by Bilskyen Premium'**
  String get sponsoredByBilskyenPremium;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @enquire.
  ///
  /// In en, this message translates to:
  /// **'Enquire'**
  String get enquire;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @dealer.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get dealer;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @searchVehicles.
  ///
  /// In en, this message translates to:
  /// **'Search Vehicles'**
  String get searchVehicles;

  /// No description provided for @loadingFilters.
  ///
  /// In en, this message translates to:
  /// **'Loading filters...'**
  String get loadingFilters;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for brands, models, equipment or keywords...'**
  String get searchHint;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @listingType.
  ///
  /// In en, this message translates to:
  /// **'Listing type'**
  String get listingType;

  /// No description provided for @priceKr.
  ///
  /// In en, this message translates to:
  /// **'Price (kr)'**
  String get priceKr;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @kmDriven.
  ///
  /// In en, this message translates to:
  /// **'KM driven'**
  String get kmDriven;

  /// No description provided for @typeBrandModel.
  ///
  /// In en, this message translates to:
  /// **'Type / Brand / Model'**
  String get typeBrandModel;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get vehicleDetails;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @selectBrandFirst.
  ///
  /// In en, this message translates to:
  /// **'Select brand first'**
  String get selectBrandFirst;

  /// No description provided for @modelYear.
  ///
  /// In en, this message translates to:
  /// **'Model year'**
  String get modelYear;

  /// No description provided for @bodyStyleCategory.
  ///
  /// In en, this message translates to:
  /// **'Body style / Category'**
  String get bodyStyleCategory;

  /// No description provided for @odometerKm.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km)'**
  String get odometerKm;

  /// No description provided for @ownerTax.
  ///
  /// In en, this message translates to:
  /// **'Owner tax'**
  String get ownerTax;

  /// No description provided for @driveWheels.
  ///
  /// In en, this message translates to:
  /// **'Drive wheels'**
  String get driveWheels;

  /// No description provided for @firstRegistrationYear.
  ///
  /// In en, this message translates to:
  /// **'First Registration Year'**
  String get firstRegistrationYear;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @sellerDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'Seller distance (km)'**
  String get sellerDistanceKm;

  /// No description provided for @distanceKmHint.
  ///
  /// In en, this message translates to:
  /// **'Distance in km'**
  String get distanceKmHint;

  /// No description provided for @horsepowerHp.
  ///
  /// In en, this message translates to:
  /// **'Horsepower (hp)'**
  String get horsepowerHp;

  /// No description provided for @batteryCapacityKwh.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity (kWh)'**
  String get batteryCapacityKwh;

  /// No description provided for @rangeKm.
  ///
  /// In en, this message translates to:
  /// **'Range (km)'**
  String get rangeKm;

  /// No description provided for @chargingType.
  ///
  /// In en, this message translates to:
  /// **'Charging type'**
  String get chargingType;

  /// No description provided for @doorsSeats.
  ///
  /// In en, this message translates to:
  /// **'Doors & seats'**
  String get doorsSeats;

  /// No description provided for @doorsMin.
  ///
  /// In en, this message translates to:
  /// **'Doors (min)'**
  String get doorsMin;

  /// No description provided for @seatsMin.
  ///
  /// In en, this message translates to:
  /// **'Seats (min)'**
  String get seatsMin;

  /// No description provided for @seatsMax.
  ///
  /// In en, this message translates to:
  /// **'Seats (max)'**
  String get seatsMax;

  /// No description provided for @towingWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Towing weight (kg)'**
  String get towingWeightKg;

  /// No description provided for @minTowingWeight.
  ///
  /// In en, this message translates to:
  /// **'Min towing weight'**
  String get minTowingWeight;

  /// No description provided for @fuelEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Fuel efficiency'**
  String get fuelEfficiency;

  /// No description provided for @topSpeedKmh.
  ///
  /// In en, this message translates to:
  /// **'Top speed (km/h)'**
  String get topSpeedKmh;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @engineDisplacementCc.
  ///
  /// In en, this message translates to:
  /// **'Engine displacement (cc)'**
  String get engineDisplacementCc;

  /// No description provided for @physicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Physical details'**
  String get physicalDetails;

  /// No description provided for @engineCylindersWheels.
  ///
  /// In en, this message translates to:
  /// **'Engine cylinders, wheels, axles, airbags'**
  String get engineCylindersWheels;

  /// No description provided for @cylinders.
  ///
  /// In en, this message translates to:
  /// **'Cylinders'**
  String get cylinders;

  /// No description provided for @wheels.
  ///
  /// In en, this message translates to:
  /// **'Wheels'**
  String get wheels;

  /// No description provided for @axles.
  ///
  /// In en, this message translates to:
  /// **'Axles'**
  String get axles;

  /// No description provided for @airbags.
  ///
  /// In en, this message translates to:
  /// **'Airbags'**
  String get airbags;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @factoryNew.
  ///
  /// In en, this message translates to:
  /// **'Factory new'**
  String get factoryNew;

  /// No description provided for @listingPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get listingPurchase;

  /// No description provided for @listingLeasing.
  ///
  /// In en, this message translates to:
  /// **'Leasing'**
  String get listingLeasing;

  /// No description provided for @filterChargingAc.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get filterChargingAc;

  /// No description provided for @filterChargingDc.
  ///
  /// In en, this message translates to:
  /// **'DC'**
  String get filterChargingDc;

  /// No description provided for @filterChargingAcDc.
  ///
  /// In en, this message translates to:
  /// **'AC/DC'**
  String get filterChargingAcDc;

  /// No description provided for @filterNcapTest.
  ///
  /// In en, this message translates to:
  /// **'NCAP test'**
  String get filterNcapTest;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuelType;

  /// No description provided for @gearType.
  ///
  /// In en, this message translates to:
  /// **'Gear type'**
  String get gearType;

  /// No description provided for @salesType.
  ///
  /// In en, this message translates to:
  /// **'Sales type'**
  String get salesType;

  /// No description provided for @priceType.
  ///
  /// In en, this message translates to:
  /// **'Price type'**
  String get priceType;

  /// No description provided for @bodyTypes.
  ///
  /// In en, this message translates to:
  /// **'Body types'**
  String get bodyTypes;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @variant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get variant;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @euronorms.
  ///
  /// In en, this message translates to:
  /// **'Euronorms'**
  String get euronorms;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleaseAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Privacy Policy'**
  String get pleaseAgreeTerms;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailed;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent'**
  String get resetLinkSent;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email for the password reset link.'**
  String get checkEmail;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You can now log in with your new password.'**
  String get passwordResetSuccessMessage;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @welcomeBackWithName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBackWithName(String name);

  /// No description provided for @changesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changesSavedSuccess;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout Failed'**
  String get logoutFailed;

  /// No description provided for @sellYourCarHassleFree.
  ///
  /// In en, this message translates to:
  /// **'Sell your car hassle-free'**
  String get sellYourCarHassleFree;

  /// No description provided for @sellBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get an instant offer or list it on the marketplace in minutes.'**
  String get sellBannerSubtitle;

  /// No description provided for @startSelling.
  ///
  /// In en, this message translates to:
  /// **'Start Selling'**
  String get startSelling;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// No description provided for @pleaseSignInToListVehicle.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to list your vehicle on the marketplace.'**
  String get pleaseSignInToListVehicle;

  /// No description provided for @sellYourCar.
  ///
  /// In en, this message translates to:
  /// **'Sell Your Car'**
  String get sellYourCar;

  /// No description provided for @sellYourCarOnDenmarkMarket.
  ///
  /// In en, this message translates to:
  /// **'Sell your car on Denmark\'s largest car market'**
  String get sellYourCarOnDenmarkMarket;

  /// No description provided for @sellYourCarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your car\'s license plate and we\'ll help you with the rest. All fields are visible.'**
  String get sellYourCarSubtitle;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @enterManuallyLead.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have a registration number'**
  String get enterManuallyLead;

  /// No description provided for @startOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get startOver;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// No description provided for @advertisementsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Advertisements'**
  String advertisementsCount(int count);

  /// No description provided for @favoritesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Favorites'**
  String favoritesCount(int count);

  /// No description provided for @ncapFiveStar.
  ///
  /// In en, this message translates to:
  /// **'5-star NCAP'**
  String get ncapFiveStar;

  /// No description provided for @driveWheelFwd.
  ///
  /// In en, this message translates to:
  /// **'FWD'**
  String get driveWheelFwd;

  /// No description provided for @driveWheelRwd.
  ///
  /// In en, this message translates to:
  /// **'RWD'**
  String get driveWheelRwd;

  /// No description provided for @driveWheelAwd.
  ///
  /// In en, this message translates to:
  /// **'AWD'**
  String get driveWheelAwd;

  /// No description provided for @signInToViewFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your favorites'**
  String get signInToViewFavorites;

  /// No description provided for @signInToViewFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save vehicles you like and access them here.'**
  String get signInToViewFavoritesSubtitle;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @startAddingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Start adding vehicles to your favorites'**
  String get startAddingFavorites;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @arrangeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Arrange'**
  String get arrangeTooltip;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sortDefault;

  /// No description provided for @sortBestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best match'**
  String get sortBestMatch;

  /// No description provided for @sortStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get sortStandard;

  /// No description provided for @sortDistanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Distance - farthest first'**
  String get sortDistanceDesc;

  /// No description provided for @sortDistanceAsc.
  ///
  /// In en, this message translates to:
  /// **'Distance - nearest first'**
  String get sortDistanceAsc;

  /// No description provided for @sortDirectionAsc.
  ///
  /// In en, this message translates to:
  /// **'lowest first'**
  String get sortDirectionAsc;

  /// No description provided for @sortDirectionDesc.
  ///
  /// In en, this message translates to:
  /// **'highest first'**
  String get sortDirectionDesc;

  /// No description provided for @sortColumnCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Date created'**
  String get sortColumnCreatedAt;

  /// No description provided for @sortColumnPublishedAt.
  ///
  /// In en, this message translates to:
  /// **'Date published'**
  String get sortColumnPublishedAt;

  /// No description provided for @sortColumnPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortColumnPrice;

  /// No description provided for @sortColumnModelYear.
  ///
  /// In en, this message translates to:
  /// **'Model year'**
  String get sortColumnModelYear;

  /// No description provided for @sortColumnMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get sortColumnMileage;

  /// No description provided for @sortColumnKmPerLiter.
  ///
  /// In en, this message translates to:
  /// **'KM/L'**
  String get sortColumnKmPerLiter;

  /// No description provided for @sortColumnFuelEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Fuel efficiency'**
  String get sortColumnFuelEfficiency;

  /// No description provided for @sortColumnRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get sortColumnRange;

  /// No description provided for @sortColumnBatteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity'**
  String get sortColumnBatteryCapacity;

  /// No description provided for @sortColumnBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get sortColumnBrand;

  /// No description provided for @sortColumnEnginePower.
  ///
  /// In en, this message translates to:
  /// **'Engine power'**
  String get sortColumnEnginePower;

  /// No description provided for @sortColumnTopSpeed.
  ///
  /// In en, this message translates to:
  /// **'Top speed'**
  String get sortColumnTopSpeed;

  /// No description provided for @sortColumnTowingWeight.
  ///
  /// In en, this message translates to:
  /// **'Towing weight'**
  String get sortColumnTowingWeight;

  /// No description provided for @sortColumnOwnershipTax.
  ///
  /// In en, this message translates to:
  /// **'Ownership tax'**
  String get sortColumnOwnershipTax;

  /// No description provided for @sortColumnFirstRegistration.
  ///
  /// In en, this message translates to:
  /// **'First registration date'**
  String get sortColumnFirstRegistration;

  /// No description provided for @sortColumnFirstRegistrationYear.
  ///
  /// In en, this message translates to:
  /// **'First registration year'**
  String get sortColumnFirstRegistrationYear;

  /// No description provided for @signInToManageListings.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your listings'**
  String get signInToManageListings;

  /// No description provided for @signInToManageListingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and manage your vehicle listings here.'**
  String get signInToManageListingsSubtitle;

  /// No description provided for @noVehiclesYet.
  ///
  /// In en, this message translates to:
  /// **'No vehicles yet'**
  String get noVehiclesYet;

  /// No description provided for @listYourFirstVehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List your first vehicle to get started.'**
  String get listYourFirstVehicleSubtitle;

  /// No description provided for @listYourFirstVehicle.
  ///
  /// In en, this message translates to:
  /// **'List your first vehicle'**
  String get listYourFirstVehicle;

  /// No description provided for @noVehicleDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No vehicle data available'**
  String get noVehicleDataAvailable;

  /// No description provided for @listedPrice.
  ///
  /// In en, this message translates to:
  /// **'Listed Price'**
  String get listedPrice;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @vehicleDetailTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get vehicleDetailTitleLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @vehicleSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Specifications'**
  String get vehicleSpecifications;

  /// No description provided for @enginePower.
  ///
  /// In en, this message translates to:
  /// **'Engine Power'**
  String get enginePower;

  /// No description provided for @kilometersDriven.
  ///
  /// In en, this message translates to:
  /// **'Kilometers Driven'**
  String get kilometersDriven;

  /// No description provided for @annualTax.
  ///
  /// In en, this message translates to:
  /// **'Annual Tax'**
  String get annualTax;

  /// No description provided for @firstRegistration.
  ///
  /// In en, this message translates to:
  /// **'First Registration'**
  String get firstRegistration;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @detailedSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Detailed Specifications'**
  String get detailedSpecifications;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @vinLocation.
  ///
  /// In en, this message translates to:
  /// **'VIN Location'**
  String get vinLocation;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get totalWeight;

  /// No description provided for @technicalTotalWeight.
  ///
  /// In en, this message translates to:
  /// **'Technical Total Weight'**
  String get technicalTotalWeight;

  /// No description provided for @minimumWeight.
  ///
  /// In en, this message translates to:
  /// **'Minimum Weight'**
  String get minimumWeight;

  /// No description provided for @grossCombinationWeight.
  ///
  /// In en, this message translates to:
  /// **'Gross Combination Weight'**
  String get grossCombinationWeight;

  /// No description provided for @towingWeightBrakes.
  ///
  /// In en, this message translates to:
  /// **'Towing Weight (Brakes)'**
  String get towingWeightBrakes;

  /// No description provided for @engineCode.
  ///
  /// In en, this message translates to:
  /// **'Engine Code'**
  String get engineCode;

  /// No description provided for @engineCylinders.
  ///
  /// In en, this message translates to:
  /// **'Engine Cylinders'**
  String get engineCylinders;

  /// No description provided for @doors.
  ///
  /// In en, this message translates to:
  /// **'Doors'**
  String get doors;

  /// No description provided for @minimumSeats.
  ///
  /// In en, this message translates to:
  /// **'Minimum Seats'**
  String get minimumSeats;

  /// No description provided for @maximumSeats.
  ///
  /// In en, this message translates to:
  /// **'Maximum Seats'**
  String get maximumSeats;

  /// No description provided for @integratedChildSeats.
  ///
  /// In en, this message translates to:
  /// **'Integrated Child Seats'**
  String get integratedChildSeats;

  /// No description provided for @seatBeltAlarms.
  ///
  /// In en, this message translates to:
  /// **'Seat Belt Alarms'**
  String get seatBeltAlarms;

  /// No description provided for @euroNorm.
  ///
  /// In en, this message translates to:
  /// **'Euro Norm'**
  String get euroNorm;

  /// No description provided for @driveAxles.
  ///
  /// In en, this message translates to:
  /// **'Drive Axles'**
  String get driveAxles;

  /// No description provided for @wheelbase.
  ///
  /// In en, this message translates to:
  /// **'Wheelbase'**
  String get wheelbase;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @serviceBook.
  ///
  /// In en, this message translates to:
  /// **'Service Book'**
  String get serviceBook;

  /// No description provided for @extraEquipment.
  ///
  /// In en, this message translates to:
  /// **'Extra Equipment'**
  String get extraEquipment;

  /// No description provided for @dispensations.
  ///
  /// In en, this message translates to:
  /// **'Dispensations'**
  String get dispensations;

  /// No description provided for @permits.
  ///
  /// In en, this message translates to:
  /// **'Permits'**
  String get permits;

  /// No description provided for @registrationAndStatus.
  ///
  /// In en, this message translates to:
  /// **'Registration & Status'**
  String get registrationAndStatus;

  /// No description provided for @registrationStatus.
  ///
  /// In en, this message translates to:
  /// **'Registration Status'**
  String get registrationStatus;

  /// No description provided for @registrationStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Registration Status Updated'**
  String get registrationStatusUpdated;

  /// No description provided for @expireDate.
  ///
  /// In en, this message translates to:
  /// **'Expire Date'**
  String get expireDate;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status Updated'**
  String get statusUpdated;

  /// No description provided for @inspectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Inspection Details'**
  String get inspectionDetails;

  /// No description provided for @lastInspectionDate.
  ///
  /// In en, this message translates to:
  /// **'Last Inspection Date'**
  String get lastInspectionDate;

  /// No description provided for @lastInspectionResult.
  ///
  /// In en, this message translates to:
  /// **'Last Inspection Result'**
  String get lastInspectionResult;

  /// No description provided for @lastInspectionOdometer.
  ///
  /// In en, this message translates to:
  /// **'Last Inspection Odometer'**
  String get lastInspectionOdometer;

  /// No description provided for @leasingInformation.
  ///
  /// In en, this message translates to:
  /// **'Leasing Information'**
  String get leasingInformation;

  /// No description provided for @leasingPeriodStart.
  ///
  /// In en, this message translates to:
  /// **'Leasing Period Start'**
  String get leasingPeriodStart;

  /// No description provided for @leasingPeriodEnd.
  ///
  /// In en, this message translates to:
  /// **'Leasing Period End'**
  String get leasingPeriodEnd;

  /// No description provided for @equipmentAndFeatures.
  ///
  /// In en, this message translates to:
  /// **'Equipment & Features'**
  String get equipmentAndFeatures;

  /// No description provided for @listingInformation.
  ///
  /// In en, this message translates to:
  /// **'Listing Information'**
  String get listingInformation;

  /// No description provided for @addedToListing.
  ///
  /// In en, this message translates to:
  /// **'Added to Listing'**
  String get addedToListing;

  /// No description provided for @contactSeller.
  ///
  /// In en, this message translates to:
  /// **'Contact seller'**
  String get contactSeller;

  /// No description provided for @sendEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Send Enquiry'**
  String get sendEnquiry;

  /// No description provided for @exchangeRequest.
  ///
  /// In en, this message translates to:
  /// **'Request Exchange'**
  String get exchangeRequest;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @requestTestDrive.
  ///
  /// In en, this message translates to:
  /// **'Request Test Drive'**
  String get requestTestDrive;

  /// No description provided for @priceNegotiation.
  ///
  /// In en, this message translates to:
  /// **'Price Negotiation'**
  String get priceNegotiation;

  /// No description provided for @noEmailAddressAvailable.
  ///
  /// In en, this message translates to:
  /// **'No email address available'**
  String get noEmailAddressAvailable;

  /// No description provided for @couldNotOpenEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app'**
  String get couldNotOpenEmailApp;

  /// No description provided for @unknownSeller.
  ///
  /// In en, this message translates to:
  /// **'Unknown Seller'**
  String get unknownSeller;

  /// No description provided for @sellerInformation.
  ///
  /// In en, this message translates to:
  /// **'Seller Information'**
  String get sellerInformation;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @interestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Interested?'**
  String get interestedTitle;

  /// No description provided for @takeNextSteps.
  ///
  /// In en, this message translates to:
  /// **'Take the next steps to make this vehicle yours.'**
  String get takeNextSteps;

  /// No description provided for @requestVehicleHistory.
  ///
  /// In en, this message translates to:
  /// **'Request detailed vehicle history'**
  String get requestVehicleHistory;

  /// No description provided for @scheduleInspection.
  ///
  /// In en, this message translates to:
  /// **'Schedule inspection'**
  String get scheduleInspection;

  /// No description provided for @discussFinancing.
  ///
  /// In en, this message translates to:
  /// **'Discuss financing options'**
  String get discussFinancing;

  /// No description provided for @arrangeTestDrive.
  ///
  /// In en, this message translates to:
  /// **'Arrange test drive'**
  String get arrangeTestDrive;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @oneDayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get oneDayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @couldNotOpenPhoneDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open phone dialer'**
  String get couldNotOpenPhoneDialer;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @showPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get showPhoneNumber;

  /// No description provided for @vehicleInformation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @currentPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Price'**
  String get currentPrice;

  /// No description provided for @yourOffer.
  ///
  /// In en, this message translates to:
  /// **'Your Offer'**
  String get yourOffer;

  /// No description provided for @yourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your Details'**
  String get yourDetails;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @enterFullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullNamePlaceholder;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @enterEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailPlaceholder;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneOptionalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number (optional)'**
  String get enterPhoneOptionalPlaceholder;

  /// No description provided for @exchangeLicensePlateLabel.
  ///
  /// In en, this message translates to:
  /// **'License plate'**
  String get exchangeLicensePlateLabel;

  /// No description provided for @exchangeLicensePlatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter license plate'**
  String get exchangeLicensePlatePlaceholder;

  /// No description provided for @exchangeLicensePlateRequired.
  ///
  /// In en, this message translates to:
  /// **'License plate is required'**
  String get exchangeLicensePlateRequired;

  /// No description provided for @exchangeKilometersUsedLabel.
  ///
  /// In en, this message translates to:
  /// **'Kilometers used'**
  String get exchangeKilometersUsedLabel;

  /// No description provided for @exchangeKilometersUsedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter kilometers used'**
  String get exchangeKilometersUsedPlaceholder;

  /// No description provided for @exchangeKilometersUsedRequired.
  ///
  /// In en, this message translates to:
  /// **'Kilometers used is required'**
  String get exchangeKilometersUsedRequired;

  /// No description provided for @exchangeValidNonNegativeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative number'**
  String get exchangeValidNonNegativeNumber;

  /// No description provided for @exchangeExpectedPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected price'**
  String get exchangeExpectedPriceLabel;

  /// No description provided for @exchangeExpectedPricePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your expected price'**
  String get exchangeExpectedPricePlaceholder;

  /// No description provided for @exchangeExpectedPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Expected price is required'**
  String get exchangeExpectedPriceRequired;

  /// No description provided for @yourOfferMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Offer / Message'**
  String get yourOfferMessageLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @enquiryMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your enquiry...'**
  String get enquiryMessagePlaceholder;

  /// No description provided for @testDriveMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your preferred test drive date and time, or any specific questions you have...'**
  String get testDriveMessagePlaceholder;

  /// No description provided for @priceNegotiationMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your offer price or negotiation message. For example: \'I would like to offer DKK 250,000 for this vehicle\' or \'Is there any room for negotiation on the price?\''**
  String get priceNegotiationMessagePlaceholder;

  /// No description provided for @submitOffer.
  ///
  /// In en, this message translates to:
  /// **'Submit Offer'**
  String get submitOffer;

  /// No description provided for @submitEnquiryButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Enquiry'**
  String get submitEnquiryButton;

  /// No description provided for @submitTestDriveRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Test Drive Request'**
  String get submitTestDriveRequest;

  /// No description provided for @enquiryFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Enquiry'**
  String get enquiryFormTitle;

  /// No description provided for @testDriveFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Test Drive'**
  String get testDriveFormTitle;

  /// No description provided for @priceNegotiationFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Negotiation'**
  String get priceNegotiationFormTitle;

  /// No description provided for @enquiryFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Submit your enquiry about this vehicle. We\'ll get back to you as soon as possible.'**
  String get enquiryFormDescription;

  /// No description provided for @testDriveFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Request a test drive for this vehicle. We\'ll get back to you as soon as possible to schedule your test drive.'**
  String get testDriveFormDescription;

  /// No description provided for @priceNegotiationFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Make an offer or negotiate the price for this vehicle. We\'ll get back to you as soon as possible.'**
  String get priceNegotiationFormDescription;

  /// No description provided for @pleaseLoginToSubmitEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Please login to submit an enquiry'**
  String get pleaseLoginToSubmitEnquiry;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get messageRequired;

  /// No description provided for @enquirySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your enquiry has been submitted successfully!'**
  String get enquirySuccessMessage;

  /// No description provided for @exchangeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your exchange request has been submitted successfully!'**
  String get exchangeSuccessMessage;

  /// No description provided for @testDriveSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your test drive request has been submitted successfully!'**
  String get testDriveSuccessMessage;

  /// No description provided for @priceNegotiationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your price negotiation has been submitted successfully!'**
  String get priceNegotiationSuccessMessage;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @vehiclesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vehicles'**
  String vehiclesCount(int count);

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @worth.
  ///
  /// In en, this message translates to:
  /// **'Worth'**
  String get worth;

  /// No description provided for @inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get inquiries;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete vehicle'**
  String get deleteVehicle;

  /// No description provided for @deleteVehicleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String deleteVehicleConfirm(String title);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @failedToLoadInquiries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inquiries: {error}'**
  String failedToLoadInquiries(String error);

  /// No description provided for @vehicleInquiries.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Inquiries'**
  String get vehicleInquiries;

  /// No description provided for @inquiryCountSingular.
  ///
  /// In en, this message translates to:
  /// **'1 inquiry for this vehicle'**
  String get inquiryCountSingular;

  /// No description provided for @inquiryCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} inquiries for this vehicle'**
  String inquiryCountPlural(int count);

  /// No description provided for @noInquiriesYet.
  ///
  /// In en, this message translates to:
  /// **'No inquiries yet'**
  String get noInquiriesYet;

  /// No description provided for @inquiryForVehicle.
  ///
  /// In en, this message translates to:
  /// **'Inquiry for {title}'**
  String inquiryForVehicle(String title);

  /// No description provided for @inquiry.
  ///
  /// In en, this message translates to:
  /// **'Inquiry'**
  String get inquiry;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @unpublish.
  ///
  /// In en, this message translates to:
  /// **'Unpublish'**
  String get unpublish;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @viewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String viewsCount(int count);

  /// No description provided for @inquiriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} inquiries'**
  String inquiriesCount(int count);

  /// No description provided for @inquiriesWithCount.
  ///
  /// In en, this message translates to:
  /// **'Inquiries ({count})'**
  String inquiriesWithCount(int count);

  /// No description provided for @findVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Vehicle'**
  String get findVehicleTitle;

  /// No description provided for @findVehicleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your license plate to auto-fill vehicle information'**
  String get findVehicleDescription;

  /// No description provided for @licensePlatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter license plate (e.g., AB12345)'**
  String get licensePlatePlaceholder;

  /// No description provided for @findVehicleButton.
  ///
  /// In en, this message translates to:
  /// **'Find Vehicle'**
  String get findVehicleButton;

  /// No description provided for @vehicleInfoLoadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle information loaded successfully! Review and complete the form below.'**
  String get vehicleInfoLoadedSuccess;

  /// No description provided for @sellSectionBasicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Vehicle Information'**
  String get sellSectionBasicInfoTitle;

  /// No description provided for @sellSectionBasicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Title, variant, and color'**
  String get sellSectionBasicInfoSubtitle;

  /// No description provided for @sellSectionBasicInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Basic information about your vehicle.'**
  String get sellSectionBasicInfoDescription;

  /// No description provided for @vehicleTitleAutoGenerated.
  ///
  /// In en, this message translates to:
  /// **'Vehicle title will be auto-generated'**
  String get vehicleTitleAutoGenerated;

  /// No description provided for @sellTitleHelp.
  ///
  /// In en, this message translates to:
  /// **'Vehicle title automatically generated from vehicle information.'**
  String get sellTitleHelp;

  /// No description provided for @sellVariantLabel.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get sellVariantLabel;

  /// No description provided for @selectVariant.
  ///
  /// In en, this message translates to:
  /// **'Select Variant'**
  String get selectVariant;

  /// No description provided for @sellVariantHelp.
  ///
  /// In en, this message translates to:
  /// **'Vehicle variant/trim level (automatically set based on model)'**
  String get sellVariantHelp;

  /// No description provided for @sellColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get sellColorLabel;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @sellColorHelp.
  ///
  /// In en, this message translates to:
  /// **'Vehicle exterior color'**
  String get sellColorHelp;

  /// No description provided for @brandRequired.
  ///
  /// In en, this message translates to:
  /// **'Brand *'**
  String get brandRequired;

  /// No description provided for @modelRequired.
  ///
  /// In en, this message translates to:
  /// **'Model *'**
  String get modelRequired;

  /// No description provided for @yearRequired.
  ///
  /// In en, this message translates to:
  /// **'Year *'**
  String get yearRequired;

  /// No description provided for @fuelTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type *'**
  String get fuelTypeRequired;

  /// No description provided for @sellSectionSpecsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Specifications'**
  String get sellSectionSpecsTitle;

  /// No description provided for @sellSectionSpecsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kilometer driven, registration, inspection, and technical details'**
  String get sellSectionSpecsSubtitle;

  /// No description provided for @sellSectionSpecsDescription.
  ///
  /// In en, this message translates to:
  /// **'Technical specifications and registration details.'**
  String get sellSectionSpecsDescription;

  /// No description provided for @kilometerDrivenRequired.
  ///
  /// In en, this message translates to:
  /// **'Kilometer Driven *'**
  String get kilometerDrivenRequired;

  /// No description provided for @kmDrivenRequired.
  ///
  /// In en, this message translates to:
  /// **'Kilometer driven is required'**
  String get kmDrivenRequired;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @selectGearType.
  ///
  /// In en, this message translates to:
  /// **'Select gear type'**
  String get selectGearType;

  /// No description provided for @firstRegistrationMonth.
  ///
  /// In en, this message translates to:
  /// **'First Registration Month'**
  String get firstRegistrationMonth;

  /// No description provided for @lastInspectionMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Inspection Month'**
  String get lastInspectionMonth;

  /// No description provided for @lastInspectionYear.
  ///
  /// In en, this message translates to:
  /// **'Last Inspection Year'**
  String get lastInspectionYear;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @electricRangeKm.
  ///
  /// In en, this message translates to:
  /// **'Electric Range (km)'**
  String get electricRangeKm;

  /// No description provided for @electricRange.
  ///
  /// In en, this message translates to:
  /// **'Electric Range'**
  String get electricRange;

  /// No description provided for @electricRangeOrKmPerL.
  ///
  /// In en, this message translates to:
  /// **'Electric Range / KM/L'**
  String get electricRangeOrKmPerL;

  /// No description provided for @kmPerL.
  ///
  /// In en, this message translates to:
  /// **'KM/L'**
  String get kmPerL;

  /// No description provided for @technicalTotalWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Total Technical Weight (kg)'**
  String get technicalTotalWeightKg;

  /// No description provided for @selectEuronom.
  ///
  /// In en, this message translates to:
  /// **'Select Euronom'**
  String get selectEuronom;

  /// No description provided for @euronom.
  ///
  /// In en, this message translates to:
  /// **'Euronom'**
  String get euronom;

  /// No description provided for @sellSectionEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment & Features'**
  String get sellSectionEquipmentTitle;

  /// No description provided for @sellSectionEquipmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the equipment your vehicle has'**
  String get sellSectionEquipmentSubtitle;

  /// No description provided for @sellSectionEquipmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the equipment and features your vehicle has. This helps buyers find exactly what they\'re looking for.'**
  String get sellSectionEquipmentDescription;

  /// No description provided for @equipmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipmentOther;

  /// No description provided for @servicebog.
  ///
  /// In en, this message translates to:
  /// **'Servicebog'**
  String get servicebog;

  /// No description provided for @sellDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sellDefault;

  /// No description provided for @servicebogHelp.
  ///
  /// In en, this message translates to:
  /// **'Does the vehicle have a service book?'**
  String get servicebogHelp;

  /// No description provided for @sellSectionPricingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Tax'**
  String get sellSectionPricingTitle;

  /// No description provided for @sellSectionPricingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Price and tax information'**
  String get sellSectionPricingSubtitle;

  /// No description provided for @priceDkkRequired.
  ///
  /// In en, this message translates to:
  /// **'Price (DKK) *'**
  String get priceDkkRequired;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequired;

  /// No description provided for @taxInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax Information Based on Mileage'**
  String get taxInfoTitle;

  /// No description provided for @taxInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Tax information based on mileage - To be implemented after consulting with Berken.'**
  String get taxInfoDescription;

  /// No description provided for @sellSectionPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get sellSectionPhotosTitle;

  /// No description provided for @sellSectionPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your vehicle'**
  String get sellSectionPhotosSubtitle;

  /// No description provided for @sellSectionPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your vehicle. Good photos help your listing sell faster! You can select multiple images.'**
  String get sellSectionPhotosDescription;

  /// No description provided for @uploadText.
  ///
  /// In en, this message translates to:
  /// **'Click to upload or drag and drop'**
  String get uploadText;

  /// No description provided for @uploadHint.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG, GIF up to 20MB each'**
  String get uploadHint;

  /// No description provided for @selectedImages.
  ///
  /// In en, this message translates to:
  /// **'Selected Images'**
  String get selectedImages;

  /// No description provided for @selectedImagesCount.
  ///
  /// In en, this message translates to:
  /// **'Selected Images ({count})'**
  String selectedImagesCount(int count);

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @sellSectionDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sellSectionDescriptionTitle;

  /// No description provided for @sellSectionDescriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle description'**
  String get sellSectionDescriptionSubtitle;

  /// No description provided for @sellSectionDescriptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a description of your vehicle for potential buyers.'**
  String get sellSectionDescriptionDescription;

  /// No description provided for @enterVehicleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle description...'**
  String get enterVehicleDescription;

  /// No description provided for @describeYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Describe your vehicle'**
  String get describeYourVehicle;

  /// No description provided for @sellSectionSellerTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller Information'**
  String get sellSectionSellerTitle;

  /// No description provided for @sellSectionSellerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your contact details'**
  String get sellSectionSellerSubtitle;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @postalCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal code is required'**
  String get postalCodeRequired;

  /// No description provided for @postalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCodeLabel;

  /// No description provided for @yourAddress.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get yourAddress;

  /// No description provided for @sellSectionPackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get sellSectionPackagesTitle;

  /// No description provided for @sellSectionPackagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a package for your listing'**
  String get sellSectionPackagesSubtitle;

  /// No description provided for @selectPackageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a package to enhance your vehicle listing. Each package includes different features.'**
  String get selectPackageDescription;

  /// No description provided for @readyToPublish.
  ///
  /// In en, this message translates to:
  /// **'Ready to publish your listing?'**
  String get readyToPublish;

  /// No description provided for @readyToPublishDescription.
  ///
  /// In en, this message translates to:
  /// **'Review your information and click the button below to publish your vehicle listing.'**
  String get readyToPublishDescription;

  /// No description provided for @publishVehicleListing.
  ///
  /// In en, this message translates to:
  /// **'Publish Vehicle Listing'**
  String get publishVehicleListing;

  /// No description provided for @noEquipmentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No equipment available'**
  String get noEquipmentAvailable;

  /// No description provided for @noPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plans available'**
  String get noPlansAvailable;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @locationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSection;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @conditionAndHistory.
  ///
  /// In en, this message translates to:
  /// **'Condition & history'**
  String get conditionAndHistory;

  /// No description provided for @technicalSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Technical specifications'**
  String get technicalSpecifications;

  /// No description provided for @co2Emission.
  ///
  /// In en, this message translates to:
  /// **'CO₂ emission'**
  String get co2Emission;

  /// No description provided for @electricalConsumption.
  ///
  /// In en, this message translates to:
  /// **'Electrical consumption'**
  String get electricalConsumption;

  /// No description provided for @noxEmission.
  ///
  /// In en, this message translates to:
  /// **'NOx emission'**
  String get noxEmission;

  /// No description provided for @fuelConsumptionWltp.
  ///
  /// In en, this message translates to:
  /// **'Fuel consumption (WLTP)'**
  String get fuelConsumptionWltp;

  /// No description provided for @fuelConsumptionNedc.
  ///
  /// In en, this message translates to:
  /// **'Fuel consumption (NEDC)'**
  String get fuelConsumptionNedc;

  /// No description provided for @measurementNorm.
  ///
  /// In en, this message translates to:
  /// **'Measurement norm'**
  String get measurementNorm;

  /// No description provided for @productionDate.
  ///
  /// In en, this message translates to:
  /// **'Production date'**
  String get productionDate;

  /// No description provided for @enginePowerKw.
  ///
  /// In en, this message translates to:
  /// **'Engine power (kW)'**
  String get enginePowerKw;

  /// No description provided for @engineTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine type'**
  String get engineTypeLabel;

  /// No description provided for @engineDisplacementLitres.
  ///
  /// In en, this message translates to:
  /// **'Engine displacement (L)'**
  String get engineDisplacementLitres;

  /// No description provided for @gearCount.
  ///
  /// In en, this message translates to:
  /// **'Gears'**
  String get gearCount;

  /// No description provided for @particleFilter.
  ///
  /// In en, this message translates to:
  /// **'Particle filter'**
  String get particleFilter;

  /// No description provided for @registrationStatusDmr.
  ///
  /// In en, this message translates to:
  /// **'Registration status (DMR)'**
  String get registrationStatusDmr;

  /// No description provided for @lastRegistrationChange.
  ///
  /// In en, this message translates to:
  /// **'Last registration change'**
  String get lastRegistrationChange;

  /// No description provided for @dealerInformation.
  ///
  /// In en, this message translates to:
  /// **'Dealer information'**
  String get dealerInformation;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactName;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cvr.
  ///
  /// In en, this message translates to:
  /// **'CVR'**
  String get cvr;

  /// No description provided for @dealerOnlyPricing.
  ///
  /// In en, this message translates to:
  /// **'Dealer pricing'**
  String get dealerOnlyPricing;

  /// No description provided for @wholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Wholesale price'**
  String get wholesalePrice;

  /// No description provided for @internalCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Internal cost price'**
  String get internalCostPrice;

  /// No description provided for @priceExcludingTax.
  ///
  /// In en, this message translates to:
  /// **'Price excluding tax'**
  String get priceExcludingTax;

  /// No description provided for @wholesaleIncludesDelivery.
  ///
  /// In en, this message translates to:
  /// **'Wholesale includes delivery'**
  String get wholesaleIncludesDelivery;

  /// No description provided for @listingPhone.
  ///
  /// In en, this message translates to:
  /// **'Listing phone'**
  String get listingPhone;

  /// No description provided for @vehicleLocation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle location'**
  String get vehicleLocation;

  /// No description provided for @importVehicle.
  ///
  /// In en, this message translates to:
  /// **'Import vehicle'**
  String get importVehicle;

  /// No description provided for @visitDealerPage.
  ///
  /// In en, this message translates to:
  /// **'Visit dealer page'**
  String get visitDealerPage;

  /// No description provided for @seeAllDealerVehicles.
  ///
  /// In en, this message translates to:
  /// **'See all vehicles from this dealer'**
  String get seeAllDealerVehicles;

  /// No description provided for @leasingType.
  ///
  /// In en, this message translates to:
  /// **'Leasing type'**
  String get leasingType;

  /// No description provided for @leasingCustomerType.
  ///
  /// In en, this message translates to:
  /// **'Customer type'**
  String get leasingCustomerType;

  /// No description provided for @leasingMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get leasingMonthlyPayment;

  /// No description provided for @leasingFirstPayment.
  ///
  /// In en, this message translates to:
  /// **'First payment'**
  String get leasingFirstPayment;

  /// No description provided for @leasingResidualValue.
  ///
  /// In en, this message translates to:
  /// **'Residual value'**
  String get leasingResidualValue;

  /// No description provided for @leasingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (months)'**
  String get leasingDuration;

  /// No description provided for @leasingAnnualMileage.
  ///
  /// In en, this message translates to:
  /// **'Annual mileage'**
  String get leasingAnnualMileage;

  /// No description provided for @leasingTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get leasingTotalCost;

  /// No description provided for @specificationCount.
  ///
  /// In en, this message translates to:
  /// **'{name} (×{count})'**
  String specificationCount(String name, int count);

  /// No description provided for @consumptionPer100km.
  ///
  /// In en, this message translates to:
  /// **'l/100 km'**
  String get consumptionPer100km;

  /// No description provided for @consumptionLPer100kmSuffix.
  ///
  /// In en, this message translates to:
  /// **'L/100km'**
  String get consumptionLPer100kmSuffix;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registrationNumber;

  /// No description provided for @vinNumber.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vinNumber;
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
      <String>['da', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
