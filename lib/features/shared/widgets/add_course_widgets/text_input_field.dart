import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String label;
  final String hint;
  final Function(String) onChanged;
  final int maxLines;
  final TextEditingController? controller;
  final bool enabled;
  final TextInputType keyboardType;
  final String? initialValue;

  const TextInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint = '',
    this.maxLines = 1,
    this.controller,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.initialValue,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late final TextEditingController _internalController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _internalController = widget.controller!;
    } else {
      _internalController =
          TextEditingController(text: widget.initialValue ?? '');
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
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onChanged: (value) => widget.onChanged(value.trim()),
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
