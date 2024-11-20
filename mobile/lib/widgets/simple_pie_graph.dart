import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/helper_widgets/text_decimal_widget.dart';
import 'package:sap_avicola/utils/mixins/general_mixins.dart';

class SimplePieGraph extends StatelessWidget with ThemesMixin {
  SimplePieGraph({
    super.key,
    this.size = 500,
    this.sizeFactor = 1,
    required this.color,
    required this.value,
    this.bgColor,
    this.title,
    this.showState = false,
    this.higherStateText = "Excelente",
    this.highStateText = "Muy Bien",
    this.regularStateText = "Bien",
    this.lowerStateText = "Regular",
  });
  final double size;
  final double sizeFactor;
  final Color color;
  final double value;
  final Color? bgColor;
  final String? title;
  final bool showState;
  final String higherStateText;
  final String highStateText;
  final String regularStateText;
  final String lowerStateText;

  @override
  Widget build(BuildContext context) {
    String getStateText() {
      if (value <= 20) {
        return lowerStateText;
      } else if (value <= 40) {
        return regularStateText;
      } else if (value <= 60) {
        return highStateText;
      } else {
        return higherStateText;
      }
    }

    return Container(
      width: size / 2,
      height: size / 2,
      padding: EdgeInsets.all(15.3 * sizeFactor),
      decoration: BoxDecoration(
        color: bgColor ?? theme.cardColor,
        boxShadow: const [Vars.boxShadow3],
        borderRadius: const BorderRadius.all(Radius.circular(200)),
      ),
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: CircularProgressIndicator(
            strokeWidth: 30 * sizeFactor,
            value: value / 100,
            color: color,
            backgroundColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16 * sizeFactor,
            horizontal: 18 * sizeFactor,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (title.hasValue) ...[
              Text(title!,
                  style: TextStyle(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    height: 1.2 * sizeFactor,
                  )),
              const Gap(8).column,
            ],
            TextDecimal("$value",
                symbol: "%",
                customPatterm: '#,##0.00¤',
                maxDecimals: 1,
                minimumFractionDigits: 0,
                defaultDecimalRedux: 0,
                styleDecimals: const TextStyle(fontWeight: FontWeight.w700),
                style: TextStyle(
                  fontSize: 45.sp * sizeFactor,
                  fontWeight: FontWeight.w700,
                )),
            if (showState)
              Text(getStateText(),
                  style: TextStyle(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: color,
                  )),
          ]),
        )
      ]),
    );
  }
}
