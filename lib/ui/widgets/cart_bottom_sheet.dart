import 'package:flutter/material.dart';
import 'package:realiteye/view_models/cart_screen_vm.dart';

class CartBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Add custom BottomSheet Theme (if needed)
    return Container(
      height: 350,
      padding: EdgeInsets.only(left: 10, right: 15, top: 10),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.red[500],
      //   ),
      //   borderRadius: BorderRadius.all(Radius.circular(20)),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            //alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Details",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  "999\$",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Container(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 33,
              itemBuilder: (context, index) {
                return Container(
                  height: 20,
                  //padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Item name  $index xQuantity",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              },
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            height: 50,
            //padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Address Informations:",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 3,),
                Text(
                  "Via test, città test, etc..",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            //padding: EdgeInsets.only(left: 10),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Informations:",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 3,),
                Text(
                  "Via test, città test, etc..",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {},
              color: Theme.of(context).primaryColor,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(18.0),
              // ),
              child: Text("Confirm order"),
            ),
          ),
        ],
      ),
    );
  }
}
