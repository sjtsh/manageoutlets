import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Services/UserService.dart';

import '../../DialogBox/backButtonAlert.dart';
import '../../DialogBox/renameBeatNameDialog.dart';
import '../../backend/Entities/Distributor.dart';
import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/database.dart';

class BeatWidgets extends StatefulWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final Function removeBeat;
  final List<User> users;
  final Distributor selectedDropdownItem;

  BeatWidgets(
    this.beat,
    this.changeColor,
    this.index,
    this.renameBeat,
    this.removeBeat,
    this.users,
    this.selectedDropdownItem
  );

  @override
  State<BeatWidgets> createState() => _BeatWidgetsState();
}

class _BeatWidgetsState extends State<BeatWidgets> {
  User? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: SizedBox(
        width: 400,
        child: GestureDetector(
          onTap: () {},
          onDoubleTap: () {
            // double tap function
          },
          child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.beat.beatName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${widget.beat.outlet.where((element) => !element.deactivated).toList().length} Outlets, ",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return List.generate(
                          colorIndex.length,
                          (index) => PopupMenuItem(
                                child: Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorIndex[index],
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                ),
                                value: colorIndex[index],
                              ));
                    },
                    initialValue: widget.beat.color,
                    onSelected: (Color value) {
                      widget.changeColor(value, widget.index);
                      // widget.refresh();
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.beat.color,
                          border: Border.all(color: Colors.black)),
                    ),
                    tooltip: "Show colors",
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.edit,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      /// remove from list
                      //  widget.removeBeat(widget.beats[index]);
                      showDialog(
                        builder: (_) {
                          return BackButtonAlert(
                              "Your progress will be lost.", "REMOVE", "CANCEL",
                              () {
                            widget.removeBeat(widget.beat);
                          });
                        },
                        context: context,
                      );
                    },
                    child: Container(
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
                  Container(
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
