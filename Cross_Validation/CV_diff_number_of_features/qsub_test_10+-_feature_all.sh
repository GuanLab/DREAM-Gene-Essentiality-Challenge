#!/bin/bash
   
#PBS -l walltime=200:05:00
#PBS -N feature10
   
cd /state4
mkdir -p tyli/job1
cd /state4/tyli/job1
 
scp -r guanlab12:/state2/state1/cv2/25_cv_folder_for_10+_feature_all/$1 .

ii=18961 #ii is the number of features
#do
	perl ~/cv_scripts/get_top_300_cor_all.pl $1
	perl ~/cv_scripts/generate_GE_top_100.pl $1

		perl ~/cv_scripts/get_top_prior_2300.pl $ii $1
        echo "Step 1 completed!"
        perl ~/cv_scripts/extract_value_svm.pl $ii $1
        echo "Step 2 completed!"
        perl ~/cv_scripts/extract_value_svm_test.pl $ii $1
        echo "Step 3 completed!"
        
        
	files=`ls $1/svm_input_feature$ii | grep testref`
	for fi in $files
	do
		new="${fi/testref/test}"
		awk '{$1=0;print}' $1/svm_input_feature$ii/$fi > $1/svm_input_feature$ii/$new
	done
	
	echo "Step 4 completed!"
	perl ~/cv_scripts/perform_svm.pl $1/svm_input_feature$ii
	echo "Step 5 completed!"
	perl ~/cv_scripts/svm_results_correlation.pl $1/svm_input_feature$ii > $1/all_scores_feature_$ii.txt
	echo "Step 6 completed!"
#done



scp $1/all_scores_* guanlab12:/state2/state1/cv2/25_cv_folder_for_10+_feature_all/$1


rm -r $1
~                                                                                                                                                      
~                     
