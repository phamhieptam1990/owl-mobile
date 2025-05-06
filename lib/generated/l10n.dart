// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `See All`
  String get seeAll {
    return Intl.message('See All', name: 'seeAll', desc: '', args: []);
  }

  /// `Feature Products`
  String get featureProducts {
    return Intl.message(
      'Feature Products',
      name: 'featureProducts',
      desc: '',
      args: [],
    );
  }

  /// `Gears Collections`
  String get bagsCollections {
    return Intl.message(
      'Gears Collections',
      name: 'bagsCollections',
      desc: '',
      args: [],
    );
  }

  /// `Woman Collections`
  String get womanCollections {
    return Intl.message(
      'Woman Collections',
      name: 'womanCollections',
      desc: '',
      args: [],
    );
  }

  /// `Man Collections`
  String get manCollections {
    return Intl.message(
      'Man Collections',
      name: 'manCollections',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message('Buy Now', name: 'buyNow', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message('Add To Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Yêu Cầu QL`
  String get plannedDashboard {
    return Intl.message(
      'Yêu Cầu QL',
      name: 'plannedDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Chưa hoàn tất`
  String get undone {
    return Intl.message('Chưa hoàn tất', name: 'undone', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Reviews`
  String get readReviews {
    return Intl.message('Reviews', name: 'readReviews', desc: '', args: []);
  }

  /// `Additional Information`
  String get additionalInformation {
    return Intl.message(
      'Additional Information',
      name: 'additionalInformation',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews`
  String get noReviews {
    return Intl.message('No Reviews', name: 'noReviews', desc: '', args: []);
  }

  /// `The product is added`
  String get productAdded {
    return Intl.message(
      'The product is added',
      name: 'productAdded',
      desc: '',
      args: [],
    );
  }

  /// `You might also like`
  String get youMightAlsoLike {
    return Intl.message(
      'You might also like',
      name: 'youMightAlsoLike',
      desc: '',
      args: [],
    );
  }

  /// `Select the size`
  String get selectTheSize {
    return Intl.message(
      'Select the size',
      name: 'selectTheSize',
      desc: '',
      args: [],
    );
  }

  /// `Select the color`
  String get selectTheColor {
    return Intl.message(
      'Select the color',
      name: 'selectTheColor',
      desc: '',
      args: [],
    );
  }

  /// `Select the quantity`
  String get selectTheQuantity {
    return Intl.message(
      'Select the quantity',
      name: 'selectTheQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `My Cart`
  String get myCart {
    return Intl.message('My Cart', name: 'myCart', desc: '', args: []);
  }

  /// `Save to Wishlist`
  String get saveToWishList {
    return Intl.message(
      'Save to Wishlist',
      name: 'saveToWishList',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Clear Cart`
  String get clearCart {
    return Intl.message('Clear Cart', name: 'clearCart', desc: '', args: []);
  }

  /// `My Wishlist`
  String get myWishList {
    return Intl.message('My Wishlist', name: 'myWishList', desc: '', args: []);
  }

  /// `Your bag is empty`
  String get yourBagIsEmpty {
    return Intl.message(
      'Your bag is empty',
      name: 'yourBagIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you haven’t added any items to the bag yet. Start shopping to fill it in.`
  String get emptyCartSubtitle {
    return Intl.message(
      'Looks like you haven’t added any items to the bag yet. Start shopping to fill it in.',
      name: 'emptyCartSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start Shopping`
  String get startShopping {
    return Intl.message(
      'Start Shopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `No favourites yet.`
  String get noFavoritesYet {
    return Intl.message(
      'No favourites yet.',
      name: 'noFavoritesYet',
      desc: '',
      args: [],
    );
  }

  /// `Tap any heart next to a product to favotite. We’ll save them for you here!`
  String get emptyWishlistSubtitle {
    return Intl.message(
      'Tap any heart next to a product to favotite. We’ll save them for you here!',
      name: 'emptyWishlistSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Search for Items`
  String get searchForItems {
    return Intl.message(
      'Search for Items',
      name: 'searchForItems',
      desc: '',
      args: [],
    );
  }

  /// `Shipping`
  String get shipping {
    return Intl.message('Shipping', name: 'shipping', desc: '', args: []);
  }

  /// `preview`
  String get review {
    return Intl.message('preview', name: 'review', desc: '', args: []);
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `State / Province`
  String get stateProvince {
    return Intl.message(
      'State / Province',
      name: 'stateProvince',
      desc: '',
      args: [],
    );
  }

  /// `Zip-code`
  String get zipCode {
    return Intl.message('Zip-code', name: 'zipCode', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Street Name`
  String get streetName {
    return Intl.message('Street Name', name: 'streetName', desc: '', args: []);
  }

  /// `Shipping Method`
  String get shippingMethod {
    return Intl.message(
      'Shipping Method',
      name: 'shippingMethod',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Shipping`
  String get continueToShipping {
    return Intl.message(
      'Continue to Shipping',
      name: 'continueToShipping',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Review`
  String get continueToReview {
    return Intl.message(
      'Continue to Review',
      name: 'continueToReview',
      desc: '',
      args: [],
    );
  }

  /// `Continue to Payment`
  String get continueToPayment {
    return Intl.message(
      'Continue to Payment',
      name: 'continueToPayment',
      desc: '',
      args: [],
    );
  }

  /// `Go back to address`
  String get goBackToAddress {
    return Intl.message(
      'Go back to address',
      name: 'goBackToAddress',
      desc: '',
      args: [],
    );
  }

  /// `Go back to shipping`
  String get goBackToShipping {
    return Intl.message(
      'Go back to shipping',
      name: 'goBackToShipping',
      desc: '',
      args: [],
    );
  }

  /// `Go back to review`
  String get goBackToReview {
    return Intl.message(
      'Go back to review',
      name: 'goBackToReview',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Shipping Address`
  String get shippingAddress {
    return Intl.message(
      'Shipping Address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Order details`
  String get orderDetail {
    return Intl.message(
      'Order details',
      name: 'orderDetail',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Payment Methods`
  String get paymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Choose your payment method`
  String get chooseYourPaymentMethod {
    return Intl.message(
      'Choose your payment method',
      name: 'chooseYourPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Place My Order`
  String get placeMyOrder {
    return Intl.message(
      'Place My Order',
      name: 'placeMyOrder',
      desc: '',
      args: [],
    );
  }

  /// `It's ordered!`
  String get itsOrdered {
    return Intl.message(
      'It\'s ordered!',
      name: 'itsOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Order No.`
  String get orderNo {
    return Intl.message('Order No.', name: 'orderNo', desc: '', args: []);
  }

  /// `Show All My Ordered`
  String get showAllMyOrdered {
    return Intl.message(
      'Show All My Ordered',
      name: 'showAllMyOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Back to Shop`
  String get backToShop {
    return Intl.message('Back to Shop', name: 'backToShop', desc: '', args: []);
  }

  /// `The first name field is required`
  String get firstNameIsRequired {
    return Intl.message(
      'The first name field is required',
      name: 'firstNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The last name field is required`
  String get lastNameIsRequired {
    return Intl.message(
      'The last name field is required',
      name: 'lastNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The street name field is required`
  String get streetIsRequired {
    return Intl.message(
      'The street name field is required',
      name: 'streetIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The city field is required`
  String get cityIsRequired {
    return Intl.message(
      'The city field is required',
      name: 'cityIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The state field is required`
  String get stateIsRequired {
    return Intl.message(
      'The state field is required',
      name: 'stateIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The country field is required`
  String get countryIsRequired {
    return Intl.message(
      'The country field is required',
      name: 'countryIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The phone number field is required`
  String get phoneIsRequired {
    return Intl.message(
      'The phone number field is required',
      name: 'phoneIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The email field is required`
  String get emailIsRequired {
    return Intl.message(
      'The email field is required',
      name: 'emailIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The zip code field is required`
  String get zipCodeIsRequired {
    return Intl.message(
      'The zip code field is required',
      name: 'zipCodeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `No Orders`
  String get noOrders {
    return Intl.message('No Orders', name: 'noOrders', desc: '', args: []);
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message('Order Date', name: 'orderDate', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get orderHistory {
    return Intl.message(
      'Order History',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `Refund Request`
  String get refundRequest {
    return Intl.message(
      'Refund Request',
      name: 'refundRequest',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get recentSearches {
    return Intl.message('History', name: 'recentSearches', desc: '', args: []);
  }

  /// `Recent`
  String get recents {
    return Intl.message('Recent', name: 'recents', desc: '', args: []);
  }

  /// `By Price`
  String get byPrice {
    return Intl.message('By Price', name: 'byPrice', desc: '', args: []);
  }

  /// `By Category`
  String get byCategory {
    return Intl.message('By Category', name: 'byCategory', desc: '', args: []);
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `General Setting`
  String get generalSetting {
    return Intl.message(
      'General Setting',
      name: 'generalSetting',
      desc: '',
      args: [],
    );
  }

  /// `Get Notification`
  String get getNotification {
    return Intl.message(
      'Get Notification',
      name: 'getNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notify Messages`
  String get listMessages {
    return Intl.message(
      'Notify Messages',
      name: 'listMessages',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `Rate the app`
  String get rateTheApp {
    return Intl.message('Rate the app', name: 'rateTheApp', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `LogIn`
  String get login {
    return Intl.message('LogIn', name: 'login', desc: '', args: []);
  }

  /// `items`
  String get items {
    return Intl.message('items', name: 'items', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Shop`
  String get shop {
    return Intl.message('Shop', name: 'shop', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Blog`
  String get blog {
    return Intl.message('Blog', name: 'blog', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Sign in with email`
  String get signInWithEmail {
    return Intl.message(
      'Sign in with email',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message('Sign up', name: 'signup', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Please input fill in all fields`
  String get pleaseInput {
    return Intl.message(
      'Please input fill in all fields',
      name: 'pleaseInput',
      desc: '',
      args: [],
    );
  }

  /// `Searching Address`
  String get searchingAddress {
    return Intl.message(
      'Searching Address',
      name: 'searchingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Out of stock`
  String get outOfStock {
    return Intl.message('Out of stock', name: 'outOfStock', desc: '', args: []);
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message('Unavailable', name: 'unavailable', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `No Product`
  String get noProduct {
    return Intl.message('No Product', name: 'noProduct', desc: '', args: []);
  }

  /// `We found {length} products`
  String weFoundProducts(Object length) {
    return Intl.message(
      'We found $length products',
      name: 'weFoundProducts',
      desc: '',
      args: [length],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Your Recent View`
  String get recentView {
    return Intl.message(
      'Your Recent View',
      name: 'recentView',
      desc: '',
      args: [],
    );
  }

  /// `In stock`
  String get inStock {
    return Intl.message('In stock', name: 'inStock', desc: '', args: []);
  }

  /// `Tracking number is`
  String get trackingNumberIs {
    return Intl.message(
      'Tracking number is',
      name: 'trackingNumberIs',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Tracking page`
  String get trackingPage {
    return Intl.message(
      'Tracking page',
      name: 'trackingPage',
      desc: '',
      args: [],
    );
  }

  /// `My points`
  String get myPoints {
    return Intl.message('My points', name: 'myPoints', desc: '', args: []);
  }

  /// `You have $point points`
  String get youHavePoints {
    return Intl.message(
      'You have \$point points',
      name: 'youHavePoints',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Point`
  String get point {
    return Intl.message('Point', name: 'point', desc: '', args: []);
  }

  /// `Order notes`
  String get orderNotes {
    return Intl.message('Order notes', name: 'orderNotes', desc: '', args: []);
  }

  /// `Please rating before you send your comment`
  String get ratingFirst {
    return Intl.message(
      'Please rating before you send your comment',
      name: 'ratingFirst',
      desc: '',
      args: [],
    );
  }

  /// `Please write your comment`
  String get commentFirst {
    return Intl.message(
      'Please write your comment',
      name: 'commentFirst',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment`
  String get writeComment {
    return Intl.message(
      'Write your comment',
      name: 'writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Your rating`
  String get productRating {
    return Intl.message(
      'Your rating',
      name: 'productRating',
      desc: '',
      args: [],
    );
  }

  /// `Layouts`
  String get layout {
    return Intl.message('Layouts', name: 'layout', desc: '', args: []);
  }

  /// `Select Address`
  String get selectAddress {
    return Intl.message(
      'Select Address',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get saveAddress {
    return Intl.message(
      'Save Address',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please write input in search field`
  String get searchInput {
    return Intl.message(
      'Please write input in search field',
      name: 'searchInput',
      desc: '',
      args: [],
    );
  }

  /// `Total tax`
  String get totalTax {
    return Intl.message('Total tax', name: 'totalTax', desc: '', args: []);
  }

  /// `Invalid SMS Verification code`
  String get invalidSMSCode {
    return Intl.message(
      'Invalid SMS Verification code',
      name: 'invalidSMSCode',
      desc: '',
      args: [],
    );
  }

  /// `Get code`
  String get sendSMSCode {
    return Intl.message('Get code', name: 'sendSMSCode', desc: '', args: []);
  }

  /// `Verify`
  String get verifySMSCode {
    return Intl.message('Verify', name: 'verifySMSCode', desc: '', args: []);
  }

  /// `Show Gallery`
  String get showGallery {
    return Intl.message(
      'Show Gallery',
      name: 'showGallery',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `I want to create an account`
  String get iwantToCreateAccount {
    return Intl.message(
      'I want to create an account',
      name: 'iwantToCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Coupon code`
  String get couponCode {
    return Intl.message('Coupon code', name: 'couponCode', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Congratulations! Coupon code applied successfully`
  String get couponMsgSuccess {
    return Intl.message(
      'Congratulations! Coupon code applied successfully',
      name: 'couponMsgSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Your address is exist in your local`
  String get saveAddressSuccess {
    return Intl.message(
      'Your address is exist in your local',
      name: 'saveAddressSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Your note`
  String get yourNote {
    return Intl.message('Your note', name: 'yourNote', desc: '', args: []);
  }

  /// `Write your note`
  String get writeYourNote {
    return Intl.message(
      'Write your note',
      name: 'writeYourNote',
      desc: '',
      args: [],
    );
  }

  /// `You've successfully placed the order`
  String get orderSuccessTitle1 {
    return Intl.message(
      'You\'ve successfully placed the order',
      name: 'orderSuccessTitle1',
      desc: '',
      args: [],
    );
  }

  /// `You can check status of your order by using our delivery status feature. You will receive an order confirmation e-mail with details of your order and a link to track its progress.`
  String get orderSuccessMsg1 {
    return Intl.message(
      'You can check status of your order by using our delivery status feature. You will receive an order confirmation e-mail with details of your order and a link to track its progress.',
      name: 'orderSuccessMsg1',
      desc: '',
      args: [],
    );
  }

  /// `Your account`
  String get orderSuccessTitle2 {
    return Intl.message(
      'Your account',
      name: 'orderSuccessTitle2',
      desc: '',
      args: [],
    );
  }

  /// `You can log to your account using e-mail and password defined earlier. On your account you can edit your profile data, check history of transactions, edit subscription to newsletter.`
  String get orderSuccessMsg2 {
    return Intl.message(
      'You can log to your account using e-mail and password defined earlier. On your account you can edit your profile data, check history of transactions, edit subscription to newsletter.',
      name: 'orderSuccessMsg2',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Currencies`
  String get currencies {
    return Intl.message('Currencies', name: 'currencies', desc: '', args: []);
  }

  /// `Sale {percent} %`
  String sale(Object percent) {
    return Intl.message(
      'Sale $percent %',
      name: 'sale',
      desc: '',
      args: [percent],
    );
  }

  /// `Update Profile`
  String get updateUserInfor {
    return Intl.message(
      'Update Profile',
      name: 'updateUserInfor',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Display name`
  String get displayName {
    return Intl.message(
      'Display name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Nice name`
  String get niceName {
    return Intl.message('Nice name', name: 'niceName', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Vietnam`
  String get vietnamese {
    return Intl.message('Vietnam', name: 'vietnamese', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Spanish`
  String get spanish {
    return Intl.message('Spanish', name: 'spanish', desc: '', args: []);
  }

  /// `Chinese`
  String get chinese {
    return Intl.message('Chinese', name: 'chinese', desc: '', args: []);
  }

  /// `Japanese`
  String get japanese {
    return Intl.message('Japanese', name: 'japanese', desc: '', args: []);
  }

  /// `The Language is updated successfully`
  String get languageSuccess {
    return Intl.message(
      'The Language is updated successfully',
      name: 'languageSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Privacy and Term`
  String get agreeWithPrivacy {
    return Intl.message(
      'Privacy and Term',
      name: 'agreeWithPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy and Term`
  String get PrivacyAndTerm {
    return Intl.message(
      'Privacy and Term',
      name: 'PrivacyAndTerm',
      desc: '',
      args: [],
    );
  }

  /// `I agree with`
  String get iAgree {
    return Intl.message('I agree with', name: 'iAgree', desc: '', args: []);
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `have been added to your cart`
  String get addToCartSucessfully {
    return Intl.message(
      'have been added to your cart',
      name: 'addToCartSucessfully',
      desc: '',
      args: [],
    );
  }

  /// `Pull to Load more`
  String get pullToLoadMore {
    return Intl.message(
      'Pull to Load more',
      name: 'pullToLoadMore',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed!`
  String get loadFail {
    return Intl.message('Load Failed!', name: 'loadFail', desc: '', args: []);
  }

  /// `Release to load more`
  String get releaseToLoadMore {
    return Intl.message(
      'Release to load more',
      name: 'releaseToLoadMore',
      desc: '',
      args: [],
    );
  }

  /// `No more Data`
  String get noData {
    return Intl.message('No more Data', name: 'noData', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Attributes`
  String get attributes {
    return Intl.message('Attributes', name: 'attributes', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get resetYourPassword {
    return Intl.message(
      'Reset Your Password',
      name: 'resetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your username or email`
  String get yourUsernameEmail {
    return Intl.message(
      'Your username or email',
      name: 'yourUsernameEmail',
      desc: '',
      args: [],
    );
  }

  /// `Get password link`
  String get getPasswordLink {
    return Intl.message(
      'Get password link',
      name: 'getPasswordLink',
      desc: '',
      args: [],
    );
  }

  /// `Check your email for confirmation link`
  String get checkConfirmLink {
    return Intl.message(
      'Check your email for confirmation link',
      name: 'checkConfirmLink',
      desc: '',
      args: [],
    );
  }

  /// `Username/Email is empty`
  String get emptyUsername {
    return Intl.message(
      'Username/Email is empty',
      name: 'emptyUsername',
      desc: '',
      args: [],
    );
  }

  /// `Romanian`
  String get romanian {
    return Intl.message('Romanian', name: 'romanian', desc: '', args: []);
  }

  /// `Turkish`
  String get turkish {
    return Intl.message('Turkish', name: 'turkish', desc: '', args: []);
  }

  /// `Italian`
  String get italian {
    return Intl.message('Italian', name: 'italian', desc: '', args: []);
  }

  /// `Indonesiana`
  String get indonesian {
    return Intl.message('Indonesiana', name: 'indonesian', desc: '', args: []);
  }

  /// `German`
  String get german {
    return Intl.message('German', name: 'german', desc: '', args: []);
  }

  /// `Your coupon code is invalid`
  String get couponInvalid {
    return Intl.message(
      'Your coupon code is invalid',
      name: 'couponInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Featured`
  String get featured {
    return Intl.message('Featured', name: 'featured', desc: '', args: []);
  }

  /// `On Sale`
  String get onSale {
    return Intl.message('On Sale', name: 'onSale', desc: '', args: []);
  }

  /// `Please checking internet connection!`
  String get pleaseCheckInternet {
    return Intl.message(
      'Please checking internet connection!',
      name: 'pleaseCheckInternet',
      desc: '',
      args: [],
    );
  }

  /// `Cannot launch this app, make sure your settings on config.dart is correct`
  String get canNotLaunch {
    return Intl.message(
      'Cannot launch this app, make sure your settings on config.dart is correct',
      name: 'canNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Billing Address`
  String get billingAddress {
    return Intl.message(
      'Billing Address',
      name: 'billingAddress',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit an App`
  String get doYouWantToExitApp {
    return Intl.message(
      'Do you want to exit an App',
      name: 'doYouWantToExitApp',
      desc: '',
      args: [],
    );
  }

  /// `Shopping cart, {totalCartQuantity} items`
  String shoppingCartItems(Object totalCartQuantity) {
    return Intl.message(
      'Shopping cart, $totalCartQuantity items',
      name: 'shoppingCartItems',
      desc: '',
      args: [totalCartQuantity],
    );
  }

  /// `On-hold`
  String get orderStatusOnHold {
    return Intl.message(
      'On-hold',
      name: 'orderStatusOnHold',
      desc: '',
      args: [],
    );
  }

  /// `Pending Payment`
  String get orderStatusPendingPayment {
    return Intl.message(
      'Pending Payment',
      name: 'orderStatusPendingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get orderStatusFailed {
    return Intl.message(
      'Failed',
      name: 'orderStatusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get orderStatusProcessing {
    return Intl.message(
      'Processing',
      name: 'orderStatusProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get orderStatusCompleted {
    return Intl.message(
      'Completed',
      name: 'orderStatusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get orderStatusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'orderStatusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get orderStatusRefunded {
    return Intl.message(
      'Refunded',
      name: 'orderStatusRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Please fill your code`
  String get pleaseFillCode {
    return Intl.message(
      'Please fill your code',
      name: 'pleaseFillCode',
      desc: '',
      args: [],
    );
  }

  /// `Warning: {message}`
  String warning(Object message) {
    return Intl.message(
      'Warning: $message',
      name: 'warning',
      desc: '',
      args: [message],
    );
  }

  /// `{itemCount} items`
  String nItems(Object itemCount) {
    return Intl.message(
      '$itemCount items',
      name: 'nItems',
      desc: '',
      args: [itemCount],
    );
  }

  /// `Data Empty`
  String get dataEmpty {
    return Intl.message('Data Empty', name: 'dataEmpty', desc: '', args: []);
  }

  /// `Your address is exist in your local`
  String get yourAddressExistYourLocal {
    return Intl.message(
      'Your address is exist in your local',
      name: 'yourAddressExistYourLocal',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message('Ok', name: 'ok', desc: '', args: []);
  }

  /// `You have been save address in your local`
  String get youHaveBeenSaveAddressYourLocal {
    return Intl.message(
      'You have been save address in your local',
      name: 'youHaveBeenSaveAddressYourLocal',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `This platform is not support for webview`
  String get thisPlatformNotSupportWebview {
    return Intl.message(
      'This platform is not support for webview',
      name: 'thisPlatformNotSupportWebview',
      desc: '',
      args: [],
    );
  }

  /// `No back history item`
  String get noBackHistoryItem {
    return Intl.message(
      'No back history item',
      name: 'noBackHistoryItem',
      desc: '',
      args: [],
    );
  }

  /// `No forward history item`
  String get noForwardHistoryItem {
    return Intl.message(
      'No forward history item',
      name: 'noForwardHistoryItem',
      desc: '',
      args: [],
    );
  }

  /// `dateBooking`
  String get dateBooking {
    return Intl.message('dateBooking', name: 'dateBooking', desc: '', args: []);
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Added Successfully`
  String get addedSuccessfully {
    return Intl.message(
      'Added Successfully',
      name: 'addedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get notFound {
    return Intl.message('Not Found', name: 'notFound', desc: '', args: []);
  }

  /// `Error: {message}`
  String error(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'error',
      desc: '',
      args: [message],
    );
  }

  /// `Go back to home page`
  String get goBackHomePage {
    return Intl.message(
      'Go back to home page',
      name: 'goBackHomePage',
      desc: '',
      args: [],
    );
  }

  /// `Opps, the blog seems no longer exist`
  String get noBlog {
    return Intl.message(
      'Opps, the blog seems no longer exist',
      name: 'noBlog',
      desc: '',
      args: [],
    );
  }

  /// `Prev`
  String get prev {
    return Intl.message('Prev', name: 'prev', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `No thanks`
  String get noThanks {
    return Intl.message('No thanks', name: 'noThanks', desc: '', args: []);
  }

  /// `Maybe Later`
  String get maybeLater {
    return Intl.message('Maybe Later', name: 'maybeLater', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Phone Number Verification`
  String get phoneNumberVerification {
    return Intl.message(
      'Phone Number Verification',
      name: 'phoneNumberVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to`
  String get enterSendedCode {
    return Intl.message(
      'Enter the code sent to',
      name: 'enterSendedCode',
      desc: '',
      args: [],
    );
  }

  /// `*Please fill up all the cells properly`
  String get pleasefillUpAllCellsProperly {
    return Intl.message(
      '*Please fill up all the cells properly',
      name: 'pleasefillUpAllCellsProperly',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code? `
  String get didntReceiveCode {
    return Intl.message(
      'Didn\'t receive the code? ',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// ` RESEND`
  String get resend {
    return Intl.message(' RESEND', name: 'resend', desc: '', args: []);
  }

  /// `Please input fill in all fields`
  String get pleaseInputFillAllFields {
    return Intl.message(
      'Please input fill in all fields',
      name: 'pleaseInputFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Please agree with our terms`
  String get pleaseAgreeTerms {
    return Intl.message(
      'Please agree with our terms',
      name: 'pleaseAgreeTerms',
      desc: '',
      args: [],
    );
  }

  /// `Under Vietnamese lawssss, users’ information such as names, email addresses, passwords and date of birth could be classified as “personal information.\n\n In particular,\n (a) Under Decree 72/2013, personal information is defined as information  which  is  attached  to  the  identification  of  the  identity  and personal  details  of  an  individual  including name,  age,  address,  people's  identity  card  number, telephone number, email address and other information as stipulated by law\n\n (b) Under Circular 25/2010,  personal information means information sufficient to precisely identify an individual, which includes at least one of the following details: full name, birth date, occupation, title, contact address, email address, telephone number, identity card number and passport number. Information of personal privacy includes health record, tax payment record, social insurance card number, credit card number and other personal secrets.\n\n Circular 25 applies to the collection and use of personal information by websites operated by Vietnamese Government authorities. Circular 25 is not directly applicable to the collection and use of personal information by websites operated by non-Government entities. However, the provisions of Circular 25 could be applied by analogy. In addition, it is likely that a non-Government entity will be subject to the same or more stringent standards than those applicable to a Government entity.`
  String get privacyTerms {
    return Intl.message(
      'Under Vietnamese lawssss, users’ information such as names, email addresses, passwords and date of birth could be classified as “personal information.\n\n In particular,\n (a) Under Decree 72/2013, personal information is defined as information  which  is  attached  to  the  identification  of  the  identity  and personal  details  of  an  individual  including name,  age,  address,  people\'s  identity  card  number, telephone number, email address and other information as stipulated by law\n\n (b) Under Circular 25/2010,  personal information means information sufficient to precisely identify an individual, which includes at least one of the following details: full name, birth date, occupation, title, contact address, email address, telephone number, identity card number and passport number. Information of personal privacy includes health record, tax payment record, social insurance card number, credit card number and other personal secrets.\n\n Circular 25 applies to the collection and use of personal information by websites operated by Vietnamese Government authorities. Circular 25 is not directly applicable to the collection and use of personal information by websites operated by non-Government entities. However, the provisions of Circular 25 could be applied by analogy. In addition, it is likely that a non-Government entity will be subject to the same or more stringent standards than those applicable to a Government entity.',
      name: 'privacyTerms',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get url {
    return Intl.message('URL', name: 'url', desc: '', args: []);
  }

  /// `Nearby Places`
  String get nearbyPlaces {
    return Intl.message(
      'Nearby Places',
      name: 'nearbyPlaces',
      desc: '',
      args: [],
    );
  }

  /// `No Result Found`
  String get noResultFound {
    return Intl.message(
      'No Result Found',
      name: 'noResultFound',
      desc: '',
      args: [],
    );
  }

  /// `Search Place`
  String get searchPlace {
    return Intl.message(
      'Search Place',
      name: 'searchPlace',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select this location`
  String get tapSelectLocation {
    return Intl.message(
      'Tap to select this location',
      name: 'tapSelectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Brazil`
  String get brazil {
    return Intl.message('Brazil', name: 'brazil', desc: '', args: []);
  }

  /// `On backorder`
  String get backOrder {
    return Intl.message('On backorder', name: 'backOrder', desc: '', args: []);
  }

  /// `French`
  String get french {
    return Intl.message('French', name: 'french', desc: '', args: []);
  }

  /// `Value is required`
  String get valueIsRequired {
    return Intl.message(
      'Value is required',
      name: 'valueIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email invalid`
  String get emailInvalid {
    return Intl.message(
      'Email invalid',
      name: 'emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be less than 8 characters`
  String get Pass_vaditor_char {
    return Intl.message(
      'Password cannot be less than 8 characters',
      name: 'Pass_vaditor_char',
      desc: '',
      args: [],
    );
  }

  /// `@ License `
  String get license {
    return Intl.message('@ License ', name: 'license', desc: '', args: []);
  }

  /// `List`
  String get List {
    return Intl.message('List', name: 'List', desc: '', args: []);
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Profile`
  String get profilePage {
    return Intl.message('Profile', name: 'profilePage', desc: '', args: []);
  }

  /// `Change Profile`
  String get ChangeProfile {
    return Intl.message(
      'Change Profile',
      name: 'ChangeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get SearchTitle {
    return Intl.message('Search', name: 'SearchTitle', desc: '', args: []);
  }

  /// `FAQ`
  String get FAQ {
    return Intl.message('FAQ', name: 'FAQ', desc: '', args: []);
  }

  /// `Foodies`
  String get FOODS {
    return Intl.message('Foodies', name: 'FOODS', desc: '', args: []);
  }

  /// `ALO QTSC`
  String get APP_NAME {
    return Intl.message('ALO QTSC', name: 'APP_NAME', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get Privacy_Policy {
    return Intl.message(
      'Privacy Policy',
      name: 'Privacy_Policy',
      desc: '',
      args: [],
    );
  }

  /// `About Application`
  String get About_Application {
    return Intl.message(
      'About Application',
      name: 'About_Application',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get LogOut {
    return Intl.message('Logout', name: 'LogOut', desc: '', args: []);
  }

  /// `Version`
  String get Version {
    return Intl.message('Version', name: 'Version', desc: '', args: []);
  }

  /// `Please check the login information`
  String get Login_Failed {
    return Intl.message(
      'Please check the login information',
      name: 'Login_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại`
  String get Login_Offline_Failed {
    return Intl.message(
      'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại',
      name: 'Login_Offline_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Đã quá số lần đăng nhập offline`
  String get Login_Offline_Over_Limit {
    return Intl.message(
      'Đã quá số lần đăng nhập offline',
      name: 'Login_Offline_Over_Limit',
      desc: '',
      args: [],
    );
  }

  /// `Please check the password change information`
  String get ChangePass_Failed {
    return Intl.message(
      'Please check the password change information',
      name: 'ChangePass_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Please check the profile change information`
  String get ChangeProfile_Failed {
    return Intl.message(
      'Please check the profile change information',
      name: 'ChangeProfile_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully!`
  String get ChangePass_true {
    return Intl.message(
      'Password changed successfully!',
      name: 'ChangePass_true',
      desc: '',
      args: [],
    );
  }

  /// `The new password is the same as the old password`
  String get Password_Failed {
    return Intl.message(
      'The new password is the same as the old password',
      name: 'Password_Failed',
      desc: '',
      args: [],
    );
  }

  /// `New passwords do not match`
  String get Password_Repeat_Failed {
    return Intl.message(
      'New passwords do not match',
      name: 'Password_Repeat_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get Error {
    return Intl.message('Error', name: 'Error', desc: '', args: []);
  }

  /// `Email invalidate`
  String get Email_Invalid {
    return Intl.message(
      'Email invalidate',
      name: 'Email_Invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter information`
  String get Require_Value {
    return Intl.message(
      'Please enter information',
      name: 'Require_Value',
      desc: '',
      args: [],
    );
  }

  /// `Email login`
  String get User_Name {
    return Intl.message('Email login', name: 'User_Name', desc: '', args: []);
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Forgot password`
  String get Forgot_Password {
    return Intl.message(
      'Forgot password',
      name: 'Forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get Login {
    return Intl.message('LOGIN', name: 'Login', desc: '', args: []);
  }

  /// `SIGN UP`
  String get Sign_Up {
    return Intl.message('SIGN UP', name: 'Sign_Up', desc: '', args: []);
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Password Old`
  String get Password_Old {
    return Intl.message(
      'Password Old',
      name: 'Password_Old',
      desc: '',
      args: [],
    );
  }

  /// `Password New`
  String get Password_New {
    return Intl.message(
      'Password New',
      name: 'Password_New',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new password`
  String get Password_New_Repeat {
    return Intl.message(
      'Enter a new password',
      name: 'Password_New_Repeat',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `Language`
  String get Language {
    return Intl.message('Language', name: 'Language', desc: '', args: []);
  }

  /// `Password Repeat`
  String get Password_Repeat {
    return Intl.message(
      'Password Repeat',
      name: 'Password_Repeat',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get Register_User_Name {
    return Intl.message(
      'Username',
      name: 'Register_User_Name',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get Username {
    return Intl.message('Username', name: 'Username', desc: '', args: []);
  }

  /// `Default`
  String get System_Default {
    return Intl.message('Default', name: 'System_Default', desc: '', args: []);
  }

  /// `English`
  String get Lang_English {
    return Intl.message('English', name: 'Lang_English', desc: '', args: []);
  }

  /// `Vietnamese`
  String get Lang_Vietnam {
    return Intl.message('Vietnamese', name: 'Lang_Vietnam', desc: '', args: []);
  }

  /// `Chọn theme`
  String get Choose_Theme {
    return Intl.message('Chọn theme', name: 'Choose_Theme', desc: '', args: []);
  }

  /// `Home`
  String get Home {
    return Intl.message('Home', name: 'Home', desc: '', args: []);
  }

  /// `Shop`
  String get Shop {
    return Intl.message('Shop', name: 'Shop', desc: '', args: []);
  }

  /// `TAP TO RETRY`
  String get Tap_To_Retry {
    return Intl.message(
      'TAP TO RETRY',
      name: 'Tap_To_Retry',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get Empty {
    return Intl.message('Empty', name: 'Empty', desc: '', args: []);
  }

  /// `Currently no data!`
  String get Oops_Wrong {
    return Intl.message(
      'Currently no data!',
      name: 'Oops_Wrong',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get No_More_Data {
    return Intl.message(
      'No more data',
      name: 'No_More_Data',
      desc: '',
      args: [],
    );
  }

  /// `Loading more data...`
  String get Loading_More_Data {
    return Intl.message(
      'Loading more data...',
      name: 'Loading_More_Data',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get Employee {
    return Intl.message('Employee', name: 'Employee', desc: '', args: []);
  }

  /// `Change Password`
  String get ChangePass {
    return Intl.message(
      'Change Password',
      name: 'ChangePass',
      desc: '',
      args: [],
    );
  }

  /// `Employee code`
  String get EmployeeCode {
    return Intl.message(
      'Employee code',
      name: 'EmployeeCode',
      desc: '',
      args: [],
    );
  }

  /// `Mail job`
  String get WorkMail {
    return Intl.message('Mail job', name: 'WorkMail', desc: '', args: []);
  }

  /// `FullName`
  String get FullName {
    return Intl.message('FullName', name: 'FullName', desc: '', args: []);
  }

  /// `Description`
  String get Description {
    return Intl.message('Description', name: 'Description', desc: '', args: []);
  }

  /// `Phone`
  String get Phone {
    return Intl.message('Phone', name: 'Phone', desc: '', args: []);
  }

  /// `Updating`
  String get IsUpdating {
    return Intl.message('Updating', name: 'IsUpdating', desc: '', args: []);
  }

  /// `Level`
  String get Level {
    return Intl.message('Level', name: 'Level', desc: '', args: []);
  }

  /// `Unit code`
  String get UnitCode {
    return Intl.message('Unit code', name: 'UnitCode', desc: '', args: []);
  }

  /// `Game`
  String get GameScreen {
    return Intl.message('Game', name: 'GameScreen', desc: '', args: []);
  }

  /// `Sign Up Success!`
  String get Singup_true {
    return Intl.message(
      'Sign Up Success!',
      name: 'Singup_true',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed!`
  String get Singup_Failed {
    return Intl.message(
      'Registration failed!',
      name: 'Singup_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get Notification {
    return Intl.message(
      'Notification',
      name: 'Notification',
      desc: '',
      args: [],
    );
  }

  /// `Ticket`
  String get Ticket {
    return Intl.message('Ticket', name: 'Ticket', desc: '', args: []);
  }

  /// `Ok`
  String get btOk {
    return Intl.message('Ok', name: 'btOk', desc: '', args: []);
  }

  /// `Cancel`
  String get btCancel {
    return Intl.message('Cancel', name: 'btCancel', desc: '', args: []);
  }

  /// `Exit`
  String get btExit {
    return Intl.message('Exit', name: 'btExit', desc: '', args: []);
  }

  /// `Delete`
  String get btDelete {
    return Intl.message('Delete', name: 'btDelete', desc: '', args: []);
  }

  /// `Create`
  String get btCreate {
    return Intl.message('Create', name: 'btCreate', desc: '', args: []);
  }

  /// `Edit`
  String get btEdit {
    return Intl.message('Edit', name: 'btEdit', desc: '', args: []);
  }

  /// `Welcome to application`
  String get wellCome {
    return Intl.message(
      'Welcome to application',
      name: 'wellCome',
      desc: '',
      args: [],
    );
  }

  /// `Currently available`
  String get Now_have {
    return Intl.message(
      'Currently available',
      name: 'Now_have',
      desc: '',
      args: [],
    );
  }

  /// `There are currently (0) notifications`
  String get Noti_title0Text {
    return Intl.message(
      'There are currently (0) notifications',
      name: 'Noti_title0Text',
      desc: '',
      args: [],
    );
  }

  /// `Notice details`
  String get Noti_titleDetail {
    return Intl.message(
      'Notice details',
      name: 'Noti_titleDetail',
      desc: '',
      args: [],
    );
  }

  /// `Ticket details`
  String get Ticket_titleDetail {
    return Intl.message(
      'Ticket details',
      name: 'Ticket_titleDetail',
      desc: '',
      args: [],
    );
  }

  /// `Create a new ticket`
  String get Ticket_titleCreate {
    return Intl.message(
      'Create a new ticket',
      name: 'Ticket_titleCreate',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the file?`
  String get Ticket_ActionDelete {
    return Intl.message(
      'Do you want to delete the file?',
      name: 'Ticket_ActionDelete',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save the ticket?`
  String get Ticket_saveTicket {
    return Intl.message(
      'Do you want to save the ticket?',
      name: 'Ticket_saveTicket',
      desc: '',
      args: [],
    );
  }

  /// `Save ticket success`
  String get Ticket_saveTicket_true {
    return Intl.message(
      'Save ticket success',
      name: 'Ticket_saveTicket_true',
      desc: '',
      args: [],
    );
  }

  /// `Details are empty`
  String get Ticket_getTicket_Detail {
    return Intl.message(
      'Details are empty',
      name: 'Ticket_getTicket_Detail',
      desc: '',
      args: [],
    );
  }

  /// `Assignee`
  String get Ticket_assignee {
    return Intl.message(
      'Assignee',
      name: 'Ticket_assignee',
      desc: '',
      args: [],
    );
  }

  /// `Add File: `
  String get Ticket_ChFile {
    return Intl.message(
      'Add File: ',
      name: 'Ticket_ChFile',
      desc: '',
      args: [],
    );
  }

  /// `Upload file failed!`
  String get UploadFileFailed {
    return Intl.message(
      'Upload file failed!',
      name: 'UploadFileFailed',
      desc: '',
      args: [],
    );
  }

  /// `Save ticket failed!`
  String get Ticket_SaveFailed {
    return Intl.message(
      'Save ticket failed!',
      name: 'Ticket_SaveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Download file failed!`
  String get DownloadFileFailed {
    return Intl.message(
      'Download file failed!',
      name: 'DownloadFileFailed',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get Noti_title {
    return Intl.message('Title', name: 'Noti_title', desc: '', args: []);
  }

  /// `Application`
  String get Noti_application {
    return Intl.message(
      'Application',
      name: 'Noti_application',
      desc: '',
      args: [],
    );
  }

  /// `Maker Id`
  String get Noti_makerId {
    return Intl.message('Maker Id', name: 'Noti_makerId', desc: '', args: []);
  }

  /// `From`
  String get Noti_from {
    return Intl.message('From', name: 'Noti_from', desc: '', args: []);
  }

  /// `Maker Date`
  String get Noti_makerDate {
    return Intl.message(
      'Maker Date',
      name: 'Noti_makerDate',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get Noti_to {
    return Intl.message('To', name: 'Noti_to', desc: '', args: []);
  }

  /// `Record Status`
  String get Noti_recordStatus {
    return Intl.message(
      'Record Status',
      name: 'Noti_recordStatus',
      desc: '',
      args: [],
    );
  }

  /// `AggId`
  String get Noti_aggId {
    return Intl.message('AggId', name: 'Noti_aggId', desc: '', args: []);
  }

  /// `Title`
  String get Ticket_title {
    return Intl.message('Title', name: 'Ticket_title', desc: '', args: []);
  }

  /// `Issue Name`
  String get Ticket_issueName {
    return Intl.message(
      'Issue Name',
      name: 'Ticket_issueName',
      desc: '',
      args: [],
    );
  }

  /// `Maker Id`
  String get Ticket_makerId {
    return Intl.message('Maker Id', name: 'Ticket_makerId', desc: '', args: []);
  }

  /// `Maker Date`
  String get Ticket_makerDate {
    return Intl.message(
      'Maker Date',
      name: 'Ticket_makerDate',
      desc: '',
      args: [],
    );
  }

  /// `Record Status`
  String get Ticket_recordStatus {
    return Intl.message(
      'Record Status',
      name: 'Ticket_recordStatus',
      desc: '',
      args: [],
    );
  }

  /// `AggId`
  String get Ticket_aggId {
    return Intl.message('AggId', name: 'Ticket_aggId', desc: '', args: []);
  }

  /// `Status Code`
  String get Ticket_statusCode {
    return Intl.message(
      'Status Code',
      name: 'Ticket_statusCode',
      desc: '',
      args: [],
    );
  }

  /// `Issue Code`
  String get Ticket_issueCode {
    return Intl.message(
      'Issue Code',
      name: 'Ticket_issueCode',
      desc: '',
      args: [],
    );
  }

  /// `Title Cropper`
  String get Ticket_TitleCropper {
    return Intl.message(
      'Title Cropper',
      name: 'Ticket_TitleCropper',
      desc: '',
      args: [],
    );
  }

  /// `Enter the request`
  String get Ticket_inputNote {
    return Intl.message(
      'Enter the request',
      name: 'Ticket_inputNote',
      desc: '',
      args: [],
    );
  }

  /// `Request`
  String get Ticket_Note {
    return Intl.message('Request', name: 'Ticket_Note', desc: '', args: []);
  }

  /// `Camera`
  String get Camera {
    return Intl.message('Camera', name: 'Camera', desc: '', args: []);
  }

  /// `Create video`
  String get Creata_video {
    return Intl.message(
      'Create video',
      name: 'Creata_video',
      desc: '',
      args: [],
    );
  }

  /// `Pick MultiFile`
  String get Pick_MultiFile {
    return Intl.message(
      'Pick MultiFile',
      name: 'Pick_MultiFile',
      desc: '',
      args: [],
    );
  }

  /// `Email/Phone`
  String get Acount {
    return Intl.message('Email/Phone', name: 'Acount', desc: '', args: []);
  }

  /// `UserName`
  String get UserName {
    return Intl.message('UserName', name: 'UserName', desc: '', args: []);
  }

  /// `Status`
  String get STATUS {
    return Intl.message('Status', name: 'STATUS', desc: '', args: []);
  }

  // skipped getter for the 'STATUS.STATUS_NAME' key

  /// `Status`
  String get STATUS_CODE {
    return Intl.message('Status', name: 'STATUS_CODE', desc: '', args: []);
  }

  /// `Accept`
  String get STATUS_CODE_APPROVED {
    return Intl.message(
      'Accept',
      name: 'STATUS_CODE_APPROVED',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get STATUS_CODE_CANCEL {
    return Intl.message(
      'Canceled',
      name: 'STATUS_CODE_CANCEL',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get STATUS_CODE_DONE {
    return Intl.message('Closed', name: 'STATUS_CODE_DONE', desc: '', args: []);
  }

  /// `Init`
  String get STATUS_CODE_INIT {
    return Intl.message('Init', name: 'STATUS_CODE_INIT', desc: '', args: []);
  }

  /// `In Progress`
  String get STATUS_CODE_IN_PROGRESS {
    return Intl.message(
      'In Progress',
      name: 'STATUS_CODE_IN_PROGRESS',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get STATUS_CODE_OPEN {
    return Intl.message('Open', name: 'STATUS_CODE_OPEN', desc: '', args: []);
  }

  /// `Deny`
  String get STATUS_CODE_REJECTED {
    return Intl.message(
      'Deny',
      name: 'STATUS_CODE_REJECTED',
      desc: '',
      args: [],
    );
  }

  /// `Reopen`
  String get STATUS_CODE_REOPENED {
    return Intl.message(
      'Reopen',
      name: 'STATUS_CODE_REOPENED',
      desc: '',
      args: [],
    );
  }

  /// `Sale Review`
  String get STATUS_CODE_SALE_REVIEW {
    return Intl.message(
      'Sale Review',
      name: 'STATUS_CODE_SALE_REVIEW',
      desc: '',
      args: [],
    );
  }

  /// `Solved`
  String get STATUS_CODE_UNDER_REVIEW {
    return Intl.message(
      'Solved',
      name: 'STATUS_CODE_UNDER_REVIEW',
      desc: '',
      args: [],
    );
  }

  /// `Sent for Admin`
  String get STATUS_CODE_ASSIGNED {
    return Intl.message(
      'Sent for Admin',
      name: 'STATUS_CODE_ASSIGNED',
      desc: '',
      args: [],
    );
  }

  /// `Need more information`
  String get STATUS_CODE_NEED_MORE_INFO {
    return Intl.message(
      'Need more information',
      name: 'STATUS_CODE_NEED_MORE_INFO',
      desc: '',
      args: [],
    );
  }

  /// `Status id`
  String get STATUS_ID {
    return Intl.message('Status id', name: 'STATUS_ID', desc: '', args: []);
  }

  /// `Detail`
  String get News_titleDetail {
    return Intl.message('Detail', name: 'News_titleDetail', desc: '', args: []);
  }

  /// `List category\n`
  String get List_news_category {
    return Intl.message(
      'List category\n',
      name: 'List_news_category',
      desc: '',
      args: [],
    );
  }

  /// `List news\n`
  String get List_news {
    return Intl.message('List news\n', name: 'List_news', desc: '', args: []);
  }

  /// `News`
  String get News_title {
    return Intl.message('News', name: 'News_title', desc: '', args: []);
  }

  /// `OTP`
  String get Otp {
    return Intl.message('OTP', name: 'Otp', desc: '', args: []);
  }

  /// `Otp = 6 characters`
  String get Otp_vaditor_char {
    return Intl.message(
      'Otp = 6 characters',
      name: 'Otp_vaditor_char',
      desc: '',
      args: [],
    );
  }

  /// `Action success`
  String get VerifyOtp_true {
    return Intl.message(
      'Action success',
      name: 'VerifyOtp_true',
      desc: '',
      args: [],
    );
  }

  /// `Verify code invalid`
  String get verify_code_invalid {
    return Intl.message(
      'Verify code invalid',
      name: 'verify_code_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Verify code no exist or expire`
  String get verify_code_no_exist_or_expire {
    return Intl.message(
      'Verify code no exist or expire',
      name: 'verify_code_no_exist_or_expire',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get Company {
    return Intl.message('Company', name: 'Company', desc: '', args: []);
  }

  // skipped getter for the 'validation.contact.duplicateEmail' key

  // skipped getter for the 'validation.contact.duplicatePhone' key

  /// `Already exist in the system`
  String get duplicate_error_format {
    return Intl.message(
      'Already exist in the system',
      name: 'duplicate_error_format',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message('Confirm', name: 'Confirm', desc: '', args: []);
  }

  /// `Check`
  String get CheckAccount {
    return Intl.message('Check', name: 'CheckAccount', desc: '', args: []);
  }

  /// `Data input invalid`
  String get data_input_invalid {
    return Intl.message(
      'Data input invalid',
      name: 'data_input_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Send otp fail`
  String get invalid_email {
    return Intl.message(
      'Send otp fail',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get Check {
    return Intl.message('Check', name: 'Check', desc: '', args: []);
  }

  /// `Email Repeat`
  String get EmailRepeat {
    return Intl.message(
      'Email Repeat',
      name: 'EmailRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Please check the information`
  String get check_info_error {
    return Intl.message(
      'Please check the information',
      name: 'check_info_error',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get Alert {
    return Intl.message('Alert', name: 'Alert', desc: '', args: []);
  }

  /// `Incorrect account! Please check `
  String get check_account_error {
    return Intl.message(
      'Incorrect account! Please check ',
      name: 'check_account_error',
      desc: '',
      args: [],
    );
  }

  /// `Ghi chú`
  String get note {
    return Intl.message('Ghi chú', name: 'note', desc: '', args: []);
  }

  /// `Wait for confirmation`
  String get filter01 {
    return Intl.message(
      'Wait for confirmation',
      name: 'filter01',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get filter02 {
    return Intl.message('Processing', name: 'filter02', desc: '', args: []);
  }

  /// `Confirmed`
  String get filter03 {
    return Intl.message('Confirmed', name: 'filter03', desc: '', args: []);
  }

  /// `Denied`
  String get filter04 {
    return Intl.message('Denied', name: 'filter04', desc: '', args: []);
  }

  /// `End`
  String get filter05 {
    return Intl.message('End', name: 'filter05', desc: '', args: []);
  }

  /// `Phone`
  String get cellPhone {
    return Intl.message('Phone', name: 'cellPhone', desc: '', args: []);
  }

  /// `Bạn có muốn đăng xuất khỏi ứng dụng?`
  String get logout_alert {
    return Intl.message(
      'Bạn có muốn đăng xuất khỏi ứng dụng?',
      name: 'logout_alert',
      desc: '',
      args: [],
    );
  }

  /// `Update new version?`
  String get update_newversion {
    return Intl.message(
      'Update new version?',
      name: 'update_newversion',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get Menu {
    return Intl.message('Menu', name: 'Menu', desc: '', args: []);
  }

  /// `Trợ lý bán hàng thông minh`
  String get intelligentSalesAssistant {
    return Intl.message(
      'Trợ lý bán hàng thông minh',
      name: 'intelligentSalesAssistant',
      desc: '',
      args: [],
    );
  }

  /// `© Licence to 2023 Athena`
  String get copy_right {
    return Intl.message(
      '© Licence to 2023 Athena',
      name: 'copy_right',
      desc: '',
      args: [],
    );
  }

  /// `Athena Owl`
  String get appName {
    return Intl.message('Athena Owl', name: 'appName', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Lịch thu hồi nợ`
  String get calendarToday {
    return Intl.message(
      'Lịch thu hồi nợ',
      name: 'calendarToday',
      desc: '',
      args: [],
    );
  }

  /// `Xem bản đồ`
  String get seeMap {
    return Intl.message('Xem bản đồ', name: 'seeMap', desc: '', args: []);
  }

  /// `Không có gì trong cuộc họp này`
  String get no_record_metting {
    return Intl.message(
      'Không có gì trong cuộc họp này',
      name: 'no_record_metting',
      desc: '',
      args: [],
    );
  }

  /// `Dự định`
  String get propose {
    return Intl.message('Dự định', name: 'propose', desc: '', args: []);
  }

  /// `Đã hoàn thành`
  String get actionDone {
    return Intl.message(
      'Đã hoàn thành',
      name: 'actionDone',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collections {
    return Intl.message('Collections', name: 'collections', desc: '', args: []);
  }

  /// `Paid Cases`
  String get paidCases {
    return Intl.message('Paid Cases', name: 'paidCases', desc: '', args: []);
  }

  /// `Unpaid Cases`
  String get unpaidCases {
    return Intl.message(
      'Unpaid Cases',
      name: 'unpaidCases',
      desc: '',
      args: [],
    );
  }

  /// `Yêu cầu hỗ trợ`
  String get supportRequire {
    return Intl.message(
      'Yêu cầu hỗ trợ',
      name: 'supportRequire',
      desc: '',
      args: [],
    );
  }

  /// `Tạo bởi tôi`
  String get createdByMe {
    return Intl.message('Tạo bởi tôi', name: 'createdByMe', desc: '', args: []);
  }

  /// `Hôm nay`
  String get today {
    return Intl.message('Hôm nay', name: 'today', desc: '', args: []);
  }

  /// `tuần`
  String get week {
    return Intl.message('tuần', name: 'week', desc: '', args: []);
  }

  /// `ngày`
  String get day {
    return Intl.message('ngày', name: 'day', desc: '', args: []);
  }

  /// `Ghi nhận khiếu tại từ KH`
  String get customerComplain {
    return Intl.message(
      'Ghi nhận khiếu tại từ KH',
      name: 'customerComplain',
      desc: '',
      args: [],
    );
  }

  /// `Khảo sát`
  String get examine {
    return Intl.message('Khảo sát', name: 'examine', desc: '', args: []);
  }

  /// `Mục tiêu`
  String get target {
    return Intl.message('Mục tiêu', name: 'target', desc: '', args: []);
  }

  /// `Daily target`
  String get dailyTarget {
    return Intl.message(
      'Daily target',
      name: 'dailyTarget',
      desc: '',
      args: [],
    );
  }

  /// `Survey Submission`
  String get surveySubmission {
    return Intl.message(
      'Survey Submission',
      name: 'surveySubmission',
      desc: '',
      args: [],
    );
  }

  /// `Đã đạt được`
  String get achieved {
    return Intl.message('Đã đạt được', name: 'achieved', desc: '', args: []);
  }

  /// `thg`
  String get thg {
    return Intl.message('thg', name: 'thg', desc: '', args: []);
  }

  /// `KRA tháng này`
  String get kraMonthCurrent {
    return Intl.message(
      'KRA tháng này',
      name: 'kraMonthCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Hoạt động trong tháng này`
  String get actionInMonth {
    return Intl.message(
      'Hoạt động trong tháng này',
      name: 'actionInMonth',
      desc: '',
      args: [],
    );
  }

  /// `Add support request`
  String get addSupportRequire {
    return Intl.message(
      'Add support request',
      name: 'addSupportRequire',
      desc: '',
      args: [],
    );
  }

  /// `Complaint record KH`
  String get addComplainCustomer {
    return Intl.message(
      'Complaint record KH',
      name: 'addComplainCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Ghi nhận hoạt ký cho hoạt động`
  String get noteActionDiary {
    return Intl.message(
      'Ghi nhận hoạt ký cho hoạt động',
      name: 'noteActionDiary',
      desc: '',
      args: [],
    );
  }

  /// `Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ`
  String get placeHolderSearch {
    return Intl.message(
      'Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ',
      name: 'placeHolderSearch',
      desc: '',
      args: [],
    );
  }

  /// `Chi tiết`
  String get detail {
    return Intl.message('Chi tiết', name: 'detail', desc: '', args: []);
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Phân bổ cho`
  String get allocationFor {
    return Intl.message(
      'Phân bổ cho',
      name: 'allocationFor',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật lần cuối`
  String get lastUpdate {
    return Intl.message(
      'Cập nhật lần cuối',
      name: 'lastUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Gọi`
  String get call {
    return Intl.message('Gọi', name: 'call', desc: '', args: []);
  }

  /// `Điều hướng`
  String get direction {
    return Intl.message('Điều hướng', name: 'direction', desc: '', args: []);
  }

  /// `SMS`
  String get SMS {
    return Intl.message('SMS', name: 'SMS', desc: '', args: []);
  }

  /// `Lịch sử`
  String get history {
    return Intl.message('Lịch sử', name: 'history', desc: '', args: []);
  }

  /// `ID`
  String get ID {
    return Intl.message('ID', name: 'ID', desc: '', args: []);
  }

  /// `Loại`
  String get type {
    return Intl.message('Loại', name: 'type', desc: '', args: []);
  }

  /// `Loại hợp đồng`
  String get typeContract {
    return Intl.message(
      'Loại hợp đồng',
      name: 'typeContract',
      desc: '',
      args: [],
    );
  }

  /// `Loại hợp đồng chi tiết`
  String get typeContractDetail {
    return Intl.message(
      'Loại hợp đồng chi tiết',
      name: 'typeContractDetail',
      desc: '',
      args: [],
    );
  }

  /// `Thông tin khách hàng`
  String get customerInfomation {
    return Intl.message(
      'Thông tin khách hàng',
      name: 'customerInfomation',
      desc: '',
      args: [],
    );
  }

  /// `Tên khách hàng`
  String get customerName {
    return Intl.message(
      'Tên khách hàng',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Mã số khách hàng`
  String get customerCode {
    return Intl.message(
      'Mã số khách hàng',
      name: 'customerCode',
      desc: '',
      args: [],
    );
  }

  /// `Lịch`
  String get calendar {
    return Intl.message('Lịch', name: 'calendar', desc: '', args: []);
  }

  /// `Bạn có 1 thông báo mới`
  String get Notification_msg {
    return Intl.message(
      'Bạn có 1 thông báo mới',
      name: 'Notification_msg',
      desc: '',
      args: [],
    );
  }

  /// `Bạn muốn đọc thông báo mới ?`
  String get Msg_new {
    return Intl.message(
      'Bạn muốn đọc thông báo mới ?',
      name: 'Msg_new',
      desc: '',
      args: [],
    );
  }

  /// `Khởi tạo`
  String get ticketStatusINIT {
    return Intl.message(
      'Khởi tạo',
      name: 'ticketStatusINIT',
      desc: '',
      args: [],
    );
  }

  /// `Đang xử lý`
  String get ticketStatusINPROGRESS {
    return Intl.message(
      'Đang xử lý',
      name: 'ticketStatusINPROGRESS',
      desc: '',
      args: [],
    );
  }

  /// `Đã cập nhật trạng thái`
  String get ticketStatusSTATUS_UPDATED {
    return Intl.message(
      'Đã cập nhật trạng thái',
      name: 'ticketStatusSTATUS_UPDATED',
      desc: '',
      args: [],
    );
  }

  /// `Hoàn tất`
  String get ticketStatusDONE {
    return Intl.message(
      'Hoàn tất',
      name: 'ticketStatusDONE',
      desc: '',
      args: [],
    );
  }

  /// `Khách hàng không cung cấp email`
  String get customerNoEmail {
    return Intl.message(
      'Khách hàng không cung cấp email',
      name: 'customerNoEmail',
      desc: '',
      args: [],
    );
  }

  /// `Khách hàng không cung cấp số điện thoại`
  String get customerNoPhone {
    return Intl.message(
      'Khách hàng không cung cấp số điện thoại',
      name: 'customerNoPhone',
      desc: '',
      args: [],
    );
  }

  /// `Check in`
  String get checkIn {
    return Intl.message('Check in', name: 'checkIn', desc: '', args: []);
  }

  /// `Yêu cầu tài liệu từ Ommnidocs`
  String get requireDocumentFromOmniDoc {
    return Intl.message(
      'Yêu cầu tài liệu từ Ommnidocs',
      name: 'requireDocumentFromOmniDoc',
      desc: '',
      args: [],
    );
  }

  /// `Kiểm tra thông tin thanh toán`
  String get checkPaymentCustomer {
    return Intl.message(
      'Kiểm tra thông tin thanh toán',
      name: 'checkPaymentCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Xem các địa chỉ khác của khách hàng`
  String get seeOtherAddressCustomer {
    return Intl.message(
      'Xem các địa chỉ khác của khách hàng',
      name: 'seeOtherAddressCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Fetch data`
  String get fecthData {
    return Intl.message('Fetch data', name: 'fecthData', desc: '', args: []);
  }

  /// `Ghi nhật ký cho hoạt động`
  String get noteDiaryAction {
    return Intl.message(
      'Ghi nhật ký cho hoạt động',
      name: 'noteDiaryAction',
      desc: '',
      args: [],
    );
  }

  /// `Tài liệu`
  String get document {
    return Intl.message('Tài liệu', name: 'document', desc: '', args: []);
  }

  /// `Thông tin`
  String get infomation {
    return Intl.message('Thông tin', name: 'infomation', desc: '', args: []);
  }

  /// `Địa điểm`
  String get position {
    return Intl.message('Địa điểm', name: 'position', desc: '', args: []);
  }

  /// `Phương thức liên hệ`
  String get contactBy {
    return Intl.message(
      'Phương thức liên hệ',
      name: 'contactBy',
      desc: '',
      args: [],
    );
  }

  /// `Liên hệ với`
  String get contactWith {
    return Intl.message('Liên hệ với', name: 'contactWith', desc: '', args: []);
  }

  /// `Nguyên nhân cụ thể`
  String get reason {
    return Intl.message(
      'Nguyên nhân cụ thể',
      name: 'reason',
      desc: '',
      args: [],
    );
  }

  /// `Nơi liên hệ`
  String get contactPlace {
    return Intl.message(
      'Nơi liên hệ',
      name: 'contactPlace',
      desc: '',
      args: [],
    );
  }

  /// `Họ tên người đóng tiền`
  String get fullNamePayment {
    return Intl.message(
      'Họ tên người đóng tiền',
      name: 'fullNamePayment',
      desc: '',
      args: [],
    );
  }

  /// `Số tiền đã thu`
  String get moneyPaymentTake {
    return Intl.message(
      'Số tiền đã thu',
      name: 'moneyPaymentTake',
      desc: '',
      args: [],
    );
  }

  /// `Thời gian tác động tiếp theo`
  String get timeScheduleNext {
    return Intl.message(
      'Thời gian tác động tiếp theo',
      name: 'timeScheduleNext',
      desc: '',
      args: [],
    );
  }

  /// `Điện thoại khách hàng`
  String get customerPhone {
    return Intl.message(
      'Điện thoại khách hàng',
      name: 'customerPhone',
      desc: '',
      args: [],
    );
  }

  /// `Nhấn vào đây để xem trước nội dung tin nhắn`
  String get touchAndSeeContentSMS {
    return Intl.message(
      'Nhấn vào đây để xem trước nội dung tin nhắn',
      name: 'touchAndSeeContentSMS',
      desc: '',
      args: [],
    );
  }

  /// `Chọn`
  String get select {
    return Intl.message('Chọn', name: 'select', desc: '', args: []);
  }

  /// `Khách hàng hứa/ đã thanh toán (PTP)`
  String get customerPromiseToPay {
    return Intl.message(
      'Khách hàng hứa/ đã thanh toán (PTP)',
      name: 'customerPromiseToPay',
      desc: '',
      args: [],
    );
  }

  /// `Khách hàng từ chối thanh toán (RTP)`
  String get customerRefuseToPay {
    return Intl.message(
      'Khách hàng từ chối thanh toán (RTP)',
      name: 'customerRefuseToPay',
      desc: '',
      args: [],
    );
  }

  /// `Thanh toán hợp đồng`
  String get customerPartialPayment {
    return Intl.message(
      'Thanh toán hợp đồng',
      name: 'customerPartialPayment',
      desc: '',
      args: [],
    );
  }

  /// `Khách hàng hứa thanh toán (C-PTP)`
  String get customerPromiseToPayC {
    return Intl.message(
      'Khách hàng hứa thanh toán (C-PTP)',
      name: 'customerPromiseToPayC',
      desc: '',
      args: [],
    );
  }

  /// `Khách hàng từ chối thanh toán (C-RTP)`
  String get customerRefuseToPayC {
    return Intl.message(
      'Khách hàng từ chối thanh toán (C-RTP)',
      name: 'customerRefuseToPayC',
      desc: '',
      args: [],
    );
  }

  /// `Thanh toán hợp đồng (C-P)`
  String get customerPartialPaymentC {
    return Intl.message(
      'Thanh toán hợp đồng (C-P)',
      name: 'customerPartialPaymentC',
      desc: '',
      args: [],
    );
  }

  /// `Kết quả viếng thăm khác (C-Other)`
  String get otherCheckInC {
    return Intl.message(
      'Kết quả viếng thăm khác (C-Other)',
      name: 'otherCheckInC',
      desc: '',
      args: [],
    );
  }

  /// `Số tiền hứa thanh toán`
  String get moneyPromisePayment {
    return Intl.message(
      'Số tiền hứa thanh toán',
      name: 'moneyPromisePayment',
      desc: '',
      args: [],
    );
  }

  /// `Kết quả viếng thăm khác`
  String get otherCheckIn {
    return Intl.message(
      'Kết quả viếng thăm khác',
      name: 'otherCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng nhập thông tin`
  String get pleaseInputRequire {
    return Intl.message(
      'Vui lòng nhập thông tin',
      name: 'pleaseInputRequire',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `Thời lượng`
  String get timeSchedule {
    return Intl.message('Thời lượng', name: 'timeSchedule', desc: '', args: []);
  }

  /// `Phút`
  String get mins {
    return Intl.message('Phút', name: 'mins', desc: '', args: []);
  }

  /// `Thời gian`
  String get time {
    return Intl.message('Thời gian', name: 'time', desc: '', args: []);
  }

  /// `Cập nhật thất bại`
  String get update_failed {
    return Intl.message(
      'Cập nhật thất bại',
      name: 'update_failed',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật thành công`
  String get update_sucess {
    return Intl.message(
      'Cập nhật thành công',
      name: 'update_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Mã hoạt động`
  String get actionCode {
    return Intl.message('Mã hoạt động', name: 'actionCode', desc: '', args: []);
  }

  /// `Nguyên nhân cụ thể`
  String get actionAttributeCode {
    return Intl.message(
      'Nguyên nhân cụ thể',
      name: 'actionAttributeCode',
      desc: '',
      args: [],
    );
  }

  /// `Chạm để tải lại`
  String get tapToRefresh {
    return Intl.message(
      'Chạm để tải lại',
      name: 'tapToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Cuộc gặp tiếp theo`
  String get nextMeeting {
    return Intl.message(
      'Cuộc gặp tiếp theo',
      name: 'nextMeeting',
      desc: '',
      args: [],
    );
  }

  /// `Vào lúc`
  String get onTime {
    return Intl.message('Vào lúc', name: 'onTime', desc: '', args: []);
  }

  /// `Tháng`
  String get month {
    return Intl.message('Tháng', name: 'month', desc: '', args: []);
  }

  /// `Năm`
  String get year {
    return Intl.message('Năm', name: 'year', desc: '', args: []);
  }

  /// `Chưa cập nhật trạng thái`
  String get doNotUpdateStatus {
    return Intl.message(
      'Chưa cập nhật trạng thái',
      name: 'doNotUpdateStatus',
      desc: '',
      args: [],
    );
  }

  /// `Meeting date`
  String get meetingDate {
    return Intl.message(
      'Meeting date',
      name: 'meetingDate',
      desc: '',
      args: [],
    );
  }

  /// `Created date`
  String get createdDate {
    return Intl.message(
      'Created date',
      name: 'createdDate',
      desc: '',
      args: [],
    );
  }

  /// `Last updated date`
  String get lastUpdatedDate {
    return Intl.message(
      'Last updated date',
      name: 'lastUpdatedDate',
      desc: '',
      args: [],
    );
  }

  /// `Application ID`
  String get applicationId {
    return Intl.message(
      'Application ID',
      name: 'applicationId',
      desc: '',
      args: [],
    );
  }

  /// `Type of contact`
  String get typeOfContact {
    return Intl.message(
      'Type of contact',
      name: 'typeOfContact',
      desc: '',
      args: [],
    );
  }

  /// `Contract type`
  String get contractType {
    return Intl.message(
      'Contract type',
      name: 'contractType',
      desc: '',
      args: [],
    );
  }

  /// `Contract id`
  String get contractId {
    return Intl.message('Contract id', name: 'contractId', desc: '', args: []);
  }

  /// `Not check in`
  String get notCheckIn {
    return Intl.message('Not check in', name: 'notCheckIn', desc: '', args: []);
  }

  /// `Not PTP`
  String get notPTP {
    return Intl.message('Not PTP', name: 'notPTP', desc: '', args: []);
  }

  /// `PTP`
  String get PTP {
    return Intl.message('PTP', name: 'PTP', desc: '', args: []);
  }

  /// `AssignedDate`
  String get AssignedDate {
    return Intl.message(
      'AssignedDate',
      name: 'AssignedDate',
      desc: '',
      args: [],
    );
  }

  /// `Contract number`
  String get contractNumber {
    return Intl.message(
      'Contract number',
      name: 'contractNumber',
      desc: '',
      args: [],
    );
  }

  /// `Từ chối thanh toán`
  String get refuseToPay {
    return Intl.message(
      'Từ chối thanh toán',
      name: 'refuseToPay',
      desc: '',
      args: [],
    );
  }

  /// `Hứa thanh toán`
  String get promiseToPay {
    return Intl.message(
      'Hứa thanh toán',
      name: 'promiseToPay',
      desc: '',
      args: [],
    );
  }

  /// `Liên kết`
  String get connection {
    return Intl.message('Liên kết', name: 'connection', desc: '', args: []);
  }

  /// `Tính số tiền phải trả hàng tháng`
  String get calculateMoneyPayPerMonth {
    return Intl.message(
      'Tính số tiền phải trả hàng tháng',
      name: 'calculateMoneyPayPerMonth',
      desc: '',
      args: [],
    );
  }

  /// `Liên hệ IT hỗ trợ`
  String get contactITToSuppoter {
    return Intl.message(
      'Liên hệ IT hỗ trợ',
      name: 'contactITToSuppoter',
      desc: '',
      args: [],
    );
  }

  /// `Add Request support`
  String get customerRequestPage {
    return Intl.message(
      'Add Request support',
      name: 'customerRequestPage',
      desc: '',
      args: [],
    );
  }

  /// `Detail Request support`
  String get customerRequestPageDetail {
    return Intl.message(
      'Detail Request support',
      name: 'customerRequestPageDetail',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get labelCategory {
    return Intl.message('Category', name: 'labelCategory', desc: '', args: []);
  }

  /// `Sub Category`
  String get labelSubCategory {
    return Intl.message(
      'Sub Category',
      name: 'labelSubCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please choose one`
  String get hintTextDropdown {
    return Intl.message(
      'Please choose one',
      name: 'hintTextDropdown',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get name {
    return Intl.message('Title', name: 'name', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Pick Image`
  String get image {
    return Intl.message('Pick Image', name: 'image', desc: '', args: []);
  }

  /// `Pick MultiFile`
  String get pickmultiFile {
    return Intl.message(
      'Pick MultiFile',
      name: 'pickmultiFile',
      desc: '',
      args: [],
    );
  }

  /// `Create Video`
  String get creatavideo {
    return Intl.message(
      'Create Video',
      name: 'creatavideo',
      desc: '',
      args: [],
    );
  }

  /// `Do you want delete file?`
  String get deleteFile {
    return Intl.message(
      'Do you want delete file?',
      name: 'deleteFile',
      desc: '',
      args: [],
    );
  }

  /// `Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại`
  String get featureCantRunOffline {
    return Intl.message(
      'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại',
      name: 'featureCantRunOffline',
      desc: '',
      args: [],
    );
  }

  /// `Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại`
  String get addressCantGetWhenOffline {
    return Intl.message(
      'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại',
      name: 'addressCantGetWhenOffline',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật cuối`
  String get last_update {
    return Intl.message(
      'Cập nhật cuối',
      name: 'last_update',
      desc: '',
      args: [],
    );
  }

  /// `Xác thực vân tay`
  String get login_finterprint {
    return Intl.message(
      'Xác thực vân tay',
      name: 'login_finterprint',
      desc: '',
      args: [],
    );
  }

  /// `History call`
  String get historyCall {
    return Intl.message(
      'History call',
      name: 'historyCall',
      desc: '',
      args: [],
    );
  }

  /// `Xem thông tin lịch sử thanh toán`
  String get seeHistoryInfomationPayment {
    return Intl.message(
      'Xem thông tin lịch sử thanh toán',
      name: 'seeHistoryInfomationPayment',
      desc: '',
      args: [],
    );
  }

  /// `Truy tìm thông tin khách hàng`
  String get seeKalapaInfomation {
    return Intl.message(
      'Truy tìm thông tin khách hàng',
      name: 'seeKalapaInfomation',
      desc: '',
      args: [],
    );
  }

  /// `No check in`
  String get noCheckin {
    return Intl.message('No check in', name: 'noCheckin', desc: '', args: []);
  }

  /// `Vui lòng chọn `
  String get pleaseChoose {
    return Intl.message(
      'Vui lòng chọn ',
      name: 'pleaseChoose',
      desc: '',
      args: [],
    );
  }

  /// `Xem thông tin lịch thanh toán`
  String get seeShedulePaymentInfomation {
    return Intl.message(
      'Xem thông tin lịch thanh toán',
      name: 'seeShedulePaymentInfomation',
      desc: '',
      args: [],
    );
  }

  /// `Hiển thị`
  String get display {
    return Intl.message('Hiển thị', name: 'display', desc: '', args: []);
  }

  /// `Cuối cùng`
  String get lastest {
    return Intl.message('Cuối cùng', name: 'lastest', desc: '', args: []);
  }

  /// `Bán kính`
  String get radius {
    return Intl.message('Bán kính', name: 'radius', desc: '', args: []);
  }

  /// `Vui lòng kiểm tra bán kính > 0 !`
  String get radius_require {
    return Intl.message(
      'Vui lòng kiểm tra bán kính > 0 !',
      name: 'radius_require',
      desc: '',
      args: [],
    );
  }

  /// `No Unread Notification`
  String get no_unread_notification {
    return Intl.message(
      'No Unread Notification',
      name: 'no_unread_notification',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message('Security', name: 'security', desc: '', args: []);
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Data`
  String get data {
    return Intl.message('Data', name: 'data', desc: '', args: []);
  }

  /// `Assignee`
  String get assignee {
    return Intl.message('Assignee', name: 'assignee', desc: '', args: []);
  }

  /// `List request`
  String get list_request {
    return Intl.message(
      'List request',
      name: 'list_request',
      desc: '',
      args: [],
    );
  }

  /// `My request`
  String get my_request {
    return Intl.message('My request', name: 'my_request', desc: '', args: []);
  }

  /// `CreateDate From`
  String get createdDateFrom {
    return Intl.message(
      'CreateDate From',
      name: 'createdDateFrom',
      desc: '',
      args: [],
    );
  }

  /// `CreateDate To`
  String get createdDateTo {
    return Intl.message(
      'CreateDate To',
      name: 'createdDateTo',
      desc: '',
      args: [],
    );
  }

  /// `Chỉ được check-in từ 07:00 - 21:00 hàng ngày`
  String get checkInTimeInvalid {
    return Intl.message(
      'Chỉ được check-in từ 07:00 - 21:00 hàng ngày',
      name: 'checkInTimeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `POS`
  String get POS {
    return Intl.message('POS', name: 'POS', desc: '', args: []);
  }

  /// `EMI`
  String get EMI {
    return Intl.message('EMI', name: 'EMI', desc: '', args: []);
  }

  /// `Due date`
  String get dueDate {
    return Intl.message('Due date', name: 'dueDate', desc: '', args: []);
  }

  /// `Amount overdue`
  String get OverdueAmount {
    return Intl.message(
      'Amount overdue',
      name: 'OverdueAmount',
      desc: '',
      args: [],
    );
  }

  /// `giảm dần`
  String get desc {
    return Intl.message('giảm dần', name: 'desc', desc: '', args: []);
  }

  /// `tăng dần`
  String get asc {
    return Intl.message('tăng dần', name: 'asc', desc: '', args: []);
  }

  /// `Min amount due`
  String get minAmountDue {
    return Intl.message(
      'Min amount due',
      name: 'minAmountDue',
      desc: '',
      args: [],
    );
  }

  /// `Xem số tiền thanh toán sớm`
  String get earlyTermination {
    return Intl.message(
      'Xem số tiền thanh toán sớm',
      name: 'earlyTermination',
      desc: '',
      args: [],
    );
  }

  /// `Thêm thành công`
  String get insertComplete {
    return Intl.message(
      'Thêm thành công',
      name: 'insertComplete',
      desc: '',
      args: [],
    );
  }

  /// `Thêm thất bại`
  String get insertFailed {
    return Intl.message(
      'Thêm thất bại',
      name: 'insertFailed',
      desc: '',
      args: [],
    );
  }

  /// `Thời gian tác động không hợp lệ`
  String get invalidStartDatetime {
    return Intl.message(
      'Thời gian tác động không hợp lệ',
      name: 'invalidStartDatetime',
      desc: '',
      args: [],
    );
  }

  /// `Chụp hình check-in`
  String get selfie_check_in {
    return Intl.message(
      'Chụp hình check-in',
      name: 'selfie_check_in',
      desc: '',
      args: [],
    );
  }

  /// `Ảnh chụp hình check-in không hợp lệ`
  String get selfie_check_in_invalid {
    return Intl.message(
      'Ảnh chụp hình check-in không hợp lệ',
      name: 'selfie_check_in_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Khảo sát`
  String get survey {
    return Intl.message('Khảo sát', name: 'survey', desc: '', args: []);
  }

  /// `Cập nhật thất bại`
  String get trackingCallFailed {
    return Intl.message(
      'Cập nhật thất bại',
      name: 'trackingCallFailed',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng chờ nhận cuộc gọi`
  String get trackingCallSucess {
    return Intl.message(
      'Vui lòng chờ nhận cuộc gọi',
      name: 'trackingCallSucess',
      desc: '',
      args: [],
    );
  }

  /// `Đã có lỗi xảy ra!`
  String get failedDefault {
    return Intl.message(
      'Đã có lỗi xảy ra!',
      name: 'failedDefault',
      desc: '',
      args: [],
    );
  }

  /// `Nguồn tiền liên kết`
  String get moneySources {
    return Intl.message(
      'Nguồn tiền liên kết',
      name: 'moneySources',
      desc: '',
      args: [],
    );
  }

  /// `Danh sách tải về`
  String get downloadList {
    return Intl.message(
      'Danh sách tải về',
      name: 'downloadList',
      desc: '',
      args: [],
    );
  }

  /// `Đã liên kết`
  String get linked {
    return Intl.message('Đã liên kết', name: 'linked', desc: '', args: []);
  }

  /// `Kiểm tra phiên bản cập nhật!`
  String get auto_check_version {
    return Intl.message(
      'Kiểm tra phiên bản cập nhật!',
      name: 'auto_check_version',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật phiên bản mới?`
  String get update_title {
    return Intl.message(
      'Cập nhật phiên bản mới?',
      name: 'update_title',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật`
  String get update_button_text {
    return Intl.message(
      'Cập nhật',
      name: 'update_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Bỏ qua`
  String get dismiss_button_text {
    return Intl.message(
      'Bỏ qua',
      name: 'dismiss_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật phiên bản ứng dụng từ {localVersion} đến {storeVersion}`
  String update_content(Object localVersion, Object storeVersion) {
    return Intl.message(
      'Cập nhật phiên bản ứng dụng từ $localVersion đến $storeVersion',
      name: 'update_content',
      desc: '',
      args: [localVersion, storeVersion],
    );
  }

  /// `Bận cần cập nhật phiên bản mới để tiếp tục sử dụng ứng dụng`
  String get force_update {
    return Intl.message(
      'Bận cần cập nhật phiên bản mới để tiếp tục sử dụng ứng dụng',
      name: 'force_update',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
