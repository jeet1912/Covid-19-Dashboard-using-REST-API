import 'dart:io';

import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_flutter_project/repositories/endpoints_data.dart';

import 'package:coronavirus_rest_api_flutter_project/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter_project/ui/last_updated.dart';
import 'package:coronavirus_rest_api_flutter_project/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndPointDataModel _endPointDataModel;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endPointDataModel = dataRepository.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final alldata = await dataRepository.getAllEndPointDataFromDataRep();
      setState(() => _endPointDataModel = alldata);
    } on SocketException catch (_) {
      showAlertDialog(
          context: context,
          title: 'Connectionion Error',
          content: 'Could not retrieve data',
          defaultActionText: 'OK');
    }
    // handles rethrow; generic alert dialog - 1)4xx,5xx from servers 2)Parsing errors
    catch (_) {
      showAlertDialog(
          context: context,
          title: 'Unkown Error',
          content: 'Please contact support or try again later',
          defaultActionText: 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormatter(
        date:
            //using conditional member access operator to handle NoSuchMetthodError
            //todo : handle null values in getData in data_cache_service
            _endPointDataModel != null ? _endPointDataModel.cases?.date : null);

    return Scaffold(
      appBar: AppBar(
        title: Text("Coronavirus Tracker"),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.04),
                  child: LastUpdated(
                    text: formattedDate.lastUpdatedStatus(),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    for (var endpoint in Endpoint.values)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        child: EndPointCard(
                          endpoint: endpoint,
                          value: _endPointDataModel != null
                              //using conditional member access operator to handle NoSuchMetthodError
                              ? _endPointDataModel.reqValues[endpoint]?.value
                              : null,
                        ),
                      ),
                  ],
                ),
              ]),
        ]),
      ),
    );
  }
}
