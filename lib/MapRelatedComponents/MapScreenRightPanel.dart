import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import 'package:manage_outlets/DialogBox/renameBeatNameDialog.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/BeatWidgets.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/ConfirmedBeat.dart';
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

class MapScreenRightPanel extends StatefulWidget {
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
  MapScreenRightPanel(
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
      this.listOfBeatWidgets,);

  @override
  _MapScreenRightPanelState createState() => _MapScreenRightPanelState();
}

class _MapScreenRightPanelState extends State<MapScreenRightPanel> {
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
          hi.Container(
            color: Colors.white,
            child: DropdownSearch<Distributor>(
              showSearchBox: true,
              mode: Mode.MENU,
              items: widget.distributors,
              onChanged: (selected) {
                widget._changeDropDownValue(selected as Distributor);
              },
              selectedItem: widget.selectedDropDownItem,
              popupItemBuilder:
                  (BuildContext context, Distributor distributor, bool a) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(distributor.distributorName),
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
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Beats",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),

          Expanded(
            child: ListView(
              children: [
                ...widget.listOfBeatWidgets,
              ],
            ),
          ),
          // Center(
          //   child: hi.Container(
          //     clipBehavior: Clip.hardEdge,
          //     height: 50,
          //     decoration: BoxDecoration(
          //         color: Colors.green,
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
          //               BeatService()
          //                   .updateOutlets(widget.beats,
          //                       widget.selectedDropDownItem.id, context)
          //                   .then((value) {
          //                 setState(() {
          //                   isDisabled = false;
          //                 });
          //                 while (Navigator.canPop(context)) {
          //                   Navigator.pop(context);
          //                 }
          //                 Navigator.push(context,
          //                     MaterialPageRoute(builder: (_) {
          //                   return GetOutletScreen(1000000);
          //                 }));
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
          //                 style: const TextStyle(color: Colors.white),
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
