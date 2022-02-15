import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

import 'CompareInteractive.dart';
import 'InteractiveImage.dart';
import 'NextScreen.dart';
import 'backButtonAlert.dart';
import 'backend/Entities/Category.dart';
import 'backend/Entities/Outlet.dart';
import 'backend/Entities/OutletsListEntity.dart';
import 'backend/database.dart';

class SingularOutletNonMerging extends StatelessWidget {
  final List<Outlet> selectedOutlet;
  final Outlet tempOutlet;
  final TextEditingController controller;
  final Function changeOutletSelectionStatus;
  final bool isValidate;
  final List<Category> categories;
  final Function setCategoryID;
  final Beat tempBeat;
  final int i;

  SingularOutletNonMerging(
      this.selectedOutlet,
      this.tempOutlet,
      this.controller,
      this.changeOutletSelectionStatus,
      this.isValidate,
      this.categories,
      this.setCategoryID,
      this.tempBeat,
      this.i);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedOutlet.contains(tempOutlet)
                ? Colors.green
                : Colors.transparent,
            width: selectedOutlet.contains(tempOutlet) ? 5 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                spreadRadius: 2,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.1))
          ],
        ),
        child: GestureDetector(
          onTap: () {
            changeOutletSelectionStatus(tempOutlet);
          },
          child: Stack(
            children: [
              Column(children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Checkbox(
                        activeColor: Colors.green,
                        value: selectedOutlet.contains(tempOutlet),
                        onChanged: (newValue) =>
                            changeOutletSelectionStatus(selectedOutlet)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: HoverWidget(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            color: Colors.white,
                            child: TextField(
                              autofocus: false,
                              controller: controller,
                              onChanged: (String? text) {
                                tempOutlet.outletName = text ?? "";
                              },
                              decoration: InputDecoration(
                                errorText:
                                    (controller.text == "" && !isValidate)
                                        ? 'Field Can\'t Be Empty'
                                        : null,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        hoverChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            color: Colors.grey.shade200,
                            child: TextField(
                              controller: controller,
                              onChanged: (String? text) {
                                tempOutlet.outletName = text ?? "";
                              },
                              decoration: InputDecoration(
                                errorText:
                                    (controller.text == "" && !isValidate)
                                        ? 'Field Can\'t Be Empty'
                                        : null,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        onHover: (PointerEnterEvent event) {},
                      ),
                    ),

                    // Text(tempOutlet.outletName),
                    // Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 50,
                        child: Builder(builder: (context) {
                          return DropdownSearch<Category>(
                            showSearchBox: true,
                            mode: Mode.MENU,
                            dropdownButtonSplashRadius: 1,
                            dropDownButton: SizedBox.shrink(),
                            items: categories,
                            onChanged: (Category? category) {
                              setCategoryID(category);
                            },
                            selectedItem: (tempOutlet.newcategoryID == null)
                                ? Category("Select category", 10000000)
                                : categories.firstWhere(
                                    (e) => e.id == tempOutlet.newcategoryID!),
                            dropdownSearchDecoration: InputDecoration(
                                errorText: (tempOutlet.newcategoryID == null &&
                                        !isValidate)
                                    ? "define category"
                                    : null,
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder()),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BackButtonAlert(
                                  "Do you want to deactivate this outlet?",
                                  "CANCEL",
                                  "REMOVE");
                            });
                      },
                      child: const Icon(
                        Icons.clear,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return InteractiveImage(selectedOutlet, tempBeat, i, controller,
                              categories, isValidate);
                        }));
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: Image.network(
                            tempBeat.outlet[i].videoName == null
                                ? tempBeat.outlet[i].imageURL
                                : localhost +
                                tempBeat.outlet[i].imageURL,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              ]),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: tempOutlet.videoName == null
                          ? Colors.red
                          : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1))
                      ],
                    ),
                    child: Center(
                      child: Text(
                        tempOutlet.videoName == null ? "FA" : "SC",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
