import 'package:flutter/material.dart';

import '../DialogBox/backButtonAlert.dart';
import '../MergeRelatedComponents/MergeMap.dart';
import '../MergeRelatedComponents/MergeScreen.dart';
import '../MergeRelatedComponents/SingularOutletNonMerging.dart';
import '../backend/Entities/Category.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import 'DoneButton.dart';

class ActivatedOutlets extends StatelessWidget {
  final bool scrollable;
  final ScrollController controller;
  final Beat? tempBeat;
  final List<Outlet> selectedOutlet;
  final List<Category> categories;
  final bool isValidate;
  final Function setCategoryID;
  final Function chanegOutletSelectionStatus;
  final Function stopScroll;
  final Beat beat;
  final Function refreshNext;
  final void Function() doneFunction;
  final String sortDropdownItem;
  final Function changeOutletSelectionStatus;
  final Function shortestPath;
  final void Function(String?) onDropdownChanged;
  final Function refresh;
  final Function changeDeactivated;
  final bool isDeactivated;
  final Function setActivate;

  ActivatedOutlets(
    this.scrollable,
    this.controller,
    this.tempBeat,
    this.selectedOutlet,
    this.categories,
    this.isValidate,
    this.setCategoryID,
    this.chanegOutletSelectionStatus,
    this.stopScroll,
    this.beat,
    this.refreshNext,
    this.doneFunction,
    this.sortDropdownItem,
    this.changeOutletSelectionStatus,
    this.shortestPath,
    this.onDropdownChanged,
    this.refresh,
    this.changeDeactivated,
    this.isDeactivated,
    this.setActivate,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Builder(builder: (context) {
              double height = MediaQuery.of(context).size.height;
              double width = MediaQuery.of(context).size.width;
              return isDeactivated
                  ? ListView(
                      physics:
                          scrollable ? null : NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: List.generate(tempBeat!.outlet.length, (index) {
                        if (index % 3 == 0) {
                          return Row(
                              children: [index, index + 1, index + 2].map((i) {
                            if (i < tempBeat!.outlet.length) {
                              TextEditingController controller =
                                  TextEditingController();
                              controller.text = tempBeat!.outlet[i].outletName;
                              if (tempBeat!.outlet[i].deactivated) {
                                return SizedBox(
                                  height: height / 3,
                                  width: width / 3 - 24,
                                  child: Stack(
                                    children: [
                                      SingularOutletNonMerging(
                                          selectedOutlet,
                                          tempBeat!.outlet[i],
                                          controller,
                                          changeOutletSelectionStatus,
                                          isValidate,
                                          categories,
                                          setCategoryID,
                                          tempBeat!,
                                          i,
                                          stopScroll, setActivate),
                                      Container(
                                        height: height / 3 - 12,
                                        width: width / 3 - 36,
                                        color: Colors.black.withOpacity(0.5),
                                        child: Center(
                                            child: GestureDetector(
                                              onTap: (){
                                              setActivate(tempBeat!.outlet[i].id, false);
                                              },
                                              child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Activate"),
                                          ),
                                        ),
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: height / 3,
                                  width: width / 3 - 24,
                                  child: SingularOutletNonMerging(
                                      selectedOutlet,
                                      tempBeat!.outlet[i],
                                      controller,
                                      changeOutletSelectionStatus,
                                      isValidate,
                                      categories,
                                      setCategoryID,
                                      tempBeat!,
                                      i,
                                      stopScroll, setActivate),
                                );
                              }
                            } else {
                              return Container();
                            }
                          }).toList());
                        }
                        return Container();
                      }),
                    )
                  : Builder(builder: (context) {
                      List<Outlet> outlets = tempBeat!.outlet
                          .where((element) => !element.deactivated)
                          .toList();
                      return ListView(
                        physics:
                            scrollable ? null : NeverScrollableScrollPhysics(),
                        controller: controller,
                        children: List.generate(outlets.length, (index) {
                          if (index % 3 == 0) {
                            return Row(
                                children:
                                    [index, index + 1, index + 2].map((i) {
                              if (i < outlets.length) {
                                TextEditingController controller =
                                    TextEditingController();
                                controller.text = outlets[i].outletName;
                                return SizedBox(
                                  height: height / 3,
                                  width: width / 3 - 24,
                                  child: SingularOutletNonMerging(
                                      selectedOutlet,
                                      outlets[i],
                                      controller,
                                      changeOutletSelectionStatus,
                                      isValidate,
                                      categories,
                                      setCategoryID,
                                      tempBeat!,
                                      i,
                                      stopScroll, setActivate),
                                );
                              } else {
                                return Container();
                              }
                            }).toList());
                          } else {
                            return Container();
                          }
                        }),
                      );
                    });
            }),
          ),
        ),
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
          child: Builder(builder: (context) {
            double widthOfScreen = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                SizedBox(
                    width: widthOfScreen,
                    height: 200,
                    child: MergeMap(tempBeat!.outlet, selectedOutlet, false,
                        isDeactivated)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: DropdownButton(
                                    items:
                                        <String>["Distance", "Name", "Category"]
                                            .map(
                                              (e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ),
                                            )
                                            .toList(),
                                    value: sortDropdownItem,
                                    underline: Container(),
                                    onChanged: onDropdownChanged,
                                  ),
                                ),
                              );
                            }),
                            Expanded(child: Container()),
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
                                refresh();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                                child: const Focus(
                                  autofocus: true,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "${(tempBeat as Beat).outlet.length} Outlets",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeDeactivated();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDeactivated
                                        ? Colors.red
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      isDeactivated
                                          ? "Showing Deactivated"
                                          : "Not Showing Deactivated",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if ((selectedOutlet.length > 1)) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return MergeScreen(
                                        beat,
                                        categories,
                                        refreshNext,
                                        selectedOutlet,
                                        tempBeat!,
                                        isDeactivated);
                                  }));
                                }
                              },
                              child: Material(
                                color: (selectedOutlet.length <= 1)
                                    ? Colors.blueGrey
                                    : Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "MERGE",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.merge_type,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            DoneButton(doneFunction),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
