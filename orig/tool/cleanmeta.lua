local file = table.unpack(arg)
if file == '' then file = nil end
local fd = file and io.open(file, 'r') or io.stdin
if not fd then
	io.stdout:write("can't open file for reading\n")
	os.exit(1)
end

local text = fd:read'*a'
if file then fd:close() end

local out = text:gsub('%-%-', '---')

local function split(str,delim)
	local i, last = 1
	return function()
		local s, e = string.find(str,delim,i,true)
		if not s then
			if last and last < #str then
				local l = last
				last = nil
				return string.sub(str, i), i
			else
				return nil
			end
		end
		last,i = i,e+1
		return string.sub(str, last, s-1), i
	end
end

local function explode(str,delim,n)
	local a = {}
	local ct = 0
	for s,i in split(str,delim) do
		if ct == n then
			a[ct+1] = string.sub(str, i)
			return a
		else
			ct = ct + 1
		end
		a[ct] = s
	end
	return a
end

out=out:gsub('%b{}', function(m)
	local lang, en, nat = table.unpack(explode(m:sub(2,#m-1), '/'))
	if lang == nil or en == nil then
		return m
	else
		-- TODO figure out a smarter way to handle multiling text
		--      in epubs
		return '"' .. en .. '"'
	end
end)

local coda = ''
local body = ''
for line in split(out, '\n') do
	local cmd, args = line:match("^%s*%%%s*([^%s\n]+)%s?([^\n]*)$")
	if cmd == 'is' then
		local k,v = table.unpack(explode(args,' ',1))
		if k == 'coda' then
			coda = '![](' .. v .. ')\n'
		end
	elseif cmd == 'img' then
		body = body .. '![](' .. args .. ')\n'
	elseif cmd == nil then
	-- if not line:match('^%s*%%') then
		body = body .. line .. '\n'
	end
end
body = body .. coda
-- if file then
-- 	fd = io.open(file, 'w+')
-- 	if not fd then
-- 		io.stderr:write('can\'t open file for writing\n')
-- 		os.exit(2)
-- 	end
-- 	fd:write(out)
-- 	fd:close()
-- else
	io.stdout:write(body)
-- end
