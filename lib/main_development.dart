import 'package:benaiah_mobile_app/app/app.dart';
import 'package:benaiah_mobile_app/bootstrap.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  bootstrap(() => DevicePreview(enabled: kIsWeb, builder: (_) => const App()));
}
