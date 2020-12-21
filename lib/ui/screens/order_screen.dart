import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/order_card.dart';

class OrderScreen extends StatelessWidget {
  final List _testList = [1,2,3,4,5,6,7,8];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Orders'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'In progress',),
                Tab(text: 'Completed',),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard();
                    }
              ),
              ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard();
                    }
              ),
            ],
          ),
        )
    );
  }
}
