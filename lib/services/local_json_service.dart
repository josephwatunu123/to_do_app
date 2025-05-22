import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalJsonService {
  static const String _fileName = 'todos.json';
  File? _localFile;

  Future<File> _getLocalFile() async {
    if (_localFile != null) return _localFile!;
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    if (!await file.exists()) {
      final assetData = await rootBundle.loadString('assets/data/todos.json');
      await file.writeAsString(assetData);
    }

    _localFile = file;
    return file;
  }


  Future<List<dynamic>> readJsonList() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      return jsonDecode(contents) as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> writeJsonList(List<Map<String, dynamic>> jsonList) async {
    try {
      final file = await _getLocalFile();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      rethrow;
    }
  }
}
