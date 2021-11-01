import 'package:flutter/material.dart';

class MainButtonWidget extends StatelessWidget {
  const MainButtonWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff1976d2), Color(0xff2979ff)],
            //colors: [Color(0xffFB724C), Color(0xffFE904B)],
            stops: [0.3, 0.6],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xfffcfcfc),
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
