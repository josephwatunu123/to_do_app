import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/ui/views/dashboard/dashboard_view.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';
import 'package:task_sync/ui/widgets/no_tasks_screen.dart';

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
          child: viewModel.tasks.isEmpty ? NoTasksScreen() :ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final task = viewModel.tasks.removeAt(oldIndex);
                viewModel.tasks.insert(newIndex, task);
              });
            },
            children: List.generate(
              viewModel.tasks.length,
                  (index) {
                final task = viewModel.tasks[index];
                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart, // swipe left to delete
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Task'),
                        content: const Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    viewModel.deleteTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${task.title} deleted')),
                    );
                  },
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

  Widget _customListTile (TaskModel task, HomeViewModel viewModel,){
    TextStyle style = TextStyle(
      fontSize: 16,
      decoration: task.isComplete
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      color: task.isComplete
          ? Colors.grey
          : Colors.black,
    );
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 0.4,color: Colors.purple)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 10,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 200,
            height: 85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title,style: style),
                const SizedBox(height: 5),
                Text(
                  task.dueDate ?? "",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
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
