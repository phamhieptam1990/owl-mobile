import 'package:flutter/material.dart';

class BaseButtonApp extends StatelessWidget {
  final Color color;
  final void Function()? onTap;
  final String title;

  const BaseButtonApp({
    Key? key,
    this.color = const Color(0xFF018747),
    required this.onTap,
    this.title = ' ',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: onTap != null ? color : Colors.black45,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}