import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailor/sailor.dart';
import 'package:todo_list_app/core/pages/settings_screen.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';

void main() {
  Routes.createRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (ctx, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          home: MyHomePage(title: 'ToDo List'),
          onGenerateRoute: Routes.sailor.generator(),
          navigatorKey: Routes.sailor.navigatorKey,
        ),
      ),
    );
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
        child: Text('Test Text'),
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
          name: SettingsScreen.routeName,
          builder: (_, args, params) => SettingsScreen(),
        ),
      ],
    );
  }
}
