import 'package:flutter/material.dart';

import 'models.dart';
import 'main.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.strings,
    required this.categories,
    required this.tasks,
    required this.onAddCategory,
    required this.onRenameCategory,
    required this.onDeleteCategory,
  });

  final AppStrings strings;
  final List<String> categories;
  final List<TaskItem> tasks;
  final bool Function(String name) onAddCategory;
  final bool Function(String oldName, String newName) onRenameCategory;
  final bool Function(String name) onDeleteCategory;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? _selectedCategory;
  String? _renamingCategory;
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void dispose() {
    _addController.dispose();
    _renameController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CategoriesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedCategory != null &&
        !widget.categories.contains(_selectedCategory)) {
      _selectedCategory = widget.categories.isEmpty
          ? null
          : widget.categories.first;
    }
    if (_renamingCategory != null &&
        !widget.categories.contains(_renamingCategory)) {
      _renamingCategory = null;
      _renameController.clear();
    }
  }

  void _showToast(String text) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _submitAddCategory() {
    final String value = _addController.text.trim();
    if (value.isEmpty) {
      _showToast(widget.strings.get('validationEmpty'));
      return;
    }

    bool ok = false;
    try {
      ok = widget.onAddCategory(value);
    } catch (_) {
      ok = false;
    }

    if (!mounted) {
      return;
    }

    if (ok) {
      setState(() {
        _selectedCategory = value;
        _addController.clear();
      });
    } else {
      _showToast(widget.strings.get('authError'));
    }
  }

  void _startRename(String category) {
    setState(() {
      _renamingCategory = category;
      _renameController.text = category;
    });
  }

  void _cancelRename() {
    setState(() {
      _renamingCategory = null;
      _renameController.clear();
    });
  }

  void _submitRename(String oldName) {
    final String newName = _renameController.text.trim();
    if (newName.isEmpty) {
      _showToast(widget.strings.get('validationEmpty'));
      return;
    }

    bool ok = false;
    try {
      ok = widget.onRenameCategory(oldName, newName);
    } catch (_) {
      ok = false;
    }

    if (!mounted) {
      return;
    }

    if (ok) {
      setState(() {
        if (_selectedCategory == oldName) {
          _selectedCategory = newName;
        }
        _renamingCategory = null;
        _renameController.clear();
      });
    } else {
      _showToast(widget.strings.get('authError'));
    }
  }

  void _deleteCategory(String name) {
    bool ok = false;
    try {
      ok = widget.onDeleteCategory(name);
    } catch (_) {
      ok = false;
    }

    if (!mounted) {
      return;
    }

    if (ok) {
      setState(() {
        if (_selectedCategory == name) {
          _selectedCategory = widget.categories.isEmpty
              ? null
              : widget.categories.first;
        }
        if (_renamingCategory == name) {
          _renamingCategory = null;
          _renameController.clear();
        }
      });
    } else {
      _showToast(widget.strings.get('authError'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> categories = List<String>.from(widget.categories);
    final List<TaskItem> filteredTasks = _selectedCategory == null
        ? <TaskItem>[]
        : widget.tasks
              .where((TaskItem t) => t.category == _selectedCategory)
              .toList();

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? <Color>[
                      const Color(0xFF111F1A),
                      const Color(0xFF173027),
                      const Color(0xFF1C3A31),
                    ]
                  : <Color>[
                      const Color(0xFFE5F5EE),
                      const Color(0xFFF8F3EA),
                      const Color(0xFFF1FAF5),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -75,
          right: -35,
          child: _GlowOrb(
            size: 180,
            color: isDark
                ? const Color(0xFF79D8B7).withValues(alpha: 0.23)
                : const Color(0xFF8CDFC6).withValues(alpha: 0.28),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? <Color>[
                              const Color(0xFF21473B),
                              const Color(0xFF153028),
                            ]
                          : <Color>[
                              const Color(0xFF1E3F36),
                              const Color(0xFF2D6D5D),
                            ],
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.category_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.strings.get('categories'),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            Text(
                              '${categories.length} ${widget.strings.get('category')}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.86),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _addController,
                            decoration: InputDecoration(
                              hintText: widget.strings.get('category'),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submitAddCategory(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: _submitAddCategory,
                          icon: const Icon(Icons.add_rounded),
                          label: Text(widget.strings.get('save')),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ...categories.map((String category) {
                        final int count = widget.tasks
                            .where((TaskItem t) => t.category == category)
                            .length;
                        final bool selected = _selectedCategory == category;
                        final bool isRenaming = _renamingCategory == category;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () => setState(
                                      () => _selectedCategory = category,
                                    ),
                                    selected: selected,
                                    title: Text(category),
                                    subtitle: Text('$count'),
                                    leading: CircleAvatar(
                                      child: Text(
                                        category.isEmpty
                                            ? '?'
                                            : category[0].toUpperCase(),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 96,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () =>
                                                _startRename(category),
                                            icon: const Icon(
                                              Icons.edit_rounded,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _deleteCategory(category),
                                            icon: const Icon(
                                              Icons.delete_outline_rounded,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isRenaming)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        4,
                                        12,
                                        8,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: _renameController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              onSubmitted: (_) =>
                                                  _submitRename(category),
                                              decoration: InputDecoration(
                                                hintText: widget.strings.get(
                                                  'category',
                                                ),
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _submitRename(category),
                                            icon: const Icon(
                                              Icons.check_circle_rounded,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: _cancelRename,
                                            icon: const Icon(
                                              Icons.close_rounded,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                      if (_selectedCategory != null)
                        Text(
                          '${widget.strings.get('category')}: $_selectedCategory',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      const SizedBox(height: 8),
                      ...filteredTasks.map(
                        (TaskItem task) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                task.isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                              ),
                              title: Text(task.title),
                              subtitle: Text(
                                '${widget.strings.get('dueLabel')}: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: color, blurRadius: 90, spreadRadius: 15),
          ],
        ),
      ),
    );
  }
}
