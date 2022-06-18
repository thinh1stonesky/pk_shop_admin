


import 'package:flutter/material.dart';

import '../../models/user.dart';

class ManageUsersDetail extends StatefulWidget {
  UserSnapshot userSnapshot;
  ManageUsersDetail({Key? key, required this.userSnapshot}) : super(key: key);

  @override
  State<ManageUsersDetail> createState() => _ManageUsersDetailState();
}

class _ManageUsersDetailState extends State<ManageUsersDetail> {
  bool? xem;
  UserSnapshot? userSnapshot;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userSnapshot = widget.userSnapshot;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Xem chi tiết'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    child: Image.network(userSnapshot!.user!.userImage!)
                ),
                const SizedBox(height: 5,),
                Text("Tên người dùng: " + userSnapshot!.user!.userName! + "\n"),

                userSnapshot!.user!.userPhone != null ?Text("Điện thoại: " + userSnapshot!.user!.userPhone!+ "\n")
                : const SizedBox(height: 0.1,),
                userSnapshot!.user!.userAddress != null?
                Column(
                  children: [
                    const Text("Địa chỉ:"),
                    Column(
                      children: userSnapshot!.user!.userAddress!.asMap().entries.map((e) =>
                          Text(
                              '${e.key}. ${e.value}'
                          )).toList(),
                    ),
                  ],
                ): SizedBox(height: 0.1,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        child: const Text('Đóng'),
                        onPressed: () async{
                          Navigator.of(context).pop();
                        }
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
}
