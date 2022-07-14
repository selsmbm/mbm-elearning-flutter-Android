import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'dart:async';
import 'TextFielsContainer.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final int maxLines;
  const RoundedInputField({
    Key? key,
    this.hintText,
    required this.onChanged,
    this.errorText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        cursorColor: rPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

typedef CaretMoved = void Function(Offset globalCaretPosition);
typedef TextChanged = void Function(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  const TrackingTextInput({
    Key? key,
    required this.onTextChanged,
    required this.hint,
    required this.icon,
    this.isObscured = false,
    this.suffixIcon = const SizedBox(
      width: 0,
    ),
  }) : super(key: key);
  final TextChanged onTextChanged;
  final String hint;
  final IconData icon;
  final Widget suffixIcon;
  final bool isObscured;
  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Colors.black,
            ),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hint,
            border: InputBorder.none,
          ),
          onChanged: widget.onTextChanged,
          cursorColor: rPrimaryColor,
          key: _fieldKey,
          controller: _textController,
          obscureText: widget.isObscured,
          validator: (value) {
            return null;
          }),
    );
  }
}
