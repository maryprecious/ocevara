import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageUtils {
  static ImageProvider getProfileImageProvider(String url) {
    if (url.startsWith('data:image')) {
      final parts = url.split(',');
      if (parts.length > 1) {
        try {
          final Uint8List bytes = base64Decode(parts[1]);
          return MemoryImage(bytes);
        } catch (e) {
          debugPrint('Error decoding base64 image: $e');
        }
      }
    }
    return NetworkImage(url);
  }
}
