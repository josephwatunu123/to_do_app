class TaskModel {
   final String id;
   final String title;
   final String? dueDate;
   final String priority;
   bool isComplete;

  TaskModel({
    required this.id,
    required this.title,
    this.dueDate,
    required this.priority,
    required this.isComplete
});

   factory TaskModel.fromJson(Map<String, dynamic> json) {
     return TaskModel(
       id: json['id'].toString(),
       title: json['title'] ?? '',
       dueDate: json['dueDate'],
       priority: json['priority'] ?? 'low',
       isComplete: json['isComplete'] ?? false,
     );
   }

   Map<String, dynamic> toJson() {
     return {
       'id': id,
       'title': title,
       'dueDate': dueDate,
       'priority': priority,
       'completed': isComplete,
     };
   }
}