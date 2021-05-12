import 'package:flutter/material.dart';

import '../constants.dart';

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = kFirstColour
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path_0 = Path();
    path_0.moveTo(0,0);
    path_0.lineTo(size.width,0);
    path_0.quadraticBezierTo(size.width*0.83,size.height*0.69,size.width*0.50,size.height*0.69);
    path_0.quadraticBezierTo(size.width*0.17,size.height*0.70,0,0);
    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}