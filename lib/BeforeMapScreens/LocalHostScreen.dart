import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_outlets/backend/Services/versionCheckService.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:yaml/yaml.dart';
import 'GetOutletScreen.dart';
class StartButtonIntent extends Intent{}
class LocalHostScreen extends StatelessWidget {
  LocalHostScreen({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController(text: localhost);

  @override
  Widget build(BuildContext context) {

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): StartButtonIntent()},
      actions: {
        StartButtonIntent: CallbackAction(onInvoke: (intent) {
          Navigator.push(context,
              PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => GetOutletScreen(10000000000),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 500)));
        })
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              SvgPicture.asset(
                "assets/hilifelogo.svg",
              ),
              Container(
                height: 50,
                width: 200,
                child: TextField(
                  controller: controller,
                  decoration:  InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 200,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Color(0xff00929E),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.1))
                    ]),
                child: Material(
                  color: Color(0xff00929E),
                  child: InkWell(
                    onTap: () {
                      if (controller.text != "") {
                        localhost = controller.text;
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                      //   return GetOutletScreen(1000000);
                      // }));
                      // FutureBuilder(
                      //     future: ,
                      //     builder: (context, snapshot) {
                      //       String version = "Unknown";
                      //       if (snapshot.hasData) {
                      //         var yaml = loadYaml(snapshot.data);
                      //         version = yaml["version"];
                      //       }
                      //
                      //       return Container(
                      //         child: Text(
                      //             'Version: $version'
                      //         ),
                      //       );
                      //     }),

                      VersionCheck().getVersion().then((value) {
                      rootBundle.loadString("pubspec.yaml").then((a){
                        var yaml = loadYaml(a);
                        print((yaml["version"]).toString());

                        if(yaml["version"].toString() == value){


                          Navigator.push(context,
                              PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => GetOutletScreen(10000000000),
                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 500)));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please update application to Version ${yaml["version"]} from $value ")));
                        }
                      });
                      });


                    },
                    child: Center(
                      child: Text(
                        "LOG IN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Expanded(child: Container()),
              SizedBox(height: 32,)
            ],
          ),
        ),
      ),
    );
  }
}
