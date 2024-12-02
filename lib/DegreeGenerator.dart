import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:degree_verifier/SideBar.dart';
import 'package:degree_verifier/Printer.dart';
import 'package:degree_verifier/InputField.dart';
import 'package:degree_verifier/constants.dart';

class DegreeGenerator extends StatefulWidget {
  final String title;
  const DegreeGenerator({super.key, required this.title});

  @override
  State<DegreeGenerator> createState() => _DegreeGeneratorState();
}

class _DegreeGeneratorState extends State<DegreeGenerator> {
  Map<String, String> details = {
    "uni": "Ghulam Ishaq Khan Institute of Engineering Sciences and Technology",
    "reg": "",
    "name": "",
    "type": "",
    "field": "",
    "date": "",
  };

  final GlobalKey<FormState> _formKey = GlobalKey();

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
      body: Container(
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
                      hintText: 'Bachelor of Science',
                      initialValue: details["type"]!,
                      onSaved: (value) {
                        details["type"] = value ?? "";
                      },
                    ),
                    InputBox(
                      labelText: "Degree Field",
                      hintText: 'Computer Science',
                      initialValue: details["field"]!,
                      onSaved: (value) {
                        details["field"] = value ?? "";
                      },
                    ),
                    InputBox(
                      labelText: "Date",
                      hintText: 'June Twenty First, Year Two Thousand Twenty Five',
                      initialValue: details["date"]!,
                      onSaved: (value) {
                        details["date"] = value ?? "";
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
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => generateDegree(details),
                  );
                },
                style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
                child: const Text("Save PDF", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() == false) return;
                  _formKey.currentState!.save();
                  await Printing.sharePdf(bytes: await generateDegree(details), filename: 'degree.pdf');
                },
                style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
                child: const Text("Share PDF", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
