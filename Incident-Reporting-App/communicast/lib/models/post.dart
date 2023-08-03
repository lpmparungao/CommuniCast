import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String location;
  final double latitude;
  final double longitude;
  final String indicator;
  final bool notificationSent;

  const Post({
    required this.title,
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.indicator,
    required this.notificationSent,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        title: snapshot["title"],
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        location: snapshot['location'],
        latitude: snapshot['latitude'],
        longitude: snapshot['longitude'],
        indicator: snapshot['indicator'],
        notificationSent: snapshot['notificationSent']);
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'indicator': indicator,
        'notificationSent': notificationSent,
      };
}
