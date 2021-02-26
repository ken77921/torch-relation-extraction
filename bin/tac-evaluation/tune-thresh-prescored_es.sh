#!/usr/bin/env bash

YEAR=$1
SCORED_CANDIDATES=$2
OUT=$3

#THRESHOLDS="0.0 0.1 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.9 1.0"
#THRESHOLDS="0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.9 1.0"
THRESHOLDS="0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.9 1.0"
#THRESHOLDS="0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.9 1.0"

TAC_EVAL_ROOT=${TH_RELEX_ROOT}/bin/tac-evaluation
source ${TAC_EVAL_ROOT}/configs/${YEAR}

HAVE_SPACE_DIR=/iesl/canvas/hschang/temp

TMP_DIR=`mktemp -d -p $HAVE_SPACE_DIR`
echo "Working in temp directory $TMP_DIR"
PRED_ROOT=${TMP_DIR}/prediction_
for t in ${THRESHOLDS}; do
    echo "GETTING TOP $t"
    THRESH_CANDIDATES=`mktemp -p $HAVE_SPACE_DIR`
    awk -v threshold=$t -F '\t' '{if($9 >= threshold) print  }' ${SCORED_CANDIDATES} > ${THRESH_CANDIDATES}

    echo "Converting scored candidate to response file"
    RESPONSE=`mktemp -p $HAVE_SPACE_DIR`
    ${TAC_ROOT}/components/bin/response.sh ${QUERY_EXPANDED} ${THRESH_CANDIDATES} ${RESPONSE}
    #${TAC_ROOT}/components/bin/response_inv.sh ${QUERY_EXPANDED} ${THRESH_CANDIDATES} ${RESPONSE}

    echo "Post processing response for year $YEAR"
    RESPONSE_PP=${PRED_ROOT}${t}
    ${TAC_EVAL_ROOT}/post-process-response.sh ${YEAR} ${PP} ${QUERY_EXPANDED} ${RESPONSE} ${RESPONSE_PP}
done

echo "Tuning per Relation and exporting best params to $OUT"

echo "-----------------------"
echo "${TAC_SCRIPTS}/tunej.sh ${KEY} ${SCORE_SCRIPT} ${PRED_ROOT} ${OUT} ${THRESHOLDS} | grep -e " F1" -e Tuning"
echo "-------------------------"

TAC_SCRIPTS=${TH_RELEX_ROOT}/bin/tac-evaluation/eval-scripts
${TAC_SCRIPTS}/tunej.sh ${KEY} ${SCORE_SCRIPT} ${PRED_ROOT} ${OUT} ${THRESHOLDS} | grep -e " F1" -e Tuning
rm -rf ${TMP_DIR}
echo "Done. F1 : `cat ${OUT}/F1`"
