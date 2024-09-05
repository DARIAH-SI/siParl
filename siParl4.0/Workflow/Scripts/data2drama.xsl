<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:km="https://www.inz.si/sl/Znanstvenoraziskovalni-oddelek/Katja-Meden/"
	exclude-result-prefixes="xs xi tei" version="2.0">

	<xsl:output method="xml" indent="yes"/>
	<xsl:output encoding="UTF-8"/>

	<!--Input: Mappings.xml, output: drama/SDT8/*.xml-->
	
	<xsl:template match="mappings">
		<!-- Process each file in turn -->
		<xsl:for-each select="map">
			<xsl:variable name="target_document" select="target"/>
			<!--<xsl:message select="concat('INFO: Converting ', source, ' to ', target)"/>-->
			<xsl:result-document href="{concat('drama/', $target_document)}">
				<xsl:apply-templates select="document(source)">
					<xsl:with-param name="fileName" select="$target_document"/>
				</xsl:apply-templates>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

	<xsl:variable name="continuation">^\(nadaljevanje?\) ?</xsl:variable>


	<xsl:template name="fileDesc">
		<xsl:param name="workingBody"/>
		<fileDesc>
			<titleStmt>
				<title>
					<xsl:choose>
						<xsl:when test="matches($workingBody, 'KZP')">
							<xsl:text>Komisija za poslovnik</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KZNS')">
							<xsl:text>Komisija za narodni skupnosti</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KZPCPIEM')">
							<xsl:text>Komisija za peticije, človekove pravice in enake možnosti</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KZNOIVS')">
							<xsl:text>Komisija za nadzor obveščevalnih in varnostnih služb</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZG')">
							<xsl:text>Odbor za gospodarstvo</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZIOIP')">
							<xsl:text>Odbor za infrastrukturo, okolje in prostor</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZKGIP')">
							<xsl:text>Odbor za kmetijstvo, gozdarstvo in prehrano</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZF')">
							<xsl:text>Odbor za finance</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KZNJF')">
							<xsl:text>Komisija za nadzor javnih financ</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZZEU')">
							<xsl:text>Odbor za zadeve Evropske unije</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZZP')">
							<xsl:text>Odbor za zunanjo politiko</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZO')">
							<xsl:text>Odbor za obrambo</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZZ')">
							<xsl:text>Odbor za zdravstvo</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'PZSROVRS')">
							<xsl:text>Pododbor za spremljanje rakavih obolenj v Republiki Sloveniji</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZIZSIM')">
							<xsl:text>Odbor za izobraževanje, znanost, šport in mladino</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZDDSZII')">
							<xsl:text>Odbor za delo, družino, socialne zadeve in invalide</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KZOSSVZIPS')">
							<xsl:text>Komisija za odnose s Slovenci v zamejstvu in po svetu</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'UK')">
							<xsl:text>Ustavna komisija</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'MK')">
							<xsl:text>Mandatno-volilna komisija</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'SO')">
							<xsl:text>Skupni odbor</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZP')">
							<xsl:text>Odbor za pravosodje</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZNZJUILS')">
							<xsl:text>Odbor za notranje zadeve, javno upravo in lokalno samoupravo</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'PZSRT')">
							<xsl:text>Pododbor za spremljanje romske tematike</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'OZK')">
							<xsl:text>Odbor za kulturo</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'Skupna')">
							<xsl:text>Skupna seja</xsl:text>
						</xsl:when>
						<xsl:when test="matches($workingBody, 'KPDZ')">
							<xsl:text>Kolegij predsednika Državnega zbora</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>
								<xsl:value-of
									select="concat('Error: ', $workingBody, 'Missing full name')"/>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				<respStmt>
					<persName>Katja Meden</persName>
					<persName>Andrej Pančur</persName>
					<resp xml:lang="sl">Kodiranje TEI</resp>
					<resp xml:lang="en">TEI corpus encoding</resp>
				</respStmt>
			</titleStmt>
			<publicationStmt>
				<publisher>
					<orgName xml:lang="sl">Inštitut za novejšo zgodovino</orgName>
					<orgName xml:lang="en">Institute of Contemporary History</orgName>
					<ref target="http://www.inz.si/">http://www.inz.si/</ref>
					<address>
						<street>Kongresni trg 1</street>
						<settlement>Ljubljana</settlement>
						<postCode>1000</postCode>
						<country xml:lang="sl">Slovenija</country>
						<country xml:lang="en">Slovenia</country>
					</address>
					<email>inz@inz.si</email>
				</publisher>
				<distributor>DARIAH-SI</distributor>
				<distributor>CLARIN.SI</distributor>
				<availability status="free">
					<licence>http://creativecommons.org/licenses/by/4.0/</licence>
					<p xml:lang="en">This work is licensed under the <ref
							target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
							Attribution 4.0 International License.</ref></p>
					<p xml:lang="sl">To delo je ponujeno pod <ref
							target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
							Priznanje avtorstva 4.0 mednarodna licenca.</ref></p>
				</availability>
				<date>
					<xsl:attribute name="when">
						<xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
					</xsl:attribute>
				</date>
			</publicationStmt>
			<sourceDesc>
				<bibl type="mag">
					<idno type="URI">
						<xsl:text>https://www.dz-rs.si/wps/portal/Home/seje/sejeDT/poDatumu</xsl:text>
					</idno>
				</bibl>
			</sourceDesc>
		</fileDesc>
	</xsl:template>

	<xsl:template name="profileDesc">
		<xsl:param name="workingBody"/>
		<xsl:param name="title2"/>
		<xsl:param name="session_number"/>
		<xsl:param name="status"/>
		<xsl:param name="day_fixed"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="day_padded"/>
		<xsl:param name="month_padded"/>
		<profileDesc>
			<settingDesc>
				<setting>
					<xsl:attribute name="who">
						<xsl:value-of select="concat('#', $title2, '.', $workingBody)"/>
					</xsl:attribute>
					<xsl:attribute name="n">
						<xsl:value-of select="$session_number"/>
					</xsl:attribute>
					<name>
						<xsl:value-of select="$status"/>
					</name>
					<date>
						<xsl:attribute name="when">
							<xsl:value-of
								select="xs:date(concat($year, '-', $month_padded, '-', $day_padded))"
							/>
						</xsl:attribute>
					</date>
				</setting>
			</settingDesc>
			<particDesc>
				<listOrg>
					<org>
						<xsl:attribute name="xml:id">
							<xsl:value-of select="concat($title2, '.DZ')"/>
						</xsl:attribute>
						<orgName xml:lang="sl">
							<xsl:text>Državni zbor Republike Slovenije</xsl:text>
						</orgName>
						<listEvent>
							<head>Mandat</head>
							<event n="8" notBefore="2018-06-22" notAfter="2022-05-13">
								<label>
									<xsl:text>8.mandat (2018-2022)</xsl:text>
								</label>
							</event>
						</listEvent>
						<listOrg>
							<head>
								<xsl:text>Delovno telo Državnega zbora Republike Slovenije</xsl:text>
							</head>
							<org>
								<xsl:attribute name="xml:id">
									<xsl:value-of select="concat($title2, '.', $workingBody)"/>
								</xsl:attribute>
								<orgName>
									<xsl:attribute name="key">
										<xsl:value-of select="$workingBody"/>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="matches($workingBody, 'KZP')">
											<xsl:text>Komisija za poslovnik</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KZNS')">
											<xsl:text>Komisija za narodni skupnosti</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KZPCPIEM')">
											<xsl:text>Komisija za peticije, človekove pravice in enake možnosti</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KZNOIVS')">
											<xsl:text>Komisija za nadzor obveščevalnih in varnostnih služb</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZG')">
											<xsl:text>Odbor za gospodarstvo</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZIOIP')">
											<xsl:text>Odbor za infrastrukturo, okolje in prostor</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZKGIP')">
											<xsl:text>Odbor za kmetijstvo, gozdarstvo in prehrano</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZF')">
											<xsl:text>Odbor za finance</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KZNJF')">
											<xsl:text>Komisija za nadzor javnih financ</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZZEU')">
											<xsl:text>Odbor za zadeve Evropske unije</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZZP')">
											<xsl:text>Odbor za zunanjo politiko</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZO')">
											<xsl:text>Odbor za obrambo</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZZ')">
											<xsl:text>Odbor za zdravstvo</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'PZSROVRS')">
											<xsl:text>Pododbor za spremljanje rakavih obolenj v Republiki Sloveniji</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZIZSIM')">
											<xsl:text>Odbor za izobraževanje, znanost, šport in mladino</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZDDSZII')">
											<xsl:text>Odbor za delo, družino, socialne zadeve in invalide</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KZOSSVZIPS')">
											<xsl:text>Komisija za odnose s Slovenci v zamejstvu in po svetu</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'UK')">
											<xsl:text>Ustavna komisija</xsl:text>
										</xsl:when>

										<xsl:when test="matches($workingBody, 'MK')">
											<xsl:text>Mandatno-volilna komisija</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'SO')">
											<xsl:text>Skupni odbor</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZP')">
											<xsl:text>Odbor za pravosodje</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZNZJUILS')">
											<xsl:text>Odbor za notranje zadeve, javno upravo in lokalno samoupravo</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'PZSRT')">
											<xsl:text>Pododbor za spremljanje romske tematike</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'OZK')">
											<xsl:text>Odbor za kulturo</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'Skupna')">
											<xsl:text>Skupna seja</xsl:text>
										</xsl:when>
										<xsl:when test="matches($workingBody, 'KPDZ')">
											<xsl:text>Kolegij predsednika Državnega zbora</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:message>
												<xsl:value-of
												select="concat('Warning: ', $workingBody, 'Missing name')"
												/>
											</xsl:message>
										</xsl:otherwise>
									</xsl:choose>
								</orgName>
							</org>
						</listOrg>
					</org>
				</listOrg>
			</particDesc>
		</profileDesc>
	</xsl:template>

	<xsl:template match="root">
		<xsl:param name="fileName"/>
		<xsl:variable name="title" select="tokenize($fileName, '/')[2]"/>
		<xsl:variable name="title2" select="tokenize($title, '\.')[1]"/>
		<xsl:variable name="workingBody" select="tokenize($title, '-')[1]"/>
		<xsl:variable name="session_number" select="tokenize($title, '-')[2]"/>
		<xsl:variable name="status" select="tokenize($title, '-')[3]"/>
		<xsl:variable name="year" select="tokenize($fileName, '-')[4]"/>
		<xsl:variable name="month" select="tokenize($fileName, '-')[5]"/>
		<xsl:variable name="month_padded">
			<xsl:choose>
				<xsl:when test="string-length($month) = 1">
					<xsl:text>0</xsl:text>
					<xsl:value-of select="$month"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$month"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="day" select="tokenize($fileName, '-')[6]"/>
		<xsl:variable name="day_fixed" select="tokenize($day, '\.')[1]"/>
		<xsl:variable name="day_padded">
			<xsl:choose>
				<xsl:when test="string-length($day_fixed) = 1">
					<xsl:text>0</xsl:text>
					<xsl:value-of select="$day_fixed"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$day_fixed"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<TEI xml:id="{$title2}">
			<teiHeader>
				<xsl:call-template name="fileDesc">
					<xsl:with-param name="workingBody" select="$workingBody"/>
				</xsl:call-template>
				<xsl:call-template name="profileDesc">
					<xsl:with-param name="title2" select="$title2"/>
					<xsl:with-param name="workingBody" select="$workingBody"/>
					<xsl:with-param name="session_number" select="$session_number"/>
					<xsl:with-param name="status" select="$status"/>
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="month_padded" select="$month_padded"/>
					<xsl:with-param name="day_fixed" select="$day_fixed"/>
					<xsl:with-param name="day_padded" select="$day_padded"/>
				</xsl:call-template>
			</teiHeader>
			<text>
				<body>
					<div>
						<xsl:variable name="var1">
							<!-- Pass 1: Remove all unwanted tags and characters -->
							<xsl:apply-templates mode="pass1"/>
						</xsl:variable>
						<xsl:variable name="var1.5">
							<xsl:apply-templates select="$var1" mode="pass1.5"/>
						</xsl:variable>
						<xsl:variable name="var2">
							<xsl:apply-templates select="$var1.5" mode="pass2"/>
						</xsl:variable>
						<xsl:variable name="var3">
							<xsl:apply-templates select="$var2" mode="pass3"/>
						</xsl:variable>
						<xsl:variable name="var4">
							<xsl:apply-templates select="$var3" mode="pass4"/>
						</xsl:variable>
						<xsl:variable name="var5">
							<div>
								<xsl:apply-templates select="$var4" mode="pass5"/>
							</div>
						</xsl:variable>
						<xsl:variable name="var6">
							<xsl:apply-templates select="$var5" mode="pass6"/>
						</xsl:variable>
						<!--Pass 7: Merging broken paragraphs;
						This pass should also be used to produce the dump of speaker values.
						Workflow after this: 
						1.) from Mappings-full.xml produce a dump of speaker values, then
						2.) Produce csv file using list-person.xsl to then include fuzzy match values (Levensthein distance) with Who_mappings.py;
						2.) Manual edits of the output (save a copy to prevent accidental override)
						3.) Use insert_who.py script to insert the newly corrected values as @ana attributes to the listPerson.xml
						4.) Rerun this script with $var8 settin (or use separate xsl file "insert_speaker.xsl" if easyer) to replace values in the transcripts.-->
						<xsl:variable name="var7">
							<xsl:apply-templates select="$var6" mode="pass7"/>
						</xsl:variable>
						<!--Pass8: Replacing the values in the trancsript with corrected values, plus switching the order of values from
						NameSurname to SurnameName (and other variations, such as NameSurnameSurname...), also removing "SDT8:" tag-->
						<xsl:variable name="var8">
							<xsl:apply-templates select="$var7" mode="pass8"/>
						</xsl:variable>
						<!--Last pass, handling some incorectlly split speaker IDs. -->
						<xsl:variable name="var9">
							<xsl:apply-templates select="$var8" mode="pass9"/>
						</xsl:variable>
						<xsl:copy-of select="$var9"/>
					</div>
				</body>
			</text>
		</TEI>
	</xsl:template>

	<!--Pass1: Move everything to the TEI namespace, delete unnecessary elements and fix the most upper 
	problematic elements (h5, ul, ...)-->

	<xsl:template match="@*" mode="pass1">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="*" mode="pass1">
		<xsl:element name="{name()}" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:apply-templates select="@* | node()" mode="pass1"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="text()" mode="pass1">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

	<xsl:template match="font[not(normalize-space())]" mode="pass1"/>
	<xsl:template match="b[not(normalize-space())]" mode="pass1"/>
	<xsl:template match="br" mode="pass1"/>
	<xsl:template match="p" mode="pass1">
		<xsl:apply-templates mode="pass1"/>
	</xsl:template>
	<xsl:template match="h5[2]" mode="pass1"/>
	<xsl:template match="@color" mode="pass1"/>
	<xsl:template match="div[@align = 'right']" mode="pass1"/>
	<xsl:template match="sub" mode="pass1">
		<font size="4">
			<sub>
				<xsl:value-of select="font"/>
			</sub>
		</font>
	</xsl:template>

	<xsl:template match="a[@href]" mode="pass1">
		<font size="4">
			<ref>
				<xsl:attribute name="target">
					<xsl:value-of select="@href"/>
				</xsl:attribute>
				<xsl:value-of select="u/font"/>
			</ref>
		</font>
	</xsl:template>

	<xsl:template match="i" mode="pass1">
		<font size="4">
			<quote>
				<xsl:value-of select="."/>
			</quote>
		</font>
	</xsl:template>



	<xsl:template match="@* | node()" mode="pass1.5">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass1.5"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:b[not(ancestor::tei:div)]" mode="pass1.5">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when test="matches(tei:font, '^\($') and $following[self::tei:font]">
				<font size="4">
					<xsl:value-of select="concat(., $following[self::tei:font])"/>
				</font>
			</xsl:when>
			<xsl:when test="matches(tei:font, '^/$') and $preceding[self::tei:font]">
				<font size="4">
					<xsl:value-of select="concat('/', $preceding[self::tei:font], .)"/>
				</font>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass1.5"/>
					<xsl:apply-templates mode="pass1.5"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:font[not(ancestor::tei:div)]" mode="pass1.5">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when test="self::tei:font and $preceding[self::tei:b and matches(tei:font, '^/$')]"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass1.5"/>
					<xsl:apply-templates mode="pass1.5"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!--Pass2: Handling the preface -->

	<xsl:template match="@* | node()" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass2"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:ul" mode="pass2">
		<xsl:choose>
			<xsl:when test="tei:ul/tei:font[matches(., '^\d\.')]">
				<xsl:for-each select="tei:ul/tei:font[matches(., '^\d\.')]">
					<p>
					  <xsl:value-of select="."/>
					  <xsl:message select="concat('AGENDA:', .)"/>
					</p>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="tei:font[matches(., '^\d\.$')]"/>
			<xsl:when test="tei:font[matches(., '^\d\.')]">
			  <xsl:for-each select="tei:font[matches(., '^\d\.')]">
			    <p>
			      <xsl:value-of select="."/>
			    </p>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:h5[1]" mode="pass2">
		<head>
			<xsl:value-of select="tei:span"/>
		</head>
	</xsl:template>

	<xsl:template match="tei:div[@align = 'center']//tei:b" mode="pass2">
		<xsl:choose>
			<xsl:when test="
					matches(tei:font, '^\p{Lu}{2}')
					or matches(tei:font, '^\p{Lu}\s\p{Lu}+')">

				<!-- Starts with only one caps char: "V ZAMEJSTVU ..." -->

				<stage type="title">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>
			<xsl:when test="
					matches(tei:font, '\ssej[ae]|redna|nujna', 'i')">

				<!-- Broken in two: (, 27.november 2018)-->

				<stage type="session">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>
			<xsl:when test="matches(tei:font, '^\(?\d\.$')">
				<stage type="session">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>
			<xsl:when test="matches(tei:font, '\d{4}') and not(matches(., '\ssej[ae]'))">
				<stage type="date">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>
			<xsl:when test="matches(tei:font, '\d{4}') or matches(., '^\(3. in 4. junij\)$')">
				<!--In case of broken element: 2000-->
				<stage type="date">
					<xsl:value-of select="."/>
				</stage>
			</xsl:when>
			<xsl:when
				test="matches(tei:font, '^(in|In|Kolegij predsednika Državnega zbora|Mandatno-volilna komisija)$')">
				<stage type="title">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:message select="concat('VALUES: ', .)"/>
					<xsl:apply-templates select="@*" mode="pass2"/>
					<xsl:apply-templates mode="pass2"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template match="tei:b[not(ancestor::tei:div)]" mode="pass2">
		<xsl:choose>
			<!-- Chairman scenario: e.g., Sejo je vodil XY.-->
			<xsl:when
				test="self::tei:b[matches(tei:font, '^(Srečanje|Posvet|Sej|Skupno sejo|Skupno seja|Kolegij).*(vodi|vodila|vodili).*')]">
				<stage type="chairman">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>

			<!-- Magnetogram: Looking for exceptions witout TRAK or other caps characters, e.g., 11.45-->
			<xsl:when
				test="matches(., '^(-\s|–\s)?\d{1,2}\.\d{1,2}$') or matches(., '\d{1,2}\.\strak:')">
				<stage type="mag">
					<xsl:value-of select="tei:font"/>
				</stage>
			</xsl:when>

			<!-- Time: Looking for the pattern indicating the time, e.g., Skupna seja se je začela ob 13.20, seja se je zaključila ob 20:00.  -->
			<xsl:when test="
					matches(tei:font, '(Odprti|Srečanje|Posvet|Skupna seja|Sej|sej).*(začel|začeta|pričela|priča).*')
					or matches(tei:font, '(Odprti|Srečanje|Posvet|Skupna seja|Seja|sej).*(zaključ|zaklj|konč|preki|nadalj).*')">
				<stage type="time">
					<!--<xsl:message select="concat('time: ', .)"></xsl:message>-->
					<xsl:value-of select="."/>
				</stage>
			</xsl:when>

			<xsl:when test="matches(., '^(Katarina Kralj|Urša Regvar):$')">
				<speaker>
					<xsl:value-of select="."/>
				</speaker>
			</xsl:when>


			<!--                     SPEAKER ALL CAPS SCENARIOS:                 -->

			<xsl:when
				test="matches(tei:font, '^\d\.\p{Ll}?\sTOČK.*:$') or matches(tei:font, '\d\.\s?TOČK')">
				<!--<xsl:message select="concat('CHECK: ',.)"></xsl:message>-->
				<title>
					<xsl:value-of select="."/>
				</title>
			</xsl:when>
			<xsl:when test="matches(tei:font, '\p{Lu}{2}')">
				<!-- Select all elements that contain at least 2 caps characters, can include titles, speakers, time, and tracks:
					e.g., TOČKA DNEVNEGA REDA..., PREDSEDNICA EVA IRGL:, (SEJA SE JE ZAKLJUČILA OB 17:10), 25. TRAK etc. -->
				<xsl:choose>
					<!-- Handling record changes, e.g., 25. TRAK, 4.25. -->

					<xsl:when
						test="matches(., 'TRAK|TARK|TRKA|TRASK|TAK|TKRAK') or matches(., '\d\.\d{2}\s')">
						<stage type="mag">
							<!--<xsl:message select="concat('mag:', .)"></xsl:message>-->
							<xsl:value-of select="."/>
						</stage>
					</xsl:when>


					<!-- Speaker scenario 1: Classic speaker structure: NAME SURNAME:, e.g., ŽIŽA FELICE:, MAURIZIO TREMUL:; or 
					just the <font>PREDSEDNIK</font> or similar (PODPREDSEDNICA, PPREDSEDNIK etc).-->
					<xsl:when test="
							(self::tei:b[matches(tei:font, '\p{Lu}$')]
							and following-sibling::*[1][matches(., '(\(PS\s.*|\p{Lu})\)?:?$')])
							
							or matches(., ':$')
							or matches(., '^(PREDSEDNIK MAG\.|PREDSEDNIK|PREDSEDNICA|MAG\.?|PROF\.|DR\.?|DOC\.|DOC\. DR\.|PROF\. DR\.|PREDSDUJOČI|PODPREDSEDNICA|PODPREDSEDNIK)$')">
						<speaker>
							<!--<xsl:message select="concat('Classic speakers: ', .)"></xsl:message>-->
							<xsl:value-of select="."/>
						</speaker>
					</xsl:when>

					<xsl:when test="matches(tei:font, '/$')">
						<speaker>
							<xsl:value-of select="replace(., '/', '')"/>
						</speaker>
					</xsl:when>

					<xsl:when test="matches(tei:font, '…$')">
						<speaker>
							<xsl:value-of select="replace(., '…', '')"/>
						</speaker>
					</xsl:when>

					<!-- Scenario 2: String ends with a caps, and then followed immediately by text, that starts with ":" - 
					e.g., <b><font>ŽIŽA FELICE-</font></b> <font>: Hvala za besedo.</font> - <speaker>ŽIŽA FELICE:</speaker>-->

					<xsl:when test="
							self::tei:b[matches(tei:font, '(\p{Lu}|\)|_)$')]
							and (following-sibling::*[1][self::tei:font and matches(., '^:')]
							or following-sibling::*[1][self::tei:b and matches(., '^:')])">
						<speaker>
							<!--<xsl:message select="concat('Scenario 2: ', .)"></xsl:message>-->
							<xsl:value-of
								select="concat(self::tei:b[matches(tei:font, '(\p{Lu}|\)|_)$')], ':')"/>
							<!-- WARNING 1 - NORMALIZE_SPACE!!! -->
						</speaker>
					</xsl:when>

					<!-- Scenario 3: Similar as above, but it is dealing with following-sibling that starts with "):" - Could also maybe be 
						united with one above? E.g.: <b><font>ZVONKO ČERNAČ (PS SDS</font></b>\n <font>): Hvala za besedo</font> - 
					<speaker> ZVONKO ČERNAČ (PS SDS): </speaker>-->

					<xsl:when test="
							self::tei:b[matches(tei:font, '\w$')
							and following-sibling::*[1][self::tei:font and matches(., '^\):')]]">
						<speaker>
							<!--<xsl:message select="concat('Scenario 3: ', .)"></xsl:message>-->
							<xsl:value-of
								select="concat(self::tei:b[matches(tei:font, '\w$')], '):')"/>
						</speaker>
					</xsl:when>

					<!--Scenario 4: MATEJA UDOVČ (PS SMC): Hvala, DR. VASKO SIMONITI: H -  
					NOTE: WILL NEED TO BE THEN MERGED WITH following-sibling::*[1]: 
					<speaker>MATEJA UDOVČ (PS SMC): Hvala</speaker>
            		<font size="4"> lepa za besedo.]-->
					<xsl:when
						test="self::tei:b[matches(tei:font, '(:\s((\p{Lu}|\p{Lu}\p{Ll}+)|»|-)$)')]">
						<speaker>
							<!--<xsl:message select="concat('Scenario 4:', .)"></xsl:message>-->
							<xsl:value-of select="."/>
						</speaker>
					</xsl:when>

					<!-- Last two speaker scenarios: Catching string-specific speakers and renaming typos in speakers names.
					JANI (JANKO):, basically could also use xsl:otherwise, but that would be uncontrolled).
					-->
					<xsl:when test="
							self::tei:b[matches(tei:font, '^(JANI \(JANKO\)|JANI|JANKO)$')]
							or matches(tei:font, '^(BOŠTJAN KORAŽIJA \(PS Levica\)|EDVARD PAULIČ \(PS LMŠ\)|MAG. BOJANA MURŠIČ \(PS SD\)|MIHA KORDIŠ \(PS Levica\)|ZVONKO ČERNAČ \(PS SDS\))$')
							or matches(tei:font, '^(EVA IRGL \(PS SDS\)|ALENKA JERAJ \(PS SDS\)|ALENKA JERAJ|VLADISLAV ROŽIČ|ŽELJKO CIGLER \(PS Levica\)|JOŽE TANKO \(PS SDS\)|JOŽEF HORVAT \(PS NSi\))$')
							or matches(tei:font, '^(NATAŠA SUKIČ \(PS Levica\)|JANI PREDNIK \(PS SD\)|PREDSEDNICA VIOLETA TOMIĆ|PODPREDSEDNIK PREDRAG BAKOVIĆ|PREDSEDNIK ZVONKO ČERNAČ|MATJAŽ NEMEC \(PS SD\)|NATALIJA NEDELJKO|TAMARA GREGORČIČ|MONIKA GREGORČIČ \(PS SMC\)|GORAN LUKIĆ)$')">
						<!-- MAG. DEJAN KALOH, FELICE ŽIČA -->
						<speaker>
							<!--<xsl:message select="concat('Scenario 5:', .)"></xsl:message>-->
							<xsl:value-of select="concat(., ':')"/>
						</speaker>
					</xsl:when>
					<xsl:when test="matches(., '^FELICE ŽIČA$')">
						<speaker>
							<xsl:value-of select="replace(., 'FELICE ŽIČA', 'FELICE ŽIŽA')"/>
						</speaker>
					</xsl:when>
					<xsl:when
						test="matches(tei:font, '^(PREDSEDNIK MAG\. BRANKO GRIMS\.|MAG\. ALENKA BRATUŠEK\.|PREDSEDNIK GREGOR PERIČ\.|)$')">
						<speaker>
							<xsl:value-of select="replace(., '\.', ':')"/>
						</speaker>
					</xsl:when>


					<!-- Handling titles, from 1. TOČKA DNEVNEGA REDA, A1. TOČKA, 2. in 3. TOČKA DNEVNEGA REDA, as well as text in the middle that has no 
						clear pattern to separate it from the speakers without ":", matching it by words with the help of filtering through xsl:message -->
					<xsl:when test="
							matches(., '^(\p{Lu}\d|\d)|(\.|,|&quot;)$')
							or matches(., '(TOČK|PREDLOG|EVROP|RAZNO|točko|DOGOVOR|POZIV|MNENJE|POROČIL|PREDSTAVITEV|
							EVROPSKO|INDUSTRIJSKI|EPA|GOSPODARSTVU|RED|SICER|ZAKON|POSLOVNIK|MINISTRSTVO|POGOVOR|ODLOČITEV|UREDBE|OCENA|REPUBLIKI|RAČUN|TO JE NA|postopku)')
							or matches(., '^NE$')">
						<title>
							<!--<xsl:message select="concat('Title:', .)"></xsl:message>-->
							<xsl:value-of select="."/>
						</title>
					</xsl:when>

					<!-- Time of interrupted sessions with all-caps format: (SEJA JE BILA PREKINJENA OB 17:30)-->
					<xsl:when test="matches(., '^\(.*\)$')">
						<stage type="time">
							<xsl:value-of select="."/>
						</stage>
					</xsl:when>

					<!-- Otherwise, copy and produce message about the unfiltered values that are all caps. -->
					<xsl:otherwise>
						<!--<xsl:message select="concat('Values: ', .)"/>-->
						<xsl:copy>
							<xsl:apply-templates select="@*" mode="pass2"/>
							<xsl:apply-templates mode="pass2"/>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when
						test="matches(., '2019\.|Dogovor|naslednjo|zahteve|obravnav|točk|red|sej|postopk|Odbor|arhiva', 'i')">
						<!--<xsl:message select="concat('Title:', .)"></xsl:message>-->
						<title>
							<xsl:value-of select="."/>
						</title>
					</xsl:when>
					<xsl:when test="matches(., '^\d\.$') or matches(., '^\p{Lu}\d\.?$')">
						<!--<xsl:message select="concat('Title:', .)"></xsl:message>-->
						<title>
							<xsl:value-of select="."/>
						</title>
					</xsl:when>
					<xsl:when test="matches(., '^:$')"/>
					<xsl:when test="matches(., '^(\.|,|\d{1,2}\.?|!|–|preje|…|H|K)$')">
						<p>
							<xsl:value-of select="."/>
						</p>
					</xsl:when>
					<xsl:when test="matches(., '/nerazumljivo/|Mojci Škrinjar|najavo časa')">
						<p>
							<stage>
								<xsl:value-of select="."/>
							</stage>
						</p>
					</xsl:when>
					<xsl:when test="matches(., 'Kolegij')">
						<stage type="time">
							<xsl:value-of select="."/>
						</stage>
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:message select="concat('BAH values: ', .)"/>-->
						<xsl:copy>
							<xsl:apply-templates select="@*" mode="pass2"/>
							<xsl:apply-templates mode="pass2"/>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:font" mode="pass2">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:variable name="prolog">
			<xsl:analyze-string select="." regex="(/[^/]+/|\.\.\.|…|\((.*?\)))">
				<xsl:matching-substring>
					<xsl:choose>

						<!--Look at all of the /.*/ elements in text, e.g., / nerazumljivo/, but
						exclude the ones that are just regular slaches e.g, km/h, and 2019/2020-->
						<xsl:when
							test="matches(., '/[^/]+/') and not(matches(., '^/(\d{1,2}|h\s|API\s|rekla:|uro\s)'))">
							<!--<xsl:message select="concat('STAGE: ', .)"/>-->
							<stage>
								<xsl:value-of select="."/>
							</stage>
						</xsl:when>

						<!-- Catching the gap pattern (..., …)-->
						<xsl:when test="matches(., '\.\.\.') or matches(., '…')">
							<gap n="..."/>
						</xsl:when>


						<!-- Times (that are only in <font> elements and not in the <b><font>, 
						e.g., Skupna seja je bila prekinjena/se je nadaljevala-->
						<xsl:when test="matches(., '(Skupna seja|Seja).*(preki|nadalj).*')">
							<!--<xsl:message select="concat('seja: ', .)"/>-->
							<stage type="time">
								<xsl:value-of select="."/>
							</stage>
						</xsl:when>

						<!--Interruptions within text: get all of the text in brackets e.g., (da), (Ne), (23) (Nihče), but exlude the ones, 
						where (nadaljevanje) appears at the beginning of the string, as it needs to be processed
						differenty - will serve to concat broken-up fonts-->
						<xsl:when
							test="matches(., '\(.*\)') and not(matches(., '^\(nadaljevanje|\(nadaljevanj', 'i'))">
							<stage>
								<xsl:value-of select="."/>
							</stage>
						</xsl:when>
					</xsl:choose>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$prolog/*">
				<p>
					<xsl:copy-of select="$prolog"/>
				</p>
			</xsl:when>

			<xsl:when
				test="matches(., '(\p{Lu}|\p{Ll}|,)$') and $following[self::tei:font and matches(., '^(\p{Ll}|\.|,|-)') and not(matches(., '^\p{Ll}\)'))]">
				<p>
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:font and matches(., '^(\p{Ll}|\.|,|-)') and not(matches(., '^\p{Ll}\)'))])"
					/>
				</p>
			</xsl:when>
			<xsl:when
				test="self::tei:font[matches(., '^(\p{Ll}|\.|,|-)') and not(matches(., '^\p{Ll}\)'))] and $preceding[self::tei:font and matches(., '(\p{Lu}|\p{Ll}|,)$')]"/>
			<xsl:otherwise>
				<p>
					<xsl:value-of select="."/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




	<xsl:template match="@* | node()" mode="pass3">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass3"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="tei:stage[@type = 'mag']" mode="pass3"/>

	<xsl:template match="tei:speaker" mode="pass3">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when test="self::tei:speaker and $following[self::tei:speaker]">
				<speaker>
					<xsl:value-of select="concat(., ' ', $following[self::tei:speaker])"/>
				</speaker>
			</xsl:when>
			<xsl:when test="self::tei:speaker and $preceding[self::tei:speaker]"/>
			<xsl:when test="self::tei:speaker[matches(., '(:\s((\p{Lu}|\p{Lu}\p{Ll}+)|»|-)$)')]">
				<speaker>
					<xsl:value-of select="replace(., '(\s(\p{Lu}|\p{Lu}\p{Ll}+)|»|-)$', '')"/>
				</speaker>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass3"/>
					<xsl:apply-templates mode="pass3"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:title" mode="pass3">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="following2" select="following-sibling::*[2]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:variable name="preceding2" select="preceding-sibling::*[2]"/>
		<xsl:choose>
			<!-- Title Scenario 1: If three titles right after the other, merge and delete duplicated title. -->
			<xsl:when
				test="self::tei:title and $following[self::tei:title] and $following2[self::tei:title]">
				<!--<xsl:message select="concat('Three titles:',.)"></xsl:message>-->
				<title>
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:title], ' ', $following2[self::tei:title])"
					/>
				</title>
			</xsl:when>

			<xsl:when
				test="self::tei:title and $preceding[self::tei:title] and $following[self::tei:title]"/>

			<xsl:when
				test="self::tei:title and $preceding[self::tei:title] and $preceding2[self::tei:title]"/>


			<!-- Title Scenario 2: Merge title and tei:p if it contains . or , and delete duplicate. -->
			<xsl:when test="self::tei:title and $following[self::tei:p and matches(., '^(\.|,)$')]">
				<!--<xsl:message select="concat('Title and paragraph: ', .)"></xsl:message>-->
				<title>
					<xsl:value-of
						select="concat(., $following[self::tei:p and matches(., '^(\.|,)$')])"/>
				</title>
			</xsl:when>

			<!-- Title Scenario 3: Merge title, -, title, delete duplicates (one for deletion of the <p>-</p> is in the -->
			<xsl:when
				test="self::tei:title and $following[self::tei:p and matches(., '^-$')] and $following2[self::tei:title]">
				<!--<xsl:message select="concat('Title, paragraph, title: ', .)"></xsl:message>-->
				<title>
					<xsl:value-of select="concat(., ' - ', $following2[self::tei:title])"/>
				</title>
			</xsl:when>
			<xsl:when
				test="self::tei:title and $preceding[self::tei:p and matches(., '^-$')] and $preceding2[self::tei:title]"/>

			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass3"/>
					<xsl:apply-templates mode="pass3"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:stage[not(@*)]" mode="pass3">
		<xsl:variable name="prevText">
			<xsl:value-of select="preceding-sibling::text()[1]"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="matches(., '^\(') and contains($prevText, 'Kdo je za')">
				<stage type="vote-ayes">
					<!--<xsl:message select="concat('yes:', .)"/>-->
					<xsl:apply-templates select="@* | node()"/>
				</stage>
			</xsl:when>
			<xsl:when
				test="matches(., '^\(') and preceding-sibling::text()[1][matches(., 'Je kdo proti|Kdo je proti|Proti?')]">
				<!--<xsl:text>&#32;</xsl:text>-->
				<stage type="vote-no">
					<!--<xsl:message select="concat('noes:', .)"/>-->
					<xsl:apply-templates select="@* | node()"/>
				</stage>
			</xsl:when>
			<xsl:when
				test="matches(., '^\(') and preceding-sibling::text()[1][matches(., 'Vzdržani?|Kdo je vzdržan?')]">
				<!--<xsl:message select="concat('ABSTAIN:', .)"/>-->
				<stage type="vote">
					<xsl:apply-templates select="@* | node()"/>
				</stage>
			</xsl:when>
			<xsl:when test="matches(., '^\(\?\)$')">
				<gap reason="inaudible">
					<!--<xsl:message select="concat('GAP:', .)"/>-->
					<desc>
						<xsl:value-of select="."/>
					</desc>
				</gap>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:message select="concat('interuptions:', .)"/>-->
				<xsl:copy>
					<xsl:apply-templates select="@* | node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="tei:div[@align = 'center']//tei:p" mode="pass3">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when
				test="matches(., '^\(?1\.$') and $following[self::tei:stage[@type = 'session']]">
				<!--<xsl:message select="concat('CHECK1: ', .)"/>-->
				<stage type="session">
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:stage[@type = 'session']])"/>
				</stage>
			</xsl:when>
			<xsl:when test="matches(., '^\(?\d\.$')">
				<stage type="date">
					<xsl:value-of select="."/>
				</stage>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:message select="concat('CHECK2: ', .)"/>-->
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass3"/>
					<xsl:apply-templates mode="pass3"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:div[@align = 'center']//tei:stage" mode="pass3">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="following2" select="following-sibling::*[2]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:variable name="preceding2" select="preceding-sibling::*[2]"/>
		<xsl:choose>
			<xsl:when
				test="(self::tei:stage[@type = 'title'] and $following[self::tei:stage[@type = 'title']] and $following2[self::tei:stage[@type = 'title']]) and not(matches(., '^in$', 'i'))">
				<!--<xsl:message select="concat('Two titles: ', .)"></xsl:message>-->
				<stage type="title">
					<xsl:value-of
						select="concat(., ', ', $following[self::tei:stage[@type = 'title']], ', ', $following2[self::tei:stage[@type = 'title']])"
					/>
				</stage>
			</xsl:when>
			<xsl:when
				test="self::tei:stage[@type = 'title'] and $preceding[self::tei:stage[@type = 'title']] and $following[self::tei:stage[@type = 'title']]"/>
			<xsl:when
				test="self::tei:stage[@type = 'title'] and $preceding[self::tei:stage[@type = 'title']] and $preceding2[self::tei:stage[@type = 'title']]"/>

			<xsl:when
				test="self::tei:stage[@type = 'session'] and $following[self::tei:stage[@type = 'session']]">
				<stage type="session">
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:stage[@type = 'session']])"/>
				</stage>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass3"/>
					<xsl:apply-templates mode="pass3"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:p" mode="pass3">
		<!--First basic merging scenarios-->

		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<!-- Deleting ":" from <p> elements (if they start with ":"), correcting 
					the wrongly broken speaker "NAME SURNAME:" -->
			<xsl:when test="matches(., '^:$') and $preceding[self::tei:speaker]"/>
			<xsl:when test="matches(., '^:') and $preceding[self::tei:speaker]">
				<p>
					<xsl:value-of select="replace(., ':\s', '')"/>
				</p>
			</xsl:when>

			<!--Basic merging with of <p>.</p> with the previous tei:p-->
			<xsl:when test="matches(., '^(\.|,)$') and $preceding[self::tei:p]">
				<p>
					<xsl:value-of select="concat($preceding[self::tei:p], .)"/>
					<!--<xsl:message select="concat('Merging: ', $preceding[self::tei:p], '/////',.)"/>-->
				</p>
			</xsl:when>
			<xsl:when test="self::tei:p and $following[self::tei:p and matches(., '^(\.|,)$')]"/>

			<!-- Merging <p> that end with lowercase/UPPERCASE/, or ) and the following <p> 
					elements that start with lowercase, comma or other characters that signalise broken sentence.-->
			<xsl:when
				test="matches(., '(\p{Lu}|\p{Ll}|,|«)$') and $following[self::tei:p and matches(., '^(\p{Ll}|\.|,|-)') and not(matches(., '^\p{Ll}\)'))]">
				<p>
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:p and matches(., '^(\p{Ll}|\.|,|-)') and not(matches(., '^\p{Ll}\)'))])"
					/>
				</p>
			</xsl:when>
			<xsl:when
				test="self::tei:p[matches(., '^(\p{Ll}|\.|,|-|«)') and not(matches(., '^\p{Ll}\)'))] and $preceding[self::tei:p and matches(., '(\p{Lu}|\p{Ll}|,)$')]"/>

			<!--deletion of the merged "-" for title, -, title scenario-->
			<xsl:when
				test="self::tei:p[matches(., '^-$')] and $preceding[self::tei:title] and $following[self::tei:title]"/>

			<!--deletion of the punctuation (<p>.</p>) after merging it with title-->
			<xsl:when test="self::tei:p[matches(., '^(\.|,)$')] and $preceding[self::tei:title]"/>
			<xsl:otherwise>
				<!--<xsl:message select="concat('AHHHHHHHH: ', .)"/>-->
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass3"/>
					<xsl:apply-templates mode="pass3"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Pass4: Handle merging of the <div> elements so that they are correctly put together, merging <tei:p> and <tei:title> elements
		OPTIMIZATION START: first just remove all mergings for tei:p, as they might not even be working, but keep tei:title as it only handles those and not connected with tei:p, 
		except for one?, WAATT IS THIS SHIT-->

	<xsl:template match="@* | node()" mode="pass4">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass4"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:div[@align = 'center']//tei:stage" mode="pass4">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<!-- Deletion of the duplicte of two consecutive session stages in the preface -->
			<xsl:when
				test="self::tei:stage[@type = 'session'] and $preceding[self::tei:stage[@type = 'session']]"/>

			<!-- Merging two title stages is one of them is "in|IN" and removing duplicate-->
			<xsl:when
				test="self::tei:stage[@type = 'title' and matches(., '^in$', 'i')] and $following[self::tei:stage[@type = 'title']]">
				<stage type="title">
					<xsl:value-of
						select="concat(., ' ', $following[self::tei:stage[@type = 'title']])"/>
				</stage>
			</xsl:when>
			<xsl:when
				test="self::tei:stage[@type = 'title'] and $preceding[self::tei:stage[@type = 'title'] and matches(., '^in$', 'i')]"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass4"/>
					<xsl:apply-templates mode="pass4"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:title" mode="pass4">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>

			<!-- Title Scenario 1: If two titles right after the other, merge and delete duplicated title. -->

			<xsl:when test="self::tei:title and $following[self::tei:title]">
				<!--<xsl:message select="concat('pass4 title:',.)"></xsl:message>-->
				<title>
					<xsl:value-of select="concat(., ' ', $following[self::tei:title])"/>
					<!--<xsl:message select="concat('merging pass4',., '////////////', following-sibling::*[1][self::tei:title])"/>-->
				</title>
			</xsl:when>
			<xsl:when test="self::tei:title and $preceding[self::tei:title]"/>


			<!-- Deletion of the dupliated title that is left over after merging tei:p that ends with lowercase or , from the above template
			(match="tei:p" mode="pass4")-->

			<xsl:when test="self::tei:title and $preceding[self::tei:p[tei:title]]">
				<!--<xsl:message select="concat('DELETION pass4: ', preceding-sibling::*[1][self::tei:p[tei:title]], '/////', .)"/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass4"/>
					<xsl:apply-templates mode="pass4"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Pass5: Remove the <div @align='center'> and keep the content, manage merging of the tei:p and tei:title elements-->

	<xsl:template match="@* | node()" mode="pass5">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass5"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:div[@align = 'center']" mode="pass5">
		<xsl:apply-templates mode="pass5"/>
	</xsl:template>

	<xsl:template match="tei:p" mode="pass5">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when test="$following[self::tei:title]">
				<!--<xsl:message select="concat('CHECK: ', ., $following[self::tei:title])"/>-->
				<xsl:copy>
					<xsl:apply-templates select="@* | node()" mode="pass6"/>
					<xsl:text>&#32;</xsl:text>
					<xsl:apply-templates select="$following[self::tei:title]" mode="pass6"/>
					<!--<xsl:message select="concat('Merging: ', ., '/////', following-sibling::*[1][self::tei:stage[@type='title']])"/>-->
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass5"/>
					<xsl:apply-templates mode="pass5"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:title" mode="pass5">
		<xsl:variable name="following" select="following-sibling::*[1]"/>
		<xsl:variable name="preceding" select="preceding-sibling::*[1]"/>
		<xsl:choose>
			<xsl:when test="$preceding[self::tei:p]">
				<!--<xsl:message select="concat('CHECK: ', ., $following[self::tei:title])"/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass5"/>
					<xsl:apply-templates mode="pass5"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Pass6: Add <div> element to enable speaker recursive function (call template speaker) and manage normalize-space() for elements without any child nodes-->

	<xsl:template match="@* | node()" mode="pass6">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass6"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:div" mode="pass6">
		<xsl:call-template name="speaker_id"/>
	</xsl:template>

	<xsl:template match="tei:p/text()" mode="pass6">
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::* | following-sibling::*)">
				<!-- Normalize only if there are no other sibling elements -->
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Otherwise, keep the content unchanged -->
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="speaker_id">
		<xsl:for-each-group select="*" group-starting-with="tei:speaker">
			<!--<xsl:message select="concat('SPEAKER/TITLES:', .)"/>-->
			<xsl:choose>
				<xsl:when test="current-group()[1]/name() = 'speaker'">
					<!--and preceding-sibling::tei:br[preceding-sibling::tei:br]-->
					<sp>
						<!--<xsl:message select="concat('DEBUGGING: Added sp element: ', .)"/>-->
						<xsl:attribute name="who">
							<xsl:variable name="speaker_process"
								select="km:b2who(current-group()[1]//text())"/>
							<xsl:choose>
								<xsl:when
									test="matches($speaker_process, '(GOSPOD|GSOPOD)\s?(_+):?') or matches($speaker_process, '^GOSPOD:?$', 'i')">
									<xsl:text>SDT8:unknown-M</xsl:text>
								</xsl:when>
								<xsl:when
									test="matches($speaker_process, '(GOSPA)\s?(_+):?') or matches($speaker_process, '^GOSPA:?$', 'i')">
									<xsl:text>SDT8:unknown-F</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="speaker_n"
										select="tokenize($speaker_process, '\s')[1]"/>
									<xsl:variable name="speaker_n_clean">
										<xsl:value-of select="replace($speaker_n, '(\(.*\))', '')"/>
									</xsl:variable>
									<xsl:variable name="speaker_l">
										<xsl:value-of select="
												string-join(for $word in tokenize($speaker_process, '\s')[position() > 1]
												return
													concat(upper-case(substring($word, 1, 1)), lower-case(substring($word, 2))))"
										/>
									</xsl:variable>
									<xsl:variable name="speaker_l_join">
										<xsl:value-of select="string-join($speaker_l, .)"/>
									</xsl:variable>
									<xsl:variable name="speaker_low_n"
										select="concat(substring($speaker_n_clean, 1, 1), lower-case(substring($speaker_n_clean, 2)))"/>
									<xsl:variable name="speaker">
										<xsl:value-of
											select="concat('SDT8:', $speaker_low_n, $speaker_l)"/>
									</xsl:variable>
									<xsl:variable name="speaker_clean">
										<xsl:variable name="patterns"
											>(Gospod|Gospa|Mah\.|Mag\.|Mg\.|Ag\.|De\.|Dr\.|Mab\.|Mr\.|Redsednica|Nje\.Eksc\.)|(\(.*\))|(/.*/)|(\*\*\*\*)|–|:$|\)$|\.$</xsl:variable>
										<xsl:choose>
											<xsl:when test="matches($speaker, $patterns, 'i')">
												<xsl:value-of
												select="replace($speaker, $patterns, '', 'i')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$speaker"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="$speaker_clean"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:apply-templates select="current-group()" mode="pass6"/>
					</sp>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="current-group()" mode="pass6"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:template>


	<xsl:template match="@* | node()" mode="pass7">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass7"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:sp/tei:p" mode="pass7">
		<xsl:choose>
			<!-- Do not output elements that will be merged -->
			<xsl:when test="preceding-sibling::tei:p and km:merge-with-previous(.)"/>
			<!-- Maybe the following xsl:when should be deleted! -->
			<!--<xsl:when test="km:merge-with-next(.)"/>-->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="pass7"/>
					<xsl:copy-of select="node()"/>
					<!-- Insert content of following elements that should be merged, if any -->
					<xsl:apply-templates mode="merge" select="following-sibling::tei:*[1]"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Merge sp subordinate elements if conditions are met -->
	<xsl:template mode="merge" match="tei:sp/tei:*">
		<xsl:if test="km:merge-with-previous(.) or km:merge-with-next(.)">
			<!-- Insert a space except if counter-indicated -->
			<xsl:if test="not(matches(., '^[,;:]'))">
				<xsl:text>&#32;</xsl:text>
			</xsl:if>
			<!-- Process children to get rid of continuation string, if present -->
			<xsl:apply-templates mode="merge"/>
			<!-- Move on to following element -->
			<xsl:apply-templates mode="merge" select="following-sibling::tei:*[1]"/>
		</xsl:if>
	</xsl:template>

	<!-- Get rid of continuation string -->
	<xsl:template mode="merge" match="tei:*">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template mode="merge" match="text()">
		<xsl:value-of select="replace(., $continuation, '', 'i')"/>
	</xsl:template>



	<xsl:template match="@* | node()" mode="pass8">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass8"/>
		</xsl:copy>
	</xsl:template>



	<xsl:template match="tei:sp/@who" mode="pass8">
		<xsl:variable name="listPerson" select="document('../listPerson-list.xml')"/>
		<xsl:variable name="current_id" select="replace(., 'SDT8:', '')"/>
		<xsl:variable name="corrected_id"
			select="$listPerson//tei:person[@xml:id = $current_id]/@ana"/>
		<xsl:choose>
			<xsl:when test="$corrected_id">
				<!--<xsl:message select="concat('CHECK:', .)"/>-->
				<xsl:attribute name="who">
					<xsl:choose>
						<xsl:when
							test="matches($corrected_id, 'unknown-M') or matches($corrected_id, 'unknown-F')">
							<!--<xsl:message select="concat('Unknown:', .)"/>-->
							<xsl:choose>
								<xsl:when test="matches($corrected_id, 'unknown-M')">
									<text>unknown-M</text>
								</xsl:when>
								<xsl:when test="matches($corrected_id, 'unknown-F')">
									<text>unknown-F</text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:message select="concat('MISSING values:', $current_id)"/>
								</xsl:otherwise>
							</xsl:choose>
							<!--<xsl:message select="concat('Unknown CHECK:', .)"/>-->
						</xsl:when>

						<!-- Replace @who with corrected value -->
						<xsl:otherwise>
							<xsl:variable name="who" select="$corrected_id"/>
							<!--<xsl:variable name="inputString" select="replace($corrected_id, 'SDT8:', '')"/>-->
							<xsl:analyze-string select="$who"
								regex="([A-ZŽČŠĆĐÓÉÁ][a-zžčšćüđö0óéáüä]+)(([A-ZŽČŠĆĐÓÉÁáüä,\.-]+[a-zžčšćüđö0óéáüä]+)+)">
								<xsl:matching-substring>
									<xsl:variable name="name">
										<xsl:value-of select="regex-group(1)"/>
									</xsl:variable>
									<xsl:variable name="surname">
										<xsl:value-of select="regex-group(2)"/>
									</xsl:variable>
									<xsl:value-of select="concat($surname, $name)"/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:choose>
										<xsl:when test="matches($current_id, 'unknown-M')">
											<text>unknown-M</text>
										</xsl:when>
										<xsl:when test="matches($current_id, 'unknown-F')">
											<text>unknown-F</text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:message select="concat('Missing unmatched VALUES:', $current_id)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<!-- Keep the original @who value -->
				<xsl:attribute name="who">
					<xsl:choose>
						<xsl:when
							test="matches($corrected_id, 'unknown-M') or matches($corrected_id, 'unknown-F')">
							<xsl:value-of select="replace($current_id, 'SDT8:', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="remove" select="replace($current_id, 'SDT8:', '')"/>
							<xsl:analyze-string select="$remove"
								regex="([A-ZŽČŠĆĐÓÉ][a-zžčšćüđö0óé]+)(([A-ZŽČŠĆĐÓÉ,\.-]+[a-zžčšćüđö0óé]+)+)">
								<xsl:matching-substring>
									<xsl:variable name="name">
										<xsl:value-of select="regex-group(1)"/>
									</xsl:variable>
									<xsl:variable name="surname">
										<xsl:value-of select="regex-group(2)"/>
									</xsl:variable>
									<xsl:value-of select="concat($surname, $name)"/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:message select="concat('VALUES:', .)"/>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="@* | node()" mode="pass9">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="pass9"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:sp[@who ='MarijaColaričJakšeLea']/@who" mode="pass9">
		<xsl:message select="concat('Colaric @who:', .)"></xsl:message>
			<xsl:attribute name="who">
				<xsl:text>ColaričJakšeMarijaLea</xsl:text>
			</xsl:attribute>
