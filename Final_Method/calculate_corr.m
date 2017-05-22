clear;
scores = importdata('Achilles_v2.11_training_phase3.gct.noheader.txt');
expressions = importdata('CCLE_expression_training_phase3.gct.noheader');

corPearson = corr(transpose(scores.data),transpose(expressions.data));
dlmwrite('pearson_matrix_all.txt',corPearson);

