import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDebugger {
  static void printFirebaseStatus() {
    print('=== FIREBASE DEBUG INFO ===');
    
    // Check if Firebase is initialized
    try {
      if (Firebase.apps.isNotEmpty) {
        print('✅ Firebase is initialized');
        print('📱 Current app: ${Firebase.app().name}');
        print('🔗 Project ID: ${Firebase.app().options.projectId}');
      } else {
        print('❌ Firebase is NOT initialized');
        return;
      }
    } catch (e) {
      print('❌ Error checking Firebase initialization: $e');
      return;
    }

    // Check Firebase Auth status
    try {
      final auth = FirebaseAuth.instance;
      print('🔐 Auth instance: ${auth.toString()}');
      print('👤 Current user: ${auth.currentUser?.email ?? "No user signed in"}');
      print('🌐 Auth domain: ${Firebase.app().options.authDomain}');
    } catch (e) {
      print('❌ Error accessing Firebase Auth: $e');
    }

    print('========================');
  }

  static Future<void> testAuthentication(String email, String password) async {
    print('=== TESTING AUTHENTICATION ===');
    
    try {
      print('🔄 Attempting to create user...');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      print('✅ User created successfully!');
      print('👤 User ID: ${userCredential.user?.uid}');
      print('📧 Email: ${userCredential.user?.email}');
      print('✅ Email verified: ${userCredential.user?.emailVerified}');
      
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Exception:');
      print('   Code: ${e.code}');
      print('   Message: ${e.message}');
      print('   Plugin: ${e.plugin}');
      
      // Common error codes and solutions
      switch (e.code) {
        case 'email-already-in-use':
          print('💡 Solution: Try logging in instead of registering');
          break;
        case 'weak-password':
          print('💡 Solution: Use a stronger password (at least 6 characters)');
          break;
        case 'invalid-email':
          print('💡 Solution: Check email format');
          break;
        case 'operation-not-allowed':
          print('💡 Solution: Enable Email/Password authentication in Firebase Console');
          break;
        default:
          print('💡 Check Firebase Console and authentication settings');
      }
    } catch (e) {
      print('❌ General Exception: $e');
    }
    
    print('==============================');
  }
}
