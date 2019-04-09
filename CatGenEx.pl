#!/usr/bin/perl
#Author: Arun H. Patil 
#Contributor: Sayali C. Deolankar
#Date: April 02, 2019

$input = $ARGV[0];
$output = $ARGV[1];
if (@ARGV == 0 )
{
	print "USAGE: perl program.pl <input_file_name> <output_file_name>\n";
	exit;
}
else
{
	print " Input file name: $input\n";
	print "Output file name: $output\n";	
}

open (FILE, "$input") or die $!;
open (OUT, ">$output") or die $!;
while (<FILE>)
{
	chomp ($_);
	$_ =~ s/\r//g;
	@lines = split (/\t/, $_);
	$tissues_size = @lines-1;
	if ($_ !~ /Gene/)
	{
		@values=();
		$sum =0;
		$classi = "mixed";
		$group=0; $enhance = $enCount =  $enDiv = 0;$groupenriched_TissueList="Arun -";
		$count=0;
		$flag=0;
		%value_key;
		foreach $i (1..$tissues_size) 
		{
			$num = int($lines[$i]);
			if ($lines[$i] >0) {$count++;} 
			push @values, $num;
			$sum += $num;
			$value_key{$num} = $header[$i];
		}
		$avgall = $sum/$tissues_size;
		$fiveAvg = $avgall*5;
		@sorted = sort { $a <=> $b } @values;

		if (exists $value_key{$sorted[-1]}){
		$TEnriched_name = $value_key{$sorted[-1]};
		}else{
		$TEnriched_name = "-";
		}

		if ($sorted[-2] >0){$div = $sorted[-1]/$sorted[-2];}
		if ($sorted[-2] == 0 || $div > 5 ) 
		{
			$classi = "Tissue enriched";
			print OUT "$_\t$TEnriched_name\t-\t-\tTissue enriched\n";
			next;
		}
		if ($sorted[0] > 0) { $flag =1;}
		@enhancedTissues=(); @groupEnrichedTissues=();
		if ($flag != 1)
		{
			foreach $i (1..$tissues_size)
			{
				if ($lines[$i] != 0)
				{
					$enDiv = $lines[$i] / $avgall;
					if ($enDiv > 5) {
					push @enhancedTissues, $header[$i];
					$enhance = 1;
					$classi = "Tissue enhanced";
					}
					if ($lines[$i] > $avgall){
					$group=1;
					push @groupEnrichedTissues, $header[$i];
					}
				}
			}
		}
		else{ 
			foreach $i (1..$tissues_size)
			{
				if ($lines[$i] > $avgall){
				$group=1;
				push @groupEnrichedTissues, $header[$i];
				}
			}
		}
		if ($enhance == 1){
		$enhanced_TissueList = join (";", @enhancedTissues);
		if ($enhanced_TissueList =~ /^;/) {$enhanced_TissueList =~ s/;//;}
		}
		if ($group == 1){
		$groupenriched_TissueList = join (";", @groupEnrichedTissues);
		if ($groupenriched_TissueList =~ /^;/) {$groupenriched_TissueList =~ s/;//;}
		}
		@revSorted = reverse @sorted;
		$count_3=0; $count_above_avg=0; $count_below_avg=0;
		foreach $x (@revSorted)
		{
			if ($x > $avgall)
			{
				foreach $y (@sorted)
				{
					if ($y != 0)
					{
						$a = $y * 5;
						if ($x > $a)
						{
							$count_3++;
							$count_above_avg++;
							last;
						}
					}
				}
			}
			else
			{
				foreach $y (@sorted)
				{
					if ($y != 0)
					{
						$a = $y * 5;
						if ($x > $a)
						{
							$count_3++;
							$count_below_avg++;
							last;
						}
					}
				}
			}
		}
		$total = (($count_above_avg+$count_below_avg)/$count)*100;
		@new_scale = ();
		$div_1_2 = 0;$new_count=0;
		$arraySize = @sorted;
		$arraySize = $arraySize -2;
		if ($flag == 1)
		{
			for ($i =0 ; $i< $arraySize; $i++)
			{
				$div_1_2 = $sorted[$i]/$sorted[$i+1]; 
				push @new_scale, $div_1_2;
			}
			push @new_scale, 1;
			@rev_new_scale = reverse @new_scale;
			foreach $s (@rev_new_scale)
			{
				if ($s > 0.6)
				{
					$new_count++;
				}
				elsif ($s <= 0.6) 
				{last;}
			}
			if ($new_count > 0 && $new_count <= 7 && $count_above_avg <= 7)
			{
				print OUT "$_\t$TEnriched_name\t$groupenriched_TissueList\t-\tGroup enriched\n";
				next;
			}
			else
			{
				print OUT "$_\t$TEnriched_name\t-\t-\tExpressed in all\n";
				next;
			}
		}
		elsif ($flag ==0) 
		{
			for ($i =0 ; $i< $arraySize; $i++)	
			{
				if ($sorted[$i] != 0)
				{
					$div_1_2 = $sorted[$i]/$sorted[$i+1];
					push @new_scale, $div_1_2;
				}
				push @new_scale, 1;
				@rev_new_scale = reverse @new_scale;
			}
			foreach $s (@rev_new_scale)
			{
				if ($s > 0.6)
				{
					$new_count++;
				}
				elsif ($s <= 0.6) 
				{last;}
			}
			if ($new_count > 0 && $new_count <= 7 && $count_above_avg <= 7)
			{
				print OUT "$_\t$TEnriched_name\t$groupenriched_TissueList\t-\tGroup enriched\n";
				next;
			}
			elsif ($enhance == 1)
			{
				print OUT "$_\t$TEnriched_name\t-\t$enhanced_TissueList\tTissue enhanced\n";
				next;
			}
			else
			{
				print OUT "$_\t$TEnriched_name\t-\t-\tMixed\n";
				next;
			}
		}
		if ($count_above_avg == 6)
		{
			if ($flag ==1 && $total >= 70) {
				print OUT "$_\t$TEnriched_name\t$groupenriched_TissueList\t-\tGroup enriched\n";
				next;}
			elsif ($flag ==1 && $total < 70) {
				print OUT "$_\t$TEnriched_name\t-\t-\tExpressed in all\n";
				next;}
			elsif ($flag == 0 && $total >= 70 ) {
				print OUT "$_\t$TEnriched_name\t$groupenriched_TissueList\t-\tGroup enriched\n";
				next;}
			elsif ($flag == 0 && $total < 70) {
				print OUT "$_\t$TEnriched_name\t-\t$enhanced_TissueList\tTissue enhanced\n";
				next;}
			else {
				print OUT "$_\t$TEnriched_name\t-\t-\tMixed\n";
			}
		}
		if ($count_above_avg >= 7)
		{
			if ($flag == 1) {
				print OUT "$_\t$TEnriched_name\t-\t-\tExpressed in all\n";
				next;}
			elsif ($flag == 0 &&  $enhance == 1) {
				print OUT "$_\t$TEnriched_name\t-\t$enhanced_TissueList\tTissue enhanced\n";
				next;}
			elsif ($flag == 0 && $enhance == 0) { 
				print OUT "$_\t$TEnriched_name\t-\t-\tMixed\n";
			}
		}
	}
	else
	{
		print OUT "$_\tTissue enriched\tGroup enriched\tTissue enhanced\tClassification\n";
		@header = split (/\t/, $_);
	}
}
