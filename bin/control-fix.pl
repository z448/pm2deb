#!/usr/bin/env perl

use Term::ANSIColor;
use Cydia::Control;
use JSON::Tiny qw(encode_json);
use feature 'say';

my $dis_req;
my %ctrl;
my $ctrl_json;

unless($ARGV[0]){
     $dis_req='IO-All';
 } else { $dis_req=$ARGV[0] }

$dis_req =~ s/\:\:/\-/g;

my $m = get_control($dis_req);

sub deps {
    my @deps;
     for my $hash(@{$m->{dependency}}){
         if ($$hash{relationship} eq 'requires'){
             push @deps, $$hash{module};
     }
 }
 return \@deps;
}

sub make_control {
    while (($key, $value) = each %ctrl) {
        unless ($key eq 'Depends'){
            print $key, ":\ ";
            print $ctrl{$key}."\n";
        } else {
            print $key.': ';
            for(@{$ctrl{$key}}){
                unless($_ eq 'perl'){
                    s/\:\:/\-/g;
                    print "lib".lc($_)."\-p5"."\,\ ";
            } else { print "perl5\,\ " }
            };
            print "\n";
        }
    }
}

sub term_dim { # todo: stty bin check
    my@x=qx!stty -a!; 
    my@y=split(/;/,$x[0]);
    my@w=split(/columns/,$y[2]); 
    $w[1]=~s/^\s+|\s+$//g;
    return $w[0];
}

sub render {
    my $term=&term_dim;
    #json
    print "\n".("_"x$term)."\n".colored(['bright_white'],'JSON CONTROL')."\n".("-"x$term).$ctrl_json."\n".("-"x$term)."\n";;

    
    print "\n\n\n".("_"x$term)."\n".colored(['bright_white'],'DPKG CONTROL')."\n".("-"x$term)."\n\n";

    make_control();
    print "\n\n".("-"x$term)."\n\n\n";
}

$ctrl{Package} = 'lib'.lc $m->{name}.'-p5';
$ctrl{Name} = $m->{name};
$ctrl{Description} = $m->{abstract};
$ctrl{Author} = $m->{author};
$ctrl{Version} = $m->{version};
$ctrl{Depends} =  deps();
$ctrl_hash = { %ctrl };
$ctrl_json = encode_json $ctrl_hash;


render();