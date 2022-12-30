import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressFile(File file) async {
  final filePath = file.absolute.path;

  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 50,
  );

  print(file.lengthSync());
  print(result?.lengthSync());

  return result!;
}
