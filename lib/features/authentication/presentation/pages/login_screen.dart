import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/features/authentication/presentation/bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, there!',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 30.0,
                  ),
            ),
            SizedBox(height: 20.0),
            Text('You can login with'),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(LoginWithGoogleEvent());
                  },
                  child: Text('Google'),
                ),
                SizedBox(width: 10.0),
                Text('OR'),
                SizedBox(width: 10.0),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(LoginWithFacebookEvent());
                  },
                  child: Text('Facebook'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
