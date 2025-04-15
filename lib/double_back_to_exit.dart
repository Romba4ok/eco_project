import 'package:flutter/material.dart';

class DoubleBackToExitWrapper extends StatefulWidget {
  final Widget child;
  final String exitMessage;
  final Duration duration;

  const DoubleBackToExitWrapper({
    Key? key,
    required this.child,
    this.exitMessage = 'Нажмите еще раз, чтобы выйти',
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _DoubleBackToExitWrapperState createState() => _DoubleBackToExitWrapperState();
}

class _DoubleBackToExitWrapperState extends State<DoubleBackToExitWrapper> {
  DateTime? _lastBackPressTime;

  Future<bool> _handleWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > widget.duration) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.exitMessage),
          duration: widget.duration,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: widget.child,
    );
  }
}
