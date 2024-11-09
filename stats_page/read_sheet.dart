import 'dart:convert';
import '../controllers/sheet_values.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

SheetValues sv = Get.find();

// credit to read the sheet to ChatGPT version 3.5
Future<Map<String, List<String>>> getDataForMatchNumber({
  required String team,
}) async {
  const String sheetId = 'INSERT HERE';
  const String apiKey = 'INSERT HERE';
  final Uri uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/$team?majorDimension=ROWS&key=$apiKey');

  /*
  'ALLIANCE', // value is 0
    'MATCH #', // value is 1
    'ROBOT AMP POSITION', // value is 2
    'ROBOT CENTER POSITION', // value is 3
    'ROBOT BETWEEN POSITION', // value is 4
    'ROBOT SOURCE POSITION', // value is 5
    'NOTE 1', // value is 6
    'NOTE 2', // value is 7
    'NOTE 3', // value is 8
    'NOTE 4', // value is 9
    'NOTE 5', // value is 10
    'NOTE 6', // value is 11
    'NOTE 7', // value is 12
    'NOTE 8', // value is 13
    'LEAVE', // value is 14
    'AUTO AMP NOTES', // value is 15
    'AUTO AMP MISSED',// value is 16
    'AUTO SPEAKER NOTES', // value is 17
    'AUTO SPEAKER MISSED', value is 18
    'TELEOP AMP NOTES', // value is 19
    'TELEOP AMP MISSED', // value is 20
    'TELEOP SPEAKER NOTES', // value is 21
    'TELEOP SPEAKER MISSED', // value is 22
    'NOTES IN TRAP', // value is 23
    'MISSED TRAP', // value is 24
    'LEFT STAGE', // value is 25
    'CENTER STAGE', // value is 26
    'RIGHT STAGE', // value is 27
    'NONE', // value is 28
    'SLIGHT', // value is 29
    'MODEST', // value is 30
    'GENEROUS', // value is 31
    'EXCLUSIVELY', // value is 32
    'PARK', // value is 33
    'HARMONY', // value is 34
    'COMMENTS', // value is 35
    'NOTES FROM WHERE' value is 36
    'SCOUTER'S NAME', // value is 37
    'SCOUTER'S TEAM', // value is 38 / 39 for some reason
       */

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List? values = data['values'];

    if (values == null || values.isEmpty) {
      return {};
    }

    List scoutersData = [];
    // Initialize the map to store match number and associated data
    Map<String, List<String>> matchDataMap = {};
    // Iterate through each row of data (starting from the second row)
    for (int i = 1; i < values.length; i++) {
      // Extract match number from the third value in the row
      String matchNumber = values[i][2].toString();

      // Retrieve the list of data associated with the match number
      /*the reason why this function works the way we want it is becaue any time
       there is more than one row with the same team number,the map where all the data gets put into gets overwritten and
        the value gets changed to the last instance of the data. EX: scouter A submitted data for match 6 team XYZ at 9:00am but scouter B did the same thing but at 9:10am. 
        When they go to the view the data, it will only show scouter B's data for match 6*/
      if (sv.wantsTeamOnlyStats.isTrue) {
        if (values[i][38] == sv.scoutersTeam.text ||
            values[i][39] == sv.scoutersTeam.text) {
          List<String> rowData = values[i]
              .sublist(1)
              .map<String>((value) => value == null || value.toString().isEmpty
                  ? 'NO VALUE PRESENT'
                  : value.toString())
              .toList();
          // Store the data in the map

          matchDataMap[matchNumber] = rowData;
        }
      } else {
        List<String> rowData = values[i]
            .sublist(1)
            .map<String>((value) => value == null || value.toString().isEmpty
                ? 'NO VALUE PRESENT'
                : value.toString())
            .toList();
        // Store the data in the map

        matchDataMap[matchNumber] = rowData;
        //this line under this comment is the one that gets all the data from different scouters
        scoutersData.add(values[i].sublist(1));
      }

      // // Store the data in the map

      // matchDataMap[matchNumber] = rowData;
    }

    List row = matchDataMap.keys.toList();

    sv.matchNumAndValue.value = matchDataMap;
    sv.teamMatches.value = row;
    sv.viewAllScoutComment.value = scoutersData;
    return matchDataMap;
  }

  return {};
}

