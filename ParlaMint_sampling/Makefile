mini-test-cnv-root:
	$s -xsl:Scripts/siparl2parlamint-root.xsl files-minitest.xml > Tests/ParlaMint-SI-test-output.xml

# Test conversion of root
test-cnv-root:
	$s -xsl:Scripts/siparl2parlamint-root.xsl files-test.xml > Data/ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng Data/ParlaMint-SI.xml

# Test conversion of components
test-cnv-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl files-test.xml
	$j Schema/ParlaMint-TEI.rng Data/ParlaMint-SI_*.xml

# Test coversion of ana components (samples)
test-ana-components:
	$s -xsl:Scripts/siparl2parlamint-components-ana.xsl files-ana.xml

# Test conversion of ana root (samples)
test-ana-root:
	$s -xsl:Scripts/siparl2parlamint-root-ana.xsl files-ana.xml > ParlaMint-SI.ana.xml

all:	prep-files clean 

# Validation of the complete ParlaMint, does not work yet
validate:
	$j Schema/ParlaMint-teiCorpus.rng Data/ParlaMint-SI.xml
	$j Schema/ParlaMint-TEI.rng Data/*/*.xml
	$s -xsl:copy-teiHeader.xsl Data/ParlaMint-SI.xml > Data/ParlaMint-SI-teiHeader.tmp
	$s -xi -xsl:copy.xsl Data/ParlaMint-SI-teiHeader.tmp > Data/TMP/ParlaMint-SI-teiHeader.xml
	nice find Data/*/ -name '*.xml' | $P --jobs 20 \
	'$s meta=Data/TMP/ParlaMint-SI-teiHeader.xmll -xsl:Scripts/check-links.xsl {}'

# Processing of complete corpus root
cnv-root:
	$s -xsl:Scripts/siparl2parlamint-root.xsl files.xml > Data/ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng Data/ParlaMint-SI.xml

# Processing of complete corpus
cnv-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl test.xml
	$j Schema/ParlaMint-TEI.rng Data/*/*.xml
# Remove output files
clean:
	rm -f ParlaMint-SI.xml
	rm -f Data/????/*
	rmdir Data/????
	rm -f Data/TMP/*

# Prepare the list of input/output files from mandates given as first parameter
prep-files:
	Scripts/map-files-test.pl 'SDZ7 SDZ8' '../speech_samples' > files-test.xml

# Prepare the list of input/output files for ana version
prep-files-ana:
	Scripts/map-files-ana.pl 'SDZ7 SDZ8' '../speech_samples_ana' > files-ana.xml

################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
