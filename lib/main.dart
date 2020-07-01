import 'package:coronavirus_rest_api_flutter_project/data_cache/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter_project/network/api.dart';
import 'package:coronavirus_rest_api_flutter_project/network/api_service.dart';
import 'package:coronavirus_rest_api_flutter_project/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_flutter_project/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // since we're waiting in the main()

  Intl.defaultLocale = 'en_GB';
  await initializeDateFormatting();

  final sharedPreferences1 = await SharedPreferences.getInstance();

  runApp(MyApp(
    sharedPreferences: sharedPreferences1,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key key, this.sharedPreferences}) : super(key: key);

// constructor created to pass sharedPreferences, a future type(async) to DataRepository which is in build (works synchronously)

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
          apiService: APIService(api: API.adminsandbox()),
          dataCacheService:
              DataCacheService(sharedPreferences: sharedPreferences)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF101010),
            cardColor: Color(0xFF222222)),
        home: Dashboard(),
      ),
    );
  }
}
