#!/usr/bin/perl -w

##UsageExample: ./extract_top_value.pl GE_all_top_10 Achilles_v2.9_training.gct CCLE_expression_training.gct #All_GE

open GE, "../../datasets/CCLE_expression_training_phase3.gct" or die;
<GE>;
<GE>;
$line=<GE>;
chomp $line;
@title=split "\t", $line;
shift @title;
shift @title;
$celli=0;
foreach $aaa (@title){
	$linetoid{$aaa}=$celli;
	$celli++;
}

$gi=0;
while ($line=<GE>){
	chomp $line;
	@table=split "\t", $line;
	$gene=shift @table;
	shift @table;
	if (exists $getoid{$gene}){
	}else{
		$getoid{$gene}=$gi;
		$gi++;
	}
		
	foreach $cellline (@title){
	
		$i=$linetoid{$cellline};
		$aaa=shift @table;

		$ref[$i][$getoid{$gene}]=$aaa;
	}
}

close GE;




open GE, "../../datasets/CCLE_copynumber_training_phase3.gct" or die;
<GE>;
<GE>;
$line=<GE>;
chomp $line;
@title=split "\t", $line;
shift @title;
shift @title;

while ($line=<GE>){
	chomp $line;
	@table=split "\t", $line;
	$gene=shift @table;
	shift @table;
	if (exists $getoid{$gene}){
	}else{
		$getoid{$gene}=$gi;
		$gi++;
	}
		
	foreach $cellline (@title){
	
		$i=$linetoid{$cellline};
		$aaa=shift @table;

		$ref[$i][$getoid{$gene}]=$aaa;
	}
}

close GE;







%top10=();
open FILE, "GE_train_top_10" or die;
$id=0;
while ($line=<FILE>){
	chomp $line;
	@table=split "\t", $line;
	$aaa=shift @table;
	
	if (exists $gid{$aaa}){
		print "error: replicate gene! $aaa\n";
	}else{
		$gid{$aaa}=$id;
		foreach $bbb (@table){
			$top10[$id].="\t$bbb";
		}
		$id++;
	}
}
close FILE;


open LIST, "../../datasets/prioritized_gene_list_phase3.txt" or die;
while ($line=<LIST>){
	chomp $line;
	$ext_list{$line}=0;
}
close LIST;

mkdir "svm_input";
open FILE, "../../datasets/Achilles_v2.11_training_phase3.gct.scaled.pos" or die;
<FILE>;
<FILE>;
$line=<FILE>;
chomp $line;
@title=split "\t", $line;
shift @title;
shift @title;

while ($line=<FILE>){
	chomp $line;
	@table=split "\t", $line;
	$aaa=shift @table;
	if (exists $ext_list{$aaa}){
	shift @table;
	$id=$gid{$aaa};
	@features=split "\t", $top10[$id];
	shift @features;

	open NEW, ">svm_input/${aaa}.train.input" or die;
	$i=0;
	foreach $cellline (@title){
		$value=shift @table;
		print NEW "$value";
		$tmp_i=1;
		$i=$linetoid{$cellline};
		foreach $fff (@features){
			
			if (exists $getoid{$fff}){
				$gi=$getoid{$fff};
		
				print NEW " $tmp_i".":";
				if ($fff=~/_at/){
					print NEW "$ref[$i][$gi]";
				}else{
					$val=$ref[$i][$gi]*10;
					print NEW "$val";
				}
			
			$tmp_i++;
			}
		}
		print NEW "\n";
	}
	close NEW;
	}
}
close FILE;
