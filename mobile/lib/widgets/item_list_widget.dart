import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sap_avicola/utils/general/variables.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.name,
    this.icon,
    this.padding,
    this.height,
    this.onTap,
  });
  final String name;
  final dynamic icon;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: SizedBox(
            height: height,
            child: Row(children: [
              if (icon != null) ...{
                icon is IconData
                    ? Icon(icon, size: 25)
                    : (icon as String).endsWith(".svg")
                        ? SvgPicture.asset(icon)
                        : Image.asset(icon, height: 25),
                Gap(2.5.sp).row
              },
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(Vars.gapXLarge).row,
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        ),
      ),
    );
  }
}
