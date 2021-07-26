import 'package:book_my_slot/controllers/covid_session_controller.dart';
import 'package:book_my_slot/models/session.dart';
import 'package:book_my_slot/widgets/customCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class TesterView extends StatefulWidget {
  const TesterView({Key? key}) : super(key: key);

  @override
  _TesterViewState createState() => _TesterViewState();
}

class _TesterViewState extends State<TesterView> {
  CovidSessionAvailabilityController covidSessionAvailabilityController =
      CovidSessionAvailabilityController();

  CovidSession? covidSession;
  String jsonText = '';
  bool stopStreaming = false;
  TextEditingController pinCodeController = TextEditingController();

  //show datePicker to pick date
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      covidSessionAvailabilityController.date.value =
          "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode fcusNode = FocusNode();
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book My Slot'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                'Pincode: ${covidSessionAvailabilityController.pinCode}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Obx(
              () => Text(
                'Start Date: ${covidSessionAvailabilityController.date}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Obx(
              () => Text(
                  'Last Synced : ${covidSessionAvailabilityController.currentTime.value.substring(10, 19)}'),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => !covidSessionAvailabilityController.stopStream.value
                    ? StreamBuilder<CovidSession>(
                        stream: covidSessionAvailabilityController
                            .fetchSlotsForPincodeAndDateProvided(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Some error');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                                'Connecting to CoWIN Api\nPlease Wait ');
                          } else if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            //set the last synced time
                            //check if there is any data at all
                            DateTime.now().toString();
                            if (snapshot.data!.centers!.length == 0) {
                              return Container(
                                width: size.width * 0.95,
                                child: Text(
                                  'No data for this pincode yet on specified date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${snapshot.data!.centers!.length} centers found'),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${snapshot.data!.centers![index].name}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Divider(color: Colors.amber),
                                                Text(
                                                  '${snapshot.data!.centers![index].address}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Text(
                                                  'District ${snapshot.data!.centers![index].districtName}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Text(
                                                    'Pincode: ${snapshot.data!.centers![index].pincode}'),
                                                CustomCardWidget(
                                                  text:
                                                      "Timings:${snapshot.data!.centers![index].from} - ${snapshot.data!.centers![index].to}",
                                                  bgColor: Colors.blueAccent,
                                                ),

                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  color: snapshot
                                                              .data!
                                                              .centers![index]
                                                              .feeType ==
                                                          "Free"
                                                      ? Colors.green
                                                      : Colors.red,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                    child: Text(
                                                      '${snapshot.data!.centers![index].feeType}',
                                                      style: TextStyle(
                                                          //color according to fee type
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),

                                                //show ONLY IF list of  fees if paid (Fees is a list as covishield, covaxin may have diff prices)
                                                if (snapshot
                                                        .data!
                                                        .centers![index]
                                                        .feeType ==
                                                    "Paid")
                                                  for (int i = 0;
                                                      i <
                                                          snapshot
                                                              .data!
                                                              .centers![index]
                                                              .vaccineFees!
                                                              .length;
                                                      i++)
                                                    CustomCardWidget(
                                                      text:
                                                          "${snapshot.data!.centers![index].vaccineFees![i].vaccine} - ₹${snapshot.data!.centers![index].vaccineFees![i].fee}",
                                                      bgColor: Colors.redAccent,
                                                    ),

                                                SizedBox(height: 8),
                                                Text('Vaccination Dates'),
                                                //show no sessions if not available
                                                SizedBox(height: 8),
                                                if (snapshot
                                                        .data!
                                                        .centers![index]
                                                        .sessions!
                                                        .length ==
                                                    0)
                                                  Text('No sessions'),
                                                Container(
                                                  height: 150,
                                                  child: ListView.separated(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (ctx, sessionIndex) {
                                                        return Container(
                                                          width: 150,
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            elevation: 5,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  //show vaccination date
                                                                  customContainerTextWidget(
                                                                      snapshot
                                                                          .data!
                                                                          .centers![
                                                                              index]
                                                                          .sessions![
                                                                              sessionIndex]
                                                                          .date,
                                                                      5),

                                                                  //show vaccine type
                                                                  Text(
                                                                    '${snapshot.data!.centers![index].sessions![sessionIndex].vaccineName}',
                                                                    style: TextStyle(
                                                                        wordSpacing:
                                                                            2,
                                                                        letterSpacing:
                                                                            2,
                                                                        color: Colors
                                                                            .blueAccent),
                                                                  ),
                                                                  // SizedBox(height: 5),
                                                                  Container(
                                                                    child: Text(
                                                                      'Doses ${snapshot.data!.centers![index].sessions![sessionIndex].availableCapacity} ',
                                                                      style: TextStyle(
                                                                          color: snapshot.data!.centers![index].sessions![sessionIndex].availableCapacity == 0
                                                                              ? Colors.red
                                                                              : Colors.green),
                                                                    ),
                                                                  ),
                                                                  if (snapshot
                                                                          .data!
                                                                          .centers![
                                                                              index]
                                                                          .sessions![
                                                                              sessionIndex]
                                                                          .allowAllAge ==
                                                                      true)
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child: Text(
                                                                            'All Ages '))
                                                                  else if (snapshot
                                                                          .data!
                                                                          .centers![
                                                                              index]
                                                                          .sessions![
                                                                              sessionIndex]
                                                                          .maxAgeLimit ==
                                                                      null)
                                                                    Text(
                                                                      'Age Group ${snapshot.data!.centers![index].sessions![sessionIndex].minAgeLimit} and above',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  else
                                                                    Text(
                                                                      'Age Group ${snapshot.data!.centers![index].sessions![sessionIndex].minAgeLimit} to ${snapshot.data!.centers![index].sessions![sessionIndex].maxAgeLimit}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),

                                                                  Text(
                                                                      'First Dose - ${snapshot.data!.centers![index].sessions![sessionIndex].availableCapacityDose1}'),
                                                                  Text(
                                                                      'Second Dose - ${snapshot.data!.centers![index].sessions![sessionIndex].availableCapacityDose2}')
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (ctx, index) {
                                                        return SizedBox(
                                                            width: 10);
                                                      },
                                                      itemCount: snapshot
                                                          .data!
                                                          .centers![index]
                                                          .sessions!
                                                          .length),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data!.centers!.length,
                                    separatorBuilder: (ctx, index) {
                                      return SizedBox(height: 10);
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text('Stream done');
                          }
                          return Text('');
                        },
                      )
                    : Center(
                        child: Text('Syncing Stopped'),
                      ),
              ),
            ),

            //changes the date and pincode
            Container(
              height: 50,
              // width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Pincode'),
                      controller: pinCodeController,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                //change the pincode
                //first stop the streaming
                covidSessionAvailabilityController.stopStream.value = true;
                //change the pincode
                covidSessionAvailabilityController.pinCode.value =
                    pinCodeController.text;
                //then reload the stream again
                covidSessionAvailabilityController.stopStream.value = false;
                print(
                    "date - ${covidSessionAvailabilityController.date.value} ");
              },
              child: Text('Change'),
            )
          ],
        ),
      ),
    );
  }

  Column customContainerTextWidget(String? text, double? spacing) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              '$text',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: spacing)
      ],
    );
  }
}
