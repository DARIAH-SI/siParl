2parlamint:
	$s -xsl:drama2ParlaMint.xsl
	#$s -xsl:working-XSLT/ParlaMint-corpus-file.xsl working-XSLT/ParlaMint-list.xml

################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
