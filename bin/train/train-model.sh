#!/usr/bin/env bash

GPU_ID=$1
CONFIG=$2

source ${TH_RELEX_ROOT}/${CONFIG}

DATE=`date +'%Y-%m-%d_%k'`
mkdir ${SAVE_MODEL_ROOT} ${RESULT_ROOT}

RUN_CMD="th ${TH_RELEX_ROOT}/src/${MODEL}.lua \
-train ${TRAIN_FILE_ROOT}/${TRAIN_FILE} \
-saveModel ${SAVE_MODEL_ROOT}/${MODEL}_${TRAIN_FILE}  \
-maxSeq $MAX_SEQ \
-learningRate $LEARN_RATE \
-gpuid ${GPU_ID} \
-embeddingDim ${EMBED_DIM} \
-numEpochs ${MAX_EPOCHS} \
"

if [ "$WORD_DIM" ]; then
  RUN_CMD="$RUN_CMD -wordDim $WORD_DIM"
fi
if [ "$REL_DIM" ]; then
  RUN_CMD="$RUN_CMD -relDim $REL_DIM"
fi
if [ "$DROPOUT" ]; then
  RUN_CMD="$RUN_CMD -dropout $DROPOUT"
fi
if [ "$TEST_FILE" ]; then
  RUN_CMD="$RUN_CMD -test $TEST_FILE"
fi
if [ "$TRAINED_EP" ]; then
  RUN_CMD="$RUN_CMD -loadEpEmbeddings $TRAINED_EP"
fi

echo "Training : ${MODEL}_${TRAIN_FILE}\tGPU : $GPU_ID"
echo "$RUN_CMD"
${RUN_CMD} | tee ${RESULT_ROOT}/${MODEL}_${TRAIN}
