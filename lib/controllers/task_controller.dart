import 'package:get/get.dart';
import 'package:root/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  var taskList = <TaskM>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<int> addTask(TaskM? task) async {
    return await DBHelper.insert(task);
  }

  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => new TaskM.fromJson(e)).toList());
  }

  void delete(TaskM task) {
    var val = DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}
