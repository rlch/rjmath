import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import 'widgets/canvas.dart';

void main() {
  runApp(
    MaterialApp(
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      themeMode: ThemeMode.system,
      home: CanvasScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
