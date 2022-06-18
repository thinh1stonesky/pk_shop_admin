





import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? userName, userImage, userEmail, userId, userPhone;
  List<dynamic>? userAddress;
  User({
    this.userId,
    this.userName,
    this.userEmail,
    this.userImage,
    this.userPhone,
    this.userAddress
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userImage: json['userImage'] as String,
      userPhone: json['userPhone'],
      userAddress: json['userAddress'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'userId' : userId,
      'userName' : userName,
      'userEmail' : userEmail,
      'userImage' : userImage,
      'userPhone' : userPhone,
      'userAddress' : userAddress
    };
  }
}

class UserSnapshot{
  User? user;
  DocumentReference? docRef;
  UserSnapshot({required this.user, required this.docRef});

  factory UserSnapshot.fromSnapshot(DocumentSnapshot docSnap){
    return UserSnapshot(
      user: User.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  Future<void> update(User user) async {
    return docRef!.update(user.toJson());
  }

  Future<void> delete() async {
    return docRef!.delete();
  }

  static Future<DocumentReference> addNew(User user) async {
    return FirebaseFirestore.instance.collection('Category').add(user.toJson());
  }


  static Stream<List<UserSnapshot>> getAllUser(){
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance.collection('User').snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qSnap) => qSnap.docs);
    return listDocSnap.map((lds) => lds.map((docSnap) => UserSnapshot.fromSnapshot(docSnap)).toList());
  }
}