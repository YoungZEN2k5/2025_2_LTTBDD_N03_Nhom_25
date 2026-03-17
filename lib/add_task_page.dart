import 'package:flutter/material.dart';

import 'models.dart';
import 'main.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({
    super.key,
    required this.strings,
    required this.categories,
  });

  final AppStrings strings;
  final List<String> categories;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDeadline = DateTime.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.isEmpty
        ? 'General'
        : widget.categories.first;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  String _twoDigits(int number) => number.toString().padLeft(2, '0');

  String _formatDateTime(DateTime dateTime) {
    return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  }

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedDeadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      TaskItem(
        title: _taskController.text.trim(),
        category: _selectedCategory,
        deadline: _selectedDeadline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(widget.strings.get('newTask'))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? <Color>[
                    const Color(0xFF0F1C18),
                    const Color(0xFF16302A),
                    const Color(0xFF193A31),
                  ]
                : <Color>[
                    const Color(0xFFDCEFE7),
                    const Color(0xFFF7F3EB),
                    const Color(0xFFF2F8F2),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.strings.get('addTask'),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.strings.get('homeSubtitle'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 22),
                          TextFormField(
                            controller: _taskController,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              hintText: widget.strings.get('taskHint'),
                              prefixIcon: const Icon(Icons.assignment_rounded),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return widget.strings.get('validationEmpty');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          Text(
                            widget.strings.get('category'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: widget.categories
                                .map(
                                  (String category) => ChoiceChip(
                                    selected: _selectedCategory == category,
                                    label: Text(category),
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            widget.strings.get('deadline'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Card.outlined(
                            child: ListTile(
                              leading: const Icon(
                                Icons.event_available_rounded,
                              ),
                              title: Text(_formatDateTime(_selectedDeadline)),
                              subtitle: Text(
                                widget.strings.get('changeDateTime'),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_calendar_rounded),
                                onPressed: _pickDateTime,
                              ),
                              onTap: _pickDateTime,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(widget.strings.get('cancel')),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.save_rounded),
                                  label: Text(widget.strings.get('saveTask')),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
