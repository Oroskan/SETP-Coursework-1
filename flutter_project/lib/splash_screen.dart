import 'package:e/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'main.dart'; 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/profilepic.jpg', width: 150), 
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 247, 118, 232)),
            ),
            const SizedBox(height: 30),
            const SpinKitThreeBounce(color: Colors.white, size: 20.0), 
          ],
        ),
      ),
    );
  }
}
