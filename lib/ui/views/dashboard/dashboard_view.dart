import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/ui/views/dashboard/dashboard_view_model.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';
import 'package:task_sync/ui/widgets/custom_progress_bar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: ()=>DashboardViewModel()..fetchTasksProgress() ,
        builder: (context, viewModel, child)=> Scaffold(
          appBar: const CustomAppBar(),
          extendBodyBehindAppBar: true,
          body: SafeArea(
              child: Column(
                spacing: 15,
                children: [
                  _taskProgress("Completed Tasks", viewModel.overallProgress),
                  _taskProgress("High Priority Tasks Complete", viewModel.highPriorityProgress),
                  _taskProgress("Medium Priority Tasks Complete", viewModel.mediumPriorityProgress),
                  _taskProgress("Low Priority Tasks Complete", viewModel.lowPriorityProgress),
                  _pendingTasks("Tasks Pending", viewModel.pendingTasksCount),
                  _pendingTasks("Tasks Completed", viewModel.completedTasksCount),
                  _pendingTasks("High Priority tasks pending", viewModel.highPriorityTasksPending)
                ],
              )),
        )
    );
  }

  Widget _taskProgress (String title, double progress){
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
          CustomProgressBar(progress: progress)
        ],
      ),
    );
  }


  Widget _pendingTasks (String title, int value){
    return Container(
      color: Colors.white60,
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.only(left:10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style:
            TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,

            ),),
          Text("$value",style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Colors.deepOrange
          ),)
        ],
      ),
    );
  }
}
