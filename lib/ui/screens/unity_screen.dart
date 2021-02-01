import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:realiteye/generated/locale_keys.g.dart';

// Unity plugin requires strings, so colors are directly represented in this type
final List<String> colorStrings = ['255,0,0', '0,255,0', '0,0,255', '255,255,0'];

class UnityScreen extends StatefulWidget {
  @override
  _UnityScreenState createState() => _UnityScreenState();

  UnityScreen({Key key}) : super(key: key);
}

class _UnityScreenState extends State<UnityScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool _modelPlaced = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        unloadAssetBundle();
        _unityWidgetController.unload();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(LocaleKeys.unity_title.tr()),
        ),
        body: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: onUnityCreated(args['bundlePath']),
              isARScene: true,
              onUnityMessage: onUnityMessage,
              onUnitySceneLoaded: onUnitySceneLoaded,
              fullscreen: false,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildButtomCardWidget(_modelPlaced),
            ),
          ],
        ),
      ),
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

  // Communication from Flutter to Unity
  void changeModelColor(String encodedColor) {
    _unityWidgetController.postMessage(
      'ObjectSpawner',
      'ChangeColor',
      encodedColor,
    );
  }
  
  void unloadAssetBundle() {
    _unityWidgetController.postMessage(
      'ObjectSpawner',
      'UnloadAssetBundle',
      'noParamActuallyNeededButThisLibraryIsStupid'
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
    if (message.toString() == 'model placed') {
      setState(() {
        _modelPlaced = true;
      });
    }
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
  void onUnitySceneLoaded(SceneLoaded sceneInfo) {
    print('Received scene loaded from unity: ${sceneInfo.name}');
    print('Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
  }

  Widget _buildButtomCardWidget(bool modelPlaced) {
    if (modelPlaced) {
      return Card(
        elevation: 10,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Text(LocaleKeys.unity_color_picker_title.tr()),
            SizedBox(
              height: 70,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.format_color_reset),
                        onPressed: () => changeModelColor('default')
                      ),
                      SizedBox(width: 20,),
                      Expanded(child: Scrollbar(
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
                          separatorBuilder: (context, index) => SizedBox(width: 12,),
                        )
                      ))
                    ],
                  )
              ),
            )
          ],
        ),
      );
    }
    else {
      return Card(
        elevation: 10,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.unity_ar_hint.tr(),
            style: TextStyle(color: Colors.white),
          ),
        )
      );
    }
  }
}