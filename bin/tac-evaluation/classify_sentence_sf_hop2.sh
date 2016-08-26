#!/usr/bin/env bash

CANDIDATES=$1
HOP2_QUERY_EXPANDED=$2
HOP2_QUERY_ORG=$3
HOP1_RESPONSE=$4
OUT=$5
GPU=$6

TAC_EVAL_ROOT=${TH_RELEX_ROOT}/bin/tac-evaluation

MODEL_USchema=${TH_RELEX_ROOT}/models/uschema-english-relogged-100d_ep_weight_more_data/2016-07-30_15/15-model
VOCAB_USchema=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_for_USchema_weighted_2_ep_avg_max_more_data_training/training_vocab-relations.txt
#TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2014_tune/params 
#TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2012-2015_tune/params 
#TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/KDE_tune/params_t0.25_manually_tuned
TUNED_PARAMS_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/hop2_tuned/params_hop2
TUNED_PARAMS_USchema_HOP1=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/hop2_tuned/params_hop1
#OUT_USchema=${TH_RELEX_ROOT}/results/USchema_100d_weighted_2_ep_avg_max_more_data_15/2015-kb
OUT_USchema=${OUT}/USchema
mkdir -p $OUT_USchema

#MODEL_LSTM=${TH_RELEX_ROOT}/models/lstm-bi-maxpool-paper_USchema_init_weighted_2_ep_more_data_normal/2016-08-01_20/9-model 
#MODEL_LSTM=${TH_RELEX_ROOT}/models/lstm-bi-maxpool-paper_USchema_init_weighted_2_ep_even_more/2016-08-08_15/15-model
MODEL_LSTM=${TH_RELEX_ROOT}/models/lstm-bi-maxpool-paper_USchema_init_weighted_2_ep_even_more_aug/2016-08-10_01/15-model
#VOCAB_LSTM=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_weighted_2_ep_more_data_normal_training/training_vocab-tokens.txt 
#VOCAB_LSTM=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_weighted_2_ep_even_more_training/training_vocab-tokens.txt 
VOCAB_LSTM=/iesl/canvas/hschang/TAC_2016/codes/torch-relation-extraction/data/train_processed_files/Ben_weighted_2_ep_even_more_aug_training/training_vocab-tokens.txt 
#TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_more_data_normal_max_seq_9/2014_tune/params 
#TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_even_more_aug_15/2012-2015_tune/params
#TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_even_more_aug_15/KDE_tune/params_t0.25_manual_tuned
TUNED_PARAMS_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_even_more_aug_15/hop2_tuned/params_hop2
TUNED_PARAMS_LSTM_HOP1=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_even_more_aug_15/hop2_tuned/params_hop1
OUT_LSTM=${OUT}/LSTM
mkdir -p $OUT_LSTM

#OUT_LSTM=${TH_RELEX_ROOT}/results/LSTM_USchema_org_weighted_2_ep_more_data_normal_max_seq_9/2015-kb

MAX_SEQ=20

${TH_RELEX_ROOT}/bin/tac-evaluation/score-tuned_for_sf_pipeline_hop2.sh $CANDIDATES $HOP2_QUERY_EXPANDED $HOP2_QUERY_ORG $MODEL_USchema $VOCAB_USchema $GPU $MAX_SEQ $TUNED_PARAMS_USchema $TUNED_PARAMS_USchema_HOP1 $HOP1_RESPONSE $OUT_USchema -logRelations -relations

${TH_RELEX_ROOT}/bin/tac-evaluation/score-tuned_for_sf_pipeline_hop2.sh $CANDIDATES $HOP2_QUERY_EXPANDED $HOP2_QUERY_ORG $MODEL_LSTM $VOCAB_LSTM $GPU $MAX_SEQ $TUNED_PARAMS_LSTM $TUNED_PARAMS_LSTM_HOP1 $HOP1_RESPONSE $OUT_LSTM

mkdir -p ${OUT}

RESPONSE="${OUT}/response"

#cat ${OUT_LSTM}/response ${OUT_USchema}/response > $RESPONSE
cat ${OUT_LSTM}/response_hop1_filtering ${OUT_USchema}/response_hop1_filtering > $RESPONSE