</xsl:template>

	<!-- ////////////////////////////////////// FUNCTIONS: ////////////////////////////////////////// -->



	<xsl:function name="km:b2who">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="not(normalize-space($str))">
				<xsl:message terminate="no" select="concat('ERROR: No @who found in ', $str)"/>
			</xsl:when>
			<xsl:when test="matches($str, '(POD)?(PREDS\p{Lu}+|PPRE\p{Lu}+)\.?\s(DR\.|MAG\.)?')">
				<!--<xsl:message select="concat('VALUES TO BE CHECKED: ', $str)"/>-->
				<xsl:value-of
					select="km:b2who(replace($str, '(POD)?(PR\p{Lu}+|PP\p{Lu}+)\.?\s(DR\.|MAG\.)?\s?([^:]*):?', '$4'))"
				/>
			</xsl:when>
			<xsl:when
				test="matches($str, '^(IZR\.)?(PROF\.|PRIM\.|AS\.|DOC\.|DDR\.|ASIST\.)?(MAG\.|DR\.)?\s')">
				<xsl:value-of
					select="km:b2who(replace($str, '^(IZR\.)?(GOSPOD|GOSPA|PROF\.|PRIM\.|AS\.|DOC\.|DDR\.|ASIST\.)?(MAG\.|DR\.)?\s(\p{Lu}+):?', '$4'))"
				/>
			</xsl:when>
			<xsl:when test="matches($str, '\(PS\s\w+\)|\(PS\s\p{Lu}+\)|\(PS\sNP\s\w+\)')">
				<xsl:value-of
					select="km:b2who(replace($str, '\s?\(PS\s\w+\):?|\s?\(PS\s\p{Lu}+\):?|\s?\(PS\sNP\s\w+\):?', ''))"
				/>
			</xsl:when>
			<xsl:when test="matches($str, '(\(PS:\s\w+\)|:\s/$)')">
				<xsl:value-of select="km:b2who(replace($str, '(\(PS:\s\w+\)|:\s/$)', ''))"/>
			</xsl:when>
			<xsl:otherwise>
				<!--     <xsl:message select="concat('INFO: Returning value: ', $str)"/>-->
				<xsl:value-of select="replace($str, '^(.*?):\s*', '$1')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="km:merge-with-next" as="xs:boolean">
		<xsl:param name="element"/>
		<xsl:variable name="text" select="$element/."/>
		<xsl:choose>
			<!-- If it ain't a p, won't merge with next -->
			<xsl:when test="$element/name() != 'p'">
				<xsl:value-of select="false()"/>
			</xsl:when>
			<!-- If it ends with a mid-sentence punct, will merge with next -->
			<xsl:when test="matches($text, '[,;:]$')">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Otherwise (also if empty) won't merge with next -->
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Should $element be merged with previous element? -->
	<xsl:function name="km:merge-with-previous" as="xs:boolean">
		<xsl:param name="element"/>
		<xsl:variable name="text" select="$element/."/>
		<xsl:variable name="preceding" select="$element/preceding-sibling::*[1]"/>
		<xsl:choose>

			<!-- If it ain't a p, won't merge with previous -->
			<xsl:when test="$element/name() != 'p'">
				<xsl:value-of select="false()"/>
			</xsl:when>
			<!-- If it starts with a mid-sentence punct, will merge with previous -->
			<xsl:when test="matches($text, '^[,;:\d\.]')">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- If it starts with a lower case letter, will merge with previous -->
			<xsl:when test="matches($text, '^\p{Ll}')">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- If explicitly marked as continuation, will merge with previous -->
			<xsl:when test="matches($text, $continuation, 'i')">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Otherwise (also if empty) won't merge with previous -->
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
