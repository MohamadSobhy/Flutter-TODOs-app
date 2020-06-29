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
                _buildSocialButton(
                  context,
                  color: Colors.red,
                  text: 'Google',
                  onTap: () => _loginWithGoogle(context),
                ),
                SizedBox(width: 10.0),
                Text(
                  'OR',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.0),
                _buildSocialButton(
                  context,
                  color: Colors.blue,
                  text: 'Facebook',
                  onTap: () => _loginWithFacebook(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {color, text, onTap}) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: color,
      onPressed: onTap,
      child: Text(text),
    );
  }

  void _loginWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(LoginWithGoogleEvent());
  }

  void _loginWithFacebook(context) {
    BlocProvider.of<AuthBloc>(context).add(LoginWithFacebookEvent());
  }
}
