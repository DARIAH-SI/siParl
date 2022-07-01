2speech:
	$s -xsl:drama2speech.xsl drama/SDT6-list.xml

################################################
s = java -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2
