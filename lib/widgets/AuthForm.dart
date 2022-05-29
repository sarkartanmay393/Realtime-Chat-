import 'package:flutter/material.dart';

enum AuthMode {
  Login,
  Signup;
}

class AuthForm extends StatefulWidget {
  final Function sumbitForm;

  AuthForm(this.sumbitForm, {Key? key}) : super(key: key);

  static var isLoading = false;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode CurrentMode = AuthMode.Login;
  final _formKey = GlobalKey<FormState>();

  void mode_switcher() {
    if (CurrentMode == AuthMode.Login) {
      setState(() {
        CurrentMode = AuthMode.Signup;
        animatedContainerHeight = 525;
      });
    } else {
      setState(() {
        CurrentMode = AuthMode.Login;
        animatedContainerHeight = 235;
      });
    }
  }

  void submitter() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      AuthForm.isLoading = true;
    });
    FocusScope.of(context).unfocus();

    if (CurrentMode == AuthMode.Login) {
      widget.sumbitForm(
        email: Data['email']!,
        password: Data['password']!,
        ctx: context,
        isLogin: true,
        username: null,
      );
    } else {
      widget.sumbitForm(
        email: createData['email']!,
        password: createData['password']!,
        ctx: context,
        isLogin: false,
        username: createData['username']!,
      );
    }
  }

  static Map<String, String> Data = {
    'email': '',
    'password': '',
  };
  static Map<String, String> createData = {
    'email': '',
    'password': '',
    'username': '',
  };

  double animatedContainerHeight = 235;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 500,
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

  _LoginForm(this.Mode_Switcher, this.submit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          validator: (input) {
            if (input!.isEmpty) {
              return 'Enter Email.';
            }
            if (!(input.contains('@') && input.contains('.'))) {
              return 'Enter Valid Email.';
            }
            return null;
          },
          onSaved: (input) {
            _AuthFormState.Data['email'] = input.toString();
          },
          decoration: const InputDecoration(labelText: "Email Address"),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          validator: (input) {
            if (input!.isEmpty) {
              return 'Enter Password.';
            }
            if (!(input.length >= 7)) {
              return 'Minimum Length is 7.';
            }
            return null;
          },
          onSaved: (input) {
            _AuthFormState.Data['password'] = input.toString();
          },
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
          child: AuthForm.isLoading
              ? const SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text("Login"),
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

  _SignupForm(this.Mode_Switcher, this.submit, {Key? key}) : super(key: key);

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            minRadius: 47,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Pick Image'),
          ),
          TextFormField(
            validator: (input) {
              if (input!.isEmpty) {
                return 'Enter Email.';
              }
              if (!(input.contains('@') && input.contains('.'))) {
                return 'Enter Valid Email.';
              }
              return null;
            },
            onSaved: (input) {
              _AuthFormState.createData['email'] = input.toString();
            },
            decoration: const InputDecoration(labelText: "Email Address"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            validator: (input) {
              if (input!.isEmpty) {
                return 'Enter Username.';
              }
              if (!(input.length >= 4)) {
                return 'Enter Valid Username.';
              }
              return null;
            },
            onSaved: (input) {
              _AuthFormState.createData['username'] = input.toString();
            },
            decoration: const InputDecoration(labelText: "Username"),
          ),
          TextFormField(
            validator: (input) {
              if (input!.isEmpty) {
                return 'Enter Password.';
              }
              if (!(input.length >= 7)) {
                return 'Minimum Length is 7.';
              }
              return null;
            },
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          TextFormField(
            validator: (input) {
              if (input!.isEmpty) {
                return 'Enter Password.';
              }
              if (!(input.length >= 7)) {
                return 'Minimum Length is 7.';
              }
              if (_passwordController.text != input) {
                return "Password isn't Matching";
              }
              return null;
            },
            onSaved: (input) {
              _AuthFormState.createData['password'] = input.toString();
            },
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
            child: AuthForm.isLoading
                ? const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Create"),
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
