#!/usr/bin/env bash
#
# Runs the English PCFG parser on one or more files, printing trees only

if [ ! $# -ge 1 ]; then
  echo Usage: `basename $0` 'file(s)'
  echo
  exit
fi


pv "$@" \
  | java -Xmx4g -cp "$STANFORD_PARSER_HOME/*" \
        edu.stanford.nlp.pipeline.StanfordCoreNLP \
        -annotators "tokenize,ssplit,pos,parse" \
        -parse.model edu/stanford/nlp/models/srparser/englishSR.ser.gz \
        -ssplit.eolonly true -tokenize.whitespace true \
        -numThreads 4 \
        -output.prettyPrint False -output.includeText False \
        2> /dev/null  \
   | sed 's,^\(<.*\)\((ROOT.*\)$,\1\n\2,g' \
   | grep -v '^<' \
   | sed 's,^[ ]\+, ,g' \
   | perl -ne 'if (!/^$/) { chomp } print'
