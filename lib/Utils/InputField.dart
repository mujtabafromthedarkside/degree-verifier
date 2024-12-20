import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:degree_verifier/Config/constants.dart';

class InputBox extends StatefulWidget {
  final Function(String)? onValueChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  // final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool showEyeIcon;
  final String initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InputBox(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.showEyeIcon = false,
      this.validator,
      this.onSaved,
      this.onValueChanged,
      this.initialValue = "",
      this.keyboardType,
      this.inputFormatters});

  // const InputBox({super.key});
  @override
  State<InputBox> createState() => _InputBoxState();
}

Color inputBoxUnderLineColor = Colors.grey;
Color inputBoxLabelColor = Colors.grey;
Color inputBoxHintColor = Colors.grey;
Color inputBoxInputColor = Colors.black;
Color cursorColor = designColor;
double inputBoxLabelFontSize = 16.0;
double inputBoxInputFontSize = 16.0;

class _InputBoxState extends State<InputBox> {
  bool obscureText = false;

  @override
  void initState() {
    // _controller = TextEditingController(text: widget.initialValueText);
    if (widget.showEyeIcon) obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      initialValue: widget.initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) return "Please enter valid value";
            return null;
          },
      onSaved: widget.onSaved,
      onChanged: widget.onValueChanged,
      inputFormatters: widget.inputFormatters,
      // controller: widget.controller,
      // onChanged: widget.onValueChanged, // Call the callback function with input value
      style: TextStyle(color: inputBoxInputColor, fontSize: inputBoxInputFontSize),
      decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: designColor, width: 2.0),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: inputBoxUnderLineColor, width: 0.5),
            borderRadius: BorderRadius.circular(0),
          ),
          labelStyle: TextStyle(color: inputBoxLabelColor, fontSize: inputBoxLabelFontSize),
          hintStyle: TextStyle(color: inputBoxHintColor, fontSize: inputBoxInputFontSize),
          suffixIcon: !widget.showEyeIcon
              ? null
              : IconButton(
                  icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )),
      cursorWidth: 1.0,
      cursorColor: cursorColor,
      obscureText: obscureText,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
