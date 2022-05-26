import 'package:flutter/material.dart';

enum AuthMode {
  Login,
  Signup;
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode CurrentMode = AuthMode.Login;
  final _formKey = GlobalKey<FormState>();
  var firstAppBuild = true;

  void mode_switcher() {
    if (CurrentMode == AuthMode.Login) {
      setState(() {
        CurrentMode = AuthMode.Signup;
        animatedContainerHeight = 525;
      });
    } else {
      setState(() {
        CurrentMode = AuthMode.Login;
        animatedContainerHeight = 300;
      });
    }
  }

  void submitter() {}

  double animatedContainerHeight = 300;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 1000,
          ),
          curve: Curves.decelerate,
          height: animatedContainerHeight,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 8,
                ),
                child: CurrentMode == AuthMode.Login
                    ? _LoginForm(mode_switcher, submitter)
                    : _SignupForm(mode_switcher, submitter),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final Mode_Switcher;
  final submit;

  const _LoginForm(this.Mode_Switcher, this.submit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Email Address"),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Username"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: submit,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: const Text("Login"),
        ),
        TextButton(
          onPressed: Mode_Switcher,
          child: const Text("Create a New Account"),
        ),
      ],
    );
  }
}

class _SignupForm extends StatelessWidget {
  final Mode_Switcher;
  final submit;

  const _SignupForm(this.Mode_Switcher, this.submit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            minRadius: 46,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Pick Image'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email Address"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Username"),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            onPressed: submit,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: const Text("Create"),
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            children: [
              const Text(
                'Already have an account ?',
                style: TextStyle(fontSize: 14),
              ),
              TextButton(
                onPressed: Mode_Switcher,
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
