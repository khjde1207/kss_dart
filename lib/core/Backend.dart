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

import '../base/BackupManager.dart';
import '../base/Base.dart';
import '../base/ChunkWithIndex.dart';
import '../base/Const.dart';
import '../base/SentenceIndex.dart';
import '../base/enumerate/Id.dart';
import '../base/enumerate/Stats.dart';
import '../rule/Rule.dart';
import '../util/IntToBool.dart';

class Backend {
  List<String> realignByQuote(String text, int lastQuotePos, String quoteType, bool useHeuristic, bool useQuotesBracketsProcessing,
      int maxRecoverStep, int maxRecoverLength, int recoverStep) {
    List<String> beforeQuote = splitSentences(
        text.substring(0, lastQuotePos), useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, recoverStep, false);

    String beforeLast = beforeQuote.isNotEmpty ? beforeQuote.last : "";
    beforeQuote = beforeQuote.length == 1 ? [] : beforeQuote;

    List<String> afterQuote = splitSentences(
        text.substring(lastQuotePos + 1), useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, recoverStep, false);

    String afterFirst = afterQuote.isNotEmpty ? afterQuote.first : "";

    afterQuote = afterQuote.length == 1 ? [] : afterQuote.getRange(1, afterQuote.length - 1).toList();

    List<String> middleQuote = [];
    middleQuote.add(beforeLast + quoteType + afterFirst);
    List<String> results = [];

    results.addAll(beforeQuote);
    results.addAll(middleQuote);
    results.addAll(afterQuote);

    return results;
  }

  List<String> lindexSplit(String text, List<int> indices) {
    List<int> args = [];
    args.add(0);

    for (int data in indices) {
      args.add(data + 1);
    }
    args.add(text.length + 1);

    List<List<int>> zipped = [];
    for (int i = 0; i < args.length; i++) {
      if (i != args.length - 1) {
        List<int> newList = [];
        newList.add(args.elementAt(i));
        newList.add(args.elementAt(i + 1));
        zipped.add(newList);
      }
    }
    List<String> newList = [];
    for (List<int> zip in zipped) {
      newList.add(text.substring(zip.elementAt(0), zip.elementAt(1) - 1));
    }
    return newList;
  }

  List<int> findAll(String aStr, String sub) {
    int start = 0;
    List<int> output = [];
    while (true) {
      start = aStr.indexOf(sub, start);
      if (start == -1) {
        break;
      }
      output.add(start + sub.length);
      start += sub.length;
    }
    return output;
  }

  List<String> postProcessing(List<String> results, List<String> postProcessingList) {
    List<String> finalResults = [];
    for (String res in results) {
      List<int> splitIdx = [];
      List<String> qoutes = [];
      bool findQuotes = false;
      qoutes.addAll(Const.singleQuotes);
      qoutes.addAll(Const.doubleQuotes);
      qoutes.addAll(Const.bracket);

      for (String qt in qoutes) {
        if (res.contains(qt)) {
          findQuotes = true;
          break;
        }
      }
      if (!findQuotes) {
        for (var i = 0; i < postProcessingList.length; i++) {
          var post = postProcessingList[i];
          if (res.contains(post)) {
            splitIdx.addAll(findAll(res, postProcessingList[i + 1]));
          }
        }
        // for (String post in postProcessingList) {
        //     if (res.contains(post)) {
        //         splitIdx.addAll(findAll(res, post + 1));
        //     }
        // }
      }
      splitIdx.sort((a, b) => a.compareTo(b));
      finalResults.addAll(lindexSplit(res, splitIdx));
    }
    return finalResults;
  }

  List<String> endPoint = _setEndPoint();
  List<String> needToReplaceZwsp = _setNeedToReplaceZwsp();

  static List<String> _setEndPoint() {
    List<String> list = [];
    list.addAll(Const.singleQuotes);
    list.addAll(Const.doubleQuotes);
    list.addAll(Const.bracket);
    list.addAll(Const.punctuation);
    list.add(" ");
    list.add("");
    list.addAll(Rule.commonValue.keys);
    return list;
  }

  static List<String> _setNeedToReplaceZwsp() {
    List<String> list = [];
    list.addAll(Const.singleQuotes);
    list.addAll(Const.doubleQuotes);
    list.addAll(Const.bracket);
    return list;
  }

