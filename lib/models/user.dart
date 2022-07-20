import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
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

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  List<User> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

      return User(
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