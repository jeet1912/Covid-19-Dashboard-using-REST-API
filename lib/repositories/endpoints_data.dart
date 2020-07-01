import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/network/endpoint_data.dart';
import 'package:flutter/material.dart';

class EndPointDataModel {
  final Map<Endpoint, EndpointData> reqValues;

  EndPointDataModel({@required this.reqValues});

  EndpointData get cases => reqValues[Endpoint.cases];
  EndpointData get casesConfirmed => reqValues[Endpoint.casesConfirmed];
  EndpointData get casesSuspected => reqValues[Endpoint.casesSuspected];
  EndpointData get deaths => reqValues[Endpoint.deaths];
  EndpointData get recovered => reqValues[Endpoint.recovered];

  @override
  String toString() =>
      'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}

class EndpointCardData {
  final String title;
  final String assetName;
  final Color color;

  EndpointCardData(
      {@required this.title, @required this.assetName, @required this.color});
}
