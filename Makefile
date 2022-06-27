2parlamint:
	$s -xsl:drama2ParlaMint.xsl drama/SDT2-list.xml >  ParlaMint2/SDT2.xml

################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
