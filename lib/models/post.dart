import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String description;
  final String postId;
  final String username;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({
    required this.uid,
    required this.description,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'description' : description,
    'postId' : postId,
    'username' : username,
    'datePublished' : datePublished,
    'postUrl' : postUrl,
    'profImage' : profImage,
    'likes' : likes
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes']
    );
  }
}