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

   <xsl:import href="../SIstory/to.xsl"/>
   
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
   
   <!--<xsl:param name="chapterAsSIstoryPublications">true</xsl:param>-->
   
   <!-- Uredi parametre v skladu z dodatnimi zahtevami za pretvorbo te publikacije: -->
   
   <xsl:param name="localWebsite">true</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">false</xsl:param>
   
   <!--<xsl:param name="path-general">../../../</xsl:param>-->
   <!--<xsl:param name="path-general">http://www2.sistory.si/publikacije/</xsl:param>-->
   <!-- v primeru localWebsite='true' spodnji paragraf nima vrednosti -->
   <xsl:param name="path-general"></xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/to.xsl -->
   <xsl:param name="outputDir"></xsl:param>
   
   <xsl:param name="splitLevel">1</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="homeLabel">SIstory</xsl:param>
   <xsl:param name="homeURL">http://www.sistory.si/11686/38085</xsl:param>
   
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description">Pregled objavljenih raziskovalnih podatkov Slovenskega parlamentarnega korpusa</xsl:param>
   <xsl:param name="keywords">Slovenija, parlament, skupščina</xsl:param>
   <xsl:param name="title">Slovenski parlamentarni korpus: Pregled objavljenih raziskovalnih podatkov</xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>V body/div procesiram sezname parlamentarnih govorov</desc>
   </doc>
   <xsl:template match="tei:listBibl">
      <xsl:call-template name="datatable"/>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Podatke iz listBibl procesiram v datatable</desc>
   </doc>
   <xsl:template name="datatable">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables/datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables/range-filter-external.js' else 'http://www2.sistory.si/publikacije/themes/js/plugin/DataTables/range-filter-external.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'datatables/responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'datatables/buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         <xsl:choose>
            <xsl:when test="ancestor::tei:div[@xml:id='SDZ']">var columnIDs = [1, 2, 4, 5];</xsl:when>
            <xsl:otherwise>var columnIDs = [1, 2, 3, 5, 6];</xsl:otherwise>
         </xsl:choose>
      </script>
      
      <div>
         <ul class="accordion" data-accordion="" data-allow-all-closed="true">
            <li class="accordion-item" data-accordion-item="">
               <a href="#" class="accordion-title">Filtriraj po datumu seje / zasedanja</a>
               <div class="accordion-content rangeFilterWrapper" data-target="4" data-tab-content="">
                  <div class="row">
                     <div class="small-3 columns">
                        <label for="middle-label" class="text-right middle">Filtriraj od datuma</label>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMinDay" maxlength="2" placeholder="Dan"/>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMinMonth" maxlength="2" placeholder="Mesec"/>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMinYear" maxlength="4" placeholder="Leto"/>
                     </div>
                  </div>
                  <div class="row">
                     <div class="small-3 columns">
                        <label for="middle-label" class="text-right middle">do datuma</label>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMaxDay" maxlength="2" placeholder="Dan"/>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMaxMonth" maxlength="2" placeholder="Mesec"/>
                     </div>
                     <div class="small-3 columns">
                        <input type="text" class="rangeMaxYear" maxlength="4" placeholder="Leto"/>
                     </div>
                     <div class="small-12 columns" style="text-align: right;">
                        <a class="clearRangeFilter" href="#">Počisti filter</a>
                     </div>
                  </div>
               </div>
            </li>
         </ul>
         
         <table id="datatablePersons" class="display responsive nowrap targetTable" data-order="[[ { if (ancestor::tei:div[@xml:id='SDZ']) then 2 else 3}, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Povezava</th>
                  
                  <xsl:if test="ancestor::tei:div[@xml:id='SSK']">
                     <th>Zbor</th>
                  </xsl:if>
                  <xsl:if test="ancestor::tei:div[@xml:id='SDT']">
                     <th>Telo</th>
                  </xsl:if>
                  
                  <th>Vrsta seje</th>
                  <th>Št. seje</th>
                  <th>Dan</th>
                  <th>Govori</th>
                  <th>Besede</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <xsl:if test="ancestor::tei:div[@xml:id='SSK' or @xml:id='SDT']">
                     <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  </xsl:if>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="tei:biblStruct">
                  <xsl:choose>
                     <xsl:when test="tei:monogr/tei:title/@type = 'workingBody-session-date'">
                        <xsl:for-each select="tei:monogr/tei:title[@type = 'workingBody-session-date']">
                           <xsl:variable name="working-body" select="tokenize(normalize-space(.),':')[1]"/>
                           <xsl:variable name="session" select="normalize-space(substring-before(tokenize(normalize-space(.),':')[2],'('))"/>
                           <xsl:variable name="date" select="substring-before(substring-after(normalize-space(.),'('),')')"/>
                           <tr>
                              <!-- Povezave -->
                              <td>
                                 <a href="{concat('http://exist.sistory.si/exist/apps/parla/',ancestor::tei:biblStruct/tei:ref)}" title="eXist-db app" target="_blank">parla</a>
                              </td>
                              
                              <!-- delovna telesa -->
                              <td>
                                 <xsl:value-of select="$working-body"/>
                              </td>
                                 
                              <!-- Vrsta seje -->
                              <td>
                                 <xsl:value-of select="normalize-space(tokenize($session,'\.\s')[2])"/>
                              </td>
                              <!-- št. seje -->
                              <td>
                                 <xsl:value-of select="normalize-space(tokenize($session,'\.\s')[1])"/>
                              </td>
                              <!-- dan -->
                              <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date[. = $date]">
                                 <td data-search="{@when}">
                                    <xsl:attribute name="data-order">
                                       <xsl:for-each select="./@when">
                                          <xsl:call-template name="sort-date"/>
                                       </xsl:for-each>
                                    </xsl:attribute>
                                    <xsl:value-of select="."/>
                                 </td>
                              </xsl:for-each>
                              <!-- govori -->
                              <td>
                                 <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='sp']"/>
                              </td>
                              <!-- besede -->
                              <td>
                                 <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='w']"/>
                              </td>
                           </tr>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <tr>
                           <!-- Povezave -->
                           <td>
                              <a href="{concat('http://exist.sistory.si/exist/apps/parla/',tei:ref)}" title="eXist-db app" target="_blank">parla</a>
                           </td>
                           
                           <!-- Zbori -->
                           <xsl:if test="ancestor::tei:div[@xml:id='SSK']">
                              <td>
                                 <xsl:choose>
                                    <xsl:when test="tei:monogr/tei:title[@type='chamber'] = 'Vsi zbori zasedajo skupaj'">vsi zbori</xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="tei:monogr/tei:title[@type='chamber']"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </td>
                           </xsl:if>
                           <!-- delovna telesa -->
                           <xsl:if test="ancestor::tei:div[@xml:id='SDT']">
                              <td>
                                 <xsl:value-of select="tei:monogr/tei:title[@type='workingBody' or @type = 'KPDZ']"/>
                              </td>
                           </xsl:if>
                           
                           <!-- Vrsta seje -->
                           <td>
                              <xsl:value-of select="normalize-space(tokenize(tei:monogr/tei:title[@type='session'],'\.\s')[2])"/>
                           </td>
                           <!-- št. seje -->
                           <td>
                              <xsl:value-of select="normalize-space(tokenize(tei:monogr/tei:title[@type='session'],'\.\s')[1])"/>
                           </td>
                           <!-- dan -->
                           <td data-search="{tei:monogr/tei:imprint/tei:date/@when}">
                              <xsl:attribute name="data-order">
                                 <xsl:for-each select="tei:monogr/tei:imprint/tei:date/@when">
                                    <xsl:call-template name="sort-date"/>
                                 </xsl:for-each>
                              </xsl:attribute>
                              <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
                           </td>
                           <!-- govori -->
                           <td>
                              <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='sp']"/>
                           </td>
                           <!-- besede -->
                           <td>
                              <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='w']"/>
                           </td>
                        </tr>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
            </tbody>
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="sort-date">
      <xsl:choose>
         <!-- samo letnica -->
         <xsl:when test="not(contains(.,'-'))">
            <xsl:value-of select="concat(.,'0000')"/>
         </xsl:when>
         <!-- celoten datum -->
         <xsl:when test="matches(.,'\d{4}-\d{2}-\d{2}')">
            <xsl:value-of select="translate(.,'-','')"/>
         </xsl:when>
         <!-- drugače je samo mesec -->
         <xsl:otherwise>
            <xsl:value-of select="concat(translate(.,'-',''),'00')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Ker je pri body poglavjih samo eden div z vsebino, poenostavim prvotni template</desc>
      <param name="thisLanguage"></param>
   </doc>
   <xsl:template name="nav-body-head">
      <xsl:param name="thisLanguage"/>
      <xsl:text>Pregled objav</xsl:text>
   </xsl:template>
   
</xsl:stylesheet>
