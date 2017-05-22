use strict;

my $dir=$ARGV[0]; #this is the directory of svm input files;
$dir =~ s/\/$//;

my $c=0.005; #change this if needed
my @files = glob "$dir/*train*";
for my $file(@files){
	my $test=$file; 
	$test=~s/\.train\./.test./g;
	my $model=$file; 
	$model=~s/\.train\./.model./g;
	my $out=$file;
	$out=~s/\.train\./.out./g;
	system "svm_learn -z r -v 0 -c $c $file $model";
	system "svm_classify ${test} ${model} ${out}";
}


