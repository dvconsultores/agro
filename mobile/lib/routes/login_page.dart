import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sap_avicola/repositories/auth_api.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/services/local_auth_service.dart';
import 'package:sap_avicola/utils/services/local_data/hive_data_service.dart';
import 'package:sap_avicola/utils/services/local_data/secure_storage_service.dart';
import 'package:sap_avicola/widgets/defaults/button.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/defaults/snackbar.dart';
import 'package:sap_avicola/widgets/form_fields/checkbox.dart';
import 'package:sap_avicola/widgets/form_fields/input_field.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.fromSplashPage = false});
  final bool fromSplashPage;
  @override
  State<LoginPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LoginPage> {
  late final authApi = AuthApi(context);

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _rememberMe = ValueNotifier<bool>(false);
  bool _obscureText = true;

  bool haveBiometrics = false;
  bool biometricsActive = false;

  String? localUsername;
  String? localPassword;

  late final loader = AppLoader.of(context);

  /*void _callSetStateAfterBuild(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => fn()));
  }*/

  Future<void> getData() async {
    if (HiveData.read(HiveDataCollection.rememberMe) ?? false) {
      _rememberMe.value = true;
    }
    if (HiveData.read(HiveDataCollection.biometrics) ?? false) {
      biometricsActive = true;
    }
    haveBiometrics = await LocalAuth.hasBiometrics() &&
        (HiveData.read(HiveDataCollection.biometrics) ?? true);
    _rememberMe.value = HiveData.read(HiveDataCollection.rememberMe) ?? false;

    if (_rememberMe.value) {
      localUsername = await SecureStorage.read(SecureCollection.username);
      localPassword = await SecureStorage.read(SecureCollection.password);
      _userController.text = localUsername ?? '';
    } else {
      await SecureStorage.delete(SecureCollection.username);
    }
    if (!mounted) return;

    setState(() {});
    if (widget.fromSplashPage && canBiometric) await bioLogin();
  }

  bool get canBiometric =>
      haveBiometrics &&
      localUsername == _userController.text &&
      localPassword != null;

  Future<void> login({
    required String username,
    required String password,
    bool bio = false,
  }) async {
    if (!bio &&
        (!(_userController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty) ||
            loader.loading)) return;

    // FocusScope.of(context).unfocus();
    loader.init();
    setState(() {});

    try {
      HiveData.write(HiveDataCollection.rememberMe, _rememberMe.value);

      await authApi.signIn(username: username, password: password);
      if (!mounted) return;

      setState(loader.close);

      // Navigator.of(context).popUntil((route) => route.isFirst);
      // Asegúrate de que no haya operaciones de navegación en conflicto
      /*if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

      // changePageRightWithBloc(2, context);
      await Future.delayed(const Duration(milliseconds: 300));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );*/

      /*NavConst.pushReplacement(
          context, const HomePage());*/

      router.goNamed("home");
    } catch (error) {
      setState(loader.close);
      showSnackbar(error.toString(), type: SnackbarType.error);
    }
  }

  Future<void> bioLogin() async {
    final bool isAuthenticated = await LocalAuth.authenticate();
    if (!isAuthenticated) return;

    await login(username: localUsername!, password: localPassword!, bio: true);
  }

  @override
  void initState() {
    authApi.clearTokenAuth();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _rememberMe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return AppScaffold(
      scrollable: true,
      paintedScaffold: false,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Gap(media.size.height * .13).column,
        Hero(
          tag: "logo demo",
          child: SvgPicture.asset('assets/logos/logo.svg'),
        ),
        /*const Text(
          "dataIO29",
          style: TextStyle(fontSize: 30),
        ),*/
        Gap(55.sp).column,
        InputField(
          controller: _userController,
          labelText: "Usuario",
          hintText: "Admin",
        ),
        Gap(24.sp).column,
        InputField(
          controller: _passwordController,
          labelText: "Clave",
          hintText: "Admin",
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        Gap(16.sp).column,
        CheckboxFieldV2(
          controller: _rememberMe,
          labelText: "Recuérdame",
        ),
        Gap(24.sp).column,
        Row(children: [
          Expanded(
              child: Button(
            text: "Iniciar Sesión",
            onPressed: () {
              if (_userController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty) {
                final user = _userController.text;
                final password = _passwordController.text;
                login(username: user, password: password);
              } else {
                showSnackbar("Por favor, rellene todos los campos",
                    type: SnackbarType.error);
              }
            },
          )),
          const Gap(Vars.gapNormal).row,
          if (biometricsActive)
            Button.iconVariant(
              icon: const Icon(Icons.fingerprint_rounded),
              onPressed: bioLogin,
            ),
        ]),
        Gap(22.sp).column,
        /*Button.textVariant(
          text: "¿Olvidaste la contraseña?",
          textStyle: const TextStyle(
            color: Color(0xFF3B1039),
            fontWeight: FontWeight.w500,
          ),
          onPressed: () {},
        )*/
      ]),
    );
  }
}