// except these functions below
String getAllAverageTrue({required int column}) {
  List matches = sv.teamMatches;
  int listLength = sv.matchNumAndValue.length;
  int allTrue = 0;
  int total = 0;
  for (int i = 0; i < listLength; i++) {
    List values = sv.matchNumAndValue[matches[i]];
    String wantedValue = values[column];
    total++;
    if (wantedValue != '0' && wantedValue != 'FALSE') allTrue++;
  }
  return '$allTrue / $total';
}

viewDiffScouterRespons({required String match}) {
  List currentMatchScouters = sv.viewAllScoutComment;
  int length = currentMatchScouters.length;
  Map returnMap = {};

  for (int i = 0; i < length; i++) {
    if (currentMatchScouters[i][1] == match) {
      returnMap[currentMatchScouters[i][37]] = currentMatchScouters[i];
    }
  }
  if (returnMap.length != 1) {
    sv.matchScouters.value = returnMap.keys.toList();
    sv.matchScouters.sort();
    sv.wantsTeamOnlyStats.value == true
        ? sv.matchCommDropAva.value = false
        : sv.matchCommDropAva.value = true;
    sv.scoutersMap.value = returnMap;
  } else {
    sv.matchCommDropAva.value = false;
    sv.scoutersMap.value = {};
  }
}

String climbAverage() {
  List matches = sv.teamMatches;
  int bottom = sv.matchNumAndValue.length;
  int top = 0;
  for (int i = 0; i < bottom; i++) {
    List values = sv.matchNumAndValue[matches[i]];
    for (int i = 25; i <= 27; i++) {
      String stages = values[i];
      switch (i) {
        case 25:
          if (stages == 'TRUE') top++;
        case 26:
          if (stages == 'TRUE') top++;
        case 27:
          if (stages == 'TRUE') top++;
      }
    }
  }

  return '$top/$bottom';
}

String getMatchBool(
    {required int column, required String match, String? newScouter}) {
  if (newScouter == null) {
    List value = sv.matchNumAndValue[match];
    String wantedValue = value[column];
    return wantedValue;
  } else {
    var value = sv.scoutersMap[newScouter];
    String wantedValue = value[column];
    return wantedValue;
  }
}

double getAllAverageNumbers({required int made}) {
  List allMatchNumbers = sv.teamMatches;
  int totalMatches = sv.matchNumAndValue.length;
  int top = 0;
  int total = 0;
  double average;
  if (sv.matchNumAndValue.isNotEmpty) {
    for (int i = 0; i < totalMatches; i++) {
      var currentRow = sv.matchNumAndValue[allMatchNumbers[i]];
      int over = int.parse(currentRow[made]);
      top += over;
      total++;
    }
  }
  average = top / total;
  if (average.isNaN) {
    average = 0;
    return average;
  } else {
    return average.toPrecision(2);
  }
}

String getMatchAverageNumbers({
  required int made,
  required int missed,
  required String match,
  String? newScouter,
}) {
  if (newScouter == null) {
    int top = 0;
    int total = 0;
    if (sv.matchNumAndValue.isNotEmpty) {
      var currentRow = sv.matchNumAndValue[match];
      int over = int.parse(currentRow[made]);
      int under = int.parse(currentRow[missed]);
      top += over;
      total += over + under;
    }
    return '$top/$total';
  } else {
    int top = 0;
    int total = 0;
    if (sv.matchNumAndValue.isNotEmpty) {
      var currentRow = sv.scoutersMap[newScouter];
      int over = int.parse(currentRow[made]);
      int under = int.parse(currentRow[missed]);
      top += over;
      total += over + under;
    }
    return '$top/$total';
  }
}

