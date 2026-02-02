class WeekDates {

  List<DateTime> getWeekDates(DateTime date){
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) =>
    monday.add(Duration(days: index)));
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceStart = date.difference(firstDayOfYear).inDays;
    return ((daysSinceStart + firstDayOfYear.weekday) / 7).ceil();
  }
}