import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class Directories {
  static Future<Directory> getKeystoreDir() {
    return getTemporaryDirectory();
  }
}
