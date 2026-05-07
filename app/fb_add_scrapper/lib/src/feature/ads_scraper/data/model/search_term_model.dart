import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

class SearchTermModel {
  const SearchTermModel({
    required this.id,
    required this.term,
    this.adType = 'ALL',
    this.status = 'pending',
    this.totalCount = 0,
    this.lastFetchedAt,
    this.createdAt,
    this.errorMessage,
  });

  factory SearchTermModel.fromJson(String id, Map<String, dynamic> json) {
    DateTime? _toDateTime(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return SearchTermModel(
      id: id,
      term: json['term'] as String? ?? id,
      adType: json['adType'] as String? ?? 'ALL',
      status: json['status'] as String? ?? 'pending',
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      lastFetchedAt: _toDateTime(json['lastFetchedAt']),
      createdAt: _toDateTime(json['createdAt']),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  final String id;
  final String term;
  final String adType;
  final String status;
  final int totalCount;
  final DateTime? lastFetchedAt;
  final DateTime? createdAt;
  final String? errorMessage;

  Map<String, dynamic> toJson() => {
        'term': term,
        'adType': adType,
        'status': status,
        'totalCount': totalCount,
        if (lastFetchedAt != null) 'lastFetchedAt': lastFetchedAt!.toIso8601String(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (errorMessage != null) 'errorMessage': errorMessage,
      };

  SearchTermStatus get statusEnum {
    switch (status) {
      case 'loading':
        return SearchTermStatus.loading;
      case 'done':
        return SearchTermStatus.done;
      case 'error':
        return SearchTermStatus.error;
      default:
        return SearchTermStatus.pending;
    }
  }
}

