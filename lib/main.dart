import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/features/todos/data/datasources/database_helper.dart';

import 'core/mixins/alerts_mixin.dart';
import 'core/pages/loading_screen.dart';
import 'core/pages/settings_screen.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/pages/login_screen.dart';
import 'features/todos/presentation/pages/home_screen.dart';
import 'features/todos/presentation/provider/todos_provider.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Routes.createRoutes();
  runApp(MyApp());
}

final myHomePage = MyHomePage();

class MyApp extends StatelessWidget with AlertsMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = servLocator<AuthBloc>();

            bloc.add(CheckLoggedInStateEvent());
            return bloc;
          },
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (ctx, state) {
          return Provider<TodoProvider>.value(
            value: servLocator<TodoProvider>(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.themeData,
              home: BlocListener<AuthBloc, AuthState>(
                listener: (ctx, state) {
                  if (state is ErrorState) {
                    print(state.message);
                    displaySnackbar(state.message, ctx);
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, state) {
                    final userData =
                        servLocator<SharedPreferences>().get('user');
                    if (state is LoadingState) {
                      if (userData == null) {
                        return LoadingPage();
                      } else {
                        return myHomePage;
                      }
                    } else if (state is LoggedInState) {
                      return myHomePage;
                    } else if (state is LoggedOutState) {
                      return LoginScreen();
                    } else if (state is ErrorState) {
                      if (userData == null) {
                        return LoginScreen();
                      } else {
                        return myHomePage;
                      }
                    }
                    return LoginScreen();
                  },
                ),
              ),
              onGenerateRoute: Routes.sailor.generator(),
              navigatorKey: Routes.sailor.navigatorKey,
            ),
          );
        },
      ),
    );
  }
}

class Routes {
  static Sailor sailor = Sailor();

  static void createRoutes() {
    sailor.addRoutes(
      [
        SailorRoute(
          name: LoginScreen.routeName,
          builder: (_, args, params) => LoginScreen(),
        ),
        SailorRoute(
          name: SettingsScreen.routeName,
          builder: (_, args, params) => SettingsScreen(),
        ),
      ],
    );
  }
}
