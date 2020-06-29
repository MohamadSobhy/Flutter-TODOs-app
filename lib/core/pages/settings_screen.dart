import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailor/sailor.dart';
import 'package:todo_list_app/core/theme/app_theme.dart';
import 'package:todo_list_app/core/theme/bloc/theme_bloc.dart';
import 'package:todo_list_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:todo_list_app/features/authentication/presentation/pages/login_screen.dart';

import '../../main.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'APP THEME',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          ...buildAppThemeFilters(context),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              child: Text(
                'LOG OUT',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildAppThemeFilters(context) {
    return appThemesData.keys
        .map(
          (appTheme) => Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            child: InkWell(
              onTap: () => _onAppThemeChanged(appTheme, context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                child: Text(
                  appTheme.toString(),
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: appThemesData[appTheme].primaryColor,
                      ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  void _onAppThemeChanged(AppTheme appTheme, context) {
    final bloc = BlocProvider.of<ThemeBloc>(context);
    switch (appTheme) {
      case AppTheme.purpleLight:
        {
          bloc.add(
            ChangeAppThemeEvent(appTheme: AppTheme.purpleLight),
          );
          break;
        }
      case AppTheme.purpleDark:
        {
          bloc.add(
            ChangeAppThemeEvent(appTheme: AppTheme.purpleDark),
          );
          break;
        }
      case AppTheme.greenDark:
        {
          bloc.add(ChangeAppThemeEvent(appTheme: AppTheme.greenDark));
          break;
        }
      case AppTheme.greenLight:
        {
          bloc.add(ChangeAppThemeEvent(appTheme: AppTheme.greenLight));
          break;
        }
    }
  }
}
