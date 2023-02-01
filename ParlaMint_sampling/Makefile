#---------Tests and ParlaMint sample validations: ------------------

# Test conversion of root
test-cnv-root:
	$s -xsl:Scripts/coal_oppo.xsl files-test.xml > ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng ParlaMint-SI.xml

# Test conversion of components
test-cnv-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl files-test.xml
	$j Schema/ParlaMint-TEI.rng Data/ParlaMint-SI_*.xml

# Test coversion of ana components (samples)
test-ana-components:
	$s -xsl:Scripts/siparl2parlamint-components-ana.xsl files-test-ana.xml
	$j Schema/ParlaMint-TEI.ana.rng ParlaMint-SI_*.ana.xml

# Test conversion of ana root (samples)
test-ana-root:
	$s -xsl:Scripts/siparl2parlamint-root-ana.xsl files-test-ana.xml > ParlaMint-SI.ana.xml
	$j Schema/ParlaMint-teiCorpus.ana.rng ParlaMint-SI.ana.xml



#------SDZ7 and SDZ8 conversions:-------------------------------------------------------------------

# Convert TEI root:
TEI-root:
	$s -xsl:Scripts/siparl2parlamint-root.xsl files-TEI.xml > ParlaMint-SI.TEI/ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng ParlaMint-SI.TEI/ParlaMint-SI.xml

# Convert TEI components:
TEI-components:
	$s -xsl:Scripts/siparl2parlamint-components.xsl files-TEI.xml
	$j Schema/ParlaMint-TEI.rng ParlaMint-SI.TEI/*/ParlaMint-SI_*.xml

# Convert ana root:
ana-root:
	$s -xsl:Scripts/siparl2parlamint-root-ana.xsl files-ana.xml > ParlaMint-SI.TEI.ana/ParlaMint-SI.ana.xml

# Convert ana components: 
ana-components:
	$s -xsl:Scripts/siparl2parlamint-components-ana.xsl files-ana.xml
#-------------2000 extenstion:------------------------------------------------------------------

2000-TEI:
	$s -xsl:Scripts/siparl2parlamint-components.xsl 2000-tei.xml
	$j Schema/ParlaMint-TEI.rng ParlaMint-SI.TEI/*/ParlaMint-SI_*.xml

2000-root:
	$s -xsl:Scripts/siparl2parlamint-root.xsl 2000-tei.xml > ParlaMint-SI.TEI/ParlaMint-SI.xml
	$j Schema/ParlaMint-teiCorpus.rng ParlaMint-SI.TEI/ParlaMint-SI.xml

2000-ana:
	$s -xsl:Scripts/siparl2parlamint-components-ana.xsl 2000-ana.xml

2000-ana-root:
	$s -xsl:Scripts/siparl2parlamint-root-ana.xsl 2000-ana.xml > ParlaMint-SI.TEI.ana/ParlaMint-SI.ana.xml


# --------Prep files:-----------------------------------------------------------------------------------

# Prepare the list of input/output files from mandates given as first parameter
prep-files:
	Scripts/map-files-test.pl 'SDZ3 SDZ7 SDZ8' '../speech_samples' > files-test.xml

# Prepare the list of input/output files for ana version
prep-files-ana:
	Scripts/map-files-ana.pl 'SDZ3 SDZ7 SDZ8' '../speech_samples_ana' > files-test-ana.xml

# Prep TEI for SDZ7 and SDZ8: 
prep-TEI:
	Scripts/map-files.pl 'SDZ7 SDZ8' '../speech2parlamint' 'ParlaMint-SI.TEI'> files-TEI.xml


# Prep ana for SDZ7 and SDZ8:
prep-ana:
	Scripts/map-ana.pl 'SDZ7 SDZ8' '../speech2parlamint_ana' 'ParlaMint-SI.TEI.ana'> files-ana.xml

# Prep TEI for extended ParlaMint:
prep-2000:
	Scripts/map-files.pl 'SDZ3 SDZ7 SDZ8' '../speech_samples' 'ParlaMint-SI.TEI'> 2000-tei.xml

prep-2000-ana:
	Scripts/map-ana.pl 'SDZ3 SDZ7 SDZ8' '../speech_samples_ana' 'ParlaMint-SI.TEI.ana'> 2000-ana.xml


#------------------Other:------------------------------------------------------------------------
validate-parlamint:
	Scripts/validate-parlamint.pl 'Schema' '.'


#--------
all:	prep-files clean


# Remove output files
clean:
	rm -f ParlaMint-SI.xml
	rm -f Data/????/*
	rmdir Data/????
	rm -f Data/TMP/*
################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
