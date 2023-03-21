import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EventCalendar(
        calendarType: CalendarType.GREGORIAN,
        calendarOptions: CalendarOptions(
          toggleViewType: true,
          viewType: ViewType.DAILY,
        ),
        calendarLanguage: 'en',
        events: [
          Event(
            child: const Text('Change of Command'),
            dateTime: CalendarDateTime(
              year: 2023,
              month: 12,
              day: 8,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
        ],
      ),
    );
  }
}
