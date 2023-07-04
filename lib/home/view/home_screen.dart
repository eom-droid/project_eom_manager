import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('home screen'),
    );
  }
}




/*

import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   'asset/imgs/bg-img.jpg',
          //   fit: BoxFit.cover,
          //   height: MediaQuery.of(context).size.height,
          // ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 50, 50, 50),
              // image: DecorationImage(
              //   colorFilter: ColorFilter.mode(
              //     Colors.,
              //     BlendMode.dstATop,
              //   ),
              //   image: const AssetImage('asset/imgs/bg-img.jpg'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Image.asset(
                  'asset/imgs/sample-img.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.33,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.18,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Image.asset(
                  'asset/imgs/sample-img1.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.33,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.18,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Image.asset(
                    'asset/imgs/sticker1.png',
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

*/