#!/usr/bin/env bash

CANDIDATES=$1
QUERY_EXPANDED=$2
OUT=$3
GPU=$4

TAC_EVAL_ROOT=${TH_RELEX_ROOT}/bin/tac-evaluation

MODEL_USchema=${TH_RELEX_ROOT}/models/uschema-english-relogged-100d_ep_weight_more_data/2016-07-30_15/15-model
VOCAB_USchema=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_for_USchema_weighted_2_ep_avg_max_more_data_training/training_vocab-relations.txt
#TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2014_tune/params 
TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2015_tune/params 
#OUT_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2015-kb
OUT_USchema=${OUT}/USchema
mkdir -p $OUT_USchema

#MODEL_LSTM=${TH_RELEX_ROOT}/models/lstm-bi-maxpool-paper_USchema_init_weighted_2_ep_more_data_normal/2016-08-01_20/9-model 
MODEL_LSTM=${TH_RELEX_ROOT}/models/lstm-bi-maxpool-paper_USchema_init_weighted_2_ep_even_more/2016-08-04_23/15-model
#VOCAB_LSTM=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_weighted_2_ep_more_data_normal_training/training_vocab-tokens.txt 
VOCAB_LSTM=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_weighted_2_ep_even_more_training/training_vocab-tokens.txt 
#TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_more_data_normal_max_seq_9/2014_tune/params 
TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_even_more_15/2014_tune/params
OUT_LSTM=${OUT}/LSTM
mkdir -p $OUT_LSTM

#OUT_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_more_data_normal_max_seq_9/2015-kb

MAX_SEQ=20

${TH_RELEX_ROOT}/bin/tac-evaluation/score-tuned_for_sf_pipeline.sh $CANDIDATES $QUERY_EXPANDED $MODEL_USchema $VOCAB_USchema $GPU $MAX_SEQ $TUNED_PARAMS_USchema $OUT_USchema -logRelations -relations

${TH_RELEX_ROOT}/bin/tac-evaluation/score-tuned_for_sf_pipeline.sh $CANDIDATES $QUERY_EXPANDED $MODEL_LSTM $VOCAB_LSTM $GPU $MAX_SEQ $TUNED_PARAMS_LSTM $OUT_LSTM

mkdir -p ${OUT}

RESPONSE="${OUT}/response"

cat ${OUT_LSTM}/response ${OUT_USchema}/response > $RESPONSE
