import 'package:coronavirus_rest_api_flutter_project/network/api_key.dart';
import 'package:flutter/foundation.dart';

enum Endpoint { cases, casesSuspected, casesConfirmed, deaths, recovered }

class API {
  final String apiKey;

  API({@required this.apiKey});

  factory API.adminsandbox() => API(apiKey: ApiKey.ncovSandBoxAuthKey);

  static final String host = 'ncov2019-admin.firebaseapp.com';
  Uri tokenURI() => Uri(scheme: 'https', host: host, path: 'token');

  Uri endpointURI(Endpoint endpoint) =>
      Uri(scheme: 'https', host: host, path: '/${_paths[endpoint]}');
  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.casesSuspected: 'casesSuspected',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered'
  };
}
