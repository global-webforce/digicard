import 'package:digicard/app/app.locator.dart';
import 'package:digicard/app/constants/colors.dart';
import 'package:digicard/app/constants/dimensions.dart';
import 'package:digicard/app/extensions/color_extension.dart';
import 'package:digicard/app/models/digital_card.dart';
import 'package:digicard/app/ui/_core/ez_button.dart';
import 'package:digicard/app/ui/_core/scaffold_body_wrapper.dart';
import 'package:digicard/app/ui/overlays/loader_overlay_wrapper.dart';
import 'package:digicard/app/views/card_open/card_open_viewmodel.dart';
import 'package:digicard/app/views/card_open/widgets/card_display.dart';
import 'package:digicard/app/views/card_open/widgets/card_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import 'widgets/card.appbar.dart';

class CardOpenView extends StatelessWidget {
  final DigitalCard card;
  final ActionType actionType;
  const CardOpenView({Key? key, required this.card, required this.actionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CardOpenViewModel>.reactive(
        viewModelBuilder: () => locator<CardOpenViewModel>(),
        disposeViewModel: false,
        onViewModelReady: (model) {
          model.initialize(card, actionType);
          model.context = context;
        },
        onDispose: (model) {
          model.formModel.reset();
          model.formModel.form.dispose();
          model.formModel.customLinksCustomLinkForm
              .map((e) => e.form.dispose());
        },
        builder: (context, viewModel, child) {
          final isUserPresent = viewModel.user != null;
          final isCardOwnedByUser =
              "${viewModel.formModel.model.userId}" == "${viewModel.user?.id}";
          final isCardInContacts =
              viewModel.isCardInContacts(viewModel.formModel.model.id);

          /***/

/***/

          return ReactiveDigitalCardForm(
            form: viewModel.formModel,
            child: ReactiveValueListenableBuilder<dynamic>(
                formControl: viewModel.formModel.colorControl,
                builder: (context, color, child) {
                  final colorTheme = Color(color.value ?? kcPrimaryColorInt);

                  screenBottomPadding() {
                    // When bottomsheet is visible it blocks bottom contact of card
                    // to fix this, a bottom padding is added
                    return EdgeInsets.only(
                        bottom: viewModel.editMode ? 0.0 : 100.0);
                  }

                  adPanel() {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorTheme.darken(0.2),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "A Free Digital Business Card from Digicard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }

                  Widget youOwnButton() {
                    return EzButton.elevated(
                      foreground: Colors.white,
                      background: colorTheme,
                      title: " You own this card",
                      onTap: null,
                    );
                  }

                  Widget saveButton() {
                    return EzButton.elevated(
                      background: colorTheme,
                      title: "Save Contact",
                      onTap: () async {
                        await viewModel.saveToContacts(card);
                      },
                    );
                  }

                  return WillPopScope(
                    onWillPop: () async {
                      return await viewModel.confirmExit();
                    },
                    child: SafeArea(
                      top: viewModel.editMode ? false : false,
                      child: LoaderOverlayWrapper(
                          type: viewModel.busy(saveBusyKey)
                              ? LoadingType.save
                              : viewModel.busy(doneBusyKey)
                                  ? LoadingType.done
                                  : null,
                          builder: (context) {
                            return LayoutBuilder(builder: (context, size) {
                              final cardWidth = Dimens.computedWidth(
                                  screenSize: size,
                                  targetWidth: 540,
                                  vPadding: 0,
                                  hPadding: 0);
                              return Scaffold(
                                extendBodyBehindAppBar: !viewModel.editMode,
                                appBar: const CardAppBar(),
                                bottomSheet: viewModel.actionType ==
                                        ActionType.test
                                    ? LayoutBuilder(builder: (context, size) {
                                        return Container(
                                          color: Colors.transparent,
                                          padding: cardWidth,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 8.0, 8.0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                isUserPresent
                                                    ? isCardOwnedByUser
                                                        ? youOwnButton()
                                                        : !isCardInContacts
                                                            ? saveButton()
                                                            : const SizedBox
                                                                .shrink()
                                                    : const SizedBox.shrink(),
                                                if (kIsWeb) adPanel()
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                    : const SizedBox.shrink(),
                                body: ScaffoldBodyWrapper(
                                    isFullWidth: true,
                                    padding: cardWidth,
                                    builder: (context, size) {
                                      return Padding(
                                        padding: screenBottomPadding(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (!viewModel.editMode)
                                              const CardDisplay(),
                                            if (viewModel.editMode)
                                              const CardForm(),
                                          ],
                                        ),
                                      );
                                    }),
                              );
                            });
                          }),
                    ),
                  );
                }),
          );
        });
  }
}
