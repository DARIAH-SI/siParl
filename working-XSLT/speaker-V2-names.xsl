<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je *-speaker-ostali.xml -->
    <!-- Naredi persName iz prvih name -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- GOSPOD/GOSPA (napisano tudi z malimi črkami) 
-DR. (dr.) tudi z vejico - DR,
-MAG. (mag./mag_) MAG,
-PROF.
-IZR. PROF. DR.
-MR.
-PREDSEDNIK/-ICA
-PODPREDSEDNIK/-ICA
-PROF. DR. (tudi brez presledkov vmes)
-znaki: "?"  "/?" "/?/"  "(?)"
-Dva imena in priimek ter dva priimlka in ime. 
-ime in vzdevek v oklepaju
-Izjemoma tudi imena in priimki napisani z malimi črkami
-vezaj med priimkoma -->
    <xsl:variable name="odvecna">
        <beseda>DR.</beseda>
        <beseda>DR</beseda>
        <beseda>dr.</beseda>
        <beseda>DR,</beseda>
        <beseda>MAG.</beseda>
        <beseda>MAG</beseda>
        <beseda>mag.</beseda>
        <beseda>mag_</beseda>
        <beseda>MAG,</beseda>
        <beseda>PROF.</beseda>
        <beseda>IZR.</beseda>
        <beseda>MR.</beseda>
        <beseda>PREDSEDNIK</beseda>
        <beseda>PREDSEDNICA</beseda>
        <beseda>PODPREDSEDNIK</beseda>
        <beseda>PODPREDSEDNICA</beseda>
        <beseda>PROF.DR.</beseda>
        <beseda>?</beseda>
        <beseda>/?/</beseda>
        <beseda>/?</beseda>
        <beseda>(?)</beseda>
        <beseda>Gospa</beseda>
        <beseda>GOSPA</beseda>
        <beseda>GOSPOD</beseda>
    </xsl:variable>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <xsl:variable name="name" select="normalize-space(translate(tei:name[1],':',''))"/>
        <xsl:variable name="words">
            <xsl:for-each select="tokenize($name,' ')">
                <xsl:choose>
                    <xsl:when test=". = $odvecna/tei:beseda">
                        <!-- ne zapišem -->
                    </xsl:when>
                    <xsl:otherwise>
                        <w>
                            <xsl:value-of select="substring(.,1,1)"/>
                            <xsl:value-of select="lower-case(substring(.,2))"/>
                        </w>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <person>
            <persName>
                <xsl:choose>
                    <xsl:when test="$words/tei:w[3]">
                        <xsl:for-each select="$words/tei:w">
                            <name>
                                <xsl:value-of select="."/>
                            </name>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <surname>
                            <xsl:value-of select="$words/tei:w[2]"/>
                        </surname>
                        <forename>
                            <xsl:value-of select="$words/tei:w[1]"/>
                        </forename>
                    </xsl:otherwise>
                </xsl:choose>
            </persName>
            
            <xsl:apply-templates/>
        </person>
    </xsl:template>
    
</xsl:stylesheet>