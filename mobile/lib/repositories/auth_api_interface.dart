import 'package:sap_avicola/models/profile_model.dart';

abstract class AuthApiInterface {
  Future<void> signIn({required String username, required String password});
  Future<ProfileModel> signUp();
  void signOut();
  void clearTokenAuth();
}
