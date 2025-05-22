import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomProgressBar extends StatefulWidget {
  const CustomProgressBar({super.key, required this.progress});
  final double progress;
  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  @override
  Widget build(BuildContext context) {
    final double width=300;
    double starSize= 40.0;
    final double height=20;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
              clipBehavior: Clip.none,
              children:[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow:[ BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(2, 2)
                      )]
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: width * widget.progress,
                        height: height,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade200, // Light orange
                                Colors.green, // Deep orange
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),

                    ],
                  ),
                ),

              ]
          ),

        ],
      ),
    );
  }
}
