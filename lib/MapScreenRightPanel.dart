import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart' as hi;
import 'package:manage_outlets/NextScreen.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:manage_outlets/backend/shortestPath.dart';

import 'GetOutletScreen.dart';
import 'backend/Entities/Distributor.dart';

import 'backend/Entities/OutletsListEntity.dart';
import 'backend/Services/BeatService.dart';
import 'backend/database.dart';

class MapScreenRightPanel extends StatefulWidget {
  final List<Category> categories;
  final List<Beat> beats;
  final Function removeBeat;
  final List<Distributor> distributors;
  final Distributor selectedDropDownItem;
  final Function _changeDropDownValue;
  final Function refresh;
  final Function updateBeat;

  MapScreenRightPanel(
    this.categories,
    this.distributors,
    this.beats,
    this.removeBeat,
    this.selectedDropDownItem,
    this._changeDropDownValue,
    this.refresh,
    this.updateBeat,
  );

  @override
  _MapScreenRightPanelState createState() => _MapScreenRightPanelState();
}

class _MapScreenRightPanelState extends State<MapScreenRightPanel> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                selectedItem: widget.selectedDropDownItem),
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
                ...List.generate(widget.beats.length, (int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {},
                      onDoubleTap: () {
                        // double tap function
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                          return NextScreen(
                              widget.beats[index],
                              widget.categories,
                              widget.refresh,
                              widget.updateBeat);
                        }));
                      },
                      child: hi.Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.beats[index].beatName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${widget.beats[index].outlet.length} Outlets",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Expanded(child: hi.Container()),
                                hi.Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorIndex[colorIndex.length -
                                          1 -
                                          widget.selectedDropDownItem.beats
                                              .length -
                                          index],
                                      border:
                                          Border.all(color: Colors.black)),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    /// remove from list
                                    widget.removeBeat(widget.beats[index]);
                                  },
                                  child: hi.Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),),
                      ),
                    ),
                  );
                }).reversed,
                ...List.generate(
                  widget.selectedDropDownItem.beats.length,
                  (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: hi.Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.selectedDropDownItem.beats[index]
                                          .beatName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${widget.selectedDropDownItem.beats[index].outlet.length} Outlets",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Expanded(child: hi.Container()),
                              hi.Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorIndex[
                                        colorIndex.length - 1 - index],
                                    border: Border.all(color: Colors.black)),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Center(
            child: hi.Container(
              clipBehavior: Clip.hardEdge,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1))
                  ]),
              child: RawMaterialButton(
                onPressed: () {
                  if (widget.selectedDropDownItem.distributorName.isNotEmpty) {
                    if ("Select Distributor" !=
                        widget.selectedDropDownItem.distributorName) {
                      if (!isDisabled) {
                        setState(() {
                          isDisabled = true;
                        });
                        BeatService()
                            .updateOutlets(widget.beats,
                                widget.selectedDropDownItem.id, context)
                            .then((value) {
                          setState(() {
                            isDisabled = false;
                          });
                          while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return GetOutletScreen(1000000);
                          }));
                        });
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
                },
                child: Center(
                  child: isDisabled
                      ? CircularProgressIndicator()
                      : Text(
                          "CONFIRM",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
          //SizedBox(height: 0,)
        ],
      ),
    );
  }
}
