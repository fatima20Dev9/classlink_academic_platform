import 'package:flutter/material.dart';
import '../../../../models/enums/assignment_filter.dart';

class AssignmentFilterTabs extends StatelessWidget {
  final AssignmentFilter selectedFilter;
  final ValueChanged<AssignmentFilter> onChanged;

  const AssignmentFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final filters = AssignmentFilter.values;

    return SizedBox(
      height: 60,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? scheme.primary
                      : scheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: scheme.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _label(filter),
                    style: TextStyle(
                      color:
                          isSelected
                              ? scheme.onPrimary
                              : scheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(AssignmentFilter filter) {
    switch (filter) {
      case AssignmentFilter.all:
        return 'All';

      case AssignmentFilter.pending:
        return 'Pending';

      case AssignmentFilter.submitted:
        return 'Submitted';
    }
  }
}