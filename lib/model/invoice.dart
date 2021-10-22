import 'package:accounter/model/ReceiptInfo.dart';
import 'package:accounter/model/schoolinfo.dart';

class Invoice {
  final SchoolName schoolname;
  final ReceiptInfo receiptinfo;

  const Invoice({
    this.schoolname,
    this.receiptinfo,
  });
}
