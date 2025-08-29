import 'dart:convert';
import 'dart:io';

class GetDataToUploadUseCase {
  const GetDataToUploadUseCase();

  Future<String> execute(
    String filePath,
    String collectionName,
    String projectId,
  ) async {
    final fileToUpload = await File(filePath).readAsString();
    final jsonToUpload = json.decode(fileToUpload) as Map<String, dynamic>;
    final firestoreJson = _convertToFirestoreBatch(
      jsonToUpload,
      collectionName,
      projectId,
    );
    return json.encode(firestoreJson);
  }

  Map<String, dynamic> _convertToFirestoreBatch(
    Map<String, dynamic> json,
    String collectionName,
    String projectId,
  ) {
    final List<Map<String, dynamic>> writes = [];

    final documents = json['documents'] as List<dynamic>;
    for (final doc in documents) {
      final docId = doc['docId'] as String;
      final fields = doc['fields'] as Map<String, dynamic>;
      writes.add({
        'update': {
          'name':
              'projects/$projectId/databases/(default)/documents/$collectionName/$docId',
          'fields': _convertFieldsToFirestore(fields),
        },
      });
    }

    return {'writes': writes};
  }

  Map<String, dynamic> _convertFieldsToFirestore(Map<String, dynamic> fields) {
    final Map<String, dynamic> firestoreFields = {};

    fields.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('integerValue') ||
            value.containsKey('doubleValue') ||
            value.containsKey('stringValue') ||
            value.containsKey('booleanValue') ||
            value.containsKey('geoPointValue') ||
            value.containsKey('mapValue')) {
          firestoreFields[key] = value;
        } else {
          firestoreFields[key] = {
            'mapValue': {'fields': _convertFieldsToFirestore(value)},
          };
        }
      } else if (value is int) {
        firestoreFields[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        firestoreFields[key] = {'doubleValue': value};
      } else if (value is String) {
        firestoreFields[key] = {'stringValue': value};
      } else if (value is bool) {
        firestoreFields[key] = {'booleanValue': value};
      } else if (value is List) {
        firestoreFields[key] = {
          'arrayValue': {
            'values': value.map((v) => _convertValueToFirestore(v)).toList(),
          },
        };
      }
    });

    return firestoreFields;
  }

  dynamic _convertValueToFirestore(dynamic value) {
    if (value is Map<String, dynamic>)
      return {
        'mapValue': {'fields': _convertFieldsToFirestore(value)},
      };
    if (value is int) return {'integerValue': value.toString()};
    if (value is double) return {'doubleValue': value};
    if (value is String) return {'stringValue': value};
    if (value is bool) return {'booleanValue': value};
    if (value is List)
      return {
        'arrayValue': {'values': value.map(_convertValueToFirestore).toList()},
      };
    throw Exception('Unsupported value type: ${value.runtimeType}');
  }
}
