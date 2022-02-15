import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:manage_outlets/MergeMap.dart';
import 'package:manage_outlets/SingularOutlet.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import 'DoneButton.dart';
import 'InteractiveImage.dart';
import 'SingularOutletNonMerging.dart';
import 'backButtonAlert.dart';
import 'backend/Entities/OutletsListEntity.dart';
import 'MergingScreen.dart';
import 'backend/Entities/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;
  final Function refresh;
  final Function updateBeat;

  NextScreen(
    this.beat,
    this.categories,
    this.refresh,
    this.updateBeat,
  );

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class TabIntent extends Intent {}

class BackIntent extends Intent {}

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
  int? categoadsuig;

  bool isMerging = false;
  late FocusNode _textFocus;
  late FocusNode _dropFocus1;
  late FocusNode _dropFocus2;
  int tabCounter = 0;


  @override
  void initState() {
    super.initState();
    List<Outlet> outlets = [];
    List<Outlet> deactivateds = [];
    for (var element in widget.beat.outlet) {
      Outlet outlet = Outlet(
          imageURL: element.imageURL,
          categoryID: element.categoryID,
          categoryName: element.categoryName,
          lng: element.lng,
          lat: element.lat,
          id: element.id,
          outletName: element.outletName,
          marker: element.marker,
          beatID: element.beatID,
          dateTime: element.dateTime,
          md5: element.md5,
          videoID: element.videoID,
          videoName: element.videoName);
      outlet.newcategoryID = element.newcategoryID;
      outlets.add(outlet);
    }

    for (var element in widget.beat.deactivated ?? []) {
      deactivateds.add(Outlet(
          imageURL: element.imageURL,
          categoryID: element.categoryID,
          categoryName: element.categoryName,
          lng: element.lng,
          lat: element.lat,
          id: element.id,
          outletName: element.outletName,
          marker: element.marker,
          beatID: element.beatID,
          dateTime: element.dateTime,
          md5: element.md5,
          videoID: element.videoID,
          videoName: element.videoName));
    }
    tempBeat = Beat(
      widget.beat.beatName,
      outlets,
      id: widget.beat.id,
      deactivated: deactivateds,
    );
    _textFocus = FocusNode();
    _dropFocus1 = FocusNode();
    _dropFocus2 = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
      },
      child: Actions(
        actions: {
          BackIntent: CallbackAction(onInvoke: ((intent) {
            showDialog(
                context: context,
                builder: (_) {
                  return BackButtonAlert(
                      "Your progress will not be saved", "Confirm", "Cancel");
                });
          }))
        },
        child: Scaffold(
          body: Column(
            children: [
              hi.Container(
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
                    GestureDetector(
                      onTap: () {
                        if (isMerging) {
                          headerText = "SELECT THE PHOTO";
                          chosenOutlet = null;
                          myID = null;
                          videoName = null;
                          categoryName = null;
                          categoadsuig = null;
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return BackButtonAlert(
                                    "Your progress will not be saved",
                                    "Confirm",
                                    "Cancel");
                              });
                          widget.refresh();
                        }
                      },
                      child: const Focus(
                        autofocus: true,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
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
                    DoneButton(doneFunction),
                    const SizedBox(
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
                          return SingularOutlet(selectedOutlet[i], (Outlet a) {
                            setState(() {
                              chosenOutlet = a;
                            });
                          }, chosenOutlet: chosenOutlet);
                        } else {
                          TextEditingController controller =
                              TextEditingController();
                          controller.text = tempBeat!.outlet[i].outletName;
                          return SingularOutletNonMerging(
                              selectedOutlet,
                              tempBeat!.outlet[i],
                              controller,
                              (Outlet a) {
                                setState(() {
                                  if (selectedOutlet.contains(a)) {
                                    selectedOutlet.remove(a);
                                  } else {
                                    selectedOutlet.add(a);
                                  }
                                });
                              },
                              isValidate,
                              widget.categories,
                              (Category? selected) {
                                tempBeat!.outlet[i].newcategoryID =
                                    selected?.id;
                              },
                              tempBeat!,
                              i);
                        }
                      }),
                    );
                  }),
                ),
              ),
              hi.Container(
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
                                  hi.Container(
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
                                  isMerging
                                      ? Container()
                                      : Positioned(
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
                                        ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    hi.Container(
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
                                    return Shortcuts(
                                      shortcuts: {
                                        LogicalKeySet(LogicalKeyboardKey.tab):
                                            TabIntent(),
                                      },
                                      child: Actions(
                                        actions: {
                                          TabIntent: CallbackAction(
                                              onInvoke: ((intent) {
                                            print(tabCounter);
                                            if (tabCounter == 0) {
                                              print(tabCounter);

                                              setState(() {
                                                _textFocus.requestFocus();
                                                tabCounter++;
                                              });
                                            } else if (tabCounter == 1) {
                                              setState(() {
                                                _dropFocus1.requestFocus();
                                                tabCounter++;
                                              });
                                            } else {
                                              setState(() {
                                                _dropFocus2.requestFocus();
                                                tabCounter = 0;
                                              });
                                            }
                                          }))
                                        },
                                        child: Center(
                                          child: Material(
                                            child: hi.Container(
                                              height: 300,
                                              width: 300,
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "FILL THE REQUIREMENTS",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child:
                                                                hi.Container()),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Icon(Icons.clear),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Focus(
                                                      canRequestFocus: true,
                                                      autofocus: true,
                                                      focusNode: _textFocus,
                                                      child: TextField(
                                                        controller:
                                                            textController,
                                                        decoration: const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                "Oulet Name (optional)"),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Focus(
                                                      canRequestFocus: true,
                                                      focusNode: _dropFocus1,
                                                      child: DropdownSearch(
                                                        showSearchBox: true,
                                                        items: List.generate(
                                                            selectedOutlet
                                                                .length,
                                                            (index) =>
                                                                selectedOutlet[
                                                                        index]
                                                                    .outletName),
                                                        selectedItem:
                                                            outletName,
                                                        hint: "Outlet Name",
                                                        onChanged: (String? a) {
                                                          setState(() {
                                                            outletName = a;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Focus(
                                                      canRequestFocus: true,
                                                      focusNode: _dropFocus2,
                                                      child: DropdownSearch(
                                                        selectedItem: category,
                                                        showSearchBox: true,
                                                        items:
                                                            widget.categories,
                                                        hint: "Select Category",
                                                        onChanged:
                                                            (Category? a) {
                                                          setState(() {
                                                            category = a;
                                                            categoadsuig =
                                                                a?.id;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: hi.Container()),
                                                    GestureDetector(
                                                      onTap: () {
                                                        undefinableFunction();
                                                      },
                                                      child: hi.Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 2,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1))
                                                            ]),
                                                        child: Center(
                                                          child: Text(
                                                            "CONFIRM",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                      child: hi.Container(
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
        ),
      ),
    );
  }

  undefinableFunction() {
    if (myID != null && imageURL != null && lat != null && lng != null) {
      if (textController.text != "" || outletName != null) {
        if (category != null) {
          for (int i = 0; i < tempBeat!.outlet.length; i++) {
            if (tempBeat!.outlet[i].id == myID) {
              tempBeat!.outlet[i].categoryName = (category!.categoryName);
              tempBeat!.outlet[i].newcategoryID = categoadsuig;
              tempBeat!.outlet[i].outletName =
                  textController.text == "" ? outletName! : textController.text;
              tempBeat!.outlet[i].lat = lat!;
              tempBeat!.outlet[i].lng = lng!;
              tempBeat!.outlet[i].imageURL = imageURL!;
              break;
            }
          }
          List dynamicList =
              selectedOutlet.where((element) => element.id != myID).toList();
          for (var element in dynamicList) {
            if (tempBeat?.deactivated == null) {
              tempBeat!.deactivated = [element];
            } else {
              tempBeat!.deactivated?.add(element);
            }
            tempBeat!.outlet.remove(element);
          }
          Navigator.pop(context);
          selectedOutlet = [];
          headerText = "SELECT THE PHOTO";
          chosenOutlet = null;
          myID = null;
          videoName = null;
          categoryName = null;
          categoadsuig = null;
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Successful")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Select a category")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Select or enter the outlet name")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Soemthing went wrong")));
    }
  }

  doneFunction() {
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
      widget.updateBeat(formerBeat: widget.beat, newBeat: tempBeat);
      Navigator.pop(context);
    } else {
      setState(() {
        isValidate = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select all name and categories")));
    }
  }
}


