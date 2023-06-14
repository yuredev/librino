import 'package:flutter/material.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';

class SoftButtonWidget extends StatelessWidget {
  final void Function() onPress;
  final String title;
  final Color color;
  final Color? textColor;
  final Widget? leftIcon;
  final double? height;
  final double? width;

  const SoftButtonWidget({
    Key? key,
    required this.onPress,
    required this.title,
    required this.color,
    this.textColor,
    this.leftIcon,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWellWidget(
        borderRadius: 5,
        onTap: () {  },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            if (leftIcon != null) const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
