import 'appointment.dart';

/// Groups together appointments on a given day
class DailyAppointments {
  final DateTime day;
  final List<Appointment> appointments;

  DailyAppointments({required this.day, required this.appointments});

  /// Creates a sorted list of DaylyAppointments from a list of appointments
  static List<DailyAppointments> getAll(List<Appointment> appointments) {
    final byDate = _slotsByDate(appointments);
    final List<DailyAppointments> list = [];
    for (final pair in byDate.entries) {
      final date = pair.key;
      final entriesByDate = pair.value;
      entriesByDate.sort();
      list.add(DailyAppointments(day: date, appointments: entriesByDate));
    }
    list.sort((a, b) => a.day.compareTo(b.day));
    return list;
  }

  /// Splits appointments into groups by date
  static Map<DateTime, List<Appointment>> _slotsByDate(
      List<Appointment> appointments) {
    final Map<DateTime, List<Appointment>> map = {};
    for (final appointment in appointments) {
      final slot = appointment.start;
      final day = DateTime(slot.year, slot.month, slot.day);

      if (map[day] == null) {
        map[day] = [appointment];
      } else {
        map[day]!.add(appointment);
      }
    }
    return map;
  }
}
