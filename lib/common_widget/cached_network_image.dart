import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


Widget cachedNetworkImageWidget({required String url}) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    ),
    placeholder: (context, url) =>
        SizedBox(width: 10, height: 10, child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => Icon(
      Icons.error,
    ),
  );
}