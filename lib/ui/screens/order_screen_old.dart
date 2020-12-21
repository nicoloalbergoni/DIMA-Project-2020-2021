import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/order_card.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class OrderScreenOld extends StatefulWidget {
  @override
  _OrderScreenOldState createState() => _OrderScreenOldState();
}

class _OrderScreenOldState extends State<OrderScreenOld> {
  List _testList = [1,2,3,4,5,6,7,8];
  bool _inProgressVisibility = true;
  bool _completedVisibility = false;

  void _switchInProgressVisibility() {
    setState(() {
      _inProgressVisibility = !_inProgressVisibility;
    });
  }

  void _switchCompletedVisibility() {
    setState(() {
      _completedVisibility = !_completedVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Orders"),
        drawer: SideMenu(),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 8,),
                Text('In progress',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(flex: 1,),
                IconButton(icon: (_inProgressVisibility)
                    ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                    onPressed: _switchInProgressVisibility)
              ],
            ),
            Divider(thickness: 2.0,),
            Visibility(
                visible: _inProgressVisibility,
                child: Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _testList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderCard();
                      }),
                )
            ),
            // TODO: Refactor this into a widget, it's the same of above group
            Row(
              children: [
                SizedBox(width: 8,),
                Text('Completed',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(flex: 1,),
                IconButton(icon: (_completedVisibility)
                    ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                    onPressed: _switchCompletedVisibility)
              ],
            ),
            Divider(thickness: 2.0,),
            Visibility(
                visible: _completedVisibility,
                child: Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _testList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderCard();
                      }),
                )
            )
          ],
        )
    );
  }
}

