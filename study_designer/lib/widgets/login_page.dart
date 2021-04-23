import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:studyu_designer/models/app_state.dart';
import 'package:supabase/supabase.dart' show Provider;

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/icon_wide.png'), height: 200),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (email) => EmailValidator.validate(email) ? null : 'Please enter a valid email',
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) => value.length >= 8 ? null : 'Password needs at least 8 characters',
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (appState.authError != null) ...[
                  SizedBox(height: 24),
                  Text(appState.authError, style: theme.textTheme.subtitle1.copyWith(color: Colors.red)),
                ],
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 6,
                      child: OutlinedButton.icon(
                          icon: Icon(Icons.login),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              appState.signIn(_emailController.text, _passwordController.text);
                            }
                          },
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text('Login', style: TextStyle(fontSize: 20)),
                          )),
                    ),
                    //SizedBox(width: 64),
                    Spacer(),
                    Flexible(
                      flex: 6,
                      child: OutlinedButton.icon(
                          icon: Icon(MdiIcons.accountPlus),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              appState.signUp(_emailController.text, _passwordController.text);
                            }
                          },
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text('Login with', style: theme.textTheme.headline5),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(MdiIcons.github),
                      onPressed: () => appState.signInWithProvider(Provider.github, 'repo gist'),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(MdiIcons.gitlab, color: const Color(0xfffc6d26)),
                      onPressed: () => appState.signInWithProvider(
                          Provider.gitlab, 'api read_user read_api read_repository write_repository profile email'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () => appState.skipLogin(),
                  child: Text('Skip login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
