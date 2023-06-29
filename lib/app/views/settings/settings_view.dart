import 'package:digicard/app/app.locator.dart';
import 'package:digicard/app/ui/_core/settings_ui.dart';
import 'package:digicard/app/views/dashboard/dashboard_view.dart';
import 'package:digicard/app/views/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.nonReactive(
        viewModelBuilder: () => locator<SettingsViewModel>(),
        onViewModelReady: (viewModel) async {},
        disposeViewModel: false,
        builder: (context, viewModel, child) {
          return DashboardBuilder(onPop: (v) {
            v.setIndex(0);
            return Future.value(false);
          }, builder: (context, child) {
            return Scaffold(
                drawer: child.drawer,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("SETTINGS"),
                ),
                bottomNavigationBar: child.bottomNavBar,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SettingsItem.header(leading: "Plan"),
                      const SettingsItem(
                        leading: "Digicard Free",
                        subtitle: "Contact us to upgrade your plan.",
                      ),
                      const SettingsItem.header(
                        leading: "Digicard",
                      ),
                      const SettingsItem(
                        leading: "Version",
                        trailing: "1.0.0",
                      ),
                      const Divider(height: 0),
                      const SettingsItem(
                        leading: "Developer",
                        trailing: "Global Webforce",
                      ),
                      const SettingsItem.header(
                        leading: "Digicard",
                      ),
                      SettingsItem(
                        leading: "Theme",
                        trailing: "Toggle Dark Mode",
                        onTap: () {
                          getThemeManager(context).toggleDarkLightTheme();
                        },
                      ),
                      const SettingsItem.header(leading: "Account"),
                      SettingsItem(
                        leading: "Email",
                        trailing: viewModel.email,
                      ),
                      const Divider(height: 0),
                      SettingsItem(
                        leading: "Logout",
                        onTap: () {
                          viewModel.logout();
                        },
                      ),
                    ],
                  ),
                ));
          });
        });
  }
}
