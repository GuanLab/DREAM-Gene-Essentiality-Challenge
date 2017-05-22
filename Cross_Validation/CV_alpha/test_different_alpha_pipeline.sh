# one required argument:


# $1: the fist argument for this script is the directory of one cv file, eg. cv_1_21

for ii in $(seq 0 0.1 1) #ii is alpha
do
        perl ~/cv_scripts/get_top_prior_2300.pl $ii $1
        #echo "Step 1 completed!"
        perl ~/cv_scripts/extract_value_svm.pl $ii $1
        #echo "Step 2 completed!"
        perl ~/cv_scripts/extract_value_svm_test.pl $ii $1
        #echo "Step 3 completed!"


#==========================================================================================================#

	files=`ls $1/svm_input_alpha$ii | grep testref`
	for fi in $files
	do
		new="${fi/testref/test}"
		awk '{$1=0;print}' $1/svm_input_alpha$ii/$fi > $1/svm_input_alpha$ii/$new
	done
	
	#echo "Step 4 completed!"
	perl ~/cv_scripts/perform_svm.pl $1/svm_input_alpha$ii
	#echo "Step 5 completed!"
	perl ~/cv_scripts/svm_results_correlation.pl $1/svm_input_alpha$ii > $1/all_scores_alpha_$ii.txt
	#echo "Step 6 completed!"

done