  List<String> splitSentences(
      String text, bool useHeuristic, bool useQuotesBracketsProcessing, int maxRecoverStep, int maxRecoverLength, int recoverStep, bool useStrip) {
    if (text.length > maxRecoverLength) {
      maxRecoverStep = 0;
    }

    text = text.replaceAll("\u200b", "");
    BackupManager backupManager = BackupManager();

    List<String> doubleQuoteStack = [];
    List<String> singleQuoteStack = [];
    List<String> bracketStack = [];
    List<String> tests = ["다", "요", "죠", "함", "음"];

    for (int i = 0; i < text.length; i++) {
      String ch = text[i];
      if (tests.contains(ch)) {
        if (i != text.length - 1) {
          if (!endPoint.contains(text[i + 1])) {
            String targetToBackup = ch + text[i + 1];
            backupManager.addItem2Dict(targetToBackup, targetToBackup.hashCode.abs().toString());
          }
        }
      }
    }

    text = backupManager.backup(text);
    for (String s in needToReplaceZwsp) {
      text = text.replaceAll(s, "\u200b$s\u200b");
    }

    String prev = "";
    String curSentence = "";
    List<String> results = [];
    int curStat = Stats.DEFAULT;

    int lastSingleQuotePos = 0;
    int lastDoubleQuotePos = 0;
    int lastBracketPos = 0;

    String singleQuotePop = "'";
    String doubleQuotePop = "\"";
    String bracketPoP = " ";

    for (int i = 0; i < text.length; i++) {
      List<String> code = [".", "!", "?"];
      String ch = text[i];

      if (curStat == Stats.DEFAULT) {
        if (Const.doubleQuotes.contains(ch)) {
          if (useQuotesBracketsProcessing) {
            if (Const.doubleQuotesOpenToClose.containsKey(ch)) {
              doubleQuotePop = Base.doPushPopSymbol(doubleQuoteStack, Const.doubleQuotesOpenToClose[ch] ?? "", ch);
            } else {
              doubleQuotePop = Base.doPushPopSymbol(doubleQuoteStack, Const.doubleQuotesCloseToOpen[ch] ?? "", ch);
            }
            lastDoubleQuotePos = i;
          }
        } else if (Const.singleQuotes.contains(ch)) {
          if (useQuotesBracketsProcessing) {
            if (Const.singleQuotesOpenToClose.containsKey(ch)) {
              singleQuotePop = Base.doPushPopSymbol(singleQuoteStack, Const.singleQuotesOpenToClose[ch] ?? "", ch);
            } else {
              singleQuotePop = Base.doPushPopSymbol(singleQuoteStack, Const.singleQuotesCloseToOpen[ch] ?? "", ch);
            }
            lastSingleQuotePos = i;
          }
        } else if (Const.bracket.contains(ch)) {
          if (useQuotesBracketsProcessing) {
            if (Const.bracketOpenToClose.containsKey(ch)) {
              bracketPoP = Base.doPushPopSymbol(bracketStack, Const.bracketOpenToClose[ch] ?? "", ch);
            } else {
              bracketPoP = Base.doPushPopSymbol(bracketStack, Const.bracketCloseToOpen[ch] ?? "", ch);
            }
            lastBracketPos = i;
          }
        } else if (code.contains(ch)) {
          if (doubleQuoteStack.isEmpty &&
              singleQuoteStack.isEmpty &&
              bracketStack.isEmpty &&
              Utils.intToBool(Rule.table[Stats.SB]?[prev] ?? 0 & Id.PREV)) {
            curStat = Stats.SB;
          }
        }

        if (useHeuristic) {
          if (ch == "다") {
            if (doubleQuoteStack.isEmpty &&
                singleQuoteStack.isEmpty &&
                bracketStack.isEmpty &&
                Utils.intToBool(Rule.table[Stats.DA]?[prev] ?? 0 & Id.PREV)) {
              curStat = Stats.DA;
            }
          }

          if (ch == "요") {
            if (doubleQuoteStack.isEmpty &&
                singleQuoteStack.isEmpty &&
                bracketStack.isEmpty &&
                Utils.intToBool(Rule.table[Stats.YO]?[prev] ?? 0 & Id.PREV)) {
              curStat = Stats.YO;
            }
          }
          if (ch == "죠") {
            if (doubleQuoteStack.isEmpty &&
                singleQuoteStack.isEmpty &&
                bracketStack.isEmpty &&
                Utils.intToBool(Rule.table[Stats.JYO]?[prev] ?? 0 & Id.PREV)) {
              curStat = Stats.JYO;
            }
          }
          if (ch == "함") {
            if (doubleQuoteStack.isEmpty &&
                singleQuoteStack.isEmpty &&
                bracketStack.isEmpty &&
                Utils.intToBool(Rule.table[Stats.HAM]?[prev] ?? 0 & Id.PREV)) {
              curStat = Stats.HAM;
            }
          }
          if (ch == "음") {
            if (doubleQuoteStack.isEmpty &&
                singleQuoteStack.isEmpty &&
                bracketStack.isEmpty &&
                Utils.intToBool(Rule.table[Stats.UM]?[prev] ?? 0 & Id.PREV)) {
              curStat = Stats.UM;
            }
          }
        }
      } else {
        if (Const.doubleQuotes.contains(ch)) {
          lastDoubleQuotePos = i;
        } else if (Const.singleQuotes.contains(ch)) {
          lastSingleQuotePos = i;
        } else if (Const.bracket.contains(ch)) {
          lastBracketPos = i;
        }

        bool endIf = false;
        if (!endIf) {
          if (ch == " " || Utils.intToBool(Rule.table[Stats.COMMON]?[ch] ?? 0 & Id.CONT)) {
            if (Utils.intToBool(Rule.table[curStat]?[Id.PREV] ?? 0 & Id.NEXT1)) {
              curSentence = Base.doTrimSentPushResults(curSentence, results);

              curSentence += prev;
              curStat = Stats.DEFAULT;
            }
            endIf = true;
          }
        }
        if (!endIf) {
          if (Utils.intToBool(Rule.table[curStat]?[ch] ?? 0 & Id.NEXT)) {
            if (Utils.intToBool(Rule.table[curStat]?[prev] ?? 0 & Id.NEXT1)) {
              curSentence += prev;
            }
            curStat = Stats.DEFAULT;
            endIf = true;
          }
        }
        if (!endIf) {
          if (Utils.intToBool(Rule.table[curStat]?[ch] ?? 0 & Id.NEXT1)) {
            if (Utils.intToBool(Rule.table[curStat]?[prev] ?? 0 & Id.NEXT1)) {
              curSentence = Base.doTrimSentPushResults(curSentence, results);

              curSentence += prev;
              curStat = Stats.DEFAULT;
            }
            endIf = true;
          }
        }

        if (!endIf) {
          if (Utils.intToBool(Rule.table[curStat]?[ch] ?? 0 & Id.NEXT2)) {
            if (Utils.intToBool(Rule.table[curStat]?[prev] ?? 0 & Id.NEXT1)) {
              curSentence += prev;
            } else {
              curSentence = Base.doTrimSentPushResults(curSentence, results);
            }
            curStat = Stats.DEFAULT;
            endIf = true;
          }
        }
        if (!endIf) {
          if (!Utils.intToBool(Rule.table[curStat]?[ch] ?? 0) || Utils.intToBool(Rule.table[curStat]?[ch] ?? 0 & Id.PREV)) {
            curSentence = Base.doTrimSentPushResults(curSentence, results);

            if (Utils.intToBool(Rule.table[curStat]?[prev] ?? 0 & Id.NEXT1)) {
              curSentence += prev;
            }

            curStat = Stats.DEFAULT;

            if (Const.bracket.contains(ch)) {
              if (useQuotesBracketsProcessing) {
                if (Const.bracketOpenToClose.containsKey(ch)) {
                  bracketPoP = Base.doPushPopSymbol(bracketStack, Const.bracketOpenToClose[ch] ?? "", ch);
                } else {
                  bracketPoP = Base.doPushPopSymbol(bracketStack, Const.bracketCloseToOpen[ch] ?? "", ch);
                }
                lastBracketPos = i;
              }
            } else if (Const.doubleQuotes.contains(ch)) {
              if (useQuotesBracketsProcessing) {
                if (Const.doubleQuotesOpenToClose.containsKey(ch)) {
                  doubleQuotePop = Base.doPushPopSymbol(doubleQuoteStack, Const.doubleQuotesOpenToClose[ch] ?? "", ch);
                } else {
                  doubleQuotePop = Base.doPushPopSymbol(doubleQuoteStack, Const.doubleQuotesCloseToOpen[ch] ?? "", ch);
                }
                lastDoubleQuotePos = i;
              }
            } else if (Const.singleQuotes.contains(ch)) {
              if (useQuotesBracketsProcessing) {
                if (Const.singleQuotesOpenToClose.containsKey(ch)) {
                  singleQuotePop = Base.doPushPopSymbol(singleQuoteStack, Const.singleQuotesOpenToClose[ch] ?? "", ch);
                } else {
                  singleQuotePop = Base.doPushPopSymbol(singleQuoteStack, Const.singleQuotesCloseToOpen[ch] ?? "", ch);
                }
                lastSingleQuotePos = i;
              }
            }
            endIf = true;
          }
        }
      }

      if (curStat == Stats.DEFAULT || !Utils.intToBool((Rule.table[curStat]?[ch] ?? 0 & Id.NEXT1))) {
        curSentence += ch;
      }

      prev = ch;
    }

    if (curSentence.isNotEmpty) {
      curSentence = Base.doTrimSentPushResults(curSentence, results);
    }
    if (Utils.intToBool(Rule.table[curStat]?[prev] ?? 0 & Id.NEXT1)) {
      curSentence += prev;
      Base.doTrimSentPushResults(curSentence, results);
    }

    if (useHeuristic) {
      if (text.contains("다 ")) {
        results = postProcessing(results, Rule.postProcessingDa);
      }
      if (text.contains("요 ")) {
        results = postProcessing(results, Rule.postProcessingYo);
      }
      if (text.contains("죠 ")) {
        results = postProcessing(results, Rule.postProcessingJyo);
      }
      if (text.contains("함 ")) {
        results = postProcessing(results, Rule.postProcessingHam);
      }
      if (text.contains("음 ")) {
        results = postProcessing(results, Rule.postProcessingUm);
      }
    }
    if (singleQuoteStack.isNotEmpty && recoverStep < maxRecoverStep) {
      results = realignByQuote(
          text, lastSingleQuotePos, singleQuotePop, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, recoverStep + 1);
    }
    if (doubleQuoteStack.isNotEmpty && recoverStep < maxRecoverStep) {
      results = realignByQuote(
          text, lastDoubleQuotePos, doubleQuotePop, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, recoverStep + 1);
    }
    if (bracketStack.isNotEmpty && recoverStep < maxRecoverStep) {
      results = realignByQuote(
          text, lastBracketPos, bracketPoP, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, recoverStep + 1);
    }

    List<String> resultList = [];

    for (String s in results) {
      s = backupManager.restore(s);
      s = s.replaceAll("\u200b", "");
      resultList.add(useStrip ? s.trim() : s);
    }

    results.addAll(resultList);
    return resultList;
  }

