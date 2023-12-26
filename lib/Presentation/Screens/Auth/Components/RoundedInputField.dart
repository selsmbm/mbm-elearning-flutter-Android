import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'TextFielsContainer.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final Function(String)? onChanged;
  final int maxLines;
  final TextEditingController? controller;
  const RoundedInputField({
    super.key,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
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

class NormalInputField extends StatelessWidget {
  final String? hintText;
  final int maxLines;
  final TextEditingController? controller;
  const NormalInputField({
    super.key,
    this.hintText,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

typedef CaretMoved = void Function(Offset globalCaretPosition);
typedef TextChanged = void Function(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  const TrackingTextInput({
    super.key,
    required this.onTextChanged,
    required this.hint,
    required this.icon,
    this.isObscured = false,
    this.suffixIcon = const SizedBox(
      width: 0,
    ),
  });
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
        color: Theme.of(context).primaryColor == rPrimaryMaterialColorLite
            ? rPrimaryLiteColor
            : Colors.white30,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
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
        },
      ),
    );
  }
}
