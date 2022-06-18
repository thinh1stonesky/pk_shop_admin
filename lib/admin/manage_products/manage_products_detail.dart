

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../helpers/dialog.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../provider/sanpham_provider.dart';

class ManageProductsDetail extends StatefulWidget {

  bool? xem;
  SanPhamSnapshot? spSnapshot;
  ManageProductsDetail({Key? key,required this.xem, this.spSnapshot}) : super(key: key);

  @override
  State<ManageProductsDetail> createState() => _ManageProductsDetailState();
}

class _ManageProductsDetailState extends State<ManageProductsDetail> {

  bool? xem;
  SanPhamSnapshot? spSnapshot;

  bool _imageChange = false;
  XFile? _xImage; // lưu thông tin đường dẫn ảnh

  String label = "Thêm sản phẩm ";
  String buttonLabel = "Thêm";

  late int newId;

  String? currentCategory;
  String? dropdownValue;

  TextEditingController idCtrl = TextEditingController();
  TextEditingController tenCtrl = TextEditingController();
  TextEditingController chitietCtrl = TextEditingController();
  TextEditingController anhCtr = TextEditingController();
  TextEditingController giaCtr = TextEditingController();

  SanPhamProvider? provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SanPhamProvider sanPhamProvider = Provider.of(context, listen: false);
    sanPhamProvider.fetchCategoryData();
    sanPhamProvider.fetchProductData();

