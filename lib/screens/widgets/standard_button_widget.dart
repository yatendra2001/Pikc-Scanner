import 'package:flutter/material.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class StandardButton extends StatelessWidget {
  const StandardButton({
    Key? key,
    required this.size,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Size size;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            padding: const EdgeInsets.all(0.0)),
        child: Container(
            constraints: BoxConstraints(
                maxWidth: size.width * 0.75, minHeight: size.height * 0.4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kGradientStartingColor, kGradientEndingColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: child),
      ),
    );
  }
}
