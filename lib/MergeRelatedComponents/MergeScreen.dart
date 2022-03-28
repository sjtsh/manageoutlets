import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:manage_outlets/DialogBox/ConfirmMergeDialogBox.dart';
import 'package:manage_outlets/MergeRelatedComponents/MergeMap.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import '../MergeRelatedComponents/SingularOutlet.dart';
import '../MergeRelatedComponents/SingularOutletNonMerging.dart';
import '../DialogBox/backButtonAlert.dart';
import '../OutletGridViewScreens/DoneButton.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/Outlet.dart';

class MergeScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;
  final Function refresh;
  final List<Outlet> selectedOutlet;
  final Beat tempBeat;
  final bool isDeactivated;

  MergeScreen(
    this.beat,
    this.categories,
    this.refresh,
    this.selectedOutlet,
    this.tempBeat, this.isDeactivated,
  );

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class TabIntent extends Intent {}

class BackIntent extends Intent {}

class _MergeScreenState extends State<MergeScreen> {
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
  TextEditingController textController = TextEditingController();

  setChosenOutlet(Outlet a) {
    setState(() {
      chosenOutlet = a;
    });
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
                        headerText = "SELECT THE PHOTO";
                        Navigator.pop(context);
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
                          headerText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
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
                      children:
                          List.generate(widget.selectedOutlet.length, (i) {
                        return SingularOutlet(
                            widget.selectedOutlet[i], setChosenOutlet,
                            chosenOutlet: chosenOutlet);
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
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.selectedOutlet
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
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    hi.Container(
                        width: 500,
                        child: MergeMap(widget.selectedOutlet,
                            chosenOutlet == null ? [] : [chosenOutlet!], true, widget.isDeactivated)),
                    GestureDetector(
                      onTap: () {
                        if (chosenOutlet != null) {
                          if (headerText == "SELECT THE PHOTO") {
                            headerText = "SELECT THE LOCATION";
                            myID ??= chosenOutlet?.id;
                            videoName ??= chosenOutlet?.videoName;
                            dateTime ??= chosenOutlet?.dateTime;
                            imageURL = chosenOutlet?.imageURL;
                            chosenOutlet = null;

                            setState(() {});
                          } else if (headerText == "SELECT THE LOCATION") {
                            headerText = "SELECT THE LOCATION";

                            myID ??= chosenOutlet?.id;
                            videoName ??= chosenOutlet?.videoName;
                            dateTime ??= chosenOutlet?.dateTime;
                            lat = chosenOutlet?.lat;
                            lng = chosenOutlet?.lng;
                            chosenOutlet = null;

                            setState(() {});
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ConfirmMergeDialogBox(
                                      widget.selectedOutlet,
                                      widget.categories,
                                      textController,
                                      chosenOutlet,
                                      myID,
                                      videoName,
                                      categoryName,
                                      beatID,
                                      dateTime,
                                      lat,
                                      lng,
                                      imageURL,
                                      widget.tempBeat,
                                      widget.refresh);
                                });
                          }
                        }
                      },
                      child: hi.Container(
                        color: (chosenOutlet == null)
                            ? Colors.blueGrey
                            : Colors.green,
                        width: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "NEXT",
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
}
