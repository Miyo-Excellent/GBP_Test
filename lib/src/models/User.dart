class UsersModel {
  List<UserModel> items = new List();

  UsersModel();

  UsersModel.fromJsonList({List<dynamic> jsonList}) {
    if (jsonList == null) return;

    for (final item in jsonList) {
      final user = UserModel.fromJsonMap(json: item);

      items.add(user);
    }
  }
}

class UserModel {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  bool siteAdmin;

  UserModel(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.gravatarId,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.siteAdmin});

  UserModel.fromJsonMap({Map<String, dynamic> json}) {
    this.login = json["login"];
    this.id = json["id"];
    this.nodeId = json["node_id"];
    this.avatarUrl = json["avatar_url"];
    this.gravatarId = json["gravatarId"];
    this.url = json["url"];
    this.htmlUrl = json["html_url"];
    this.followersUrl = json["followers_url"];
    this.followingUrl = json["following_url"];
    this.gistsUrl = json["gists_url"];
    this.starredUrl = json["starred_url"];
    this.subscriptionsUrl = json["subscriptions_url"];
    this.organizationsUrl = json["organizations_url"];
    this.reposUrl = json["repos_url"];
    this.eventsUrl = json["events_url"];
    this.receivedEventsUrl = json["receivedEvents_url"];
    this.type = json["type"];
    this.siteAdmin = json["site_admin"];
  }

  Map<String, dynamic> toMap() => {
    "login": this.login,
    "id": this.id,
    "node_id": this.nodeId,
    "avatar_irl": this.avatarUrl,
    "gravatar_id": this.gravatarId,
    "url": this.url,
    "html_url": this.htmlUrl,
    "followers_url": this.followersUrl,
    "following_url": this.followingUrl,
    "gists_url": this.gistsUrl,
    "starred_url": this.starredUrl,
    "subscriptions_url": this.subscriptionsUrl,
    "organizations_url": this.organizationsUrl,
    "repos_url": this.reposUrl,
    "events_url": this.eventsUrl,
    "received_events_url": this.receivedEventsUrl,
    "type": this.type,
    "site_admin": this.siteAdmin,
  };
}
