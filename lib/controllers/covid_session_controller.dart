import 'dart:async';
import 'dart:convert';

import 'package:book_my_slot/models/session.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CovidSessionAvailabilityController extends GetxController {
  var currentTime = '...................................'.obs;
  var stopStream = false.obs;
  var pinCode = '110084'.obs;
  var date = '30-07-2021'.obs;
  //cowin api calls function
  int apiCalled = 0;
  Stream<CovidSession> fetchSlotsForPincodeAndDateProvided() async* {
    //api limit
    //100 API calls per 5 minutes per IP
    //means 20 API calls per minute per IP
    if (!stopStream.value) {
      while (!stopStream.value) {
        final response = await http.get(Uri.parse(
            "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pinCode&date=$date"));
        if (response.statusCode == 200) {
          print('api called $apiCalled times');
          apiCalled++;
          yield CovidSession.fromJson(jsonDecode(response.body));
          currentTime.value = DateTime.now().toString(); //set the current time
        } else {
          //print error code
          print('${response.statusCode}');
          break; //break stream if some error occurs
        }
        //delay the api as COWIN api has a cap mention on line `[16]`
        await Future.delayed(Duration(seconds: 30));
      }
    } else {
      yield* Stream.empty();
    }
  }
}
