import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbp_test/src/models/User.dart';
import 'package:gbp_test/src/providers/User.dart';

class Home extends StatelessWidget {
  final UserProvider userProvider = UserProvider();

  final List<Map> users = <Map>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          size: 35.0,
        ),
        title: _appBarTitle(title: "Prueba GBP"),
        centerTitle: true,
      ),
      body: Container(
        child: _list(context: context),
      ),
    );
  }

  Widget _appBarTitle({String title}) => Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
      );

  Widget _list({BuildContext context}) {
    return FutureBuilder(
        //  initialData: [],
        future: userProvider.getUser(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List<Widget> _users = [];

            for (final UserModel user in snapshot.data) {
              _users
                ..add(_listItem(context: context, user: user))
                ..add(Divider());
            }

            return ListView(children: _users);
          }

          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _listItem({BuildContext context, UserModel user}) => ListTile(
        onTap: () {
          Navigator.pushNamed(context, "user", arguments: user);
        },
        leading: ClipRRect(
          child: Image.network(user.avatarUrl),
          borderRadius: BorderRadius.circular(100.0),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user.login,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              user.reposUrl,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                color: Colors.black12,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        contentPadding: EdgeInsets.all(10.0),
      );
}
