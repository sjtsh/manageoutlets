import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/MergeMap.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';

import 'Entity/OutletsListEntity.dart';
import 'MergingScreen.dart';
import 'backend/Entities/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;
  final Function refresh;
  final Function updateBeat;

  const NextScreen(this.beat,
      this.categories,
      this.refresh,
      this.updateBeat,);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

Category selectedCategories = Category("Select category", 10000000);

void _changeDropDownValue(Category newValue) {
  selectedCategories = newValue;
}

class _NextScreenState extends State<NextScreen> {
  Beat? tempBeat;

  TextEditingController textController = TextEditingController();

  List<Outlet> selectedOutlet = [];
  String headerText = "SELECT THE PHOTO";
  Outlet? chosenOutlet;
  String? myID;
  String? videoName;
  String? categoryName;
  String? beatID;
  String? dateTime;
  String? outletName;
  double? lat;
  double? lng;
  String? imageURL;
  Category? category;

 bool isMerging = false;
 bool _validate =  false;

  @override
  void initState() {
   // ((tempBeat as Beat).outlet.where((element) => element.outletName.isEmpty)

    // TODO: implement initState
    super.initState();
    List<Outlet> outlets = [];
    outlets.addAll(widget.beat.outlet);
    tempBeat = Beat(
      widget.beat.beatName,
      outlets,
      id: widget.beat.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppBar(
                  title: Center(
                    child: Text(
                      isMerging
                          ? headerText
                          : "${(tempBeat as Beat).outlet.length} Outlets",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  toolbarHeight: 50,
                  leading: GestureDetector(
                    onTap: () {
                      if (isMerging) {
                        setState(() {
                          isMerging = false;
                        });
                      } else {
                        Navigator.pop(context);
                        print(tempBeat!.outlet.length.toString() +
                            " " +
                            widget.beat.outlet.length.toString());
                        // widget.updateBeat(
                        //     formerBeat: tempBeat, newBeat: widget.beat);
                        widget.refresh();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.updateBeat(formerBeat: widget.beat, newBeat: tempBeat);

                  // if(selectedCategories.categoryName!="Select category"){
                  //   Navigator.pop(context);
                  // }else{
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select all categories")));
                  // }

                  Navigator.pop(context);
                },
                child: Container(
                  height: 60,
                  width: 120,
                  color: Colors.green,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DONE",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Builder(builder: (context) {
                double height = MediaQuery
                    .of(context)
                    .size
                    .height;
                double width = MediaQuery
                    .of(context)
                    .size
                    .width;
                return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: width / (height * 1.175),
                  children: List.generate(
                      isMerging
                          ? selectedOutlet.length
                          : tempBeat!.outlet.length, (i) {
                    if (isMerging) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedOutlet[i] == chosenOutlet
                                ? Colors.blue
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, -2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Checkbox(
                                    // activeColor: Colors.blue,
                                    value: selectedOutlet[i] == chosenOutlet,
                                    onChanged: (newValue) =>
                                        setState(() {
                                          chosenOutlet = selectedOutlet[i];
                                        }),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: Image.network(
                                    selectedOutlet[i].videoName == null
                                        ? selectedOutlet[i].imageURL
                                        : localhost +
                                        selectedOutlet[i].imageURL,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      TextEditingController controller = TextEditingController();
                      controller.text = tempBeat!.outlet[i].outletName;
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedOutlet.contains(tempBeat!.outlet[i])
                                ? Colors.blue
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, -2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Checkbox(
                                    // activeColor: Colors.blue,
                                    value: selectedOutlet
                                        .contains(tempBeat!.outlet[i]),
                                    onChanged: (newValue) =>
                                        setState(() {
                                          if (selectedOutlet
                                              .contains(tempBeat!.outlet[i])) {
                                            selectedOutlet
                                                .remove(tempBeat!.outlet[i]);
                                          } else {
                                            selectedOutlet.add(
                                                tempBeat!.outlet[i]);
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: controller,
                                      onChanged: (String? text){
                                        tempBeat!.outlet[i].outletName = text ?? "";
                                      },
                                    ),
                                  ),
                                 // Text(tempBeat!.outlet[i].outletName),
                                 // Expanded(child: Container()),
                                  Container(
                                    width: 200,
                                    child: Builder(builder: (context) {
                                      return DropdownSearch<Category>(
                                        showSearchBox: true,
                                        mode: Mode.MENU,
                                        items: widget.categories,
                                        onChanged: (selected) {
                                          _changeDropDownValue(
                                              selectedCategories);
                                        },
                                        selectedItem: selectedCategories,
                                        dropdownSearchDecoration:
                                        const InputDecoration(
                                          // filled: true,
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF01689A),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        (tempBeat as Beat)
                                            .outlet
                                            .remove(tempBeat!.outlet[i]);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: Image.network(
                                    tempBeat!.outlet[i].videoName == null
                                        ? tempBeat!.outlet[i].imageURL
                                        : localhost +
                                        tempBeat!.outlet[i].imageURL,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                );
              }),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ],
              border: const Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 10,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedOutlet
                        .map(
                          (e) =>
                          Stack(
                            children: [
                              Container(
                                width: 350,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      e.videoName == null
                                          ? e.imageURL
                                          : localhost + e.imageURL,
                                    ),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, -2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 12,
                                child: IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    selectedOutlet.remove(e);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                              )
                            ],
                          ),
                    )
                        .toList(),
                  ),
                ),
                Container(
                  width: 500,
                  child: isMerging
                      ? MergeMap(selectedOutlet,
                      chosenOutlet == null ? [] : [chosenOutlet!], true)
                      : MergeMap(tempBeat!.outlet, selectedOutlet, false),
                ),
                GestureDetector(
                  onTap: () {
                    if ((selectedOutlet.length > 1 && !isMerging)) {
                      setState(() {
                        isMerging = true;
                      });
                    } else if (chosenOutlet != null && isMerging) {
                      setState(() {
                        if (headerText == "SELECT THE PHOTO") {
                          headerText = "SELECT THE LOCATION";
                          myID ??= chosenOutlet?.id;
                          videoName ??= chosenOutlet?.videoName;
                          dateTime ??= chosenOutlet?.dateTime;
                          imageURL = chosenOutlet?.imageURL;
                          chosenOutlet = null;
                        } else if (headerText == "SELECT THE LOCATION") {
                          headerText = "SELECT THE LOCATION";
                          myID ??= chosenOutlet?.id;
                          videoName ??= chosenOutlet?.videoName;
                          dateTime ??= chosenOutlet?.dateTime;
                          lat = chosenOutlet?.lat;
                          lng = chosenOutlet?.lng;
                          chosenOutlet = null;
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Center(
                                  child: Material(
                                    child: Container(
                                      height: 300,
                                      width: 300,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            TextField(
                                              controller: textController,
                                              decoration: const InputDecoration(
                                                  border:OutlineInputBorder(),
                                                labelText:"Oulet Name (optional)"
                                              ),
                                            ),
                                            const SizedBox(height: 12,),
                                            DropdownSearch(
                                              showSearchBox: true,
                                              items: List.generate(
                                                  selectedOutlet.length,
                                                      (index) =>
                                                  selectedOutlet[index]
                                                      .outletName),
                                              selectedItem: outletName,
                                              hint: "Outlet Name",
                                              onChanged: (String? a) {
                                                setState(() {
                                                  outletName = a;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 12,),
                                            DropdownSearch(
                                              selectedItem: category,
                                              showSearchBox: true,
                                              items: widget.categories,
                                              hint: "Select Category",
                                              onChanged: (Category? a) {
                                                setState(() {
                                                  category = a;
                                                });
                                              },
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                if (myID != null &&
                                                    imageURL != null &&
                                                    lat != null &&
                                                    lng != null) {
                                                  if (textController.text !=
                                                      "" ||
                                                      outletName != null) {
                                                    if (category != null) {
                                                      for (int i = 0;
                                                      i <
                                                          tempBeat!.outlet
                                                              .length;
                                                      i++) {
                                                        if ((tempBeat as Beat)
                                                            .outlet[i]
                                                            .id ==
                                                            myID) {
                                                          (tempBeat as Beat)
                                                              .outlet[i]
                                                              .categoryName =
                                                          (category!
                                                              .categoryName);
                                                          (tempBeat as Beat)
                                                              .outlet[i]
                                                              .outletName =
                                                          textController
                                                              .text ==
                                                              ""
                                                              ? outletName!
                                                              : textController
                                                              .text;
                                                          (tempBeat as Beat)
                                                              .outlet[i]
                                                              .lat = lat!;
                                                          (tempBeat as Beat)
                                                              .outlet[i]
                                                              .lng = lng!;
                                                          (tempBeat as Beat)
                                                              .outlet[i]
                                                              .imageURL =
                                                          imageURL!;
                                                          break;
                                                        }
                                                      }
                                                      List dynamicList =
                                                      selectedOutlet
                                                          .where(
                                                              (element) =>
                                                          element
                                                              .id !=
                                                              myID)
                                                          .toList();
                                                      for (var element
                                                      in dynamicList) {
                                                        (tempBeat as Beat)
                                                            .outlet
                                                            .remove(element);
                                                      }
                                                      Navigator.pop(context);
                                                      selectedOutlet = [];
                                                      headerText =
                                                      "SELECT THE PHOTO";
                                                      chosenOutlet = null;
                                                      myID = null;
                                                      videoName = null;
                                                      categoryName = null;
                                                      beatID = null;
                                                      dateTime = null;
                                                      outletName = null;
                                                      lat = null;
                                                      lng = null;
                                                      imageURL = null;
                                                      category = null;
                                                      textController.text = "";
                                                      setState(() {
                                                        isMerging = false;
                                                      });
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  "Successful")));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  "Select a category")));
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Select or enter the outlet name")));
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Soemthing went wrong")));
                                                }
                                              },
                                              child: Container(
                                                color: Colors.green,
                                                height: 60,
                                                child: Center(
                                                  child: Text(
                                                    "CONFIRM",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      });
                    }
                  },
                  child: Container(
                    color: (selectedOutlet.length <= 1 && !isMerging) ||
                        (chosenOutlet == null && isMerging)
                        ? Colors.blueGrey
                        : Colors.green,
                    width: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isMerging ? "NEXT" : "MERGE",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