  List<SentenceIndex> splitSentencesIndex(
      String text, bool useHeuristic, bool useQuotesBracketsProcessing, int maxRecoverStep, int maxRecoverLength) {
    List<String> sentences = splitSentences(text, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength, 0, true);

    List<SentenceIndex> sentenceIndexes = [];
    int offset = 0;

    for (String sentence in sentences) {
      sentenceIndexes.add(new SentenceIndex(start: offset + text.indexOf(sentence), end: offset + text.indexOf(sentence) + sentence.length));

      offset += text.indexOf(sentence) + sentence.length;
      text = text.substring(text.indexOf(sentence) + sentence.length);
    }
    return sentenceIndexes;
  }

  List<ChunkWithIndex> splitChunks(
      String text, int maxLength, bool overlap, bool useHeuristic, bool useQuotesBracketsProcessing, int maxRecoverStep, int maxRecoverLength) {
    List<SentenceIndex> span = [];
    List<ChunkWithIndex> chunks = [];

    List<SentenceIndex> indices = splitSentencesIndex(text, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength);

    for (SentenceIndex index in indices) {
      if (span.length > 0) {
        if (index.getEnd() - span.elementAt(0).getStart() > maxLength) {
          chunks.add(getChunkWithIndex(span, text));
          if (overlap) {
            double halfSpanSize = span.length / 2.0;
            span = List.from(span.getRange((halfSpanSize - (halfSpanSize % 1)).toInt(), span.length));
          } else {
            span = [];
          }
        }
      }
      span.add(index);
    }

    chunks.add(getChunkWithIndex(span, text));
    return chunks;
  }

  ChunkWithIndex getChunkWithIndex(List<SentenceIndex> span, String text) {
    int start = span.elementAt(0).getStart();
    int end = span.last.getEnd();

    return ChunkWithIndex(start: span.first.getStart(), text: text.substring(start, end));
  }
}
