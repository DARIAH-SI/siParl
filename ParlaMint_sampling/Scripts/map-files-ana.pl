#!/usr/bin/perl -w
# Store a list of input files for given terms and input directory
use utf8;
my $terms = shift;
my $inDir = shift;
my $outDir = shift;
binmode(STDOUT,'utf8');
binmode(STDERR,'utf8');
print "<mappings>\n";
foreach $term (split / /, $terms) {
    $termRoot = "$inDir/$term.xml";
    die "Can't find $termRoot!\n" unless -e $termRoot;
    print "<source>$termRoot</source>\n";
    $termFile = "$inDir/$term/*.xml";
    foreach $inFile (glob $termFile) {
	print "<map>\n";
	print "<source>$inFile</source>\n";
	($label, $date) = $inFile =~
	    m|/([^/]+)-((\d\d\d\d)-\d\d-\d\d)\.ana.xml|
	    or die "Bad input file $inFile!\n";
	$outFile = "ParlaMint-SI_$date-$term-$label.ana.xml";
	print "<target>$outFile</target>\n";
	print "</map>\n";
    }
}
print "</mappings>\n";
