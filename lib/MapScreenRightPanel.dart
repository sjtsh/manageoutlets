import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/NextScreen.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:manage_outlets/backend/shortestPath.dart';

import 'backend/Entities/Distributor.dart';

import 'Entity/OutletsListEntity.dart';
import 'backend/database.dart';

class MapScreenRightPanel extends StatefulWidget {
  final List<Category> categories;
  final List<Beat> beats;
  final Function removeBeat;
  final List<Distributor> distributors;
  final Distributor selectedDropDownItem;
  final Function _changeDropDownValue;

  MapScreenRightPanel(
    this.categories,
    this.distributors,
    this.beats,
    this.removeBeat,
    this.selectedDropDownItem,
    this._changeDropDownValue,
  );

  @override
  _MapScreenRightPanelState createState() => _MapScreenRightPanelState();
}

class _MapScreenRightPanelState extends State<MapScreenRightPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
          Container(
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
                      onTap: () {
                        //single tap funtion
                      },
                      onDoubleTap: () {
                        // double tap function
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return NextScreen(
                              widget.beats[index], widget.categories);
                        }));
                      },
                      child: Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.beats[index].beatName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${widget.beats[index].outlet.length} Outlets",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorIndex[index],
                                    border: Border.all(color: Colors.black)),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  /// remove from list
                                  widget.removeBeat(widget.beats[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                ...List.generate(
                  widget.selectedDropDownItem.beats.length,
                  (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          //single tap funtion
                        },
                        onDoubleTap: () {
                          // double tap function
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return NextScreen(
                                widget.selectedDropDownItem.beats[index],
                                widget.categories);
                          }));
                        },
                        child: Container(
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
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${widget.selectedDropDownItem.beats[index].outlet.length} Outlets",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                Expanded(child: Container()),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorIndex[
                                          widget.beats.length + index],
                                      border: Border.all(color: Colors.black)),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
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
            child: Container(
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
              child: const Center(
                  child: Text(
                "CONFIRM",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          //SizedBox(height: 0,)
        ],
      ),
    );
  }
}
