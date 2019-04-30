<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:template match="tei:divGen[@xml:id]">
        <xsl:variable name="datoteka" select="concat($outputDir,@xml:id,'.html')"/>
        <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
            <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
            <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
            <html>
                <xsl:call-template name="addLangAtt"/>
                <!-- vključimo statični head -->
                <xsl:variable name="pagetitle">
                    <xsl:choose>
                        <xsl:when test="tei:head">
                            <xsl:apply-templates select="tei:head" mode="plain"/>
                        </xsl:when>
                        <xsl:when test="self::tei:TEI">
                            <xsl:value-of select="tei:generateTitle(.)"/>
                        </xsl:when>
                        <xsl:when test="self::tei:text">
                            <xsl:value-of select="tei:generateTitle(ancestor::tei:TEI)"/>
                            <xsl:value-of select="concat('[', position(), ']')"/>
                        </xsl:when>
                        <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
                <!-- začetek body -->
                <body id="TOP">
                    <xsl:call-template name="bodyMicroData"/>
                    <xsl:call-template name="bodyJavascriptHook">
                        <xsl:with-param name="thisLanguage"  select="@xml:lang"/>
                    </xsl:call-template>
                    <xsl:call-template name="bodyHook"/>
                    <!-- začetek vsebine -->
                    <div class="column row">
                        <xsl:if test="self::tei:divGen[@type='cip']">
                            <!-- Microdata - schema.org - dodam itemscope -->
                            <xsl:attribute name="itemscope"/>
                            <!-- in itemtype za knjige -->
                            <xsl:attribute name="itemtype">http://schema.org/Book</xsl:attribute>
                        </xsl:if>
                        <!-- vstavim svoj header -->
                        <xsl:call-template name="html-header">
                            <xsl:with-param name="thisChapter-id" select="@xml:id"/>
                            <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                        </xsl:call-template>
                        <!-- GLAVNA VSEBINA -->
                        <section>
                            <div class="row">
                                <div class="medium-2 columns show-for-medium">
                                    <xsl:call-template name="previous-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                        <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                                    </xsl:call-template>
                                </div>
                                <div class="medium-8 small-12 columns">
                                    <xsl:call-template name="stdheader">
                                        <xsl:with-param name="title">
                                            <xsl:call-template name="header"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </div>
                                <div class="medium-2 columns show-for-medium text-right">
                                    <xsl:call-template name="next-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                        <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                            <div class="row hide-for-medium">
                                <div class="small-6 columns text-center">
                                    <xsl:call-template name="previous-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                        <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                                    </xsl:call-template>
                                </div>
                                <div class="small-6 columns text-center">
                                    <xsl:call-template name="next-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                        <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                            <!--<xsl:if test="$topNavigationPanel = 'true'">
                                                <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                                                    <xsl:call-template name="xrefpanel">
                                                         <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                                                         <xsl:with-param name="mode" select="local-name(.)"/>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:if>-->
                            <xsl:if test="$subTocDepth >= 0">
                                <xsl:call-template name="subtoc"/>
                            </xsl:if>
                            <xsl:call-template name="startHook"/>
                            <!-- VSTAVI VSEBINO divGen strani -->
                            <!-- zaradi lažjega nadzora nad procesiranjem divGen, jih procesiram preko ločenega call-template -->
                            <xsl:call-template name="divGen-main-content">
                                <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                            </xsl:call-template>
                            
                            <!--<xsl:call-template name="makeDivBody">
                                                <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                                            </xsl:call-template>-->
                            <xsl:call-template name="printNotes"/>
                            <!--<xsl:if test="$bottomNavigationPanel = 'true'">
                                                    <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                                                        <xsl:call-template name="xrefpanel">
                                                            <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                                                            <xsl:with-param name="mode" select="local-name(.)"/>
                                                        </xsl:call-template>
                                                     </xsl:element>
                                            </xsl:if>-->
                            <xsl:call-template name="stdfooter"/>
                        </section>
                    </div>
                    <xsl:call-template name="bodyEndHook"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="previous-divGen-Link">
        <xsl:param name="thisDivGenType"/>
        <xsl:param name="thisLanguage"/>
        <xsl:variable name="sistoryPath">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="preceding-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="preceding-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType]">
            <a class="button" href="{concat($sistoryPath,preceding-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/@xml:id,'.html')}" title="{preceding-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/tei:head}">&lt;&lt;</a>
        </xsl:if>
    </xsl:template>
    <xsl:template name="next-divGen-Link">
        <xsl:param name="thisDivGenType"/>
        <xsl:param name="thisLanguage"/>
        <xsl:variable name="sistoryPath">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="following-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="following-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType]">
            <a class="button" href="{concat($sistoryPath,following-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/@xml:id,'.html')}" title="{following-sibling::tei:divGen[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][@type = $thisDivGenType][1]/tei:head}">&gt;&gt;</a>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="divGen-main-content">
        <xsl:param name="thisLanguage"/>
        <!-- kolofon CIP -->
        <xsl:if test="self::tei:divGen[@type='cip']">
            <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc" mode="kolofon"/>
        </xsl:if>
        <!-- TEI kolofon -->
        <xsl:if test="self::tei:divGen[@type='teiHeader']">
            <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
        </xsl:if>
        <!-- kazalo vsebine toc -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='toc'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='toc']">
            <xsl:choose>
                <xsl:when test="$languages-locale='true'">
                    <xsl:call-template name="mainTOC-my">
                        <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="mainTOC"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- kazalo slik -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='images'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='images']">
            <xsl:call-template name="images">
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
            </xsl:call-template>
        </xsl:if>
        <!-- kazalo grafikonov -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='charts'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='charts']">
            <xsl:call-template name="charts">
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
            </xsl:call-template>
        </xsl:if>
        <!-- kazalo tabel -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='tables'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='tables']">
            <xsl:call-template name="tables">
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
            </xsl:call-template>
        </xsl:if>
        <!-- kazalo vsebine toc, ki izpiše samo glavne naslove poglavij, skupaj z imeni avtorjev poglavij -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleAuthor'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleAuthor']">
            <xsl:call-template name="TOC-title-author"/>
        </xsl:if>
        <!-- kazalo vsebine toc, ki izpiše samo naslove poglavij, kjer ima div atributa type in xml:id -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleType'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleType']">
            <xsl:call-template name="TOC-title-type"/>
        </xsl:if>
        <!-- prazen divGen, v katerem lahko naknadno poljubno procesiramo vsebino -->
        <xsl:if test="self::tei:divGen[@type='content']">
            <xsl:call-template name="divGen-process-content"/>
        </xsl:if>
        <!-- seznam (indeks) oseb -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='persons']">
            <xsl:call-template name="persons"/>
        </xsl:if>
        <!-- seznam (indeks) krajev -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='places'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='places']">
            <xsl:call-template name="places"/>
        </xsl:if>
        <!-- seznam (indeks) organizacij -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='organizations'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='organizations']">
            <xsl:call-template name="organizations"/>
        </xsl:if>
        <!-- iskalnik -->
        <xsl:if test="self::tei:divGen[@type='search']">
            <xsl:call-template name="search"/>
        </xsl:if>
    </xsl:template>
    
    <!-- Moja prilagoditev prevzetega procesiranja kazala glede na language-locale -->
    <xsl:template name="mainTOC-my">
        <xsl:param name="thisLanguage"/>
        <xsl:if test="$tocFront">
            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front">
                <xsl:call-template name="partTOC-my">
                    <xsl:with-param name="part">front</xsl:with-param>
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:body">
            <xsl:call-template name="partTOC-my">
                <xsl:with-param name="part">body</xsl:with-param>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="$tocBack">
            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back">
                <xsl:call-template name="partTOC-my">
                    <xsl:with-param name="part">back</xsl:with-param>
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="partTOC-my">
        <xsl:param name="part"/>
        <xsl:param name="force"/>
        <xsl:param name="thisLanguage"/>
        <xsl:if test="tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
            <ul class="toc{$force} toc_{$part}">
                <xsl:apply-templates mode="maketoc"
                    select="tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                    <xsl:with-param name="forcedepth" select="$force"/>
                </xsl:apply-templates>
            </ul>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>