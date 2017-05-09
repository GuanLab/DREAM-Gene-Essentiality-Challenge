#!/usr/bin/perl
#

### need to use old feature list file";


$alpha=($ARGV[0]);
if (scalar (@ARGV)<1){
	die;
}

open FILE, "/home/tyli/gene_essentiality/subchallenge3/v2_ori/feature_list.txt" or die;
$line=<FILE>;
chomp $line;
@table=split "\t", $line;
$ref{$table[0]}=$table[1];
$maximum=$table[1];
while ($line=<FILE>){
	chomp $line;
	@table=split "\t", $line;
	$ref{$table[0]}=$table[1];
}
close FILE;



open COPY, "../../datasets/CCLE_copynumber_training_phase3.gct" or die;
<COPY>;
<COPY>;
<COPY>;
while ($line=<COPY>){
	chomp $line;
	@table=split "\t", $line;
	$copy{$table[0]}=0;
}
close COPY;

open FILE, "../../pearson_matrix_all.txt" or die;
open NEW, ">GE_train_top_10" or die;
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
	while ($i<9){
		print NEW "\t$keys[$i]";
		
		
		$i++;
	}
	if (exists $copy{$gene}){
		print NEW "\t$gene";
	}else{
		print NEW "\t$keys[$i]";
	}
		
	print NEW "\n";
}
close FILE;
close NEW;
	
