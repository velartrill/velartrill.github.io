srand
6.times {
	print "<p>"
	rand(30..120).times {
		print "<img src=\"img/cuneiform/" + rand(1..18).to_s + ".png\"> "
	}
	puts ".</p>"
}
