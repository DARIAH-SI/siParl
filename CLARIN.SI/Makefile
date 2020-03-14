all:	get sample
sample:
	ls siParl-ana/S*/*.xml > files.tmp
	$s files=../files.tmp -xsl:bin/siParl2sample.xsl \
	siParl-ana/SDT2-ana.xml > siParl-ana/SDT2-sample.xml
	$s -xi -xsl:bin/pretty.xsl siParl-ana/SDT2-sample.xml | $j schema/parla-clarin.rng
	$s files=../files.tmp -xsl:bin/siParl2sample.xsl \
	siParl-ana/siParl-ana.xml > siParl-ana/siParl-sample.xml
	$s -xi -xsl:bin/pretty.xsl siParl-ana/siParl-sample.xml | $j schema/parla-clarin.rng
	rm files.tmp
get:
	cp ../../Master/SDT2/KPZONOJFSPD-Redna-021-1998-11-25-ana.xml siParl-ana/SDT2
	cp ../../Master/SDT2/OZKGIP-Redna-025-1998-12-08-ana.xml siParl-ana/SDT2
	cp ../../Master/SDT2/OZKŠIŠ-Redna-034-2000-05-18-ana.xml siParl-ana/SDT2
	cp ../../Master/SDT2-ana.xml siParl-ana
	cp ../../Master/siParl-ana.xml siParl-ana


j = java -jar /usr/local/bin/jing.jar 
#s = java -jar /usr/local/bin/saxon9he.jar
s = java -jar /home/tomaz/bin/saxon9he.jar
P = parallel --gnu --halt 2
