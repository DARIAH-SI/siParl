#!/usr/bin/perl -w
# Store a list of input files for given terms and input directory
use utf8;
use Encode;
use Text::Unidecode; # Added Text::Unidecode module


my $terms = shift;
my $inDir = shift;
my $outDir = shift;
my $abbreviation;

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
print "<mappings>\n";
foreach $term (split / /, $terms) {
    $termRoot = "$inDir/$term.xml";
    die "Can't find $termRoot!\n" unless -e $termRoot;
    print "<source>$termRoot</source>\n";


    $termFile = "$inDir/$term/*.xml";
    foreach $inF (glob $termFile) {
	my $encoded_string = encode('iso-8859-1', $inF);
	my $inFile = decode('utf-8', $encoded_string);
	print "<map>\n";
        print "<source>$inFile</source>\n";
        ($label, $number, $status, $day, $month, $year) = $inFile =~
	    m|Seja_\d+\s-\s(\D+)\s-\s(\d+)\.\s(\D+)_(\d{1,2})\.\s(\d{1,2})\.\s(\d{4})_\d{2}-\d{2}-\d{2}-\d{3}\.xml|
            or die "Bad input file $inFile!\n";
#	print SDTERR "$status\n";
        if ($status =~ /(skupna seja)/i) {
            $label = "Skupna";
	    $status =~ s/skupna seja//i;
        } else {my $abbreviation = join('', map { substr($_, 0, 1) } split(/\s+/, $label));
		$abbreviation = uc($abbreviation);
		$label = $abbreviation
	}
	$status =~ s/\s\(\s*\)//g;
	$label = unidecode($label);
	$status = unidecode($status);
	# Pad day and month with leading zeros if they are single-digit numbers
        $day = sprintf("%02d", $day);
        $month = sprintf("%02d", $month);

	$outFile = "$outDir/$label-$number-$status-$year-$month-$day.xml";
#        $outFile = sprintf("%s/%s-%d-%s-%d-%02d-%02d.xml",$outDir, $label, $number, $status, $year, $month, $day);
	if (exists $files{$outFile}) {
	    $i = 1;
	    $outFile =~ s|($number)|$1\_$i|;
	    while (exists $files{$outFile}) {
		$i++;
		$outFile =~ s|($number)_\d+|$1\_$i|;
	    }
	    print STDERR "WARNING: changing output file to $outFile\n";
	}
	$files{$outFile}++;
        print "<target>$outFile</target>\n";
        print "</map>\n";
    }
}
print "</mappings>\n";

