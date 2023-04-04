import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

bool isFileExistLocally(String fileDir) {
  bool res = false;
  try {
    if (fileDir.trim() != "null" && fileDir.trim() != "") {
      res = io.File(fileDir).existsSync();
    }
  } catch (e) {
    return false;
  }
  return res;
}

class CardLogo extends StatelessWidget {
  final Color color;

  /// Can be String (network-based image) orXFile (local upload)
  final String? imagePath;

  /// When set to true the widget will just display a plain colored container
  final bool readOnly;
  final Function()? onTap;

  const CardLogo({
    Key? key,
    this.imagePath,
    required this.color,
    this.onTap,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget errorWidget() {
      return readOnly
          ? const SizedBox.shrink()
          : InkWell(
              onTap: onTap != null ? () => onTap!() : null,
              child: Ink(
                child: Center(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.add,
                        size: 20,
                      ),
                      Text(
                        "LOGO",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
              ),
            );
    }

    if (imagePath?.trim() != "null" && imagePath?.trim() != "") {
      if (Uri.parse("$imagePath").isAbsolute) {
        return InkWell(
          onTap: onTap != null ? () => onTap!() : null,
          child: CachedNetworkImage(
            imageUrl: "$imagePath",
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            placeholder: (context, url) {
              return errorWidget();
            },
            errorWidget: (context, url, error) {
              return errorWidget();
            },
          ),
        );
      }

      if (isFileExistLocally("$imagePath")) {
        return InkWell(
          onTap: onTap != null ? () => onTap!() : null,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File("$imagePath")),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }
    }
    return errorWidget();
  }
}
