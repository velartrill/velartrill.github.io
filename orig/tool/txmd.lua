local file, arc = table.unpack(arg)
if file == '' then file = nil end
local fd = file and io.open(file, 'r') or io.stdin
if not fd then
	io.stdout:write("can't open file for reading\n")
	os.exit(1)
end

local text = fd:read'*a'
if file then fd:close() end

function nav(n, t)
	return t:gsub('%s?%[([^%]]+)%]%(([^)]+)%){%.'..n..'}','%%' .. n .. ' %2 %1\n')
end
local out = text
	:gsub('^[^\n]*\n+','') --delete first line
	:gsub('::: {style="text%-align: center"}\n!%[%]%((.-)%)\n:::\n',
	      '%%is coda %1\n')
	:gsub('::: byline\nby (.-)\n:::\n',
	      '%%by %1\n')
	:gsub('::: byline\n(.-)\n:::\n',
	      '%%byline %1\n')
	:gsub('\n([^\n])', ' %1')
	:gsub('\n%s','\n\n')
	:gsub("\\'","'")
	:gsub('%-%-%-+',function(m)
		if #m == 3 then return '--' else return '---' end
	end)
out = nav('prev', nav('next', out)) ..
	(arc and ('\n%in arc ' .. arc .. '\n') or '')

if file then
	fd = io.open(file, 'w+')
	if not fd then
		io.stderr:write('can\'t open file for writing\n')
		os.exit(2)
	end
	fd:write(out)
	fd:close()
else
	io.stdout:write(out)
end
