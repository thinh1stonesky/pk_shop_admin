

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../../helpers/dialog.dart';
import '../../models/product.dart';
import 'manage_products_detail.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  BuildContext? _dialogContext;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ManageProductsDetail(xem: false,),)
            );
          },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: StreamBuilder<List<SanPhamSnapshot>>(
        stream: SanPhamSnapshot.getAllSanPham(),
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
              snapshot.data!.sort((a, b) => a.sanPham!.id!.compareTo(b.sanPham!.id!));
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    SanPham? sp = snapshot.data![index].sanPham;
                    _dialogContext = context;
                    return Slidable(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(sp!.anh!),
                        ),
                        title: Text('${sp.ten}'),
                        subtitle: Text('${sp.gia}'),
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
                                      return ManageProductsDetail(xem: true,
                                          spSnapshot: snapshot.data![index]);
                                    }));
                              }
                          ),
                          SlidableAction(
                              icon: Icons.edit,
                              foregroundColor: Colors.blue,
                              onPressed: (context){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        ManageProductsDetail(xem: false, spSnapshot: snapshot.data![index]))
                                );
                              }
                          ),
                          SlidableAction(
                              icon: Icons.delete_forever,
                              foregroundColor: Colors.red,
                              onPressed:(context)=> _xoa(_dialogContext!, snapshot.data![index])
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

void _xoa(BuildContext context, SanPhamSnapshot sps) async {
  String? confirm;
  confirm = await showConfirmDialog(context, "Bạn muốn xóa ${sps.sanPham!.ten} ư");
  if(confirm == "ok"){
    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference reference = _storage.ref().child("images").child("anh_${sps.sanPham!.id}.jpg");
    reference.delete();
    sps.delete().whenComplete(() => showSnackBar(context, "Xóa thành công", 3))
        .onError((error, stackTrace) {
      showSnackBar(context, "Xóa không thành công", 3);
      return Future.error("Xóa dữ liệu không thành công");
    });

  }
}

