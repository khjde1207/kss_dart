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
class Const {
  static List<String> numbersArr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  static final List<String> numbers = List.from(numbersArr);

  static List<String> alphabetArr = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];
  static final List<String> alphabets = List.from(alphabetArr);

  static List<String> bracketArr = [
    ")",
    "）",
    "〉",
    "》",
    "]",
    "］",
    "〕",
    "】",
    "}",
    "｝",
    "』",
    "」",
    "(",
    "（",
    "〈",
    "《",
    "[",
    "［",
    "〔",
    "【",
    "{",
    "｛",
    "「",
    "『"
  ];

  static final List<String> bracket = List.from(bracketArr);

  static List<String> punctuationArr = [";", ".", "?", "!", "~", "…"];
  static final List<String> punctuation = List.from(punctuationArr);

  static List<String> doubleQuotesArr = ["\"", "“", "”"];
  static final List<String> doubleQuotes = List.from(doubleQuotesArr);

  static List<String> singleQuotesArr = ["'", "‘", "’"];
  static final List<String> singleQuotes = List.from(singleQuotesArr);

  static Map<String, String> doubleQuotesOpenToClose = {"“": "”", "\"": "\""};
  static Map<String, String> doubleQuotesCloseToOpen = {"”": "“", "\"": "\""};
  static Map<String, String> singleQuotesOpenToClose = {"‘": "’", "'": "'"};
  static Map<String, String> singleQuotesCloseToOpen = {"’": "‘", "'": "'"};

  static Map<String, String> bracketOpenToClose = {
    "(": ")",
    "（": "）",
    "〈": "〉",
    "《": "》",
    "[": "]",
    "［": "］",
    "〔": "〕",
    "【": "】",
    "{": "}",
    "｛": "｝",
    "「": "」",
    "『": "』"
  };
  static Map<String, String> bracketCloseToOpen = {
    ")": "(",
    "）": "（",
    "〉": "〈",
    "》": "《",
    "]": "[",
    "］": "［",
    "〕": "〔",
    "】": "【",
    "}": "{",
    "｝": "｛",
    "」": "「",
    "』": "『"
  };

  static final List<String> lowerAlphabets = alphabets;
  static List<String> upperAlphabets = _setUpperAlphabets();
  static List<String> special = _setSpecial();

  static List<String> _setUpperAlphabets() {
    List<String> upperAlphabets = [];
    for (String s in alphabets) {
      upperAlphabets.add(s.toUpperCase());
    }
    return upperAlphabets;
  }

  static List<String> _setSpecial() {
    List<String> special = [];
    special.addAll(punctuation);
    special.addAll(bracket);
    return special;
  }
}
