import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/firebase_doc_future_builder.dart';
import 'package:realiteye/ui/widgets/single_card_page_list.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';

final double _textPadding = 4.0;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String uid = getUID(context);
    if (uid == null)
      return Container();

    return Scaffold(
        appBar: CustomAppBar(
          LocaleKeys.account_title.tr(),
        ),
        body: FirebaseDocFutureBuilder(
          getUserDocument(uid),
          (data) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (data['photoURL'] != null)
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(data['photoURL']),
                          )
                        : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100,
                          child: Icon(
                            Icons.account_circle,
                            size: 200,
                          ),
                        ),
                      SizedBox(height: 10,),
                      Text('${data['firstname']} ${data['lastname']}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          ..._buildInfoWidgets(data),

                          SizedBox(height: 24,),
                          Text(LocaleKeys.account_address_title.tr(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 6,),
                          SingleCardPageList(data['addresses'],
                              _buildAddressCardContent,
                              cardHeight: 100
                          ),

                          SizedBox(height: 24,),
                          Text(LocaleKeys.account_payment_title.tr(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 6,),
                          SingleCardPageList(data['payment_methods'],
                              _buildPaymentCardContent,
                              cardHeight: 60
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            );
          }
        )
    );
  }
}

Widget _buildAddressCardContent(Map<String, dynamic> address) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${LocaleKeys.account_address_state.tr()}: ${address['state']}'),
      SizedBox(height: _textPadding,),
      Text('${LocaleKeys.account_address_city.tr()}: ${address['city']}'),
      SizedBox(height: _textPadding,),
      Text('${LocaleKeys.account_address_street.tr()}: ${address['street']}'),
      SizedBox(height: _textPadding,),
      Text('${LocaleKeys.account_address_zip.tr()}: ${address['zip_code']}'),
    ],
  );
}

Widget _buildPaymentCardContent(Map<String, dynamic> payment) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${LocaleKeys.account_payment_card.tr()}: ${payment['CC_number']}'),
      SizedBox(height: _textPadding,),
      Text('${LocaleKeys.account_payment_expiration.tr()}: '
          '${formatDate(payment['CC_expiry_date'])}'),
    ],
  );
}

List<Widget> _buildInfoWidgets(Map<String, dynamic> data) {
  return <Widget>[
    Text('Email: ${data['email']}'),
    SizedBox(height: _textPadding,),
    (data['birth_date'] != null)
        ? Text('${LocaleKeys.account_birthday.tr()}: '
            '${formatDate(data['birth_date'])}')
        : Text('${LocaleKeys.account_birthday.tr()}: ')
  ];
}
