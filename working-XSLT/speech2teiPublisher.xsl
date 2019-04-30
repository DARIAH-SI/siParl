<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhajam iz speech-list.xml -->
    <!-- TEI datoteke iz ../speech/ predelam na način, da so primerne za objavo v teiPublisher, eXist-db -->
    <!-- OPOZORILO: NE PROCESIRAJ VSEGA NA ENKRAT, KER IMAŠ ZA TO PREMALO SPOMINA: ZATO UPORABI SPODNJI PARAMETER, KI IMA LAHKO TRI VREDNOSTI:
         - SSK
         - SDZ
         - SDT
     -->
    <xsl:param name="minutesType">SDT</xsl:param>
    <!-- POTEM PA ŠE ŠTEVILKA MANDATA -->
    <xsl:param name="mandate">7</xsl:param>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="terms" xmlns="http://www.siparl.si" xmlns:parl="http://www.siparl.si">
        <term n="11" start="1990-05-05" end="1992-12-23">11. mandat (1990-1992)</term>
        <term n="1" start="1992-12-23" end="1996-11-28">1. mandat (1992-1996)</term>
        <term n="2" start="1996-11-28" end="2000-10-27">2. mandat (1996-2000)</term>
        <term n="3" start="2000-10-27" end="2004-10-22">3. mandat (2000-2004)</term>
        <term n="4" start="2004-10-22" end="2008-10-15">4. mandat (2004-2008)</term>
        <term n="5" start="2008-10-15" end="2011-12-15">5. mandat (2008-2011)</term>
        <term n="6" start="2011-12-16" end="2014-08-01">6. mandat (2011-2014)</term>
        <term n="7" start="2014-08-01" end="2018-06-22">7. mandat (2014-2018)</term>
    </xsl:variable>
    
    <xsl:variable name="documents">
        <xsl:for-each select="documentsList/folder[@label= concat($minutesType,$mandate)]/ref">
            <xsl:variable name="filename" select="substring-before(tokenize(.,'/')[position()=last()],'.xml')"/>
            <document
                date="{if ($minutesType='SDZ') then concat(tokenize($filename,'-')[3],'-',tokenize($filename,'-')[4],'-',tokenize($filename,'-')[5]) else concat(tokenize($filename,'-')[4],'-',tokenize($filename,'-')[5],'-',tokenize($filename,'-')[6])}"
                chamber="{if ($minutesType='SSK') then tokenize($filename,'-')[1] else ''}"
                workingBody="{if ($minutesType='SDT') then tokenize($filename,'-')[1] else ''}"
                sessionType="{if ($minutesType='SDZ') then tokenize($filename,'-')[1] else tokenize($filename,'-')[2]}"
                sessionNum="{if ($minutesType='SDZ') then tokenize($filename,'-')[2] else tokenize($filename,'-')[3]}">
                <xsl:value-of select="tokenize(.,'/')[position()=last()]"/>
            </document>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="speakers">
        <xsl:for-each select="documentsList/folder[@label= concat($minutesType,$mandate)]/teiHeader/profileDesc/particDesc/listPerson[@type='speaker']">
            <xsl:for-each select="person | personGrp">
                <person xml:id="{@xml:id}">
                    <xsl:choose>
                        <xsl:when test="persName/*">
                            <xsl:for-each select="persName[1]">
                                <forename>
                                    <xsl:for-each select="forename">
                                        <xsl:value-of select="."/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </forename>
                                <surname>
                                    <xsl:for-each select="surname">
                                        <xsl:value-of select="."/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </surname>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <persName>
                                <xsl:value-of select="persName[1]"/>
                            </persName>
                        </xsl:otherwise>
                    </xsl:choose>
                </person>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="documentsList">
        <xsl:for-each select="folder[@label= concat($minutesType,$mandate)]/ref">
            
            <!-- TEI dokumenti -->
            <xsl:variable name="document" select="concat('../teiPublisher/',parent::folder/@label,'/',tokenize(.,'/')[position()=last()])"/>
            <xsl:result-document href="{$document}">
                <xsl:apply-templates select="document(.)" mode="pass0">
                    <xsl:with-param name="file" select="tokenize(.,'/')[last()]"/>
                </xsl:apply-templates>
            </xsl:result-document>          
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="/" mode="pass0">
        <xsl:param name="file"/>
        <xsl:variable name="var1">
            <xsl:apply-templates mode="pass1">
                <xsl:with-param name="file" select="$file"/>
            </xsl:apply-templates>
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
        
        <!-- kopiram zadnjo variablo z vsebino celotnega dokumenta -->
        <xsl:copy-of select="$var4" copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:param name="file"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1">
                <xsl:with-param name="file" select="$file"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt" mode="pass1">
        <xsl:param name="file"/>
        <titleStmt>
            <xsl:choose>
                <xsl:when test="$minutesType='SSK'">
                    <title>
                        <xsl:text>Skupščina Republike Slovenije, </xsl:text>
                        <xsl:value-of select="tei:title[@type='sub'][@xml:lang='sl']"/>
                        <!-- sem v speech/SSK/ pozabil dodati datume, zato jih dodajam sedaj -->
                        <xsl:value-of select="concat(' (',ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date,')')"/>
                    </title>
                </xsl:when>
                <xsl:when test="$minutesType='SDZ'">
                    <title>
                        <xsl:text>Državni zbor Republike Slovenije, </xsl:text>
                        <xsl:value-of select="tei:title[@type='sub'][@xml:lang='sl']"/>
                    </title>
                </xsl:when>
                <xsl:when test="$minutesType='SDT'">
                    <xsl:choose>
                        <xsl:when test="tei:title[@type='main'][@xml:lang='sl'] = 'Dobesedni zapis seje Kolegija predsednika Državnega zbora Republike Slovenije'">
                            <title>
                                <xsl:text>Kolegij predsednika Državnega zbora, </xsl:text>
                                <xsl:value-of select="tei:title[@type='sub'][@xml:lang='sl']"/>
                            </title>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="tei:title[@type='sub'][@xml:lang='sl']">
                                <title>
                                    <xsl:value-of select="."/>
                                </title>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="*[not(self::tei:title)]" mode="pass1">
                <xsl:with-param name="file" select="$file"/>
            </xsl:apply-templates>
        </titleStmt>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:date" mode="pass1">
        <date when="{current-date()}"/>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc" mode="pass1">
        <xsl:param name="file"/>
        <sourceDesc>
            <bibl>
                <xsl:text>https://github.com/DARIAH-SI/siParl/blob/master/speech/</xsl:text>
                <xsl:value-of select="$minutesType"/>
                <xsl:value-of select="$mandate"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$file"/>
            </bibl>
        </sourceDesc>
    </xsl:template>
    
    <xsl:template match="tei:text" mode="pass1">
        <xsl:param name="file"/>
        <xsl:variable name="filename" select="if (matches($file,'_')) then substring-before($file,'_') else substring-before($file,'.xml')"/>
        <xsl:variable name="chamber" select="if ($minutesType='SSK') then tokenize($filename,'-')[1] else ''"/>
        <xsl:variable name="workingBody" select="if ($minutesType='SDT') then tokenize($filename,'-')[1] else ''"/>
        <xsl:variable name="sessionType" select="if ($minutesType='SDZ') then tokenize($filename,'-')[1] else tokenize($filename,'-')[2]"/>
        <xsl:variable name="sessionNum" select="if ($minutesType='SDZ') then tokenize($filename,'-')[2] else tokenize($filename,'-')[3]"/>
        <xsl:variable name="date" select="if ($minutesType='SDZ') then concat(tokenize($filename,'-')[3],'-',tokenize($filename,'-')[4],'-',tokenize($filename,'-')[5]) else concat(tokenize($filename,'-')[4],'-',tokenize($filename,'-')[5],'-',tokenize($filename,'-')[6])"/>
        <xsl:variable name="sameSession">
            <xsl:for-each select="$documents/tei:document[@chamber=$chamber][@workingBody=$workingBody][@sessionType=$sessionType][@sessionNum=$sessionNum]">
                <xsl:sort select="@date"/>
                <document when="{@date}">
                    <xsl:if test="@date=$date">
                        <xsl:attribute name="this">yes</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </document>
            </xsl:for-each>
        </xsl:variable>
        <text>
            <front>
                <div type="about" xml:id="{ancestor::tei:TEI/@xml:id}.div.about">
                    <head>O zapisniku seje</head>
                    <p>
                        <xsl:choose>
                            <xsl:when test="$minutesType='SSK'">Skupščina Republike Slovenije</xsl:when>
                            <xsl:otherwise>Državni zbor Republike Slovenije</xsl:otherwise>
                        </xsl:choose>
                    </p>
                    <p>
                        <xsl:value-of xmlns:parl="http://www.siparl.si" select="$terms/parl:term[@n=$mandate]"/>
                    </p>
                    <xsl:if test="$minutesType='SSK'">
                        <!-- imena enega ali več zborov -->
                        <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:org">
                            <p>
                                <xsl:value-of select="."/>
                            </p>
                        </xsl:for-each>
                        <!-- številka in vrsta seje -->
                        <p>
                            <xsl:value-of select="substring-after(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],': ')"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="$minutesType='SDZ'">
                        <!-- številka in vrsta seje -->
                        <p>
                            <xsl:value-of select=" substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],' (')"/>
                        </p>
                    </xsl:if>
                    <xsl:if test="$minutesType='SDT'">
                        <xsl:choose>
                            <xsl:when test=" ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:org[2]">
                                <!-- imena delovnih teles in številka in vrsta seje -->
                                <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl']">
                                    <p>
                                        <xsl:value-of select="substring-before(.,' (')"/>
                                    </p>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- ime delovnega telesa -->
                                <p>
                                    <xsl:value-of select="substring-before(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],':')"/>
                                </p>
                                <!-- številka in vrsta seje -->
                                <p>
                                    <xsl:value-of select="substring-before(substring-after(ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl'],': '),' (')"/>
                                </p>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:if>
                    <!-- datum seje -->
                    <p>
                        <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
                    </p>
                    
                    <!-- pomikanje naprej in nazaj po istih sejah na različne datume -->
                    <xsl:if test="$sameSession/tei:document[2]">
                        <list>
                            <xsl:if test="$sameSession/tei:document[@this][preceding-sibling::tei:document]">
                                <item>
                                    <xsl:text>Predhodni dan seje: </xsl:text>
                                    <ref target="{$sameSession/tei:document[@this]/preceding-sibling::tei:document[1]}">
                                        <xsl:value-of select="$sameSession/tei:document[@this]/preceding-sibling::tei:document[1]/@when"/>
                                    </ref>
                                </item>
                            </xsl:if>
                            <xsl:if test="$sameSession/tei:document[@this][following-sibling::tei:document]">
                                <item>
                                    <xsl:text>Nadaljevanje seje: </xsl:text>
                                    <ref target="{$sameSession/tei:document[@this]/following-sibling::tei:document[1]}">
                                        <xsl:value-of select="$sameSession/tei:document[@this]/following::tei:document[1]/@when"/>
                                    </ref>
                                </item>
                            </xsl:if>
                        </list>
                    </xsl:if>
                </div>
            </front>
            <xsl:apply-templates mode="pass1"/>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='minutes']" mode="pass1">
        <xsl:for-each-group select="*" group-starting-with="tei:note[@type='speaker']">
            <div type="sp" ana="{current-group()[self::tei:u]/@ana}">
                <xsl:apply-templates select="current-group()" mode="pass1"/>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:div[@type='sp']" mode="pass2">
        <xsl:variable name="num">
            <xsl:number count="tei:div[@type='sp']" level="any"/>
        </xsl:variable>
        <div type="{if (string-length(@ana) = 0) then 'preface' else 'sp'}" xml:id="{ancestor::tei:TEI/@xml:id}.sp{$num}">
            <xsl:apply-templates mode="pass2"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="pass2">
        <xsl:apply-templates mode="pass2"/>
    </xsl:template>
    
    <xsl:template match="tei:seg" mode="pass2">
        <u who="{parent::tei:u/@who}">
            <xsl:apply-templates select="@*" mode="pass2"/>
            <xsl:apply-templates mode="pass2"/>
        </u>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:text" mode="pass3">
        <text>
            <xsl:apply-templates mode="pass3"/>
            <xsl:if test="//tei:div[@type='sp']">
                <back>
                    <div type="speakers" xml:id="{ancestor::tei:TEI/@xml:id}.div.speakers">
                        <head>Seznam govornikov</head>
                        <list>
                            <xsl:for-each-group select="//tei:div[@type='sp']" group-by="substring-after(tei:u[1]/@who,'#')">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:variable name="personID" select="current-grouping-key()"/>
                                <item>
                                    <xsl:for-each select="$speakers/tei:person[@xml:id=$personID]">
                                        <xsl:choose>
                                            <xsl:when test="tei:forename | tei:surname">
                                                <xsl:value-of select="tei:surname"/>
                                                <xsl:text>, </xsl:text>
                                                <xsl:value-of select="tei:forename"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="tei:persName"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:text>: </xsl:text>
                                    <xsl:for-each select="current-group()">
                                        <ref target="#{@xml:id}">
                                            <xsl:text>govor</xsl:text>
                                        </ref>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </item>
                            </xsl:for-each-group>
                        </list>
                    </div>
                </back>
            </xsl:if>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:front" mode="pass3">
        <front>
            <xsl:apply-templates mode="pass3"/>
            <xsl:if test="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:abstract/tei:list[@type='agenda']">
                <div type="contents" xml:id="{ancestor::tei:TEI/@xml:id}.div.contents">
                    <head>Dnevni red</head>
                    <list>
                        <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:abstract/tei:list[@type='agenda']/tei:item">
                            <item xml:id="{@xml:id}">
                                <ref target="{tei:ptr[1]/@target}">
                                    <xsl:value-of select="tei:title"/>
                                </ref>
                                <xsl:variable name="corresp">
                                    <xsl:for-each select="tei:ptr">
                                        <ptr>
                                            <xsl:value-of select="substring-after(@target,'#')"/>
                                        </ptr>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="string-length($corresp) gt 0">
                                    <list>
                                        <xsl:for-each select="//tei:div[@type='sp'][tei:u/@xml:id = $corresp/tei:ptr]">
                                            <xsl:variable name="personID" select="substring-after(tei:u[1]/@who,'#')"/>
                                            <item>
                                                <ref target="#{@xml:id}">
                                                    <xsl:for-each select="$speakers/tei:person[@xml:id=$personID]">
                                                        <xsl:choose>
                                                            <xsl:when test="tei:forename | tei:surname">
                                                                <xsl:value-of select="tei:forename"/>
                                                                <xsl:text> </xsl:text>
                                                                <xsl:value-of select="tei:surname"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="tei:persName"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </ref>
                                            </item>
                                        </xsl:for-each>
                                    </list>
                                </xsl:if>
                            </item>
                        </xsl:for-each>    
                    </list>
                </div>
            </xsl:if>
        </front>
    </xsl:template>
    
    <xsl:template match="tei:abstract" mode="pass3">
        <!-- ga odstranim -->
    </xsl:template>
    
    <xsl:template match="tei:list[not(tei:item)]" mode="pass3">
        <!-- ga odstranim -->
    </xsl:template>
    
    <!-- čisto na koncu še preštejem vse elemente -->
    <xsl:template match="@* | node()" mode="pass4">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass4"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
    
    <xsl:template match="tei:tagsDecl" mode="pass4">
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>
    
</xsl:stylesheet>