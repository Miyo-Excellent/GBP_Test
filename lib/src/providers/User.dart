import 'dart:convert';

import 'package:gbp_test/src/models/User.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _url = "api.github.com";

  Future<List<UserModel>> getUser() async {
    final url = Uri.https(_url, "users");

    final res = await http.get(url);
    final decodedData = json.decode(res.body);

    final users = UsersModel.fromJsonList(jsonList: decodedData);

    return users.items;
  }
}
