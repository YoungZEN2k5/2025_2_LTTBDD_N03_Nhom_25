import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'about_page.dart';
import 'add_task_page.dart';
import 'calendar_page.dart';
import 'categories_page.dart';
import 'home_page.dart';
import 'models.dart';
import 'profile_page.dart';
import 'statistics_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught async error: $error');
    debugPrintStack(stackTrace: stack);
    return true;
  };

  runZonedGuarded(() => runApp(const TodoApp()), (
    Object error,
    StackTrace stack,
  ) {
    debugPrint('Uncaught zone error: $error');
    debugPrintStack(stackTrace: stack);
  });
}

enum AppLanguage { english, vietnamese }

enum AppThemeMode { light, dark }

class AppStrings {
  AppStrings(this.language);

  final AppLanguage language;

  static const Map<AppLanguage, Map<String, String>> _values = {
    AppLanguage.english: {
      'appTitle': 'To-Do Bloom',
      'homeTitle': 'My Tasks',
      'homeSubtitle': 'Plan beautifully, finish intentionally.',
      'addTask': 'Add Task',
      'newTask': 'New Task',
      'taskHint': 'Task title',
      'saveTask': 'Save Task',
      'cancel': 'Cancel',
      'emptyTitle': 'No tasks yet',
      'emptySubtitle': 'Tap Add Task to create your first plan.',
      'completed': 'Completed',
      'pending': 'Not completed',
      'overdue': 'Overdue',
      'today': 'Today',
      'inDays': 'In',
      'days': 'days',
      'aboutTeam': 'About Team',
      'projectName': 'Project Name',
      'teamMembers': 'Team Members',
      'description': 'Description',
      'projectValue': 'To-Do Bloom',
      'descriptionValue':
          'A stylish Flutter to-do app focused on beautiful UI, category planning, deadline tracking, and bilingual support.',
      'memberOne': 'Nguyen Van Tien',
      'deleteTask': 'Delete task',
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'taskSaved': 'Task added successfully.',
      'validationEmpty': 'Please enter a value.',
      'aboutCaption': 'Built with Flutter and Material Design.',
      'category': 'Category',
      'deadline': 'Deadline',
      'changeDateTime': 'Change date and time',
      'all': 'All',
      'notCompleted': 'Not completed',
      'themeMode': 'Theme',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'dueLabel': 'Due',
      'summaryTitle': 'Today at a glance',
      'search': 'Search tasks',
      'sort': 'Sort',
      'sortNearest': 'Nearest deadline',
      'sortFarthest': 'Farthest deadline',
      'name': 'Name',
      'email': 'Email',
      'avatar': 'Avatar',
      'save': 'Save',
      'profileUpdatedSuccess': 'Profile updated successfully.',
      'invalidEmail': 'Please enter a valid email.',
      'calendar': 'Calendar',
      'categories': 'Categories',
      'statistics': 'Statistics',
      'profile': 'Profile',
      'contact': 'Contact',
      'phone': 'Phone',
      'contactPhone': 'Phone: 0358880605',
      'contactEmail': 'Email: tien29082005@gmail.com',
    },
    AppLanguage.vietnamese: {
      'appTitle': 'To-Do Bloom',
      'homeTitle': 'Trang chủ',
      'homeSubtitle': 'Lên kế hoạch đẹp mắt, hoàn thành có chủ đích.',
      'addTask': 'Thêm Công Việc',
      'newTask': 'Công Việc Mới',
      'taskHint': 'Tên công việc',
      'saveTask': 'Lưu Công Việc',
      'cancel': 'Hủy',
      'emptyTitle': 'Chưa có công việc',
      'emptySubtitle': 'Nhấn Thêm Công Việc để bắt đầu kế hoạch đầu tiên.',
      'completed': 'Đã hoàn thành',
      'pending': 'Chưa hoàn thành',
      'overdue': 'Quá hạn',
      'today': 'Hôm nay',
      'inDays': 'Còn',
      'days': 'ngày',
      'aboutTeam': 'Thông Tin Nhóm',
      'projectName': 'Tên dự án',
      'teamMembers': 'Thành viên nhóm',
      'description': 'Mô tả',
      'projectValue': 'To-Do Bloom',
      'descriptionValue':
          'Ứng dụng hỗ trợ cho người dùng quản lý công việc cá nhân.',
      'memberOne': 'Nguyễn Văn Tiến',
      'deleteTask': 'Xóa công việc',
      'language': 'Ngôn ngữ',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'taskSaved': 'Đã thêm công việc thành công.',
      'validationEmpty': 'Vui lòng nhập giá trị.',
      'aboutCaption': 'Xây dựng bằng Flutter và Material Design.',
      'category': 'Danh mục',
      'deadline': 'Thời hạn',
      'changeDateTime': 'Đổi ngày và giờ',
      'all': 'Tất cả',
      'notCompleted': 'Chưa hoàn thành',
      'themeMode': 'Giao diện',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'dueLabel': 'Hạn',
      'summaryTitle': 'Tổng quan hôm nay',
      'search': 'Tìm kiếm công việc',
      'sort': 'Sắp xếp',
      'sortNearest': 'Hạn gần nhất',
      'sortFarthest': 'Hạn xa nhất',
      'name': 'Họ tên',
      'email': 'Email',
      'avatar': 'Ảnh đại diện',
      'save': 'Lưu',
      'profileUpdatedSuccess': 'Cập nhật hồ sơ thành công.',
      'invalidEmail': 'Vui lòng nhập email hợp lệ.',
      'calendar': 'Lịch',
      'categories': 'Danh mục',
      'statistics': 'Thống kê',
      'profile': 'Tài khoản',
      'contact': 'Liên hệ',
      'phone': 'SĐT',
      'contactPhone': 'SĐT: 0358880605',
      'contactEmail': 'Email: tien29082005@gmail.com',
      'authError': 'Thao tác thất bại. Vui lòng thử lại.',
      'updateProfile': 'Cập nhật',
    },
  };

