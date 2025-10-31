import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget content; // The widget inside the container
  final double topLeftRadius,
      bottomLeftRadius,
      bottomRightRadius,
      topRightRadius; // Radius of the border's corners
  final double? width;
  final double borderWidth; // Width of the border
  final Gradient borderGradient; // The gradient applied to the border
  final EdgeInsetsGeometry? margin; // Margin around the container
  final EdgeInsetsGeometry? contentPadding; // Padding inside the content
  final Color? containerColor;
  const GradientBorderContainer({
    required this.content,
    required this.borderGradient,
    super.key,
    this.topLeftRadius = 0.0,
    this.bottomLeftRadius = 0.0,
    this.bottomRightRadius = 0.0,
    this.topRightRadius = 0.0,
    this.borderWidth = 1.0,
    // this.height,
    this.width = double.infinity,
    this.margin,
    this.contentPadding,
    this.containerColor,
  });
  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: margin, // Apply margin if provided
      width: width,
      padding: const EdgeInsets.all(1), // Add padding for the border to show
      decoration: BoxDecoration(
        gradient: borderGradient, // Apply gradient to the border
        borderRadius: _getBorderRadius(), // Round the corners based on radius
      ),
      child: Container(
        width: width! - 1,
        padding: contentPadding, // Padding for the content inside the container
        decoration: BoxDecoration(
          color: containerColor, // Background color for the content area
          borderRadius: _getBorderRadius(), // Round corners for content as well
        ),
        child: content, // The content widget (could be anything)
      ),
    );
  }

  // Helper function to return border radius based on the 'radius' property
  BorderRadius _getBorderRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeftRadius),
      topRight: Radius.circular(topRightRadius),
      bottomRight: Radius.circular(bottomRightRadius),
      bottomLeft: Radius.circular(bottomLeftRadius),
    );
  }
}
