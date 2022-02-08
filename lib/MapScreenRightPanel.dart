import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/DistributorService.dart';


class MapScreenRightPanel extends StatefulWidget {
  const MapScreenRightPanel({Key? key}) : super(key: key);

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
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            color: Colors.white,
            child: DropdownSearch<String>(
                showSearchBox: true,
                mode: Mode.MENU,
                items: const [
                  "Brazil",
                  "Italia (Disabled)",
                  "Tunisia",
                  'Canada'
                ],
                hint: "Select Distibutor",
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: print,
                selectedItem: "Brazil"),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Beats",
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: (){
                      //single tap funtion
                    },
                    onDoubleTap: (){
                      // double tap function

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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: const [
                                Text("Name of beat:",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Number of outlets:", style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: (){
                                /// remove from list
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
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
              },
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
              child: const Center(child: Text("Confirm", style: TextStyle(color: Colors.white),)),
            ),
          )
        ],
      ),
    ) ;
  }
}