# Arguments for this script:
# 1. the directory of svm input files;

use strict;
use Statistics::RankCorrelation;
use List::Util qw(sum);

my $dir=$ARGV[0]; #this is the directory of svm input files;
$dir =~ s/\/$//;

my @all_cors=();
my @all_avg_cors=();

my @test_refs = glob "$dir/*testref*";
for my $one_gene(@test_refs){
	my $ref=$one_gene;
	my $out=$one_gene;
	$out =~ s/\.testref\./.out./;
	open REF,$ref or die $!;
	open TEST,$out or die $!; 
		
	my @pred_scores=(); #svm results 
	my @ref_scores=();# Achilles scores
		
	while (<TEST>){
		chomp;
		push @pred_scores,$_;
	}	
		
	while (<REF>){
		chomp;
		my ($score,undef)=split /\s/,$_,2;
		push @ref_scores,$score;
	}
		
	my $cor = Statistics::RankCorrelation->new( \@pred_scores, \@ref_scores, sorted => 1 );
	push @all_cors, $cor->spearman;
	#print join ",", @all_cors,"\n";
}
	
print sum(@all_cors)/@all_cors,"\n";


