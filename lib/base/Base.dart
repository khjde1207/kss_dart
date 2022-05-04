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
class Base {
  static bool empty(dynamic o) {
    return o.isEmpty;
  }

  static bool top(List<String> stack, String symbol) {
    return true; //Objects.equals(stack.peek(), symbol);
  }

  static String doPushPopSymbol(List<String> stack, String symbol, String currentCh) {
    if (empty(stack)) {
      stack.add(symbol);
    } else {
      if (top(stack, currentCh)) {
        stack.removeLast();
      } else {
        stack.add(symbol);
      }
    }
    return currentCh;
  }

  static String doTrimSentPushResults(String curSentence, List<String> results) {
    results.add(curSentence.trim());
    curSentence = "";
    return curSentence;
  }
}
