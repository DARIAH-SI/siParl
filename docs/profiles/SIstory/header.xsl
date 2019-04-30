<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="html-header">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <header>
            <div class="hide-for-large">
                <xsl:if test="$title-bar-sticky = 'true'">
                    <xsl:attribute name="data-sticky-container"/>
                </xsl:if>
                <div id="header-bar">
                    <xsl:if test="$title-bar-sticky = 'true'">
                        <xsl:attribute name="data-sticky"/>
                        <xsl:attribute name="data-sticky-on">small</xsl:attribute>
                        <xsl:attribute name="data-options">marginTop:0;</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="data-top-anchor">1</xsl:attribute>
                    </xsl:if>
                    <div class="title-bar" data-responsive-toggle="publication-menu" data-hide-for="large">
                        <button class="menu-icon" type="button" data-toggle=""></button>
                        <div class="title-bar-title">
                            <xsl:choose>
                                <xsl:when test="$languages-locale='true'">
                                    <xsl:call-template name="myi18n-lang">
                                        <xsl:with-param name="word">Menu</xsl:with-param>
                                        <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="tei:i18n('Menu')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="title-bar-right">
                            <a class="title-bar-title" href="{$homeURL}">
                                <i class="fi-home" style="color:white;"></i>
                            </a>
                        </div>
                        <div id="publication-menu" class="hide-for-large">
                            <ul class="vertical menu" data-drilldown="" data-options="backButton: &lt;li class=&quot;js-drilldown-back&quot;&gt;&lt;a tabindex=&quot;0&quot;&gt;{tei:i18n('Nazaj')}&lt;/a&gt;&lt;/li&gt;;">
                                <xsl:call-template name="title-bar-list-of-contents">
                                    <xsl:with-param name="title-bar-type">vertical</xsl:with-param>
                                    <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="show-for-large">
                <xsl:if test="$title-bar-sticky = 'true'">
                    <xsl:attribute name="data-sticky-container"/>
                </xsl:if>
                <nav class="title-bar">
                    <xsl:if test="$title-bar-sticky = 'true'">
                        <xsl:attribute name="data-sticky"/>
                        <xsl:attribute name="data-options">marginTop:0;</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="data-top-anchor">1</xsl:attribute>
                    </xsl:if>
                    <div class="title-bar-left">
                        <a class="title-bar-title" href="{$homeURL}">
                            <i class="fi-home" style="color:white;"></i>
                            <xsl:text> </xsl:text>
                            <span>
                                <xsl:value-of select="$homeLabel"/>
                            </span>
                        </a>
                    </div>
                    <div class="title-bar-right">
                        <ul class="dropdown menu" data-dropdown-menu="">
                            <xsl:call-template name="title-bar-list-of-contents">
                                <xsl:with-param name="title-bar-type">dropdown</xsl:with-param>
                                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                            </xsl:call-template>
                        </ul>
                    </div>
                </nav>
            </div>
            
            <!-- iskalnik -->
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:variable name="sistoryPath-search">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search'][@xml:lang=$thisLanguage]/@xml:id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <form action="{concat($sistoryPath-search,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search'][@xml:lang=$thisLanguage]/@xml:id,'.html')}">
                            <div class="row collapse">
                                <div class="small-10 large-11 columns">
                                    <input type="text" name="q" id="tipue_search_input">
                                        <xsl:attribute name="placeholder">
                                            <xsl:call-template name="myi18n-lang">
                                                <xsl:with-param name="word">Search placeholder</xsl:with-param>
                                                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </input>
                                </div>
                                <div class="small-2 large-1 columns">
                                    <img type="button" class="tipue_search_button"/>
                                </div>
                            </div>
                        </form>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="sistoryPath-search">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']/@xml:id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <form action="{concat($sistoryPath-search,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']/@xml:id,'.html')}">
                            <div class="row collapse">
                                <div class="small-10 large-11 columns">
                                    <input type="text" name="q" id="tipue_search_input" placeholder="{tei:i18n('Search placeholder')}"/>
                                </div>
                                <div class="small-2 large-1 columns">
                                    <img type="button" class="tipue_search_button"/>
                                </div>
                            </div>
                        </form>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </header>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
    </doc>
    <xsl:template name="title-bar-list-of-contents">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:variable name="sistoryParentPath">
            <xsl:choose>
                <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="self::tei:teiCorpus/@xml:id"/>
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$teiParentId"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="ancestor-or-self::tei:TEI/@xml:id"/>
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$teiParentId"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Poiščemo vse možne dele publikacije -->
        <!-- Naslovnica - index.html je vedno, kadar ni procesirano iz teiCorpus in ima hkrati TEI svoj xml:id -->
        <li>
            <!-- večjezično poimenovanje index html datotek -->
            <xsl:variable name="index-html">
                <xsl:choose>
                    <xsl:when test="$thisLanguage != $languages-locale-primary">
                        <xsl:value-of select="concat('index','-',$thisLanguage)"/>
                    </xsl:when>
                    <xsl:otherwise>index</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$thisChapter-id = $index-html">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="ancestor::tei:teiCorpus and ancestor-or-self::tei:TEI[@xml:id]">
                            <xsl:value-of select="concat($sistoryParentPath,ancestor-or-self::tei:TEI/@xml:id,'.html')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($sistoryParentPath,$index-html,'.html')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="tei:text[@type = 'article'] or ancestor::tei:text[@type = 'article'] or self::tei:teiCorpus/tei:TEI/tei:text[@type = 'article']">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Naslov</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Naslov')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Naslovnica</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Naslovnica')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
        <!-- kolofon: CIP in teiHeader -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader']">
            <xsl:call-template name="header-colophon">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- kolofon CIP za teiCorpus za revije: TODO za večjezičnost-locale -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-cip='true'">
            <li>
                <xsl:if test="$thisChapter-id='cip'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="self::tei:teiCorpus/@xml:id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <a href="{concat($sistoryPath,'impressum.html')}">
                    <xsl:sequence select="tei:i18n('impressum')"/>
                </a>
            </li>
        </xsl:if>
        <!-- TEI kolofon za teiCorpus za revije: TODO za večjezičnost-locale -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-teiHeader='true'">
            <li>
                <xsl:if test="$thisChapter-id='teiHeader'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="self::tei:teiCorpus/@xml:id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <a href="{concat($sistoryPath,'teiHeader.html')}">
                    <xsl:sequence select="tei:i18n('teiHeader')"/>
                </a>
            </li>
        </xsl:if>
        <!-- kazalo toc titleAuthor za teiCorpus za revije (predpogoj: tei:text mora imeti @n): TODO za večjezičnost-locale -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-toc_titleAuthor='true'">
            <li>
                <xsl:if test="$thisChapter-id='tocJournal'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="self::tei:teiCorpus/@xml:id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <a href="{concat($sistoryPath,'tocJournal.html')}">
                    <xsl:sequence select="tei:i18n('tocJournal')"/>
                </a>
            </li>
        </xsl:if>
        <!-- kazalo toc -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']">
            <xsl:call-template name="header-toc">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Uvodna poglavja v tei:front -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div">
            <xsl:call-template name="header-front">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Osrednji del besedila v tei:body - Poglavja -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div">
            <xsl:call-template name="header-body">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Content: divGen, ki požene prazen template divGen-process-content,
             v katerega lahko vstavimo pretvorbo za dinamično prikazovanje glavne vsebine -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:divGen[@type='content']">
            <xsl:call-template name="header-content">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- viri in literatura v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
            <xsl:call-template name="header-bibliogr">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Spremne besedila/študije k digitalnim izdajam -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study']">
            <xsl:call-template name="header-study">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Priloge v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']">
            <xsl:call-template name="header-appendix">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- povzetki -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']">
            <xsl:call-template name="header-summary">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Indeksi (oseb, krajev in organizacij) v divGen ali v div -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index']">
            <xsl:call-template name="header-back-index">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- languages - locale -->
        <xsl:if test="$languages-locale='true'">
            <xsl:call-template name="header-locale">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-colophon">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='cip' or @type='teiHeader']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi cip -->
            <xsl:variable name="sistoryPath-colophon1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-colophon1,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-colophon-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-toc">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-toc,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-toc,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-toc">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='toc']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi toc -->
            <xsl:variable name="sistoryPath-toc1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-toc1,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-toc-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-toc">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-toc,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-toc,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-front">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[parent::tei:front][self::tei:div]">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi front/div -->
            <xsl:variable name="sistoryPath-front1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-front1,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-front-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-front">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-front,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-front,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-body">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[ancestor::tei:body and self::tei:div][tokenize($thisChapter-id,'-')[1] != 'index']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi body/div -->
            <xsl:variable name="sistoryPath-body1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-body1,ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-body-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <!--<xsl:variable name="chapters-id" select="@xml:id"/>-->
                        <li>
                            <xsl:if test="descendant-or-self::tei:div[@xml:id = $thisChapter-id]">
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:apply-templates mode="generateLink" select="."/>
                                </xsl:attribute>
                                <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                            </a>
                            <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                            </xsl:call-template>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-content">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <xsl:variable name="sistoryPath-content">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:divGen[@type='content'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <li>
            <xsl:if test=".[@type='content']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{concat($sistoryPath-content,ancestor-or-self::tei:TEI/tei:text/tei:body/tei:divGen[@type='content'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]/@xml:id,'.html')}">
                <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:divGen[@type='content'][if ($languages-locale='true') then @xml:lang=$thisLanguage else tei:head]/tei:head[1]"/>
            </a>
        </li>
    </xsl:template>
    
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-bibliogr">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='bibliogr']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z bibliogr -->
            <xsl:variable name="sistoryPath-bibliogr1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-bibliogr1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Bibliografija</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Bibliografija')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-bibliogr">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-bibliogr,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-bibliogr,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-study">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='study']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z appendix -->
            <xsl:variable name="sistoryPath-study">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-study,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-study-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-appendix">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-appendix,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-appendix,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-appendix">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='appendix']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z appendix -->
            <xsl:variable name="sistoryPath-appendix1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-appendix1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-appendix-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-appendix">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-appendix,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-appendix,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-summary">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='summary']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z summary -->
            <xsl:variable name="sistoryPath-summary1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-summary1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-summary-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-summary">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-summary,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-summary,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
        <param name="title-bar-type"></param>
        <param name="sistoryParentPath"></param>
    </doc>
    <xsl:template name="header-back-index">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='index']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi indeks -->
            <xsl:variable name="sistoryPath-index1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-index1,ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-index-head">
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-index">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-index,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-index,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="header-locale">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="thisLanguage"/>
        <li>
            <a href="#">
                <xsl:call-template name="myi18n-lang">
                    <xsl:with-param name="word">Locale</xsl:with-param>
                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                </xsl:call-template>
            </a>
            <ul class="menu">
                <xsl:variable name="otherGroupLanguage">
                    <xsl:for-each-group select="//tei:div[@xml:id][@xml:lang != $thisLanguage]" group-by="@xml:lang">
                        <lang>
                            <xsl:value-of select="current-grouping-key()"/>
                        </lang>
                    </xsl:for-each-group>
                </xsl:variable>
                <xsl:for-each-group select="//tei:div[@xml:id][@xml:lang != $thisLanguage]" group-by="@xml:lang">
                    <xsl:variable name="thisGroupLanguage" select="current-grouping-key()"/>
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:variable name="language-corresp">
                                    <xsl:for-each select="//tei:*[@xml:id=$thisChapter-id]">
                                        <xsl:for-each select="tokenize(@corresp,' ')">
                                            <to>
                                                <xsl:value-of select="substring-after(.,'#')"/>
                                            </to>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:variable name="correspChapterId">
                                    <xsl:choose>
                                        <xsl:when test="tokenize($thisChapter-id,'-')[1] = 'index'">
                                            <xsl:choose>
                                                <xsl:when test="$languages-locale-primary=$thisGroupLanguage">index</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('index','-',$thisGroupLanguage)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="//tei:*[@xml:id=$language-corresp/html:to][@xml:lang=$thisGroupLanguage]">
                                                <xsl:value-of select="@xml:id"/>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="sistoryPath">
                                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                                        <xsl:call-template name="sistoryPath">
                                            <xsl:with-param name="chapterID" select="$correspChapterId"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:variable>
                                <xsl:value-of select="concat($sistoryPath,$correspChapterId,'.html')"/>
                            </xsl:attribute>
                            <xsl:call-template name="myi18n-lang">
                                <xsl:with-param name="word">Locale</xsl:with-param>
                                <xsl:with-param name="thisLanguage" select="current-grouping-key()"/>
                            </xsl:call-template>
                        </a>
                    </li>
                </xsl:for-each-group>
            </ul>
        </li>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:head" mode="chapters-head">
        <xsl:apply-templates mode="chapters-head"/>
    </xsl:template>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:note" mode="chapters-head">
        <!-- ne procesirmar -->
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="title-bar-type"></param>
    </doc>
    <xsl:template name="attribute-title-bar-type">
        <xsl:param name="title-bar-type"/>
        <xsl:attribute name="class">
            <xsl:if test="$title-bar-type = 'vertical'">vertical menu</xsl:if>
            <xsl:if test="$title-bar-type = 'dropdown'">menu</xsl:if>
        </xsl:attribute>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
        <param name="thisChapter-id"></param>
        <param name="title-bar-type"></param>
    </doc>
    <xsl:template name="title-bar-list-of-contents-subchapters">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:if test="tei:div[@xml:id][@type]">
            <ul>
                <xsl:attribute name="class">
                    <xsl:if test="$title-bar-type = 'vertical'">vertical menu</xsl:if>
                    <xsl:if test="$title-bar-type = 'dropdown'">menu</xsl:if>
                </xsl:attribute>
                <xsl:for-each select="tei:div">
                    <li>
                        <xsl:if test="descendant-or-self::tei:div[@xml:id = $thisChapter-id]">
                            <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:apply-templates mode="generateLink" select="."/>
                            </xsl:attribute>
                            <!--<xsl:attribute name="href">
                                <xsl:variable name="this-subchapterID" select="@xml:id"/>
                                <xsl:value-of select="concat(ancestor::tei:div[1]/@xml:id,'.html#',$this-subchapterID)"/>
                            </xsl:attribute>-->
                            <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                        </a>
                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis imena, glede na število kazal: so lahko v tei:front</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-toc-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kazalo</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kazalo')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kazali</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kazali')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kazala</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kazala')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis imena, glede na število indeksov (krajevnih, osebnih, organizacij): so lahko v tei:back</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-index-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Indeks</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Indeks')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/*[self::tei:divGen or self::tei:div][@type='index'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Indeksa</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Indeksa')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Indeksi</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Indeksi')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis imen, gle na cip in teiHeader kolofon</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-colophon-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kolofon</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kolofon')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip' or @type='teiHeader'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kolofona</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kolofona')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Kolofoni</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Kolofoni')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis imena, glede na število front/div</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-front-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <!-- če je article, je lahko samo abstract -->
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text[@type='article'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Izvleček</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Izvleček')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Izvlečka</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Izvlečka')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Izvlečki</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Izvlečki')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Uvod</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Uvod')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Uvoda</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Uvoda')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Uvodi</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Uvodi')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis imena, glede na število body/div</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-body-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text[@type='article'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Besedilo članka</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Besedilo članka')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[@type='part'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Besedilo</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Besedilo')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Poglavje</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Poglavje')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Poglavji</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Poglavji')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$languages-locale='true'">
                                <xsl:call-template name="myi18n-lang">
                                    <xsl:with-param name="word">Poglavja</xsl:with-param>
                                    <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="tei:i18n('Poglavja')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis spremnih študij, glede na število back/div</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-study-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Priloga</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Študija')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='study'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Prilogi</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Študiji')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Priloge</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Študije')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis prilog, glede na število back/div</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-appendix-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Priloga</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Priloga')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Prilogi</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Prilogi')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Priloge</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Priloge')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>izpis povzetkov, glede na število back/div</desc>
        <param name="thisLanguage"></param>
    </doc>
    <xsl:template name="nav-summary-head">
        <xsl:param name="thisLanguage"/>
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 1">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Povzetek</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Povzetek')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][if ($languages-locale='true') then @xml:lang=$thisLanguage else @xml:id]) = 2">
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Povzetka</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Povzetka')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$languages-locale='true'">
                        <xsl:call-template name="myi18n-lang">
                            <xsl:with-param name="word">Povzetki</xsl:with-param>
                            <xsl:with-param name="thisLanguage" select="$thisLanguage"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Povzetki')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
