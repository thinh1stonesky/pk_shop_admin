

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pk_shop_admin/models/user.dart';

class ProductsOrder{
  String? ten, anh;
  int? id;
  dynamic? gia;
  dynamic soluong;
  ProductsOrder({
    this.id,
    required this.ten,
    required this.soluong,
    this.gia,
    this.anh,
  });

  factory ProductsOrder.fromJson(Map<String, dynamic> json){
    return ProductsOrder(
      id: json['id'],
      ten: json['ten'],
      soluong: json['soluong'],
      gia: json['gia'],
        anh: json['anh']

    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'ten' : ten,
      'gia' : gia,
      'soluong' : soluong,
      'anh' : anh
    };
  }
}

class CTDonHangSnapshot{
  ProductsOrder? productsOrder;
  DocumentReference? docRef;

  CTDonHangSnapshot({required this.productsOrder, required this.docRef});

  factory CTDonHangSnapshot.fromSnapshot(DocumentSnapshot docSnap){
    return CTDonHangSnapshot(
      productsOrder: ProductsOrder.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  Future<void> update(ProductsOrder productsOrder) async {
    return docRef!.update(productsOrder.toJson());
  }

  Future<void> delete() async {
    return docRef!.delete();
  }


  static Stream<List<CTDonHangSnapshot>> getAllProductsOrder({required User currentUser, required String orderid}){

    Stream<QuerySnapshot> qs = FirebaseFirestore.instance.collection('Order').doc(currentUser.userId).collection("ProductsOrder").doc(orderid).collection("ListProduct").snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qSnap) => qSnap.docs);
    return listDocSnap.map((lds) => lds.map((docSnap) => CTDonHangSnapshot.fromSnapshot(docSnap)).toList());
  }
}