String getBoolAverage({required int value}) {
  int top = 0;
  List row = sv.teamMatches;
  int bottom = row.length;
  bool notBlank = true;
  if (sv.matchNumAndValue.isNotEmpty) {
    for (int i = 0; i < bottom; i++) {
      var currentRow = sv.matchNumAndValue[row[i]][value];
      // int intCurrentValue = int.parse(currentRow);

      if (currentRow == 'TRUE') {
        top++;
      }
    }
  } else {
    notBlank = false;
  }
  if (notBlank != false) {
    return '$top/$bottom';
  } else {
    return 'N/A';
  }
}

seeAllComments() {
  List match = [];
  Map rowCountAndComment = {};
  int length = sv.matchNumAndValue.length;
  List playedMatches = sv.matchNumAndValue.keys.toList();
  Map rows = sv.matchNumAndValue;
  for (int i = 0; i < length; i++) {
    List currentRow = rows[playedMatches[i]];
    rowCountAndComment[currentRow[1]] = [
      currentRow[35].toString(),
      currentRow[37]
    ];
  }
  match = rowCountAndComment.keys.toList();
  sv.commentCount.value = match;
  sv.allComments.value = rowCountAndComment;
}

String getTeamStrongSuit() {
  int speakerNotes = 0;
  double ampNotes = 0;
  int trapNotes = 0;
  double defense = 0;
  int length = sv.matchNumAndValue.length;
  List playedMatches = sv.matchNumAndValue.keys.toList();
  Map rows = sv.matchNumAndValue;
  for (int i = 0; i < length; i++) {
    List currentRow = rows[playedMatches[i]];
    ampNotes += int.parse(currentRow[15]) * 1.25;
    ampNotes += int.parse(currentRow[19]) * 1.25;
    speakerNotes += int.parse(currentRow[17]);
    speakerNotes += int.parse(currentRow[21]);
    trapNotes += int.parse(currentRow[23]);
    for (int d = 28; d <= 32; d++) {
      String def = currentRow[d];
      switch (d) {
        case 28:
          if (def == 'TRUE') defense += 0;
        case 29:
          if (def == 'TRUE') defense += 0.5;
        case 30:
          if (def == 'TRUE') defense += 1;
        case 31:
          if (def == 'TRUE') defense += 1.5;
        case 32:
          if (def == 'TRUE') defense += 2;
      }
    }
  }
  if (ampNotes > speakerNotes && ampNotes >= trapNotes && ampNotes >= defense) {
    return 'Amp';
  } else if (speakerNotes > ampNotes &&
      speakerNotes >= trapNotes &&
      speakerNotes >= defense) {
    return 'Speaker';
  } else if (trapNotes > ampNotes &&
      trapNotes > speakerNotes &&
      trapNotes >= defense) {
    return 'Trap';
  } else if (defense > ampNotes &&
      defense > speakerNotes &&
      defense > trapNotes) {
    return 'Defense';
  } else {
    if (ampNotes == speakerNotes) {
      return 'Amp and Speaker';
    } else {
      return 'None';
    }
  }
}

