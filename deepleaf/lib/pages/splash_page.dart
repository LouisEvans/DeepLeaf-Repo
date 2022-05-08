import 'package:deepleaf/pages/home_page.dart';
import 'package:deepleaf/providers/home_page_provider.dart';
import 'package:flutter/material.dart';

// Page to display on startup
class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageProvider(child: HomePage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFEDEE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "deep",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  Text(
                    "leaf",
                    style: TextStyle(fontSize: 30, color: Color(0xff1ebe4b)),
                  ),
                ],
              ),
            ),
          ),
          Image.asset('splash.png')
        ],
      ),
    );
  }
}
