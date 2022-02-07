// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
//
// import '../ImageNew.dart';
// import '../backend/Outlet.dart';
//
// class OutletMergeScreen extends StatefulWidget {
//   final List<Outlet> outlets1;
//   final bool mergeTime;
//
//   OutletMergeScreen(this.outlets1, this.mergeTime);
//
//   @override
//   State<OutletMergeScreen> createState() => _OutletMergeScreenState();
// }
//
// class _OutletMergeScreenState extends State<OutletMergeScreen> {
//   List<Outlet> outlets = [];
//   List flexMap = [1, 4, 2, 2, 2, 2, 1, 1];
//   List<int> selected = [];
//   int? toBeMergedTo;
//   String stringid = "0";
//
//   String mergableID = "0";
//   String mergableName = "0";
//   String mergableLat = "0";
//   String mergableLng = "0";
//   String mergableImg = "0";
//   TextEditingController beatController = TextEditingController();
//   TextEditingController distributorController = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     outlets = widget.outlets1;
//   }
//
//   select(int index) {
//     setState(() {
//       if (!selected.contains(index)) {
//         selected.add(index);
//       } else {
//         selected.remove(index);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f2f2),
//       body: Expanded(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.arrow_back_rounded)),
//                 Expanded(
//                   child: Container(
//                     height: 60,
//                     child: const Center(child: Text("MERGE MULTIPLE OUTLETS")),
//                   ),
//                 ),
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: TextField(
//                     controller: beatController,
//                     decoration: InputDecoration(labelText: "Beat Name"),
//                   ),
//                 )),
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: TextField(
//                     controller: distributorController,
//                     decoration: InputDecoration(labelText: "Distributor Name"),
//                   ),
//                 )),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_rounded,
//                     color: Colors.transparent,
//                   ),
//                 ),
//               ],
//             ),
//             mergeTime
//                 ? Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               offset: Offset(0, 2),
//                               spreadRadius: 3,
//                               blurRadius: 3),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: flexMap[0],
//                             child: Center(
//                               child: Text(toBeMergedTo.toString()),
//                             ),
//                           ),
//                           Expanded(
//                             flex: flexMap[1],
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: DropdownButton(
//                                 onChanged: (input) {
//                                   setState(() {
//                                     mergableName = input.toString();
//                                   });
//                                 },
//                                 items: List.generate(selected.length,
//                                         (e) => outlets[selected[e]])
//                                     .map((e) => DropdownMenuItem(
//                                           child: Text(e.outletName.toString()),
//                                           value: e.id,
//                                         ))
//                                     .toList(),
//                                 value: mergableName,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: flexMap[2],
//                             child: Center(
//                               child: DropdownButton(
//                                 onChanged: (input) {
//                                   setState(() {
//                                     mergableLat = input.toString();
//                                     mergableLng = input.toString();
//                                     stringid = mergableLat;
//                                   });
//                                 },
//                                 items: List.generate(selected.length,
//                                         (e) => outlets[selected[e]])
//                                     .map((e) => DropdownMenuItem(
//                                           child: Text(e.lat.toString() +
//                                               ", " +
//                                               e.lng.toString()),
//                                           value: e.id,
//                                         ))
//                                     .toList(),
//                                 value: mergableLat,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: flexMap[5],
//                             child: Center(
//                               child: DropdownButton(
//                                 onChanged: (input) {
//                                   setState(() {
//                                     mergableImg = input.toString();
//                                   });
//                                 },
//                                 items: List.generate(selected.length,
//                                         (e) => outlets[selected[e]])
//                                     .map((e) => DropdownMenuItem(
//                                           child: Image.network(e.imageURL),
//                                           value: e.id,
//                                         ))
//                                     .toList(),
//                                 value: mergableImg,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : Container(),
//             SizedBox(
//               height: 12,
//             ),
//             Divider(
//               color: Colors.black,
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   flex: flexMap[0],
//                   child: Center(
//                     child: Text("ID"),
//                   ),
//                 ),
//                 Expanded(
//                   flex: flexMap[1],
//                   child: Center(
//                     child: Text("Name"),
//                   ),
//                 ),
//                 Expanded(
//                   flex: flexMap[2],
//                   child: Center(
//                     child: Text("Lat, Lng"),
//                   ),
//                 ),
//                 mergeTime
//                     ? Container()
//                     : Expanded(
//                         flex: flexMap[3],
//                         child: Center(
//                           child: Text("CSV Path"),
//                         ),
//                       ),
//                 mergeTime
//                     ? Container()
//                     : Expanded(
//                         flex: flexMap[4],
//                         child: Center(
//                           child: Text("Directory / Cloud"),
//                         ),
//                       ),
//                 Expanded(
//                   flex: flexMap[5],
//                   child: Center(
//                     child: Text("Image"),
//                   ),
//                 ),
//                 mergeTime
//                     ? Container()
//                     : Expanded(
//                         flex: flexMap[6],
//                         child: Center(
//                           child: Text("Selected"),
//                         ),
//                       ),
//                 mergeTime
//                     ? Container()
//                     : Expanded(
//                         flex: flexMap[7],
//                         child: Center(
//                           child: Text("Remove"),
//                         ),
//                       ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: outlets.length,
//                 itemBuilder: (context, int index) {
//                   TextEditingController controller =
//                       TextEditingController(text: outlets[index].outletName);
//                   return (!mergeTime || selected.contains(index))
//                       ? Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Container(
//                             height: 100,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     offset: Offset(0, 2),
//                                     spreadRadius: 3,
//                                     blurRadius: 3),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: flexMap[0],
//                                   child: Center(
//                                     child: Text(outlets[index].id.toString()),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: flexMap[1],
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: TextField(
//                                       controller: controller,
//                                       onChanged: (String? input) {
//                                         outlets[index].outletName =
//                                             input.toString();
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: flexMap[2],
//                                   child: Center(
//                                     child: Text(outlets[index].lat.toString() +
//                                         "," +
//                                         outlets[index].lng.toString()),
//                                   ),
//                                 ),
//                                 mergeTime
//                                     ? Container()
//                                     : Expanded(
//                                         flex: flexMap[3],
//                                         child: Center(
//                                           child: Text(
//                                             outlets[index].videoName ==null?"FA":"OWN",
//                                           ),
//                                         ),
//                                       ),
//                                 mergeTime
//                                     ? Container()
//                                     : Expanded(
//                                         flex: flexMap[4],
//                                         child: Center(
//                                           child: Text(outlets[index].videoName ==null?"FA":"OWN"),
//                                         ),
//                                       ),
//                                 Expanded(
//                                   flex: flexMap[5],
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(context,
//                                           MaterialPageRoute(builder: (_) {
//                                         return ImageNew(
//                                             outlets, index, selected, select);
//                                       }));
//                                     },
//                                     child: Image.network(outlets[index].imageURL),
//                                   ),
//                                 ),
//                                 mergeTime
//                                     ? Container()
//                                     : Expanded(
//                                         flex: flexMap[6],
//                                         child: Center(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(12.0),
//                                             child: !mergeTime
//                                                 ? GestureDetector(
//                                                     onTap: () {
//                                                       select(index);
//                                                     },
//                                                     child: Container(
//                                                       height: 100,
//                                                       width: 100,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: selected
//                                                                 .contains(index)
//                                                             ? Colors.red
//                                                             : Colors.green,
//                                                       ),
//                                                       child: Center(
//                                                         child: selected
//                                                                 .contains(index)
//                                                             ? Icon(
//                                                                 Icons.remove,
//                                                                 color:
//                                                                     Colors.white,
//                                                               )
//                                                             : Icon(
//                                                                 Icons.add,
//                                                                 color:
//                                                                     Colors.white,
//                                                               ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : selected.contains(index)
//                                                     ? GestureDetector(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             toBeMergedTo = index;
//                                                           });
//                                                         },
//                                                         child: Container(
//                                                           height: 100,
//                                                           width: 100,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                             color: selected
//                                                                     .contains(
//                                                                         index)
//                                                                 ? Colors.red
//                                                                 : Colors.green,
//                                                           ),
//                                                           child: Center(
//                                                             child: toBeMergedTo ==
//                                                                     index
//                                                                 ? Icon(
//                                                                     Icons
//                                                                         .merge_type,
//                                                                     color: Colors
//                                                                         .white,
//                                                                   )
//                                                                 : Container(),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     : Container(),
//                                           ),
//                                         ),
//                                       ),
//                                 mergeTime
//                                     ? Container()
//                                     : Expanded(
//                                         flex: flexMap[7],
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               outlets.removeAt(index);
//                                             });
//                                           },
//                                           child: Center(
//                                             child: Container(
//                                                 height: 50,
//                                                 width: 50,
//                                                 decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     border: Border.all(
//                                                         color: Colors.red)),
//                                                 child: Center(
//                                                     child: Icon(
//                                                   Icons.clear,
//                                                   color: Colors.red,
//                                                 ))),
//                                           ),
//                                         ),
//                                       ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container();
//                 },
//               ),
//             ),
//             mergeTime
//                 ? Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               mergeTime = false;
//                             });
//                           },
//                           child: Container(
//                             color: Colors.red,
//                             height: 60,
//                             child: Center(
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             if (toBeMergedTo != null) {
//                               print(toBeMergedTo);
//                               outlets
//                                       .firstWhere(
//                                           (element) => element.id == toBeMergedTo)
//                                       .outletName =
//                                   outlets
//                                       .firstWhere(
//                                           (element) => element.id == mergableName)
//                                       .outletName;
//                               outlets
//                                       .firstWhere(
//                                           (element) => element.id == toBeMergedTo)
//                                       .imageURL =
//                                   outlets
//                                       .firstWhere(
//                                           (element) => element.id == mergableImg)
//                                       .imageURL;
//                               List<String> ids = List.generate(selected.length,
//                                   (index) => outlets[selected[index]].id);
//                               ids.remove(stringid);
//                               for (String element in ids) {
//                                 outlets.removeWhere((a) => a.id == element);
//                               }
//                               selected = [];
//                               toBeMergedTo = null;
//                               setState(() {
//                                 mergeTime = false;
//                               });
//                             }
//                           },
//                           child: Container(
//                             color: toBeMergedTo == null
//                                 ? Colors.blueGrey
//                                 : Colors.green,
//                             height: 60,
//                             child: Center(
//                               child: Text(
//                                 "Confirm",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 : Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             if (selected.isNotEmpty) {
//                               setState(() {
//                                 mergableID = outlets[selected[0]].id;
//                                 mergableName = outlets[selected[0]].id;
//                                 mergableLat = outlets[selected[0]].id;
//                                 mergableLng = outlets[selected[0]].id;
//                                 mergableImg = outlets[selected[0]].id;
//                                 mergeTime = true;
//                               });
//                             }
//                           },
//                           child: Container(
//                             height: 60,
//                             color:
//                                 selected.isEmpty ? Colors.blueGrey : Colors.green,
//                             child: const Center(
//                               child: Text(
//                                 "MERGE",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () async {
//                             if (beatController.text != "" &&
//                                 distributorController.text != "") {
//                               String? directoryPath = await FilePicker.platform
//                                   .getDirectoryPath(
//                                       dialogTitle: "Where to store?");
//                               String contents =
//                                   "id,outletName,image path,latitude,longitude,csv path,image storage,beat,distributor\n";
//                               if (directoryPath != null) {
//                                 for (var element in outlets) {
//                                   contents += element.id.toString().trim() +
//                                       "," +
//                                       element.outletName.trim() +
//                                       "," +
//                                       element.imageURL.trim() +
//                                       "," +
//                                       element.lat.toString().trim() +
//                                       "," +
//                                       element.lng.toString().trim() +
//                                       "," +
//                                       beatController.text.trim() +
//                                       "," +
//                                       distributorController.text.trim() +
//                                       "\n";
//                                 }
//                                 File(directoryPath +
//                                         "\\${distributorController.text.trim()}_${beatController.text.trim()}.csv")
//                                     .writeAsString(contents)
//                                     .then((value) {
//                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                       content: Text(
//                                           "Saved at $directoryPath\\${distributorController.text.trim()}_${beatController.text.trim()}.csv")));
//                                 });
//                               }
//                             }
//                           },
//                           child: Container(
//                             height: 60,
//                             color: Colors.yellow,
//                             child: const Center(
//                               child: Text(
//                                 "EXPORT",
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
