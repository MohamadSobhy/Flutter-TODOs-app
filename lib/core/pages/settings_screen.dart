import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/core/theme/app_theme.dart';
import 'package:todo_list_app/core/theme/bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: buildAppThemeFilters()
            .keys
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
            .toList(),
      ),
    );
  }

  Map<AppTheme, ThemeData> buildAppThemeFilters() => appThemesData;

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
