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

class Id {
  static int NONE = 0;
  static int PREV = 1 << 0;
  static int CONT = 1 << 1;
  static int NEXT = 1 << 2;
  static int NEXT1 = 1 << 3;
  static int NEXT2 = 1 << 4;
  static int _value = NONE;
  static int getValue() => _value;
}
