import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class FirestoreException implements Exception {
  FirestoreException(this.cause, this.stackTrace);

  final Object cause;
  final StackTrace stackTrace;
}

class FbFirestoreController {
  FbFirestoreController(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  Future<void> addToCollection(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    try {
      return _firebaseFirestore.collection(collectionPath).add(data);
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<List<Map<String, dynamic>>> getCollectionQuerySnapshot(
    String collectionPath, {
    String? field,
    Object? isEqualTo,
    Object? isLessThan,
    Object? isGreaterThan,
    Object? isNotEqualTo,
    bool? descending,
    String? orderBy,
    int? limit,
    String? startAfterDocumentId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firebaseFirestore.collection(
        collectionPath,
      );

      // Add filtering if a field and condition are provided
      if (field != null && isEqualTo != null) {
        query = query.where(field, isEqualTo: isEqualTo);
      }
      if (field != null && isLessThan != null) {
        query = query.where(field, isLessThan: isLessThan);
      }
      if (field != null && isGreaterThan != null) {
        query = query.where(field, isGreaterThan: isGreaterThan);
      }
      if (field != null && isNotEqualTo != null) {
        query = query.where(field, isNotEqualTo: isNotEqualTo);
      }

      // Add ordering if specified
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending ?? false);
      }

      // Add limit if specified
      if (limit != null) {
        query = query.limit(limit);
      }

      // Add startAfterDocumentId if specified
      if (startAfterDocumentId != null) {
        final docSnapshot = await _firebaseFirestore
            .collection(collectionPath)
            .doc(startAfterDocumentId)
            .get();
        if (docSnapshot.exists) {
          query = query.startAfterDocument(docSnapshot);
        }
      }

      final queryData = await query.get();
      final snapshots = queryData.docs.where((doc) => doc.exists);

      return snapshots.map((snapshot) => snapshot.data()).toList();
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<void> addDocumentToCollection({
    required String collectionPath,
    required String documentPath,
    required Map<String, dynamic> data,
  }) {
    try {
      return _firebaseFirestore
          .collection(collectionPath)
          .doc(documentPath)
          .set(data);
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<void> deleteDocumentFromCollection({
    required String collectionPath,
    required String documentPath,
  }) {
    try {
      return _firebaseFirestore
          .collection(collectionPath)
          .doc(documentPath)
          .delete();
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<Map<String, dynamic>?> getDocumentFromCollection(
    String collectionPath,
    String documentPath,
  ) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(collectionPath)
          .doc(documentPath)
          .get();
      if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
        return snapshot.data();
      }
      throw Exception('No collection found');
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<void> updateDocumentFromCollection(
    String collectionPath,
    String documentPath,
    Map<String, dynamic> data,
  ) {
    try {
      return _firebaseFirestore
          .collection(collectionPath)
          .doc(documentPath)
          .update(data);
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  Future<void> batchUpdateDocuments(
    String collectionPath,
    List<Map<String, dynamic>> updates,
  ) async {
    try {
      final batch = _firebaseFirestore.batch();
      for (final update in updates) {
        final docRef = _firebaseFirestore
            .collection(collectionPath)
            .doc(update['documentPath'] as String);
        batch.update(docRef, update['data'] as Map<String, dynamic>);
      }
      await batch.commit();
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }

  /// GeoFire query: Returns a stream of documents within [radiusInKm] of [center].
  ///
  /// [field] should be the Firestore field name containing the GeoPoint (e.g., 'location').
  /// [geoPointFrom] is optional; if not provided, it defaults to extracting the GeoPoint from [field].
  Stream<List<Map<String, dynamic>>> subscribeToGeoCollection({
    required String collectionPath,
    required GeoFirePoint center,
    required double radiusInKm,
    required String field,
    required GeoPoint Function(Map<String, dynamic> data) geoPointFrom,
  }) {
    try {
      final collectionRef = _firebaseFirestore.collection(collectionPath);
      final stream = GeoCollectionReference(collectionRef).subscribeWithin(
        center: center,
        radiusInKm: radiusInKm,
        field: field,
        geopointFrom: geoPointFrom,
        strictMode: true,
      );
      return stream.map((results) {
        return results.map((doc) => doc.data()!).toList();
      });
    } catch (error, st) {
      return Stream.error(FirestoreException(error, st));
    }
  }

  /// GeoFire query: Returns a stream of documents within [radiusInKm] of [center] with distance info.
  ///
  /// [field] should be the Firestore field name containing the GeoPoint (e.g., 'location').
  /// [geoPointFrom] is required to extract the GeoPoint from the document data.
  Stream<List<Map<String, dynamic>>> subscribeToGeoCollectionWithDistance({
    required String collectionPath,
    required GeoFirePoint center,
    required double radiusInKm,
    required String field,
    required GeoPoint Function(Map<String, dynamic> data) geoPointFrom,
  }) {
    try {
      final collectionRef = _firebaseFirestore.collection(collectionPath);
      final stream = GeoCollectionReference(collectionRef)
          .subscribeWithinWithDistance(
            center: center,
            radiusInKm: radiusInKm,
            field: field,
            geopointFrom: geoPointFrom,
            strictMode: true,
          );
      return stream.map((results) {
        return results.map((geoDoc) {
          final data = geoDoc.documentSnapshot.data();
          if (data != null) {
            return <String, dynamic>{
              ...data,
              'distanceInKm': geoDoc.distanceFromCenterInKm,
            };
          }
          return <String, dynamic>{};
        }).toList();
      });
    } catch (error, st) {
      return Stream.error(FirestoreException(error, st));
    }
  }

  /// GeoFire query: Returns a Future of documents within [radiusInKm] of [center] with distance info (one-time fetch).
  ///
  /// [field] should be the Firestore field name containing the GeoPoint (e.g., 'location').
  /// [geoPointFrom] is required to extract the GeoPoint from the document data.
  Future<List<Map<String, dynamic>>> getGeoCollectionWithDistance({
    required String collectionPath,
    required GeoFirePoint center,
    required double radiusInKm,
    required String field,
    required GeoPoint Function(Map<String, dynamic> data) geoPointFrom,
  }) async {
    try {
      final collectionRef = _firebaseFirestore.collection(collectionPath);
      final results = await GeoCollectionReference(collectionRef)
          .fetchWithinWithDistance(
            center: center,
            radiusInKm: radiusInKm,
            field: field,
            geopointFrom: geoPointFrom,
            strictMode: true,
          );
      return results.map((geoDoc) {
        final data = geoDoc.documentSnapshot.data();
        if (data != null) {
          return <String, dynamic>{
            ...data,
            'distanceInKm': geoDoc.distanceFromCenterInKm,
          };
        }
        return <String, dynamic>{};
      }).toList();
    } catch (error, st) {
      throw FirestoreException(error, st);
    }
  }
}
