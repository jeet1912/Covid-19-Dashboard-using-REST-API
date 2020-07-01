import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/repositories/endpoints_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndPointCard extends StatelessWidget {
  final Endpoint endpoint;
  final int value;

  const EndPointCard({Key key, this.endpoint, this.value}) : super(key: key);

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  static Map<Endpoint, EndpointCardData> _cardData = {
    Endpoint.cases: EndpointCardData(
        assetName: "assets/count.png",
        color: Color(0xFFFFF492),
        title: 'Cases'),
    Endpoint.casesConfirmed: EndpointCardData(
        assetName: "assets/fever.png",
        color: Color(0xFFE99600),
        title: 'Confirmed cases'),
    Endpoint.casesSuspected: EndpointCardData(
        assetName: "assets/suspect.png",
        color: Color(0xFFEEDA28),
        title: 'Suspected cases'),
    Endpoint.deaths: EndpointCardData(
        assetName: "assets/death.png",
        color: Color(0xFFE40000),
        title: 'Deaths'),
    Endpoint.recovered: EndpointCardData(
        assetName: "assets/patient.png",
        color: Color(0xFF70A901),
        title: 'Recovered'),
  };
  @override
  Widget build(BuildContext context) {
    final cardData = _cardData[endpoint];
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.008,
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white10,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.008,
                horizontal: MediaQuery.of(context).size.width * 0.04),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cardData.title,
                      style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)
                          .copyWith(color: cardData.color)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        cardData.assetName,
                        color: cardData.color,
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Text(
                        formattedValue != null ? formattedValue.toString() : '',
                        style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.035,
                                fontWeight: FontWeight.w500)
                            .copyWith(color: cardData.color),
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
