#!/usr/bin/perl
use strict;
use utf8;

# read input
my $input = $ARGV[0];

# Init - Grobal
my $count = 0;
my @hand_array = (0,0,0,0,0,0,0,0,0,0,0,0);

# check ...
&make_array($input);
&wait_check(@hand_array);

# count - each pai / with input check
sub make_array{
	my $hand = $_[0];
	my $pai = $hand % 10;
	my $exist = int($hand / 10);
	if($pai == 0){ &error;}
	else{
		$hand_array[$pai]++;
		if($hand_array[$pai] > 4){ &error;}
	}
	$count++;
	
	@_ = $exist;
	if ($exist != 0){ goto &make_array;}
	elsif($count != 13){ &error;}
	return 0;
}

# head check
sub wait_check{
	my @array = @_;
	for(my $pai = 1; $pai < 10 ; $pai++){
		# if head exists -> make wait
		if($array[$pai] >= 2){
			my $str_head = "($pai$pai)";
			&make_wait($str_head, &single_df($pai, 2, @array));
		}
		# if no-head, but pai exists -> make pair
		if($array[$pai] >= 1){
			my $str_single = "[$pai]";
			&make_set($str_single, 1, &single_df($pai, 1, @array));
		}
	}
	return 0;
}

# shared routine (in &wait_check)
sub single_df{
	my ($pai, $diff, @array) = @_;
	$array[$pai] -= $diff;
	return @array;
}

# make wait
sub make_wait{
	my ($str, @array) = @_;	
	for(my $pai = 1; $pai < 10 ; $pai++){
		if($array[$pai] >= 2){ 				# e.g.) 3-3 
			&make_set(&double_df_str($pai, 0, $str, @array));
		}
		if($array[$pai] >= 1 && $array[$pai+1] >= 1 ){	# e.g.) 3-4
			&make_set(&double_df_str($pai, 1, $str, @array));
		}
		if($array[$pai] >= 1 && $array[$pai+2] >= 1 ){	# e.g.) 3-5
			&make_set(&double_df_str($pai, 2, $str, @array));
		}
	}
	return 0;
}

# shared toutine (in &make_wait)
sub double_df_str{
	my ($pai, $diff, $str, @array) = @_;
	$array[$pai] -= 1;
	$array[$pai+$diff] -= 1;
	my $str_new = $str."[".($pai).($pai+$diff)."]";
	return ($str_new, 0, @array);
}

# make set
sub make_set{
	my ($str, $flag_one,  @array) = @_;
	# 7pairs
	if($flag_one == 1){
		my @array_exist = @array;
		my $str_new = $str;
		my $set = 0;
		for(my $pai = 1; $pai < 10 ; $pai++){
			while($array_exist[$pai] > 1){
				$array_exist[$pai] -=  2;
				$str_new = $str_new."(".$pai.$pai.")";
				$set++;
			}
		}
		if($set == 6){print "$str_new\n";}
	}
	
	# not 7pairs
	&make3(1, 0 - $flag_one, $str, @array);
	return 0;
}

# make set (sub) / 3 pais sets
sub make3{
	my ($pai_st, $set, $str, @array) = @_;	
	for(my $pai = $pai_st; $pai < 10 ; $pai++){
		if($array[$pai] >= 3){ &make3(&set_calc(1, $pai, $set, $str, @array));}
		if(($array[$pai] && $array[$pai+1] && $array[$pai+2]) > 0 ){ &make3(&set_calc(2, $pai, $set, $str, @array));}
	}
	return 0;
}

# shared routine (in &make3)
sub set_calc{
	my ($st3, $pai, $set, $str, @array) = @_;
	if($st3 == 1){
		$array[$pai] -= 3;
		$str = $str."(".$pai.$pai.$pai.")";
		$set++;
	}
	if($st3 == 2){
		$array[$pai]--;
		$array[$pai+1]--;
		$array[$pai+2]--;
		$str = $str."(".$pai.($pai+1).($pai+2).")";
		$set++;
	}
	if($set == 3){print "$str\n";}
	return ($pai, $set, $str, @array);
}

sub error{
	print "Input is invalid ... (e.g. \$ perl mahjong.pl 1112345678999)\n";
	exit;
}