int seeAverageDefense() {
  int none = 0;
  int slight = 0;
  int modest = 0;
  int generous = 0;
  int exclusively = 0;
  int rowLength = sv.matchNumAndValue.length;
  List row = sv.teamMatches;
  Map currentRow = sv.matchNumAndValue;
  for (int i = 0; i < rowLength; i++) {
    List currentValues = currentRow[row[i]];
    for (int a = 28; a <= 32; a++) {
      String currentBool = currentValues[a];
      switch (a) {
        case 28:
          if (currentBool == 'TRUE') {
            none++;
            break;
          }
        case 29:
          if (currentBool == 'TRUE') {
            slight++;
            break;
          }
        case 30:
          if (currentBool == 'TRUE') {
            modest++;
            break;
          }
        case 31:
          if (currentBool == 'TRUE') {
            generous++;
            break;
          }
        case 32:
          if (currentBool == 'TRUE') {
            exclusively++;
            break;
          }
      }
    }
  }
  //1 for none, 2 for slight, 3 for modest, 4 generous, 5 exclusively
  if (slight > none &&
      slight > modest &&
      slight > generous &&
      slight > exclusively) {
    return 2;
  } else if (modest > none &&
      modest > slight &&
      modest > generous &&
      modest > exclusively) {
    return 3;
  } else if (generous >= none &&
      generous > slight &&
      generous > modest &&
      generous > exclusively) {
    return 4;
  } else if (exclusively >= none &&
      exclusively > slight &&
      exclusively > generous &&
      exclusively > modest) {
    return 5;
  } else {
    return 1;
  }
}

Future<Map<int, String>> eventTeams() async {
  const String apiKey = 'INSERT HERE';
  final String url =
      'https://www.thebluealliance.com/api/v3/event/2024${sv.eventKey}/teams/simple';
  Map<int, String> teamNames = {};

  final response =
      await http.get(Uri.parse(url), headers: {'X-TBA-Auth-Key': apiKey});

  if (response.statusCode == 200) {
    final List<dynamic> eventTeams = json.decode(response.body);

    for (var team in eventTeams) {
      final int teamNumber = team['team_number'];
      final String teamName = team['nickname'];
      teamNames[teamNumber] = teamName;
    }
    return teamNames;
  } else {
    return {};
  }
}

Future<Map> getEventMatches() async {
  Map allMatches = {};
  const String apiKey = 'INSERT HERE';
  final String url =
      'https://www.thebluealliance.com/api/v3/event/2024${sv.eventKey}/matches/simple';

  final response =
      await http.get(Uri.parse(url), headers: {'X-TBA-Auth-Key': apiKey});

  if (response.statusCode == 200) {
    List matchesData = json.decode(response.body);

    for (var match in matchesData) {
      if (match['comp_level'] == 'qm') {
        int matchNumber = match['match_number'];
        List redTeams = match['alliances']['red']['team_keys'];

        List blueTeams = match['alliances']['blue']['team_keys'];

        allMatches[matchNumber] = {'blue': blueTeams, 'red': redTeams};
      }
    }
    sv.allianceMatches.value = allMatches;
    return allMatches;
  } else {
    return {};
  }
}

Future<Map<String, String>> getAllRegionalEvents() async {
  const String apiKey = 'INSERT HERE';
  const String url = 'https://www.thebluealliance.com/api/v3/events/2024';
  Map<String, String> allEventsMap = {};
  final response =
      await http.get(Uri.parse(url), headers: {'X-TBA-Auth-Key': apiKey});
  if (response.statusCode == 200) {
    final List<dynamic> events = json.decode(response.body);
    for (var events in events) {
      final String eventName = events['short_name'];
      final String eventKey = events['event_code'];
      final int eventType = events['event_type'];
      if (eventType == 0) {
        allEventsMap[eventName] = eventKey;
      }
    }
    return allEventsMap;
  } else {
    return {};
  }
}

Future<Map<String, String>> getAllDistrictEvents() async {
  const String apiKey = 'INSERT HERE';
  const String url = 'https://www.thebluealliance.com/api/v3/events/2024';
  Map<String, String> allEventsMap = {};
  final response =
      await http.get(Uri.parse(url), headers: {'X-TBA-Auth-Key': apiKey});
  if (response.statusCode == 200) {
    final List<dynamic> events = json.decode(response.body);
    for (var events in events) {
      final String eventName = events['short_name'];
      final String eventKey = events['event_code'];
      final int eventType = events['event_type'];
      if (eventType == 1 || eventType == 2 || eventType == 5) {
        allEventsMap[eventName] = eventKey;
      }
    }
    return allEventsMap;
  } else {
    return {};
  }
}
