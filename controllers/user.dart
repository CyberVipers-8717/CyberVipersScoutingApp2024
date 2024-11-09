import 'dart:core';

class UserFields {
  static const String teamNum = 'TEAM #';
  static const String alliance = 'ALLIANCE';
  static const String matchNum = 'MATCH #';

  static const String posAmp = 'ROBOT AMP POSITION';
  static const String posCenter = 'ROBOT CENTER POSITION';
  static const String posBetween = 'ROBOT BETWEEN POSITION';
  static const String posSource = 'ROBOT SOURCE POSITION';

  static const String note1 = 'NOTE 1'; //note closest to the amp
  static const String note2 = 'NOTE 2';
  static const String note3 = 'NOTE 3'; //note farthest to the amp

  static const String note4 = 'NOTE 4'; //note closest to the amp on the bottom
  static const String note5 = 'NOTE 5';
  static const String note6 = 'NOTE 6';
  static const String note7 = 'NOTE 7';
  static const String note8 = 'NOTE 8'; //note farthest to the amp bottom

  static const String leave = 'LEAVE';
  static const String autoAmp = 'AUTO AMP NOTES';
  static const String autoAmpMissed = 'AUTO AMP MISSED';
  static const String autoSpeker = 'AUTO SPEAKER NOTES';
  static const String autoSpeakerMissed = 'AUTO SPEAKER MISSED';

  static const String teleopAmp = 'TELEOP AMP NOTES';
  static const String teleopAmpMissed = 'TELEOP AMP MISSED';
  static const String teleopSpeaker = 'TELEOP SPEAKER NOTES';
  static const String teleopSpeakerMissed = 'TELEOP SPEAKER MISSED';
  static const String trap = 'NOTES IN TRAP';
  static const String trapMissed = 'MISSED TRAP';

  static const String leftStage = 'LEFT STAGE';
  static const String centerStage = 'CENTER STAGE';
  static const String rightStage = 'RIGHT STAGE';

  static const String dNone = 'NONE';
  static const String dSlight = 'SLIGHT';
  static const String dModest = 'MODEST';
  static const String dGenerous = 'GENEROUS';
  static const String dExclusively = 'EXCLUSIVELY';

  static const String park = 'PARK';
  static const String harmony = 'HARMONY';

  static const String comments = 'COMMENTS';
  static const String notesFromWhere = 'NOTES FROM WHERE';
  static const String scoutersName = 'SCOUTER\'S NAME';
  static const String scoutersTeam = 'SCOUTER\'S TEAM';

  static List<String> getFields() => [
        teamNum,
        alliance,
        matchNum,
        posAmp,
        posCenter,
        posBetween,
        posSource,
        note1,
        note2,
        note3,
        note4,
        note5,
        note6,
        note7,
        note8,
        leave,
        autoAmp,
        autoAmpMissed,
        autoSpeker,
        autoAmpMissed,
        teleopAmp,
        teleopAmpMissed,
        teleopSpeaker,
        teleopSpeakerMissed,
        trap,
        trapMissed,
        leftStage,
        centerStage,
        rightStage,
        dNone,
        dSlight,
        dModest,
        dGenerous,
        dExclusively,
        park,
        harmony,
        comments,
        notesFromWhere,
        scoutersName,
        scoutersTeam,
      ];
}
