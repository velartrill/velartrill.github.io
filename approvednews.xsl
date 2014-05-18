<?xml version="1.0" encoding="UTF-8"?>
<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<head>
<style type="text/css">
	body {
		font-family: "Open Sans", "Helvetica Neue", Helvetica, sans-serif;
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
		background-color: rgb(200,132,147);
		height: 250px;
		background-image: url(header.png);
		background-position: center;
		background-repeat: no-repeat;
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
	#newsheader a {
		float: right;
		display: block;
		color: #999;
		font-weight: 100;
		text-decoration: none;
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
		border-top: none;
		background-color: white;
		padding: .8em;
		text-align: right;
		color: #aaa;
		text-transform: uppercase;
		letter-spacing: .4em;
	}
	.time {
		text-align: right;
		font-size: 9pt;
		color: #999;
		font-weight: normal;
		padding: .5em;
	}
</style>
</head>
<body>
<div id="header" />
<div id="slogan">Serving the Public from the News Warrens of <span class="redacted">[REDACTED]</span> since 1886</div>
<div id="container">
<div id="newsheader">Latest News <a href="#beginning">Read in Chronological Order</a></div>
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
Oldest
</div>
<a name="beginning" />
</div>
</body>
</html>