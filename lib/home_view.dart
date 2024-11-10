import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';
import 'package:server_drive_ui_example/service.dart';

class RemoteButtonApp extends StatelessWidget {
  final Runtime runtime = Runtime();
  final DynamicContent data = DynamicContent();

  RemoteButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: const Text('RFW Example')),
        body: FutureBuilder(
          future: fetchRfwTxt()
              .then(parseAndEncodeRfwTxt)
              .then((binary) => updateRuntime(runtime, binary)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RemoteWidget(
                runtime: runtime,
                data: data,
                widget: const FullyQualifiedWidgetName(LibraryName(['main']), 'root'),
                onEvent: (String name, DynamicMap arguments) {
                  // Handle events here
                  print('User triggered event "$name" with data: $arguments');
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> updateRuntime(Runtime runtime, Uint8List binary) async {
    // core.widgets kütüphanesini ekle
    runtime.update(const LibraryName(['core', 'widgets']), createCoreWidgets());

    // Uzak widget'ları güncelle
    final remoteWidgets = decodeLibraryBlob(binary);
    runtime.update(const LibraryName(['main']), remoteWidgets);
  }
}
