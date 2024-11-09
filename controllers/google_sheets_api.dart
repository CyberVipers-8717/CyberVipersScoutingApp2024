import 'user.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credential
  static const String _credentials = r'''
INSERT HERE

''';
// set up and connect to the speradsheet
// you can find the id in the middle of the URL of the spreadsheet
  static const _spreadsheetId = '1LguA3zZWvRQslDV3DPmQYuCyK7wlquIiPx8Gkq_XoA4';
  // the google sheet your connecting to. you have to pass the credentials
  static final _gsheets = GSheets(_credentials);
  // the worksheet is just the tabs in a google sheet
  static Worksheet? _worksheet;

  // we make this function to initialize the spreadsheet
  Future init() async {
    // calls for the spreadsheet
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    // calls for the worksheet inside the spreadsheet
    _worksheet = ss.worksheetByTitle('Worlds');

    // as stated this gets the fields of the worksheet.
    final firstRow = UserFields.getFields();
    //You have to pass what row your data starts in and then show it that values that will go with the corrisponding column
    _worksheet!.values.insertRow(1, firstRow);
  }

  /*This is kinda complicated but essntially its takes a List of a Map that has a string as its key and any type of variabe as its value
  all that is stored in the variable dataList but it can be called anything obviously
  When we send data we need to pass in the key and its corrisponding value
  The key is the colum on the sheet that we want to put the data in
  the value is just any kind of variable like an int or a bool
  all this does is make a new row everytime its called so long as there is at least one value passed(dont worry about that though)
  // It makes a new row then passes the values into the corrisponding spot(column)*/
  static Future sendData(List<Map<String, dynamic>> dataList) async {
    _worksheet!.values.map.appendRows(dataList);
  }

  static Future<int> getRowCount() async {
    if (_worksheet == null) return 0;

    final lastRow = await _worksheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_worksheet == null) return;
    _worksheet!.values.map.appendRows(rowList);
  }
}
