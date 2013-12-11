#!/usr/local/bin/perl

use Cwd;
use Getopt::Long;
use URI::Escape;
use File::Copy qw(move);

my $file = "";
my $from = "";
my $to = "";
my @fixed_file;
my $compress = "";
my $strip_creation_lines = "";

my $usage = "USAGE:\n"
."wpdbtransfer\n\n"
."Updates a text dump of a wordpress database with a new URL, preserving and\n"
."fixing the serialized data as it goes. The originally supplied file will be\n"
."untouched and the new file created with \".fixed\" as a suffix.\n\n"
."Takes:\n"
."\t--file=<name of database file>\n"
."\t--from=<URL to search for> (optional)\n"
."\t--to=<URL to replace with> (optional)\n\n"
."\t--strip_db_create  remove the database CREATE and USE lines (optional)\n\n"
."\t--gzip  compress the fixed file for speedy uploads (optional)\n\n"
."Note: if either of \n\t--to\n or \n\t--from\n are supplied, they both must be.\n\n";

$ret = GetOptions("file=s" => \$file,"from=s" => \$from,"to=s" => \$to, "strip_db_create" => \$strip_creation_lines, "gzip" => \$compress );

if ( $file eq "" ) {
	print "\n\n\t--file option is required.\n\n";
	die $usage;
}
if ( $from && $to eq "") {
	print "\n\n\t--to is required if --from is supplied.\n\n";
	die $usage;
}
if ( $to && $from eq "") {
	print "\n\n\t--from is required if --to is supplied.\n\n";
	die $usage;
}

if ( $to ) {
	$do_global_sub = 1;
}

$fixed_file = $file . ".fixed";

#$PWD = cwd();

if ( -e $file ) {
	open( SOURCE_FILE, "<", $file) || die "Can't open $file: $!";
	@entire_file = <SOURCE_FILE>;
	close SOURCE_FILE;
} else {
	die "\n\n\t$file does not exist!\n\n";
}

print "Subbing from $from to $to in $file\n";

LINE: foreach $line_to_fix (@entire_file) {

	if ( $strip_creation_lines && ( $line_to_fix =~ m#^\s*CREATE DATABASE IF NOT EXISTS#i || $line_to_fix =~  m#^\s*USE\s+#i ) ) {
		next LINE;
	}

	# first do the string substitution
	if ( $do_global_sub ) {
		$line_to_fix =~ s#$from#$to#g;
	}

	# Then fix the serialized data. Note that we care only about strings.
	# Search for "s:digit:anything;" and sub in the unescaped length of "anything"
	# The e flag means execute, so that the function call works
	$line_to_fix =~ s#s:(\d+):(.*?);#"s:".md_unescape($2).":$2;"#eg;
	#print "$line_to_fix";
	push( @fixed_data, $line_to_fix);
}
open(FIXED_FILE, ">$fixed_file") or "Can't open $fixed_file: $!";
print FIXED_FILE @fixed_data;
close FIXED_FILE;

if ( $compress ) {
	system ("gzip -9 $fixed_file");
}



sub md_unescape {
	my ($data) = @_;
	$data =~ s#\\\"##g;
	return length($data);
}
