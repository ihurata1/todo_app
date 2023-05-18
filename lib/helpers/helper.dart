import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root/db/db_helper.dart';
import 'package:root/helpers/notification.dart';

class AppHelper {
  static initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    NotifyHelper().initializeNotification();
    await DBHelper.initDb();
    await GetStorage.init();
  }
}
