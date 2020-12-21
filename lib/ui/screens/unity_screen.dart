import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:realiteye/generated/locale_keys.g.dart';

class UnityScreen extends StatefulWidget {
  final String bundlePath;
  @override
  _UnityScreenState createState() => _UnityScreenState();

  UnityScreen({Key key, @required this.bundlePath}) : super(key: key);
}

class _UnityScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(LocaleKeys.unity_title.tr()),
      ),
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityViewCreated: onUnityCreated,
                isARScene: true,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("Rotation speed:"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                          setObjPosition(value.toString());
                        },
                        value: _sliderValue,
                        min: 0,
                        max: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );/*,
    );*/
  }

  // Communication from Flutter to Unity
  void setObjPosition(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'setObjPosition',
      speed,
    );
  }

  // Communication from Flutter to Unity
  void setupModelBundle(String bundlePath) {
    _unityWidgetController.postMessage(
      'ObjectSpawner',
      'SetupObject',
      bundlePath,
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
    setupModelBundle(widget.bundlePath);
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(
      controller, {
        int buildIndex,
        bool isLoaded,
        bool isValid,
        String name,
      }) {
    print('Received scene loaded from unity: $name');
    print('Received scene loaded from unity buildIndex: $buildIndex');
  }

}