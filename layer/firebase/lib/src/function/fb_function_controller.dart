import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase/src/auth/fb_auth_controller.dart';

class FbFunctionException implements Exception {
  const FbFunctionException(this.cause, this.stackTrace);

  final Object cause;
  final StackTrace stackTrace;
}

class FbFunctionController {
  FbFunctionController(this._firebaseFunctions, this._authController);

  final FirebaseFunctions _firebaseFunctions;
  final FbAuthController _authController;

  Future<dynamic> callFunction(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final user = _authController.currentUser;
      if (user == null) {
        throw FbFunctionException('User not signed in', StackTrace.current);
      }

      final callable = _firebaseFunctions.httpsCallable(name);
      final response = await callable.call<dynamic>(parameters ?? {});
      if (response.data == null) {
        throw FbFunctionException('No data found', StackTrace.current);
      }
      return response.data;
    } on FbFunctionException {
      rethrow;
    } on FirebaseFunctionsException catch (e, st) {
      throw FbFunctionException(e.message ?? e.code, st);
    } catch (e, st) {
      throw FbFunctionException(e, st);
    }
  }
}
