import 'package:flutter/material.dart';
import 'package:go_food/GoFood/screens/register_login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({super.key});

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _controller = PageController();
  bool lastPage = false;
  bool pageone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) => setState(() {
              lastPage = index == 2;
              pageone = (index == 1 || index == 2);
            }),
            controller: _controller,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.amber,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.red,
              ),
            ],
          ),
          //dot indicator
          Align(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                pageone
                    ? InkWell(
                        onTap: () {
                          _controller.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text("PRIVOUS"),
                      )
                    : InkWell(
                        onTap: () {
                          _controller.jumpToPage(2);
                        },
                        child: Text("SKIP"),
                      ),

                SmoothPageIndicator(controller: _controller, count: 3),
                lastPage
                    ? InkWell(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterLogin()),
                        ),
                        child: Text("DONE"),
                      )
                    : InkWell(
                        onTap: () => _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                        child: Text("NEXT"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
