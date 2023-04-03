import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setUserLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        setUserLogin();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(87, 65, 104, 1),
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/logo.png',
              height: 150,
              width: 150,
              color: Colors.white,
            ),
            const Text(
              'Smart Home Control',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Center(
              child: SpinKitFoldingCube(
                color: Color.fromRGBO(247, 236, 89, 1),
                // color: Colors.white,
                size: 50.0,
              ),
            ),
          ],
        ));
  }
}
