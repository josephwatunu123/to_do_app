import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/models/task_model.dart';
import 'package:http/http.dart' as http;

import '../../../services/local_json_service.dart';

class HomeViewModel extends BaseViewModel{
  final _jsonService = LocalJsonService();
  List<TaskModel> _tasks =[];
  List<TaskModel> get tasks => _tasks.where((task) => !task.isComplete).toList();
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> fetchToDos() async {
    setBusy(true);
    notifyListeners();

    try {
      final jsonList = await _jsonService.readJsonList();
      _tasks = jsonList.map((json) => TaskModel.fromJson(json)).toList();
      debugPrint("Fetched ${_tasks.length} todos from local file");
    } catch (e) {
      debugPrint("Error fetching local JSON: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void toggleIsComplete(TaskModel task, bool done) {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isComplete = done;
      notifyListeners();
    }
  }
}