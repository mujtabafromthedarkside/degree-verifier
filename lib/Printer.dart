import 'dart:math';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Import widgets for layout

Future<Uint8List> generateDegree(Map<String, String> details) async {
  final pdf = pw.Document();

  final Uint8List imageBytes = await rootBundle.load('lib/assets/giki_logo_rb_wb2.png').then((data) => data.buffer.asUint8List());
  final pw.MemoryImage imageGIKI = pw.MemoryImage(imageBytes);

  final Uint8List imageBytes2 = await rootBundle.load('lib/assets/sign1.png').then((data) => data.buffer.asUint8List());
  final pw.MemoryImage imageSign1 = pw.MemoryImage(imageBytes2);

  final Uint8List imageBytes3 = await rootBundle.load('lib/assets/sign2.png').then((data) => data.buffer.asUint8List());
  final pw.MemoryImage imageSign2 = pw.MemoryImage(imageBytes3);

  final Uint8List imageBytes4 = await rootBundle.load('lib/assets/stamp2.png').then((data) => data.buffer.asUint8List());
  final pw.MemoryImage imageStamp = pw.MemoryImage(imageBytes4);

  final uniStyle = pw.TextStyle(font: pw.Font.timesBold(), fontWeight: pw.FontWeight.bold, fontSize: 25);
  final nameStyle = pw.TextStyle(font: pw.Font.timesBold(), fontWeight: pw.FontWeight.bold, fontSize: 20);
  final degreeStyle = pw.TextStyle(font: pw.Font.timesBold(), fontWeight: pw.FontWeight.bold, fontSize: 18);
  final fillerStyle = pw.TextStyle(font: pw.Font.timesItalic(), fontSize: 18);
  final fillerStyle2 = pw.TextStyle(font: pw.Font.timesItalic(), fontStyle: pw.FontStyle.italic, fontSize: 14);
  final signeeStyle = pw.TextStyle(font: pw.Font.times(), fontSize: 16);

  pdf.addPage(pw.Page(
      // margin: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: pw.EdgeInsets.zero,
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (pw.Context context) {
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            color: PdfColors.white,
            child: pw.Stack(children: [
              pw.Center(child: pw.Opacity(opacity: 0.05, child: pw.Image(imageGIKI, width: 300, height: 300, fit: pw.BoxFit.cover))),
              pw.Column(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text("Serial No: ${Random().nextInt(1000000).toString().padLeft(6, '0')}"),
                    pw.Image(imageGIKI, width: 100, height: 100, fit: pw.BoxFit.cover),
                    pw.Text("Reg No: ${details["reg"]!}"),
                  ]),
                  pw.SizedBox(height: 5),
                  pw.Text(details["uni"]!, style: uniStyle),
                  pw.SizedBox(height: 15),
                  pw.Text("on the recommendation of the Faculty and Governing Council", style: fillerStyle),
                  pw.SizedBox(height: 10),
                  pw.Text(details["name"]!.toUpperCase(), style: nameStyle),
                  pw.SizedBox(height: 10),
                  pw.Text("is admitted to the degree of", style: fillerStyle),
                  pw.SizedBox(height: 10),
                  pw.Text(details["type"]!, style: degreeStyle),
                  pw.SizedBox(height: 5),
                  pw.Text("in", style: fillerStyle),
                  pw.SizedBox(height: 5),
                  pw.Text(details["field"]!, style: degreeStyle),
                  pw.SizedBox(height: 15),
                  pw.Text("Awarded on", style: fillerStyle2),
                  pw.SizedBox(height: 10),
                  pw.Text(details["date"]!, style: fillerStyle2),
                ]),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Image(imageSign1, width: 100, height: 40, fit: pw.BoxFit.cover),
                    pw.Container(margin: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 0), height: 1, width: 150, color: PdfColors.black),
                    pw.Text("PRESIDENT", style: signeeStyle),
                    pw.Text("BOARD OF GOVERNORS", style: signeeStyle),
                  ]),
                  pw.Image(imageStamp, width: 120, height: 120),
                  pw.Column(children: [
                    pw.Image(imageSign2, width: 120, height: 40, fit: pw.BoxFit.cover),
                    pw.Container(margin: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 0), height: 1, width: 150, color: PdfColors.black),
                    pw.Text("RECTOR", style: signeeStyle),
                  ]),
                ]),
              ])
            ]));
      }));

  return pdf.save();
}
