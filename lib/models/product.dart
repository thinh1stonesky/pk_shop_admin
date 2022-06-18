
import 'package:cloud_firestore/cloud_firestore.dart';

class SanPham {
  String? ten, chitiet, anh;
  int? id;
  dynamic? gia;
  dynamic categoryId;
  SanPham({
    this.id,
    required this.ten,
    required this.categoryId,
    this.chitiet,
    this.gia,
    this.anh,
  }){
    // id = Random().nextInt(1000);
  }

  factory SanPham.fromJson(Map<String, dynamic> json){
    return SanPham(
        id: json['id'],
        categoryId: json['categoryId'],
        ten: json['ten'] as String,
        gia: json['gia'],
        chitiet: json['chitiet'] as String,
        anh: json['anh']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'ten' : ten,
      'gia' : gia,
      'chitiet' : chitiet,
      'categoryId' : categoryId,
      'anh' : anh
    };
  }
}

class SanPhamSnapshot{
  SanPham? sanPham;
  DocumentReference? docRef;

  SanPhamSnapshot({required this.sanPham, required this.docRef});

  factory SanPhamSnapshot.fromSnapshot(DocumentSnapshot docSnap){
    return SanPhamSnapshot(
      sanPham: SanPham.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  Future<void> update(SanPham sp) async {
    return docRef!.update(sp.toJson());
  }

  Future<void> delete() async {
    return docRef!.delete();
  }

  static Future<DocumentReference> addNew(SanPham sp) async {
    return FirebaseFirestore.instance.collection('SanPham').add(sp.toJson());
  }


  static Stream<List<SanPhamSnapshot>> getAllSanPham(){
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance.collection('SanPham').snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qSnap) => qSnap.docs);
    return listDocSnap.map((lds) => lds.map((docSnap) => SanPhamSnapshot.fromSnapshot(docSnap)).toList());
  }
}