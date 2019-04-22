# Zapisniki sej slovenskega parlamenta v TEI

Zapisnike sej se ureja v TEI modulu za dramska besedila, ki se nahajajo v mapi 
[drama](drama)drama. Zapisniki sej so glede na mandatna obdobja združeni v podmape. Pri tem se posebej
loči zapisnike Sej Državnega zbora (SDZ) in zapisnike Sej delovnih teles (SDT) Državnega zbora.
Vsako mandatno obdobje, ki združuje zapisnike SDZn ali SDTn je samostojni teiCorpus, ki vključuje
zapisnike sej posameznega dne v istoimenski podmapi. Seznami govornikov se nahajajo v
ločeni *-speaker.xml datoteki.

Zapisnike sej se z pretvorbo XSLT 
[drama2speech.xsl](drama2speech.xsl)drama2speech.xsl iz TEI modula za dramska besedila pretvori v
TEI modul za prepis govorov, ki se nahaja v mapi 
[speech](speech)speech. Pri pretvorbi se izhaja iz vsakokratnega drama/*-list.xml seznama datotek
posameznega mandata/korpusa.


