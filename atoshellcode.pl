#!/usr/bin/perl
#superm

use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;

sub VERSION_MESSAGE {
 print "Script to convert various ascii shellcode formats to binary shellcode.\n"
 # src: https://isc.sans.edu/diary/Static+analysis+of+Shellcode/4970, http://zeltser.com/reverse-malware/convert-shellcode.html
}
sub HELP_MESSAGE {
 print "Usage: toshellcode.pl -f <file> -m <mode>\n";
 print "Modes:\n";
 print "0 = %u9090\n";
 print "1 = \\x90\\x90\n";
 print "2 = %90%90\n";
 print "3 = 9090\n";
 print "4 = \\u9090\n";
 print "5 = &#x9090\n";
}
getopts('f:m:');

if ( $opt_f ) {
 open(TF, $opt_f) || die "can't open file.\n";
 my $lines = -s $opt_f;
 read(TF,$bin,$lines);
 close (TF);
}
else {
 while ( <STDIN> ) {
 	$bin .= $_;
 }
}

# %u9090
if (!$opt_m or $opt_m eq 0) {$bin =~ s/\%u(..)(..)/chr(hex($2)).chr(hex($1))/ge;}
# \x90\x90
elsif ($opt_m eq 1) {$bin =~ s/\\x(..)/chr(hex($1))/ge;}
# %90%90
elsif ($opt_m eq 2) {$bin =~ s/\%(..)/chr(hex($1))/ge;}
# 9090
elsif ($opt_m eq 3) {$bin =~ s/(..)/chr(hex($1))/ge;}
# \u9090
elsif ($opt_m eq 4) {$bin =~ s/\\u(..)(..)/chr(hex($2)).chr(hex($1))/ge;}
# &#x9090
elsif ($opt_m eq 5) {$bin =~ s/&#xu(..)(..)/chr(hex($2)).chr(hex($1))/ge;}

print $bin;
