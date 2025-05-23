import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../models/task_model.dart';
import '../../../services/local_json_service.dart';

class CreateTaskViewModel extends BaseViewModel{
  String title = '';
  String? priority;
  String? dueDate;
  final _jsonService = LocalJsonService();
  static const platform = MethodChannel('com.tasksync/notifications');

  late final GlobalKey<FormState> formKey;
  void setFormKey(GlobalKey<FormState> key) {
    formKey = key;
  }

  void setTitle(String val) {
    title = val;
    notifyListeners();
  }

  void setPriority(String? val) {
    priority = val;
    notifyListeners();
  }

  void setDueDate(String? val) {
    dueDate = val;
    notifyListeners();
  }

  Future<void> createNewTask() async {
    if (!formKey.currentState!.validate() || priority == null) return;
    setBusy(true);
    try {
      final rawList = await _jsonService.readJsonList();
      final tasks = rawList.map((e) => TaskModel.fromJson(e)).toList();

      final maxId = tasks
          .map((t) => int.tryParse(t.id) ?? 0)
          .fold<int>(0, (prev, el) => el > prev ? el : prev);

      final newTask = TaskModel(
        id: (maxId + 1).toString(),
        title: title.trim(),
        dueDate: dueDate,
        priority: priority!,
        isComplete: false,
      );

      tasks.add(newTask);
      await _jsonService.writeJsonList(tasks.map((t) => t.toJson()).toList());
      if (dueDate != null) {
        final parsedDate = DateFormat('MMM dd, yyyy HH:mm').parse(dueDate!);
        await scheduleAndroidNotification(title.trim(), parsedDate);
      }
    } catch (e) {
      debugPrint("Error creating new task: $e");
      rethrow;
    } finally {
      setBusy(false);
    }
  }



  Future<void> scheduleAndroidNotification(
      String title, DateTime dateTime) async {
    try {
      await platform.invokeMethod('scheduleNotification', {
        'title': title,
        'timestamp': dateTime.millisecondsSinceEpoch,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule notification: ${e.message}");
    }
  }


}