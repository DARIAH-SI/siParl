<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhaja iz speech-list.xml -->
    <!-- naredi sezname poglavja s seznami listBibl za http://www.sistory.si/11686/38085 -->
    <!-- OPOZORILO: NE PROCESIRAJ VSEGA NA ENKRAT, KER IMAŠ ZA TO PREMALO SPOMINA: ZATO UPORABI SPODNJI PARAMETER, KI IMA LAHKO TRI VREDNOSTI:
         - SSK
         - SDZ
         - SDT
     -->
    <xsl:param name="processing">SDT</xsl:param>
    <!-- POTEM PA ŠE ŠTEVILKA MANDATA -->
    <xsl:param name="mandate">7</xsl:param>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="documentsList">
        <body>
            <xsl:for-each-group select="folder" group-by="substring(@label,1,3)">
                <xsl:variable name="type" select="current-grouping-key()"/>
                <div type="part" xml:id="{current-grouping-key()}">
                    <head>
                        <xsl:choose>
                            <xsl:when test="current-grouping-key() = 'SSK'">Seje Skupščine Republike Slovenije</xsl:when>
                            <xsl:when test="current-grouping-key() = 'SDZ'">Seje Državnega zbora Republike Slovenije</xsl:when>
                            <xsl:when test="current-grouping-key() = 'SDT'">Seje delovnih teles Državnega zbora</xsl:when>
                            <xsl:otherwise>
                                <xsl:message>Unknown folder/@label: <xsl:value-of select="current-grouping-key()"/></xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </head>
                    <xsl:for-each-group select="current-group()" group-by="substring(@label,4)">
                        <div type="chapter" xml:id="{@label}">
                            <head>
                                <xsl:choose>
                                    <xsl:when test="current-grouping-key() = '11'">11. mandat (1990-1992)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '1'">1. mandat (1992-1996)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '2'">2. mandat (1996-2000)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '3'">3. mandat (2000-2004)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '4'">4. mandat (2004-2008)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '5'">5. mandat (2008-2011)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '6'">6. mandat (2011-2014)</xsl:when>
                                    <xsl:when test="current-grouping-key() = '7'">7. mandat (2014-2018)</xsl:when>
                                </xsl:choose>
                            </head>
                            <listBibl>
                                <xsl:for-each select="ref">
                                    <xsl:sort>
                                        <xsl:analyze-string select="." regex="\d{{4}}-\d{{2}}-\d{{2}}">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:sort>
                                    <xsl:choose>
                                        <xsl:when test="$type = 'SSK'">
                                            <xsl:if test="$processing = $type and current-grouping-key() = $mandate">
                                                <xsl:apply-templates select="document(.)" mode="SSK">
                                                    <xsl:with-param name="document-uri" select="."/>
                                                </xsl:apply-templates>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="$type = 'SDZ'">
                                            <xsl:if test="$processing = $type and current-grouping-key() = $mandate">
                                                <xsl:apply-templates select="document(.)" mode="SDZ">
                                                    <xsl:with-param name="document-uri" select="."/>
                                                </xsl:apply-templates>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="$type = 'SDT'">
                                            <xsl:if test="$processing = $type and current-grouping-key() = $mandate">
                                                <xsl:apply-templates select="document(.)" mode="SDT">
                                                    <xsl:with-param name="document-uri" select="."/>
                                                </xsl:apply-templates>
                                            </xsl:if>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </listBibl>
                        </div>
                    </xsl:for-each-group>
                </div>
            </xsl:for-each-group>
        </body>
    </xsl:template>
    
    <xsl:template match="tei:TEI" mode="SSK">
        <xsl:param name="document-uri"/>
        <xsl:variable name="filename" select="(tokenize($document-uri,'/'))[last()]"/>
        <!-- Štetje besed -->
        <xsl:variable name="counting">
            <string>
                <xsl:apply-templates select="tei:text/tei:body"/>
            </string>
        </xsl:variable>
        <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
        <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
        <biblStruct type="minutes" xml:id="{@xml:id}">
            <monogr>
                <title type="chamber">
                    <xsl:value-of select="normalize-space(tokenize(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],':')[1])"/>
                </title>
                <title type="session">
                    <xsl:value-of select="normalize-space(tokenize(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],':')[2])"/>
                </title>
                <imprint>
                    <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                    <distributor>CLARIN.SI</distributor>
                    <biblScope unit="sp">
                        <xsl:value-of select="count(//tei:u)"/>
                    </biblScope>
                    <biblScope unit="w">
                        <xsl:value-of select="$count-words"/>
                    </biblScope>
                    <date when="{tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date/@when}">
                        <xsl:value-of select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
                    </date>
                </imprint>
            </monogr>
            <ref target="{$filename}">
                <xsl:value-of select="$filename"/>
            </ref>
        </biblStruct>
    </xsl:template>
    
    <xsl:template match="tei:TEI" mode="SDZ">
        <xsl:param name="document-uri"/>
        <xsl:variable name="filename" select="(tokenize($document-uri,'/'))[last()]"/>
        <!-- Štetje besed -->
        <xsl:variable name="counting">
            <string>
                <xsl:apply-templates select="tei:text/tei:body"/>
            </string>
        </xsl:variable>
        <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
        <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
        <biblStruct type="minutes" xml:id="{@xml:id}">
            <monogr>
                <title type="session">
                    <xsl:value-of select="substring-before(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],' (')"/>
                </title>
                <imprint>
                    <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                    <distributor>CLARIN.SI</distributor>
                    <biblScope unit="sp">
                        <xsl:value-of select="count(//tei:u)"/>
                    </biblScope>
                    <biblScope unit="w">
                        <xsl:value-of select="$count-words"/>
                    </biblScope>
                    <date when="{tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date/@when}">
                        <xsl:value-of select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
                    </date>
                </imprint>
            </monogr>
            <ref target="{$filename}">
                <xsl:value-of select="$filename"/>
            </ref>
        </biblStruct>
    </xsl:template>
    
    <xsl:template match="tei:TEI" mode="SDT">
        <xsl:param name="document-uri"/>
        <xsl:variable name="filename" select="(tokenize($document-uri,'/'))[last()]"/>
        <!-- Štetje besed -->
        <xsl:variable name="counting">
            <string>
                <xsl:apply-templates select="tei:text/tei:body"/>
            </string>
        </xsl:variable>
        <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
        <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
        
        <xsl:choose>
            <!-- če je kolegij predsednika državenga zbora -->
            <xsl:when test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main'] ='Dobesedni zapis seje Kolegija predsednika Državnega zbora Republike Slovenije'">
                <biblStruct type="minutes" xml:id="{@xml:id}">
                    <monogr>
                        <title type="KPDZ">Kolegij predsednika Državnega zbora</title>
                        <title type="session">
                            <xsl:value-of select="substring-before(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],' (')"/>
                        </title>
                        <imprint>
                            <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                            <distributor>CLARIN.SI</distributor>
                            <biblScope unit="sp">
                                <xsl:value-of select="count(//tei:u)"/>
                            </biblScope>
                            <biblScope unit="w">
                                  <xsl:value-of select="$count-words"/>
                            </biblScope>
                            <date when="{tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date/@when}">
                                <xsl:value-of select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
                            </date>
                        </imprint>
                    </monogr>
                    <ref target="{$filename}">
                        <xsl:value-of select="$filename"/>
                    </ref>
                </biblStruct>
            </xsl:when>
            <!-- če so skupne seje različnih delovnih teles -->
            <xsl:when test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'][2]">
                <biblStruct type="minutes" xml:id="{@xml:id}">
                    <monogr>
                        <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl']">
                            <title type="workingBody-session-date">
                                <xsl:value-of select="."/>
                            </title>
                        </xsl:for-each>
                        <imprint>
                            <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                            <distributor>CLARIN.SI</distributor>
                            <biblScope unit="sp">
                                <xsl:value-of select="count(//tei:u)"/>
                            </biblScope>
                            <biblScope unit="w">
                                  <xsl:value-of select="$count-words"/>
                            </biblScope>
                            <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date">
                                <date when="{@when}">
                                    <xsl:value-of select="."/>
                                </date>
                            </xsl:for-each>
                        </imprint>
                    </monogr>
                    <ref target="{$filename}">
                        <xsl:value-of select="$filename"/>
                    </ref>
                </biblStruct>
            </xsl:when>
            <xsl:otherwise>
                <biblStruct type="minutes" xml:id="{@xml:id}">
                    <monogr>
                        <title type="workingBody">
                            <xsl:value-of select="normalize-space(tokenize(substring-before(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],' ('),':')[1])"/>
                        </title>
                        <title type="session">
                            <xsl:value-of select="normalize-space(tokenize(substring-before(tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],' ('),':')[2])"/>
                        </title>
                        <imprint>
                            <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                            <distributor>CLARIN.SI</distributor>
                            <biblScope unit="sp">
                                <xsl:value-of select="count(//tei:u)"/>
                            </biblScope>
                            <biblScope unit="w">
                                  <xsl:value-of select="$count-words"/>
                            </biblScope>
                            <date when="{tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date/@when}">
                                <xsl:value-of select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
                            </date>
                        </imprint>
                    </monogr>
                    <ref target="{$filename}">
                        <xsl:value-of select="$filename"/>
                    </ref>
                </biblStruct>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>