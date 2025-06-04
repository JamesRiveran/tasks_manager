import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../database/DataBaseHelper.dart';
import '../models/task.dart';
import '../models/user.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _searchQuery = '';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  User? _activeUser;
  User? get activeUser => _activeUser;

  TaskProvider();

  List<Task> get tasks => _tasks;
  String get searchQuery => _searchQuery;

  List<Task> get pendingTasks {
    if (_searchQuery.isEmpty) {
      return _tasks.where((task) => !task.isCompleted).toList();
    } else {
      return _tasks
          .where((task) =>
              !task.isCompleted &&
              (task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  task.description
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())))
          .toList();
    }
  }

  List<Task> get completedTasks {
    if (_searchQuery.isEmpty) {
      return _tasks.where((task) => task.isCompleted).toList();
    } else {
      return _tasks
          .where((task) =>
              task.isCompleted &&
              (task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  task.description
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())))
          .toList();
    }
  }

  void setActiveUser(User? user) {
    _activeUser = user;
    _loadTasks();
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    if (_activeUser == null) {
      _tasks = [];
      notifyListeners();
      return;
    }

    final allTasks = await _dbHelper.getTasks();
    _tasks = allTasks.where((task) => task.userId == _activeUser!.id).toList();
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    if (_activeUser == null) return;

    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      userId: _activeUser!.id,
    );

    await _dbHelper.insertTask(newTask);
    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> editTask(String id, String title, String description) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final updatedTask = _tasks[taskIndex].copyWith(
        title: title,
        description: description,
      );

      await _dbHelper.updateTask(updatedTask);
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final updatedTask = _tasks[taskIndex].copyWith(
        isCompleted: !_tasks[taskIndex].isCompleted,
      );

      await _dbHelper.updateTask(updatedTask);
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await _dbHelper.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addDemoTasks() async {
    if (_activeUser == null) return;

    await _dbHelper.deleteAllTasks();

    final demoTasks = [
      Task(
        id: const Uuid().v4(),
        title: 'Estudiar Flutter',
        description: 'Aprender sobre Material Design 3',
        isCompleted: false,
        userId: _activeUser!.id,
      ),
      Task(
        id: const Uuid().v4(),
        title: 'Hacer ejercicio',
        description: '30 minutos de cardio',
        isCompleted: true,
        userId: _activeUser!.id,
      ),
      Task(
        id: const Uuid().v4(),
        title: 'Comprar víveres',
        description: 'Leche, pan, huevos y frutas',
        isCompleted: false,
        userId: _activeUser!.id,
      ),
    ];

    for (var task in demoTasks) {
      await _dbHelper.insertTask(task);
    }

    await _loadTasks();
  }
}
