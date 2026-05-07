import 'package:equatable/equatable.dart';

class FbPageInfoEntity extends Equatable {
  const FbPageInfoEntity({
    required this.id,
    this.name,
    this.about,
    this.description,
    this.emails,
    this.phone,
    this.website,
    this.category,
    this.link,
    this.fanCount,
    this.verificationStatus,
    this.founded,
    this.locationCity,
    this.locationCountry,
    this.locationState,
    this.locationStreet,
    this.locationZip,
  });

  final String id;
  final String? name;
  final String? about;
  final String? description;
  final List<String>? emails;
  final String? phone;
  final String? website;
  final String? category;

  /// URL to the Facebook Page.
  final String? link;

  /// Number of people who like the page.
  final int? fanCount;

  /// `not_verified`, `blue_verified`, or `gray_verified`.
  final String? verificationStatus;
  final String? founded;

  // Location fields
  final String? locationCity;
  final String? locationCountry;
  final String? locationState;
  final String? locationStreet;
  final String? locationZip;

  /// Returns a human-readable full address string.
  String? get fullAddress {
    final parts = [
      if (locationStreet != null) locationStreet,
      if (locationCity != null) locationCity,
      if (locationState != null) locationState,
      if (locationZip != null) locationZip,
      if (locationCountry != null) locationCountry,
    ];
    return parts.isEmpty ? null : parts.join(', ');
  }

  @override
  List<Object?> get props => [
    id,
    name,
    about,
    description,
    emails,
    phone,
    website,
    category,
    link,
    fanCount,
    verificationStatus,
    founded,
    locationCity,
    locationCountry,
    locationState,
    locationStreet,
    locationZip,
  ];
}

