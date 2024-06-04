import 'package:flutter/material.dart';
import 'dart:core';

class CodeView extends StatefulWidget {
  CodeView({
    required this.code,
    this.length = 6,
    this.codeTextStyle,
    this.obscurePin = true,
    required this.width,
    required this.showBullets,
    required this.bulletSize,
    required this.bulletDecoration,
    required this.codeDecoration,
  });

  final String code;
  final int length;
  final bool obscurePin;
  final TextStyle? codeTextStyle;
  final BoxDecoration bulletDecoration, codeDecoration;
  final double width;
  final bool showBullets;
  final double bulletSize;

  CodeViewState createState() => CodeViewState();
}

class CodeViewState extends State<CodeView> {
  Widget getCodeAt(index) {
    String code;

    if (widget.code.length < index)
      code = "  ";
    else if (widget.obscurePin) {
      code = "•";
    } else {
      code = widget.code.substring(index - 1, index);
    }

    return Text(
      code,
      textAlign: TextAlign.center,
      style: widget.codeTextStyle,
    );
  }

  Widget getBulletAt(index) {
    if (widget.code.length < index)
      return Container();
    else {
      return Container(
        width: widget.bulletSize * 0.7,
        height: widget.bulletSize * 0.7,
        decoration: widget.bulletDecoration.copyWith(
          border: Border.all(width: 0),
        ),
      );
    }
  }

  _getCodeViews() {
    int _codeLength = widget.length;
    double _gapSize = widget.showBullets ? 10 : 3;
    double _inputWidth =
        (widget.width - 1 - (_codeLength - 1) * _gapSize) / _codeLength;
    if (_inputWidth < 30) _inputWidth = 30;
    if (_inputWidth > 50) _inputWidth = 50;
    double _inputHeight = _inputWidth * 1.1;

    if (widget.showBullets) {
      _inputWidth = _inputHeight = widget.bulletSize;
    }

    List<Widget> widgets = [];
    for (var i = 0; i < _codeLength; i++) {
      widgets.add(
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                right: i == _codeLength - 1 ? 0 : _gapSize, bottom: _gapSize),
            decoration: widget.showBullets
                ? widget.bulletDecoration
                    .copyWith(color: widget.codeDecoration.color)
                : widget.codeDecoration,
            height: _inputHeight,
            width: _inputWidth,
            child: widget.showBullets ? getBulletAt(i + 1) : getCodeAt(i + 1)),
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
