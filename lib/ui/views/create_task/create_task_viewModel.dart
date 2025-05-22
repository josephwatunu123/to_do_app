import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../models/task_model.dart';
import '../../../services/local_json_service.dart';

class CreateTaskViewModel extends BaseViewModel{
  String title = '';
  String? priority;
  DateTime? dueDate;
  final _jsonService = LocalJsonService();

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

  void setDueDate(DateTime? val) {
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
        dueDate: dueDate?.toIso8601String(),
        priority: priority!,
        isComplete: false,
      );

      tasks.add(newTask);
      await _jsonService.writeJsonList(tasks.map((t) => t.toJson()).toList());
    } catch (e) {
      debugPrint("Error creating new task: $e");
      rethrow;
    } finally {
      setBusy(false);
    }
  }

}