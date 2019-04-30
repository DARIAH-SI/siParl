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
      
    <xsl:template match="tei:listPerson[@type='data']|tei:listPlace[@type='data']|tei:listOrg[@type='data']|tei:listEvent[@type='data']">
        <dl>
            <dt>
                <xsl:choose>
                    <xsl:when test="$element-gloss-namesdates = 'true'">
                        <xsl:call-template name="node-gloss-namesdates"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name()"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@*">
                    <xsl:call-template name="namesdates-dl-atributes"/>
                </xsl:if>
            </dt>
            <dd>
                <xsl:call-template name="namesdates-dl"/>
            </dd>
        </dl>
    </xsl:template>
    
    <xsl:template name="namesdates-dl">
        <dl>
            <xsl:for-each select="*">
                <dt>
                    <xsl:if test=".[@xml:id]">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$element-gloss-namesdates = 'true'">
                            <xsl:call-template name="node-gloss-namesdates"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="name()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@*">
                        <xsl:call-template name="namesdates-dl-atributes"/>
                    </xsl:if>
                </dt>
                <xsl:if test="text() and child::*">
                    <dd>
                        <xsl:value-of select="text()"/>
                        <xsl:call-template name="namesdates-dl"/>
                    </dd>
                </xsl:if>
                <xsl:if test="not(text()) and child::*">
                    <dd>
                        <xsl:call-template name="namesdates-dl"/>
                    </dd>
                </xsl:if>
                <xsl:if test="text() and not(child::*)">
                    <dd>
                        <xsl:value-of select="text()"/>
                    </dd>
                </xsl:if>
                <xsl:if test="not(text()) and not(child::*)">
                    <dd></dd>
                </xsl:if>
            </xsl:for-each>
        </dl>    
    </xsl:template>
    
    <xsl:template name="namesdates-dl-atributes">
        <!--<xsl:variable name="here" select="*"/>
        <xsl:variable name="ptr" select="false()"/>-->
        <xsl:text> [</xsl:text>
        <xsl:for-each select="@*">
            <xsl:variable name="attribute-label">
                <xsl:variable name="attribute-name" select="name()"/>
                <xsl:variable name="attribute-gloss">
                    <xsl:for-each select="document('../teiLocalise-sl.xml')/tei:TEI/tei:text/tei:body/tei:classSpec//tei:attDef[@ident = $attribute-name]">
                        <xsl:choose>
                            <xsl:when test="tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]">
                                <xsl:value-of select="tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$attribute-name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>    
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($attribute-gloss) gt 0">
                        <xsl:value-of select="$attribute-gloss"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$attribute-name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$element-gloss-namesdates = 'true'">
                    <xsl:value-of select="concat($attribute-label,' = ')"/>
                    <xsl:choose>
                        <xsl:when test="contains(.,'#')">
                            <xsl:variable name="povezave">
                                <xsl:for-each select="tokenize(normalize-space(.),' ')">
                                    <povezava>
                                        <xsl:value-of select="."/>
                                    </povezava>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:for-each select="//*[@xml:id = substring-after($povezave/html:povezava,'#')]">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:apply-templates mode="generateLink" select="."/>
                                    </xsl:attribute>
                                    <xsl:value-of select="concat('#',@xml:id)"/>
                                </a>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(.,'http:') or contains(.,'https:')">
                            <xsl:for-each select="tokenize(normalize-space(.),' ')">
                                <a href="{.}" target="_blank">
                                    <xsl:value-of select="."/>
                                </a>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(name(),' = ',.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() != last()">
                <xsl:text> | </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template name="node-gloss-namesdates">
        <xsl:variable name="node-ident" select="name()"/>
        <xsl:variable name="node-names">
            <xsl:for-each select="document('../teiLocalise-sl.xml')/tei:TEI/tei:text/tei:body/tei:elementSpec[@ident = $node-ident]">
                <xsl:for-each select="tei:gloss">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$node-names/tei:gloss[@xml:lang = $element-gloss-namesdates-lang]">
                <xsl:value-of select="$node-names/tei:gloss[@xml:lang = $element-gloss-namesdates-lang]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$node-ident"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
  
</xsl:stylesheet>
