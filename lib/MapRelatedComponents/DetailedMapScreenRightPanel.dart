import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import 'package:manage_outlets/DialogBox/renameBeatNameDialog.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/AssignedBeat.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/BeatWidgets.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/ConfirmedBeat.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/ReviewBeat.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/SyncButton.dart';
import 'package:manage_outlets/OutletGridViewScreens/NextScreen.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:manage_outlets/backend/shortestPath.dart';

import '../BeforeMapScreens/GetOutletScreen.dart';
import '../DialogBox/backButtonAlert.dart';
import '../backend/Entities/Distributor.dart';

import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/User.dart';
import '../backend/Services/BeatService.dart';
import '../backend/database.dart';
import 'PopUpColors.dart';

class DetailedMapScreenRightPanel extends StatefulWidget {
  final List<Category> categories;
  final List<Beat> beats;
  final List<Distributor> distributors;
  final Distributor selectedDropDownItem;
  final Function _changeDropDownValue;
  final Function refresh;
  final Function changeColor;
  final bool isDeactivated;
  final Function changeDeactivated;
  final Function renameBeat;
  final List<User> users;
  final List<Widget> listOfBeatWidgets;
  final Widget sync;
  final Function addDistributor;

  DetailedMapScreenRightPanel(
      this.categories,
      this.distributors,
      this.beats,
      this.selectedDropDownItem,
      this._changeDropDownValue,
      this.refresh,
      this.changeColor,
      this.isDeactivated,
      this.changeDeactivated,
      this.renameBeat,
      this.users,
      this.listOfBeatWidgets,
      this.sync, this.addDistributor);

  @override
  _DetailedMapScreenRightPanelState createState() =>
      _DetailedMapScreenRightPanelState();
}

class _DetailedMapScreenRightPanelState
    extends State<DetailedMapScreenRightPanel> {
  TextEditingController newDistributorController = TextEditingController();
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 12, right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              spreadRadius: 2,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Show Disabled",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              widget.sync,
              SizedBox(
                width: 12,
              ),
              Switch(
                value: widget.isDeactivated,
                onChanged: (bool a) {
                  widget.changeDeactivated(a);
                },
              )
            ],
          ),

          const SizedBox(
            height: 12,
          ),
          const Text(
            "Distributor",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: hi.Container(
                  color: Colors.white,
                  child: DropdownSearch<Distributor>(
                    showSearchBox: true,
                    mode: Mode.MENU,
                    items: widget.distributors,
                    onChanged: (selected) {
                      widget._changeDropDownValue(selected as Distributor);
                    },
                    selectedItem: widget.selectedDropDownItem,
                    popupItemBuilder: (BuildContext context,
                        Distributor distributor, bool a) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(distributor.distributorName,
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          distributor.beats.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 12),
                                      child: Text(
                                        distributor.beats.length.toString() +
                                            " beats",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: Material(
                            child: Container(
                              height: 180,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text("CREATE DISTRIBUTOR", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(height: 12,),
                                    TextField(
                                      controller: newDistributorController,
                                      decoration: InputDecoration(
                                        labelText: "Distributor's Name",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black))),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    MaterialButton(
                                      color: Colors.green,
                                      height: 60,
                                      onPressed: () async {
                                        if (newDistributorController.text !=
                                            "") {
                                          try {
                                            Distributor dis =
                                                await DistributorService()
                                                    .createDistributor(
                                                        newDistributorController
                                                            .text);
                                            widget.addDistributor(dis);
                                            Navigator.pop(context);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text("Unsuccessful")));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Fill in the field")));
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1))),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Assigned",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Builder(builder: (context) {
                  List<Beat> beats = widget.selectedDropDownItem.beats
                      .where((element) => element.status == 1)
                      .toList();
                  return Wrap(
                    direction: Axis.horizontal,
                    children: [
                      ...List.generate(
                        beats.length,
                        (int index) {
                          return AssignedBeat(
                              beats[index],
                              widget.changeColor,
                              index,
                              widget.renameBeat,
                              widget.users, widget.distributors);
                        },
                      ),
                    ],
                  );
                }),
                Divider(
                  color: Colors.black.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "To Be Reviewed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Builder(builder: (context) {
                  return Wrap(
                    direction: Axis.horizontal,
                    children: [...widget.listOfBeatWidgets],
                  );
                }),
                Divider(
                  color: Colors.black.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Confirmed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Builder(builder: (context) {
                  List<Beat> beats = widget.selectedDropDownItem.beats
                      .where((element) => element.status == 3)
                      .toList();
                  return Wrap(
                    direction: Axis.horizontal,
                    children: [
                      ...List.generate(
                        beats.length,
                        (int index) {
                          return ConfirmedBeat(
                              beats[index],
                              widget.changeColor,
                              index,
                              widget.renameBeat,
                              widget.users, widget.distributors);
                        },
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
          // Center(
          //   child: hi.Container(
          //     clipBehavior: Clip.hardEdge,
          //     height: 50,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(12),
          //         boxShadow: [
          //           BoxShadow(
          //               offset: const Offset(0, 2),
          //               spreadRadius: 2,
          //               blurRadius: 2,
          //               color: Colors.black.withOpacity(0.1))
          //         ]),
          //     child: RawMaterialButton(
          //       onPressed: () {
          //         if (widget.selectedDropDownItem.distributorName.isNotEmpty) {
          //           if ("Select Distributor" !=
          //               widget.selectedDropDownItem.distributorName) {
          //             if (!isDisabled) {
          //               setState(() {
          //                 isDisabled = true;
          //               });
          //               try {
          //                 BeatService()
          //                     .updateOutlets(widget.beats,
          //                         widget.selectedDropDownItem.id, context)
          //                     .then((value) {
          //                   while (Navigator.canPop(context)) {
          //                     Navigator.pop(context);
          //                   }
          //                   Navigator.push(context,
          //                       MaterialPageRoute(builder: (_) {
          //                     return GetOutletScreen(1000000);
          //                   }));
          //                 });
          //               } catch (e) {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(
          //                     content: Text(
          //                         "Unsuccessful try again with connection"),
          //                   ),
          //                 );
          //               }
          //               setState(() {
          //                 isDisabled = false;
          //               });
          //             }
          //           } else {
          //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //               content: Text("Select a distributor"),
          //             ));
          //           }
          //         } else {
          //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //             content: Text("No beats created"),
          //           ));
          //         }
          //       },
          //       child: Center(
          //         child: isDisabled
          //             ? const CircularProgressIndicator()
          //             : const Text(
          //                 "CONFIRM",
          //                 style: const TextStyle(color: Colors.black),
          //               ),
          //       ),
          //     ),
          //   ),
          // ),
          //SizedBox(height: 0,)
        ],
      ),
    );
  }
}
