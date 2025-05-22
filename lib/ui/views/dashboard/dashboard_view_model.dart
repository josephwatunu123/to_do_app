import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/models/task_model.dart';

import '../../../services/local_json_service.dart';

class DashboardViewModel extends BaseViewModel {
  final _jsonService = LocalJsonService();

  List<TaskModel> _allTasks = [];

  // Completed tasks by priority
  List<TaskModel> _completedTasks = [];
  List<TaskModel> _completedHighPriorityTasks = [];
  List<TaskModel> _completedMediumPriorityTasks = [];
  List<TaskModel> _completedLowPriorityTasks = [];

  // Total tasks by priority (for accurate progress calculation)
  List<TaskModel> _highPriorityTasks = [];
  List<TaskModel> _mediumPriorityTasks = [];
  List<TaskModel> _lowPriorityTasks = [];

  // Pre-calculated progress values
  double _overallProgress = 0.0;
  double _highPriorityProgress = 0.0;
  double _mediumPriorityProgress = 0.0;
  double _lowPriorityProgress = 0.0;

  // Getters for completed tasks
  List<TaskModel> get completedTasks => List.unmodifiable(_completedTasks);
  List<TaskModel> get completedHighPriorityTasks => List.unmodifiable(_completedHighPriorityTasks);
  List<TaskModel> get completedMediumPriorityTasks => List.unmodifiable(_completedMediumPriorityTasks);
  List<TaskModel> get completedLowPriorityTasks => List.unmodifiable(_completedLowPriorityTasks);

  // Getters for all tasks by priority
  List<TaskModel> get allTasks => List.unmodifiable(_allTasks);
  List<TaskModel> get highPriorityTasks => List.unmodifiable(_highPriorityTasks);
  List<TaskModel> get mediumPriorityTasks => List.unmodifiable(_mediumPriorityTasks);
  List<TaskModel> get lowPriorityTasks => List.unmodifiable(_lowPriorityTasks);

  // Pre-calculated progress getters (no computation needed)
  double get overallProgress => _overallProgress;
  double get highPriorityProgress => _highPriorityProgress;
  double get mediumPriorityProgress => _mediumPriorityProgress;
  double get lowPriorityProgress => _lowPriorityProgress;

  // Fetch and calculate all progress data in one go
  Future<void> fetchTasksProgress() async {
    setBusy(true);
    notifyListeners();

    try {
      final jsonList = await _jsonService.readJsonList();
      _allTasks = jsonList.map((json) => TaskModel.fromJson(json)).toList();

      _calculateProgress();

    } catch (e) {
      debugPrint("Error fetching tasks: $e");
      // Reset to empty state on error
      _resetState();
    } finally {
      setBusy(false);
    }
  }

  void _calculateProgress() {
    // Group tasks by completion status and priority in a single pass
    _completedTasks.clear();
    _highPriorityTasks.clear();
    _mediumPriorityTasks.clear();
    _lowPriorityTasks.clear();
    _completedHighPriorityTasks.clear();
    _completedMediumPriorityTasks.clear();
    _completedLowPriorityTasks.clear();

    for (final task in _allTasks) {
      // Group by completion
      if (task.isComplete) {
        _completedTasks.add(task);
      }

      // Group by priority and track completed ones
      switch (task.priority.toLowerCase()) {
        case 'high':
          _highPriorityTasks.add(task);
          if (task.isComplete) {
            _completedHighPriorityTasks.add(task);
          }
          break;
        case 'medium':
          _mediumPriorityTasks.add(task);
          if (task.isComplete) {
            _completedMediumPriorityTasks.add(task);
          }
          break;
        case 'low':
          _lowPriorityTasks.add(task);
          if (task.isComplete) {
            _completedLowPriorityTasks.add(task);
          }
          break;
      }
    }

    // Calculate progress percentages once
    _overallProgress = _allTasks.isEmpty ? 0.0 : _completedTasks.length / _allTasks.length;
    _highPriorityProgress = _highPriorityTasks.isEmpty ? 0.0 : _completedHighPriorityTasks.length / _highPriorityTasks.length;
    _mediumPriorityProgress = _mediumPriorityTasks.isEmpty ? 0.0 : _completedMediumPriorityTasks.length / _mediumPriorityTasks.length;
    _lowPriorityProgress = _lowPriorityTasks.isEmpty ? 0.0 : _completedLowPriorityTasks.length / _lowPriorityTasks.length;
  }

  void _resetState() {
    _allTasks.clear();
    _completedTasks.clear();
    _highPriorityTasks.clear();
    _mediumPriorityTasks.clear();
    _lowPriorityTasks.clear();
    _completedHighPriorityTasks.clear();
    _completedMediumPriorityTasks.clear();
    _completedLowPriorityTasks.clear();

    _overallProgress = 0.0;
    _highPriorityProgress = 0.0;
    _mediumPriorityProgress = 0.0;
    _lowPriorityProgress = 0.0;
  }

  // Helper methods for counts (useful for UI display)
  int get totalTasksCount => _allTasks.length;
  int get completedTasksCount => _completedTasks.length;
  int get pendingTasksCount => _allTasks.length - _completedTasks.length;

  // Priority-specific counts
  int get highPriorityCount => _highPriorityTasks.length;
  int get mediumPriorityCount => _mediumPriorityTasks.length;
  int get lowPriorityCount => _lowPriorityTasks.length;

  int get completedHighPriorityCount => _completedHighPriorityTasks.length;
  int get completedMediumPriorityCount => _completedMediumPriorityTasks.length;
  int get completedLowPriorityCount => _completedLowPriorityTasks.length;
}