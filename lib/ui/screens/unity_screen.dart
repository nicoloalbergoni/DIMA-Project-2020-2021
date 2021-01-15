import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:realiteye/generated/locale_keys.g.dart';

// Unity plugin requires strings, so colors are directly represented in this type
final List<String> colorStrings = ['255,0,0', '0,255,0', '0,0,255'];

class UnityScreen extends StatefulWidget {
  @override
  _UnityScreenState createState() => _UnityScreenState();

  UnityScreen({Key key}) : super(key: key);
}

class _UnityScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(LocaleKeys.unity_title.tr()),
      ),
        body: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityViewCreated: onUnityCreated(args['bundlePath']),
              isARScene: true,
              onUnityMessage: onUnityMessage,
              onUnitySceneLoaded: onUnitySceneLoaded,
              onUnityUnloaded: onUnityUnloaded,
              fullscreen: false,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text("Choose a color:"),
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Scrollbar(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: colorStrings.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<int> cValues = colorStrings[index].split(',')
                                  .map((e) => int.parse(e)).toList();
                              Color c = Color.fromRGBO(cValues[0], cValues[1], cValues[2], 1);

                              return InkWell(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: c,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                ),
                                onTap: () => changeModelColor(colorStrings[index]),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(width: 10,),
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );/*,
    );*/
  }

  // Communication from Flutter to Unity
  // void setObjPosition(String speed) {
  //   _unityWidgetController.postMessage(
  //     'Cube',
  //     'setObjPosition',
  //     speed,
  //   );
  // }

  // Communication from Flutter to Unity
  void setupModelBundle(String bundlePath) {
    _unityWidgetController.postMessage(
      'ObjectSpawner',
      'SetupObject',
      bundlePath,
    );
  }

  // Communication from Flutter to Unity
  void changeModelColor(String encodedColor) {
    _unityWidgetController.postMessage(
      'ObjectSpawner',
      'ChangeColor',
      encodedColor,
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(UnityWidgetController controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  /// Closure that generates the callback that connects the created controller
  /// to the Unity controller. A closure is required because the unity plugin
  /// callback accepts only the controller that is passed by the Unity instance.
  void Function(UnityWidgetController) onUnityCreated(String bundlePath) {
    return (controller) {
      this._unityWidgetController = controller;
      setupModelBundle(bundlePath);
    };
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(UnityWidgetController controller, {
        int buildIndex, bool isLoaded, bool isValid, String name}) {
    print('Received scene loaded from unity: $name');
    print('Received scene loaded from unity buildIndex: $buildIndex');
  }

  void onUnityUnloaded(UnityWidgetController controller) async {
    print('Unity unload fired');
    await controller.silentQuitPlayer();
  }

}