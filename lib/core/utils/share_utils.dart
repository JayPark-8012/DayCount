import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Captures the widget wrapped by [RepaintBoundary] as PNG bytes.
/// Uses pixelRatio 3.0 for 1080×1080 export.
Future<Uint8List> captureCard(GlobalKey key) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

/// Saves [pngBytes] to a temporary file and returns its path.
Future<String> saveTempFile(Uint8List pngBytes) async {
  final dir = await getTemporaryDirectory();
  final file = File(
    '${dir.path}/daycount_share_${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(pngBytes);
  return file.path;
}

/// Opens the native share sheet with the image at [filePath].
Future<void> shareImage(String filePath) async {
  await Share.shareXFiles([XFile(filePath)]);
}
