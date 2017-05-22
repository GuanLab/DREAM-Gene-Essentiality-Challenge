 use strict;
 
 #my @cvs=glob "/state2/state1/cv2/25_cv_folder/cv*";
 my @cvs=glob $ARGV[0];
 
 for my $cv(@cvs){
 	
 	my $ach_file=glob "$cv/Achilles_v2.11_training_phase3.gct.noheader_train.txt";
 	my $ccle_file=glob "$cv/CCLE_expression_training_phase3.gct.noheader_train.txt";
 	my $cor_file=glob "$cv/pearson_matrix_train.txt";
 	
 	open ACH,$ach_file or die $!; # Achilles
 	open CCLE,$ccle_file or die $!; # Expression
 	open COR,$cor_file or die $!; #pearson corr matrix
 	open OUT,">", "$cv/pearson_matrix_train_top300.txt"or die $!;
 	my $l1=<ACH>;
 	my $l2=<CCLE>;
 	print "L1!=L2\n" if ($l1 ne $l2);
 	my @ach=();
 	my @ccle=();
 	while(<ACH>){
 		chomp;next unless $_;
 		my ($gene,undef)=split /\s/,$_,2;
 		push @ach,$gene;
 	}
	while(<CCLE>){
 		chomp;next unless $_;
 		my ($gene,undef)=split /\s/,$_,2;
 		push @ccle,$gene;
	}
 	while(<COR>){
 		chomp;next unless $_;
 		my $ind=${.}-1;
 		my @scores = split /,/,$_;		
 		#print "score1=$scores[0];score2=$scores[1]\n";
 		my @sorted = sort {abs($scores[$b])<=>abs($scores[$a])} 0..$#scores;
 		#@sorted = @sorted[0..299];
 		my $temp1 = $ach[$ind];
 		print OUT "$temp1\t";
 		for my $ii(@sorted){
 			my $temp2="$ccle[$ii],$scores[$ii]";
 			print OUT "$temp2\t";
 		}
 		print OUT "\n";
 	}
 }
