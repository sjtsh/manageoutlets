import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:hovering/hovering.dart';
import 'package:manage_outlets/MergeRelatedComponents/MergeMap.dart';
import 'package:manage_outlets/MergeRelatedComponents/MergeScreen.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import '../MergeRelatedComponents/SingularOutlet.dart';
import 'DoneButton.dart';
import 'InteractiveImage.dart';
import '../MergeRelatedComponents/SingularOutletNonMerging.dart';
import '../DialogBox/backButtonAlert.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/Outlet.dart';

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
  String sortDropdownItem = "Distance";
  final controller = ScrollController();

  List<Outlet> selectedOutlet = [];

  refreshNext() {
    setState(() {
      selectedOutlet = [];
    });
  }

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
          videoName: element.videoName, deactivated: element.deactivated);
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
          videoName: element.videoName,
          deactivated: element.deativated));

    }
    tempBeat = Beat(
      widget.beat.beatName,
      outlets,
      id: widget.beat.id,
      deactivated: deactivateds,
      color: widget.beat.color
    );
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
                      "Your progress will not be saved", "Confirm", "Cancel",
                      () {
                    Navigator.pop(context);
                  });
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
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BackButtonAlert(
                                "Your progress will not be saved",
                                "Confirm",
                                "Cancel",
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            });
                        widget.refresh();
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
                        child: Row(
                          children: [
                            Text(
                              "${(tempBeat as Beat).outlet.length} Outlets",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 12),
                            DropdownButton(
                              items: <String>["Distance", "Name", "Category"]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ),
                                  )
                                  .toList(),
                              value: sortDropdownItem,
                              onChanged: (String? a) {
                                if (a != null) {
                                  setState(() {
                                    sortDropdownItem = a;
                                  });
                                }
                              },
                            ),
                          ],
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
                    return ImprovedScrolling(
                      scrollController:controller ,
                      enableKeyboardScrolling: true,
                      keyboardScrollConfig: KeyboardScrollConfig(
                        arrowsScrollAmount: 250.0,
                        homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
                          return const Duration(milliseconds: 100);
                        },
                        endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
                          return const Duration(milliseconds: 2000);
                        },
                      ),
                      child: GridView.count(
                        controller: controller,
                        crossAxisCount: 3,
                        childAspectRatio: width / (height * 1.175),
                        children: List.generate(tempBeat!.outlet.length, (i) {
                          TextEditingController controller =
                              TextEditingController();
                          controller.text = tempBeat!.outlet[i].outletName;
                          return SingularOutletNonMerging(
                              selectedOutlet,
                              tempBeat!.outlet[i],
                              controller,
                              changeOutletSelectionStatus,
                              isValidate,
                              widget.categories,
                              setCategoryID,
                              tempBeat!,
                              i,
                              removeItemFunction);
                        }),
                      ),
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
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    hi.Container(
                      width: 500,
                      child: MergeMap(tempBeat!.outlet, selectedOutlet, false),
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((selectedOutlet.length > 1)) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return MergeScreen(
                              widget.beat,
                              widget.categories,
                              refreshNext,
                              selectedOutlet,
                              tempBeat!,
                            );
                          }));
                        }
                      },
                      child: hi.Container(
                        color: (selectedOutlet.length <= 1)
                            ? Colors.blueGrey
                            : Colors.green,
                        width: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "MERGE",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
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

  undefinableFunction() {}

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

  changeOutletSelectionStatus(Outlet a) {
    setState(() {
      if (selectedOutlet.contains(a)) {
        selectedOutlet.remove(a);
      } else {
        selectedOutlet.add(a);
      }
    });
  }

  setCategoryID(Category? selected, int i) {
    tempBeat!.outlet[i].newcategoryID = selected?.id;
  }

  removeItemFunction(int i) {
    setState(() {
      selectedOutlet
          .removeWhere((element) => tempBeat!.outlet[i].id == element.id);

      if (widget.beat.deactivated != null) {
        tempBeat?.deactivated!.add(tempBeat!.outlet[i]);
      } else {
        tempBeat?.deactivated = [tempBeat!.outlet[i]];
      }

      (tempBeat as Beat).outlet.remove(tempBeat!.outlet[i]);
    });
  }
}
