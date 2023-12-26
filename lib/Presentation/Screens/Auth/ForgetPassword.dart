import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Widgets/Buttons/SigninButton.dart';

import 'Components/RoundedInputField.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Forget Password");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? email;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/lottie/sign-in-yellow.gif', width: 300),
                Container(
                  height: 200,
                  width: kIsWeb ? 400 : double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).primaryColor ==
                            rPrimaryMaterialColorLite
                        ? rPrimaryColor
                        : rPrimaryDarkLiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Forget Password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TrackingTextInput(
                          hint: "Email",
                          icon: Icons.email,
                          onTextChanged: (String value) {
                            email = value;
                          },
                        ),
                        SignInButton(
                          onPressed: () async {
                            if (email != null) {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email!)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text(
                                            'Successfully send reset password email, also check mail in spam box.')));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please fill all details')));
                            }
                          },
                          text: 'Submit',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
