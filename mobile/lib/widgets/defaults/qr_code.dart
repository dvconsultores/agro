import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/variables.dart';

class AppQrCode extends StatelessWidget {
  const AppQrCode({
    super.key,
    required this.data,
    this.hideLogo = false,
    this.size,
    this.colored = false,
  });
  final String data;
  final double? size;
  final bool hideLogo;
  final bool colored;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(Vars.radius15)),
        side: BorderSide(
          width: 4,
          color: colored
              ? ThemeApp.colors(context).primary
              : ThemeApp.colors(context).text,
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: size,
        height: size,
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: size,
          backgroundColor: Colors.white,
          eyeStyle: QrEyeStyle(
            color: colored
                ? ThemeApp.colors(context).tertiary
                : ThemeApp.colors(context).text,
            eyeShape: QrEyeShape.circle,
          ),
          gapless: true,
          dataModuleStyle: QrDataModuleStyle(
            color: ThemeApp.colors(context).text,
            dataModuleShape: QrDataModuleShape.circle,
          ),
          embeddedImage:
              hideLogo ? null : const AssetImage('assets/images/avatar.png'),
        ),
      ),
    );
  }
}
