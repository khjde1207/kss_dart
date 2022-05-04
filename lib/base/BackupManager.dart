import 'Const.dart';

/*
 * Korean Sentence Splitter
 * Split Korean text into sentences using heuristic algorithm.
 * Copyright (C) 2022 자유해결사 <khjde1207@gmail.com>
 * Copyright (C) 2021 Sang-ji Lee <tkdwl06@gmail.com>
 * Copyright (C) 2021 Hyun-woong Ko <kevin.woong@tunib.ai> and Sang-Kil Park <skpark1224@hyundai.com>
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */
class BackupManager {
  BackupManager(
      //   {
      //   // required String s,
      // }
      ) {
    for (String s in getData()) {
      //  String.valueOf(Math.abs(s.hashCode())))
      this.backupDict[s] = s.hashCode.abs().toString();
    }
  }

  Map<String, String> backupDict = {};

  List<String> getData() {
    List<String> faces = [":)", ":(", ":'(", "O:)", "&)", ">:(", "3:)", "<(\")"];
    List<String> lowUpperNum = Const.lowerAlphabets;
    lowUpperNum.addAll(Const.upperAlphabets);

    List<String> apostrophe = [];
    for (String i in lowUpperNum) {
      for (String j in lowUpperNum) {
        apostrophe.add("$i'$j");
      }
    }

    List<String> years = [];
    for (String i in Const.numbers) {
      years.add("$i's");
      years.add("$i'S");
    }

    List<String> time = [];
    for (String i in Const.numbers) {
      for (String j in Const.numbers) {
        for (String k in Const.singleQuotes) {
          time.add("$i,$j$k");
        }
      }
    }

    List<String> inch = [];
    List<String> numersAdd = Const.numbers;
    numersAdd.add(".");
    for (String i in numersAdd) {
      for (String j in Const.numbers) {
        for (String k in Const.doubleQuotes) {
          inch.add("$i,$j$k");
        }
      }
    }

    List<String> ecCases = [
      "쌓이다",
      "보이다",
      "먹이다",
      "죽이다",
      "끼이다",
      "트이다",
      "까이다",
      "꼬이다",
      "데이다",
      "치이다",
      "쬐이다",
      "꺾이다",
      "낚이다",
      "녹이다",
      "벌이다",
      "다 적발",
      "다 말하",
      "다 말한",
      "다 말했",
      "다 밝혀",
      "다 밝혔",
      "다 밝히",
      "다 밝힌",
      "다 주장",
      "요 라고",
      "요. 라고",
      "죠 라고",
      "죠. 라고",
      "다 라고",
      "다. 라고",
      "다 하여",
      "다 거나",
      "다. 거나",
      "다 시피",
      "다. 시피",
      "다 응답",
      "다 로 응답",
      "다. 로 응답",
      "요 로 응답",
      "요. 로 응답",
      "죠 로 응답",
      "죠. 로 응답",
      "다 에서",
      "다. 에서",
      "요 에서",
      "요. 에서",
      "죠 에서",
      "죠. 에서",
      "타다 금지법",
      "다 온 사실",
      "다 온 것",
      "다 온 사람",
      "다 왔다",
      "다 왔더",
      "다 와보",
      "우간다",
      "사이다"
    ];

    List<String> data = [];
    data.addAll(faces);
    data.addAll(apostrophe);
    data.addAll(years);
    data.addAll(ecCases);
    data.addAll(time);
    data.addAll(inch);

    return data;
  }

  String process(String text, Map<String, String> purposeDict) {
    purposeDict.forEach((key, value) {
      text = text.replaceAll(key, value);
    });
    return text.trim();
  }

  void addItem2Dict(String key, String value) {
    backupDict[key] = value;
  }

  String backup(String text) {
    return process(text, backupDict);
  }

  String restore(String text) {
    Map<String, String> purposeDict = {};
    backupDict.forEach((key, value) {
      purposeDict[value] = key;
    });
    return process(text, purposeDict);
  }
}
