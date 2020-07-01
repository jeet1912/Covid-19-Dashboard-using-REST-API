import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/network/endpoint_data.dart';
import 'package:coronavirus_rest_api_flutter_project/repositories/endpoints_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  //keys for SharedPreferences map
  static String endPointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endPointDateKey(Endpoint endpoint) => '$endpoint/date';

  /*EndPointDataModel : Map<Endpoint,EndpointData>
   Endpoint : enum 
   EndpointData : (int,DateTime)
    */

  // values for SharedPreferences map
  Future<void> setData(EndPointDataModel endpointsdata) async {
    endpointsdata.reqValues.forEach((endpoint, endpointdata) async {
      await sharedPreferences.setInt(
        endPointValueKey(endpoint),
        endpointdata.value,
      );
      await sharedPreferences.setString(
        endPointDateKey(endpoint),
        endpointdata.date.toIso8601String(),
      );
    });
  }

  // fetching data synchronously !
  EndPointDataModel getData() {
    Map<Endpoint, EndpointData> val = {};
    Endpoint.values.forEach((endpoint) {
      final value2 = sharedPreferences.getInt(endPointValueKey(endpoint));
      final dateString = sharedPreferences.getString(endPointDateKey(endpoint));
      if (value2 != null && dateString != null) {
        final date2 = DateTime.tryParse(dateString);
        val[endpoint] = EndpointData(value: value2, date: date2);
      }
    });
    return EndPointDataModel(reqValues: val);
  }
}
