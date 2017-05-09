#!/usr/bin/perl
#

open GENE_LIST, "/home/gyuanfan/phase3/datasets/prioritized_gene_list_phase3.txt" or die;
while ($l=<GENE_LIST>){
	chomp $l;
	$ref{$l}=0;
}
close GENE_LIST;

open FILE, "/home/gyuanfan/phase3/pearson_matrix_all.txt" or die;
while ($l=<FILE>){
	chomp $l;
	@table=split "\t", $l;
	if (exists $ref{$table[0]}){
		shift @table;
		$i=0;
		while ($i<10){
			$a=shift @table;
			@t=split ',', $a;
			$count{$t[0]}++;
			$i++;
		}
	}
}
close FILE;

open NEW, ">feature_list.txt" or die;
@name=keys %count;
        @name=sort{$count{$b}<=>$count{$a}}@name;
	$i=0;
        foreach $n (@name){
                print NEW "$n\t$count{$n}\n";
		push @list, $n;
		$i++;
        }
close NEW;

	
	
	
open GENE_LIST, "/home/gyuanfan/phase3/datasets/prioritized_gene_list_phase3.txt" or die;
open NEW, ">GE_train_network_top100" or die;
while ($l=<GENE_LIST>){
	chomp $l;
	print NEW "$l";
	$i=0;
	while ($i<100){
		print NEW "\t$list[$i]";
		$i++;
	}
	print NEW "\n";

}
close GENE_LIST;
