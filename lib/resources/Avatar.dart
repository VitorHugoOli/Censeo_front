import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Avatar extends StatelessWidget {
  final String profile;
  final Color circulaColor;
  final double heightPhoto;

  Avatar(this.profile,
      {this.circulaColor = const Color(0xfffffff), this.heightPhoto = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: circulaColor,
        shape: BoxShape.circle,
      ),
      child: profile != null
          ? Image.network(
              profile,
              height: heightPhoto,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Container(
                  height: heightPhoto,
                  child: Center(
                    child: Icon(Feather.cloud_off, size: 20),
                  ),
                );
              },
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            )
          : Image.asset(
              'assets/Avatar.png',
              height: heightPhoto,
            ),
    );
  }
}
