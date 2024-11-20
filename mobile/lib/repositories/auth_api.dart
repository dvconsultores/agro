import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sap_avicola/models/profile_model.dart';
import 'package:sap_avicola/repositories/auth_api_interface.dart';
import 'package:sap_avicola/utils/services/dio_service.dart';
import 'package:sap_avicola/utils/services/local_data/hive_data_service.dart';
import 'package:sap_avicola/utils/services/local_data/secure_storage_service.dart';

class AuthApi implements AuthApiInterface {
  AuthApi(this.context);
  final BuildContext context;
// Crear una instancia de Dio

  @override
  Future<void> signIn(
      {required String username, required String password}) async {
    // ? just for showcase - when go work uncomment other lines and delete this
    // final value = (
    //   "token AUTHENTICATION_TOKEN",
    //   ProfileModel.fromJson({
    //     "uid": 1,
    //     "name": "herian",
    //     "email": "detextre4@gmail.com",
    //     "photoURL": "unafotoahi"
    //   }).toJson()
    // );

    /* final value = await dio.postCustom(
       'endpoint/',
       showRequest: true,
       showResponse: true,
       requestRef: "endpoint",
    );

    HiveData.write(HiveDataCollection.profile, value.$2);

    await SecureStorage.write(
      SecureCollection.tokenAuth,
      value.$1,
    ).then((value) => context.goNamed('home')); */
    try {
      String macAddress = 'Unknown';

      // Obtener la dirección MAC
      final info = NetworkInfo();
      try {
        macAddress = await info.getWifiBSSID() ?? 'Unknown';
      } catch (e) {
        throw Exception("Error obteniendo la dirección MAC: $e");
      }

      final response = await dio.post('/user/login', data: {
        'userName': username,
        'password': password,
        'mac': macAddress
      });

      final token = response.data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);

      HiveData.write(HiveDataCollection.profile, payload);

      await SecureStorage.write(SecureCollection.tokenAuth, token);

      if (HiveData.read(HiveDataCollection.rememberMe) ?? false) {
        await SecureStorage.write(SecureCollection.username, username);
        await SecureStorage.write(SecureCollection.password, password);
      } else {
        await SecureStorage.delete(SecureCollection.username);
        await SecureStorage.delete(SecureCollection.password);
      }

      /*FirebaseCloudMessagingApi.generateToken();

      final [profile as ProfileModel, _] = await Future.wait([
        getProfile(),
        ControlCenterApi().initSources(navigatorKey.currentContext!)
      ]);

      return profile; */
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> signUp() {
    throw UnimplementedError();
  }

  @override
  void signOut() => SecureStorage.delete(SecureCollection.tokenAuth)
      .then((_) => context.goNamed("login"));

  @override
  Future<void> clearTokenAuth() async {
    if ((await SecureStorage.read(SecureCollection.tokenAuth)) == null) return;
    await SecureStorage.delete(SecureCollection.tokenAuth);
  }
}
