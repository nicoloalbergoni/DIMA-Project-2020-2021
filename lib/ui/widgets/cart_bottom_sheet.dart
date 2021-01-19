import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/firebase_doc_future_builder.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';

class CartBottomSheet extends StatefulWidget {

  final List<CartItem> cartItems;
  final Map<String, DocumentSnapshot> documentList;
  final String uid;

  CartBottomSheet(this.cartItems, this.documentList, this.uid);

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();

}

class _CartBottomSheetState extends State<CartBottomSheet> {
  String _addressDropDownValue;
  String _paymentDropDownValue;

  double _getTotalPrice() {
    double totalPrice = 0;
    widget.documentList.forEach((_, value) {
      totalPrice += value['discounted_price'];
    });

    return totalPrice;
  }

  List<String> _getOrderRecapStrings() {
    List<String> orderStrings = [];
    widget.cartItems.forEach((element) {
      orderStrings.add(
          "${widget.documentList[element.productId.id].data()['name']}   x${element.quantity}");
    });

    return orderStrings;
  }

  List<String> _getUserAddresses(Map<String, dynamic> data) {
    List<String> userAddresses = [];
    data['addresses'].forEach((address) {
      userAddresses.add(
          "${address['street']}, ${address['city']}, ${address['state']}, ${address['zip_code']}");
    });

    return userAddresses;
  }

  List<String> _getUserPayments(Map<String, dynamic> data) {
    List<String> userPayments = [];
    data['payment_methods'].forEach((payment) {
      userPayments.add(
          "${payment['CC_number']}, ${formatDate(payment['CC_expiry_date'])}");
    });

    return userPayments;
  }

  @override
  Widget build(BuildContext context) {
    List<String> orderStrings = _getOrderRecapStrings();

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
        mainAxisSize: MainAxisSize.max,
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
                  "${_getTotalPrice().toStringAsFixed(2)}\$",
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
              itemCount: orderStrings.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 20,
                  //padding: EdgeInsets.only(left: 10),
                  child: Text(
                    orderStrings[index],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              },
            ),
          ),
          Divider(
            thickness: 1,
          ),
          FirebaseDocFutureBuilder(
            getUserDocument(widget.uid),
                (data) {
              List<String> userAddresses = _getUserAddresses(data);
              List<String> userPayments = _getUserPayments(data);

              return Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    //padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address Information:",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          underline: SizedBox(), // Remove underline
                          // Sort of work-around because apparently you cannot set the initial value for
                          // the dropdown inside this FutureBuilder via setState
                          value: _addressDropDownValue == null ? userAddresses.first : _addressDropDownValue,
                          items: userAddresses.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _addressDropDownValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 50,
                    //padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Information:",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          underline: SizedBox(),
                          value: _paymentDropDownValue == null ? userPayments.first : _paymentDropDownValue,
                          items: userPayments.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _paymentDropDownValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () async {
                //Clear the remote-cart
                await addOrderFromCartData(widget.uid, widget.cartItems, widget.documentList, _getTotalPrice(), _addressDropDownValue);
                //Clear the local-cart
                StoreProvider.of<AppState>(context).dispatch(ClearCartItemList());
                //Close the BottomSheet
                Navigator.pop(context);
              },
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
