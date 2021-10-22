import 'dart:io';
import 'package:accounter/api/pdf_api.dart';
import 'package:accounter/model/ReceiptInfo.dart';
import 'package:accounter/model/invoice.dart';
import 'package:accounter/model/schoolinfo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    String pdfname = ReceiptInfo().pdfname;

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildReceiptInfo(invoice.receiptinfo),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSchoolAddress(invoice.schoolname),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Text("Receipt", style: pw.TextStyle(fontSize: 20.0)),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildReceiptInfo(ReceiptInfo receiptinfo) => Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Received with thanks from",
                    style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.name, style: pw.TextStyle(fontSize: 16.0)),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Paid", style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.amount,
                    style: pw.TextStyle(fontSize: 16.0)),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Payment Method", style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.paymode,
                    style: pw.TextStyle(fontSize: 16.0)),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Remarks", style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.remarks,
                    style: pw.TextStyle(fontSize: 16.0)),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Reference", style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.reference,
                    style: pw.TextStyle(fontSize: 16.0)),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text("Date and Time Of Payment",
                    style: pw.TextStyle(fontSize: 16.0)),
                pw.Text(receiptinfo.time, style: pw.TextStyle(fontSize: 16.0)),
              ]),
        ],
      );

  static Widget buildSchoolAddress(SchoolName schoolinfo) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(schoolinfo.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(schoolinfo.address, style: pw.TextStyle(fontSize: 16.0)),
          Text(schoolinfo.contactInfo, style: pw.TextStyle(fontSize: 16.0))
        ],
      );

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.schoolname.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Paypal', value: invoice.schoolname.contactInfo),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
