import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../models/task_model.dart';

class CreateTaskViewModel extends BaseViewModel{
  String title = '';
  String? priority;
  DateTime? dueDate;

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

  Future<void> createNewTask () async{
    if (!formKey.currentState!.validate() || priority == null) return;
    setBusy(true);

    try{
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/todos.json');
      if (!await file.exists()) {
        final data = await rootBundle.loadString('assets/data/todos.json');
        await file.writeAsString(data);
      }
      final raw = await file.readAsString();
      final List<dynamic> list = jsonDecode(raw);
      final maxId = list
          .map((e) => int.tryParse(e['id'].toString()) ?? 0)
          .fold<int>(0, (prev, el) => el > prev ? el : prev);
      final newId = (maxId + 1).toString();
      final task = TaskModel(
        id: newId,
        title: title.trim(),
        dueDate: dueDate?.toIso8601String(),
        priority: priority!,
        isComplete: false,
      );
      list.add(task.toJson());
      await file.writeAsString(jsonEncode(list));
    }catch (e){
      debugPrint("error saving new task $e");

    }finally{
      setBusy(false);
    }
  }
}