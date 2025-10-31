import 'package:flutter/material.dart';

class CommonAppbarButton extends StatelessWidget {
  final Color? buttonColor, iconColor;
  final IconData? icon;
  final void Function()? buttonClick;
  final double? height, width;

  const CommonAppbarButton({
    super.key,
    this.buttonClick,
    this.buttonColor,
    this.icon,
    this.height,
    this.width,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonClick ??
          () {
            Navigator.of(context).pop();
          },
      child: SizedBox(
        height: height ?? 40,
        width: width ?? 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: buttonColor ?? Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon ?? Icons.arrow_back_ios_new_outlined,
              color: iconColor ?? Colors.black,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
