<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <xsl:template name="correspBiblID">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <xsl:value-of select="@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="numLevel">
                    <xsl:number count="tei:bibl[@corresp]" level="any"/>
                </xsl:variable>
                <xsl:variable name="numBibl">
                    <xsl:number value="$numLevel"/>
                </xsl:variable>
                <xsl:value-of select="concat('bibl-',$numBibl)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:listBibl">
        <xsl:if test="tei:head">
            <p><xsl:value-of select="tei:head"/>:</p>
        </xsl:if>
        <xsl:choose>
            <!-- neoštevilčen seznam -->
            <xsl:when test=".[@type='bulleted'] or .[@type='unordered'] or .[@rend='bulleted'] or .[@rend='unordered']">
                <ul class="disc">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
            <!-- oštevilčen seznam -->
            <xsl:when test=".[@type='ordered'] or .[@rend='ordered']">
                <ol>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </ol>
            </xsl:when>
            <!-- Če atribut type ni vpisan (oziroma, ni nobenega od zgoraj naštetih), dobi avtomatično krogec. -->
            <xsl:otherwise>
                <ul class="circle">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis navedene bibliografije -->
    <xsl:template match="tei:biblStruct">
        <xsl:choose>
            <!-- v seznamu literature navedena bibliografija -->
            <xsl:when test="parent::tei:listBibl">
                <!-- anchor oziroma atribut id obvezen, da se lahko na njih sklicuje iz literature v opombah.
                     Sklicujemo pa se lahko samo v primeru, če že prej obstaja povezava,
                     zato imajo biblStruct v teh primerih vedno xml:id -->
                <!-- Vsaka bibliografska enota obvezno dobi anchor, da se lahko na
                     njega sklicujemo iz literature v opombah.
                     Nujno je potreben pri iskalniku -->
                <li itemscope="">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!-- Ločim, če je schema.org članek ali knjiga. PREVERI ŠE DRUGE MOŽNOSTI! -->
                    <xsl:choose>
                        <xsl:when test="tei:analytic">
                            <xsl:attribute name="itemtype">
                                <xsl:text>https://schema.org/Article</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="itemtype">
                                <xsl:text>http://schema.org/Book</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- procesiranje bibliografskih podatkov -->
                    <xsl:choose>
                        <!-- za članke -->
                        <xsl:when test="tei:analytic">
                            <xsl:apply-templates select="tei:analytic"/>
                            <xsl:apply-templates select="tei:monogr" mode="clanek"/>
                        </xsl:when>
                        <!-- za monografije -->
                        <xsl:otherwise>
                            <xsl:apply-templates select="tei:monogr" mode="monografija"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- na koncu damo piko -->
                    <xsl:text>.</xsl:text>
                    <!-- Za stavkom še morebitne povezave na cobiss, sistory, dLib ipd. (morajo imeti stabilne URL) -->
                    <xsl:apply-templates select="tei:idno[@type='sistory']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='cobiss']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='dLib']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='WorldCat']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='ISBN']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='ISSN']" mode="bibliografija"/>
                    <xsl:apply-templates select="tei:idno[@type='doi']" mode="bibliografija"/>
                    <!-- seznam citiranih bibliografij - povezava na opombo, v okviru katere je delo citirano -->
                    <xsl:call-template name="biblCitedIn"/>
                </li>
            </xsl:when>
            <!-- za literaturo navedeno drugje, npr. v opombah -->
            <!-- TRENUTNO TEGA NE UPORABLJAM V TEI DOKUMENTIH -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- za članke -->
                    <xsl:when test="tei:analytic">
                        <xsl:apply-templates select="tei:analytic"/>
                        <xsl:apply-templates select="tei:monogr" mode="clanek"/>
                    </xsl:when>
                    <!-- za monografije -->
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:monogr" mode="monografija"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='sistory']" mode="bibliografija">
        <xsl:text> [SIstory </xsl:text>
        <a target="_blank">
            <xsl:attribute name="href">
                <xsl:value-of select="concat('http://www.sistory.si/SISTORY:ID:',.)"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='cobiss']" mode="bibliografija">
        <xsl:text> [COBISS.SI-ID </xsl:text>
        <a target="_blank">
            <xsl:attribute name="href">
                <xsl:value-of select="concat('http://cobiss5.izum.si/scripts/cobiss?command=DISPLAY&amp;base=COBIB&amp;rid=',.)"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='dLib']" mode="bibliografija">
        <xsl:text> [dLib </xsl:text>
        <a target="_blank">
            <xsl:attribute name="href">
                <xsl:value-of select="concat('http://www.dlib.si/details/',.)"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='WorldCat']" mode="bibliografija">
        <xsl:text> [WorldCat </xsl:text>
        <a target="_blank">
            <xsl:attribute name="href">
                <xsl:value-of select="concat('http://www.worldcat.org/oclc/',.)"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='ISBN']" mode="bibliografija">
        <xsl:text> [ISBN </xsl:text>
        <span itemprop="isbn">
            <xsl:value-of select="."/>
        </span>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='ISSN']" mode="bibliografija">
        <xsl:text> [ISSN </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='doi']" mode="bibliografija">
        <xsl:text> [doi </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:analytic">
        <xsl:choose>
            <xsl:when test="ancestor::tei:listBibl">
                <xsl:choose>
                    <xsl:when test="tei:author/tei:surname or tei:author/tei:forename">
                        <xsl:apply-templates select="tei:author" mode="priimekBold-ime"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:author"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="tei:author/tei:surname or tei:author/tei:forename">
                        <xsl:apply-templates select="tei:author" mode="ime-priimek"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:author"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <span itemprop="name">
            <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:monogr" mode="clanek">
        <xsl:choose>
            <!-- Ker internetne vire vedno zapisujem kot posamezne članke
                 (konkreten članek oz. spletna stran) večjih monografski enot (širše spletne strani),
                 jim vedno damo atribut type z vrednostjo www.
            -->
            <xsl:when test="parent::tei:biblStruct[@type='www']">
                <xsl:text>Dostopno na: </xsl:text>
            </xsl:when>
            <!-- Za prvotno analogne publikacije -->
            <xsl:otherwise>
                <xsl:text>V: </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="tei:editor/tei:surname or tei:editor/tei:forename">
                <xsl:apply-templates select="tei:editor" mode="ime-priimek"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:editor"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="ancestor::tei:listBibl">
                <span itemprop="name">
                    <xsl:apply-templates select="tei:title" mode="naslov-podnaslov-italic"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span itemprop="name">
                    <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select=" ancestor::tei:biblStruct/tei:series"/>
        <xsl:apply-templates select="tei:meeting"/>
        <xsl:apply-templates select="tei:imprint"/>
    </xsl:template>
    
    <xsl:template match="tei:monogr" mode="monografija">
        <xsl:choose>
            <xsl:when test="ancestor::tei:listBibl">
                <xsl:choose>
                    <xsl:when test="tei:author/tei:surname or tei:author/tei:forename">
                        <xsl:apply-templates select="tei:author" mode="priimekBold-ime"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:author"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="tei:author/tei:surname or tei:author/tei:forename">
                        <xsl:apply-templates select="tei:author" mode="ime-priimek"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:author"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="tei:editor/tei:surname or tei:editor/tei:forename">
                <xsl:apply-templates select="tei:editor" mode="priimekBold-ime"/>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:editor"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="ancestor::tei:listBibl">
                <span itemprop="name">
                    <xsl:apply-templates select="tei:title" mode="naslov-podnaslov-italic"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span itemprop="name">
                    <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="ancestor::tei:biblStruct/tei:series"/>
        <xsl:apply-templates select="tei:meeting"/>
        <xsl:apply-templates select="tei:imprint"/>
    </xsl:template>
    
    <xsl:template match="tei:author">
        <span itemprop="author">
            <xsl:value-of select="."/>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Najprej izpiše imena avtorja, potem priimke avtorja, med seboj ločeno samo s presledkom.
         Med seboj so avtorji ločeni z vejico. Zadnjega avtorja od naslova ločuje dvopičje.-->
    <xsl:template match="tei:author" mode="ime-priimek">
        <span itemprop="author">
            <xsl:for-each select="tei:forename">
                <xsl:choose>
                    <!-- Če so pri imenih samo inicialke -->
                    <xsl:when test="@full='init'">
                        <xsl:value-of select="concat(.,'.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
            <xsl:for-each select="tei:surname">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Najprej izpiše poudarjen priimek avtorja, potem sledi vejica, nato ime avtorja.
         Med seboj so avtorji ločeni z vejico. Zadnjega avtorja od naslova ločuje dvopičje.-->
    <xsl:template match="tei:author" mode="priimekBold-ime">
        <span itemprop="author">
            <xsl:for-each select="tei:surname">
                <b><xsl:value-of select="."/></b>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:if test="parent::tei:author/tei:forename">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="tei:forename">
                <xsl:choose>
                    <!-- Če so pri imenih samo inicialke -->
                    <xsl:when test="@full='init'">
                        <xsl:value-of select="concat(.,'.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="position() eq last()-1">
                <xsl:text> in </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:editor">
        <span itemprop="editor">
            <xsl:value-of select="."/>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text> (ur.): </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Najprej izpiše imena urednika, potem priimke urednika, med seboj ločeno samo s presledkom.
         Med seboj so uredniki ločeni z vejico.
         Zadnjega urednika od naslova ločuje oznaka (.ur) in dvopičje.-->
    <xsl:template match="tei:editor" mode="ime-priimek">
        <span itemprop="editor">
            <xsl:for-each select="tei:forename">
                <xsl:choose>
                    <!-- Če so pri imenih samo inicialke -->
                    <xsl:when test="@full='init'">
                        <xsl:value-of select="concat(.,'.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
            <xsl:for-each select="tei:surname">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text> (ur.): </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Najprej izpiše poudarjen priimek avtorja, potem sledi vejica, nato ime avtorja.
         Med seboj so avtorji ločeni z vejico. Zadnjega avtorja od naslova ločuje dvopičje.-->
    <xsl:template match="tei:editor" mode="priimekBold-ime">
        <span itemprop="editor">
            <xsl:for-each select="tei:surname">
                <b><xsl:value-of select="."/></b>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:if test="parent::tei:editor/tei:forename">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="tei:forename">
                <xsl:choose>
                    <!-- Če so pri imenih samo inicialke -->
                    <xsl:when test="@full='init'">
                        <xsl:value-of select="concat(.,'.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>, </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </span>
        <xsl:choose>
            <xsl:when test="position() eq last()">
                <xsl:text> (ur.): </xsl:text>
            </xsl:when>
            <xsl:when test="position() eq last()-1">
                <xsl:text> in </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- naslov zbirke še MANJKA - najprej premisli, kako in kam ni zapisal naslov zbirke (npr. za naslovom dela, ali pred, ali v oklepaju ???????? -->
    <!-- Začasno urejeno tako, da je naslov zbirke za naslovom dela v oklepaju -->
    <xsl:template match="tei:series">
        <xsl:choose>
            <xsl:when test="ancestor::tei:biblStruct/tei:monogr/tei:title">
                <xsl:value-of select="concat('(',normalize-space(tei:title),'). ')"/>
            </xsl:when>
            <!-- Če pa je naslov zbirke edini naslov, se ga izpiše namesto naslova -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::tei:listBibl">
                        <xsl:apply-templates select="tei:title" mode="naslov-podnaslov-italic"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Naslovi in podnaslovi si sledijo med seboj ločeni z vejico, za zadnjim je pika (če pa mu sledi še naslov zbirke, pa vejica). -->
    <xsl:template match="tei:title" mode="naslov-podnaslov">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test=".[1] and following-sibling::tei:title">
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="position() eq last()">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:biblStruct[tei:series]">
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:biblStruct/tei:monogr/tei:title">
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <!-- Če pa je naslov zbirke edini naslov, damo za njim piko -->
                            <xsl:otherwise>
                                <xsl:text>. </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Naslovi in podnaslovi si sledijo med seboj ločeni z vejico, za zadnjim je pika.
         Naslovi so poševni. -->
    <xsl:template match="tei:title" mode="naslov-podnaslov-italic">
        <i><xsl:value-of select="normalize-space(.)"/></i>
        <xsl:choose>
            <xsl:when test=".[1] and following-sibling::tei:title">
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="position() eq last()">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:biblStruct[tei:series]">
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:biblStruct/tei:monogr/tei:title">
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <!-- Če pa je naslov zbirke edini naslov, damo za njim piko -->
                            <xsl:otherwise>
                                <xsl:text>. </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- tei:meeting -->
    <xsl:template match="tei:meeting">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>, </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:imprint">
        <!-- Ljubljana, Celje: Založba 1, Založba 2, 2013 -->
        <!-- Celje: Založba 1, 2013 -->
        <!-- IV, Celje: Založba 1, 2013, št. 3, str. 13,  -->
        <!-- Ljubljana 2013 -->
        <!-- IV, 2013, št. 3, str. 12-14, 14 -->
        <xsl:apply-templates select="tei:pubPlace"/>
        <span itemprop="publisher">
            <xsl:apply-templates select="tei:publisher"/>
        </span>
        <xsl:apply-templates select="tei:biblScope[@unit='vol']"/>
        <span itemprop="datePublished">
            <xsl:apply-templates select="tei:date" mode="imprint"/>
        </span>
        <xsl:apply-templates select="tei:biblScope[@unit='issue']"/>
        <xsl:apply-templates select="tei:biblScope[@unit='pp']"/>
        <!-- internetni vir (ker je možno, da je več elementov imprint za isto ref, ga damo samo pri zadnjem) -->
        <xsl:if test="ancestor::tei:biblStruct/tei:ref">
            <xsl:if test="position() eq last()">
                <xsl:text>, </xsl:text>
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="ancestor::tei:biblStruct/tei:ref/@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="ancestor::tei:biblStruct/tei:ref/@target"/>
                </a>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(ancestor::tei:biblStruct/tei:ref)"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:imprint" mode="opomba">
        <!-- Ljubljana, Celje 2013, -->
        <!-- 2013, št. 2 -->
        <xsl:apply-templates select="tei:pubPlace"/>
        <span itemprop="datePublished">
            <xsl:apply-templates select="tei:date" mode="opomba"/>
        </span>
        <xsl:apply-templates select="tei:biblScope[@unit='issue']"/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:pubPlace">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:publisher">
        <xsl:if test="../tei:pubPlace">
            <xsl:if test=".[1]">
                <xsl:text>: </xsl:text>
            </xsl:if>
        </xsl:if>
        <!-- zaradi iskalnika se vse izpiše v eno vrstico - tudi ne upošteva narekovajev -->
        <xsl:value-of select="normalize-space(translate(.,'&#xA;&quot;','&#x20;'))"/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@unit='vol']">
        <!-- letnik vedno vrninemo med naslov na levi in datum,
             zato mu vedno damo pred njim prazen prostor in za njim vejico.
             Če sta prisotna založba in/ali kraj izdaje, se pravila malo spremenijo.
        -->
        <xsl:choose>
            <xsl:when test="../tei:pubPlace or ../tei:publisher">
                <xsl:text>, vol. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> vol. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="."/>
        <xsl:choose>
            <xsl:when test="../tei:pubPlace or ../tei:publisher">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:date" mode="imprint">
        <xsl:choose>
            <xsl:when test="../tei:pubPlace 
                and ../tei:publisher">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <!-- Ljubljana, Celje 2013, -->
            <xsl:when test="../tei:pubPlace and not(../tei:publisher)">
                <xsl:text> </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@when">
                <xsl:value-of select="format-date(
                    ./@when,
                    '[D]. [M]. [Y]',
                    'en',(),())"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:date" mode="opomba">
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="@when">
                <xsl:value-of select="format-date(
                    ./@when,
                    '[D]. [M]. [Y]',
                    'en',(),())"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@unit='issue']">
        <xsl:if test=".[1]">
            <xsl:text>, št. </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:biblScope[@unit='pp']">
        <xsl:if test=".[1]">
            <xsl:text>, str. </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:citedRange">
        <xsl:value-of select="@n"/>
        <xsl:if test="following-sibling::tei:citedRange">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- za literaturo v seznamu literature -->
    <xsl:template match="tei:bibl[parent::tei:listBibl]">
        <!-- anchor oziroma atribut id obvezen, da se lahko na njih sklicuje iz literature v opombah.
             Sklicujemo pa se lahko samo v primeru, če že prej obstaja povezava,
             zato imajo listBibl/bibl v teh primerih vedno xml:id -->
        <!-- Vsaka bibliografska enota obvezno dobi anchor, da se lahko na
             njega sklicujemo iz literature v opombah. -->
        <!-- Ker ne vemo vnaprej, ali je knjiga ali članek ali kaj drugega, je lahko samo CreativeWork -->
        <li id="{@xml:id}" itemscope="" itemtype="https://schema.org/CreativeWork">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <!-- za literaturo, ki ima povezavo -->
    <xsl:template match="tei:bibl[@corresp][not(@type='arhiv')]">
        <xsl:variable name="ID">
            <xsl:call-template name="correspBiblID"/>
        </xsl:variable>
        <xsl:variable name="correspID" select="substring-after(@corresp,'#')"/>
        <xsl:variable name="citedRange">
            <xsl:call-template name="citedRange"/>
        </xsl:variable>
        <xsl:choose>
            <!-- če ne vsebuje nobenega zapisa ali kvečjemu child element citedRange,
                potem je potrebno vsebino procesirati glede na podatke v biblStruct literaturi (na katero je vezan preko corresp atributa) -->
            <xsl:when test="tei:citedRange or string-length(.) = 0">
                <!-- najdemo referenčno tei:biblStruct -->
                <xsl:for-each select="//tei:biblStruct[@xml:id = $correspID]">
                    <xsl:choose>
                        <!-- za članke -->
                        <xsl:when test="tei:analytic">
                            <span id="{$ID}" itemscope="" itemtype="http://schema.org/Article">
                                <xsl:apply-templates select="tei:analytic" mode="opomba"/>
                                <xsl:apply-templates select="tei:monogr" mode="opomba-clanek"/>
                                <xsl:value-of select="$citedRange"/>
                                <xsl:call-template name="sourceLink"/>
                                <xsl:call-template name="correspBibl"/>
                            </span>
                        </xsl:when>
                        <!-- za monografije -->
                        <xsl:otherwise>
                            <span id="{$ID}" itemscope="" itemtype="http://schema.org/Book">
                                <xsl:apply-templates select="tei:monogr" mode="opomba-monografija"/>
                                <xsl:value-of select="$citedRange"/>
                                <xsl:call-template name="sourceLink"/>
                                <xsl:call-template name="correspBibl"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- Drugače se vsebina izpiše in doda samo povezava na corresp literaturo -->
            <xsl:otherwise>
                <span id="{$ID}" itemscope="" itemtype="https://schema.org/CreativeWork">
                    <xsl:apply-templates/>
                    <xsl:for-each select="//node()[parent::tei:listBibl][@xml:id = $correspID]">
                        <sup>
                            <xsl:text> [</xsl:text>
                            <!-- povezava na bibliografijo, ki je vedno v type bibliogr in ima vedno atribut xml:id -->
                            <a class="bibliography" title="Bibliografija" href="{concat(ancestor::tei:div[@type='bibliogr']/@xml:id,'.html#',./@xml:id)}">bibl</a>
                            <xsl:text>]</xsl:text>
                        </sup>
                    </xsl:for-each>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="citedRange">
        <xsl:if test="tei:citedRange[@unit='pp']">
            <xsl:text>, str. </xsl:text>
        </xsl:if>
        <xsl:for-each select="tei:citedRange">
            <xsl:value-of select="@n"/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="sourceLink">
        <!-- izpis navajanja hipterpovezave v tei:note -->
        <!-- internetni vir -->
        <xsl:if test="tei:ref">
            <xsl:text>, </xsl:text>
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="tei:ref/@target"/>
                </xsl:attribute>
                <xsl:value-of select="tei:ref/@target"/>
            </a>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="normalize-space(tei:ref)"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="correspBibl">
        <!-- povezava bibliografsko enoto v seznamu literature -->
        <sup>
            <xsl:text> [</xsl:text>
            <!-- povezava na bibliografijo, ki je vedno v type bibliogr in ima vedno atribut xml:id -->
            <a class="bibliography" title="Bibliografija" href="{concat(ancestor::tei:div[@type='bibliogr']/@xml:id,'.html#',./@xml:id)}">bibl</a>
            <xsl:text>]</xsl:text>
        </sup>
    </xsl:template>
    
    <xsl:template match="tei:analytic" mode="opomba">
        <xsl:apply-templates select="tei:author" mode="ime-priimek"/>
        <span itemprop="name">
            <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:monogr" mode="opomba-clanek">
        <xsl:choose>
            <!-- Ker internetne vire vedno zapisujem kot posamezne članke
                 (konkreten članek oz. spletna stran) večjih monografski enot (širše spletne strani),
                 jim vedno damo atribut type z vrednostjo www.
            -->
            <xsl:when test="parent::tei:biblStruct[@type='www']">
                <xsl:text>Dostopno na: </xsl:text>
            </xsl:when>
            <!-- Za prvotno analogne publikacije -->
            <xsl:otherwise>
                <xsl:text>V: </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <span itemprop="name">
            <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
        </span>
        <xsl:apply-templates select="tei:imprint" mode="opomba"/>
    </xsl:template>
    
    <xsl:template match="tei:monogr" mode="opomba-monografija">
        <xsl:apply-templates select="tei:author" mode="ime-priimek"/>
        <span itemprop="name">
            <xsl:apply-templates select="tei:title" mode="naslov-podnaslov"/>
        </span>
        <xsl:apply-templates select="tei:imprint" mode="opomba"/>
    </xsl:template>
    
    <!-- Opombe za arhivsko gradivo (moj način zapisa):
         Uporabljen tei:bibl, kateri ima type atribut arhiv.
    -->
    <xsl:template match="tei:bibl[@type='arhiv']">
        <!-- anchor obvezen, da se lahko na njih sklicuje iz literature v opombah.
             Sklicujemo pa se lahko samo v primeru, če že prej obstaja povezava,
             zato imajo biblStruct v teh primerih vedno xml:id -->
        <!-- Vsaka bibliografska enota obvezno dobi anchor (oziroma atribut id), da se lahko na
             njega sklicujemo iz literature v opombah.
             Nujno je potreben pri iskalniku -->
        <xsl:choose>
            <xsl:when test="parent::tei:listBibl">
                <li id="{@xml:id}">
                    <xsl:call-template name="biblArhiv"/>
                    <!-- na koncu enote v seznamu je vedno pika -->
                    <xsl:text>.</xsl:text>
                    <!-- seznam citiranih bibliografij - povezava na opombo, v okviru katere je delo citirano -->
                    <xsl:call-template name="biblCitedIn"/>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- če ima atribut corresp se nahaja v opombi in ima povezavo na seznam virov in literature -->
                    <xsl:when test="@corresp">
                        <xsl:variable name="ID">
                            <xsl:call-template name="correspBiblID"/>
                        </xsl:variable>
                        <xsl:variable name="correspID" select="substring-after(@corresp,'#')"/>
                        <!-- najdemo referenčno tei:bibl v tei:listBibl -->
                        <xsl:for-each select="//tei:bibl[@xml:id = $correspID]">
                            <span id="{$ID}">
                                <xsl:call-template name="biblArhivOpomba"/>
                                <!-- povezava na bibliografsko arhivsko enoto v seznamu virov in literature -->
                                <sup>
                                    <xsl:text> [</xsl:text>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat(ancestor::tei:div[@type='bibliogr']/@xml:id,'.html#',./@xml:id)"/>
                                        </xsl:attribute>
                                        <xsl:text>bibl</xsl:text>
                                    </a>
                                    <xsl:text>]</xsl:text>
                                </sup>
                            </span>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- drugih primerov trenutno ne upoštevam (če se npr. nahajajo v tei:header -->
                    <xsl:otherwise>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="biblCitedIn">
        <!-- seznam citiranih bibliografij - povezava na opombo, v okviru katere je delo citirano -->
        <!-- Če imajo biblStruct že originalno xml:id, ga imajo zaradi tega, ker obstaja do njih povezava -->
        <xsl:if test="@xml:id">
            <xsl:variable name="biblStructID" select="concat('#',@xml:id)"/>
            <xsl:text> [citirano: </xsl:text>
            <xsl:for-each select="//tei:bibl[@corresp = $biblStructID]">
                <xsl:variable name="ID">
                    <xsl:call-template name="correspBiblID"/>
                </xsl:variable>
                <!-- xml:id od div, iz katerega je narejen nov html dokument -->
                <xsl:variable name="ancestorChapter-id">
                    <xsl:value-of select="ancestor::tei:div[@xml:id][parent::tei:front or parent::tei:body or parent::tei:back]/@xml:id"/>
                </xsl:variable>
                <a href="{concat($ancestorChapter-id,'.html#',$ID)}">
                    <xsl:value-of select="substring-after($ID,'bibl-')"/>
                </a>
                <xsl:choose>
                    <xsl:when test="position() eq last()">
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>, </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="biblArhiv">
        <!-- naziv arhiva -->
        <xsl:choose>
            <xsl:when test="tei:orgName[@full='yes'] or not(tei:orgName/@full)">
                <!-- polni naziv arhiva -->
                <xsl:for-each select="tei:orgName[not(@full='init')]">
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:choose>
                        <xsl:when test="position() eq last() and following-sibling::tei:orgName[@full='init']">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- v oklepaju morebitna kratica arhiva -->
                <xsl:value-of select="concat('(',tei:orgName[@full='init'],')')"/>
            </xsl:when>
            <!-- samo kratica arhiva -->
            <xsl:otherwise>
                <xsl:value-of select="tei:orgName[@full='init']"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- ime fonda -->
        <xsl:for-each select="tei:title[@type='fond']">
            <xsl:if test="not(.[@rend='short'])">
                <xsl:value-of select="concat(', ',normalize-space(.))"/>
            </xsl:if>
            <xsl:if test=".[@rend='short']">
                <xsl:choose>
                    <!-- Kratica fonda je lahko samo ena. Če je torej pred njim kakšen drugi naslov,
                         potem je to lahko samo polni naslov, zato damo kratico v oklepaj. -->
                    <xsl:when test="preceding-sibling::tei:title">
                        <xsl:value-of select="concat(' (',.,')')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(', ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
        <!-- ime fascikla -->
        <xsl:if test="tei:title[@type='fascikel']">
            <xsl:text>, f. </xsl:text>
            <xsl:for-each select="tei:title[@type='fascikel']">
                <xsl:if test="position() ne 1">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </xsl:if>
        <!-- ime mape -->
        <xsl:if test="tei:title[@type='mapa']">
            <xsl:text>, mapa </xsl:text>
            <xsl:for-each select="tei:title[@type='mapa']">
                <xsl:if test="position() ne 1">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </xsl:if>
        <!-- ime dokumenta -->
        <xsl:for-each select="tei:title[@type='dokument']">
            <xsl:if test="@n">
                <xsl:value-of select="concat(', št. ',./@n)"/>
            </xsl:if>
            <xsl:if test="./text()">
                <xsl:value-of select="concat(', ',normalize-space(.))"/>
            </xsl:if>
        </xsl:for-each>
        <!-- datum dokumenta -->
        <xsl:for-each select="tei:date">
            <xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when test="@when">
                    <xsl:value-of select="format-date(
                        ./@when,
                        '[D]. [M]. [Y]',
                        'en',(),())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="biblArhivOpomba">
        <!-- naziv arhiva: če obstaja kratica arhiva, se navede samo njo. -->
        <xsl:choose>
            <xsl:when test="tei:orgName[@full='init']">
                <xsl:value-of select="tei:orgName[@full='init']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="tei:orgName"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- ime fonda: če obstaja kratica fonda, se navede samo njo -->
        <xsl:choose>
            <xsl:when test="tei:title[@type='fond'][@rend='short']">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="tei:title[@type='fond'][@rend='short']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="tei:title[@type='fond']">
                    <xsl:value-of select="concat(', ',normalize-space(.))"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!-- ime fascikla -->
        <xsl:if test="tei:title[@type='fascikel']">
            <xsl:text>, f. </xsl:text>
            <xsl:for-each select="tei:title[@type='fascikel']">
                <xsl:if test="position() ne 1">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </xsl:if>
        <!-- ime mape -->
        <xsl:if test="tei:title[@type='mapa']">
            <xsl:text>, mapa </xsl:text>
            <xsl:for-each select="tei:title[@type='mapa']">
                <xsl:if test="position() ne 1">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </xsl:if>
        <!-- ime dokumenta -->
        <xsl:for-each select="tei:title[@type='dokument']">
            <xsl:if test="@n">
                <xsl:value-of select="concat(', št. ',./@n)"/>
            </xsl:if>
            <xsl:if test="./text()">
                <xsl:value-of select="concat(', ',normalize-space(.))"/>
            </xsl:if>
        </xsl:for-each>
        <!-- datum dokumenta -->
        <xsl:for-each select="tei:date">
            <xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when test="@when">
                    <xsl:value-of select="format-date(
                        ./@when,
                        '[D]. [M]. [Y]',
                        'en',(),())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>