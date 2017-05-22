clear;
scores = importdata('Achilles_v2.11_training_phase3.gct.noheader_train.txt');
expressions = importdata('CCLE_expression_copy_train.txt');

corPearson = corr(transpose(scores.data),transpose(expressions.data));
dlmwrite('pearson_matrix_train.txt',corPearson);

