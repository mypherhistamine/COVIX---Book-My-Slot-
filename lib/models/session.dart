// To parse this JSON data, do
//
//     final covidSession = covidSessionFromJson(jsonString);

import 'dart:convert';

CovidSession covidSessionFromJson(String str) => CovidSession.fromJson(json.decode(str));

String covidSessionToJson(CovidSession data) => json.encode(data.toJson());

class CovidSession {
    CovidSession({
        this.centers,
    });

    List<VaccineCenter>? centers;

    factory CovidSession.fromJson(Map<String, dynamic> json) => CovidSession(
        centers: List<VaccineCenter>.from(json["centers"].map((x) => VaccineCenter.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "centers": List<dynamic>.from(centers!.map((x) => x.toJson())),
    };
}

class VaccineCenter {
    VaccineCenter({
        this.centerId,
        this.name,
        this.address,
        this.stateName,
        this.districtName,
        this.blockName,
        this.pincode,
        this.lat,
        this.long,
        this.from,
        this.to,
        this.feeType,
        this.sessions,
        this.vaccineFees,
    });

    int? centerId;
    String? name;
    String? address;
    String? stateName;
    String? districtName;
    String? blockName;
    int? pincode;
    int? lat;
    int? long;
    String? from;
    String? to;
    String? feeType;
    List<Session>? sessions;
    List<VaccineFee>? vaccineFees;

    factory VaccineCenter.fromJson(Map<String, dynamic> json) => VaccineCenter(
        centerId: json["center_id"],
        name: json["name"],
        address: json["address"],
        stateName: json["state_name"],
        districtName: json["district_name"],
        blockName: json["block_name"],
        pincode: json["pincode"],
        lat: json["lat"],
        long: json["long"],
        from: json["from"],
        to: json["to"],
        feeType: json["fee_type"],
        sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
        vaccineFees: json["vaccine_fees"] == null ? null : List<VaccineFee>.from(json["vaccine_fees"].map((x) => VaccineFee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "center_id": centerId,
        "name": name,
        "address": address,
        "state_name": stateName,
        "district_name": districtName,
        "block_name": blockName,
        "pincode": pincode,
        "lat": lat,
        "long": long,
        "from": from,
        "to": to,
        "fee_type": feeType,
        "sessions": List<dynamic>.from(sessions!.map((x) => x.toJson())),
        "vaccine_fees": vaccineFees == null ? null : List<dynamic>.from(vaccineFees!.map((x) => x.toJson())),
    };
}

class Session {
    Session({
        this.sessionId,
        this.date,
        this.availableCapacity,
        this.minAgeLimit,
        this.maxAgeLimit,
        this.allowAllAge,
        this.vaccineName,
        this.slots,
        this.availableCapacityDose1,
        this.availableCapacityDose2,
    });

    String? sessionId;
    String? date;
    int? availableCapacity;
    int? minAgeLimit;
    int? maxAgeLimit;
    bool? allowAllAge;
    String? vaccineName;
    List<String>? slots;
    int? availableCapacityDose1;
    int? availableCapacityDose2;

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        sessionId: json["session_id"],
        date: json["date"],
        availableCapacity: json["available_capacity"],
        minAgeLimit: json["min_age_limit"],
        maxAgeLimit: json["max_age_limit"] == null ? null : json["max_age_limit"],
        allowAllAge: json["allow_all_age"] == null ? null : json["allow_all_age"],
        vaccineName: json["vaccine"],
        slots: List<String>.from(json["slots"].map((x) => x)),
        availableCapacityDose1: json["available_capacity_dose1"],
        availableCapacityDose2: json["available_capacity_dose2"],
    );

    Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "date": date,
        "available_capacity": availableCapacity,
        "min_age_limit": minAgeLimit,
        "max_age_limit": maxAgeLimit == null ? null : maxAgeLimit,
        "allow_all_age": allowAllAge == null ? null : allowAllAge,
        "vaccine": vaccineName,
        "slots": List<dynamic>.from(slots!.map((x) => x)),
        "available_capacity_dose1": availableCapacityDose1,
        "available_capacity_dose2": availableCapacityDose2,
    };
}

class VaccineFee {
    VaccineFee({
        this.vaccine,
        this.fee,
    });

    String? vaccine;
    String? fee;

    factory VaccineFee.fromJson(Map<String, dynamic> json) => VaccineFee(
        vaccine: json["vaccine"],
        fee: json["fee"],
    );

    Map<String, dynamic> toJson() => {
        "vaccine": vaccine,
        "fee": fee,
    };
}
