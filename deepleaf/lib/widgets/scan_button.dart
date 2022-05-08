import 'package:flutter/material.dart';

// Button on home page
class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.all(Radius.circular(400)),
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 5)),
      child: Center(
        child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(400)),
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2)),
            child: Container(
              child: Image.asset(
                'houseplant.png',
                fit: BoxFit.scaleDown,
              ),
            )),
      ),
    );
  }
}
