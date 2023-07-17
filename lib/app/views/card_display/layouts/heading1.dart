import 'dart:typed_data';
import 'dart:ui';

import 'package:digicard/app/views/card_display/card_display_viewmodel.dart';
import 'package:digicard/app/views/card_editor/widgets/card.wave_divider.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Heading1 extends StatelessWidget {
  const Heading1({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        getParentViewModel<CardDisplayViewModel>(context, listen: true);

    Widget logoField() {
      return AspectRatio(
        aspectRatio: 1 / 1,
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  viewModel.card.logoFile ?? Uint8List(0),
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, size) {
      return SizedBox(
        width: size.maxWidth,
        height: size.maxWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: viewModel.color,
                image: DecorationImage(
                  image: MemoryImage(
                    viewModel.card.avatarFile ?? Uint8List(0),
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: viewModel.color,
                      image: DecorationImage(
                          image: MemoryImage(viewModel.card.avatarFile ??
                              Uint8List(
                                0,
                              )),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: size.maxWidth,
              child: CardWaveDivider(
                context,
                color: viewModel.color,
                size: size,
                child: logoField(),
              ),
            )
          ],
        ),
      );
    });
  }
}
