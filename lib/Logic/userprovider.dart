import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';


final userprovider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier();
});

class UserNotifier extends ChangeNotifier {
  String _username = '';
  String _loggedIn = 'false';

  String get username => _username;
  String get loggedIn => _loggedIn;

  Future<void> initialize() async {
    _username = await UserSecureStorage.getUsername() ?? '';
    final loggedInValue = await UserSecureStorage.getLoggedIn();
    _loggedIn = loggedInValue;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    UserSecureStorage.setUsername(username);
    notifyListeners();
  }

  void setLoggedIn(String loggedIn) {
    _loggedIn = loggedIn;
    UserSecureStorage.setLoggedIn(loggedIn.toString());
    notifyListeners();
  }
}