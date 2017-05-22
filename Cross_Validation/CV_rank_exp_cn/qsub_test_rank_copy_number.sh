#!/bin/bash
   
#PBS -l walltime=200:05:00
#PBS -N feature10
   
cd /state4
mkdir -p tyli/job1
cd /state4/tyli/job1
 
scp -r guanlab12:/state2/state1/cv2/25_cv_folder_rank_only_copy_number/$1 .

ii=10
	#cd $1
	
	#rm pearson_matrix_train.txt pearson_matrix_train_top300.txt feature_list_train.txt
	
	#tail -n +2 CCLE_copynumber_training_phase3.gct.noheader_train > CCLE_copynumber_training_phase3.gct.noheader_train_nocolnames
	#cat CCLE_expression_training_phase3.gct.noheader_train.txt CCLE_copynumber_training_phase3.gct.noheader_train_nocolnames > CCLE_expression_copy_train.txt
	#matlab -nodesktop -nosplash -nodisplay -r "run ~/cv_scripts_rank_only_cn/calculate_corr.m ; quit;" 
	#cat  ~/cv_scripts_rank_only_cn/calculate_corr.m | matlab -nodesktop -nosplash  #change this
	
	#cd ../
	perl ~/cv_scripts_rank_only_cn/get_top_300_cor.pl $1
	perl ~/cv_scripts_rank_only_cn/generate_GE_top_100.pl $1

#=====================================================================================	
	perl ~/cv_scripts_rank_only_cn/get_top_prior_2300.pl $ii $1
        echo "Step 1 completed!"
        perl ~/cv_scripts_rank_only_cn/extract_value_svm.pl $ii $1
        echo "Step 2 completed!"
        perl ~/cv_scripts_rank_only_cn/extract_value_svm_test.pl $ii $1
        echo "Step 3 completed!"
        
        
	files=`ls $1/svm_input_feature$ii | grep testref`
	for fi in $files
	do
		new="${fi/testref/test}"
		awk '{$1=0;print}' $1/svm_input_feature$ii/$fi > $1/svm_input_feature$ii/$new
	done
	
	echo "Step 4 completed!"
	perl ~/cv_scripts_rank_only_cn/perform_svm.pl $1/svm_input_feature$ii
	echo "Step 5 completed!"
	perl ~/cv_scripts_rank_only_cn/svm_results_correlation.pl $1/svm_input_feature$ii > $1/all_scores_feature_rank_copynumber.txt
	echo "Step 6 completed!"
#=============================================================================================

scp -pr $1 guanlab12:/state2/state1/cv2/25_cv_folder_rank_only_copy_number_results/


rm -r $1
~                                                                                                                                                      
~                     
