local sieve = require 'raincoat.Math.Sieve'.segmented

--[[--
	Prime number database.
	A stateful module used for global access to prime numbers.
]]
local PrimeDB = {}
setmetatable( PrimeDB, PrimeDB )
local configured = false
local generator


--[[--
	Configures the database with a sieve size
	and returns it.
	Subsequent calls simple return the database.
	@module PrimeDB
	@param sieveSize the size of the boolean array to use as a sieve
	note that memory usage will grow as primes are being discovered
]]
local function configure( sieveSize )
	if configured then
		return PrimeDB
	end
	configured = true
	generator = sieve( sieveSize )
	generator( 'setPrimes', PrimeDB )
	return PrimeDB
end
PrimeDB.configure = configure


--[[--
	This is responsible for loading missing primes
	Since the module
]]
function PrimeDB:__index( n )
	for i = #PrimeDB, n do
		generator()
	end
	return self[ n ]
end


return PrimeDB