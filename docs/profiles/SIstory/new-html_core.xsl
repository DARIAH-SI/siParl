<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:template name="makeaNote">
        <xsl:variable name="identifier">
            <xsl:call-template name="noteID"/>
        </xsl:variable>
        <xsl:if test="$verbose = 'true'">
            <xsl:message>Make note <xsl:value-of select="$identifier"/></xsl:message>
        </xsl:if>
        <div class="note">
            <xsl:call-template name="makeAnchor">
                <xsl:with-param name="name" select="$identifier"/>
            </xsl:call-template>
            <p>
                <xsl:choose>
                    <xsl:when test="$footnoteBackLink = 'true'">
                        <a class="link_return" title="Pojdi nazaj k besedilu"
                            href="#{concat($identifier,'_return')}">
                            <sup>
                                <xsl:call-template name="noteN"/>
                                <xsl:if test="matches(@n, '[0-9]')">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </sup>
                        </a>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <sup>
                            <xsl:call-template name="noteN"/>
                            <xsl:if test="matches(@n, '[0-9]')">
                                <!--<xsl:text>.</xsl:text>-->
                            </xsl:if>
                            <xsl:text> </xsl:text>
                        </sup>
                    </xsl:otherwise>
                </xsl:choose>
                <span class="noteBody">
                    <xsl:apply-templates/>
                </span>
                <!--<xsl:if test="$footnoteBackLink = 'true'">
                    <xsl:text> </xsl:text>
                    <a class="link_return" title="Go back to text" href="#{concat($identifier,'_return')}">↵</a>
                </xsl:if>-->
            </p>
        </div>
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:if test="tei:head">
            <xsl:element name="{if (tei:isInline(.)) then 'span' else 'div' }">
                <xsl:attribute name="class">listhead</xsl:attribute>
                <xsl:apply-templates select="tei:head"/>
            </xsl:element>
        </xsl:if>
        <xsl:variable name="listcontents">
            <xsl:choose>
                <xsl:when test="@type = 'catalogue'">
                    <p>
                        <dl>
                            <xsl:call-template name="makeRendition">
                                <xsl:with-param name="default">false</xsl:with-param>
                            </xsl:call-template>
                            <xsl:for-each select="*[not(self::tei:head)]">
                                <p/>
                                <xsl:apply-templates mode="gloss" select="."/>
                            </xsl:for-each>
                        </dl>
                    </p>
                </xsl:when>
                <xsl:when test="@type = 'gloss' and tei:match(@rend, 'multicol')">
                    <xsl:variable name="nitems">
                        <xsl:value-of select="count(tei:item) div 2"/>
                    </xsl:variable>
                    <p>
                        <table>
                            <xsl:call-template name="makeRendition">
                                <xsl:with-param name="default">false</xsl:with-param>
                            </xsl:call-template>
                            <tr>
                                <td style="vertical-align:top;">
                                    <dl>
                                        <xsl:apply-templates mode="gloss"
                                            select="tei:item[position() &lt;= $nitems]"/>
                                    </dl>
                                </td>
                                <td style="vertical-align:top;">
                                    <dl>
                                        <xsl:apply-templates mode="gloss"
                                            select="tei:item[position() > $nitems]"/>
                                    </dl>
                                </td>
                            </tr>
                        </table>
                    </p>
                </xsl:when>
                <xsl:when test="tei:isGlossList(.)">
                    <dl>
                        <!-- se doda potencialni xml:id (nujno zaradi tipue search) -->
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="makeRendition">
                            <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                        <xsl:apply-templates mode="gloss"
                            select="*[not(self::tei:head or self::tei:trailer)]"/>
                    </dl>
                </xsl:when>
                <xsl:when test="tei:isGlossTable(.)">
                    <table>
                        <xsl:call-template name="makeRendition">
                            <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                        <xsl:apply-templates mode="glosstable"
                            select="*[not(self::tei:head or self::tei:trailer)]"/>
                    </table>
                </xsl:when>
                <xsl:when test="tei:isInlineList(.)">
                    <xsl:apply-templates select="*[not(self::tei:head or self::tei:trailer)]"
                        mode="inline"/>
                </xsl:when>
                <xsl:when test="@type = 'inline' or @type = 'runin'">
                    <p>
                        <xsl:apply-templates select="*[not(self::tei:head or self::tei:trailer)]"
                            mode="inline"/>
                    </p>
                </xsl:when>
                <xsl:when test="@type = 'bibl'">
                    <xsl:apply-templates select="*[not(self::tei:head or self::tei:trailer)]"
                        mode="bibl"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{if (tei:isOrderedList(.)) then 'ol' else 'ul'}">
                        <xsl:call-template name="makeRendition">
                            <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="starts-with(@type, 'ordered:')">
                            <xsl:attribute name="start">
                                <xsl:value-of select="substring-after(@type, ':')"/>
                            </xsl:attribute>
                        </xsl:if>
                        <!-- Na podalgi zgornjega zgleda sem uredil tako, da bom oblikovanje seznamov
                            uredil s pomočjo html atributov start in type. Zaradi te ureditve,
                            sem moral tudi dopolniti tei funkcijo isOrderedList -->
                        <xsl:if test="starts-with(@rend, 'ordered:')">
                            <xsl:choose>
                                <xsl:when test="number(substring-after(@rend, ':'))">
                                    <xsl:attribute name="start">
                                        <xsl:value-of select="substring-after(@rend, ':')"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="type">
                                        <xsl:value-of select="substring-after(@rend, ':')"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <!-- se doda potencialni xml:id (nujno zaradi tipue search) -->
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="*[not(self::tei:head or self::tei:trailer)]"/>
                    </xsl:element>
                    <xsl:apply-templates select="tei:trailer"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--
	<xsl:variable name="n">
      <xsl:number level="any"/>
    </xsl:variable>
    <xsl:result-document href="/tmp/list{$n}.xml">
      <xsl:copy-of select="$listcontents"/>
      </xsl:result-document>
      -->
        <xsl:apply-templates mode="inlist" select="$listcontents"/>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>whether a list is to be rendered as ordered</desc>
    </doc>
    <xsl:function name="tei:isOrderedList" as="xs:boolean">
        <xsl:param name="context"/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="tei:match(@rend,'numbered')">true</xsl:when>
                <xsl:when test="tei:match(@rend,'ordered')">true</xsl:when>
                <!-- dopolnil s spodnjim when -->
                <xsl:when test="starts-with(@rend, 'ordered:')">true</xsl:when>
                <xsl:when test="@type='ordered'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    

</xsl:stylesheet>
