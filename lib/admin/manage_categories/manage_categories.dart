



import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


import '../../helpers/dialog.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../provider/sanpham_provider.dart';
import 'manage_categories_detail.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({Key? key}) : super(key: key);

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}
class _ManageCategoriesState extends State<ManageCategories> {
  BuildContext? _dialogContext;

  SanPhamProvider? sanPhamProvider;
  List<SanPham>? listSp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SanPhamProvider sanPhamProvider = Provider.of(context, listen: false);
    sanPhamProvider.fetchProductData();

  }

  @override
  Widget build(BuildContext context) {
    sanPhamProvider = Provider.of(context);
    listSp = sanPhamProvider?.getListSanPham;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ManageCategoriesDetail(xem: false,),)
            );
          },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: StreamBuilder<List<CategorySnapshot>>(
        stream: CategorySnapshot.getAllLoaiHang(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
            return const Center(
              child: Text('Lỗi'),
            );
          }else{
            if(!snapshot.hasData){
              print(snapshot.error);
              return const Center(child: Text('Đang tải dữ liệu...'),) ;
            }else{
              snapshot.data!.sort((a, b) => a.category!.id.compareTo(b.category!.id));
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Category? category = snapshot.data![index].category;
                    _dialogContext = context;
                    return Slidable(
                      child: ListTile(
                        leading: Text(category!.id.toString()),
                        title: Text(category.content),
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                              icon: Icons.description,
                              foregroundColor: Colors.yellow,
                              onPressed: (context) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return ManageCategoriesDetail(xem: true,
                                          categorySnapshot: snapshot.data![index]);
                                    }));
                              }
                          ),
                          SlidableAction(
                              icon: Icons.edit,
                              foregroundColor: Colors.blue,
                              onPressed: (context){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        ManageCategoriesDetail(xem: false, categorySnapshot: snapshot.data![index]))
                                );
                              }
                          ),
                          SlidableAction(
                              icon: Icons.delete_forever,
                              foregroundColor: Colors.red,
                              onPressed:(context)=> _xoa(_dialogContext!, snapshot.data![index], listSp!)
                          ),
                        ],
                      ),
                    );}
              );
            }
          }
        },
      ),
    );
  }



}

void _xoa(BuildContext context, CategorySnapshot categorySnapshots, List<SanPham> listSp) async {
  String? confirm;
  if(checkDelete(context, categorySnapshots, listSp)){
    showSnackBar(context, "Tồn tại sản phẩm thuộc loại hàng này", 3);
  }else{
    confirm = await showConfirmDialog(context, "Bạn muốn xóa ${categorySnapshots.category!.content} ư");
    if(confirm == "ok"){
      categorySnapshots.delete().whenComplete(() => showSnackBar(context, "Xóa thành công", 3))
          .onError((error, stackTrace) {
        showSnackBar(context, "Xóa không thành công", 3);
        return Future.error("Xóa dữ liệu không thành công");
      });

    }
  }

}

bool checkDelete(BuildContext context, CategorySnapshot categorySnapshot, List<SanPham> listSanPham) {
  SanPhamProvider sanPhamProvider = Provider.of(context, listen: false);
  sanPhamProvider.fetchProductData();
  // List<SanPham> listSanPham = sanPhamProvider.getListSanPham;
  List listCategoryId = listSanPham.map((e) => e.categoryId).toList();
  if(listCategoryId.contains(categorySnapshot.category?.id)){
    return true;
  }else{
    return false;
  }
}
