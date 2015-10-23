--a relatively stupid library that makes queries for Nth prime simpler
--TODO: fix that horribly poor excuse for a sieve to run faster
--TODO: add optional Lanes supports
local function coprimes(n,d)
	return coroutine.wrap(function()
	d=d or {2}
	local o,f,p,s=0,{},d[#d]
	while true do
		f,s=1,{}
		for _,v in ipairs(d) do
			for i=v,n+o,v do
				s[i-o]=1
			end
		end
		while f do
			f=nil
			for i=p,n+o,p do
				s[i-o]=1
			end
			for i=p,n+o do
				if not s[i-o] then
					f=1
					p=i
					d[#d+1]=p
					coroutine.yield(p)
					break
				end
			end
		end
		o=o+n
	end
	end)
end

pdb={}
function pdb.new(s,n)
	local r={2}
	local g=coprimes(s,r)
	r.G=g
	for i=2,n or 0 do
		r[i]=g()
	end
	return setmetatable(r,pdb)
end

function pdb.__index(s,i)
	if type(i)=='number' then
		local g=s.G
		for j=#s,i do
			g()
		end
		return rawget(s,i)
	else
		return pdb[i]
	end
end


return pdb
