// import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
//
// class BeatService{
//
//   Future<Beat> createBeat(
//       List<Beat> beat) async {
//     Response res = await http.get(
//       Uri.parse("$localhost/outlet"),
//       // body: <String, String>{
//       //   'lat': lat.toString(),
//       //   'lng': lng.toString(),
//       //   'distance': distance.toString(),
//       // },
//     );
//     if (res.statusCode == 200) {
//       List<dynamic> a = jsonDecode(res.body);
//       List<Outlet> outlets = a.map((e) => Outlet.fromJson(e)).toList();
//       print(outlets.length);
//       return outlets;
//     }
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text("UNABLE TO CONNECT"),
//     ));
//     print("UNABLE");
//     return [];
//   }
// }