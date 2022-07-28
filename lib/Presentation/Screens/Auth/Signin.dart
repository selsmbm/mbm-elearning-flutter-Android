import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/OrDevider.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Widgets/Buttons/SigninButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/RoundedInputField.dart';
import 'Components/social_login.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> with TickerProviderStateMixin {
  String? _email;
  String? _password;
  String? _emailSignup;
  String? _passwordSignup;
  bool showProgress = false;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    setCurrentScreenInGoogleAnalytics("Signin");
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Lottie.asset('assets/lottie/sign-in-yellow.json', width: 300),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor ==
                                rPrimaryMaterialColorLite
                            ? rPrimaryColor
                            : rPrimaryDarkLiteColor,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TabBar(
                              controller: tabController,
                              unselectedLabelColor: Colors.grey,
                              labelColor: Colors.white,
                              indicator: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 3.0),
                                ),
                              ),
                              tabs: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [signinTab(), signupTab()])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool passBool = false;
  bool confpassBool = false;

  Widget signupTab() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Create your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TrackingTextInput(
                hint: "Email",
                icon: Icons.email,
                onTextChanged: (String value) {
                  _emailSignup = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TrackingTextInput(
                hint: "Password",
                isObscured: !passBool,
                icon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    passBool ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      passBool = !passBool;
                    });
                  },
                ),
                onTextChanged: (String value) {
                  _passwordSignup = value;
                },
              ),
              const SizedBox(
                height: 14,
              ),
              SignInButton(
                onPressed: () async {
                  if (_passwordSignup != null) {
                    try {
                      setState(() {
                        showProgress = true;
                      });
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: _emailSignup!, password: _passwordSignup!);
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        setState(() {
                          showProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Now verify your email. and then sing in'),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          showProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'The password provided is too weak.')));
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          showProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'The account already exists for that email.')));
                      }
                    } catch (e) {
                      setState(() {
                        showProgress = false;
                      });
                      print(e);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all details')));
                  }
                },
                text: 'Sign Up',
              ),
              const ORDevider(
                text: 'Or Sign Up with',
              ),
              const SocialSigninButton(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );

  Widget signinTab() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Welcome Back !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TrackingTextInput(
                hint: "Email",
                icon: Icons.email,
                onTextChanged: (String value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TrackingTextInput(
                hint: "Password",
                isObscured: !passBool,
                icon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    passBool ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      passBool = !passBool;
                    });
                  },
                ),
                onTextChanged: (String value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'forgetPage');
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              SignInButton(
                onPressed: () async {
                  if (_password != null && _email != null) {
                    try {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        showProgress = true;
                      });
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: _email!, password: _password!);
                      if (FirebaseAuth.instance.currentUser != null &&
                          FirebaseAuth.instance.currentUser!.emailVerified) {
                        await FirebaseMessaging.instance
                            .subscribeToTopic(mbmEleFcmChannel);
                        setState(() {
                          showProgress = false;
                        });
                        if (!mounted) return;
                        if (prefs.getBool(SP.initialProfileSaved) != null) {
                          Navigator.popAndPushNamed(context, 'dashboard');
                        } else {
                          if (FirebaseAuth.instance.currentUser!.photoURL !=
                                      null &&
                                  FirebaseAuth.instance.currentUser!.photoURL!
                                      .contains(student) ||
                              FirebaseAuth.instance.currentUser!.photoURL!
                                  .contains(teacher) ||
                              FirebaseAuth.instance.currentUser!.photoURL!
                                  .contains(alumni)) {
                            prefs.setBool(SP.initialProfileSaved, true);
                            Navigator.popAndPushNamed(context, 'dashboard');
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  isItInitialUpdate: true,
                                ),
                              ),
                            );
                          }
                        }
                      } else if (!FirebaseAuth
                          .instance.currentUser!.emailVerified) {
                        await FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        setState(() {
                          showProgress = false;
                        });
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please verify your email. and retry login'),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        setState(() {
                          showProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('No user found for that email.')));
                      } else if (e.code == 'wrong-password') {
                        setState(() {
                          showProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Wrong password provided for that user.')));
                      }
                    } catch (e) {
                      setState(() {
                        showProgress = false;
                      });
                      print(e);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all details')));
                  }
                },
                text: 'Sign In',
              ),
              const ORDevider(
                text: 'Or Sign in with',
              ),
              const SocialSigninButton(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
}
