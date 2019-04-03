<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni drama/*-list.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('../speech/',.)"/>
            <xsl:result-document href="{$document}">
                <xsl:apply-templates select="document(.)" mode="pass0"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="/" mode="pass0">
        <xsl:variable name="var1">
            <xsl:apply-templates mode="pass1"/>
        </xsl:variable>
        <xsl:variable name="var2">
            <xsl:apply-templates select="$var1" mode="pass2"/>
        </xsl:variable>
        <xsl:variable name="var3">
            <xsl:apply-templates select="$var2" mode="pass3"/>
        </xsl:variable>
        <xsl:variable name="var4">
            <xsl:apply-templates select="$var3" mode="pass4"/>
        </xsl:variable>
        <xsl:variable name="var5">
            <xsl:apply-templates select="$var4" mode="pass5"/>
        </xsl:variable>
        <xsl:variable name="var6">
            <xsl:apply-templates select="$var5" mode="pass6"/>
        </xsl:variable>
        <xsl:variable name="var7">
            <xsl:apply-templates select="$var6" mode="pass7"/>
        </xsl:variable>
        <xsl:variable name="var8">
            <xsl:apply-templates select="$var7" mode="pass8"/>
        </xsl:variable>
        <!-- kopiram zadnjo variablo z vsebino celotnega dokumenta -->
        <xsl:copy-of select="$var8"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:date" mode="pass1">
        <date when="{current-date()}"/>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:div" mode="pass1">
        <div type="preface">
            <xsl:for-each select="tei:head | tei:stage[@type][not(preceding::tei:sp)] | tei:p[not(preceding::tei:sp)]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </div>
        <xsl:apply-templates mode="pass1"/>
    </xsl:template>
    <xsl:template match="tei:body/tei:div/tei:head" mode="pass1">
        <!-- ne procesiram -->
    </xsl:template>
    <xsl:template match="tei:body/tei:div/tei:stage[@type][not(preceding::tei:sp)]" mode="pass1">
        <!-- ne procesiram -->
    </xsl:template>
    <xsl:template match="tei:body/tei:div/tei:p[not(preceding::tei:sp)]" mode="pass1">
        <!-- ne procesiram -->
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="pass1">
        <div type="speech">
            <xsl:apply-templates mode="pass1"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:speaker" mode="pass1">
        <note type="speaker">
            <xsl:apply-templates mode="pass1"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:sp/tei:p" mode="pass1">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:sp/tei:p" level="any"/>
        </xsl:variable>
        <p resp="#{tokenize(parent::tei:sp/@who,':')[2]}" xml:id="{$document-name-id}.p{$num}">
            <xsl:apply-templates mode="pass1"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:sp/tei:p/tei:title[1]" mode="pass1">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:sp/tei:p/tei:title[1]" level="any"/>
        </xsl:variable>
        <title xml:id="{$document-name-id}.title{$num}">
            <xsl:apply-templates mode="pass1"/>
        </title>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:text" mode="pass2">
        <text>
            <front>
                <div type="contents">
                    <list>
                        <item xml:id="{ancestor::tei:TEI/@xml:id}.toc-item0">
                            <title>Pred dnevnim redom</title>
                        </item>
                        <xsl:for-each select="//tei:title[@xml:id]">
                            <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
                            <xsl:variable name="num">
                                <xsl:number count="tei:title[@xml:id]" level="any"/>
                            </xsl:variable>
                            <item xml:id="{$document-name-id}.toc-item{$num}" corresp="{@xml:id}">
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                                <xsl:for-each select="parent::tei:p/tei:title[not(@xml:id)]">
                                    <title><xsl:value-of select="normalize-space(.)"/></title>
                                </xsl:for-each>
                            </item>
                        </xsl:for-each>
                    </list>
                </div>
            </front>
            <xsl:apply-templates mode="pass2"/>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='preface']" mode="pass2">
        <div type="preface">
            <xsl:apply-templates mode="pass2"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:stage[@type='title']" mode="pass2">
        <note type="title">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:head" mode="pass2">
        <note type="title">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:stage[@type='session']" mode="pass2">
        <note type="session">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:stage[@type='date']" mode="pass2">
        <note type="date">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:stage[@type='chairman']" mode="pass2">
        <note type="chairman">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:stage[@type='time']" mode="pass2">
        <note type="time">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    <xsl:template match="tei:div[@type='preface']/tei:p" mode="pass2">
        <note>
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:p" mode="pass2">
        <p>
            <xsl:apply-templates select="@*" mode="pass2"/>
            <xsl:attribute name="ana">
                <xsl:choose>
                    <xsl:when test="tei:title[@xml:id]">
                        <xsl:value-of select="tei:title[@xml:id]/@xml:id"/>
                    </xsl:when>
                    <xsl:when test="preceding::tei:title[@xml:id]">
                        <xsl:value-of select="preceding::tei:title[@xml:id][1]/@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select=" concat(ancestor::tei:TEI/@xml:id,'.toc-item0')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates mode="pass2"/>
        </p>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='contents']/tei:list/tei:item[tei:title[2]]" mode="pass3">
        <item>
            <xsl:apply-templates select="@*" mode="pass3"/>
            <title>
                <xsl:value-of select="string-join(tei:title,' ')"/>
            </title>
        </item>
    </xsl:template>
    
    <!-- odstranim title oznake -->
    <xsl:template match="tei:div[@type='speech']/tei:p/tei:title" mode="pass3">
        <xsl:apply-templates mode="pass3"/>
    </xsl:template>
    
    <!-- povsod odstranim še q (citate in ostale navedke) -->
    <xsl:template match="tei:q" mode="pass3">
        <xsl:apply-templates mode="pass3"/>
    </xsl:template>
    
    <!-- odstavke p spremenim v u (utterance) -->
    <xsl:template match="tei:div[@type='speech']/tei:p" mode="pass3">
        <u>
            <xsl:apply-templates select="@*" mode="pass3"/>
            <xsl:apply-templates mode="pass3"/>
        </u>
    </xsl:template>

    <!-- Razdelim bivše p (sedaj u) elemente -->
    <!-- 1. The use of the identity rule to copy every node as-is. -->
    <xsl:template match="@* | node()" mode="pass4">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass4"/>
        </xsl:copy>
    </xsl:template>
    <!-- 2. The overriding of the identity rule with templates for processing only specific nodes -->
    <xsl:template match="/*" mode="pass4">
        <TEI>
            <xsl:apply-templates select="@*" mode="pass4"/>
            <!-- ?????? Zakaj se mi tukaj pri teiHeader in text pojavijo deklaracija xmlns:xi="http://www.w3.org/2001/XInclude" ????? -->
            <xsl:apply-templates mode="pass4"/>
        </TEI>
    </xsl:template>
    <!-- 3. Using 1. and 2. above. -->
    <xsl:template match="tei:u[tei:stage or tei:gap]/text()" mode="pass4">
        <u><xsl:copy-of select="."/></u>
    </xsl:template>
    
    <!-- prečistim razdeljene elemente -->
    <xsl:template match="@* | node()" mode="pass5">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass5"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='speech']/tei:u" mode="pass5">
        <xsl:choose>
            <xsl:when test="tei:u">
                <xsl:apply-templates mode="pass5"/>
            </xsl:when>
            <xsl:otherwise>
                <u who="{@resp}" ana="{@ana}">
                    <xsl:value-of select="normalize-space(.)"/>
                </u>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:div[@type='speech']/tei:u/tei:u" mode="pass5">
        <xsl:if test="string-length(normalize-space(.)) != 0">
            <u who="{parent::tei:u/@resp}" ana="{parent::tei:u/@ana}">
                <xsl:value-of select="normalize-space(.)"/>
            </u>
        </xsl:if>
    </xsl:template>
   
   <!-- odstranim @n -->
   <xsl:template match="tei:gap" mode="pass5">
       <gap/>
   </xsl:template>
    
    <!-- stage v note, ga še prečistim -->
    <xsl:template match="tei:stage" mode="pass5">
        <note>
            <xsl:apply-templates select="@*" mode="pass5"/>
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    
    <!-- dodam u/@xml:id -->
    <xsl:template match="@* | node()" mode="pass6">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass6"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="pass6">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:u" level="any"/>
        </xsl:variable>
        <u xml:id="{$document-name-id}.u{$num}">
            <xsl:apply-templates select="@*" mode="pass6"/>
            <xsl:apply-templates mode="pass6"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:div[@type ='speech']" mode="pass6">
        <xsl:variable name="speaker" select="tokenize(tei:note[@type='speaker'],' ')[1]"/>
        <xsl:variable name="chair">
                <item>P0DPREDSEDNIK</item>
                <item>PEDSEDNICA</item>
                <item>PEDSEDNIK</item>
                <item>PERDSEDNICA</item>
                <item>PERDSEDNIK</item>
                <item>POD</item>
                <item>PODOPREDSEDNIK</item>
                <item>PODOPRESEDNIK</item>
                <item>PODOREDSEDNIK</item>
                <item>PODPDREDSEDNICA</item>
                <item>PODPEDSEDNIK</item>
                <item>PODPPREDSEDNIK</item>
                <item>PODPPREDSENIK</item>
                <item>PODPRDESEDNICA</item>
                <item>PODPRDESENIK</item>
                <item>PODPRDSEDNICA</item>
                <item>PODPRDSEDNIK</item>
                <item>PODPREDEDNICA</item>
                <item>PODPREDEDNIK</item>
                <item>PODPREDESEDNIK</item>
                <item>PODPREDSDEDNIK</item>
                <item>PODPREDSDENIK</item>
                <item>PODPREDSDNIK</item>
                <item>PODPREDSEDENIK</item>
                <item>PODPREDSEDICA</item>
                <item>PODPREDSEDIK</item>
                <item>PODPREDSEDNCA</item>
                <item>PODPREDSEDNI</item>
                <item>PODPREDSEDNIA</item>
                <item>PODPREDSEDNIC</item>
                <item>PODPREDSEDNICA</item>
                <item>PODPREDSEDNIDA</item>
                <item>PODPREDSEDNIK</item>
                <item>PODPREDSEDNIKA</item>
                <item>PODPREDSEDNIKCA</item>
                <item>PODPREDSEDNIKI</item>
                <item>PODPREDSEDNIKMAG.</item>
                <item>PODPREDSEDNIKN</item>
                <item>PODPREDSEDNK</item>
                <item>PODPREDSEDNNIK</item>
                <item>PODPREDSEEDNIK</item>
                <item>PODPREDSENDICA</item>
                <item>PODPREDSENDIK</item>
                <item>PODPREDSENICA</item>
                <item>PODPREDSENIK</item>
                <item>PODPREDSETNIK</item>
                <item>PODPREDSEVNIK</item>
                <item>PODPRESDEDNIK</item>
                <item>PODPRESEDNICA</item>
                <item>PODPRESEDNIK</item>
                <item>PODPRESENICA</item>
                <item>PODPRREDSEDNICA</item>
                <item>PODREDSEDNICA</item>
                <item>PODREDSEDNIK</item>
                <item>PODRPEDSEDNIK</item>
                <item>PODRPREDSEDNICA</item>
                <item>PODRPREDSEDNIK</item>
                <item>POPDPREDSEDNICA</item>
                <item>POPDPREDSEDNIK</item>
                <item>POPDREDSEDNICA</item>
                <item>POPDREDSEDNIK</item>
                <item>POPPREDSEDNICA</item>
                <item>POPREDSEDNICA</item>
                <item>POPREDSEDNIK</item>
                <item>POREDSDNICA</item>
                <item>PPRDSEDNIK</item>
                <item>PPREDSEDNIK</item>
                <item>PRDEDSEDNIK</item>
                <item>PRDSEDNICA</item>
                <item>PRDSEDNIK</item>
                <item>PRDSENIK</item>
                <item>PRE</item>
                <item>PREDDSEDNIK</item>
                <item>PREDEDNIK</item>
                <item>PREDESEDNICA</item>
                <item>PREDESEDNIK</item>
                <item>PREDESENIK</item>
                <item>PREDNICA</item>
                <item>PREDPREDSEDNICA</item>
                <item>PREDPREDSEDNIK</item>
                <item>PREDSDEDNIK</item>
                <item>PREDSDENIK</item>
                <item>PREDSDNIK</item>
                <item>PREDSEBNIK</item>
                <item>PREDSECNICA</item>
                <item>PREDSEDDNIK</item>
                <item>PREDSEDEDNIK</item>
                <item>PREDSEDENIK</item>
                <item>PREDSEDICA</item>
                <item>PREDSEDIK</item>
                <item>PREDSEDINK</item>
                <item>PREDSEDN</item>
                <item>PREDSEDNCA</item>
                <item>PREDSEDNDIK</item>
                <item>PREDSEDNI</item>
                <item>PREDSEDNIAC</item>
                <item>PREDSEDNIC</item>
                <item>PREDSEDNICA</item>
                <item>PREDSEDNICA.</item>
                <item>PREDSEDNICA:</item>
                <item>PREDSEDNICa</item>
                <item>PREDSEDNIDK</item>
                <item>PREDSEDNIIK</item>
                <item>PREDSEDNIK</item>
                <item>PREDSEDNIK.</item>
                <item>PREDSEDNIK:</item>
                <item>PREDSEDNIKA</item>
                <item>PREDSEDNIKCA</item>
                <item>PREDSEDNIKDR</item>
                <item>PREDSEDNIKI</item>
                <item>PREDSEDNIKJAKOB</item>
                <item>PREDSEDNIVA</item>
                <item>PREDSEDNIk</item>
                <item>PREDSEDNK</item>
                <item>PREDSEDNKIK</item>
                <item>PREDSEDNNIK</item>
                <item>PREDSEDNUK</item>
                <item>PREDSEDSEDNICA</item>
                <item>PREDSEDSEDNIK</item>
                <item>PREDSEDSEDNIKA</item>
                <item>PREDSEDSENIK</item>
                <item>PREDSEDSNIK</item>
                <item>PREDSEDUJOČA</item>
                <item>PREDSEDUJOČI</item>
                <item>PREDSEDUJOČI:</item>
                <item>PREDSEDUJOČI____________:</item>
                <item>PREDSEEDNIK</item>
                <item>PREDSENDIK</item>
                <item>PREDSENICA</item>
                <item>PREDSENIK</item>
                <item>PREDSESDNIK</item>
                <item>PREEDSEDNICA</item>
                <item>PREEDSEDNIK</item>
                <item>PREESEDNIK</item>
                <item>PRERSEDNIK</item>
                <item>PRESDEDNICA</item>
                <item>PRESDEDNIK</item>
                <item>PRESDSEDNICA</item>
                <item>PRESEDNICA</item>
                <item>PRESEDNIK</item>
                <item>PRESEDNK</item>
                <item>PRESEDSEDNIK</item>
                <item>PREdSEDNIK</item>
                <item>PRFEDSEDNICA</item>
                <item>PRFEDSEDNIK</item>
                <item>PRREDSEDNIK</item>
        </xsl:variable>
        <div type="speech">
            <xsl:if test="$speaker = $chair/tei:item">
                <xsl:attribute name="subtype">
                    <xsl:text>chair</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="pass6"/>
        </div>
    </xsl:template>
    
    <!-- uredim povezave na kazala -->
    <xsl:template match="@* | node()" mode="pass7">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass7"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- naredim povezavo iz kazal na tei:u/@xml:id -->
    <xsl:template match="tei:div[@type='contents']/tei:list/tei:item" mode="pass7">
        <item xml:id="{@xml:id}">
            <xsl:variable name="connection" select="@corresp"/>
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:attribute name="corresp">
                <xsl:choose>
                    <xsl:when test="string-length($connection) = 0">
                        <xsl:for-each select="//tei:u[@ana = $id]">
                            <xsl:value-of select="concat('#',@xml:id)"/>
                            <xsl:if test=" position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="//tei:u[@ana = $connection]">
                            <xsl:value-of select="concat('#',@xml:id)"/>
                            <xsl:if test=" position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates mode="pass7"/>
        </item>
    </xsl:template>
    
    <!-- odstranim začasni @ana atribut -->
    <xsl:template match="tei:u" mode="pass7">
        <u xml:id="{@xml:id}" who="{@who}">
            <xsl:apply-templates mode="pass7"/>
        </u>
    </xsl:template>
    
    <!-- odstranim kazala (Pred dnevnim redom), ki nimajo povezav preko corresp -->
    <xsl:template match="@* | node()" mode="pass8">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass8"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='contents']/tei:list/tei:item[string-length(@corresp) = 0]" mode="pass8">
        <!-- ne procesiram -->
    </xsl:template>
    <!-- odstranim tudi prazna kazala -->
    <xsl:template match="tei:front[tei:div[@type='contents']/tei:list/tei:item[string-length(@corresp) = 0]][not(tei:div[@type='contents']/tei:list/tei:item[2])]" mode="pass8">
        <!-- ne procesiram -->
    </xsl:template>
    
</xsl:stylesheet>