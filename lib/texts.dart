import 'package:flutter/material.dart';
import 'constants.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final Color color;
  const HeaderText({
    super.key,
    required this.text,
    this.color = kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        color: color,
      ),
    );
  }
}

class ProfileText extends StatelessWidget {
  final String text;
  final Color color;
  const ProfileText({
    super.key,
    required this.text,
    this.color = kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        color: color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class PrimaryText extends StatelessWidget {
  final String text;
  final Color color;
  const PrimaryText({
    super.key,
    required this.text,
    this.color = kTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: color,
      ),
    );
  }
}

class SecondaryText extends StatelessWidget {
  final String text;
  final Color color;
  const SecondaryText({
    super.key,
    required this.text,
    this.color = kTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color,
      ),
    );
  }
}

class ItalicizedText extends StatelessWidget {
  final String text;
  final Color color;
  const ItalicizedText({
    super.key,
    required this.text,
    this.color = kTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
