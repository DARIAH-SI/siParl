<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html teidocx"
    version="2.0">
    
    <!-- Ime avtorja(jev): Znotraj odstavka, ločeni z novo vrstico, imena in priimki ločeni z praznim prostorom -->
    <xsl:template match="tei:docAuthor">
        <p class="text-center">
            <b>
                <xsl:choose>
                    <xsl:when test="tei:forename or tei:surname">
                        <xsl:for-each select="tei:forename">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() ne last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="tei:surname">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:for-each select="tei:surname">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() ne last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="position() ne last()">
                    <br/>
                </xsl:if>
            </b>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:q">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    
    <xsl:template match="tei:soCalled">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    
    <xsl:template match="tei:said">
        <i>
            <q>
                <xsl:apply-templates/>
            </q>
        </i>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    
    <xsl:template match="tei:placeName">
        <!-- variable za anchor -->
        <xsl:variable name="numLevel">
            <xsl:number count="tei:text//tei:placeName" level="any"/>
        </xsl:variable>
        <xsl:variable name="numPlace">
            <xsl:number value="$numLevel"/>
        </xsl:variable>
        <span id="{concat('kraj-',$numPlace)}" class="teiplace">
            <!-- ime kraja in povezava na imensko kazalo -->
            <xsl:choose>
                <xsl:when test="@ref">
                    <xsl:variable name="referenca" select="substring-after(@ref,'#')"/>
                    <span itemscope="" itemtype="http://schema.org/Place">
                        <span itemprop="name">
                            <xsl:apply-templates/>
                        </span>
                    </span>
                    <sup>
                        <a class="place">
                            <xsl:for-each select="//tei:place[@xml:id = $referenca]">
                                <xsl:attribute name="href">
                                    <!-- krajevno kazalo je vedno spravljeno v datoteki places.html
                                    (generira iz tei:divGen[@type='places'] -->
                                    <xsl:value-of select="concat('places.html#',./@xml:id)"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('Krajevno kazalo: kraj št. ',$numPlace)"/>
                            </xsl:attribute>
                            <xsl:text>[kr.]</xsl:text>
                        </a>
                    </sup>
                </xsl:when>
                <xsl:when test="@corresp">
                    <xsl:variable name="povezava" select="@corresp"/>
                    <span itemscope="" itemtype="http://schema.org/Place">
                        <span itemprop="name">
                            <xsl:apply-templates/>
                        </span>
                    </span>
                    <sup>
                        <a class="place">
                            <xsl:for-each select="//tei:place[@corresp = $povezava]">
                                <!-- ker nimajo svojega @xml:id, smo ustavrili anchorje glede na njihovo mesto v listPlace -->
                                <xsl:variable name="numLevel">
                                    <xsl:number count="tei:place" level="any"/>
                                </xsl:variable>
                                <xsl:variable name="numPlaceHead">
                                    <xsl:number value="$numLevel"/>
                                </xsl:variable>
                                <xsl:attribute name="href">
                                    <!-- krajevno kazalo je vedno spravljeno v datoteki places.html
                                    (generira iz tei:divGen[@type='places'] -->
                                    <xsl:value-of select="concat('places.html','#place-',$numPlaceHead)"/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('Krajevno kazalo: kraj št. ',$numPlace)"/>
                            </xsl:attribute>
                            <xsl:text>[kr.]</xsl:text>
                        </a>
                    </sup>
                </xsl:when>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:persName">
        <xsl:variable name="numLevel">
            <xsl:number count="tei:text//tei:persName" level="any"/>
        </xsl:variable>
        <xsl:variable name="numPerson">
            <xsl:number value="$numLevel"/>
        </xsl:variable>
        <span  id="{concat('person-',$numPerson)}" class="teiperson">
            <xsl:choose>
                <xsl:when test="tei:forename or tei:surname">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- osebe, ki so referenca na seznam oseb -->
                        <xsl:when test="@ref">
                            <span itemscope="" itemtype="http://schema.org/Person">
                                <span itemprop="name">
                                    <xsl:apply-templates/>
                                </span>
                            </span>
                            <sup>
                                <xsl:variable name="sistoryPath">
                                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                                        <xsl:call-template name="sistoryPath">
                                            <xsl:with-param name="chapterID">persons</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:variable>
                                <a class="person">
                                    <xsl:attribute name="href">
                                        <!-- imensko kazalo je vedno spravljeno v datoteki persons.html
                                    (generira iz tei:divGen[@type='persons'] -->
                                        <xsl:value-of select="concat($sistoryPath,'persons.html',@ref)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                        <xsl:variable name="persName-text1">
                                            <xsl:sequence select="tei:i18n('persName-text1')"/>
                                        </xsl:variable>
                                        <xsl:value-of select="concat($persName-text1,$numPerson)"/>
                                    </xsl:attribute>
                                    <xsl:sequence select="tei:i18n('persName-text2')"/>
                                </a>
                            </sup>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:forename">
        <xsl:text> </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:surname">
        <xsl:choose>
            <xsl:when test=".[@type='maiden']">
                <xsl:text> roj. </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- imena organizacij -->
    <xsl:template match="tei:orgName[ancestor::tei:text]">
        <xsl:variable name="numLevel">
            <xsl:number count="tei:text//tei:orgName" level="any"/>
        </xsl:variable>
        <xsl:variable name="numOrganization">
            <xsl:number value="$numLevel"/>
        </xsl:variable>
        <span id="{concat('org-',$numOrganization)}" class="teiorganization">
            <xsl:choose>
                <!-- osebe, ki so referenca na seznam oseb -->
                <xsl:when test="@ref">
                    <span itemscope="" itemtype="http://schema.org/Organization">
                        <span itemprop="name">
                            <xsl:apply-templates/>
                        </span>
                    </span>
                    <sup>
                        <a class="organization">
                            <xsl:attribute name="href">
                                <!-- kazalo organizacij je vedno spravljeno v datoteki organizations.html
                                 (generira iz tei:divGen[@type='organizations'] -->
                                <xsl:value-of select="concat('organizations.html',./@ref)"/>
                            </xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('Kazalo organizacij: organizacija št. ',$numOrganization)"/>
                            </xsl:attribute>
                            <xsl:text>[or.]</xsl:text>
                        </a>
                    </sup>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <!-- naslovi del znotraj odstavkov in podobno -->
    <xsl:template match="tei:title">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <!-- Nehirarhično in z znaki *** označena konca podpoglavij -->
    <xsl:template match="tei:milestone">
        <!-- za vsak primer, če bom hotel ta element še posebej oblikovati, sem mu dodal še class milestone -->
        <p class="milestone text-center">
            <xsl:value-of select="./@n"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:choose>
            <!-- Če ni znotraj odstavka -->
            <xsl:when test="not(ancestor::tei:p)">
                <blockquote>
                    <xsl:choose>
                        <xsl:when test="@xml:id and not(parent::tei:cit[@xml:id])">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="parent::tei:cit[@xml:id]">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::tei:cit/@xml:id"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates/>
                    <!-- glej spodaj obrazložitev pri procesiranju elementov cit -->
                    <xsl:if test="parent::tei:cit/tei:bibl/tei:author">
                        <xsl:for-each select="parent::tei:cit/tei:bibl/tei:author">
                            <cite>
                                <xsl:apply-templates/>
                            </cite>
                        </xsl:for-each>
                    </xsl:if>
                </blockquote>
            </xsl:when>
            <!-- Če pa je znotraj odstavka, ga damo samo v element q, se pravi v narekovaje. -->
            <xsl:otherwise>
                <q>
                    <xsl:apply-templates/>
                </q>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Če je naveden tudi avtor citata, damo predhodno element quote v parent element cit
         in mu dodamo še sibling element bibl/author
    -->
    <xsl:template match="tei:cit">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:bibl[tei:author]">
        <!-- ta element pustimo prazen,ker ga procesiroma zgoraj v okviru elementa quote -->
    </xsl:template>
    
    <!-- dramski govor -->
    <xsl:template match="tei:sp">
        <!-- Vsak dramski govor, ki je neposreden child od div, ima xml:id, zato izpišemo atribut id -->
        <!-- uporabimo podobno kot pri quote kot glavni HTML element blockquote,
             ki mu pred besedilom damo v element cite ima govorca  -->
        <blockquote>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    
    <!-- element speaker je child elementa sp -->
    <xsl:template match="tei:speaker">
        <cite>
            <xsl:apply-templates/>
        </cite>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    <xsl:template match="tei:lg/tei:l">
        <xsl:apply-templates/>
        <xsl:if test="position() != last()">
            <br />
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>