import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


class MapScreenRightPanel extends StatefulWidget {
  const MapScreenRightPanel({Key? key}) : super(key: key);

  @override
  _MapScreenRightPanelState createState() => _MapScreenRightPanelState();
}

class _MapScreenRightPanelState extends State<MapScreenRightPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distributor",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            DropdownSearch<String>(
                showSearchBox: true,
                mode: Mode.MENU,
                items: [
                  "Brazil",
                  "Italia (Disabled)",
                  "Tunisia",
                  'Canada'
                ],
                hint: "Select Distibutor",
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: print,
                selectedItem: "Brazil"),
            SizedBox(
              height: 12,
            ),
            Text(
              "Beats",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 2),
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
                                Text("Name of beat:",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("Number of outlets:",)
                              ],
                            ),
                            Expanded(child: Container()),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.1))
                    ]),
                child: Center(child: Text("Confirm")),
              ),
            )
          ],
        ),
      ),
    ) ;
  }
}
