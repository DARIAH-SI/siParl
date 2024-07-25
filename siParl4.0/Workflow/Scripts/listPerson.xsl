<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei" version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:output encoding="UTF-8"/>

    <!--Input: List of speakers with corrected values: listPerson-list.xml
	output: listPerson.xml-->
    <!--Manual check required for the full listPerson.xml! -->

	<xsl:variable name="male_exception">
		<name>Aljoša</name>
		<name>Andrija</name>
		<name type="unisex">Andrea</name>
		<name>Dragiša</name>
	    <name>Đurđica</name>
		<name>Elija</name>
		<name>Geza</name>
		<name>Grega</name>
		<name type="unisex">Ivica</name>
		<name>Jaka</name>
		<name>Jaša</name>
		<name>Jeremija</name>
		<name>Jona</name>
		<name>Kosta</name>
		<name>Kostja</name>
		<name>Kolja</name>
		<name>Kozma</name>
		<name>Luka</name>
		<name>Matija</name>
		<name>Miha</name>
		<name>Mitja</name>
		<name type="unisex">Nastja</name>
		<name>Nebojša</name>
		<name>Nemanja</name>
		<name type="unisex">Nikita</name>
		<name>Nikola</name>
		<name>Petja</name>
		<name type="unisex">Saša</name>
		<name>Siniša</name>
		<name>Slaviša</name>
		<name>Staniša</name>
		<name>Tosja</name>
		<name type="unisex">Vanja</name>
		<name>Vasja</name>
		<name>Žiga</name>
	</xsl:variable>


	<xsl:variable name="female_exception">
	  <name>Dolores</name>
	  <name>Iris</name>
	  <name>Ines</name>
	  <name>Ingrid</name>
	  <name>Nives</name>
	  <name>Mirjam</name>
	  <name>Kim</name>
	  <name>Karmen</name>
	  <name>Lili</name>
	  <name>Agnes</name>
	  <name>Karin</name>
	</xsl:variable>
	
	<xsl:variable name="siParl" select="document('../siParl3.0.xml')"/>
	<!--Meant to check matched person xml:id; useful for this version, new listPerson needs to be prepared and manually edited for newer versions. -->
    
    
    <xsl:template match="/">
        <!--Pass1: Inport values, create tei:person and handle @xml:id attribute creation-->
        <xsl:variable name="var1">
            <xsl:apply-templates mode="pass1"/>
        </xsl:variable>
        <!--Pass2: match xml:ids with the id from siParl.xml and replace the current ones--> 
        <xsl:variable name="var2">
            <xsl:apply-templates select="$var1" mode="pass2"/>
        </xsl:variable>
        <!--Pass2: Handle sex values (F, M, unisex)-->
        <xsl:variable name="var3">
            <xsl:apply-templates select="$var2" mode="pass3"/>
        </xsl:variable>
        <!--Pass4: Correct specific tei:person (overriding values)-->
        <xsl:variable name="var4">
            <xsl:apply-templates select="$var3" mode="pass4"/>
        </xsl:variable>
        <!--Pass5: Copy and sort newly corrected values-->
        <xsl:variable name="var5">
            <xsl:apply-templates select="$var4" mode="pass5"/>
        </xsl:variable>
        <xsl:variable name="var6">
            <xsl:apply-templates select="$var5" mode="pass6"/>
        </xsl:variable>
        <xsl:copy-of select="$var6"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:fileDesc" mode="pass1">
        <fileDesc>
            <titleStmt>
                <title xml:lang="sl">Seznam govornikov v slovenskem parlamentu</title>
                <title xml:lang="en">List of speakers in the Slovene parliament</title>
                <respStmt>
                    <persName>Katja Meden</persName>
                    <resp xml:lang="sl">Kodiranje TEI</resp>
                    <resp xml:lang="en">TEI corpus encoding</resp>
                </respStmt>
            </titleStmt>
            <publicationStmt>
                <publisher>
                    <orgName xml:lang="sl">Inštitut za novejšo zgodovino</orgName>
                    <orgName xml:lang="en">Institute of Contemporary History</orgName>
                    <ref target="http://www.inz.si/">http://www.inz.si/</ref>
                    <address>
                        <street>Kongresni trg 1</street>
                        <settlement>Ljubljana</settlement>
                        <postCode>1000</postCode>
                        <country xml:lang="sl">Slovenija</country>
                        <country xml:lang="en">Slovenia</country>
                    </address>
                    <email>inz@inz.si</email>
                </publisher>
                <distributor>DARIAH-SI</distributor>
                <distributor>CLARIN.SI</distributor>
                <availability status="free">
                    <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                    <p xml:lang="en">This work is licensed under the <ref
                            target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                            Attribution 4.0 International License</ref>.</p>
                    <p xml:lang="sl">To delo je ponujeno pod <ref
                            target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                            Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                </availability>
              <date>
		<xsl:attribute name="when">
		  <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
		</xsl:attribute>
                <xsl:value-of
                    select="format-date(current-date(), '[D1]. [M1]. [Y0001]')"/>
              </date>
            </publicationStmt>
            <sourceDesc>
                <p>Born digital.</p>
            </sourceDesc>
        </fileDesc>
    </xsl:template>

    <xsl:template match="@xml:id" mode="pass1"/>

    <xsl:template match="tei:listPerson" mode="pass1">
        <listPerson>
            <xsl:for-each select="distinct-values(tei:person/@ana)">
                <xsl:analyze-string select="."
                    regex="([A-ZŽČŠĆĐÓÉ,\.-][a-zžčšćüđö0óéáäű,\.-]+)(([A-ZŽČŠĆĐÓÉ,\.-]+[a-zžčšćüđö0óéáäű]+)+)">
                    <xsl:matching-substring>
                        <person>
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="concat(regex-group(2),regex-group(1))"/>
                            </xsl:attribute>
                            <persName>
                                <surname>
                                    <xsl:value-of select="regex-group(2)"/>
                                </surname>
                                <forename>
                                    <xsl:value-of select="regex-group(1)"/>
                                </forename>
                            </persName>
                        </person>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:message select="concat('NAME UNMATCHED:', .)"/>
                        <person>
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <persName>
                                <xsl:choose>
                                    <xsl:when test="matches(., 'unknown-F')">
                                        <xsl:text>Neidentificirana govornica</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="matches(., 'unknown-M')">
                                        <xsl:text>Neidentificiran govornik</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:message select="concat('ERROR: Unknown value', .)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </persName>
                        </person>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:for-each>
        </listPerson>
    </xsl:template>
    
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person" mode="pass2">
        <xsl:variable name="current_id" select="."/>
        <xsl:variable name="siParl_id" select="$siParl//tei:person[@xml:id = $current_id]"/>
        <xsl:variable name="match" select=".[@xml:id = $siParl]"/>
        
       <xsl:choose>
           <xsl:when test="$siParl_id">
               <xsl:copy-of select="$siParl_id" copy-namespaces="no"/>
           </xsl:when>
           <xsl:when test="$match">
               <!--<xsl:message select="concat('Match values:', .)"/>-->
           </xsl:when>
           <xsl:otherwise>
               <xsl:copy-of select="."/>
               <!--<xsl:message select="concat('Non-matching values:', .)"/>-->
           </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    
   
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
   
    <xsl:template match="tei:person[not(tei:sex)]" mode="pass3">
        <!--<xsl:message select="concat('NO SEX: ', .)"/>-->
        <xsl:variable name="firstForename" select="tei:persName/tei:forename[1]"/>
        <person>
            <xsl:attribute name="xml:id" select="@xml:id"/>
            <xsl:copy-of select="node()" copy-namespaces="no"/>
            <sex>
                <xsl:attribute name="value">
                    <xsl:choose>
                      <xsl:when test="matches($firstForename, 'a$') and not($firstForename = $male_exception/tei:name) or ($firstForename = $female_exception/tei:name)">F</xsl:when>
                        <xsl:otherwise>M</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if test="$firstForename = $male_exception/tei:name[@type='unisex']">
                    <xsl:attribute name="cert">medium</xsl:attribute>
                </xsl:if>
            </sex>
        </person>
    </xsl:template>
    
    
    
    <xsl:template match="@* | node()" mode="pass4">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass4"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:surname" mode="pass4">
        <xsl:message select="concat('Check: ', .)"/>
        <!--<mjaw>
            <xsl:value-of select="."/>
        </mjaw>-->
        <xsl:choose>
     <xsl:when test="matches(., '(\p{Lu}\p{Ll}+)(\p{Lu}\p{Ll}+)+')">
           <xsl:message select="concat('Double surnames: ', .)"/>
           <surname>
               <xsl:value-of select="replace(., '(\p{Lu}\p{Ll}+)(\p{Lu}\p{Ll}+)+', '$1')"/>
           </surname>
           <surname>
               <xsl:value-of select="replace(., '(\p{Lu}\p{Ll}+)(\p{Lu}\p{Ll}+)+', '$2')"/>
           </surname>
       </xsl:when>
           <xsl:otherwise>
               <xsl:copy>
                   <xsl:apply-templates select="@*" mode="pass3"/>
                   <xsl:apply-templates mode="pass3"/>
               </xsl:copy>
           </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass5">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass5"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:person[@xml:id='MarijaColaričJakšeLea']" mode="pass5">
        <person xml:id="ColaričJakšeMarijaLea">
            <persName>
                <surname>Colarič-Jakše</surname>
                <forename>Lea-Marija</forename>
            </persName>
            <sex value="F"/>
        </person>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass6">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass6"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:listPerson" mode="pass6">
        <!-- Copy the listPerson element -->
        <xsl:copy>
            <!-- Sort the person elements based on xml:id -->
            <xsl:for-each select="tei:person">
                <xsl:sort select="@xml:id"/>
                <!-- Copy the sorted person element -->
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
   
</xsl:stylesheet>
