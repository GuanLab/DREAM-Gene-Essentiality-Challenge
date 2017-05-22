# Final_Method
## calculate_corr.m
### Summay
Calculate Pearson Correlations between the CCLE-EXP gene and PR gene.
### Input
#### 1. Achilles_v2.11_training_phase3.gct.noheader
The original dataset downloaded [here](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825) with the header (i.e. the first and second line) deleted. 
#### 2. CCLE_expression_training_phase3.gct.noheader
The original dataset downloaded [here](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825) with the header (i.e. the first and second line) deleted. 
### Output 
#### 1. pearson_matrix_all.txt
A matrix of Pearson scores between PR genes and CCLE-EXP genes. 

<br><br><br><br>
## generate_GE_top_100.pl
### Summary
Obtain the global ranking informatiom of each feature, which would be used to calculate global scores.
### Input
#### 1. prioritized_gene_list_phase3.txt
A list of genes whose essentiality need to be predicted. [Download](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825)
#### 2. pearson_matrix_all.txt
A matrix of Pearson scores between PR genes and CCLE-EXP genes. Generated by `calculate_corr.m` 

### Output
#### 1.feature_list.txt
A two-column table containing feature names and how many times this feature's local score was top 10. This table would be used to calculated global scores.

<br><br><br><br>
## get_top_prior_2300.pl
### Summary
Use local scores and global rankings to calculate final correlation score. Then output the name of top 9 expression features and 1 copy number feature for each PR gene. One commandline parameter required. We used 0.7 in this project. 
Example: perl get_top_prior_2300.pl 0.7 
 
### Input
#### 1. feature_list.txt
A two-column table containing feature names and how many times this feature's local score was top 10. Generated by `generate_GE_top_100.pl`.

#### 2. CCLE_copynumber_training_phase3.gct
Unprocess copy number data. [Download](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825)
#### 3. pearson_matrix_all.txt
A matrix of Pearson scores between PR genes and CCLE-EXP genes. Generated by `calculate_corr.m` 

### Output
#### 1. GE_train_top_10
A table of the name of the 10 predictive features of each PR gene.
<br><br><br><br>
## extract_value_svm.pl
### Summary
Generate formated SVM input file for training dataset.
### Input
#### 1. CCLE_expression_training_phase3.gct
Unprocess gene expression data. [Download](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825)
#### 2. CCLE_copynumber_training_phase3.gct
Unprocess copy number data. [Download](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825)
#### 3. GE_train_top_10
Generated by `get_top_prior_2300.pl`
#### 4. prioritized_gene_list_phase3.txt
A list of genes whose essentiality need to be predicted. [Download](https://www.synapse.org/#!Synapse:syn2384331/wiki/62825)
#### 5. Achilles_v2.11_training_phase3.gct.scaled.pos
Achilles scores scaled by min and max. See main text for more information.
### Output
#### 1. {GENE}.train.input
This is the SVM input file for training dataset.
<br><br><br><br>
## extract_value_svm_test.pl
### Summary
Similar to `extract_value_svm.pl`, but generate SVM input files for testing data.
### Input
Same as `extract_value_svm.pl`.
### Output
#### 1. {GENE}.test.input
This is the SVM input file for testing dataset.
<br><br><br><br>
## test_svm_c.pl
### Summay
Use SVM to do linear regression and perform prediction on testing dataset. One commandline parameter required. We used 0.005 in this project. 
Example: perl test_svm_c.pl 0.005 
### Input
#### 1. {GENE}.train.input
SVM input files for training data. Generated by `extract_value_svm.pl`.
#### 2. {GENE}.test.input
SVM input files for testing data. Generated by `extract_value_svm_test.pl`.
### Output
#### 1. {GENE}.model.input
The model for a specific gene.
#### 2. {GENE}.out.input
The predicted essenciality score of a specific gene in testing cell lines.

<br><br><br><br>
# Cross_Validation
## CV_alpha
This folder contains scripts for 5-fold cross-validation testing alternative alpha values.

## CV_different_regression_methods
This folder contains scripts for 5-fold cross-validation testing different regression algorithms.

## CV_3-30_features

This folder contains scripts for 5-fold cross-validation testing a bunch of alternative numbers (3,4,5...30) of features used for prediction.
## CV_no_copynumber
This folder contains scripts for 5-fold cross-validation testing the performance of using only top 10 expression features as the 10 predictive features.
## CV_rank_only_cn
This folder contains scripts for 5-fold cross-validation testing the performance of using only top 10 copy numbers as the 10 predictive features.
## CV_rank_exp_cn
This folder contains scripts for 5-fold cross-validation testing the performance of putting copy number profile and expression profile together and use the top 10 in the mixed features as the 10 predictive features.

