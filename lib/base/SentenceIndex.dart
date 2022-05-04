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

class SentenceIndex {
  SentenceIndex({required this.start, required this.end}) {}

  int start;
  int end;

  int getStart() {
    return start;
  }

  void setStart(int start) {
    this.start = start;
  }

  int getEnd() {
    return end;
  }

  void setEnd(int end) {
    this.end = end;
  }

  String toString() {
    return "SentenceIndex{start=$start, end=$end}";
  }
}
