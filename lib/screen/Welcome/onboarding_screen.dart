import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddielink_app/screen/Parents/p_loginScreen.dart';
import 'package:kiddielink_app/screen/Welcome/content.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE040FB),
              Color(0xFF7C4DFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          "Welcome to",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        const Text(
                          "KiddieLink",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Image.asset(contents[i].image),
                        Text(
                          contents[i].discription,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                      (index) => buildDot(index),
                ),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const loginScreen()));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(child: Text('Get Started', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 7,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
    );
  }
}
