import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String? uid;
  final String? email;
  final String? photoUrl;
  final String? username;
  final String? bio;
  final List? followers;
  final List? following;

  const UserDataModel({
    this.uid,
    this.email,
    this.photoUrl,
    this.username,
    this.bio,
    this.followers,
    this.following
  });

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'photoUrl' : photoUrl,
    'username' : username,
    'bio' : bio,
    'followers' : [],
    'following' : [],
  };

  static UserDataModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserDataModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  List<UserDataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as Map<
          String,
          dynamic>;

      return UserDataModel(
          uid: dataMap['uid'],
          email: dataMap['email'],
          photoUrl: dataMap['photoUrl'],
          username: dataMap['username'],
          bio: dataMap['bio'],
          followers: dataMap['followers'],
          following: dataMap['following']);
    }).toList();
  }
}