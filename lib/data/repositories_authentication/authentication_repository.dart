import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lhstore/admin/adminscreen.dart';
import 'package:lhstore/admin/controllers/menu_app_controller.dart';
import 'package:lhstore/data/user/user_authentication.dart';
import 'package:lhstore/features/authentication/screens/login/login.dart';
import 'package:lhstore/features/authentication/screens/onboarding_screen.dart';
import 'package:lhstore/features/authentication/screens/signup/verify_email.dart';
import 'package:lhstore/navigation_menu.dart';
import 'package:lhstore/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:lhstore/utils/exceptions/firebase_exceptions.dart';
import 'package:lhstore/utils/exceptions/format_exceptions.dart';
import 'package:lhstore/utils/exceptions/platform_exceptions.dart';
import 'package:provider/provider.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    super.onReady();
    screenRedirect(); // Handle redirection when the app starts
  }

  /// Redirect user to appropriate screen
void screenRedirect() async {
  final user = _auth.currentUser;

  if (user != null) {
    if (user.emailVerified) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final isAdmin = userDoc.data()?['_isAdmin'] ?? false;

          if (isAdmin) {
            // Wrap AdminScreen in a proper MultiProvider
            Get.offAll(
              () => MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => MenuAppController()),
                ],
                child: AdminScreen(),
              ),
            );
          } else {
            Get.offAll(() => NavigationMenu());
          }
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .set({
            'Email': user.email,
          });
          Get.offAll(() => NavigationMenu());
        }
      } catch (e) {
        Get.offAll(() => LoginScreen());
      }
    } else {
      Get.offAll(() => VerifyEmailScreen(email: user.email));
    }
  } else {
    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(() => LoginScreen())
        : Get.offAll(() => OnBoardingScreen());
  }
}

  // EmailAuthentication Login//

  /// Login with email and password
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Ensure user document exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'Email': email,
          '_isAdmin': false, // Default non-admin
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again.";
    }
  }

  /// Register a new user with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'Email': email,
        '_isAdmin': false, // Default non-admin
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again.";
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Some thing went wrong Please try again";
    }
  }

  // forget password email //

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Some thing went wrong Please try again";
    }
  }

  // forget password email//
  Future<void> userAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong. Please try again";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      throw "Something went wrong. Please try again.";
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Ensure user document exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'Email': userCredential.user?.email,
          '_isAdmin': false, // Default non-admin
        });
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

  // delete//
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something Went Worng, Please try again";
    }
  }

  // ReAuth//
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something Went Worng, Please try again";
    }
  }
}
