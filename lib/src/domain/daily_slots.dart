/// Groups together doctors' timeslots on a given day
class DailyTimeSlots {
  final DateTime day;
  final List<DateTime> slots;

  DailyTimeSlots({required this.day, required this.slots});

  /// Creates a sorted list of DaylyTimeSlots from a list of timeslots
  static List<DailyTimeSlots> getAll(List<DateTime> slots) {
    final byDate = _slotsByDate(slots);
    final List<DailyTimeSlots> list = [];
    for (final pair in byDate.entries) {
      final date = pair.key;
      final entriesByDate = pair.value;
      entriesByDate.sort();
      list.add(DailyTimeSlots(day: date, slots: entriesByDate));
    }
    list.sort((a, b) => a.day.compareTo(b.day));
    return list;
  }

  /// Splits timeslots into groups by date
  static Map<DateTime, List<DateTime>> _slotsByDate(List<DateTime> slots) {
    final Map<DateTime, List<DateTime>> map = {};
    for (final slot in slots) {
      final day = DateTime(slot.year, slot.month, slot.day);
      if (map[day] == null) {
        map[day] = [slot];
      } else {
        map[day]!.add(slot);
      }
    }
    return map;
  }
}
