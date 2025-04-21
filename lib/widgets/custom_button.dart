import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.height,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.onPressed,
    required this.text,
    required this.textStyle,
    required this.context,
    required this.AppConstants,
  });

  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;
  final BuildContext context;
  final dynamic AppConstants;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppConstants.colorPalette[2],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style:
              textStyle ?? const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
