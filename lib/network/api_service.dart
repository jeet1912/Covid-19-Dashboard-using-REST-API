import 'dart:convert';

import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/network/endpoint_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  final API api;

  APIService({this.api});

  // ignore: missing_return
  Future<String> getAccessToken() async {
    final response = await http.post(api.tokenURI().toString(),
        headers: {'Authorization': 'Basic ${api.apiKey}'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    } else {
      print(
          'Request ${api.tokenURI()} failed\n Response: ${response.statusCode} ${response.reasonPhrase}');
      throw response;
    }
  }

  // ignore: missing_return
  Future<EndpointData> getEndpointData(
      {@required String accessToken, @required Endpoint endpoint}) async {
    final uri = api.endpointURI(endpoint);
    final response = await http
        .get(uri.toString(), headers: {'Authorization': 'Bearer $accessToken'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // list of maps
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseKeys[endpoint];
        final String dateString = endpointData['date'];
        final date = DateTime.tryParse(dateString);
        final int result = endpointData[responseJsonKey];
        if (result != null) {
          return EndpointData(value: result, date: date);
        }
      }
    }
    print(
        'Request $uri failed \n Response: ${response.statusCode} ${response.reasonPhrase}');
  }

  static Map<Endpoint, String> _responseKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
