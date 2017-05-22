#!/usr/bin/perl
#

my $cv_dir = $ARGV[0]; #directory of cv files. Example:cv_1_21
$cv_dir =~ s/\/$//;

open GENE_LIST, "$cv_dir/prioritized_gene_list_phase3.txt" or die;

my %ref; # a list of prioritized genes
while ($l=<GENE_LIST>){
	chomp $l;
	$ref{$l}=0;
}
close GENE_LIST;

open FILE, "$cv_dir/pearson_matrix_train_top300.txt" or die;
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

open NEW, ">","$cv_dir/feature_list_train.txt" or die;
	@name=keys %count;
        @name=sort{$count{$b}<=>$count{$a}}@name;
        foreach $n (@name){
                print NEW "$n\t$count{$n}\n";
		push @list, $n;
        }
close NEW;
