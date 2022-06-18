

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/dialog.dart';
import '../../models/category.dart';
import '../../provider/sanpham_provider.dart';

class ManageCategoriesDetail extends StatefulWidget {
  bool? xem;
  CategorySnapshot? categorySnapshot;
  ManageCategoriesDetail({Key? key, this.xem, this.categorySnapshot}) : super(key: key);

  @override
  State<ManageCategoriesDetail> createState() => _ManageCategoriesDetailState();
}

class _ManageCategoriesDetailState extends State<ManageCategoriesDetail> {
  bool? xem;
  CategorySnapshot? categorySnapshot;

  String label = "Thêm loại hàng";
  String buttonLabel = "Thêm";

  late int newId;

  String? currentCategory;
  String? dropdownValue;

  TextEditingController idCtrl = TextEditingController();
  TextEditingController contentCtrl = TextEditingController();

  SanPhamProvider? provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SanPhamProvider sanPhamProvider = Provider.of(context, listen: false);
    sanPhamProvider.fetchCategoryData();

    xem = widget.xem;
    categorySnapshot = widget.categorySnapshot;
    if(categorySnapshot != null) {
      idCtrl.text = '${categorySnapshot!.category!.id}';
      contentCtrl.text = categorySnapshot!.category!.content;
      if(xem! == false){
        label = "Cập nhật sản phẩm ${categorySnapshot!.category!.content}";
        buttonLabel = "Cập nhật";
      }
      else{
        label = "Thông tin sản phẩm ${categorySnapshot!.category!.content}";
        buttonLabel = "Đóng";
      }
    }
  }

  int createId(List<Category> listCategory){
    List<Map<String, dynamic>> list = listCategory.map((element)=> element.toJson()).toList();
    list.sort((Map u1, Map u2) => u2['id'] - u1['id']);
    return list.first['id'] +1;
  }

  @override
  Widget build(BuildContext context) {

    SanPhamProvider provider = Provider.of(context);
    List<Category> listCategory = provider.getListCategory;

    newId = createId(listCategory);
    if(categorySnapshot == null){
      idCtrl.text = '$newId';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(label),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5,),
                xem == true? Text("Id: " + categorySnapshot!.category!.id.toString() + "\n"):
                TextField(
                  enabled: false,
                  controller: idCtrl,
                  decoration: const InputDecoration(
                    label: Text("Id"),
                  ),
                  keyboardType: TextInputType.text,

                ),
                xem == true? Text("Loại hàng: " + categorySnapshot!.category!.content.toString()+ "\n"):
                TextField(
                  enabled: xem == true ? false : true,
                  controller: contentCtrl,
                  decoration: const InputDecoration(label: Text("Loại hàng")),
                  keyboardType: TextInputType.text,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text(buttonLabel),
                      onPressed: () async{
                        if(xem == true){
                          Navigator.of(context).pop();
                        }
                        else{
                          _capNhat(context, listCategory, dropdownValue);
                        }
                      },
                    ),
                    const SizedBox(width: 10,),
                    xem != false ?
                    const SizedBox(width: 1,)
                        : ElevatedButton(onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Đóng")),
                    const SizedBox(width: 10,)
                  ],
                )
              ],
            ),
          ),
        )
    );
  }


  _capNhat(BuildContext context, List<Category> loaiSps, String? dropdownValue) async {
    showSnackBar(context, "Đang cập nhật dữ liệu...", 300);
    Category category = Category(
      id: int.tryParse(idCtrl.text)!,
      content: contentCtrl.text,
    );
    if(categorySnapshot != null){
      _capNhatSP(categorySnapshot!, category);
    }else{
      _themSP(category);
    }

  }

  _capNhatSP(CategorySnapshot? categorySnapshot, Category category) async {
    categorySnapshot!.update(category).whenComplete(() =>
        showSnackBar(context, "Cập nhật thành công", 3)).onError((error, stackTrace) =>
        showSnackBar(context, "Cập nhật không thành công", 3));
  }

  _themSP(Category category) async{
    CategorySnapshot.addNew(category).whenComplete(() =>
        showSnackBar(context, "Thêm thành công", 3))
        .onError((error, stackTrace) {
      showSnackBar(context, "Thêm không thành công", 3);
      return Future.error("Lỗi khi thêm");
    });
  }
}
