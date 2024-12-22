import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:degree_verifier/Utils/SnackBar.dart';
import 'package:degree_verifier/Utils/contract_utils.dart';
import 'package:degree_verifier/Utils/SideBar.dart';
import 'package:degree_verifier/Utils/InputField.dart';

import 'package:degree_verifier/Config/constants.dart';
import 'package:degree_verifier/Config/secrets.dart';


class DegreeGenerator extends StatefulWidget {
  final String title;
  const DegreeGenerator({super.key, required this.title});

  @override
  State<DegreeGenerator> createState() => _DegreeGeneratorState();
}

class _DegreeGeneratorState extends State<DegreeGenerator> {
  Map<String, String> details = {
    "uni": "",
    "reg": "",
    "name": "",
    "type": "",
    "field": "",
    "date": "",
    "date2": "",
  };

  late Client httpClient;
  late Web3Client ethClient;

  Future<String> addDegree(Map<String, String> details) async {
    var response = await submit(ethClient, "AddDegree", [details['uni'], details['name'], details['reg'], details['date'], details['type'], details['field']]);
    print("submit response: $response");
    return response;
  }

  Future<String> readLastDegree() async {
    List<dynamic> result = await query(ethClient, "readLast", []);
    print("Received data: $result");
    return result[0];
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(secrets["web3Client"]!, httpClient);
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: designColor,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: designColor))
          : Container(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputBox(
                            labelText: "University",
                            hintText: 'GIKI',
                            initialValue: details["uni"]!,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";
                              if (value.length != 4) return "University code must be 4 characters long";
                              if (["GIKI"].contains(value) == false) return "Invalid University. Please refer to the registered list.";
                              return null;
                            },
                            onSaved: (value) {
                              details["uni"] = value ?? "";
                            },
                          ),
                          InputBox(
                            labelText: "Student Name",
                            hintText: 'Mujtaba Omar',
                            initialValue: details["name"]!,
                            onSaved: (value) {
                              details["name"] = value ?? "";
                            },
                          ),
                          InputBox(
                            labelText: "Registration No",
                            hintText: '2021495',
                            initialValue: details["reg"]!,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";
                              if (value.length != 7) return "Registration number must be 7 digits long";
                              if (num.tryParse(value) == null) return "Registration number must be a number";
                              return null;
                            },
                            onSaved: (value) {
                              details["reg"] = value ?? "";
                            },
                          ),
                          InputBox(
                            labelText: "Degree Type",
                            hintText: 'BS',
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";
                              if (["BS", "BA", "MS", "MA", "PhD"].contains(value) == false) return "Invalid Degree Type";
                              return null;
                            },
                            initialValue: details["type"]!,
                            onSaved: (value) {
                              details["type"] = value ?? "";
                            },
                          ),
                          InputBox(
                            labelText: "Degree Field",
                            hintText: 'CS',
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";
                              if (["CS", "EE", "ME", "CVE", "CME", "CE", "SE", "AI", "DS", "CYS", "ES", "MGS"].contains(value) == false) return "Invalid Major";
                              return null;
                            },
                            initialValue: details["field"]!,
                            onSaved: (value) {
                              details["field"] = value ?? "";
                            },
                          ),
                          InputBox(
                            labelText: "Date",
                            hintText: 'DD-MM-YY',
                            initialValue: details["date2"]!,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";

                              String error = "Date must be in the format DD-MM-YY";
                              if (value.length != 8) return error;
                              if (value[2] != "-" || value[5] != "-") return error;
                              for (int i = 0; i < 8; i++) {
                                if (i == 2 || i == 5) continue;
                                if (num.tryParse(value[i]) == null) return error;
                              }

                              int day = int.parse(value.substring(0, 2));
                              int month = int.parse(value.substring(3, 5));
                              int year = int.parse(value.substring(6, 8));
                              if (day < 1 || day > 31) return error;
                              if (month < 1 || month > 12) return error;

                              return null;
                            },
                            onSaved: (value) {
                              details["date2"] = value ?? "";
                            },
                          ),
                          SizedBox(height: 30),
                          // button to get Degree
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() == false) return;
                                _formKey.currentState!.save();

                                setState(() {
                                  isLoading = true;
                                });
                                details["date"] = details["date2"]!.substring(0, 2) + details["date2"]!.substring(3, 5) + details["date2"]!.substring(6, 8);
                                addDegree(details).then((value) async {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value.substring(0, 5) == "ERROR") {
                                    showSnackBar(context, "Invalid credentials");
                                  } else {
                                    showSnackBar(context, "Degree added successfully", error: false);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
                              child: const Text("Add Degree", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                readLastDegree().then((value) async {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackBar(context, "Last Degree: $value", error: false);
                                });
                              },
                              style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
                              child: const Text("Get Last Degree Code", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
