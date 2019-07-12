#!/usr/bin/env fish
set out ../feed.atom

if test (basename (pwd)) != "fic"
	echo "run this from the fic directory, dumbass!"
	exit 5
end

function identify
	grep -oPm1 '<title>\K.*?(?=</title>)' $argv[1]
	# jesus fuck i hate this
	# sure would be nice if unix tools could do
	# something obvious and useful for a change,
	# HUH!?
end

function firstpar
	grep -oPm1 "<p>\K.*(?=</p>)" $argv[1]
end

if which sha1 >/dev/null ^&1
	function hash
		sha1 $argv[1] #bsd5lyfe
	end
else
	function hash
		sha1sum $argv[1] | cut -d' ' -f1
		#cause this is the LINUX SHIT ZONE
	end
end

function field
	cut -d\x1f -f $argv[1]
end

function report
	echo "[2K"\r - "[1m$argv[1][;35m" $argv[2..-1] "[m"
end

function xml
	echo "<$argv[1]>$argv[2..-1]</$argv[1]>"
end

function stamp
	date "--date=@$argv[1]" --iso-8601=seconds
	# atom requires RFC-3339 timestamps, so we
	# CANNOT use the --rfc-3339 flag, which
	# generates ISO-8601 timestamps, not valid
	# RFC-3339 timestamps.
end

set all **.html
set files
set dates
set hashes
set uuids
set titles
set processed
set cats

set changed 0
set new     0
set total   0
set procd   0

for i in (cat .atom/db)
	set total (expr $total + 1)
	set -l file   (echo $i | field 1)
	set -l lread  (echo $i | field 2)
	set -l fhash  (echo $i | field 3)
	set -l uuid   (echo $i | field 4)
	set -l cat    (echo $i | field 5)
	echo -n "[2K[96m*[m [1m$file[m"\r

	test -e $file; or continue
		#file no longer exists, remove it from database
	test (basename $file) = "index.html"; and continue
		#file is an index, and never should have gotten
		#into the database in the first place

	if grep -q "<!-- *atom-exclude *-->" $file
		report $file marked for exclusion, detracking
		continue #file is now marked for exclusion
	end

	set procd (expr $procd + 1)

	set -l lwrite (stat -c %Y $file)

	set -a files $file
	set -a uuids $uuid
	set -a titles (identify $file)

	if test $lwrite -gt $lread
		if test (hash $file) != $fhash #changed
			set -a dates $lwrite
			set -a hashes (hash $file)
			set -a cats updated

			report $file has changed

			set changed (expr $changed + 1)
			continue
		end
	end

	#else
	set -a dates $lread
	set -a hashes $fhash
	set -a cats $cat
end

for file in $all
	contains $file $files; and continue
	test (basename $file) = "index.html"; and continue
	echo -n "[2K[92m+[m [1m$file[m"\r

	if grep -q "<!-- *atom-exclude *-->" $file
		continue #file is marked for exclusion
	end

	# new file
	report $file is new
	
	set -a files $file
	set -a titles (identify $file)
	set -a dates (stat -c %Y $file)
	set -a hashes (hash $file)
	set -a uuids (uuidgen)
	set -a cats "new"

	set new (expr $new + 1)
end

# update database with new findings
: >.atom/db #truncate db
for idx in (seq (count $files))
	echo >>.atom/db $files[$idx]\x1f$dates[$idx]\x1f$hashes[$idx]\x1f$uuids[$idx]\x1f$cats[$idx]
end

echo -n "[2K"\r # make sure we're on a clean line
echo \x1b"[1m" $new     \x1b"[;92m" added   \x1b"[m"
echo \x1b"[1m" $changed \x1b"[;94m" changed \x1b"[m"
echo \x1b"[1m" (expr $total - $procd) \x1b"[;91m" deleted \x1b"[m"

echo " - writing atom…"

cat >$out .atom/head 
echo >>$out \t (xml updated (date --iso-8601=seconds)) \n

for i in (seq (count $files))
	test $dates[$i] -gt 1557890061; or continue
		# hack to skip old shit
	
	echo >>$out \t "<entry>"
	echo >>$out \t\t (xml title $titles[$i])
	echo >>$out \t\t "<link rel=\"alternate\" href=\"http://ʞ.cc/fic/$files[$i]\"/>"
	echo >>$out \t\t (xml id "urn:uuid:$uuids[$i]")
	echo >>$out \t\t (xml updated (stamp $dates[$i]))
	echo >>$out \t\t "<summary type=\"html\"><![CDATA[<p>"(firstpar $files[$i])"</p><p><a href=\"http://ʞ.cc/fic/$files[$i]\">[read more]</a></p>]]></summary>"
	echo >>$out \t\t "<category term=\"$cats[$i]\"/>"
	echo >>$out \t "</entry>"\n
end

echo >>$out "</feed>"
