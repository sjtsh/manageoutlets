import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:hovering/hovering.dart';
import 'package:manage_outlets/MergeRelatedComponents/MergeMap.dart';
import 'package:manage_outlets/MergeRelatedComponents/MergeScreen.dart';
import 'package:manage_outlets/OutletGridViewScreens/ActivatedOutlets.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import '../MergeRelatedComponents/SingularOutlet.dart';
import '../backend/Entities/Distributor.dart';
import '../backend/Services/BeatService.dart';
import '../backend/shortestPath.dart';
import 'DoneButton.dart';
import '../MergeRelatedComponents/SingularOutletNonMerging.dart';
import '../DialogBox/backButtonAlert.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;
  final Function refresh;
  final Distributor dropdownSelectedItem;
  final Function setNewBeats;

  NextScreen(this.beat, this.categories, this.refresh,
      this.dropdownSelectedItem, this.setNewBeats);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class TabIntent extends Intent {}

class BackIntent extends Intent {}

class _NextScreenState extends State<NextScreen> {
  Beat? tempBeat;
  bool isValidate = true;
  String sortDropdownItem = "Distance";
  final ScrollController controller = ScrollController();
  bool scrollable = true;
  bool isDisabled = false;
  bool isDeactivated = false;

  List<Outlet> selectedOutlet = [];

  refreshNext() {
    setState(() {
      selectedOutlet = [];
    });
  }

  stopScroll(bool myBool) {
    setState(() {
      scrollable = myBool;
    });
  }

  changeDeactivated() {
    setState(() {
      isDeactivated = !isDeactivated;
    });
  }

  setActivate(String index, bool set) {
    if (set) {
      selectedOutlet.removeWhere((element) => index == element.id);
    }
    Outlet? outlet =
        tempBeat?.outlet.firstWhere((element) => element.id == index);
    outlet?.deactivated = set;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    List<Outlet> outlets = [];
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
          videoName: element.videoName,
          deactivated: element.deactivated);
      outlet.newcategoryID = element.newcategoryID;
      outlets.add(outlet);
    }
    tempBeat = Beat(widget.beat.beatName, outlets,
        widget.dropdownSelectedItem.distributorName,
        id: widget.beat.id,
        color: widget.beat.color,
        userID: widget.beat.userID,
        status: widget.beat.status);
  }

  @override
  Widget build(BuildContext context) {
    return !isDisabled
        ? Shortcuts(
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
                            "Your progress will not be saved",
                            "Confirm",
                            "Cancel", () {
                          Navigator.pop(context);
                        });
                      });
                }))
              },
              child: Scaffold(
                body: ActivatedOutlets(
                    scrollable,
                    controller,
                    tempBeat,
                    selectedOutlet,
                    widget.categories,
                    isValidate,
                    setCategoryID,
                    changeOutletSelectionStatus,
                    stopScroll,
                    widget.beat,
                    refreshNext,
                    doneFunction,
                    sortDropdownItem,
                    changeOutletSelectionStatus,
                    shortestPath, (String? a) {
                  if (a != null) {
                    sortDropdownItem = a;
                    if (a == "Distance") {
                      tempBeat?.outlet = shortestPath(tempBeat!.outlet)[0];
                    } else if (a == "Name") {
                      tempBeat?.outlet
                          .sort((a, b) => a.outletName.compareTo(b.outletName));
                    } else if (a == "Category") {
                      tempBeat?.outlet.sort((a, b) =>
                          a.categoryID.compareTo(b.newcategoryID ?? 0));
                    }
                    setState(() {});
                  }
                }, widget.refresh, changeDeactivated, isDeactivated,
                    setActivate),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Text("Please Wait..."),
            ),
          );
  }

  undefinableFunction() {}

  doneFunction() {
    isValidate = false;
    for (var element in (tempBeat as Beat).outlet) {
      if (element.outletName == "" ) {
        isValidate = true;
      }
    }
    if (!isValidate) {
      // widget.updateBeat(formerBeat: widget.beat, newBeat: tempBeat);
      if (widget.dropdownSelectedItem.distributorName.isNotEmpty) {
        if ("Select Distributor" !=
            widget.dropdownSelectedItem.distributorName) {
          if (!isDisabled) {
            setState(() {
              isDisabled = true;
            });
            BeatService().updateOutlets(
                [tempBeat!],
                widget.dropdownSelectedItem,
                context,
                widget.setNewBeats).then((value) {
              setState(() {
                isDisabled = false;
              });
              Navigator.pop(context);
            }).onError((error, stackTrace) {
              setState(() => isDisabled = false);
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("UNSUCCESSFUL TRY AGAIN"),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Select a distributor"),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No beats created"),
        ));
      }
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
    tempBeat!.outlet[i].categoryID =
        selected?.id ?? tempBeat!.outlet[i].categoryID;
    setState(() {});
  }
}