    xem = widget.xem;
    spSnapshot = widget.spSnapshot;
    if(spSnapshot != null) {
      idCtrl.text = '${spSnapshot!.sanPham!.id}';
      tenCtrl.text = spSnapshot!.sanPham!.ten ?? "";
      chitietCtrl.text = spSnapshot!.sanPham!.chitiet ?? "";
      anhCtr.text = spSnapshot!.sanPham!.anh ?? "";
      giaCtr.text = spSnapshot!.sanPham!.gia.toString();
      // dropdownValue = spSnapshot!.sanPham.categoryId
      if(xem! == false){
        label = "Cập nhật sản phẩm ${spSnapshot!.sanPham!.ten}";
        buttonLabel = "Cập nhật";
      }
      else{
        label = "Thông tin sản phẩm ${spSnapshot!.sanPham!.ten}";
        buttonLabel = "Đóng";
      }
    }
  }

  int createId(List<SanPham> listSp){
    List<Map<String, dynamic>> list = listSp.map((element)=> element.toJson()).toList();
    list.sort((Map u1, Map u2) => u2['id'] - u1['id']);
    return list.first['id'] +1;
  }

  @override
  Widget build(BuildContext context) {

    SanPhamProvider provider = Provider.of(context);
    List<Category> listCategory = provider.getListCategory;
    List<SanPham> listSanPham = provider.getListSanPham;

    newId = createId(listSanPham);
    print(newId);
    if(spSnapshot != null){
      currentCategory = listCategory.where((element) => element.id == spSnapshot?.sanPham?.categoryId).toList().first.content.toString();
      dropdownValue = currentCategory;
    }



    if(spSnapshot == null){
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
              children: [
                SizedBox(
                    height: 200,
                    child: _imageChange ?
                    Image.file(File(_xImage!.path))
                        : spSnapshot?.sanPham!.anh != null ?
                    Image.network(spSnapshot!.sanPham!.anh!)
                        : null
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: xem != true?()=>
                        _chonAnh(context)
                        : null,
                        child: const Icon(Icons.image))
                  ],
                ),
                xem == true? Text("id: " + spSnapshot!.sanPham!.id!.toString() + "\n"):
                TextField(
                  enabled: false,
                  controller: idCtrl,
                  decoration: const InputDecoration(
                    label: Text("Id"),
                  ),
                  keyboardType: TextInputType.text,

                ),
                xem == true? Text("Tên: " + spSnapshot!.sanPham!.ten!.toString()+ "\n"):
                TextField(
                  enabled: xem == true ? false : true,
                  controller: tenCtrl,
                  decoration: const InputDecoration(label: Text("Tên")),
                  keyboardType: TextInputType.text,
                ),
                xem == true? Text("Chi tiết: " + spSnapshot!.sanPham!.chitiet!.toString()+ "\n"):
                TextField(
                  enabled: xem == true ? false : true,
                  controller: chitietCtrl,
                  decoration: const InputDecoration(label: Text("Chi tiết")),
                  keyboardType: TextInputType.text,
                ),
                xem == true? Text("Giá: " + spSnapshot!.sanPham!.gia!.toString()+ "\n"):
                TextField(
                  enabled: xem == true ? false : true,
                  controller: giaCtr,
                  decoration: const InputDecoration(label: Text("Giá")),
                  keyboardType: TextInputType.text,
                ),
                xem == true? Text("Loại: " + currentCategory!):
                DropdownButtonFormField<String>(
                  items: listCategory.map((loaimh) => DropdownMenuItem<String>(
                    child:  Text(loaimh.content),
                    value: loaimh.content,

                  )).toList(),
                  onChanged: (value) =>
                  dropdownValue = value,
                  value: dropdownValue,
                  decoration: const InputDecoration(
                      labelText:  "Loại hàng",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)
                          )
                      )
                  ),


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

  _chonAnh(BuildContext context) async {
    _xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(_xImage != null){
      setState(() {
        _imageChange = true;
      });
    }
  }

  _capNhat(BuildContext context, List<Category> loaiSps, String? dropdownValue) async {
    showSnackBar(context, "Đang cập nhật dữ liệu...", 300);
    SanPham sp = SanPham(
        id: int.tryParse(idCtrl.text),
        ten: tenCtrl.text,
        chitiet: chitietCtrl.text,
        categoryId: loaiSps.where((element) => element.content == dropdownValue).toList().first.id,
        gia: int.tryParse(giaCtr.text),
        anh: null
    );
    if(_imageChange == true){
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference reference = _storage.ref().child("images").child("SanPham").child("anhsp_${sp.id}.jpg");

      UploadTask uploadTask = await _uploadTask2(reference, _xImage!);
      uploadTask.whenComplete(() async{
        sp.anh = await reference.getDownloadURL();
        if(spSnapshot != null){
          _capNhatSP(spSnapshot!, sp);
        }
        else{
          _themSP(sp);
        }
      }).onError((error, stackTrace) => Future.error("Có lỗi xảy ra!"));
    }else{
      if(spSnapshot != null){
        sp.anh = spSnapshot!.sanPham!.anh;
        _capNhatSP(spSnapshot!, sp);
      }else{
        sp.anh = "";
        _themSP(sp);
      }
    }
  }

  // Future<UploadTask> _uploadTask(Reference reference, XFile xImage) async {
  //   final metadata = SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {'picked-file-path': xImage.path});
  //   UploadTask uploadTask;
  //   uploadTask = reference.putFile(File(xImage.path), metadata);
  //   return Future.value(uploadTask);
  // }
  Future<UploadTask> _uploadTask2(Reference reference, XFile xImage) async {
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path' : xImage.path});
    UploadTask uploadTask;
    uploadTask = reference.putFile(File(xImage.path), metadata);
    return Future.value(uploadTask);
  }

  _capNhatSP(SanPhamSnapshot? svSnapshot, SanPham sp) async {
    svSnapshot!.update(sp).whenComplete(() =>
        showSnackBar(context, "Cập nhật thành công", 3)).onError((error, stackTrace) =>
        showSnackBar(context, "Cập nhật không thành công", 3));
  }

  _themSP(SanPham sp) async{
    SanPhamSnapshot.addNew(sp).whenComplete(() =>
        showSnackBar(context, "Thêm thành công", 3))
        .onError((error, stackTrace) {
      showSnackBar(context, "Thêm không thành công", 3);
      return Future.error("Lỗi khi thêm");
    });
  }
}
