import 'package:flutter/material.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';

class NoTasksScreen extends StatelessWidget {
  const NoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myHeight = MediaQuery.of(context).size.height;
    final myWidth = MediaQuery.of(context).size.width;
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                height: myHeight * 0.4,
                width: myWidth * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text('No Pending Tasks!', style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple
                    ),),
                    const SizedBox(height: 20),
                    Icon(Icons.check_box, color: Colors.green,size: 70,),
                    const SizedBox(height: 20),
                    Text("You are all caught up. Create a new task by tapping on the plus icon")
                  ],
                ),
              )
            ],
          ),
        );
  }
}
