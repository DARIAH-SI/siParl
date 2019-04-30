<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="tei html teidocx xs"
   version="2.0">

   <!-- import base conversion style -->
   <!-- <xsl:import href="../../../html5/html5.xsl"/>
   <xsl:import href="../../../html5/microdata.xsl"/> -->
   
   <!-- change path to your TEI Stylesheets https://github.com/TEIC/Stylesheets/blob/master/html5/html5.xsl -->
   <xsl:import href="../../stylesheet/html5/html5.xsl"/>
   <!-- change path to your TEI Stylesheets https://github.com/TEIC/Stylesheets/blob/master/html5/microdata.xsl -->
   <xsl:import href="../../stylesheet/html5/microdata.xsl"/>
   <xsl:import href="my-html_param.xsl"/>
   <xsl:import href="myi18n.xsl"/>
   
   <xsl:import href="new-html_figures.xsl"/>
   <xsl:import href="new-html_core.xsl"/>
   <xsl:import href="new-html_corpus.xsl"/>
   
   <xsl:import href="titlePage.xsl"/>
   <xsl:import href="header.xsl"/>
   <xsl:import href="divGen-common.xsl"/>
   <xsl:import href="divGen.xsl"/>
   
   <xsl:import href="my-html_core.xsl"/>
   <xsl:import href="my-html_namesdates.xsl"/>
   <xsl:import href="bibliography.xsl"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for making HTML5 output (Zurb Foundation 6 http://foundation.zurb.com/sites/docs/).</p>
         <p>This software is dual-licensed:
            
            1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
            Unported License http://creativecommons.org/licenses/by-sa/3.0/ 
            
            2. http://www.opensource.org/licenses/BSD-2-Clause
            
            
            
            Redistribution and use in source and binary forms, with or without
            modification, are permitted provided that the following conditions are
            met:
            
            * Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer.
            
            * Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.
            
            This software is provided by the copyright holders and contributors
            "as is" and any express or implied warranties, including, but not
            limited to, the implied warranties of merchantability and fitness for
            a particular purpose are disclaimed. In no event shall the copyright
            holder or contributors be liable for any direct, indirect, incidental,
            special, exemplary, or consequential damages (including, but not
            limited to, procurement of substitute goods or services; loss of use,
            data, or profits; or business interruption) however caused and on any
            theory of liability, whether in contract, strict liability, or tort
            (including negligence or otherwise) arising in any way out of the use
            of this software, even if advised of the possibility of such damage.
         </p>
         <p>Andrej Pančur, Institute for Contemporary History</p>
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>
   
   <xsl:output method="xhtml" omit-xml-declaration="yes" indent="no" encoding="UTF-8"/>
   <xsl:param name="doctypeSystem"></xsl:param>
   
   <!-- prevod: opombe, slike ipd. Pobere iz ../i18n.xml -->
   <xsl:param name="documentationLanguage">sl</xsl:param>
   
   <!-- verbose - izpišejo se pojansila; koristno v času kodiranja (true), drugače odstrani oz. false -->
   <xsl:param name="verbose">false</xsl:param>
   
   <xsl:param name="outputDir">HTML</xsl:param>
   <xsl:param name="splitLevel">0</xsl:param>
   <xsl:param name="STDOUT">false</xsl:param>
   
   <!-- head v drugem div je h3 itn. Glej še spodaj template stdheader -->
   <xsl:param name="divOffset">2</xsl:param>
   
   <xsl:param name="homeLabel">SIstory</xsl:param>
   <xsl:param name="homeURL">http://sistory.si/</xsl:param>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>Standardni footer je brez vsebine (po potrebi dodaj tukaj vsebino)</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="stdfooter"/>
   
   <xsl:param name="institution"></xsl:param>
   <xsl:param name="footnoteBackLink">true</xsl:param>
   <xsl:param name="generateParagraphIDs">true</xsl:param>
   <xsl:param name="numberBackHeadings"></xsl:param>
   <xsl:param name="numberFigures">true</xsl:param>
   <xsl:param name="numberFrontTables">true</xsl:param>
   <xsl:param name="numberHeadings">true</xsl:param>
   <xsl:param name="numberParagraphs">true</xsl:param>
   <xsl:param name="numberTables">true</xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="figures" type="string">
      <desc>Directory specification to put before names of graphics files,
         unless they start with "./"</desc>
   </doc>
   <xsl:param name="graphicsPrefix"/>
   
   <!-- vzeto iz html.xsl -->
   <!-- Vsak body mora nujno imeti div in tudi, če ima samo enega, naredi na podlagi njegovega xml:id nov html dokument -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>whether a div starts a new page</desc>
      <param name="context"/>
   </doc>
   <xsl:function name="tei:keepDivOnPage" as="xs:boolean">
      <xsl:param name="context"/>
      <xsl:for-each select="$context">
         <xsl:choose>
            <!-- 4. we are part of an inner text -->
            <xsl:when test="ancestor::tei:floatingText">true</xsl:when>
            <!-- 3. we have special rendering on the document -->
            <xsl:when test="ancestor::tei:TEI/tei:match(@rend,'all') 
               or ancestor::tei:TEI/tei:match(@rend,'frontpage') 
               or ancestor::tei:TEI/tei:match(@rend,'nosplit')">true</xsl:when>
            <!-- zato tega odstranim -->
            <!-- 2. we are a singleton -->
            <!--<xsl:when test="parent::tei:body[count(*)=1] and not(tei:div or
               tei:div2)">true</xsl:when>-->
            <!-- 1. we have no proceding sections at top level -->
            <xsl:when test="not(ancestor::tei:group) and parent::tei:body and
               not(parent::tei:body/preceding-sibling::tei:front)
               and not	(preceding-sibling::*)">true</xsl:when>
            <!-- 0. we are down the hierarchy -->
            <xsl:when test="tei:match(@rend,'nosplit')">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:function>
   
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="headHook">
      <meta http-equiv="x-ua-compatible" content="ie=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description"
         content="{$description}"/>
      <meta name="keywords" content="{$keywords}"/>
   </xsl:template>
   <xsl:param name="cssFile">
      <xsl:value-of select="concat($path-general,'themes/foundation/6/css/foundation.min.css')"/>
   </xsl:param>
   <xsl:param name="cssPrintFile"></xsl:param>
   <xsl:param name="cssSecondaryFile">
      <xsl:value-of select="concat($path-general,'themes/css/foundation/6/sistory.css')"/>
   </xsl:param>
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="cssHook">
      <xsl:if test="$title-bar-sticky = 'true'">
         <xsl:value-of select="concat($path-general,'themes/css/foundation/6/sistory-sticky_title_bar.css')"/>
      </xsl:if>
      <link href="http://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/css/normalize.css')}" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'themes/css/plugin/TipueSearch/6.1/my-tipuesearch.css')}" rel="stylesheet" type="text/css" />
   </xsl:template>
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>[html] Hook where extra Javascript functions can be defined</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="javascriptHook">
      <script src="{concat($path-general,'themes/foundation/6/js/vendor/jquery.js')}"></script>
      <!-- za highcharts -->
      <xsl:if test="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']]">
         <xsl:variable name="jsfile" select="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']][1]/tei:graphic[@mimeType = 'application/javascript']/@url"/>
         <xsl:variable name="chart-jsfile" select="document($jsfile)/html/body/script[1]/@src"/>
         <script src="{$chart-jsfile[1]}"></script>
      </xsl:if>
      <!-- za back-to-top in highcharts je drugače potrebno dati jquery, vendar sedaj ne rabim dodajati jquery kodo,
         ker je že vsebovana zgoraj -->
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where Javascript calls can be inserted  just after &lt;body&gt;</desc>
      <param name="thisLanguage"></param>
   </doc>
   <xsl:template name="bodyJavascriptHook">
      <xsl:param name="thisLanguage"/>
      <!-- za iskalnik tipue -->
      <xsl:if test="//tei:divGen[@type='search']">
         <!-- v spodnjem js je shranjena vsebina za iskanje -->
         <script src="tipuesearch_content.js"></script>
         <xsl:choose>
            <xsl:when test="$languages-locale='true'">
               <xsl:choose>
                  <xsl:when test="$thisLanguage='sl' or $thisLanguage='slv'">
                     <script src="{concat($path-general,'themes/js/plugin/TipueSearch/6.1/tipuesearch_set-sl.js')}"></script>
                  </xsl:when>
                  <xsl:when test="$thisLanguage='en' or $thisLanguage='eng'">
                     <script src="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/tipuesearch_set.js')}"></script>
                  </xsl:when>
                  <xsl:when test="$thisLanguage='Cy-sr'">
                     <script src="{concat($path-general,'themes/js/plugin/TipueSearch/6.1/tipuesearch_set-Cy-sr.js')}"></script>
                  </xsl:when>
                  <!-- drugače je angleščina -->
                  <xsl:otherwise>
                     <script src="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/tipuesearch_set.js')}"></script>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <!-- drugače izbere glede na parameter documentationLanguage -->
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$documentationLanguage = 'en'">
                     <script src="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/tipuesearch_set.js')}"></script>
                  </xsl:when>
                  <!-- drugače je moj slovenski prevod -->
                  <xsl:otherwise>
                     <script src="{concat($path-general,'themes/js/plugin/TipueSearch/6.1/tipuesearch_set-sl.js')}"></script>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
         <script src="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/tipuesearch.min.js')}"></script>
      </xsl:if>
   </xsl:template>
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="bodyEndHook">
      <script src="{concat($path-general,'themes/foundation/6/js/vendor/what-input.js')}"></script>
      <script src="{concat($path-general,'themes/foundation/6/js/vendor/foundation.min.js')}"></script>
      <script src="{concat($path-general,'themes/foundation/6/js/app.js')}"></script>
      <!-- back-to-top -->
      <script src="{concat($path-general,'themes/js/plugin/back-to-top/back-to-top.js')}"></script>
   </xsl:template>
   
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc> naredi index.html datoteko </xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="pageLayoutSimple">
      <!-- če je locale, naredim index-jezikovna_koda.html še za ostale jezike (ki niso izhodični) -->
      <xsl:if test="$languages-locale='true'">
         <xsl:call-template name="pageLayoutSimple-locale"/>
      </xsl:if>
      <!-- vključimo HTML5 deklaracijo -->
      <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
      <html class="no-js">
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:sequence select="tei:generateTitle(.)"/>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 3)"/>
         <body class="simple" id="TOP">
            <xsl:copy-of select="tei:text/tei:body/@unload"/>
            <xsl:copy-of select="tei:text/tei:body/@onunload"/>
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook">
               <xsl:with-param name="thisLanguage" select="$languages-locale-primary"/>
            </xsl:call-template>
            <xsl:call-template name="bodyHook"/>
            <!-- začetek vsebine -->
            <div class="column row">
               <!-- vstavim svoj header -->
               <xsl:call-template name="html-header">
                  <xsl:with-param name="thisChapter-id">index</xsl:with-param>
                  <xsl:with-param name="thisLanguage" select="$languages-locale-primary"/>
               </xsl:call-template>
               <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
                  <div class="stdheader autogenerated">
                     <xsl:call-template name="stdheader">
                        <xsl:with-param name="title">
                           <xsl:sequence select="tei:generateTitle(.)"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </div>
               </xsl:if>
               <xsl:comment>TEI  front matter </xsl:comment>
               <xsl:apply-templates select="tei:text/tei:front"/>
               <!-- odstranim možnost izdelave kazala na takoj prvi strani -->
               <!--<xsl:if
                  test="$autoToc = 'true' and (descendant::tei:div or descendant::tei:div1) and not(descendant::tei:divGen[@type = 'toc'])">
                  <h2>
                     <xsl:sequence select="tei:i18n('tocWords')"/>
                  </h2>
                  <xsl:call-template name="mainTOC"/>
               </xsl:if>-->
               <xsl:choose>
                  <xsl:when test="tei:text/tei:group">
                     <xsl:apply-templates select="tei:text/tei:group"/>
                  </xsl:when>
                  <xsl:when test="tei:match(@rend, 'multicol')">
                     <table>
                        <tr>
                           <xsl:apply-templates select="tei:text/tei:body"/>
                        </tr>
                     </table>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:comment>TEI body matter </xsl:comment>
                     <xsl:call-template name="startHook"/>
                     <xsl:variable name="ident">
                        <xsl:apply-templates mode="ident" select="."/>
                     </xsl:variable>
                     <xsl:apply-templates select="tei:text/tei:body"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:comment>TEI back matter </xsl:comment>
               <xsl:apply-templates select="tei:text/tei:back"/>
               <xsl:call-template name="printNotes"/>
               <xsl:call-template name="htmlFileBottom"/>
               <xsl:call-template name="bodyEndHook"/>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Procesira index-jezikovna_koda.html strani</desc>
   </doc>
   <xsl:template name="pageLayoutSimple-locale">
      <xsl:variable name="outputDir-extra">
         <xsl:if test="ancestor-or-self::tei:TEI/@xml:id">
            <xsl:value-of select="concat(ancestor-or-self::tei:TEI/@xml:id,'/')"/>
         </xsl:if>
      </xsl:variable>
      <xsl:for-each-group select="//tei:div[@xml:id][@xml:lang != $languages-locale-primary]" group-by="@xml:lang">
         <xsl:result-document doctype-public="{$doctypePublic}" doctype-system="{$doctypeSystem}"
            encoding="{$outputEncoding}"
            href="{concat($outputDir,$outputDir-extra,'index-',current-grouping-key(),$outputSuffix)}"
            method="{$outputMethod}">
            <!-- Celotno spodnjo kodo večinoma kopiram iz pageLayoutSimple -->
            <!-- vključimo HTML5 deklaracijo -->
            <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
            <html class="no-js">
               <xsl:call-template name="addLangAtt"/>
               <xsl:variable name="pagetitle">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:variable>
               <xsl:sequence select="tei:htmlHead($pagetitle, 3)"/>
               <body class="simple" id="TOP">
                  <xsl:call-template name="bodyMicroData"/>
                  <xsl:call-template name="bodyJavascriptHook">
                     <xsl:with-param name="thisLanguage" select="current-grouping-key()"/>
                  </xsl:call-template>
                  <xsl:call-template name="bodyHook"/>
                  <!-- začetek vsebine -->
                  <div class="column row">
                     <!-- vstavim svoj header: so index.html variante jezikov, ki niso $languages-locale-primary -->
                     <xsl:call-template name="html-header">
                        <xsl:with-param name="thisChapter-id">
                           <xsl:value-of select="concat('index','-',current-grouping-key())"/>
                        </xsl:with-param>
                        <xsl:with-param name="thisLanguage" select="current-grouping-key()"/>
                     </xsl:call-template>
                     <!-- še enkrat generiram povsem isti naslov kot pri index.html -->
                     <xsl:apply-templates select="//tei:text/tei:front/tei:titlePage"/>
                     <xsl:call-template name="printNotes"/>
                     <xsl:call-template name="htmlFileBottom"/>
                     <xsl:call-template name="bodyEndHook"/>
                  </div>
               </body>
            </html>
         </xsl:result-document>
      </xsl:for-each-group>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>naredi strani z div</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="writeDiv">
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <!-- vključimo HTML5 deklaracijo, skupaj s kodo za delovanje starejših verzij Internet Explorerja -->
      <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
      <html>
         <xsl:call-template name="addLangAtt"/>
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
         <body id="TOP">
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook">
               <xsl:with-param name="thisLanguage" select="@xml:lang"/>
            </xsl:call-template>
            <xsl:call-template name="bodyHook"/>
            <!-- začetek vsebine -->
            <div class="column row">
               <!-- vstavim svoj header -->
               <xsl:call-template name="html-header">
                  <xsl:with-param name="thisChapter-id" select="@xml:id"/>
                  <xsl:with-param name="thisLanguage" select="@xml:lang"/>
               </xsl:call-template>
               <!-- GLAVNA VSEBINA -->
               <section>
                  <div class="row">
                     <div class="medium-2 columns show-for-medium">
                        <p>
                           <xsl:call-template name="previousLink"/>
                        </p>
                     </div>
                     <div class="medium-8 small-12 columns">
                        <xsl:call-template name="stdheader">
                           <xsl:with-param name="title">
                              <xsl:call-template name="header"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </div>
                     <div class="medium-2 columns show-for-medium text-right">
                        <p>
                           <xsl:if test="parent::tei:div">
                              <xsl:call-template name="parentChapter"/>
                           </xsl:if>
                           <xsl:call-template name="nextLink"/>
                        </p>
                     </div>
                  </div>
                  <div class="row hide-for-medium">
                     <div class="small-6 columns text-center">
                        <p>
                           <xsl:call-template name="previousLink"/>
                        </p>
                     </div>
                     <div class="small-6 columns text-center">
                        <p>
                           <xsl:if test="parent::tei:div">
                              <xsl:call-template name="parentChapter"/>
                           </xsl:if>
                           <xsl:call-template name="nextLink"/>
                        </p>
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
                  <xsl:call-template name="makeDivBody">
                     <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                  </xsl:call-template>
                  <!-- če je part (in ima zato samo naslov), se doda kazalo vsebine -->
                  <xsl:if test="$autoToc = 'true' and self::tei:div[@type='part']">
                     <!-- kličem template partTOC, katerega prisilim, da gre samo eno stopnjo v globino -->
                     <xsl:call-template name="partTOC">
                        <xsl:with-param name="force">1</xsl:with-param>
                     </xsl:call-template>
               </xsl:if>
                  <xsl:variable name="exist-note">
                     <xsl:call-template name="printNotes"/>
                  </xsl:variable>
                  <!-- .//tei:note -->
                  <xsl:if test="string-length($exist-note) gt 0">
                     <div class="row">
                        <div class="small-6 columns text-center">
                           <p>
                              <xsl:call-template name="previousLink"/>
                           </p>
                        </div>
                        <div class="small-6 columns text-center">
                           <p>
                              <xsl:call-template name="nextLink"/>
                           </p>
                        </div>
                     </div>
                  </xsl:if>
                  <xsl:call-template name="printNotes"/>
                  <div class="row">
                     <div class="small-6 columns text-center">
                        <p>
                           <xsl:call-template name="previousLink"/>
                        </p>
                     </div>
                     <div class="small-6 columns text-center">
                        <p>
                           <xsl:call-template name="nextLink"/>
                        </p>
                     </div>
                  </div>
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
            </div><!-- konec vsebine row column -->
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="title"/>
   </xsldoc:doc>
   <xsl:template name="stdheader">
      <xsl:param name="title">(no title)</xsl:param>
      <xsl:choose>
         <xsl:when test="$pageLayout = 'Simple'">
            <xsl:if test="not($institution = '')">
               <h2 class="institution">
                  <xsl:value-of select="$institution"/>
               </h2>
            </xsl:if>
            <xsl:if test="not($department = '')">
               <h2 class="department">
                  <xsl:value-of select="$department"/>
               </h2>
            </xsl:if>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:copy-of select="$title"/>
               </xsl:with-param>
               <!-- spremenim vrednost param level iz 1 v 2, zaradi česar je prvi hn v body vedno h2 
                  (nato sledijo h3 itn. - glej zgoraj param divoffset) -->
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateSubTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="makeHTMLHeading">
                  <xsl:with-param name="class">subtitle</xsl:with-param>
                  <xsl:with-param name="text">
                     <xsl:call-template name="generateAuthorList"/>
                     <xsl:sequence select="tei:generateDate(.)"/>
                     <xsl:sequence select="tei:generateEdition(.)"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:value-of select="$title"/>
               </xsl:with-param>
               <xsl:with-param name="level">1</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="generateAuthorList"/>
               <xsl:sequence select="tei:generateDate(.)"/>
               <xsl:sequence select="tei:generateEdition(.)"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template match="tei:*" mode="generateNextLink">
      <a class="button">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:sequence select="tei:i18n('nextWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="headerLink">
               <xsl:with-param name="minimal" select="$minimalCrossRef"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:text>&gt;&gt;</xsl:text>    
      </a>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template match="tei:*" mode="generatePreviousLink">
      <a class="button">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:sequence select="tei:i18n('previousWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="headerLink">
               <xsl:with-param name="minimal" select="$minimalCrossRef"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:text>&lt;&lt;</xsl:text>    
      </a>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="parentChapter">
      <a class="button">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="parent::tei:div"/>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:sequence select="tei:i18n('upWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:variable name="chaptersHead">
               <xsl:apply-templates select="parent::tei:div/tei:head" mode="chapters-head"/>
            </xsl:variable>
            <xsl:value-of select="normalize-space($chaptersHead)"/>
         </xsl:attribute>
         <xsl:text>^</xsl:text>    
      </a>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] </p>
         <p xmlns="http://www.w3.org/1999/xhtml"> xref to previous and last sections </p>
      </desc>
   </doc>
   <xsl:template name="nextLink">
      <xsl:variable name="myName">
         <xsl:value-of select="local-name(.)"/>
      </xsl:variable>
      <!-- če je language-locale true, potem je premikanje naprej samo na div z istim jezikom -->
      <xsl:variable name="language-div" select="self::tei:div/@xml:lang"/>
      <xsl:choose>
         <xsl:when test="$languages-locale='true'">
            <xsl:choose>
               <xsl:when test="following-sibling::tei:TEI">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:TEI[1]"/>
               </xsl:when>
               <xsl:when test="following-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
               <!-- dodam spodnja dva when, da omogočim povezave med poglavji tudi takrat, kadar so globje kot 
                    npr. tei:body/tei:div (urejeno do splitLevel 2) -->
               <xsl:when test="not(following-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']) and parent::tei:div/following-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="parent::tei:div/following-sibling::tei:div[@xml:lang=$language-div][1]/tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
               <xsl:when test="not(following-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']) 
                  and not(parent::tei:div/following-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true'])
                  and parent::tei:div/parent::tei:div/following-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="parent::tei:div/parent::tei:div/following-sibling::tei:div[@xml:lang=$language-div][1]/tei:div[@xml:lang=$language-div][1]/tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
               
               <xsl:when test="parent::tei:body/following-sibling::tei:back/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink"
                     select="parent::tei:body/following-sibling::tei:back/tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
               <xsl:when test="parent::tei:front/following-sibling::tei:body/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink"
                     select="parent::tei:front/following-sibling::tei:body/tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="following-sibling::tei:TEI">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:TEI[1]"/>
               </xsl:when>
               <xsl:when test="following-sibling::tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div[1]"/>
               </xsl:when>
               <!-- dodam spodnja dva when, da omogočim povezave med poglavji tudi takrat, kadar so globje kot 
                    npr. tei:body/tei:div (urejeno do splitLevel 2) -->
               <xsl:when test="not(following-sibling::tei:div[tei:head or $autoHead='true']) and parent::tei:div/following-sibling::tei:div/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="parent::tei:div/following-sibling::tei:div[1]/tei:div[1]"/>
               </xsl:when>
               <xsl:when test="not(following-sibling::tei:div[tei:head or $autoHead='true']) 
                  and not(parent::tei:div/following-sibling::tei:div/tei:div[tei:head or $autoHead='true'])
                  and parent::tei:div/parent::tei:div/following-sibling::tei:div/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="parent::tei:div/parent::tei:div/following-sibling::tei:div[1]/tei:div[1]/tei:div[1]"/>
               </xsl:when>
               
               <xsl:when test="parent::tei:body/following-sibling::tei:back/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink"
                     select="parent::tei:body/following-sibling::tei:back/tei:div[1]"/>
               </xsl:when>
               <xsl:when test="parent::tei:front/following-sibling::tei:body/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink"
                     select="parent::tei:front/following-sibling::tei:body/tei:div[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div1' and following-sibling::tei:div1[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div1[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div2' and following-sibling::tei:div2[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div2[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div3' and following-sibling::tei:div3[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div3[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div4' and following-sibling::tei:div4[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div4[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div5' and following-sibling::tei:div5[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div5[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div6' and following-sibling::tei:div6[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div6[1]"/>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="previousLink">
      <xsl:variable name="myName">
         <xsl:value-of select="local-name(.)"/>
      </xsl:variable>
      <!-- če je language-locale true, potem je premikanje nazaj samo na div z istim jezikom -->
      <xsl:variable name="language-div" select="self::tei:div/@xml:lang"/>
      <xsl:choose>
         <xsl:when test="$languages-locale='true'">
            <xsl:choose>
               <xsl:when test="preceding-sibling::tei:TEI">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:TEI[1]"/>
               </xsl:when>
               <xsl:when test="preceding-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div[@xml:lang=$language-div][1]"/>
               </xsl:when>
               <!-- dodam spodnja when, da omogočim povezave med poglavji tudi takrat, kadar so globje kot 
                    npr. tei:body/tei:div (urejeno do splitLevel 2) -->
               <xsl:when test="not(preceding-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']) and parent::tei:div/preceding-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="parent::tei:div/preceding-sibling::tei:div[@xml:lang=$language-div][1]/tei:div[@xml:lang=$language-div][last()]"/>
               </xsl:when>
               <xsl:when test="not(preceding-sibling::tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']) 
                  and not(parent::tei:div/preceding-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true'])
                  and parent::tei:div/parent::tei:div/preceding-sibling::tei:div[@xml:lang=$language-div]/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="parent::tei:div/parent::tei:div/preceding-sibling::tei:div[@xml:lang=$language-div][1]/tei:div[@xml:lang=$language-div][last()]/tei:div[@xml:lang=$language-div][last()]"/>
               </xsl:when>
               
               <xsl:when test="parent::tei:body/preceding-sibling::tei:front/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink"
                     select="parent::tei:body/preceding-sibling::tei:front/tei:div[@xml:lang=$language-div][last()]"/>
               </xsl:when>
               <xsl:when test="parent::tei:back/preceding-sibling::tei:body/tei:div[@xml:lang=$language-div][tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink"
                     select="parent::tei:body/preceding-sibling::tei:body/tei:div[@xml:lang=$language-div][last()]"/>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="preceding-sibling::tei:TEI">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:TEI[1]"/>
               </xsl:when>
               <xsl:when test="preceding-sibling::tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div[1]"/>
               </xsl:when>
               <!-- dodam spodnja when, da omogočim povezave med poglavji tudi takrat, kadar so globje kot 
            npr. tei:body/tei:div (urejeno do splitLevel 2) -->
               <xsl:when test="not(preceding-sibling::tei:div[tei:head or $autoHead='true']) and parent::tei:div/preceding-sibling::tei:div/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="parent::tei:div/preceding-sibling::tei:div[1]/tei:div[last()]"/>
               </xsl:when>
               <xsl:when test="not(preceding-sibling::tei:div[tei:head or $autoHead='true']) 
                  and not(parent::tei:div/preceding-sibling::tei:div/tei:div[tei:head or $autoHead='true'])
                  and parent::tei:div/parent::tei:div/preceding-sibling::tei:div/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="parent::tei:div/parent::tei:div/preceding-sibling::tei:div[1]/tei:div[last()]/tei:div[last()]"/>
               </xsl:when>
               
               <xsl:when test="parent::tei:body/preceding-sibling::tei:front/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink"
                     select="parent::tei:body/preceding-sibling::tei:front/tei:div[last()]"/>
               </xsl:when>
               <xsl:when test="parent::tei:back/preceding-sibling::tei:body/tei:div[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink"
                     select="parent::tei:body/preceding-sibling::tei:body/tei:div[last()]"/>
               </xsl:when>
               <xsl:when test="$myName='div1' and preceding-sibling::tei:div1[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div1[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div2' and preceding-sibling::tei:div2[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div2[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div3' and preceding-sibling::tei:div3[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div3[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div4' and preceding-sibling::tei:div4[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div4[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div5' and preceding-sibling::tei:div5[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div5[1]"/>
               </xsl:when>
               <xsl:when test="$myName='div6' and preceding-sibling::tei:div6[tei:head or $autoHead='true']">
                  <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div6[1]"/>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="chapterID"/>
   </xsldoc:doc>
   <xsl:template name="sistoryPath">
      <xsl:param name="chapterID"/>
      <xsl:variable name="sistoryID">
         <xsl:call-template name="sistoryID">
            <xsl:with-param name="chapterID" select="$chapterID"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($sistoryID) gt 0">
         <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($sistoryID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($sistoryID)) div 1000) * 1000) + 1000,'/',$sistoryID,'/')"/>
      </xsl:if>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="chapterID"/>
   </xsldoc:doc>
   <xsl:template name="sistoryID">
      <xsl:param name="chapterID"/>
      <xsl:variable name="sistoryIDs">
         <xsl:for-each select="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
            <xsl:variable name="sistory" select="."/>
            <xsl:variable name="corresp" select="@corresp"/>
            <xsl:for-each select="tokenize($corresp,' ')">
               <corresp sistoryID="{$sistory}">
                  <xsl:value-of select="substring-after(.,'#')"/>
               </corresp>
            </xsl:for-each>
         </xsl:for-each>
         <xsl:for-each select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
            <xsl:variable name="sistory" select="."/>
            <xsl:variable name="corresp" select="@corresp"/>
            <xsl:for-each select="tokenize($corresp,' ')">
               <corresp sistoryID="{$sistory}">
                  <xsl:value-of select="substring-after(.,'#')"/>
               </corresp>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="$sistoryIDs/html:corresp[. = $chapterID]">
         <xsl:value-of select="@sistoryID"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template match="*" mode="generateLink">
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>
      <xsl:variable name="depth">
         <xsl:apply-templates mode="depth" select="."/>
      </xsl:variable>
      <xsl:variable name="keep" select="tei:keepDivOnPage(.)"/>
      <xsl:variable name="LINK">
         <xsl:choose>
            <xsl:when test="$filePerPage='true'">
               <xsl:choose>
                  <xsl:when test="preceding::tei:pb">
                     <xsl:apply-templates select="preceding::tei:pb[1]"
                        mode="ident"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>index</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:value-of select="$standardSuffix"/>
            </xsl:when>
            <xsl:when test="ancestor::tei:elementSpec and not($STDOUT='true')">
               <xsl:sequence select="concat('ref-',ancestor::tei:elementSpec/@ident,$standardSuffix,'#',$ident)"/>
            </xsl:when>
            <xsl:when test="ancestor::tei:classSpec and not($STDOUT='true')">
               <xsl:sequence select="concat('ref-',ancestor::tei:classSpec/@ident,$standardSuffix,'#',$ident)"/>
            </xsl:when>
            <xsl:when test="not ($STDOUT='true') and ancestor::tei:back and not($splitBackmatter='true')">
               <xsl:value-of select="concat($masterFile,$standardSuffix,'#',$ident)"/>
            </xsl:when>
            <xsl:when test="not($STDOUT='true') and ancestor::tei:front
               and not($splitFrontmatter='true')">
               <xsl:value-of select="concat($masterFile,$standardSuffix,'#',$ident)"/>
            </xsl:when>
            <xsl:when test="not($keep) and $STDOUT='true' and
               number($depth) &lt;= number($splitLevel)">
               <xsl:sequence select="concat($masterFile,$standardSuffix,$urlChunkPrefix,$ident)"/>
            </xsl:when>
            <xsl:when test="self::tei:text and $splitLevel=0">
               <xsl:value-of select="concat($ident,$standardSuffix)"/>
            </xsl:when>
            <xsl:when test="number($splitLevel)= -1 and
               ancestor::tei:teiCorpus">
               <xsl:value-of select="$masterFile"/>
               <xsl:call-template name="addCorpusID"/>
               <xsl:value-of select="$standardSuffix"/>
               <xsl:value-of select="concat('#',$ident)"/>
            </xsl:when>
            <xsl:when test="number($splitLevel)= -1">
               <xsl:value-of select="concat('#',$ident)"/>
            </xsl:when>
            <xsl:when test="number($depth) &lt;= number($splitLevel) and not($keep)">
               <!-- dodana relativna pot v okviru SIstory -->
               <xsl:variable name="sistoryPath">
                  <xsl:if test="$chapterAsSIstoryPublications='true'">
                     <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="$ident"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:variable>
               <xsl:value-of select="concat($sistoryPath,$ident,$standardSuffix)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="parent">
                  <xsl:call-template name="locateParentDiv"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$STDOUT='true'">
                     <xsl:sequence select="concat($masterFile,$urlChunkPrefix,$parent,'#',$ident)"/>
                  </xsl:when>
                  <xsl:when test="ancestor::tei:group">
                     <xsl:sequence select="concat($parent,$standardSuffix,'#',$ident)"/>
                  </xsl:when>
                  <xsl:when test="ancestor::tei:floatingText">
                     <xsl:sequence select="concat($parent,$standardSuffix,'#',$ident)"/>
                  </xsl:when>
                  <xsl:when test="$keep and number($depth=0)">
                     <xsl:sequence select="concat('#',$ident)"/>
                  </xsl:when>
                  <xsl:when test="$keep">
                     <xsl:sequence select="concat($masterFile,$standardSuffix,'#',$ident)"/>
                  </xsl:when>
                  <xsl:when test="ancestor::tei:div and tei:keepDivOnPage(ancestor::tei:div[last()])">
                     <xsl:sequence select="concat('#',$ident)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- dodana relativna pot v okviru SIstory -->
                     <xsl:variable name="sistoryPath">
                        <xsl:if test="$chapterAsSIstoryPublications='true'">
                           <xsl:call-template name="sistoryPath">
                              <xsl:with-param name="chapterID" select="$parent"/>
                           </xsl:call-template>
                        </xsl:if>
                     </xsl:variable>
                     <xsl:sequence select="concat($sistoryPath,$parent,$standardSuffix,'#',$ident)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--
      <xsl:message>GENERATELINK <xsl:value-of
      select="(name(),$ident,$depth,string($keep),$LINK)"
	  separator="|"/></xsl:message>
      -->
      <xsl:value-of select="$LINK"/>
   </xsl:template>
   
</xsl:stylesheet>
