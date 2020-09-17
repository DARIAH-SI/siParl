<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni drama/*-list.xml (mogoče naredim skupni seznam datotek?) -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- vstavi ob procesiranju nove verzije -->
    <xsl:param name="edition">1.0</xsl:param>
    <!-- vstavim CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
    <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1345</xsl:param>
    <!-- vstavim datum od katerega naprej se smatra, da je COVID razprava -->
    <xsl:param name="covid-date">2019-11-01</xsl:param>
    
    <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
    
    <xsl:variable name="source-united-speaker-document">
        <xsl:copy-of select="document('speaker.xml')" copy-namespaces="no"/>
    </xsl:variable>
    
    <xsl:variable name="terms">
        <term n="1" start="1992-12-23" end="1996-11-28">1. mandat (1992-1996)</term>
        <term n="2" start="1996-11-28" end="2000-10-27">2. mandat (1996-2000)</term>
        <term n="3" start="2000-10-27" end="2004-10-22">3. mandat (2000-2004)</term>
        <term n="4" start="2004-10-22" end="2008-10-15">4. mandat (2004-2008)</term>
        <term n="5" start="2008-10-15" end="2011-12-15">5. mandat (2008-2011)</term>
        <term n="6" start="2011-12-16" end="2014-08-01">6. mandat (2011-2014)</term>
        <term n="7" start="2014-08-01" end="2018-06-22">7. mandat (2014-2018)</term>
        <!-- ni konec mandata, temveč takrat nazadnje narejen -->
        <term n="8" start="2018-06-22" end="2020-07-16">8. mandat (2018-)</term>
    </xsl:variable>
    
    <xsl:param name="taxonomy-legislature">
        <taxonomy xml:id="parla.legislature">
            <desc xml:lang="sl"><term>Zakonodajna oblast</term></desc>
            <desc xml:lang="en"><term>Legislature</term></desc>
            <category xml:id="parla.geo-political">
                <catDesc xml:lang="sl"><term>Geopolitične ali upravne enote</term></catDesc>
                <catDesc xml:lang="en"><term>Geo-political or administrative units</term></catDesc>
                <category xml:id="parla.supranational">
                    <catDesc xml:lang="sl"><term>Nadnacionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Supranational legislature</term></catDesc>
                </category>
                <category xml:id="parla.national">
                    <catDesc xml:lang="sl"><term>Nacionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>National legislature</term></catDesc>
                </category>
                <category xml:id="parla.regional">
                    <catDesc xml:lang="sl"><term>Regionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Regional legislature</term></catDesc>
                </category>
                <category xml:id="parla.local">
                    <catDesc xml:lang="sl"><term>Lokalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Local legislature</term></catDesc>
                </category>
            </category>
            <category xml:id="parla.organization">
                <catDesc xml:lang="sl"><term>Organiziranost</term></catDesc>
                <catDesc xml:lang="en"><term>Organization</term></catDesc>
                <category xml:id="parla.chambers">
                    <catDesc xml:lang="sl"><term>Zbori</term></catDesc>
                    <catDesc xml:lang="en"><term>Chambers</term></catDesc>
                    <category xml:id="parla.uni">
                        <catDesc xml:lang="sl"><term>Enodomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Unicameralism</term></catDesc>
                    </category>
                    <category xml:id="parla.bi">
                        <catDesc xml:lang="sl"><term>Dvodomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Bicameralism</term></catDesc>
                        <category xml:id="parla.upper">
                            <catDesc xml:lang="sl"><term>Zgornji dom</term></catDesc>
                            <catDesc xml:lang="en"><term>Upper house</term></catDesc>
                        </category>
                        <category xml:id="parla.lower">
                            <catDesc xml:lang="sl"><term>Spodnji dom</term></catDesc>
                            <catDesc xml:lang="en"><term>Lower house</term></catDesc>
                        </category>
                    </category>
                    <category xml:id="parla.multi">
                        <catDesc xml:lang="sl"><term>Večdomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Multicameralism</term></catDesc>
                        <category xml:id="parla.chamber">
                            <catDesc xml:lang="sl"><term>Zbor</term></catDesc>
                            <catDesc xml:lang="en"><term>Chamber</term></catDesc>
                        </category>
                    </category>
                </category>
                <category xml:id="parla.committee">
                    <catDesc xml:lang="sl"><term>Delovno telo</term></catDesc>
                    <catDesc xml:lang="en"><term>Committee</term></catDesc>
                    <category xml:id="parla.committee.standing">
                        <catDesc xml:lang="sl"><term>Stalno delovno telo</term></catDesc>
                        <catDesc xml:lang="en"><term>Standing committee</term></catDesc>
                    </category>
                    <category xml:id="parla.committee.special">
                        <catDesc xml:lang="sl"><term>Začasno delovno telo</term></catDesc>
                        <catDesc xml:lang="en"><term>Special committee</term></catDesc>
                    </category>
                    <category xml:id="parla.committee.inquiry">
                        <catDesc xml:lang="sl"><term>Preiskovalna komisija</term></catDesc>
                        <catDesc xml:lang="en"><term>Committee of inquiry </term></catDesc>
                    </category>
                </category>
            </category>
            <category xml:id="parla.term">
                <catDesc xml:lang="sl"><term>Zakonodajno obdobje</term></catDesc>
                <catDesc xml:lang="en"><term>Legislative period</term>: term of the parliament between
                    general elections.</catDesc>
                <category xml:id="parla.session">
                    <catDesc xml:lang="sl"><term>Parlamentaro zasedanje</term></catDesc>
                    <catDesc xml:lang="en"><term>Legislative session</term>: the period of time in which
                        a legislature is convened for purpose of lawmaking, usually being
                        one of two or more smaller divisions of the entire time between two
                        elections. A session is a meeting or series of connected meetings
                        devoted to a single order of business, program, agenda, or announced
                        purpose.</catDesc>
                    <category xml:id="parla.meeting">
                        <catDesc xml:lang="sl"><term>Seja</term></catDesc>
                        <catDesc xml:lang="en"><term>Meeting</term>: Each meeting may be a
                            separate session or part of a group of meetings constituting a
                            session. The session/meeting may take one or more
                            days.</catDesc>
                        <category xml:id="parla.meeting-types">
                            <catDesc xml:lang="sl"><term>Vrste sej</term></catDesc>
                            <catDesc xml:lang="en"><term>Types of meetings</term></catDesc>
                            <category xml:id="parla.meeting.regular">
                                <catDesc xml:lang="sl"><term>Redna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Regular meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.special">
                                <catDesc xml:lang="sl"><term>Posebna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Special meeting</term></catDesc>
                                <category xml:id="parla.meeting.extraordinary">
                                    <catDesc xml:lang="sl"><term>Izredna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Extraordinary meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.urgent">
                                    <catDesc xml:lang="sl"><term>Nujna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Urgent meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.ceremonial">
                                    <catDesc xml:lang="sl"><term>Slavnostna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Ceremonial meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.commemorative">
                                    <catDesc xml:lang="sl"><term>Žalna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Commemorative meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.opinions">
                                    <catDesc xml:lang="sl"><term>Javna predstavitev mnenj</term></catDesc>
                                    <catDesc xml:lang="en"><term>Public presentation of opinions</term></catDesc>
                                </category>
                            </category>
                            <category xml:id="parla.meeting.continued">
                                <catDesc xml:lang="sl"><term>Ponovni sestanek</term></catDesc>
                                <catDesc xml:lang="en"><term>Continued meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.public">
                                <catDesc xml:lang="sl"><term>Javna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Public meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.executive">
                                <catDesc xml:lang="sl"><term>Zaprta seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Executive meeting</term></catDesc>
                            </category>
                        </category>
                        <category xml:id="parla.sitting">
                            <catDesc xml:lang="sl"><term>Dan seje</term></catDesc>
                            <catDesc xml:lang="en"><term>Sitting</term>: sitting day</catDesc>
                        </category>
                    </category>
                </category>
            </category>
        </taxonomy>
    </xsl:param>
    
    <xsl:param name="taxonomy-speakers">
        <taxonomy xml:id="speaker_types">
            <desc xml:lang="sl"><term>Vrste govornikov</term></desc>
            <desc xml:lang="en"><term>Types of speakers</term></desc>
            <category xml:id="chair">
                <catDesc xml:lang="sl"><term>Predsedujoči</term>: predsedujoči zasedanja</catDesc>
                <catDesc xml:lang="en"><term>Chairperson</term>: chairman of a meeting</catDesc>
            </category>
            <category xml:id="regular">
                <catDesc xml:lang="sl"><term>Navadni</term>: navadni govorec na zasedanju</catDesc>
                <catDesc xml:lang="en"><term>Regular</term>: a regular speaker at a meeting</catDesc>
            </category>
        </taxonomy>
    </xsl:param>
    
    <xsl:param name="taxonomy-subcorpus">
        <taxonomy xml:id="subcorpus">
            <desc xml:lang="sl"><term>Podkorpusi</term></desc>
            <desc xml:lang="en"><term>Subcorpora</term></desc>
            <category xml:id="reference">
                <catDesc xml:lang="sl"><term>Referenca</term>: referenčni podkorpus, do 2019-10-31</catDesc>
                <catDesc xml:lang="en"><term>Reference</term>: reference subcorpus, until 2019-10-31</catDesc>
            </category>
            <category xml:id="covid">
                <catDesc xml:lang="sl"><term>COVID</term>: COVID podkorpus, od 2019-11-01 dalje</catDesc>
                <catDesc xml:lang="en"><term>COVID</term>: COVID subcorpus, from 2019-11-01 onwards</catDesc>
            </category>
        </taxonomy>
    </xsl:param>
    
    <xsl:variable name="persons">
        <person name="Andrej Pančur" ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424"/>
        <person name="Tomaž Erjavec" ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823"/>
        <person name="Mojca Šorn" ref="https://orcid.org/0000-0002-4457-1118 http://viaf.org/viaf/61069953"/>
        <person name="Mihael Ojsteršek" ref="http://viaf.org/viaf/86154440112735340300"/>
        <person name="Neja Blaj Hribar" ref="https://orcid.org/0000-0003-0606-6724"/>
    </xsl:variable>
    
    <xsl:variable name="dz-pages">
        <page n="SDZ1">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY5NDoIwFITPwgnea0tQlkWwNLQ04SfSbgwrQ6Lowqjx9DZx40aLs5vMfJkBBwO4ebxNh_E6nefx6L11yb6Spk0zwlE0MUVJqrRTWhGsEtiFCs7H-EUcA7x488v3TUq2KHsmYqY7RE2X8T8O_rcvCpL7gpalrDlFEYd46_nVx39RI8rSKGU2Pa4ZgxZsnoF9YEO6O1xOvdfwbHkUvQAaRujE/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ2">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY7NCsIwEISfpU-wm6ZUc4xat6FJA_3BJhfpSQpaPYiKT2_Aixdtndsw8zEDHjrwY38bDv11OI_9MXjn032hbC1WTCJVSYyKFaLRRjMsUthNFXyI8YskTvD05ufvW8G2qFpOCTcNoonn8T8O_rdPGduEglG5KmWMlEzxLvCLj_9UIqrcam3XLS45hxocgXtgxZo7XE5tUPesZRS9AAjWi7c!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ3">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY5LCsIwGITP0hP8k6ZUu4yvNDRpoA802UhXUtDqQlQ8vQE3brR1dsPMxwx52pEfult_6K79eeiOwTuf7gtl62zBBGSVxFCsyBptNEOR0nas4EOMLxIY4eWbn75vM7aBarlMuGkAE0_jfxz8b1-u2SoUjMpVKWLIZIx3gZ99_JcloHKrtV22mHNONbmc3AMVa-50ObVBu2ctougFSM4Raw!!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ4">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY7NCsIwEISfpU-wm6ZUc4xa06VJA_3BJhfpSQpaPYiKT2_Aixdtndsw8zEDHjrwY38bDv11OI_9MXjn031BthYrJlFVSYzECtFooxkWKeymCj7E-EUSJ3j15ufvW8G2SC1XCTcNoonn8T8O_revMrYJBUM5lTJGlUzxLvCLj_-qRKTcam3XLS45hxocgXtgxZo7XE5tUPesZRS9AIiqOXw!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ5">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY5NDoIwFITPwgnea0vQLutfqbQ0oRBpN4aVIVF0YdR4epu4caPg7CYzX2YgQAth6G79obv256E7Ru9Dti-UdXxBBMoqpahIwWttNMEig91YIcQYv0jgCC_f_PR9y8kGVcNkykyNaOg0_sfB__blmqxiwahclYKiTMd4H_nZx39ZIqrcam2XDc4ZAwd-C_6BFanvcDk1Ue3TiSR5AcgHQUU!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ6">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY6xDoIwGISfhSf4_1KCMlbF0rSlCZRIuxgmQ6LoYNT49DZxcdHibZe7L3fgoQc_DbfxMFzH8zQcg3c-30th2mJFGPImS1EQWVilFUGZwy5W8CHGL2IY4fmbn79vCrJF0VGeUW0RdTqP_3Hwv31ekk0oaFGJmqXIsxjvAr_4-M9rRFEZpcy6wyWl0IKT4B7YEHuHy6kL6p8tS5IXCGNpUg!!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ7">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/lY5LCsIwGITP0hP8k6ZUu4yvNDRpoA802UhXUtDqQlQ8vQE3brR1dsPMxwx52pEfult_6K79eeiOwTuf7gtl62zBBGSVxFCsyBptNEOR0nas4EOMLxIY4eWbn75vM7aBarlMuGkAE0_jfxz8b1-u2SoUjMpVKWLIZIx3gZ99_JcloHKrtV22mHNONTlN7oGKNXe6nNqg3bMWUfQCSF2wNw!!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDZ8">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDrzavnegaZbora/PoDatumuSeje/!ut/p/z1/04_Sj9CPykssy0xPLMnMz0vMAfIjo8zivT39gy2dDB0N3INMjAw8Db0tQ3x8fQwNvM30wwkpiAJKG-AAjgYE9LtD9BNvv7-loZuBZ6ixu4mxb4iBga8RcfrxOJCA_oLcUCBwVAQAGc0QlQ!!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OGN00IHOLLOCU0833=CZ6_KIOS9B1A0GR420I1K9TLML10K6=LA0=Ejavax.servlet.include.path_info!QCPSejeSejaPoDatumuView.jsp==/#Z7_KIOS9B1A0OGN00IHOLLOCU0833</page>
        <page n="SDT2">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7BCoJAFEW_xS947-mguByrGQedBEfNmU24CqGsRVT09c0yiiLp7i6cc7ngoAc3DZdxN5zH4zTsfbcu3haqMmlGHOWKlqhIq1yteYiSweYFqFnogSJtSl0SFjG4f3w5169SEqjaSLJIN4g6_M3HD-E49_8b4L7PW-8nT_-7PEGVG2KmE4QLBgasyMDesKbmCqdD69PfDQ-CBx96qus!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
        <page n="SDT3">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7NCoJAFIWfxSe49-qguJx-HAcdBUfNmU3MKoSyFlHR0zfLKIqkszvwfYcDFgawk7uMO3cej5Pb-25svC1krdMFcRRrWqEkJXNZ8RAFg80L0LDQA0XalqokLGKw__hirl-nlKHsIsEi1SKq8DcfP4Tj3P9vgP0-b7yfPP3v8wRlronpPiNcMtBgKjA3bKi9wunQ-Qx3zYPgAXTf8Bo!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
        <page n="SDT4">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7NCoJAFIWfxSe49-qguJx-HAedBEfNmY3MKoSyFlHR0zfLKIqkszvwfYcDFnqwk7uMO3cej5Pb-25sPBSy0umCOIo1rVCSkrnc8BAFg-0LULPQA0XalKokLGKw__hirl-llKFsI8Ei1SCq8DcfP4Tj3P9vgP0-b7yfPP3v8gRlronpLiNcMtBgKjA3rKm5wunQ-vR3zYPgAbS72A0!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
        <page n="SDT5">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7LDoIwFES_hS-490IDYVkflKZUDAWk3RhWhkTRhVHj19ul0Wgkzm6ScyYDDjpwY38Zdv15OI793nfr4q2SpUlnxFEsaYGStMzliocoGGxegIqFHlBpXeiCUMXg_vHFVL9MKUPZRIJFukbU4W8-fgjHqf_fAPd93no_efrf5gnK3BAzbUY4Z2DArsHesKL6CqdD49PdDQ-CB7XptXg!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
        <page n="SDT6">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7BCoJAFEW_xS947-mguBwrx0EnwVFzZhOzCqGsRVT09c0yiiLp7i6cc7lgYQA7ucu4c-fxOLm978bG21LWOs2Io1jREiUpWcg1D1Ew2LwADQs9UKZtpSrCMgb7jy_m-nVKOcouEixSLaIKf_PxQzjO_f8G2O_zxvvJ0_--SFAWmpjuc8IFAw2GZ2Bu2FB7hdOh8xnumgfBA7HiE50!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
        <page n="SDT7">https://www.dz-rs.si/wps/portal/Home/deloDZ/seje/sejeDt/poDatumu/!ut/p/z1/pY7BCoJAFEW_xS947-mguBwrx0EnwVFzZhOzCqGsRVT09c0yiiLp7i6cc7lgYQA7ucu4c-fxOLm978bG21LWOs2Io1jREiUpWcg1D1Ew2LwADQs9UKZtpSrCMgb7jy_m-nVKOcouEixSLaIKf_PxQzjO_f8G2O_zxvvJ0_--SFAWmpjuc8IFAw0my8DcsKH2CqdD5zPcNQ-CB4zb9us!/dz/d5/L2dBISEvZ0FBIS9nQSEh/p0/IZ7_KIOS9B1A0OVH70IHS14SVF10C4=CZ6_KIOS9B1A0GE1D0I1MIHINA20G4=LA0=Ejavax.servlet.include.path_info!QCPSejeSejeDTPoDatumuView.jsp==/#Z7_KIOS9B1A0OVH70IHS14SVF10C4</page>
    </xsl:variable>
    
    <xsl:template match="documentsList">
        <xsl:variable name="corpus-label" select="tokenize(ref[1],'/')[1]"/>
        <xsl:variable name="corpus-term" select="substring($corpus-label,4,4)"/>
        <xsl:variable name="corpus-document" select="concat('../ParlaMint/',$corpus-label,'.xml')"/>
        <xsl:variable name="source-corpus-document" select="concat('drama/',$corpus-label,'.xml')"/>
        <xsl:variable name="source-speaker-document" select="concat('drama/',$corpus-label,'-speaker.xml')"/>
        <xsl:result-document href="{$corpus-document}">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:id="siParl.{$corpus-label}" xml:lang="sl">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <xsl:choose>
                                <xsl:when test="matches($corpus-label,'^SDZ')">
                                    <title type="main" xml:lang="sl">Dobesedni zapis sej Državnega zbora Republike Slovenije</title>
                                    <title type="main" xml:lang="en">Verbatim record of sessions of the National Assembly of the Republic of Slovenia</title>
                                </xsl:when>
                                <xsl:when test="matches($corpus-label,'^SDT')">
                                    <title type="main" xml:lang="sl">Dobesedni zapis sej delovnih teles Državnega zbora Republike Slovenije</title>
                                    <title type="main" xml:lang="en">Verbatim record of sessions of the working bodies of the National Assembly of the Republic of Slovenia</title>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>Neznana oznaka <xsl:value-of select="$corpus-label"/></xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                            <title type="sub" xml:lang="sl">
                                <xsl:value-of select="$terms/tei:term[@n=$corpus-term]"/>
                            </title>
                            <meeting n="{number($corpus-term)}" corresp="#DZ" ana="#parla.term #DZ.{$corpus-term}">
                                <xsl:value-of select="$corpus-term"/>
                                <xsl:text>. mandat</xsl:text>
                            </meeting>
                            <xsl:for-each-group select="document($source-corpus-document)/tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt" group-by="tei:persName">
                                <respStmt>
                                    <persName>
                                        <xsl:if test="$persons/tei:person[@name = current-grouping-key()]">
                                            <xsl:attribute name="ref">
                                                <xsl:value-of select="$persons/tei:person[@name = current-grouping-key()]/@ref"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </persName>
                                    <resp xml:lang="sl">Kodiranje TEI</resp>
                                    <resp xml:lang="en">TEI corpus encoding</resp>
                                </respStmt>
                            </xsl:for-each-group>
                            <xsl:for-each-group select="document($source-speaker-document)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt" group-by="tei:persName">
                                <respStmt>
                                    <persName>
                                        <xsl:if test="$persons/tei:person[@name = current-grouping-key()]">
                                            <xsl:attribute name="ref">
                                                <xsl:value-of select="$persons/tei:person[@name = current-grouping-key()]/@ref"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </persName>
                                    <resp xml:lang="sl">Urejanje seznama govornikov</resp>
                                    <resp xml:lang="en">Editing a list of speakers</resp>
                                </respStmt>
                            </xsl:for-each-group>
                            <funder>
                                <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
                                <orgName xml:lang="en">The CLARIN research infrastructure</orgName>
                            </funder>
                        </titleStmt>
                        <editionStmt>
                            <edition>
                                <xsl:value-of select="$edition"/>
                            </edition>
                        </editionStmt>
                        <extent>
                            <!--<xsl:variable name="count-files" select="count(ref)"/>
                            <measure unit="texts" quantity="{$count-files}" xml:lang="sl">
                                <xsl:value-of select="format-number($count-files,'###.###','euro')"/>
                                <xsl:text> besedil</xsl:text>
                            </measure>
                            <measure unit="texts" quantity="{$count-files}" xml:lang="en">
                                <xsl:value-of select="format-number($count-files,'###,###')"/>
                                <xsl:text> texts</xsl:text>
                            </measure>-->
                            <!-- Štetje besed -->
                            <xsl:variable name="counting">
                                <xsl:for-each select="ref">
                                    <string>
                                        <xsl:apply-templates select="document(.)/tei:TEI/tei:text/tei:body"/>
                                    </string>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
                            <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
                            <measure unit="words" quantity="{$count-words}" xml:lang="sl">
                                <xsl:value-of select="format-number($count-words,'###.###','euro')"/>
                                <xsl:text> besed</xsl:text>
                            </measure>
                            <measure unit="words" quantity="{$count-words}" xml:lang="en">
                                <xsl:value-of select="format-number($count-words,'###,###')"/>
                                <xsl:text> words</xsl:text>
                            </measure>
                        </extent>
                        <publicationStmt>
                            <publisher>
                                <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
                                <orgName xml:lang="en">CLARIN research infrastructure</orgName>
                                <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
                            </publisher>
                            <idno type="handle">http://hdl.handle.net/XXXX</idno>
                            <xsl:if test="string-length($clarinHandle) gt 0">
                                <pubPlace>
                                    <xsl:value-of select="$clarinHandle"/>
                                </pubPlace>
                            </xsl:if>
                            <availability status="free">
                                <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                                <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Attribution 4.0 International License</ref>.</p>
                                <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                            </availability>
                            <date when="{current-date()}"><xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/></date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title type="main">Website of the National Assembly of the Republic of Slovenia</title>
                                <title type="sub">Hansard</title>
                                <idno type="URI">
                                    <xsl:value-of select="$dz-pages/tei:page[@n=$corpus-label]"/>
                                </idno>
                                <date>
                                    <xsl:attribute name="from">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@start"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="to">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@end"/>
                                    </xsl:attribute>
                                    
                                </date>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <editorialDecl>
                            <correction>
                                <p>No correction of source texts was performed. Only apparently typed errors were corrected.</p>
                            </correction>
                            <hyphenation>
                                <p>No end-of-line hyphens were present in the source.</p>
                            </hyphenation>
                            <quotation>
                                <p>Quotation marks have been left in the text and are not explicitly marked up.</p>
                            </quotation>
                            <segmentation>
                                <p>The texts are segmented into utterances (speeches) and segments (corresponding to paragraphs in the source transcription).</p>
                            </segmentation>
                        </editorialDecl>
                        <classDecl>
                            <xsl:copy-of select="$taxonomy-legislature"/>
                            <xsl:copy-of select="$taxonomy-speakers"/>
                            <xsl:copy-of select="$taxonomy-subcorpus"/>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                        <settingDesc>
                            <setting>
                                <name type="city">Ljubljana</name>
                                <name type="country" key="SI">Slovenija</name>
                                <date ana="#parla.term">
                                    <xsl:attribute name="from">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@start"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="to">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@end"/>
                                    </xsl:attribute>
                                </date>
                            </setting>
                        </settingDesc>
                        <particDesc>
                            <listOrg>
                                <org xml:id="DZ" role="parliament" ana="#parla.national #parla.lower">
                                    <orgName xml:lang="sl">Državni zbor Republike Slovenije</orgName>
                                    <orgName xml:lang="en">National Assembly of the Republic of Slovenia</orgName>
                                    <event from="1992-12-23">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia"
                                        >https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
                                    <listEvent>
                                        <head>Legislative period</head>
                                        <!-- odstranil odvečne mandate -->
                                        <event xml:id="DZ.7" from="2014-08-01" to="2018-06-21">
                                            <label xml:lang="sl">7. mandat</label>
                                            <label xml:lang="en">Term 7</label>
                                        </event>
                                        <event xml:id="DZ.8" from="2018-06-22">
                                            <label xml:lang="sl">8. mandat</label>
                                            <label xml:lang="en">Term 8</label>
                                        </event>
                                    </listEvent>
                                    <xsl:if test="matches($corpus-label,'^SDT')">
                                        <listOrg xml:id="workingBodies">
                                            <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                                            <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                                            <xsl:for-each-group select="document($source-corpus-document)/tei:teiCorpus/tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org" group-by="tei:orgName/@key">
                                                <xsl:sort select="normalize-space(current-group()[1]/tei:orgName)"/>
                                                <org xml:id="{current-grouping-key()}" ana="#parla.committee">
                                                    <orgName>
                                                        <xsl:value-of select="normalize-space(current-group()[1]/tei:orgName)"/>
                                                    </orgName>
                                                </org>
                                            </xsl:for-each-group>
                                        </listOrg>
                                    </xsl:if>
                                </org>
                                <org xml:id="GOV" role="government">
                                    <orgName xml:lang="sl">Vlada Republike Slovenije</orgName>
                                    <orgName xml:lang="en">Government of the Republic of Slovenia</orgName>
                                    <event from="1990-05-16">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Vlada_Republike_Slovenije</idno>
                                    <listEvent>
                                        <event xml:id="GOV.11" from="2013-03-20" to="2014-09-18">
                                            <label>11. vlada Republike Slovenije (20. marec 2013 - 18. september
                                                2014)</label>
                                        </event>
                                        <event xml:id="GOV.12" from="2014-09-18" to="2018-09-13">
                                            <label>12. vlada Republike Slovenije (18. september 2014 - 13. september
                                                2018)</label>
                                        </event>
                                        <event xml:id="GOV.13" from="2018-09-13" to="2018-03-13">
                                            <label>13. vlada Republike Slovenije (13. september 2018 - 13. marec 2020)</label>
                                        </event>
                                        <event xml:id="GOV.14" from="2018-03-13">
                                            <label>14. vlada Republike Slovenije (13. marec 2020 - danes)</label>
                                        </event>
                                    </listEvent>
                                </org>
                                <org xml:id="party.PS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Pozitivna Slovenija</orgName>
                                    <orgName full="yes" xml:lang="en">Positive Slovenia</orgName>
                                    <orgName full="init">PS</orgName>
                                    <event from="2011-10-22">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Pozitivna_Slovenija</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Positive_Slovenia</idno>
                                </org>
                                <org xml:id="party.DL" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Državljanska lista</orgName>
                                    <orgName full="yes" xml:lang="en">Civic List</orgName>
                                    <orgName full="init">DL</orgName>
                                    <event from="2012-04-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Dr%C5%BEavljanska_lista</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Civic_List_(Slovenia)</idno>
                                </org>
                                
                                <org xml:id="party.DeSUS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Demokratična stranka upokojencev
                                        Slovenije</orgName>
                                    <orgName full="yes" xml:lang="en">Democratic Party of Pensioners of
                                        Slovenia</orgName>
                                    <orgName full="init">DeSUS</orgName>
                                    <event from="1991-05-30">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Demokrati%C4%8Dna_stranka_upokojencev_Slovenije</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Democratic_Party_of_Pensioners_of_Slovenia</idno>
                                </org>
                                <org xml:id="party.Levica.1" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Združena levica</orgName>
                                    <orgName full="yes" xml:lang="en">United Left</orgName>
                                    <orgName full="init">Levica</orgName>
                                    <event from="2014-03-01" to="2017-06-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/United_Left_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.Levica.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Levica</orgName>
                                    <orgName full="yes" xml:lang="en">The Left</orgName>
                                    <orgName full="init">Levica</orgName>
                                    <event from="2017-06-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/The_Left_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.LMŠ" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Lista Marjana Šarca</orgName>
                                    <orgName full="yes" xml:lang="en">The List of Marjan Šarec</orgName>
                                    <orgName full="init">LMŠ</orgName>
                                    <event from="2014-05-31">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Lista_Marjana_%C5%A0arca</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/List_of_Marjan_%C5%A0arec</idno>
                                </org>
                                <org xml:id="party.NeP" role="independet">
                                    <orgName full="yes" xml:lang="sl">Nepovezani poslanci</orgName>
                                    <orgName full="yes" xml:lang="en">Unrelated members of parliament</orgName>
                                    <orgName full="init">NeP</orgName>
                                </org>
                                <org xml:id="party.NP" role="independet">
                                    <orgName full="yes" xml:lang="sl">Poslanska skupina nepovezanih
                                        poslancev</orgName>
                                    <orgName full="yes" xml:lang="en">Parliamentary group of unrelated members of
                                        parliament</orgName>
                                    <orgName full="init">NP</orgName>
                                </org>
                                <org xml:id="party.IMNS" role="ethnic_communities">
                                    <orgName full="yes" xml:lang="sl">Poslanci italijanske in madžarske narodne
                                        skupnosti</orgName>
                                    <orgName full="yes" xml:lang="en">Members of the Italian and Hungarian national
                                        communities</orgName>
                                    <orgName full="init">IMNS</orgName>
                                </org>
                                <org xml:id="party.NSi" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Nova Slovenija – Krščanski demokrati</orgName>
                                    <orgName full="yes" xml:lang="en">New Slovenia – Christian Democrats</orgName>
                                    <orgName full="init">NSi</orgName>
                                    <event from="2000-08-04">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Nova_Slovenija</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/New_Slovenia</idno>
                                </org>
                                <org xml:id="party.SD" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Socialni demokrati</orgName>
                                    <orgName full="yes" xml:lang="en">Social Democrats</orgName>
                                    <orgName full="init">SD</orgName>
                                    <event from="2005-04-02">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Socialni_demokrati</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Social_Democrats_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.SDS.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Slovenska demokratska stranka</orgName>
                                    <orgName full="yes" xml:lang="en">Slovenian Democratic Party</orgName>
                                    <orgName full="init">SDS</orgName>
                                    <event from="2003-09-19">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Slovenska_demokratska_stranka</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Slovenian_Democratic_Party</idno>
                                </org>
                                <org xml:id="party.SMC.1" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka Mira Cerarja</orgName>
                                    <orgName full="yes" xml:lang="en">Party of Miro Cerar</orgName>
                                    <orgName full="init">SMC</orgName>
                                    <event from="2014-06-02" to="2015-03-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                                </org>
                                <org xml:id="party.SMC.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka modernega centra</orgName>
                                    <orgName full="yes" xml:lang="en">Modern Centre Party</orgName>
                                    <orgName full="init">SMC</orgName>
                                    <event from="2015-03-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                                </org>
                                <org xml:id="party.SNS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Slovenska nacionalna stranka</orgName>
                                    <orgName full="yes" xml:lang="en">Slovenian National Party</orgName>
                                    <orgName full="init">SNS</orgName>
                                    <event from="1991-03-17">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Slovenska_nacionalna_stranka</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Slovenian_National_Party</idno>
                                </org>
                                <org xml:id="party.ZaAB" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Zavezništvo Alenke Bratušek</orgName>
                                    <orgName full="yes" xml:lang="en">Alliance of Alenka Bratušek</orgName>
                                    <orgName full="init">ZaAB</orgName>
                                    <event from="2014-05-31" to="2016-05-21">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <org xml:id="party.ZaSLD" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Zavezništvo socialno-liberalnih
                                        demokratov</orgName>
                                    <orgName full="yes" xml:lang="en">Alliance of Social Liberal Democrats</orgName>
                                    <event from="2016-05-21" to="2017-10-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <org xml:id="party.SAB" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka Alenke Bratušek</orgName>
                                    <orgName full="yes" xml:lang="en">Party of Alenka Bratušek</orgName>
                                    <orgName full="init">SAB</orgName>
                                    <event from="2017-10-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <listRelation>
                                    <relation name="renaming" active="#party.SMC.2" passive="#party.SMC.1"
                                        when="2015-03-07"/>
                                    <relation name="successor" active="#party.Levica.2" passive="#party.Levica.1"
                                        when="2017-06-24"/>
                                    <relation name="renaming" active="#party.ZaSLD" passive="#party.ZaAB"
                                        when="2016-05-21"/>
                                    <relation name="renaming" active="#party.SAB" passive="#party.ZaSLD"
                                        when="2017-10-07"/>
                                    <relation name="coalition" mutual="#party.PS #party.SD #party.DL #party.DeSUS"
                                        from="2013-03-20" to="2014-09-18" ana="#GOV.11"/>
                                    <relation name="coalition"
                                        mutual="#party.SMC.1 #party.SMC.2 #party.SD #party.DeSUS" from="2014-09-18"
                                        to="2018-09-12" ana="#GOV.12"/>
                                    <relation name="coalition" mutual="#party.LMŠ #party.SMC.2 #party.SD #party.SAB #party.DeSUS"
                                        from="2018-09-13" to="2020-03-12" ana="#GOV.13"/>
                                    <relation name="coalition" mutual="#party.SDS.2 #party.SMC.2 #party.NSi #party.DeSUS"
                                        from="2020-03-13" ana="#GOV.14"/>
                                </listRelation>
                            </listOrg>
                            <listPerson>
                                <head xml:lang="sl">Seznam govornikov</head>
                                <head xml:lang="en">List of speakers</head>
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person[matches(@corresp,$corpus-label)]">
                                    <person xml:id="{@xml:id}">
                                        <xsl:for-each select="tei:persName">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:sex">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:birth">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <!-- pazi, da daš pravilno vrednost za @ana -->
                                        <xsl:for-each select="tei:affiliation[@ana=('#DZ.7','#DZ.8')]">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:idno">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>
                                <!--<xsl:for-each select="document($source-speaker-document)/tei:TEI/tei:text/tei:body/tei:listPerson/tei:person">
                                    <person xml:id="{$corpus-label}.{@xml:id}">
                                        <xsl:for-each select="*">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>-->
                            </listPerson>
                        </particDesc>
                        <langUsage>
                            <language ident="sl">Slovenian</language>
                            <language ident="en">English</language>
                        </langUsage>
                    </profileDesc>
                </teiHeader>
                <xsl:for-each select="ref">
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:element>
                    
                    <!-- TEI dokumenti -->
                    <xsl:variable name="document" select="concat('../ParlaMint/',.)"/>
                    <xsl:result-document href="{$document}">
                        <xsl:apply-templates select="document(.)" mode="pass0"/>
                    </xsl:result-document>          
                </xsl:for-each>
            </teiCorpus>
        </xsl:result-document>
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
        <xsl:variable name="var9">
            <xsl:apply-templates select="$var8" mode="pass9"/>
        </xsl:variable>
        <xsl:variable name="var10">
            <xsl:apply-templates select="$var9" mode="pass10"/>
        </xsl:variable>
        <xsl:variable name="var11">
            <xsl:apply-templates select="$var10" mode="pass11"/>
        </xsl:variable>
        <xsl:variable name="var12">
            <xsl:apply-templates select="$var11" mode="pass12"/>
        </xsl:variable>
        
        <!-- kopiram zadnjo variablo z vsebino celotnega dokumenta -->
        <xsl:copy-of select="$var12" copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- odstranim distributor -->
    <xsl:template match="tei:distributor" mode="pass1">
        
    </xsl:template>
    <!-- za zadnjim respStmt dodam funder -->
    <xsl:template match="tei:respStmt[position() = last()]" mode="pass1">
        <respStmt>
            <xsl:apply-templates mode="pass1"/>
        </respStmt>
        <funder>
            <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
            <orgName xml:lang="en">The CLARIN research infrastructure</orgName>
        </funder>
    </xsl:template>
    
    <xsl:template match="tei:availability" mode="pass1">
        <xsl:if test="string-length($clarinHandle) gt 0">
            <pubPlace>
                <xsl:value-of select="$clarinHandle"/>
            </pubPlace>
        </xsl:if>
        <availability>
            <xsl:apply-templates select="@*" mode="pass1"/>
            <xsl:apply-templates mode="pass1"/>
        </availability>
    </xsl:template>
    
    <!--<xsl:template match="tei:address" mode="pass1">
        <!-\- odstranim naslov INZ na Kongresnem trgu 1 -\->
    </xsl:template>-->
    <!-- zamenjam celotni publisher z novimi podatki -->
    <xsl:template match="tei:publisher" mode="pass1">
        <publisher>
            <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
            <orgName xml:lang="en">CLARIN research infrastructure</orgName>
            <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
        </publisher>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:date" mode="pass1">
        <date when="{current-date()}"><xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/></date>
    </xsl:template>
    
    <!-- prestavim uvodne podatke iz body v front -->
    <xsl:template match="tei:text" mode="pass1">
        <text>
            <xsl:if test="tei:body/tei:div/tei:stage[@type='title'] or tei:body/tei:div/tei:head or tei:body/tei:div/tei:stage[@type='session'] or tei:body/tei:div/tei:stage[@type='chairman']">
                <front>
                    <div type="preface">
                        <xsl:apply-templates select="tei:body/tei:div/tei:stage[@type='title'] | tei:body/tei:div/tei:head | tei:body/tei:div/tei:stage[@type='session'] | tei:body/tei:div/tei:stage[@type='chairman']" mode="pass1"/>
                    </div>
                </front>
            </xsl:if>
            <xsl:apply-templates mode="pass1"/>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:div" mode="pass1">
        <div>
            <xsl:apply-templates mode="pass1"/>
        </div>
    </xsl:template>
   
    <xsl:template match="tei:div/tei:stage[@type='title']" mode="pass1">
        <head>
            <xsl:value-of select="normalize-space(.)"/>
        </head>
    </xsl:template>
    <xsl:template match="tei:div/tei:head" mode="pass1">
        <head>
            <xsl:value-of select="normalize-space(.)"/>
        </head>
    </xsl:template>
    <xsl:template match="tei:stage[@type='session']" mode="pass1">
        <head type="session">
            <xsl:value-of select="normalize-space(.)"/>
        </head>
    </xsl:template>
    <xsl:template match="tei:stage[@type='date']" mode="pass1">
        <docDate>
            <xsl:value-of select="normalize-space(.)"/>
        </docDate>
    </xsl:template>
    <xsl:template match="tei:stage[@type='chairman']" mode="pass1">
        <note type="chairman">
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:div/tei:p" mode="pass1">
        <note>
            <xsl:value-of select="normalize-space(.)"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="pass1">
        <u who="#{tokenize(@who,':')[1]}.{tokenize(@who,':')[2]}">
            <xsl:apply-templates mode="pass1"/>
        </u>
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
        <!-- samo odstavki, ki niso prazni -->
        <xsl:if test="string-length(normalize-space(.)) != 0">
            <seg xml:id="{$document-name-id}.p{$num}">
                <xsl:apply-templates mode="pass1"/>
            </seg>
        </xsl:if>
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
    
    <xsl:template match="tei:TEI" mode="pass1">
        <xsl:variable name="sittingDate" select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date/@when"/>
        <TEI>
            <xsl:apply-templates select="@*" mode="pass1"/>
            <xsl:attribute name="xml:lang">sl</xsl:attribute>
            <!-- dodam covid taksonomijo za ParlaMint -->
            <xsl:attribute name="ana">
                <xsl:text>#parla.sitting </xsl:text>
                <xsl:choose>
                    <xsl:when test="xs:date($sittingDate) &lt; xs:date($covid-date)">#reference</xsl:when>
                    <xsl:otherwise>#covid</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates mode="pass1"/>
        </TEI>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc/tei:bibl" mode="pass1">
        <bibl>
            <xsl:for-each select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
                <xsl:variable name="workingGroup" select="substring-after(@who,'#')"/>
                <title>
                    <xsl:if test="ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[not(tei:orgName/@key='KKPD')]">
                        <xsl:value-of select="normalize-space(ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[@xml:id=$workingGroup]/tei:orgName)"/>
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="concat(number(@n),'. ')"/>
                    <xsl:choose>
                        <xsl:when test="tei:name = 'Redna'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'redna'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'redna seja'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'Izredna'">izredna seja</xsl:when>
                        <xsl:when test="tei:name = 'Izredna seja'">izredna seja</xsl:when>
                        <xsl:when test="tei:name = 'Nujna'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'nujna'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'nujna seja'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'Javna predstavitev'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'Javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'Zasedanje'">zasedanje</xsl:when>
                        <xsl:when test="tei:name = 'slavnostna seja'">slavnostna seja</xsl:when>
                        <xsl:when test="tei:name = 'srečanje'">srečanje</xsl:when>
                        <xsl:when test="tei:name = 'posvet'">posvet</xsl:when>
                        <xsl:when test="tei:name = 'seja izvršilnega odbora'">seja izvršilnega odbora</xsl:when>
                        <xsl:otherwise>
                            <xsl:message>Neznana vrsta seje: <xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="concat(' (',format-date(tei:date/@when,'[D1]. [M1]. [Y0001]'),')')"/>
                </title>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="@type='mag'">
                    <edition xml:lang="sl">Nepreverjen zapis seje</edition>
                    <edition xml:lang="en">Unverified session record</edition>
                </xsl:when>
                <xsl:otherwise>
                    <edition xml:lang="sl">Preverjen zapis seje</edition>
                    <edition xml:lang="en">Verified session record</edition>
                </xsl:otherwise>
            </xsl:choose>
            <date when="{ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting[1]/tei:date/@when}"/>
            <xsl:for-each select="tei:idno[@type='URI'][matches(.,'https:')]">
                <idno type="URI">
                    <!-- pri skupnih sejah delovnih deles -->
                    <xsl:if test="@corresp">
                        <xsl:attribute name="corresp">
                            <!-- kaže na podatke o delovnem telesu v teiCorpus/teiHeader -->
                            <xsl:value-of select="concat('#',tokenize(@corresp,'\.')[last()])"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </idno>
            </xsl:for-each>
        </bibl>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt" mode="pass1">
        <titleStmt>
            <xsl:choose>
                <xsl:when test="tei:title[2]">
                    <xsl:choose>
                        <xsl:when test="tokenize(ancestor::tei:TEI/@xml:id,'-')[2] = 'KKPD'">
                            <title type="main" xml:lang="sl">Dobesedni zapis seje Kolegija predsednika Državnega zbora Republike Slovenije</title>
                            <title type="main" xml:lang="en">Verbatim record of the session of the Council of the President of the National Assembly of the Republic of Slovenia</title>
                        </xsl:when>
                        <xsl:otherwise>
                            <title type="main" xml:lang="sl">Dobesedni zapis seje delovnih teles Državnega zbora Republike Slovenije</title>
                            <title type="main" xml:lang="en">Verbatim record of the session of the working bodies of the National Assembly of the Republic of Slovenia</title>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <title type="main" xml:lang="sl">Dobesedni zapis seje Državnega zbora Republike Slovenije</title>
                    <title type="main" xml:lang="en">Verbatim record of the session of the National Assembly of the Republic of Slovenia</title>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
                <xsl:variable name="workingGroup" select="substring-after(@who,'#')"/>
                <title type="sub" xml:lang="sl">
                    <xsl:if test="ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[not(tei:orgName/@key='KKPD')]">
                        <xsl:value-of select="normalize-space(ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[@xml:id=$workingGroup]/tei:orgName)"/>
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="concat(number(@n),'. ')"/>
                    <xsl:choose>
                        <xsl:when test="tei:name = 'Redna'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'redna'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'redna seja'">redna seja</xsl:when>
                        <xsl:when test="tei:name = 'Izredna'">izredna seja</xsl:when>
                        <xsl:when test="tei:name = 'Izredna seja'">izredna seja</xsl:when>
                        <xsl:when test="tei:name = 'Nujna'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'nujna'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'nujna seja'">nujna seja</xsl:when>
                        <xsl:when test="tei:name = 'Javna predstavitev'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'Javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
                        <xsl:when test="tei:name = 'Zasedanje'">zasedanje</xsl:when>
                        <xsl:when test="tei:name = 'slavnostna seja'">slavnostna seja</xsl:when>
                        <xsl:when test="tei:name = 'srečanje'">srečanje</xsl:when>
                        <xsl:when test="tei:name = 'posvet'">posvet</xsl:when>
                        <xsl:when test="tei:name = 'seja izvršilnega odbora'">seja izvršilnega odbora</xsl:when>
                        <xsl:otherwise>
                            <xsl:message>Neznana vrsta seje: <xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="concat(' (',format-date(tei:date/@when,'[D1]. [M1]. [Y0001]'),')')"/>
                </title>
            </xsl:for-each>
            <xsl:for-each select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
                <meeting n="{number(@n)}" corresp="#{tokenize(@who,'\.')[last()]}">
                    <xsl:attribute name="ana">
                        <xsl:choose>
                            <xsl:when test="tei:name = 'Redna'">#parla.meeting.regular</xsl:when>
                            <xsl:when test="tei:name = 'redna'">#parla.meeting.regular</xsl:when>
                            <xsl:when test="tei:name = 'redna seja'">#parla.meeting.regular</xsl:when>
                            <xsl:when test="tei:name = 'Izredna'">#parla.meeting.extraordinary</xsl:when>
                            <xsl:when test="tei:name = 'Izredna seja'">#parla.meeting.extraordinary</xsl:when>
                            <xsl:when test="tei:name = 'Nujna'">#parla.meeting.urgent</xsl:when>
                            <xsl:when test="tei:name = 'nujna'">#parla.meeting.urgent</xsl:when>
                            <xsl:when test="tei:name = 'nujna seja'">#parla.meeting.urgent</xsl:when>
                            <xsl:when test="tei:name = 'Javna predstavitev'">#parla.meeting.opinions</xsl:when>
                            <xsl:when test="tei:name = 'Javna predstavitev mnenj'">#parla.meeting.opinions</xsl:when>
                            <xsl:when test="tei:name = 'javna predstavitev mnenj'">#parla.meeting.opinions</xsl:when>
                            <xsl:when test="tei:name = 'Zasedanje'">#parla.meeting.special</xsl:when>
                            <xsl:when test="tei:name = 'slavnostna seja'">#parla.meeting.ceremonial</xsl:when>
                            <xsl:when test="tei:name = 'srečanje'">#parla.meeting.special</xsl:when>
                            <xsl:when test="tei:name = 'posvet'">#parla.meeting.special</xsl:when>
                            <xsl:when test="tei:name = 'seja izvršilnega odbora'">#parla.meeting.special</xsl:when>
                            <xsl:otherwise>
                                <xsl:message>Neznana vrsta seje: <xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="tei:name"/>
                </meeting>
            </xsl:for-each>
            <!-- dodam še za prikaz metapodatkov o mandatu -->
            <xsl:variable name="corpus-term" select="ancestor::tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listEvent/tei:event/@n"/>
            <meeting n="{number($corpus-term)}" corresp="#DZ" ana="#parla.term #DZ.{$corpus-term}">
                <xsl:value-of select="$corpus-term"/>
                <xsl:text>. mandat</xsl:text>
            </meeting>
            
            <xsl:apply-templates select="tei:respStmt" mode="pass1"/>
        </titleStmt>
    </xsl:template>
    
    <xsl:template match="tei:settingDesc" mode="pass1">
        <settingDesc>
            <setting>
                <name type="city">Ljubljana</name>
                <name type="country" key="SI">Slovenija</name>
                <!-- vzamem samo prvega, saj se podatki drugače ponavljajo -->
                <date when="{tei:setting[1]/tei:date/@when}" ana="#parla.sitting">
                    <xsl:value-of select="format-date(tei:setting[1]/tei:date/@when,'[D1]. [M1]. [Y0001]')"/>
                </date>
            </setting>
        </settingDesc>
    </xsl:template>
    
    <!-- podatke o državnem zboru in delovnih delesih prikažem samo v teiCorpus/teiHeader -->
    <xsl:template match="tei:particDesc" mode="pass1">
        <!--<particDesc>
            <xsl:choose>
                <xsl:when test="tei:listOrg/tei:org/tei:listOrg/tei:org">
                    <xsl:for-each select="tei:listOrg/tei:org/tei:listOrg/tei:org">
                        <org xml:id="{@xml:id}" ana="#parla.committee" corresp="#{tei:orgName/@key}">
                            <orgName>
                                <xsl:value-of select="normalize-space(tei:orgName)"/>
                            </orgName>
                        </org>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="tei:listOrg/tei:org">
                        <org xml:id="{@xml:id}" ana="#parla.lower" corresp="#DZ">
                            <orgName>
                                <xsl:value-of select="normalize-space(tei:orgName)"/>
                            </orgName>
                        </org>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </particDesc>-->
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:div/tei:head | tei:body/tei:div/tei:docDate | tei:body/tei:div/tei:note[@type='chairman']" mode="pass2">
        <!-- elemente, ki sem jih iz body/div dal tudi v front/div, brišem iz body/div -->
    </xsl:template>
    
    <xsl:template match="tei:profileDesc" mode="pass2">
        <profileDesc>
            <abstract>
                <list type="agenda">
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
            </abstract>
            <xsl:apply-templates mode="pass2"/>
        </profileDesc>
    </xsl:template>
    
    <xsl:template match="tei:seg" mode="pass2">
        <seg>
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
                        <xsl:value-of select="concat(ancestor::tei:TEI/@xml:id,'.toc-item0')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates mode="pass2"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='agenda']/tei:item[tei:title[2]]" mode="pass3">
        <item>
            <xsl:apply-templates select="@*" mode="pass3"/>
            <title>
                <xsl:value-of select="string-join(tei:title,' ')"/>
            </title>
        </item>
    </xsl:template>
    
    <!-- odstranim title oznake -->
    <xsl:template match="tei:u/tei:seg/tei:title" mode="pass3">
        <xsl:apply-templates mode="pass3"/>
    </xsl:template>
    
    <!-- povsod odstranim še q (citate in ostale navedke) -->
    <xsl:template match="tei:q" mode="pass3">
        <xsl:apply-templates mode="pass3"/>
    </xsl:template>
    
    <!-- siParl: stage v note -->
    <!--<xsl:template match="tei:stage" mode="pass3">
        <note>
            <xsl:apply-templates select="@*" mode="pass3"/>
            <xsl:apply-templates mode="pass3"/>
        </note>
    </xsl:template>-->
    <!-- ParlaMint @type vrednosti -->
    <xsl:template match="tei:stage" mode="pass3">
        <xsl:choose>
            <xsl:when test="@type = 'answer'">
                <note type="answer">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'description'">
                <note type="description">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'error'">
                <note type="error">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'vote'">
                <note type="vote">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'vote-ayes'">
                <note type="vote-ayes">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'vote-noes'">
                <note type="vote-noes">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'time'">
                <note type="time">
                    <xsl:apply-templates mode="pass3"/>
                </note>
            </xsl:when>
            <xsl:when test="@type = 'inaudible'">
                <gap reason="inaudible">
                        <xsl:apply-templates mode="pass3"/>
                </gap>
            </xsl:when>
            <xsl:when test="@type = 'editorial'">
                <gap reason="editorial">
                        <xsl:apply-templates mode="pass3"/>
                </gap>
            </xsl:when>
            <xsl:when test="@type = 'action'">
                <incident type="action">
                        <xsl:apply-templates mode="pass3"/>
                </incident>
            </xsl:when>
            <xsl:when test="@type = 'sound'">
                <incident type="sound">
                        <xsl:apply-templates mode="pass3"/>
                </incident>
            </xsl:when>
            <xsl:when test="@type = 'applause'">
                <kinesic type="applause">
                        <xsl:apply-templates mode="pass3"/>
                </kinesic>
            </xsl:when>
            <xsl:when test="@type = 'signal'">
                <kinesic type="signal">
                        <xsl:apply-templates mode="pass3"/>
                </kinesic>
            </xsl:when>
            <xsl:when test="@type = 'playback'">
                <kinesic type="playback">
                        <xsl:apply-templates mode="pass3"/>
                </kinesic>
            </xsl:when>
            <xsl:when test="@type = 'snapping'">
                <kinesic type="snapping">
                        <xsl:apply-templates mode="pass3"/>
                </kinesic>
            </xsl:when>
            <xsl:when test="@type = 'gesture'">
                <kinesic type="gesture">
                        <xsl:apply-templates mode="pass3"/>
                </kinesic>
            </xsl:when>
            <xsl:when test="@type = 'interruption'">
                <vocal type="interruption">
                        <xsl:apply-templates mode="pass3"/>
                </vocal>
            </xsl:when>
            <xsl:when test="@type = 'laughter'">
                <vocal type="laughter">
                        <xsl:apply-templates mode="pass3"/>
                </vocal>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Unknown stage/@type value: <xsl:value-of select="@type"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Razdelim bivše p (sedaj u/seg) elemente -->
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
    <xsl:template match="tei:u/tei:seg[tei:note or tei:gap or tei:incident or tei:kinesic or tei:vocal]/text()" mode="pass4">
        <seg><xsl:copy-of select="."/></seg>
    </xsl:template>
    
    
    <!-- prečistim razdeljene elemente -->
    <xsl:template match="@* | node()" mode="pass5">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass5"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u/tei:seg[not(tei:seg)]" mode="pass5">
        <seg>
            <xsl:apply-templates select="@*" mode="pass5"/>
            <xsl:value-of select="normalize-space(.)"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="tei:u/tei:seg[tei:seg]" mode="pass5">
        <seg>
            <xsl:apply-templates select="@*" mode="pass5"/>
            <xsl:for-each-group select="*" group-adjacent="boolean(self::tei:note or self::tei:incident or self::tei:kinesic or self::tei:vocal)">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <xsl:apply-templates select="." mode="pass5"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <seg>
                            <xsl:for-each select="current-group()">
                                <xsl:choose>
                                    <xsl:when test="self::tei:gap">
                                        <xsl:apply-templates select="." mode="pass5"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(.)) = 0">
                                                <!-- ne procesiram segmentov, ki imajo samo presledke -->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="." mode="pass5"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </seg>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </seg>
    </xsl:template>
    
    
    <xsl:template match="@* | node()" mode="pass6">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass6"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- odstranim odvečne parent seg elemente -->
    <xsl:template match="tei:u/tei:seg[tei:seg]" mode="pass6">
        <xsl:apply-templates mode="pass6"/>
    </xsl:template>
    
    <xsl:template match="tei:u/tei:seg/tei:seg[tei:gap or tei:seg]" mode="pass6">
        <xsl:choose>
            <xsl:when test="tei:gap and not(tei:seg)">
                <!-- Zelo čudno: če sem spodaj dal samo copy-of select ., potem je v naslednjem pass7 ta gap postal note/@n (in nimam pojma, zakaj se je to zgodilo ... -->
                <!--<xsl:copy-of select="."/>-->
                <xsl:choose>
                    <xsl:when test="tei:gap/@n">
                        <gap n="{tei:gap/@n}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <gap reason="{tei:gap/@reason}">
                            <xsl:value-of select="tei:gap"/>
                        </gap>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="not(tei:gap) and tei:seg">
                <seg ana="{parent::tei:seg/@ana}">
                    <xsl:value-of select="normalize-space(.)"/>
                </seg>
            </xsl:when>
            <xsl:when test="tei:gap and tei:seg">
                <seg ana="{parent::tei:seg/@ana}">
                    <xsl:for-each select="tei:*">
                        <xsl:choose>
                            <xsl:when test="self::tei:gap[@reason]">
                                <xsl:text> </xsl:text>
                                <xsl:copy-of select="."/>
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::tei:gap[@n][following-sibling::tei:gap[@reason='inaudible'] or preceding-sibling::tei:gap[@reason='inaudible']]">
                                <!-- ga brišem -->
                            </xsl:when>
                            <xsl:when test="self::tei:gap[@n][not(following-sibling::tei:gap[@reason='inaudible'] or preceding-sibling::tei:gap[@reason='inaudible'])]">
                                <!-- če gap sledi takoj predhodnemu gap elementu, ga ne procesiram -->
                                <xsl:if test="not(preceding-sibling::tei:*[1][self::tei:gap])">
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <xsl:copy-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </xsl:when>
                                        <xsl:when test="position() = last()">
                                            <xsl:text> </xsl:text>
                                            <xsl:copy-of select="."/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                            <xsl:copy-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </seg>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Pass 6: tei:u/tei:seg/tei:seg[tei:gap or tei:seg]: unknown combination of elements (file id <xsl:value-of select="ancestor::tei:TEI/@xml:id"/>)</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- zamenjam seg/@xml:id, ki so prej veljali za p, z novimi za seg -->
    <xsl:template match="@* | node()" mode="pass7">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass7"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u/tei:seg" mode="pass7">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:u/tei:seg" level="any"/>
        </xsl:variable>
        <!-- samo segmenti besedil, ki niso prazni -->
        <xsl:if test="string-length(normalize-space(.)) != 0">
            <seg xml:id="{$document-name-id}.seg{$num}" ana="{@ana}">
                <xsl:apply-templates mode="pass7"/>
            </seg>
        </xsl:if>
    </xsl:template>
    
    <!-- dodam vrsto govornika -->
    <xsl:template match="tei:u" mode="pass7">
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
        <u>
            <xsl:variable name="whoForSpeaker" select="@who"/>
            <xsl:attribute name="who">
                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person[tokenize(@corresp,' ') = $whoForSpeaker]">
                    <xsl:value-of select="concat('#',@xml:id)"/>
                </xsl:for-each>
            </xsl:attribute>
            <!-- dodam še @xml:id -->
            <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
            <xsl:variable name="num">
                <xsl:number count="tei:u" level="any"/>
            </xsl:variable>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($document-name-id,'.u',$num)"/>
            </xsl:attribute>
            <xsl:attribute name="ana">
                <xsl:choose>
                    <xsl:when test="$speaker = $chair/tei:item">#chair</xsl:when>
                    <xsl:otherwise>#regular</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <!--<xsl:if test="$speaker = $chair/tei:item">
                <xsl:attribute name="ana">#chair</xsl:attribute>
            </xsl:if>-->
            <xsl:apply-templates mode="pass7"/>
        </u>
    </xsl:template>
    
    <!-- dodam manjkajoče desc -->
    <xsl:template match="tei:gap[@reason] | tei:incident | tei:kinesic | tei:vocal" mode="pass7">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*" mode="pass7"/>
            <desc>
                <xsl:apply-templates mode="pass7"/>
            </desc>
        </xsl:element>
    </xsl:template>
    
    <!-- uredim povezave na kazala -->
    <xsl:template match="@* | node()" mode="pass8">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass8"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- naredim povezavo iz kazal na tei:seg/@xml:id -->
    <xsl:template match="tei:abstract/tei:list[@type='agenda']/tei:item" mode="pass8">
        <item xml:id="{@xml:id}">
            <xsl:variable name="connection" select="@corresp"/>
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:apply-templates mode="pass8"/>
            <!-- additional ptr elements -->
            <xsl:choose>
                <xsl:when test="string-length($connection) = 0">
                    <xsl:for-each select="//tei:seg[@ana = $id]">
                        <ptr target="{concat('#',@xml:id)}"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//tei:seg[@ana = $connection]">
                        <ptr target="{concat('#',@xml:id)}"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </item>
    </xsl:template>
    
    <!-- odstranim začasni @ana atribut -->
    <xsl:template match="tei:seg" mode="pass8">
        <seg xml:id="{@xml:id}">
            <xsl:apply-templates mode="pass8"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass9">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass9"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:note" mode="pass9">
        <note>
            <xsl:apply-templates select="@*" mode="pass9"/>
            <xsl:analyze-string select="normalize-space(.)" regex="^(\(|/)(.*)(\)|/)$">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(regex-group(2))"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:desc" mode="pass9">
        <desc>
            <xsl:apply-templates select="@*" mode="pass9"/>
            <xsl:analyze-string select="normalize-space(.)" regex="^(\(|/)(.*)(\)|/)$">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(regex-group(2))"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </desc>
    </xsl:template>
    
    <xsl:template match="tei:gap[@n]" mode="pass9">
        <gap reason="inaudible"><desc><xsl:value-of select="@n"/></desc></gap>
    </xsl:template>
    
    <!-- odstranim kazala (Pred dnevnim redom), ki nimajo povezav preko corresp -->
    <xsl:template match="tei:abstract/tei:list[@type='agenda']/tei:item[not(tei:ptr)]" mode="pass9">
        <!-- ne procesiram -->
    </xsl:template>
    <!-- odstranim tudi prazna kazala -->
    <xsl:template match="tei:abstract[tei:list[@type='agenda']/tei:item[not(tei:ptr)]][not(tei:list[@type='agenda']/tei:item[2])]" mode="pass9">
        <!-- ne procesiram -->
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass10">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass10"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- premaknem u/note[@type='speaker'] pred u in u/note[@type='time'] za dotični u -->
    <xsl:template match="tei:u" mode="pass10">
        <xsl:apply-templates select="tei:note[@type='speaker']" mode="pass10"/>
        <u>
            <xsl:apply-templates select="@*" mode="pass10"/>
            <xsl:apply-templates select="*[not(self::tei:note[@type='speaker'] or (position() = last() and self::tei:note[@type='time']))]" mode="pass10"/>
        </u>
        <xsl:apply-templates select="*[position() = last()][self::tei:note[@type='time']]" mode="pass10"/>
    </xsl:template>
    
    <!-- čisto na koncu še preštejem vse elemente (ne upoštevam elementov iz teiHeader) -->
    <xsl:template match="@* | node()" mode="pass11">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass11"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
    
    <xsl:template match="tei:fileDesc" mode="pass11">
        <fileDesc>
            <xsl:apply-templates mode="pass11"/>
        </fileDesc>
        <encodingDesc>
            <tagsDecl>
                <namespace name="http://www.tei-c.org/ns/1.0">
                    <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
                        <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                    </xsl:for-each>
                </namespace>
            </tagsDecl>
        </encodingDesc>
    </xsl:template>
    
    <!-- povsem na koncu dodam nekaj elementov v teiHeader: poenotenje glede na Tomaževo predlogo za ParlaMint-hr -->
    <xsl:template match="@* | node()" mode="pass12">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass12"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt" mode="pass12">
        <titleStmt>
            <xsl:apply-templates mode="pass12"/>
        </titleStmt>
        <editionStmt>
            <edition>
                <xsl:value-of select="$edition"/>
            </edition>
        </editionStmt>
        <extent>
            <xsl:variable name="count-u" select="count(ancestor::tei:TEI/tei:text//tei:u)"/>
            <measure unit="speeches" quantity="{$count-u}" xml:lang="sl">
                <xsl:value-of select="format-number($count-u,'###.###','euro')"/>
                <xsl:text> govorov</xsl:text>
            </measure>
            <measure unit="speeches" quantity="{$count-u}" xml:lang="en">
                <xsl:value-of select="format-number($count-u,'###,###')"/>
                <xsl:text> speeches</xsl:text>
            </measure>
            
            <xsl:variable name="counting">
                <string>
                    <xsl:apply-templates select="ancestor::tei:TEI/tei:text"/>
                </string>
            </xsl:variable>
            <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
            <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
            <measure unit="words" quantity="{$count-words}" xml:lang="sl">
                <xsl:value-of select="format-number($count-words,'###.###','euro')"/>
                <xsl:text> besed</xsl:text>
            </measure>
            <measure unit="words" quantity="{$count-words}" xml:lang="en">
                <xsl:value-of select="format-number($count-words,'###,###')"/>
                <xsl:text> words</xsl:text>
            </measure>
        </extent>
    </xsl:template>
    
    <xsl:template match="tei:pubPlace" mode="pass12">
        <idno type="handle">
            <xsl:value-of select="."/>
        </idno>
        <pubPlace>
            <ref target="{.}">
                <xsl:value-of select="."/>
            </ref>
        </pubPlace>
    </xsl:template>
    
    <xsl:template match="tei:bibl/tei:title" mode="pass12">
        <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
        <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt/tei:title[@type='main'][@xml:lang='sl']" mode="pass12">
        <title type="main" xml:lang="sl">Slovenski parlamentarni korpus ParlaMint-sl [ParlaMint]</title>
    </xsl:template>
    <xsl:template match="tei:titleStmt/tei:title[@type='main'][@xml:lang='en']" mode="pass12">
        <title type="main" xml:lang="en">Slovenian parliamentary corpus ParlaMint-sl [ParlaMint]</title>
    </xsl:template>
    <xsl:template match="tei:titleStmt/tei:title[@type='sub'][@xml:lang='sl']" mode="pass12">
        <title type="sub" xml:lang="sl">
            <xsl:text>Zapisi sej Državnega zbora Republike Slovenije, </xsl:text>
            <xsl:value-of select="following-sibling::tei:meeting[matches(@ana,'#parla.term')]/@n"/>
            <xsl:text>. mandat, </xsl:text>
            <xsl:choose>
                <xsl:when test="following-sibling::tei:meeting[@ana='#parla.meeting.regular']">
                    <xsl:value-of select="following-sibling::tei:meeting[@ana='#parla.meeting.regular']/@n"/>
                    <xsl:text>. redna seja, </xsl:text>
                </xsl:when>
                <xsl:when test="following-sibling::tei:meeting[@ana='#parla.meeting.extraordinary']">
                    <xsl:value-of select="following-sibling::tei:meeting[@ana='#parla.meeting.extraordinary']/@n"/>
                    <xsl:text>. izredna seja, </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
        </title>
        <title type="sub" xml:lang="en">
            <xsl:text>Minutes of the National Assembly of the Republic of Slovenia, Mandate </xsl:text>
            <xsl:value-of select="following-sibling::tei:meeting[matches(@ana,'#parla.term')]/@n"/>
            <xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when test="following-sibling::tei:meeting[@ana='#parla.meeting.regular']">
                    <xsl:text>Ordinary Session </xsl:text>
                    <xsl:value-of select="following-sibling::tei:meeting[@ana='#parla.meeting.regular']/@n"/>
                </xsl:when>
                <xsl:when test="following-sibling::tei:meeting[@ana='#parla.meeting.extraordinary']">
                    <xsl:text>Extraordinary Session </xsl:text>
                    <xsl:value-of select="following-sibling::tei:meeting[@ana='#parla.meeting.extraordinary']/@n"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting/tei:date"/>
        </title>
    </xsl:template>
    
    <!-- dodam opis ParlaMint projekta -->
    <xsl:template match="tei:encodingDesc" mode="pass12">
        <encodingDesc>
            <projectDesc>
                <p xml:lang="sl"><ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref></p>
                <p xml:lang="en"><ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref></p>
            </projectDesc>
            <xsl:apply-templates mode="pass12"/>
        </encodingDesc>
    </xsl:template>
    
    <!-- odstranim agendo (kazalo vsebine točk dnevnega reda) -->
    <xsl:template match="tei:abstract" mode="pass12">
        
    </xsl:template>
    
</xsl:stylesheet>