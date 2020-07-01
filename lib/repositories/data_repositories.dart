import 'dart:async';

import 'package:coronavirus_rest_api_flutter_project/data_cache/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/network/api_service.dart';
import 'package:coronavirus_rest_api_flutter_project/network/endpoint_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'endpoints_data.dart';

class DataRepository {
  final APIService apiService;
  final DataCacheService dataCacheService;
  DataRepository({@required this.apiService, this.dataCacheService});

  String _accessToken;

  Future<EndpointData> getEndpointDataFromDataRep(Endpoint endpoint) async =>
      await _getRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

  Future<EndPointDataModel> getAllEndPointDataFromDataRep() async {
    final endpointsData = await _getRefreshingToken<EndPointDataModel>(
        //onGetData: () => getAllEndpointData()
        onGetData:
            _getAllEndpointData //since the two functions have the same signature, we can remove the brackets
        );
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  EndPointDataModel getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndPointDataModel> _getAllEndpointData() async {
    final val = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndPointDataModel(reqValues: {
      Endpoint.cases: val[0],
      Endpoint.casesConfirmed: val[1],
      Endpoint.casesSuspected: val[2],
      Endpoint.deaths: val[3],
      Endpoint.recovered: val[4]
    });
  }

  Future<T> _getRefreshingToken<T>({Future<T> Function() onGetData}) async {
    // uncomment to verify generic alert dialog
    // throw 'error';
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }
}
