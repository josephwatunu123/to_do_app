import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/ui/views/dashboard/dashboard_view.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';

import '../../../models/task_model.dart';
import '../create_task/create_task_view.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel()..fetchToDos(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: const CustomAppBar(),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final task = viewModel.visibleTasks.removeAt(oldIndex);
                viewModel.visibleTasks.insert(newIndex, task);
              });
            },
            children: List.generate(
              viewModel.visibleTasks.length,
                  (index) {
                final task = viewModel.visibleTasks[index];
                return KeyedSubtree(
                  key: ValueKey(task.id),
                  child: _customListTile(task, viewModel),
                );
              },
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
                overlayColor: Colors.black,
                overlayOpacity: 0.7,
                activeIcon: Icons.close,
                iconTheme: IconThemeData(color: Colors.black54),
                buttonSize: Size(58, 58),
                curve: Curves.bounceIn,
                children: [
          SpeedDialChild(
            backgroundColor: Colors.transparent,
            elevation:0,
            child: Icon(Icons.new_label, color: Colors.green,),
            labelWidget: Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 18),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTaskView(),
                )).then((shouldReload) {
                  if (shouldReload == true) {
                  viewModel.fetchToDos();
                  };
            });}
          ),
          SpeedDialChild(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.dashboard, color: Colors.purple, size: 25,),
            labelWidget: Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 18),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardView(),
                ),
              );
            },
          )
        ],
                child: Icon(Icons.add),
      ),
    ));
  }

  Widget _customListTile (TaskModel task, HomeViewModel viewModel){
    TextStyle style = TextStyle(
      fontSize: 18,
      decoration: task.isComplete
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      color: task.isComplete
          ? Colors.grey
          : Colors.black,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 10,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 200,
              height: 80,
              child: Text(task.title,style: style),
            ),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                borderRadius: BorderRadius.circular(20)
              ),
              width: 70,
              height: 30,
              child: Text(task.priority),
            ),
            Checkbox(
                value: task.isComplete,
                onChanged: (val){
                  if(val !=null){
                    viewModel.toggleIsComplete(task, val);
                  }
                })
          ],
        ),
      ),
    );
  }


  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.orangeAccent;
      case 'medium':
        return Colors.purpleAccent;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }


  }
}
