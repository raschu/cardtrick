package kartentrick;
use Dancer2;
use List::Util qw/shuffle/;

our $VERSION = '0.1';

my $kombination;
my @k = qw(R6 R7 R8
           R9 RB RU
           RO RK RA
           E6 E7 E8
           E9 EB EU
           EO EK EA
           S6 S7 S8
           S9 SB SU
           SO SK SA
           T6 T7 T8
           T9 TB TU
           TO TK TA
);

my @validkombinations = qw (
    1321 1313 2321 2313 3321 3313
    1221 1213 2221 2213 3221 3213
    1121 1113 2121 2113 3121 3113
    1331 1323 2331 2323 3331 3323
    1231 1223 2231 2223 3231 3223
    1131 1123 2131 2123 3131 3123
);

my %validkombinations;
$validkombinations{$_} = 1 for @validkombinations;

my @row1;
my @row2;
my @row3;
my $answer;


get '/' => sub {
	@k = shuffle (@k);
	
	$kombination = '';
	session kombination => $kombination;
	
	my $reihenfolge = join(";", @k);
	
	session runde => '0';
	session karten => $reihenfolge;
	
	template 'layout1', {
		k01 => $k[0], k02 => $k[3], k03 => $k[6], k04 => $k[9],  k05 => $k[12], k06 => $k[15], k07 => $k[18], k08 => $k[21], k09 => $k[24], k10 => $k[27], k11 => $k[30], k12 => $k[33],
		k13 => $k[1], k14 => $k[4], k15 => $k[7], k16 => $k[10], k17 => $k[13], k18 => $k[16], k19 => $k[19], k20 => $k[22], k21 => $k[25], k22 => $k[28], k23 => $k[31], k24 => $k[34],
		k25 => $k[2], k26 => $k[5], k27 => $k[8], k28 => $k[11], k29 => $k[14], k30 => $k[17], k31 => $k[20], k32 => $k[23], k33 => $k[26], k34 => $k[29], k35 => $k[32], k36 => $k[35]
	};
};

get '/l2/:reihe' => sub {
	
	my $reihe = params->{reihe};
	my $runde = session 'runde';
	$runde++;
	my $karten = session 'karten';	
	my @k = split(";", $karten);
	my @o = @k;
	my $reihenfolge;
	
	my $sesskomb = session 'kombination';
	
	$kombination = $sesskomb . $reihe;
	
    @row1 = ();
    @row2 = ();
    @row3 = ();
	
	for (1..12) {
        my $first  = shift(@k);
        my $second = shift(@k);
        my $third  = shift(@k);
        
        push(@row1, $first);
        push(@row2, $second);
        push(@row3, $third);
	}
	
    if ($runde == 4) {  
        if (exists $validkombinations{$kombination}) {
            @o = reverse @o if $reihe == 3;
            print "$o[17]";
            
			session KARTEFOUND => $o[18];
			$reihenfolge = join(";", @o);
	
			session runde => $runde;
			session karten => $reihenfolge;
			session kombination => $kombination;
			
			$kombination = '';
			
			template 'layout3', {
				kartefound => $o[18]
			};
		} else {
			my $origk = $kombination;
			$kombination = '';
			die "keine gültige Kombination: $origk\n";
		}	     
    } else {
	    @k = ();
	    if ($reihe == 1) {
	        push(@k, reverse @row2);
	        push(@k, reverse @row1);
	        push(@k, reverse @row3);
	    } elsif ($reihe == 2) {
	        push(@k, reverse @row1);
	        push(@k, reverse @row2);
	        push(@k, reverse @row3);
	    } elsif ($reihe == 3) {
	        push(@k, reverse @row1);
	        push(@k, reverse @row3);
	        push(@k, reverse @row2);
	    } else {
	        die "nope reihe $reihe ist ungültig!\n";
	    }
	
		$reihenfolge = join(";", @k);
		session runde => $runde;
		session karten => $reihenfolge;
		session kombination => $kombination;
	
		template 'layout2', {
			k01 => $k[0], k02 => $k[3], k03 => $k[6], k04 => $k[9],  k05 => $k[12], k06 => $k[15], k07 => $k[18], k08 => $k[21], k09 => $k[24], k10 => $k[27], k11 => $k[30], k12 => $k[33],
			k13 => $k[1], k14 => $k[4], k15 => $k[7], k16 => $k[10], k17 => $k[13], k18 => $k[16], k19 => $k[19], k20 => $k[22], k21 => $k[25], k22 => $k[28], k23 => $k[31], k24 => $k[34],
			k25 => $k[2], k26 => $k[5], k27 => $k[8], k28 => $k[11], k29 => $k[14], k30 => $k[17], k31 => $k[20], k32 => $k[23], k33 => $k[26], k34 => $k[29], k35 => $k[32], k36 => $k[35]
		};	
    }
};

true;
