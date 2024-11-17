import 'package:flutter/material.dart';
import 'package:lhstore/utils/constants/colors.dart';
import 'package:lhstore/utils/constants/sizes.dart';

class LHRoundedimage extends StatelessWidget {
  const LHRoundedimage({
    super.key,
    this.border,
    this.padding,
    this.onPressed,
    this.width,
    this.height,
    this.applyImageRadius = true,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.backgroundColor = LHColor.light,
    this.isNetworkImage = false,
    this.borderRadius = LHSize.md
  });
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius): BorderRadius.zero,
          child: Image(fit: fit, image: isNetworkImage ? NetworkImage(imageUrl): AssetImage(imageUrl) as ImageProvider),
          ),
      ),
    );
  }
}