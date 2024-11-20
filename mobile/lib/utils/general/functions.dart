import 'dart:convert';
import 'dart:io' show Directory, File;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' show Response, get;
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/dialogs/modal_widget.dart';
import 'package:sap_avicola/widgets/sheets/bottom_sheet_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

Future<ByteArrayAndroidBitmap?> buildAndroidBitmap(
  String? imageUrl, {
  Size? size,
}) async {
  if (imageUrl == null || !imageUrl.hasNetworkPath) return null;

  final byteData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
  var bytes = byteData.buffer.asUint8List();

  if (size != null) {
    final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: size.width.toInt(),
          targetHeight: size.height.toInt(),
        ),
        frame = await codec.getNextFrame();

    bytes = (await frame.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  return ByteArrayAndroidBitmap.fromBase64String(base64Encode(bytes));
}

Future<String?> downloadAndSavePicture(
  String? url, {
  String? fileName,
  String extensionType = 'png',
}) async {
  if (url.hasNotValue) return null;
  final Directory directory = await getApplicationDocumentsDirectory();
  final filePath =
      '${directory.path}/${fileName ?? "file-${DateTime.now()}"}.$extensionType';

  final Response response = await get(Uri.parse(url!));
  await File(filePath).writeAsBytes(response.bodyBytes);
  return filePath;
}

void unfocus(BuildContext context) => FocusScope.of(context).unfocus();

/// Read JSON asset file
Future<T> getJsonFile<T>(String path) async =>
    jsonDecode(await rootBundle.loadString(path));

/// * Helper to multiple pop callbacks
void popMultiple(BuildContext context, [int count = 1]) {
  if (count <= 0) return;

  Navigator.pop(context);
  popMultiple(context, count - 1);
}

/// * Launch external url from the app
Future<void> openUrl(String url) async {
  final urlParsed = Uri.parse(url);
  if (!await launchUrl(urlParsed, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $urlParsed');
  }
}

/// * Used to get a function instance inside widget building
T buildWidget<T>(T Function() callback) => callback();

/// A global menu that can be invoked onto whatever widget.
Future<String?> showPopup(
  BuildContext context, {
  required List<PopupMenuItem<String>> items,
  double? offsetY,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  clipBehavior = Clip.none,
  String? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? color = Colors.white,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) async {
  //*get the render box from the context
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //*get the global position, from the widget local position
  final offset = renderBox.localToGlobal(Offset.zero);

  //*calculate the start point in this case, below the button
  final left = offset.dx;
  final top = offset.dy /* + renderBox.size.height */ + (offsetY ?? 0);
  //*The right does not indicates the width
  final right = left + renderBox.size.width;

  return await showMenu<String>(
    context: context,
    clipBehavior: clipBehavior,
    initialValue: initialValue,
    shadowColor: shadowColor,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Vars.radius15)),
        ),
    color: color,
    elevation: elevation,
    constraints:
        constraints ?? BoxConstraints(minWidth: context.size?.width ?? 100),
    position: RelativeRect.fromLTRB(left, top, right, 0.0),
    items: items,
  );
}

Future<void> attachmentPressed(
  BuildContext context, {
  bool hideBottomNavigationBar = false,
  VoidCallback? onVideo,
  VoidCallback? onImage,
  VoidCallback? onMedia,
}) async {
  final items = <Map<String, dynamic>>[];

  if (onVideo != null) {
    items.add({
      "text": "Make video",
      "icon": Icons.video_camera_back_outlined,
      "action": onVideo,
    });
  }

  if (onImage != null) {
    items.add({
      "text": "Take photo",
      "icon": Icons.camera_alt_outlined,
      "action": onImage,
    });
  }

  if (onMedia != null) {
    items.add({
      "text": "Upload media",
      "icon": Icons.photo_size_select_actual_outlined,
      "action": onMedia,
    });
  }

  await BottomSheetList.showModal<void>(
    ContextUtility.context!,
    maxChildSize: context.height.isSmall ? .33 : .3,
    initialChildSize: context.height.isSmall ? .33 : .3,
    onTap: (item) => (item.value as VoidCallback)(),
    items: items
        .map((item) => DropdownMenuItem(
              value: item['action'] as VoidCallback,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  item['icon'] as IconData,
                  size: 20,
                ),
                const Gap(Vars.gapNormal).row,
                Text(
                  item['text'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
            ))
        .toList(),
  );
}

Future<void> checkVersion(BuildContext context) =>
    PackageInfo.fromPlatform().then((packageInfo) async {
      final (minVersion, currentVersion) =
          ("1.0.0", "1.0.0"); //? implement fetch to get version 🖊️

      final packageVersion = packageInfo.version,
          hasUpdate =
              Version.parse(packageVersion) < Version.parse(currentVersion),
          requireUpdate =
              Version.parse(packageVersion) < Version.parse(minVersion);

      if (context.mounted && hasUpdate) {
        await Modal.showSystemAlert(
          context,
          barrierColor: Colors.black.withOpacity(.1),
          titleText: "Update Available!",
          contentText: requireUpdate
              ? "You must to update the application to continue"
              : "We have a new version available to you on the store",
          dismissible: !requireUpdate,
          textCancelBtn: requireUpdate ? null : "Continue",
          textConfirmBtn: "Update",
          onPressedConfirmBtn: (context) =>
              LaunchReview.launch(androidAppId: packageInfo.packageName),
        );
      }
    });
