// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:time_range/time_range.dart';
//
// import 'colors.dart';
//
// class MyDateAndTime extends StatelessWidget {
//   const MyDateAndTime(
//       {super.key,
//       required this.initialDate,
//       required this.onDateChanged,
//       required this.onRangeCompleted});
//   final DateTime initialDate;
//   final Function onDateChanged, onRangeCompleted;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         EasyDateTimeLine(
//           initialDate: initialDate,
//           onDateChange: (date) => onDateChanged(date),
//           activeColor: MyColorHelper.green1,
//           headerProps: const EasyHeaderProps(
//             showHeader: false,
//             monthPickerType: MonthPickerType.switcher,
//             selectedDateFormat: SelectedDateFormat.fullDateDayAsStrMY,
//           ),
//           dayProps: const EasyDayProps(
//             height: 100,
//             activeDayStyle: DayStyle(borderRadius: 32.0),
//             inactiveDayStyle: DayStyle(borderRadius: 32.0),
//           ),
//           timeLineProps: const EasyTimeLineProps(
//             hPadding: 16.0, // padding from left and right
//             separatorPadding: 16.0, // padding between days
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         TimeRange(
//           fromTitle: const Text(
//             'From',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: MyColorHelper.green1,
//             ),
//           ),
//           toTitle: const Text(
//             'To',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: MyColorHelper.green1,
//             ),
//           ),
//           // titlePadding: 16,
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.normal,
//             color: Colors.black87,
//             fontSize: 12,
//           ),
//           activeTextStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 12,
//           ),
//           titlePadding: 16.0,
//           borderColor: MyColorHelper.green1,
//           activeBorderColor: MyColorHelper.green1,
//           backgroundColor: Colors.transparent,
//           activeBackgroundColor: MyColorHelper.green1,
//           firstTime: const TimeOfDay(hour: 00, minute: 00),
//           lastTime: const TimeOfDay(hour: 23, minute: 59),
//           timeStep: 30,
//           timeBlock: 30,
//           onRangeCompleted: (range) => onRangeCompleted(range),
//         )
//       ],
//     );
//   }
// }
