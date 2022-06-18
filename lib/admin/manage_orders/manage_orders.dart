

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pk_shop_admin/models/your_order.dart';

import '../../models/user.dart';
import 'manage_orders_detail.dart';

class ManageOrders extends StatefulWidget {
  User? currentUser;
  ManageOrders({Key? key, this.currentUser}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  User? currentUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.currentUser;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: StreamBuilder<List<DonHangSnapshot>>(
        stream: DonHangSnapshot.getAllOrder(currentUser: currentUser!),
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
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    YourOrder? order = snapshot.data![index].order;
                    return snapshot.data!.isEmpty ||snapshot.data!.length == 0 ?
                    Center(child: const Text("Chưa có đơn hàng"),)
                        :Slidable(
                      child: ListTile(
                        leading: Text(order!.orderid!),
                        title: Text('${order.soluong} sản phẩm'),
                        subtitle: Column(
                          children: [
                            Text('${order.tongtien} đ'),
                            Text('${order.diachi}')
                          ],
                        ),
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
                                      return ManageOrdersDetail(currentUser: currentUser, orderid: order.orderid,);
                                    }));
                              }
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
