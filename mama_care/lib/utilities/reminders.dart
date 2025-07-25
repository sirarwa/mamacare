import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderItem {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final IconData icon;
  final bool isCompleted;

  ReminderItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.icon,
    this.isCompleted = false,
  });

  ReminderItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    IconData? icon,
    bool? isCompleted,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> with TickerProviderStateMixin {
  final List<ReminderItem> _reminders = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
  IconData _selectedIcon = Icons.medical_services;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _iconOptions = [
    {'icon': Icons.medical_services, 'label': 'Medical'},
    {'icon': Icons.vaccines, 'label': 'Vaccination'},
    {'icon': Icons.pregnant_woman, 'label': 'Prenatal'},
    {'icon': Icons.baby_changing_station, 'label': 'Baby Care'},
    {'icon': Icons.medication, 'label': 'Medication'},
    {'icon': Icons.favorite, 'label': 'Health'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _addReminder() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 500));

    final newReminder = ReminderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: _selectedDateTime,
      icon: _selectedIcon,
    );

    setState(() {
      _reminders.add(newReminder);
      _isLoading = false;
    });

    _titleController.clear();
    _descriptionController.clear();
    _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
    _selectedIcon = Icons.medical_services;

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Reminder added successfully!'),
            ],
          ),
          backgroundColor: Colors.pinkAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _deleteReminder(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 24),
              SizedBox(width: 8),
              Text('Delete Reminder'),
            ],
          ),
          content: const Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _reminders.removeWhere((reminder) => reminder.id == id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Reminder deleted'),
                      ],
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleComplete(String id) {
    setState(() {
      final index = _reminders.indexWhere((reminder) => reminder.id == id);
      if (index != -1) {
        _reminders[index] = _reminders[index].copyWith(
          isCompleted: !_reminders[index].isCompleted,
        );
      }
    });
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.pinkAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.pinkAccent,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          setState(() {
            _selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          });
        }
      }
    }
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.add_alert, color: Colors.pinkAccent, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Add New Reminder',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Reminder Title',
                          labelStyle: const TextStyle(color: Colors.pinkAccent),
                          hintText: 'e.g., Baby\'s 3-month checkup',
                          prefixIcon: const Icon(Icons.title, color: Colors.pinkAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a reminder title';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      
                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          labelStyle: const TextStyle(color: Colors.pinkAccent),
                          hintText: 'Additional details about the reminder',
                          prefixIcon: const Icon(Icons.description, color: Colors.pinkAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                          ),
                        ),
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      
                      // Date & Time Selection
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.schedule, color: Colors.pinkAccent),
                          title: const Text('Date & Time'),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime),
                            style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.pinkAccent),
                          onTap: () async {
                            await _selectDateTime();
                            setDialogState(() {}); // Update dialog state
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Icon Selection
                      const Text(
                        'Select Icon:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _iconOptions.map((option) {
                          final isSelected = _selectedIcon == option['icon'];
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                _selectedIcon = option['icon'];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.pinkAccent.withOpacity(0.1) : Colors.grey.shade100,
                                border: Border.all(
                                  color: isSelected ? Colors.pinkAccent : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    option['icon'],
                                    color: isSelected ? Colors.pinkAccent : Colors.grey.shade600,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option['label'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? Colors.pinkAccent : Colors.grey.shade600,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.of(context).pop();
                    _titleController.clear();
                    _descriptionController.clear();
                    _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
                    _selectedIcon = Icons.medical_services;
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Add Reminder'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingReminders = _reminders.where((r) => !r.isCompleted && r.dateTime.isAfter(DateTime.now())).toList();
    final completedReminders = _reminders.where((r) => r.isCompleted).toList();
    final overdueReminders = _reminders.where((r) => !r.isCompleted && r.dateTime.isBefore(DateTime.now())).toList();

    // Sort reminders by date
    upcomingReminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    overdueReminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    completedReminders.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: Colors.pinkAccent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health Reminders',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          Text(
                            'Stay on top of your health checkups',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Stats
                if (_reminders.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Upcoming',
                          upcomingReminders.length.toString(),
                          Icons.upcoming,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Overdue',
                          overdueReminders.length.toString(),
                          Icons.warning,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Completed',
                          completedReminders.length.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Reminders List
                Expanded(
                  child: _reminders.isEmpty
                      ? _buildEmptyState()
                      : DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: Colors.pinkAccent,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.pinkAccent,
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.upcoming, size: 16),
                                        const SizedBox(width: 4),
                                        Text('Upcoming (${upcomingReminders.length})'),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.warning, size: 16),
                                        const SizedBox(width: 4),
                                        Text('Overdue (${overdueReminders.length})'),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle, size: 16),
                                        const SizedBox(width: 4),
                                        Text('Done (${completedReminders.length})'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    _buildRemindersList(upcomingReminders, 'upcoming'),
                                    _buildRemindersList(overdueReminders, 'overdue'),
                                    _buildRemindersList(completedReminders, 'completed'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderDialog,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule,
              size: 64,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Reminders Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first health reminder\nto stay on track with your care',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddReminderDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Reminder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(List<ReminderItem> reminders, String type) {
    if (reminders.isEmpty) {
      String message = '';
      IconData icon = Icons.check_circle;
      
      switch (type) {
        case 'upcoming':
          message = 'No upcoming reminders';
          icon = Icons.upcoming;
          break;
        case 'overdue':
          message = 'No overdue reminders';
          icon = Icons.warning;
          break;
        case 'completed':
          message = 'No completed reminders';
          icon = Icons.check_circle;
          break;
      }
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _buildReminderCard(reminder, type);
      },
    );
  }

  Widget _buildReminderCard(ReminderItem reminder, String type) {
    Color cardColor = Colors.white;
    Color accentColor = Colors.pinkAccent;
    
    if (type == 'overdue') {
      accentColor = Colors.orangeAccent;
    } else if (type == 'completed') {
      accentColor = Colors.green;
      cardColor = Colors.green.withOpacity(0.1);
    }

    final isOverdue = type == 'overdue';
    final daysDifference = DateTime.now().difference(reminder.dateTime).inDays;
    final hoursDifference = DateTime.now().difference(reminder.dateTime).inHours;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? Colors.orangeAccent.withOpacity(0.7) : Colors.grey.withOpacity(0.5),
          width: isOverdue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            reminder.icon,
            color: accentColor,
            size: 24,
          ),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: reminder.isCompleted ? Colors.grey : Colors.black87,
            decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                reminder.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: isOverdue ? Colors.orangeAccent : accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(reminder.dateTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.orangeAccent : accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (isOverdue) ...[
              const SizedBox(height: 4),
              Text(
                daysDifference > 0
                    ? 'Overdue by $daysDifference day${daysDifference == 1 ? '' : 's'}'
                    : 'Overdue by $hoursDifference hour${hoursDifference == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!reminder.isCompleted)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () => _toggleComplete(reminder.id),
                tooltip: 'Mark as completed',
              ),
            if (reminder.isCompleted)
              IconButton(
                icon: const Icon(Icons.undo),
                color: Colors.blue,
                onPressed: () => _toggleComplete(reminder.id),
                tooltip: 'Mark as incomplete',
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              onPressed: () => _deleteReminder(reminder.id),
              tooltip: 'Delete reminder',
            ),
          ],
        ),
      ),
    );
  }
}
