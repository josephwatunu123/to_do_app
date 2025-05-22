import 'package:flutter/material.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Column(
            spacing: 15,
          children: [
            _taskProgress("Completed Tasks"),
            _taskProgress("High Priority Tasks Complete"),
            _taskProgress("Medium Priority Tasks Complete"),
            _taskProgress("Low Priority Tasks Complete"),
        ],
      )),
    );
  }

  Widget _taskProgress (String title){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5, // you can adjust thickness
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Text('6/6'),
          )
        ],
      ),
    );
  }
}
