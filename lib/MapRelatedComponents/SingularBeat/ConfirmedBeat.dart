import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Services/BeatService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../../DialogBox/backButtonAlert.dart';
import '../../DialogBox/renameBeatNameDialog.dart';
import '../../ExcelExport.dart';
import '../../backend/Entities/Distributor.dart';
import '../../backend/Entities/Outlet.dart';
import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/database.dart';

class ConfirmedBeat extends StatelessWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final List<User> users;
  final List<Distributor> distributors;

  ConfirmedBeat(this.beat, this.changeColor, this.index, this.renameBeat,
      this.users, this.distributors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return RenameBeatNameDialog(beat, renameBeat, distributors);
              });
        },
        child: SizedBox(
          width: 400,
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

                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(beat.beatName.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${beat.outlet.where((element) => !element.deactivated).toList().length} Outlets, ${users.firstWhere((e) => beat.userID == e.id).name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),),
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
                    initialValue: beat.color,
                    onSelected: (Color value) {
                      changeColor(value, beat);
                      // widget.refresh();
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: beat.color,
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                      onPressed: () async {
                        String distributorName = distributors
                            .firstWhere(
                                (element) => element.beats[index].id == beat.id)
                            .toString();
                        List<String> disname = [distributorName + beat.beatName];
                        String fileName =
                            "${distributorName} ${beat.beatName}.csv";
                        List<List<dynamic>> outletTocsv =
                            List.empty(growable: true);
                        outletTocsv.add(disname);
                        outletTocsv.add(OutletColumnList);
                        for (int a = 0; a < beat.outlet.length; a++) {
                          List<dynamic> row = List.empty(growable: true);
                          row.add(a + 1);
                          row.add("${beat.outlet[a].beatID}");
                          row.add("${beat.outlet[a].id}");
                          row.add("${beat.outlet[a].outletName}");
                          row.add("${beat.outlet[a].categoryName}");
                          row.add("${beat.outlet[a].categoryID}");
                          row.add("${beat.outlet[a].newcategoryID}");
                          row.add("${beat.outlet[a].lat}");
                          row.add("${beat.outlet[a].lng}");
                          row.add("${beat.outlet[a].videoID}");
                          row.add("${beat.outlet[a].videoName}");
                          row.add("${beat.outlet[a].dateTime}");
                          row.add("${beat.outlet[a].imageURL}");
                          row.add("${beat.outlet[a].marker}");
                          row.add("${beat.outlet[a].md5}");
                          row.add("${beat.outlet[a].deactivated}");
                          outletTocsv.add(row);
                        }

                        String? outputFiles =
                            await FilePicker.platform.saveFile(
                          dialogTitle: 'Please select Directory:',
                          fileName: fileName,
                        );
                        File csvFile = File(outputFiles!);
                        String csv =
                            const ListToCsvConverter().convert(outletTocsv);
                        if (outputFiles != null) {
                          csvFile.writeAsString(csv);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("File Downloaded: $outputFiles")));
                        }
                      },
                      icon: Icon(Icons.download_outlined, color: Colors.white)),
                  const SizedBox(
                    width: 12,
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
