

import '../../models/user.dart';

User getCurrentUser(String id, List<User> listUser){
  return listUser.where((element) => element.userId == id).toList().first;
}

ValidateString(String? value) {
  return value == null || value.isEmpty ? "Bạn chưa nhập dữ liệu": null;
}

ValidateSoluong(String? value) {
  if(value == null || value.isEmpty)
    return "Bạn chưa nhập dữ liệu";
  else
    return int.parse(value)< 0 ? "Số lượng không bé hơn 0": null;
}

// num tongTienGioHang(List<ReviewCart>? listCart){
//   num sum = 0;
//   listCart?.forEach((cart)=> sum += cart.gia * cart.soluong);
//
//   return sum;
// }
//
// num tongSoLuongGioHang(List<ReviewCart>? listCart){
//   num sum = 0;
//   listCart?.forEach((cart)=> sum += cart.soluong);
//
//   return sum;
// }