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

class Stats {
  static int DEFAULT = 0;
  static int DA = 1;
  static int YO = 2;
  static int JYO = 3;
  static int HAM = 4;
  static int UM = 5;
  static int SB = 6;
  static int COMMON = 7;
  static int _value = DEFAULT;
  static int getValue() => _value;
}
