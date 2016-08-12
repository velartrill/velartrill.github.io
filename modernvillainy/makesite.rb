#!/usr/bin/env ruby
require 'fileutils'

PAGES = [
	{:title => 'Current Page', :link => "index.html"},
	{:title => 'Archive', :link => "archive.html"}
]

COMICS = [
	{:title => "How do you PLEAD!?" },
	{:title => "Impudent wretches" },
	{:title => "Flee for your lives!" },
	{:title => "Perish, heretic!" },
	{:title => "Why are you pouting" },
]
def makeurl(link, depth)
	("../"*depth) + link
end
def makelink(page, curpage, depth)
	if page != curpage
		'<a href="'+
		makeurl(page[:link],depth)+'">'+
		page[:title]+'</a>'
	else
		'<span class="active">'+page[:title]+'</span>'
	end
end

def makepage(page, depth)
	nav = '<div id="nav">'
	PAGES.each { |p|
		nav += makelink(p,page,depth)
	}
	nav+='<a href="http://patreon.com/approvednews6">Support the Comic</a>
</div>'
	
'<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Modern Villainy</title>
		<link rel="stylesheet" href="'+makeurl('modernvillainy.css',depth)+'">
		<link href="http://fonts.googleapis.com/css?amp;family=Open+Sans:100,300italic,400,300,700&amp;subset=latin,latin-ext" rel="stylesheet" type="text/css" />
		<script>
		  (function(i,s,o,g,r,a,m){i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,"script","//www.google-analytics.com/analytics.js","ga");

		  ga("create", "UA-51096979-1", "auto");
		  ga("send", "pageview");
		</script>
	</head>
<body>
<div id="header"></div>
' + nav + '
<div class="container">
'+yield+'
</div>
</body>
</html>'
	
end

def makenav(i, index=false)
	q='<div><div class="comicnav">'
	if i>1
		q += '<a href="'+(index ? "pages/" : "")+(i-1).to_s+'.html">&lt; Previous</a>'
	end
	if i<COMICS.size
		q += '<a href="'+(index ? "pages/" : "")+(i+1).to_s+'.html">Next &gt;</a>'
	elsif index
		q += '<a href="pages/'+COMICS.size.to_s+'.html">Permalink</a>'
	end
	q+'</div></div>'
end

if File.exists?('pages')
	FileUtils.rm_rf('pages')
end
def comicpage(i,comic,depth)
	'<div style="text-align:center;">
<h2> #'+i.to_s+'. '+comic[:title]+'</h2>'+
	makenav(i,depth==0) +
	'<img src="'+makeurl('comics/'+i.to_s+'.png',depth)+'">' +
	makenav(i,depth==0) +
	'</div>'
end
Dir.mkdir('pages')
i=1;
COMICS.each { |c|
		f = File.open('pages/'+i.to_s+'.html','w')
		f.write makepage({:title => c[:title]},1) {
			comicpage(i,c,1)
		}
		f.close
		i+=1;
}
f=File.open('index.html','w')
	f.write makepage(PAGES[0],0) {
		comicpage(COMICS.size,COMICS[COMICS.size-1],0)
	}
f.close


f=File.open('archive.html','w')
	f.write makepage(PAGES[1],0) {
		a='<h1>Archive</h1>
<ol>'
		i=1
		COMICS.each{|c|
			a+='<li><a href="pages/'+i.to_s+'.html">'+c[:title]+'</a></li>'
			i+=1
		}
		a+'</ol>'
	}
f.close
