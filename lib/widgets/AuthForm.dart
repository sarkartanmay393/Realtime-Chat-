import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  void submitter(File? image) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      AuthForm.isLoading = true;
    });
    FocusScope.of(context).unfocus();

    if (CurrentMode == AuthMode.Signup && image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Select image to continue.",
        ),
      ));
      setState(() {
        AuthForm.isLoading = false;
      });
      return;
    }

    if (CurrentMode == AuthMode.Login) {
      widget.sumbitForm(
        email: Data['email']!,
        password: Data['password']!,
        ctx: context,
        isLogin: true,
        username: null,
      );
    } else if (CurrentMode == AuthMode.Signup && image != null) {
      widget.sumbitForm(
        email: createData['email']!,
        password: createData['password']!,
        ctx: context,
        isLogin: false,
        image: image,
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
          onPressed: () => submit(),
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

class _SignupForm extends StatefulWidget {
  final Mode_Switcher;
  final submit;

  _SignupForm(this.Mode_Switcher, this.submit, {Key? key}) : super(key: key);

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _passwordController = TextEditingController();

  var image;
  var ins = false;
  final _picker = ImagePicker();

  void imagepicking() async {
    var img = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 85,
    );

    setState(() {
      image = File(img!.path);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var jk;
    // FileImage jj = FileImage(image);
    // NetworkImage kk = NetworkImage(
    //     'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.wholesaleforeveryone.com%2Fproduct%2FHKSS0100_14_1895_0001.html&psig=AOvVaw0shq8HvV_Ji8CtffMCFuML&ust=1653932485918000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCPD6hOSghfgCFQAAAAAdAAAAABAD');
    // if (ins) {
    //   jk = jj;
    // } else {
    //   jk = kk;
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            minRadius: 47,
            backgroundImage: image != null ? FileImage(image) : null,
          ),
          TextButton.icon(
            onPressed: imagepicking,
            // showDialog(
            //   context: context,
            //   builder: (ctx) {
            //     return AlertDialog(
            //         content: Container(
            //       height: 120,
            //       child: Column(
            //         children: [
            //           TextButton(
            //             onPressed: () => imagepicking('camera'),
            //             child: Text('Camera'),
            //           ),
            //           TextButton(
            //             onPressed: () => imagepicking(' '),
            //             child: Text('Gallery'),
            //           ),
            //         ],
            //       ),
            //     ));
            //   },
            // ),
            label: const Text('Pick Image'),
            icon: Icon(Icons.camera),
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
            onPressed: () => widget.submit(image),
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
                onPressed: widget.Mode_Switcher,
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
