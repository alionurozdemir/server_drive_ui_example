import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:rfw/formats.dart';
import 'package:rfw/rfw.dart';

Future<String> fetchRfwTxt() async {
  final response = await http.get(Uri.parse('https://www.alionurozdemir.com/test3.rfwtxt'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Dosya indirilemedi: ${response.statusCode}');
  }
}

Future<Uint8List> parseAndEncodeRfwTxt(String source) async {
  final library = parseLibraryFile(source);
  return encodeLibraryBlob(library);
}

Future<void> updateRuntime(Runtime runtime, Uint8List binary) async {
  final remoteWidgets = decodeLibraryBlob(binary);
  runtime.update(const LibraryName(['main']), remoteWidgets);
}
