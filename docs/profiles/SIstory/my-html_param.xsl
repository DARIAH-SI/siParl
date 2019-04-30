<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <!-- generična pot do css in js -->
    <!--<xsl:param name="path-general">../../../</xsl:param>-->
    <xsl:param name="path-general">http://www2.sistory.si/publikacije/</xsl:param>
    
    <!-- Če je chapterAsSIstoryPublications true, potem generirani HTML dokumenti posameznih div
        poglavij pripadajo samostojnim SIstory publikacijam. SIstory ID teh publikacij je 
        zapisan v idno[@type='sistory'], kateri je z corresp atributom usmerjen na ustrezne div. -->
    <xsl:param name="chapterAsSIstoryPublications"></xsl:param>
    
    <!-- If you want to have sticky title nav bar: true  -->
    <xsl:param name="title-bar-sticky">true</xsl:param>
    
    <!-- parametri za locale (večjezično navigacijo po skupinah HTML dokumentov s skupnim jezikom) -->
    <!-- če hočemo locale, mora biti vrednost spodnjega parametra true (prevzeto false) -->
    <xsl:param name="languages-locale">false</xsl:param>
    <!-- Določimo izhodiščni jezik za index.html (privzeto slovenščina sl).
         Za ostale jezike se nato procesira index-jezikovna_koda.html, npr. index-en.html za angleščino. -->
    <xsl:param name="languages-locale-primary">sl</xsl:param>
    
    <!-- za divGen[@type='teiHeader']: če je $element-gloss-teiHeader true,
        se izpišejo gloss imena za elemente, drugače je name() elementa -->
    <xsl:param name="element-gloss-teiHeader">true</xsl:param>
    <!-- za divGen[@type='teiHeader']: določi se jezik izpisa za gloss elementa, lahko samo za:
         - sl
         - en
    -->
    <xsl:param name="element-gloss-teiHeader-lang">sl</xsl:param>
    
    <!-- za tei:listPerson[@type='data'] | tei:listOrg[@type='data'] | tei:listEvent[@type='data']:
        če je $element-gloss-namesdates true,
        se izpišejo gloss imena za elemente, drugače je name() elementa -->
    <xsl:param name="element-gloss-namesdates">true</xsl:param>
    <!-- za tei:listPerson[@type='data'] | tei:listOrg[@type='data'] | tei:listEvent[@type='data']:
         določi se jezik izpisa za gloss elementa, lahko samo za:
         - sl
         - en
    -->
    <xsl:param name="element-gloss-namesdates-lang">sl</xsl:param>
    
    <!-- V html/head izpisani metapodatki -->
    <xsl:param name="description"></xsl:param>
    <xsl:param name="keywords"></xsl:param>
    <xsl:param name="title"></xsl:param>
    
    <xsl:param name="HTML5_declaracion"><![CDATA[<!DOCTYPE html>]]></xsl:param>
    
    <!-- če procesiramo teiCorpus: možnost, da odstranimo nadaljno procesiranje tei:TEI,
         saj se lahko pojavijo problemi (različne sezname (npr. slik, tabel ipd.) dela v celotnem korpusu in ne samo znotraj enega tei:TEI).
         V tem primeru posamezne tei:TEI procesiramo ločeno.
         Vrednost true, če želimo procesirati.
    -->
    <xsl:param name="processing-TEI-from-teiCorpus"></xsl:param>
    <!-- naslednji parametri imajo isto pri teiCorpus funkcijo kot divGen pri TEI -->
    <!-- če hočemo, da procesira teiHeader od teiCorpusa (podobno kot divGen[@type='teiHeader']) -->
    <xsl:param name="write-teiCorpus-teiHeader">true</xsl:param>
    <!-- če hočemo procesirati kolofon in cip pri teiCorpus (podobno kot divGen[@type='cip']) -->
    <xsl:param name="write-teiCorpus-cip">true</xsl:param>
    <!-- če hočemo procesirati kazalo vsebine tei:TEI vključenih v teiCorpus (podobno kot divGen[@type='toc'][@xml:id='titleAuthor')  -->
    <xsl:param name="write-teiCorpus-toc_titleAuthor">true</xsl:param>
    
</xsl:stylesheet>
