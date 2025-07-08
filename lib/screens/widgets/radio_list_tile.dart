
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/navigation_bloc.dart';

// Widget _buildRadioListTile({
//   required String title,
//   required String description,
//   required NavigationEvent value,
//   required ThemeData theme,
// }) {
//   return Column(
//     children: [
//       RadioListTile<NavigationEvent>(
//         title: Text(title, style: theme.textTheme.titleMedium),
//         subtitle: Text(description, style: theme.textTheme.bodySmall), // Опис тут
//         value: value,
//         groupValue: _selectedScreen,
//         onChanged: (value) => setState(() {
//           _selectedScreen = value!; // Безпечне присвоєння
//         }),
//       ),
//       Divider(), // Розділювач між елементами списку (за бажанням)
//     ],
//   );
// }