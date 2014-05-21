<?xml version="1.0" encoding="UTF-8"?>
<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<head>
<title>Approved News 6</title>
<meta name="viewport" content="width=device-width" />
<link rel="stylesheet" href="approvednews.css" />
<link href='http://fonts.googleapis.com/css?amp;family=Open+Sans:300italic,400,300,700&amp;subset=latin,latin-ext' rel='stylesheet' type='text/css' />
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-51096979-1', 'velartrill.github.io');
  ga('send', 'pageview');
</script>
</head>
<body>
<div id="header"></div>
<div id="nav">
	<span class="selected">Archive</span>
	<a href="https://twitter.com/NewsNetwork6">Live Feed</a>
	<a href="cast.html">Cast</a>
</div>
<div id="container">
<div id="newsheader"><span class="hide_mobile">Latest News</span><a href="#beginning">Read in Chronological Order</a><div style="clear:both;"></div>
</div>
<xsl:for-each select="statuses/status">
	<a><xsl:attribute name="name">headline_<xsl:value-of select="id" /></xsl:attribute></a>
	<a><xsl:attribute name="href">#headline_<xsl:value-of select="id" /></xsl:attribute>
	<div class="item">
		<xsl:choose>
			<xsl:when test="favorite_count &gt; 0">
				<div class="favorite">
					<xsl:value-of select="text"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="text"/>
			</xsl:otherwise>
		</xsl:choose>
		<div class="time"><xsl:value-of select="created_at"/></div>
	</div></a>
</xsl:for-each>
<div id="newsfooter">
OLDEST - <a href="#top">Back to Top</a>
</div>
<a name="beginning" />
</div>
</body>
</html>
