


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';


class SanPhamProvider extends ChangeNotifier{

  List<SanPham> _listSp = [];
  List<Category> _listCategory = [];
  SanPham? sp;
  Category? category;

  List<SanPham> get getListSanPham{
    return _listSp;
  }

  List<Category> get getListCategory{
    return _listCategory;
  }

  fetchProductData() async{
    List<SanPham> newListSp = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("SanPham").get();
    value.docs.forEach((element) {
      sp = SanPham(
          ten : element.get("ten") as String,
          chitiet : element.get("chitiet")as String,
          anh : element.get("anh")as String,
          gia: element.get("gia").runtimeType == int ? element.get("gia"): int.parse(element.get("gia")),
          id: element.get("id").runtimeType == int ? element.get("id"): int.parse(element.get("id")),
          categoryId: element.get("categoryId").runtimeType == int ? element.get("categoryId"): int.parse(element.get("categoryId")
          ));
      newListSp.add(sp!);
    });
    _listSp = newListSp;
    notifyListeners();
  }

  fetchCategoryData() async{
    List<Category> newListCategory = [];
    QuerySnapshot value = await FirebaseFirestore.instance.collection("Category").get();
    value.docs.forEach((element) {
      category = Category(
        id : element.get("id").runtimeType == int ? element.get("id"): int.parse(element.get("id")),
        content : element.get("content")as String,
      );
      newListCategory.add(category!);
    });
    _listCategory = newListCategory;
    notifyListeners();
  }
}