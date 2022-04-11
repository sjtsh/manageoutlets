import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:latlng/latlng.dart';
import 'package:path_provider/path_provider.dart';

import '../backend/Entities/Distributor.dart';
import '../backend/Services/DistributorService.dart';

class CreateDistributorDialogBox extends StatefulWidget {
  Function addDistributor;

  CreateDistributorDialogBox(this.addDistributor);

  @override
  State<CreateDistributorDialogBox> createState() =>
      _CreateDistributorDialogBoxState();
}

class _CreateDistributorDialogBoxState
    extends State<CreateDistributorDialogBox> {
  TextEditingController newDistributorController = TextEditingController();

  List<LatLng> boundary = [];
  bool isDisabled=false;
  String? path;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          height: 250,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "CREATE DISTRIBUTOR",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: newDistributorController,
                  decoration: InputDecoration(
                      labelText: "Distributor's Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                SizedBox(
                  height: 12,
                ),
                DottedBorder(
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        allowedExtensions: [
                          "gpx",
                          "GPX",
                        ],
                      );
                      String? path = result!.files[0].path;
                      if (path != null) {
                        setState(() {
                          this.path = path;
                        });
                        String contents = await File(path).readAsString();
                        Gpx a = GpxReader().fromString(contents);
                        for (var trkseg in a.trks) {
                          for (var trkpt in trkseg.trksegs) {
                            for (var i in trkpt.trkpts) {
                              if (i.lat != null && i.lon != null) {
                                boundary.add(LatLng(i.lat!, i.lon!));
                              }
                            }
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      child: Center(
                        child: path == null
                            ? Text(
                                "upload gpx",
                                style: TextStyle(color: Colors.green),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(path ?? "upload gpx",
                                      style: TextStyle(color: Colors.green)),
                                  Text(
                                      boundary.length.toString() +
                                          " offsets found",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                      ),
                    ),
                  ),
                  color: Colors.green,
                ),
                SizedBox(
                  height: 12,
                ),
                MaterialButton(
                  color: Colors.green,
                  height: 60,
                  onPressed: () async {
                    if(!isDisabled){
                      if (newDistributorController.text != "") {
                        try {
                          if (boundary.isNotEmpty) {
                            setState(() {
                              isDisabled = true;
                            });
                            Distributor dis = await DistributorService()
                                .createDistributor(
                                    newDistributorController.text, boundary);
                            widget.addDistributor(dis);
                            setState(() {
                              isDisabled = false;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Choose a gpx file")));
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Unsuccessful")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fill in the field")));
                      }
                    }
                    setState(() {
                      isDisabled = false;
                    });
                  },
                  child: Center(
                    child: isDisabled ?CircularProgressIndicator():Text(
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
  }
}
