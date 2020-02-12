import 'package:flutter/material.dart';
import 'dart:core';

class CodeView extends StatefulWidget {
  CodeView({
    this.code,
    this.length = 6,
    this.codeTextStyle,
    this.obscurePin,
    this.width,
  });

  final String code;
  final int length;
  final bool obscurePin;
  final TextStyle codeTextStyle;
  final double width;

  CodeViewState createState() => CodeViewState();
}

class CodeViewState extends State<CodeView> {
  String getCodeAt(index) {
    if (widget.code == null || widget.code.length < index)
      return "  ";
    else if (widget.obscurePin) {
      return "•";
    } else {
      return widget.code.substring(index - 1, index);
    }
  }

  _getCodeViews() {
    int _codeLength = widget.length;
    double _gapWidth = 3;
    double _spotWidth =
        (widget.width - 1 - (_codeLength - 1) * _gapWidth) / _codeLength;
    if (_spotWidth < 30) _spotWidth = 30;
    if (_spotWidth > 50) _spotWidth = 50;
    double _spotHeight = _spotWidth * 1.1;

    List<Widget> widgets = [];
    for (var i = 0; i < _codeLength; i++) {
      widgets.add(
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              right: i == _codeLength - 1 ? 0 : _gapWidth, bottom: _gapWidth),
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          height: _spotHeight,
          width: _spotWidth,
          child: Text(
            getCodeAt(i + 1),
            textAlign: TextAlign.center,
            style: widget.codeTextStyle,
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: _getCodeViews(),
    );
  }
}
