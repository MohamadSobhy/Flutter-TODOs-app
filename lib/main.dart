import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailor/sailor.dart';
import 'package:todo_list_app/core/pages/loading_screen.dart';
import 'package:todo_list_app/injection_container.dart';

import 'core/pages/settings_screen.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Routes.createRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        builder: (ctx, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          home: BlocListener<AuthBloc, AuthState>(
            listener: (ctx, state) {
              if (state is ErrorState) {
                print(state.message);
                _displaySnackbar(state.message, ctx);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (_, state) {
                if (state is LoadingState) {
                  return LoadingPage();
                } else if (state is LoggedInState) {
                  return MyHomePage(
                      title: '${state.userData.name.split(' ')[0]}\'s ToDos');
                } else if (state is LoggedOutState) {
                  return LoginScreen();
                }
                return LoginScreen();
              },
            ),
          ),
          onGenerateRoute: Routes.sailor.generator(),
          navigatorKey: Routes.sailor.navigatorKey,
        ),
      ),
    );
  }

  void _displaySnackbar(String message, context) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 2),
    ).show(context);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Routes.sailor.navigate(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
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
