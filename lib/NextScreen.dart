import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/MergeMap.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';

import 'backend/Entities/OutletsListEntity.dart';
import 'MergingScreen.dart';
import 'backend/Entities/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;
  final Function refresh;
  final Function updateBeat;

  const NextScreen(
    this.beat,
    this.categories,
    this.refresh,
    this.updateBeat,
  );

  @override
  State<NextScreen> createState() => _NextScreenState();
}

Category selectedCategories = Category("Select category", 10000000);

void _changeDropDownValue(Category newValue) {
  selectedCategories = newValue;
  selectedCategories = newValue;
}

class _NextScreenState extends State<NextScreen> {
  Beat? tempBeat;
  bool isValidate = true;

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
  bool _validate = false;

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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                ),
                InkWell(
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
                Expanded(
                  child: Center(
                    child: Text(
                      isMerging
                          ? headerText
                          : "${(tempBeat as Beat).outlet.length} Outlets",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        isValidate = false;
                        for (var element in (tempBeat as Beat).outlet) {
                          if (element.outletName == "") {
                            isValidate = true;
                          }
                          if (element.newcategoryID == null) {
                            isValidate = true;
                          }
                        }
                        if (!isValidate) {
                          widget.updateBeat(
                              formerBeat: widget.beat, newBeat: tempBeat);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isValidate = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Select all name and categories")));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "DONE",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Builder(builder: (context) {
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;
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
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedOutlet[i] == chosenOutlet
                                  ? Colors.green
                                  : Colors.white,
                            width: selectedOutlet[i] == chosenOutlet
                                ? 5
                                : 0),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  chosenOutlet = selectedOutlet[i];
                                });
                              },
                              onDoubleTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return Scaffold(
                                      body: Column(
                                    children: [
                                      AppBar(
                                        leading: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          ),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.transparent,
                                      ),
                                      Expanded(
                                        child: InteractiveViewer(
                                          // boundaryMargin:
                                          //     const EdgeInsets.all(20.0),
                                          minScale: 0.7,
                                          maxScale: 3.1,
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            child: Image.network(
                                              selectedOutlet[i].videoName ==
                                                      null
                                                  ? selectedOutlet[i].imageURL
                                                  : localhost +
                                                      selectedOutlet[i]
                                                          .imageURL,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                                }));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Checkbox(
                                        activeColor: Colors.green,
                                        value:
                                            selectedOutlet[i] == chosenOutlet,
                                        onChanged: (newValue) => setState(() {
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
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      TextEditingController controller =
                          TextEditingController();
                      controller.text = tempBeat!.outlet[i].outletName;
                      return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedOutlet
                                          .contains(tempBeat!.outlet[i])
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: selectedOutlet
                                          .contains(tempBeat!.outlet[i])
                                      ? 5
                                      : 0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (selectedOutlet
                                          .contains(tempBeat!.outlet[i])) {
                                        selectedOutlet
                                            .remove(tempBeat!.outlet[i]);
                                      } else {
                                        selectedOutlet.add(tempBeat!.outlet[i]);
                                      }
                                    });
                                  },
                                  onDoubleTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return Scaffold(
                                        body: Column(
                                          children: [
                                            AppBar(
                                              leading: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              foregroundColor:
                                                  Colors.transparent,
                                            ),
                                            Expanded(
                                              child: InteractiveViewer(
                                                // boundaryMargin:
                                                //     const EdgeInsets.all(20.0),
                                                minScale: 0.7,
                                                maxScale: 3.1,
                                                child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  child: Image.network(
                                                    tempBeat!.outlet[i]
                                                                .videoName ==
                                                            null
                                                        ? tempBeat!
                                                            .outlet[i].imageURL
                                                        : localhost +
                                                            tempBeat!.outlet[i]
                                                                .imageURL,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }));
                                  },
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Checkbox(
                                                activeColor: Colors.green,
                                                value: selectedOutlet.contains(
                                                    tempBeat!.outlet[i]),
                                                onChanged: (newValue) =>
                                                    setState(() {
                                                  if (selectedOutlet.contains(
                                                      tempBeat!.outlet[i])) {
                                                    selectedOutlet.remove(
                                                        tempBeat!.outlet[i]);
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 50,
                                                    child: TextField(
                                                      controller: controller,
                                                      onChanged:
                                                          (String? text) {
                                                        tempBeat!.outlet[i]
                                                                .outletName =
                                                            text ?? "";
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        errorText: (controller
                                                                        .text ==
                                                                    "" &&
                                                                !isValidate)
                                                            ? 'Field Can\'t Be Empty'
                                                            : null,
                                                        border:
                                                            const OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Text(tempBeat!.outlet[i].outletName),
                                              // Expanded(child: Container()),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 200,
                                                  height: 50,
                                                  child: Builder(
                                                      builder: (context) {
                                                    return DropdownSearch<
                                                        Category>(
                                                      showSearchBox: true,
                                                      dropDownButton:
                                                          SizedBox.shrink(),
                                                      mode: Mode.MENU,
                                                      items: widget.categories,
                                                      onChanged: (selected) {
                                                        _changeDropDownValue(
                                                            selectedCategories);
                                                        tempBeat!.outlet[i]
                                                                .newcategoryID =
                                                            selected?.id;
                                                      },
                                                      selectedItem:
                                                          selectedCategories,
                                                      dropdownSearchDecoration: InputDecoration(
                                                          errorText: (tempBeat!
                                                                          .outlet[
                                                                              i]
                                                                          .newcategoryID ==
                                                                      null &&
                                                                  !isValidate)
                                                              ? 'Field Can\'t Be Empty'
                                                              : null,
                                                          suffixIcon: Icon(Icons
                                                              .arrow_drop_down),
                                                          border:
                                                              OutlineInputBorder()),
                                                    );
                                                  }),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedOutlet.remove(
                                                        selectedOutlet
                                                            .firstWhere(
                                                                (element) =>
                                                                    tempBeat!
                                                                        .outlet[
                                                                            i]
                                                                        .id ==
                                                                    element
                                                                        .id));
                                                    (tempBeat as Beat)
                                                        .outlet
                                                        .remove(tempBeat!
                                                            .outlet[i]);
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
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    child: Image.network(
                                                      tempBeat!.outlet[i]
                                                                  .videoName ==
                                                              null
                                                          ? tempBeat!.outlet[i]
                                                              .imageURL
                                                          : localhost +
                                                              tempBeat!
                                                                  .outlet[i]
                                                                  .imageURL,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            width: 60,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: tempBeat!.outlet[i]
                                                          .videoName ==
                                                      null
                                                  ? Colors.red
                                                  : Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1))
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                tempBeat!.outlet[i].videoName ==
                                                        null
                                                    ? "FA"
                                                    : "SC",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )));
                    }
                  }),
                );
              }),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ],
              // border: const Border(
              //   top: BorderSide(
              //     color: Colors.black,
              //     width: 10,
              //   ),
              // ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedOutlet
                        .map(
                          (e) => Stack(
                            children: [
                              Container(
                                width: 200,
                                margin: const EdgeInsets.all(12),
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
                                right: 4,
                                top: 4,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedOutlet.remove(e);
                                      setState(() {});
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
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
                                            Row(
                                              children: [
                                                Text(
                                                  "FILL THE REQUIREMENTS",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(Icons.clear),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              controller: textController,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      "Oulet Name (optional)"),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
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
                                            const SizedBox(
                                              height: 12,
                                            ),
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
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Successful")));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
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
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: const Offset(
                                                              0, 2),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.1))
                                                    ]),
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
