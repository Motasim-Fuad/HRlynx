
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api_servies/repository/auth_repo.dart';
import '../main_screen/main_screen_view.dart';

class GoogleSignUpController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final isLoading = false.obs;

  // Persona ID should come from UI (e.g. 1 = Student, 2 = Tutor, etc.)
  final selectedPersonaId = 1.obs;

  Future<void> handleGoogleSignUp() async {
    try {
      isLoading.value = true;

      // Step 1: Sign in with Google via Firebase
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null || user.email == null) {
        Get.snackbar("Error", "Google sign-in failed: No user data.");
        return;
      }

      final email = user.email!;
      final name = user.displayName ?? 'Google User';

      // Step 2: Send to backend social login API
      final personaBody = {
        "persona": selectedPersonaId.value, // Update from UI if needed
      };

      final success = await _authRepo.googleSignUpAndSetPersona(
        email: email,
        name: name,
        provider: 'google',
        personaBody: personaBody,
      );

      // Step 3: Handle success or failure
      if (success) {
        Get.snackbar("Success", "Google sign-in complete and persona set.");
        print("motasim google singin ");
        // Navigate to dashboard or home
        // Get.offAllNamed('/dashboard');
        Get.to(MainScreen());
      } else {
        Get.snackbar("Error", "Failed to set persona after Google login.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("GoogleSignUp Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}