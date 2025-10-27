import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleTimePicker extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;
  final Function(TimeOfDay?)? onTimeSelected;
  const ScheduleTimePicker(
      {super.key, this.onDateSelected, this.onTimeSelected});

  @override
  State<ScheduleTimePicker> createState() => _ScheduleTimePickerState();
}

class _ScheduleTimePickerState extends State<ScheduleTimePicker> {
 // Date controller
  final TextEditingController _dateController = TextEditingController();

  // Time controller
  final TextEditingController _timeController = TextEditingController();

  // Stored date and time
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Date picker method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // Format the date using intl package
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });

      // Call the callback if provided
      widget.onDateSelected?.call(_selectedDate);
    }
  }

  // Time picker method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        // Format time using the built-in format method
        _timeController.text = picked.format(context);
      });

      // Call the callback if provided
      widget.onTimeSelected?.call(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Date TextField
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Select Date',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16),

          // Time TextField
          TextField(
            controller: _timeController,
            decoration: InputDecoration(
              labelText: 'Select Time',
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}