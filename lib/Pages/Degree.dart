import 'package:degree_verifier/Utils/Printer.dart';
import 'package:degree_verifier/Config/constants.dart';
import 'package:degree_verifier/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class Degree extends StatefulWidget {
  const Degree({super.key});

  @override
  State<Degree> createState() => _DegreeState();
}

class _DegreeState extends State<Degree> {
  late Map<String, String> details = {'uni': '', 'name': '', 'reg': '', 'date': '', 'type': '', 'field': ''};

  void getDetails(String detailsStr) {
    int i = 0;
    detailsStr.split('|').forEach((element) {
      if (i == 0) details['uni2'] = element;
      if (i == 1) details['name'] = element;
      if (i == 2) details['reg'] = element;
      if (i == 3) details['date2'] = element;
      if (i == 4) details['type2'] = element;
      if (i == 5) details['field2'] = element;
      i++;
    });

    details['date'] = convertDateToFullText(details['date2']!);
    details['date2'] = details['date2']!.substring(0, 2) + "-" + details['date2']!.substring(2, 4) + "-" + details['date2']!.substring(4, 6);
    details['type'] = convertDegreeType(details['type2']!);
    details['field'] = convertMajor(details['field2']!);
    details['uni'] = convertUni(details['uni2']!);
  }

  @override
  Widget build(BuildContext context) {
    final String data = ModalRoute.of(context)!.settings.arguments as String;
    getDetails(data);
    TextStyle styleKey = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: const SideBar(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: designColor,
        title: Text("Degree", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("University:", style: styleKey),
                    Text("Name:", style: styleKey),
                    Text("Reg No:", style: styleKey),
                    Text("Date:", style: styleKey),
                    Text("Degree:", style: styleKey),
                    Text("Field:", style: styleKey),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details['uni2']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text(details['name']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text(details['reg']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text(details['date2']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text(details['type']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text(details['field']!, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => generateDegree(details),
                );
              },
              style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
              child: const Text("Save Degree", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await Printing.sharePdf(bytes: await generateDegree(details), filename: 'degree.pdf');
              },
              style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: designColor),
              child: const Text("Share Degree", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