  String get(String key) => _values[language]?[key] ?? key;
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  AppLanguage _language = AppLanguage.english;
  AppThemeMode _themeMode = AppThemeMode.light;
  int _tabIndex = 0;

  final List<TaskItem> _tasks = <TaskItem>[];
  final List<String> _categories = <String>[
    'Study',
    'Work',
    'Personal',
    'Shopping',
  ];
  UserProfile _profile = UserProfile(
    name: 'Nguyễn Văn Tiến',
    email: 'tien29082005@gmail.com',
    avatarSeed: 0,
  );

  AppStrings get _strings => AppStrings(_language);

  void _toggleTask(int index, bool? isCompleted) {
    setState(() {
      _tasks[index].isCompleted = isCompleted ?? false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _openAddTaskPage(BuildContext context) async {
    final TaskItem? newTask = await Navigator.of(context).push<TaskItem>(
      MaterialPageRoute<TaskItem>(
        builder: (_) => AddTaskPage(strings: _strings, categories: _categories),
      ),
    );

    if (newTask == null) {
      return;
    }

    setState(() {
      _tasks.insert(0, newTask);
    });

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(_strings.get('taskSaved'))));
  }

  void _changeLanguage(AppLanguage language) {
    if (_language == language) {
      return;
    }
    setState(() {
      _language = language;
    });
  }

  void _changeThemeMode(AppThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }
    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _openAboutPage(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => AboutPage(strings: _strings)),
    );
  }

  bool _addCategory(String name) {
    final String value = name.trim();
    if (value.isEmpty) {
      return false;
    }
    final bool exists = _categories.any(
      (String c) => c.toLowerCase() == value.toLowerCase(),
    );
    if (exists) {
      return false;
    }

    setState(() {
      _categories.add(value);
    });
    return true;
  }

  bool _renameCategory(String oldName, String newName) {
    final String value = newName.trim();
    if (value.isEmpty) {
      return false;
    }
    final int index = _categories.indexOf(oldName);
    if (index < 0) {
      return false;
    }

    final bool exists = _categories.any(
      (String c) => c.toLowerCase() == value.toLowerCase() && c != oldName,
    );
    if (exists) {
      return false;
    }

    setState(() {
      _categories[index] = value;
      for (final TaskItem task in _tasks) {
        if (task.category == oldName) {
          task.category = value;
        }
      }
    });
    return true;
  }

  bool _deleteCategory(String name) {
    if (_categories.length <= 1) {
      return false;
    }

    final int index = _categories.indexOf(name);
    if (index < 0) {
      return false;
    }

    setState(() {
      _categories.removeAt(index);
      final String fallback = _categories.first;
      for (final TaskItem task in _tasks) {
        if (task.category == name) {
          task.category = fallback;
        }
      }
    });
    return true;
  }

  void _updateProfile(UserProfile profile) {
    setState(() {
      _profile = profile;
    });
  }

  String _titleForTab() {
    switch (_tabIndex) {
      case 0:
        return _strings.get('homeTitle');
      case 1:
        return _strings.get('calendar');
      case 2:
        return _strings.get('categories');
      case 3:
        return _strings.get('statistics');
      case 4:
        return _strings.get('profile');
      default:
        return _strings.get('homeTitle');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1B6B5A),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F3EA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1A342D),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.93),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1A342D),
        foregroundColor: Colors.white,
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7ED5B0),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF101A16),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE1F5EB),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1A2A25).withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF7ED5B0),
        foregroundColor: Color(0xFF10231C),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _strings.get('appTitle'),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode == AppThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: Builder(
        builder: (BuildContext innerContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titleForTab()),
              actions: <Widget>[
                PopupMenuButton<AppLanguage>(
                  tooltip: _strings.get('language'),
                  icon: const Icon(Icons.translate_rounded),
                  onSelected: _changeLanguage,
                  itemBuilder: (_) => <PopupMenuEntry<AppLanguage>>[
                    PopupMenuItem<AppLanguage>(
                      value: AppLanguage.english,
                      child: Text(_strings.get('english')),
                    ),
                    PopupMenuItem<AppLanguage>(
                      value: AppLanguage.vietnamese,
                      child: Text(_strings.get('vietnamese')),
                    ),
                  ],
                ),
                PopupMenuButton<AppThemeMode>(
                  tooltip: _strings.get('themeMode'),
                  icon: Icon(
                    _themeMode == AppThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                  onSelected: _changeThemeMode,
                  itemBuilder: (_) => <PopupMenuEntry<AppThemeMode>>[
                    PopupMenuItem<AppThemeMode>(
                      value: AppThemeMode.light,
                      child: Text(_strings.get('lightMode')),
                    ),
                    PopupMenuItem<AppThemeMode>(
                      value: AppThemeMode.dark,
                      child: Text(_strings.get('darkMode')),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: _strings.get('aboutTeam'),
                  onPressed: () => _openAboutPage(innerContext),
                  icon: const Icon(Icons.groups_rounded),
                ),
                const SizedBox(width: 8),
              ],
            ),
            floatingActionButton: _tabIndex == 0
                ? FloatingActionButton.extended(
                    onPressed: () => _openAddTaskPage(innerContext),
                    icon: const Icon(Icons.add_task_rounded),
                    label: Text(_strings.get('addTask')),
                  )
                : null,
            body: IndexedStack(
              index: _tabIndex,
              children: <Widget>[
                HomePage(
                  strings: _strings,
                  tasks: _tasks,
                  categories: _categories,
                  onToggleTask: _toggleTask,
                  onDeleteTask: _deleteTask,
                ),
                CalendarPage(strings: _strings, tasks: _tasks),
                CategoriesPage(
                  strings: _strings,
                  categories: _categories,
                  tasks: _tasks,
                  onAddCategory: _addCategory,
                  onRenameCategory: _renameCategory,
                  onDeleteCategory: _deleteCategory,
                ),
                StatisticsPage(strings: _strings, tasks: _tasks),
                ProfilePage(
                  strings: _strings,
                  profile: _profile,
                  onUpdateProfile: _updateProfile,
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tabIndex,
              onDestinationSelected: (int index) =>
                  setState(() => _tabIndex = index),
              destinations: <Widget>[
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: _strings.get('homeTitle'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.calendar_month_outlined),
                  selectedIcon: const Icon(Icons.calendar_month_rounded),
                  label: _strings.get('calendar'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.category_outlined),
                  selectedIcon: const Icon(Icons.category_rounded),
                  label: _strings.get('categories'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart_rounded),
                  label: _strings.get('statistics'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: _strings.get('profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
