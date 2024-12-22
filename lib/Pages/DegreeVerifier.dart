import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:degree_verifier/Utils/SnackBar.dart';
import 'package:degree_verifier/Utils/SideBar.dart';
import 'package:degree_verifier/Utils/InputField.dart';
import 'package:degree_verifier/Utils/contract_utils.dart';

import 'package:degree_verifier/Config/secrets.dart';
import 'package:degree_verifier/Config/constants.dart';

class DegreeVerifier extends StatefulWidget {
  final String title;
  const DegreeVerifier({super.key, required this.title});

  @override
  State<DegreeVerifier> createState() => _DegreeVerifierState();
}

class _DegreeVerifierState extends State<DegreeVerifier> {
  late Client httpClient;
  late Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(secrets["web3Client"]!, httpClient);
  }

  Future<String> verifyDegree(String code) async {
    List<dynamic> result = await query(ethClient, "VerifyDegree", [code]);
    print("Received data: $result");
    return result[0];
  }

  String degreeCode = "";
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: designColor,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: designColor),
            )
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
                            labelText: "Degree Code",
                            hintText: 'TEST1111',
                            initialValue: degreeCode,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please enter valid value";
                              if (value.length != 8) return "Degree Code must be 8 characters long";
                              return null;
                            },
                            onSaved: (value) {
                              degreeCode = value ?? "";
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),
                    // button to get Degree
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() == false) return;
                        _formKey.currentState!.save();

                        setState(() {
                          isLoading = true;
                        });
                        verifyDegree(degreeCode).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value == "NULL") {
                            showSnackBar(context, "Degree doesn't exist");
                          } else {
                            Navigator.pushNamed(
                              context,
                              '/Degree',
                              arguments: value,
                            );
                          }
                        });
                        // showSnackBar(context, degreeCode);

                        // send degree code to api and get response
                        // if "NULL", show message "degree doesn't exist"
                        // else show the details of the degree with option to save/share pdf

                        // await Printing.layoutPdf(
                        //   onLayout: (PdfPageFormat format) async => generateDegree(details),
                        // );
                      },
                      child: const Text("Verify Degree", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
