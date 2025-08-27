import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageNetwork extends StatelessWidget {
  final String imagePath;
  final String tag;

  const FullImageNetwork({
    super.key,
    required this.imagePath,
    this.tag = "test",
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isLocalImage = imagePath.startsWith('assets/');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Hero(
          tag: tag,
          child: isLocalImage
              ? Image.asset(
            imagePath,
            fit: BoxFit.contain,
          )
              : CachedNetworkImage(
            imageUrl: imagePath,
            imageBuilder: (_, imageProvider) => PhotoView(
              imageProvider: imageProvider,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
            placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (_, __, ___) => const Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
