<?xml version="1.0" encoding="UTF-8"?>
<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<head>
<title>Approved News 6</title>
<meta name="viewport" content="width=device-width" />
<style type="text/css">
	body {
		font-family: "serif", "Open Sans", "Helvetica Neue", Helvetica, sans-serif; /* ugly hack to make font bearable on Android devices */
		font-weight: 100;
		background-color: #f0e5e5;
		margin: 0;
	}
	#slogan {
		text-align: center;
		border-bottom: 1px solid #ccc;
		letter-spacing: .4em;
		padding: 1em;
		background-color: white;
		font-size: 9pt;
		font-weight: normal;
		color: #999;
		text-transform: uppercase;
	}
	#header {
		background-color: #c88493;
		background-position: center;
		background-repeat: no-repeat;
		height: 250px;
		background-image: url(header.png);
	}
	#newsheader {
		margin-top: .3em;
		border-radius: 9px 9px 0px 0px;
		border: 1px solid #ccc;
		border-bottom: none;
		background-color: white;
		font-weight: bold;
		padding: .8em;
	}
	#newsheader a, #newsfooter a {
		float: right;
		color: #999;
		font-weight: 100;
		text-decoration: none;
		letter-spacing: normal;
	}
	#newsheader a:hover {
		color: #777;
	}
	#container {
		margin: auto;
		max-width: 768px;
		border-left: 10px;
	}
	.item {
		text-align: justify;
		border: 1px solid #ccc;
		border-bottom: none;
		padding: 1em .7em;
		padding-bottom: 0;
		background: white;
	}
	.favorite { 
		font-size: 15pt;
		background: url(logo.png) no-repeat;
		background-position: 2px center;
		padding-left: 36px;
	}
	.redacted {
		background-color: black;
		padding: 3px 5px;
		font-weight: bold;
		color: white;
		letter-spacing: normal;
	}
	#newsfooter {
		margin-bottom: .3em;
		margin-top: 0;
		border-radius: 0px 0px 9px 9px;
		border: 1px solid #ccc;
		background-color: white;
		padding: .8em;
		text-align: right;
		color: #aaa;
		letter-spacing: .4em;
	}
	.time {
		text-align: right;
		font-size: 9pt;
		color: #999;
		font-weight: normal;
		padding: .5em;
	}
	@media not all and (min-width:768px) {
		#newsheader, #newsfooter {
			border:none;
			border-radius:0;
			background: none;
		}
		.item {
			border-left: none;
			border-right: none;
		}
	}
	@media not all and (min-width:570px) {
		#header {
			height: 290px;
			background-image: url(biglogo.png);
			border-bottom: 1px solid #8d3f50;
		}
		#slogan { display: none; }
		.item {
			text-align: left;
		}
		#newsfooter {
			border-top: 1px solid #ccc;
		}
		.hide_mobile {
			display:none;
		}
	}
	@media not all and (min-width:450px) {
		body {
			font-size: 10pt;
		}
		.favorite {
			background: none;
			font-size: 13pt;
			padding-left: 0px;
		}
	}
</style>
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
<div id="header" />
<div id="slogan">Serving the Public from the News Warrens of <span class="redacted">[REDACTED]</span> since 1886</div>
<div id="container">
<div id="newsheader"><span class="hide_mobile">Latest News</span><a href="#beginning">Read in Chronological Order</a><div style="clear:both;"></div>
</div>
<xsl:for-each select="statuses/status">
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
	</div>
</xsl:for-each>
<div id="newsfooter">
OLDEST - <a href="#top">Back to Top</a>
</div>
<a name="beginning" />
</div>
</body>
</html>
