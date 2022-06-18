

import 'package:flutter/material.dart';

import '../../models/products_order.dart';
import '../../models/user.dart';

class ManageOrdersDetail extends StatefulWidget {
  User? currentUser;
  String? orderid;
  ManageOrdersDetail({Key? key, this.orderid, this.currentUser}) : super(key: key);

  @override
  State<ManageOrdersDetail> createState() => _ManageOrdersDetailState();
}

class _ManageOrdersDetailState extends State<ManageOrdersDetail> {
  User? currentUser;
  String? orderid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.currentUser;
    orderid = widget.orderid;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: StreamBuilder<List<CTDonHangSnapshot>>(
        stream: CTDonHangSnapshot.getAllProductsOrder(currentUser: currentUser!, orderid: orderid!),
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
                    ProductsOrder? productsOrder = snapshot.data![index].productsOrder;
                    return Container(
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                child: Image.network(productsOrder!.anh!),
                              )
                          ),
                          Expanded(
                              child: Container(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(productsOrder.ten!.length > 30 ? productsOrder.ten!.substring(0,30) +"..." : productsOrder.ten!,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(height: 5,),
                                        RichText(
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                            text: TextSpan(
                                                text: productsOrder.gia!.toString(),
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black54,
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.white,
                                                          offset: Offset(1,1),
                                                          blurRadius: 3
                                                      )
                                                    ]
                                                ),
                                                children: const [
                                                  TextSpan(
                                                      text: "VNĐ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10
                                                      )
                                                  )
                                                ]
                                            )
                                        ),
                                        Text('Số lượng: ${productsOrder.soluong}'),

                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
          }
        },
      ),
    );
  }
}
