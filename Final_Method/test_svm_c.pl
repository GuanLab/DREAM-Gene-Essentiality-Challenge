#!/usr/bin/perl
#
$c=$ARGV[0];
@mat=glob "svm_input/*train*" ;
foreach $file (@mat){
	$test=$file;
	$test=~s/train/test/g;
	$model=$file;
	$model=~s/train/model/g;
	$out=$file;
	$out=~s/train/out/g;
	system "svm_learn -z r -v 0 -c $c $file $model";
	system "svm_classify ${test} ${model} ${out}";
}

	
