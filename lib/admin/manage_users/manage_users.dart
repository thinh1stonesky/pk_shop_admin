

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pk_shop_admin/admin/manage_orders/manage_orders.dart';
import '../../models/user.dart';
import '../../themes.dart';
import 'manage_users_detail.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {



  @override
  Widget build(BuildContext context) {
    // ReviewCartProvider provider = Provider.of(context);
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: StreamBuilder<List<UserSnapshot>>(
        stream: UserSnapshot.getAllUser(),
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
              snapshot.data!.sort((a, b) => a.user!.userName!.compareTo(b.user!.userName!));
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    User? user = snapshot.data![index].user;
                    return Slidable(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(user!.userImage!),
                        ),
                        title: Text(user.userName!),
                        subtitle: Text(user.userEmail!),
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                              backgroundColor: secondaryColor,
                              icon: Icons.description,
                              foregroundColor: Colors.yellow,
                              onPressed: (context) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return ManageUsersDetail(
                                          userSnapshot: snapshot.data![index]);
                                    }));
                              }
                          ),
                          SlidableAction(
                              backgroundColor: secondaryColor,
                              icon: Icons.add_chart,
                              foregroundColor: Colors.yellow,
                              onPressed: (context) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return ManageOrders(currentUser: user,);
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
