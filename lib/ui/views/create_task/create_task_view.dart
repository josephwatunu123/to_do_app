import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/ui/views/create_task/create_task_view_model.dart';
import 'package:task_sync/ui/widgets/app_bar.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _priorityFormKey = GlobalKey<FormState>();
  final _taskTitleController = TextEditingController();
  String? taskTitle = null;
  static const List<String> taskPriorities = [
    "low",
    "medium",
    "high"
  ];
  String? selectedPriority;

  String? _selectedDate;

  void _pickDueDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    // First, pick the date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Then pick the time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Combine date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format to show only date, hour, and minute
        final String formattedDateTime = DateFormat('MMM dd, yyyy HH:mm').format(combinedDateTime);

        if(formattedDateTime.isNotEmpty){
          setState(() {
            _selectedDate=formattedDateTime;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: ()=> CreateTaskViewModel(),
        onViewModelReady: (vm) => vm.setFormKey(_formKey),
        builder: (context, vm, chile)=> Scaffold(
          appBar: const CustomAppBar(),
          extendBodyBehindAppBar: true,
          body: SafeArea(child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Text("Create New Task",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              ),
              _formField(
                  "Enter Task",
                  _taskTitleController,
                  TextInputType.name),
              SizedBox(height: 30),
              _taskPriorityDropDown(),
              SizedBox(height: 30,),
              TextButton.icon(
                onPressed: () => _pickDueDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null
                      ? "Select Due Date"
                      : "Due: $_selectedDate",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed:vm.isBusy? null
                  : () async{
                    if (_formKey.currentState!.validate() && _priorityFormKey.currentState!.validate()) {
                      vm.setTitle(_taskTitleController.text);
                      vm.setPriority(selectedPriority);
                      vm.setDueDate(_selectedDate);
                      await vm.createNewTask();
                      // pop and signal Home to reload
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: vm.isBusy ? const CircularProgressIndicator() :Text("Add Task")
              )
            ],
          )),
        )
    );
  }

  Widget _formField (String hintText, TextEditingController titleController, TextInputType keyboardType){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
          key: _formKey,
          child: TextFormField(
            maxLength: 40,
            controller: titleController,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25), // Circular rectangle
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            validator: (value){
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Task title cannot be empty';
              }
              if (trimmed.length > 70) {
                return 'Task title cannot exceed 70 characters';
              }
              final valid = RegExp(r'^[a-zA-Z0-9\s]+$');
              if (!valid.hasMatch(trimmed)) {
                return 'Only letters, numbers, and spaces allowed';
              }
              return null;
            },
            onChanged: (value){
              taskTitle= value.trim();
            },
          )
      )
    );
  }

  Widget _taskPriorityDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: _priorityFormKey,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: "Select Priority",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          items: taskPriorities
              .map((priority) => DropdownMenuItem(
            value: priority,
            child: Text(priority),
          ))
              .toList(),
          validator: (value) =>
          value == null ? 'Please select a priority' : null,
          onChanged: (value) {
            setState(() {
              selectedPriority = value;
            });
          },
        ),
      ),
    );
  }


}
