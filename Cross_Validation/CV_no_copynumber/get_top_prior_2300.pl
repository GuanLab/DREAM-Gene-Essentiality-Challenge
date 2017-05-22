#!/usr/bin/perl
#

### need to use old feature list file";

## two input argumants

my $alpha=0.7;
my $ft_num=$ARGV[0]; #number of features
my $cv_dir=$ARGV[1];
my %ref; #stores information in feature_list

$cv_dir =~ s/\/$//;

if (scalar (@ARGV)<1){
	die;
}

open FILE, "$cv_dir/feature_list_train.txt" or die;
$line=<FILE>;
chomp $line;
@table=split "\t", $line;
$ref{$table[0]}=$table[1];
my $maximum=$table[1]; #Feature_list was sorted, so the first number is the maximum number;

while ($line=<FILE>){
	chomp $line;
	@table=split "\t", $line;
	$ref{$table[0]}=$table[1];
}
close FILE;


open COPY, "$cv_dir/CCLE_copynumber_training_phase3.gct.noheader_train" or die;
#<COPY>; don't need these two lines because the headers were already deleted from the .gct file
#<COPY>;
<COPY>;
while ($line=<COPY>){
	chomp $line;
	my ($table,undef)=split "\t", $line,2;
	$copy{$table}=0;
}
close COPY;

open FILE, "$cv_dir/pearson_matrix_train_top300.txt" or die;
open NEW,">","$cv_dir/GE_train_top_10_feature$ft_num" or die;
while ($line=<FILE>){
	chomp $line;
	@table=split "\t", $line;
	$gene=shift @table;
	print NEW "$gene";
	$ori=0;
	%rank=();
	while (@table){
		$a=shift @table;
		@t=split ',',$a;
		$tmp=abs($t[1]);
		$val=(1-$alpha)*$tmp+$alpha*$ref{$t[0]}/$maximum;
		$rank{$t[0]}=$val;
	}
	@keys = sort { $rank{$b} <=> $rank{$a} } keys(%rank);
	$i=0;
	while ($i<$ft_num){    # change i to change the number of features
		print NEW "\t$keys[$i]";		
		$i++;
	}
	#if (exists $copy{$gene}){
	#	print NEW "\t$gene";
	#}else{
	#	print NEW "\t$keys[$i]";
	#}
		
	print NEW "\n";
}
close FILE;
close NEW;
	
