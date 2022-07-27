import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Signin.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SigninPage()));
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Lottie.asset('assets/lottie/$assetName.json', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle:
          const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      pageColor: Theme.of(context).primaryColor == rPrimaryMaterialColorLite
          ? Colors.white
          : rPrimaryDarkLiteColor,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor:
          Theme.of(context).primaryColor == rPrimaryMaterialColorLite
              ? Colors.white
              : rPrimaryDarkLiteColor,
      pages: [
        PageViewModel(
          title: "No need to worry",
          body: "No need to worry for Exams,\nWe got your Back.",
          image: _buildImage('woman'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Enjoy your Freedom",
          body: "Do what you have to do,\nWe are always there for you.",
          image: _buildImage('boy'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Theme.of(context).primaryColor == rPrimaryMaterialColorLite
            ? Color(0xFFBDBDBD)
            : rPrimaryDarkLiteColor.withOpacity(0.2),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
