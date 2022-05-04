library kss_dart;

import 'base/ChunkWithIndex.dart';
import 'core/Backend.dart';

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

class Kss {
  Kss() {
    this.kss = new Backend();
  }

  late final Backend kss;

  List<String> splitSentences(String text,
      {bool useHeuristic = true, bool useQuotesBracketProcessing = true, int maxRecoverStep = 5, int maxRecoverLength = 20000}) {
    return kss.splitSentences(text, useHeuristic, useQuotesBracketProcessing, maxRecoverStep, maxRecoverLength, 0, true);
  }

  List<ChunkWithIndex> splitChunks(String text, int maxLength,
      {bool overlap = false,
      bool useHeuristic = true,
      bool useQuotesBracketsProcessing = true,
      int maxRecoverStep = 5,
      int maxRecoverLength = 20000}) {
    return kss.splitChunks(text, maxLength, overlap, useHeuristic, useQuotesBracketsProcessing, maxRecoverStep, maxRecoverLength);
  }
}
