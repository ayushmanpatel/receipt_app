class ReceiptInfo {
  final String name;
  final String pdfname;
  final String amount;
  final String paymode;
  final String remarks;
  final String reference;
  final String time;

  const ReceiptInfo({
    this.paymode,
    this.pdfname,
    this.remarks,
    this.reference,
    this.time,
    this.name,
    this.amount,
  });
}
