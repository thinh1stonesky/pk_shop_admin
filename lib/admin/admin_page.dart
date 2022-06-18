
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pk_shop_admin/admin/manage_orders/manage_orders.dart';


import '../SignIn.dart';
import 'manage_categories/manage_categories.dart';
import 'manage_products/manage_products.dart';
import 'manage_users/manage_users.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<int> getDocuments(String collection) async{
      QuerySnapshot value = await FirebaseFirestore.instance.collection(collection).get();
      return await value.docs.length;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Spacer(),
              Text('My firebase app'),
              ElevatedButton(onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn(),), (route) => false);
              },
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      Text('Sign out')
                    ],
                  )),
              Spacer(),Spacer(),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ManageUsers(),));
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.red[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Quản lý đặt hàng"),),
                        FutureBuilder<int>(
                          future: getDocuments("User"),
                          builder: (context, snapshot) => Center(child: Text(snapshot.data!.toString() + " user"),),)
                      ],
                    ),
                  ),
                )),
            const Divider(height: 10,),
            Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ManageProducts(),)
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Quản lý sản phẩm"),),
                        FutureBuilder<int>(
                          future: getDocuments("SanPham"),
                          builder: (context, snapshot) => Center(child: Text(snapshot.data!.toString() + " sản phẩm"),),)
                      ],
                    ),
                  ),

                )
            ),
            const Divider(height: 10,),
            Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ManageCategories()));
                  },
                  child: Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Quản lý loại sản phẩm"),),
                        FutureBuilder<int>(
                          future: getDocuments("Category").timeout(Duration(seconds: 2)),
                          builder: (context, snapshot) => Center(child: Text(snapshot.data!.toString() + " loại sản phẩm"),),)
                      ],
                    ),
                  ),
                )),

          ],
        ),
      ),
    );
  }
}

