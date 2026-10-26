import 'package:flutter/material.dart';

class NumberInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final Function(int) onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final int? initialValue;

  const NumberInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.controller,
    this.enabled = true,
    this.initialValue,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late final TextEditingController _internalController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _internalController = widget.controller!;
    } else {
      final initial = widget.initialValue;
      _internalController = TextEditingController(
        text: (initial == null || initial == 0) ? '' : initial.toString(),
      );
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _internalController,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.onChanged(int.tryParse(value.trim()) ?? 0);
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
