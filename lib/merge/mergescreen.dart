import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:manage_outlets/merge/MergeTrue.dart';
import 'package:manage_outlets/merge/OutletMergeMap.dart';
import 'package:manage_outlets/merge/OutletMergeScreen.dart';

import '../backend/Entities/Outlet.dart';
import 'MergeFalse.dart';

class MergeScreen extends StatefulWidget {
  final List<Beat> beat1;

  MergeScreen(this.beat1);

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen> {
  bool mergeTime = false;

  List<Outlet> outlets = [];
  List flexMap = [1, 4, 2, 2, 2, 2, 1, 1];
  List<int> selected = [];
  int? toBeMergedTo;
  TextEditingController beatController = TextEditingController();
  TextEditingController distributorController = TextEditingController();

  setMerge(bool condition) {
    setState(() {
      mergeTime = condition;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //outlets = widget.outlets1;
  }

  select(int index) {
    setState(() {
      if (!selected.contains(index)) {
        selected.add(index);
      } else {
        selected.remove(index);
      }
    });
  }

  confirmMerge(mergableName, mergableImg, stringid) {
    if (toBeMergedTo != null) {
      print(toBeMergedTo);
      outlets.firstWhere((element) => element.id == toBeMergedTo).outletName =
          outlets
              .firstWhere((element) => element.id == mergableName)
              .outletName;
      outlets.firstWhere((element) => element.id == toBeMergedTo).imageURL =
          outlets.firstWhere((element) => element.id == mergableImg).imageURL;
      List<String> ids = List.generate(
          selected.length, (index) => outlets[selected[index]].id);
      ids.remove(stringid);
      for (String element in ids) {
        outlets.removeWhere((a) => a.id == element);
      }
      selected = [];
      toBeMergedTo = null;
      setState(() {
        mergeTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: mergeTime
          ? Row(
              children: [
                Expanded(
                  child: MergeTrue(
                    widget.beat1,
                    setMerge,
                    outlets,
                    flexMap,
                    selected,
                    toBeMergedTo,
                    confirmMerge,
                  ),
                ),
                Expanded(child: OutletMergeMap())
              ],
            )
          : Expanded(
              child: MergeFalse(
                  widget.beat1,
                  setMerge,
                  outlets,
                  flexMap,
                  selected,
                  toBeMergedTo,
                  beatController,
                  distributorController,
                  select),
            ),
    );
  }
}
