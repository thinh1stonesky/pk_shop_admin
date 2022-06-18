



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pk_shop_admin/models/user.dart';

class YourOrder{
  String? diachi, orderid;
  num? tongtien;
  num? soluong;
  YourOrder({
    this.diachi,
    this.tongtien,
    this.soluong,
    this.orderid
  });

  factory YourOrder.fromJson(Map<String, dynamic> json){
    return YourOrder(
        diachi: json['diachi'],
        tongtien: json['tongtien'],
        soluong: json['soluong'],
        orderid: json['orderid'],

    );
  }

  Map<String, dynamic> toJson(){
    return {
      'orderid' : orderid,
      'diachi' : diachi,
      'tongtien' : tongtien,
      'soluong' : soluong,
    };
  }
}

class DonHangSnapshot{
  YourOrder? order;
  DocumentReference? docRef;

  DonHangSnapshot({required this.order, required this.docRef});

  factory DonHangSnapshot.fromSnapshot(DocumentSnapshot docSnap){
    return DonHangSnapshot(
      order: YourOrder.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  Future<void> update(YourOrder order) async {
    return docRef!.update(order.toJson());
  }

  Future<void> delete() async {
    return docRef!.delete();
  }


  static Stream<List<DonHangSnapshot>> getAllOrder({required User currentUser}){

    Stream<QuerySnapshot> qs = FirebaseFirestore.instance.collection('Order').doc(currentUser.userId).collection("YourOrder").snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qSnap) => qSnap.docs);
    return listDocSnap.map((lds) => lds.map((docSnap) => DonHangSnapshot.fromSnapshot(docSnap)).toList());
  }
}