import 'package:firebase/src/auth/fb_auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });

  group('FbAuthController', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FbAuthController authController;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authController = FbAuthController(mockFirebaseAuth);
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
    });

    group('currentUser', () {
      test('should return current user when user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final result = authController.currentUser;

        expect(result, equals(mockUser));
      });

      test('should return null when no user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final result = authController.currentUser;

        expect(result, isNull);
      });
    });

    group('isSignedIn', () {
      test('should return true when user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final result = authController.isSignedIn;

        expect(result, isTrue);
      });

      test('should return false when no user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final result = authController.isSignedIn;

        expect(result, isFalse);
      });
    });

    group('authStateChanges', () {
      test('should return stream of auth state changes', () {
        final userStream = Stream<User?>.value(mockUser);
        when(
          () => mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => userStream);

        final result = authController.authStateChanges;

        expect(result, equals(userStream));
      });
    });

    group('createAccount', () {
      test('should create account successfully and return user uid', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const uid = 'test-uid';

        when(() => mockUser.uid).thenReturn(uid);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authController.createAccount(
          email: email,
          password: password,
        );

        expect(result, equals(uid));
        verify(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test(
        'should throw UserCreationFailedException when user is null',
        () async {
          const email = 'test@example.com';
          const password = 'password123';

          when(() => mockUserCredential.user).thenReturn(null);
          when(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          await expectLater(
            () =>
                authController.createAccount(email: email, password: password),
            throwsA(isA<UserCreationFailedException>()),
          );
        },
      );

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => authController.createAccount(email: email, password: password),
          throwsA(isA<EmailAlreadyInUseException>()),
        );
      });

      test('should throw AuthException when general exception occurs', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => authController.createAccount(email: email, password: password),
          throwsA(isA<UnknownAuthException>()),
        );
      });
    });

    group('signIn', () {
      test('should sign in successfully and return user uid', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const uid = 'test-uid';

        when(() => mockUser.uid).thenReturn(uid);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authController.signIn(
          email: email,
          password: password,
        );

        expect(result, equals(uid));
        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('should throw SignInFailedException when user is null', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockUserCredential.user).thenReturn(null);
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        expectLater(
          () => authController.signIn(email: email, password: password),
          throwsA(isA<SignInFailedException>()),
        );
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authController.signIn(email: email, password: password),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });

    group('signOut', () {
      test('should sign out successfully', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await authController.signOut();

        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        when(
          () => mockFirebaseAuth.signOut(),
        ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        expect(
          () => authController.signOut(),
          throwsA(isA<NetworkRequestFailedException>()),
        );
      });
    });

    group('deleteAccount', () {
      test(
        'should delete account successfully after reauthentication',
        () async {
          const email = 'test@example.com';
          const password = 'password123';
          final mockCredential = MockAuthCredential();

          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(
            () => mockUser.reauthenticateWithCredential(any()),
          ).thenAnswer((_) async => mockUserCredential);
          when(() => mockUser.delete()).thenAnswer((_) async {});

          await authController.deleteAccount(email: email, password: password);

          verify(() => mockUser.reauthenticateWithCredential(any())).called(1);
          verify(() => mockUser.delete()).called(1);
        },
      );

      test('should throw NoCurrentUserException when no user is signed in', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        expect(
          () => authController.deleteAccount(email: email, password: password),
          throwsA(isA<NoCurrentUserException>()),
        );
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(
          () => mockUser.reauthenticateWithCredential(any()),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => authController.deleteAccount(email: email, password: password),
          throwsA(isA<WrongPasswordException>()),
        );
      });
    });

    group('updatePassword', () {
      test(
        'should update password successfully after reauthentication',
        () async {
          const email = 'test@example.com';
          const currentPassword = 'oldPassword123';
          const newPassword = 'newPassword123';

          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(
            () => mockUser.reauthenticateWithCredential(any()),
          ).thenAnswer((_) async => mockUserCredential);
          when(
            () => mockUser.updatePassword(newPassword),
          ).thenAnswer((_) async {});

          await authController.updatePassword(
            email: email,
            currentPassword: currentPassword,
            newPassword: newPassword,
          );

          verify(() => mockUser.reauthenticateWithCredential(any())).called(1);
          verify(() => mockUser.updatePassword(newPassword)).called(1);
        },
      );

      test('should throw NoCurrentUserException when no user is signed in', () {
        const email = 'test@example.com';
        const currentPassword = 'oldPassword123';
        const newPassword = 'newPassword123';

        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        expect(
          () => authController.updatePassword(
            email: email,
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
          throwsA(isA<NoCurrentUserException>()),
        );
      });

      test(
        'should throw AuthException when FirebaseAuthException occurs during reauthentication',
        () {
          const email = 'test@example.com';
          const currentPassword = 'wrongPassword';
          const newPassword = 'newPassword123';

          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          when(
            () => mockUser.reauthenticateWithCredential(any()),
          ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

          expect(
            () => authController.updatePassword(
              email: email,
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
            throwsA(isA<WrongPasswordException>()),
          );
        },
      );
    });

    group('resetPassword', () {
      test('should send password reset email successfully', () async {
        const email = 'test@example.com';

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).thenAnswer((_) async {});

        await authController.resetPassword(email: email);

        verify(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).called(1);
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const email = 'invalid@example.com';

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authController.resetPassword(email: email),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });

    group('confirmPasswordReset', () {
      test('should confirm password reset successfully', () async {
        const code = 'reset-code';
        const newPassword = 'newPassword123';

        when(
          () => mockFirebaseAuth.confirmPasswordReset(
            code: code,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async {});

        await authController.confirmPasswordReset(
          code: code,
          newPassword: newPassword,
        );

        verify(
          () => mockFirebaseAuth.confirmPasswordReset(
            code: code,
            newPassword: newPassword,
          ),
        ).called(1);
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const code = 'invalid-code';
        const newPassword = 'newPassword123';

        when(
          () => mockFirebaseAuth.confirmPasswordReset(
            code: code,
            newPassword: newPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-action-code'));

        expect(
          () => authController.confirmPasswordReset(
            code: code,
            newPassword: newPassword,
          ),
          throwsA(isA<UnknownAuthException>()),
        );
      });
    });

    group('verifyPasswordResetCode', () {
      test('should verify password reset code and return email', () async {
        const code = 'valid-code';
        const email = 'test@example.com';

        when(
          () => mockFirebaseAuth.verifyPasswordResetCode(code),
        ).thenAnswer((_) async => email);

        final result = await authController.verifyPasswordResetCode(code: code);

        expect(result, equals(email));
        verify(() => mockFirebaseAuth.verifyPasswordResetCode(code)).called(1);
      });

      test('should throw AuthException when FirebaseAuthException occurs', () {
        const code = 'invalid-code';

        when(
          () => mockFirebaseAuth.verifyPasswordResetCode(code),
        ).thenThrow(FirebaseAuthException(code: 'invalid-action-code'));

        expect(
          () => authController.verifyPasswordResetCode(code: code),
          throwsA(isA<UnknownAuthException>()),
        );
      });
    });

    group('AuthException', () {
      test(
        'should create correct exception from FirebaseAuthException codes',
        () {
          final testCases = [
            ('user-not-found', UserNotFoundException),
            ('wrong-password', WrongPasswordException),
            ('invalid-email', InvalidEmailException),
            ('email-already-in-use', EmailAlreadyInUseException),
            ('weak-password', WeakPasswordException),
            ('too-many-requests', TooManyRequestsException),
            ('requires-recent-login', RequiresRecentLoginException),
            ('user-disabled', UserDisabledException),
            ('operation-not-allowed', OperationNotAllowedException),
            ('invalid-credential', InvalidCredentialException),
            ('credential-already-in-use', CredentialAlreadyInUseException),
            ('network-request-failed', NetworkRequestFailedException),
          ];

          for (final (code, expectedType) in testCases) {
            final firebaseException = FirebaseAuthException(code: code);
            final authException = AuthException.fromFirebaseAuth(
              firebaseException,
            );
            expect(
              authException,
              isA<dynamic>().having((e) => e.runtimeType, 'type', expectedType),
            );
          }
        },
      );

      test(
        'should create UnknownAuthException for unknown Firebase error codes',
        () {
          final firebaseException = FirebaseAuthException(
            code: 'unknown-error',
            message: 'Unknown error message',
          );
          final authException = AuthException.fromFirebaseAuth(
            firebaseException,
          );

          expect(authException, isA<UnknownAuthException>());
          expect(
            authException.message,
            contains('Firebase error: Unknown error message'),
          );
        },
      );

      test('should create UnknownAuthException from general exceptions', () {
        final exception = Exception('General error');
        final authException = AuthException.fromException(exception);

        expect(authException, isA<UnknownAuthException>());
        expect(authException.message, contains('An unexpected error occurred'));
      });

      test(
        'should handle FirebaseAuthException through fromException factory',
        () {
          final firebaseException = FirebaseAuthException(
            code: 'user-not-found',
          );
          final authException = AuthException.fromException(firebaseException);

          expect(authException, isA<UserNotFoundException>());
        },
      );
    });
  });
}
