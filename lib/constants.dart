import 'package:flutter/material.dart';

//Todo: test ids
const String kBannerAdsId = 'ca-app-pub-3940256099942544/6300978111';
const String kInterstitialAdsId = 'ca-app-pub-3940256099942544/1033173712';

const Color kFirstColour = Color(0xff0880AE);
const Color kSecondColour = Color(0xffEBF4F8);
const Color kmbmColor = Color(0xff603030);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kFirstColour, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
