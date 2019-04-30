<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html teidocx"
    version="2.0">
    
    <!-- iz ../../../html/html_figures.xsl -->
    <xsl:template match="tei:figure/tei:head">
        <xsl:variable name="captionlabel">
            <xsl:for-each select="..">
                <xsl:call-template name="calculateFigureNumber"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$outputTarget = 'html5'">
                <figcaption>
                    <xsl:call-template name="makeRendition">
                        <xsl:with-param name="default">caption</xsl:with-param>
                    </xsl:call-template>
                    <!-- na novo oblikovan izpis (bold in dvopičje) -->
                    <b><xsl:copy-of select="$captionlabel"/>
                        <xsl:if test="not($captionlabel = '')">
                            <xsl:text>: </xsl:text>
                        </xsl:if></b>
                    <xsl:apply-templates/>
                </figcaption>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{if (ancestor::tei:q) then 'span' else 'div'}">
                    <xsl:call-template name="makeRendition">
                        <xsl:with-param name="default">caption</xsl:with-param>
                    </xsl:call-template>
                    <xsl:copy-of select="$captionlabel"/>
                    <xsl:if test="not($captionlabel = '')">
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:graphic">
        <xsl:choose>
            <xsl:when test="parent::tei:figure[@type = 'chart']">
                <xsl:choose>
                    <xsl:when test=".[@mimeType = 'application/javascript']">
                        <xsl:variable name="chart-file" select="parent::tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']]/tei:graphic[@mimeType = 'application/javascript']/@url"/>
                        <xsl:variable name="chart-jsfile" select="document($chart-file)/html/body/script[last()]/@src"/>
                        <script src="{concat($graphicsPrefix,$chart-jsfile)}"></script>
                        <xsl:for-each select="document($chart-file)/html/body/div">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Sedaj ostalih formatov pri tei:figure[@type = 'chart'] ne procesira: 
                             če bo kdaj tako, da ne bo javascript grafikonov, temveč pri tei:figure[@type = 'chart']
                             samo slike (npr. jpg, jpeg, png, svg), potem uredi nadaljno procesiranje.
                        -->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- drugače je naprej procesiranje tako, kot je bilo v originalnem TEI Stylesheets -->
            <xsl:otherwise>
                <xsl:call-template name="showGraphic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- pri tabeli ni štelo Tabela 1 itd., zato sem to dodal -->
    <!-- makeRendition po noven ne naredi pri table elementu, temveč pri parent div elementu (zaradi česar se lahko doda clas/rend table-scroll) -->
    <xsl:template match="tei:table">
        <div>
            <!--<xsl:attribute name="class">
                <xsl:text>table</xsl:text>
                <xsl:if test="@align">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@align"/>
                </xsl:if>
            </xsl:attribute>-->
            <xsl:call-template name="makeRendition">
                <xsl:with-param name="default">false</xsl:with-param>
            </xsl:call-template>
            <xsl:if test="@xml:id">
                <xsl:call-template name="makeAnchor"/>
            </xsl:if>
            <table>
                <xsl:if test="tei:match(@rend, 'frame') or tei:match(@rend, 'rules')">
                    <xsl:attribute name="style"
                        >border-collapse:collapse;border-spacing:0;</xsl:attribute>
                </xsl:if>
                <xsl:for-each select="@*">
                    <xsl:if
                        test="name(.) = 'summary' or name(.) = 'width' or name(.) = 'border' or name(.) = 'frame' or name(.) = 'rules' or name(.) = 'cellspacing' or name(.) = 'cellpadding'">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="tei:head">
                    <!-- Dopolnim caption -->
                    <xsl:variable name="captionlabel">
                        <xsl:call-template name="calculateTableNumber"/>
                    </xsl:variable>
                    <caption>
                        <b><xsl:copy-of select="$captionlabel"/>
                            <xsl:if test="not($captionlabel = '')">
                                <xsl:text>: </xsl:text>
                            </xsl:if></b>
                        <xsl:apply-templates select="tei:head"/>
                    </caption>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="tei:row[tei:match(@rend, 'thead')]">
                        <thead>
                            <xsl:apply-templates select="tei:row[tei:match(@rend, 'thead')]"/>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="tei:row[not(tei:match(@rend, 'thead'))]"/>
                        </tbody>
                    </xsl:when>
                    <xsl:when test="tei:row[@role = 'label' and not(preceding::tei:row)]">
                        <thead>
                            <xsl:apply-templates
                                select="tei:row[@role = 'label' and not(preceding::tei:row)]"/>
                        </thead>
                        <tbody>
                            <xsl:apply-templates
                                select="tei:row[not(@role = 'label' and not(preceding::tei:row))]"/>
                        </tbody>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:row"/>
                    </xsl:otherwise>
                </xsl:choose>
            </table>
            <xsl:apply-templates select="tei:note"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <tr>
            <xsl:call-template name="makeRendition">
                <xsl:with-param name="default">false</xsl:with-param>
            </xsl:call-template>
            <!--<xsl:if test="@role">
            <xsl:attribute name="class">
               <xsl:value-of select="@role"/>
            </xsl:attribute>
         </xsl:if>-->
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <xsl:variable name="cellname">
            <xsl:choose>
                <xsl:when test="parent::tei:row[tei:match(@rend, 'thead')]">th</xsl:when>
                <!--<xsl:when test="parent::tei:row[@role = 'label' and not(preceding::tei:row)]"
               >th</xsl:when>-->
                <xsl:when test="parent::tei:row[@role = 'label']">th</xsl:when>
                <!-- dodama še spodnjo when možnost -->
                <xsl:when test=".[@role = 'label']">th</xsl:when>
                <xsl:otherwise>td</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$cellname}">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name(.) eq 'style'">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:when
                        test="
                        name(.) = 'width' or name(.) =
                        'border' or name(.) = 'cellspacing'
                        or name(.) = 'cellpadding'">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:when test="name(.) = 'rend' and starts-with(., 'width:')">
                        <xsl:attribute name="width">
                            <xsl:value-of select="substring-after(., 'width:')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.) = 'rend' and starts-with(., 'class:')">
                        <xsl:attribute name="class">
                            <xsl:value-of select="substring-after(., 'class:')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.) = 'rend' and starts-with(., 'style=')">
                        <xsl:attribute name="style">
                            <xsl:value-of select="substring-after(., 'style=')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.) = 'rend'">
                        <xsl:attribute name="class">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.) = 'cols'">
                        <xsl:attribute name="colspan">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.) = 'rows'">
                        <xsl:attribute name="rowspan">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="local-name(.) = 'align'">
                        <xsl:attribute name="align">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="@teidocx:align">
                    <xsl:attribute name="align">
                        <xsl:value-of select="@teidocx:align"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@align"/>
                <xsl:when test="not($cellAlign = 'left')">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:</xsl:text>
                        <xsl:value-of select="$cellAlign"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!--<xsl:if test="@role and not(@rend)">
            <xsl:attribute name="class">
               <xsl:value-of select="@role"/>
            </xsl:attribute>
         </xsl:if>-->
            <xsl:if test="ancestor::tei:table[tei:match(@rend, 'rules')] and not(@rend)">
                <xsl:attribute name="style">
                    <xsl:text>border: 1px solid black; padding: 2px;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:id">
                <xsl:call-template name="makeAnchor"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>