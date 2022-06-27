test-cnv-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl files-test.xml
	$j Schema/ParlaMint-TEI.rng Data/*/*.xml

validate:
	$j Schema/ParlaMint-teiCorpus.rng Data/ParlaMint-SI.xml
	$j Schema/ParlaMint-TEI.rng Data/*/*.xml
	$s -xsl:copy-teiHeader.xsl Data/ParlaMint-SI.xml > Data/ParlaMint-SI-teiHeader.tmp
	$s -xi -xsl:copy.xsl Data/ParlaMint-SI-teiHeader.tmp > Data/TMP/ParlaMint-SI-teiHeader.xml
	nice find Data/*/ -name '*.xml' | $P --jobs 20 \
	'$s meta=Data/TMP/ParlaMint-SI-teiHeader.xmll -xsl:Scripts/check-links.xsl {}'
cnv-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl test.xml
	$j Schema/ParlaMint-TEI.rng Data/*/*.xml
cnv-roots:
	$s -xsl:Scripts/siparl2parlamint-root.xsl files.xml > ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng Data/*.xml
prep-files:
	Scripts/map-files.pl 'SDZ6 SDZ7' '../speech' 'Data' > files.xml

################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
