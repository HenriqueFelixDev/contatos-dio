import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceItem extends StatelessWidget {
  final String? label;
  final IconData icon;
  final ImageSource value;

  const ImageSourceItem({
    super.key,
    this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context, value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            margin: const EdgeInsets.only(bottom: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
            ),
            child: Icon(icon),
          ),
          Text(label ?? value.name),
        ],
      ),
    );
  }
}
