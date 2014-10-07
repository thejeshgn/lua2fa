--[[
# lua2fa.lua -- version 0.1

<https=//github.com/thejeshgn/lua2fa>

**Author:** Thejesh GN, <i@thejeshgn.com>  
**Date:** 2014
**License:** GNU GPL version 3.




]] 

-------------------------------------------------------------------------------
-- Base32 decoding library is from aiq
-- License: The MIT License (MIT)
-- Copyright (c) 2013 aiq
-- Project page: https://github.com/aiq/basexx/blob/master/lib/basexx.lua
-------------------------------------------------------------------------------
local basexx = {}
local bitMap = { o = "0", i = "1", l = "1" }
local base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

function number_to_bit( num, length )
   local bits = {}

   while num > 0 do
      local rest = math.fmod( num, 2 )
      table.insert( bits, rest )
      num = ( num - rest ) / 2
   end

   while #bits < length do
      table.insert( bits, "0" )
   end

   return string.reverse( table.concat( bits ) )
end


function basexx.from_bit( str )
   str = string.lower( str )
   str = str:gsub( '[ilo]', function( c ) return bitMap[ c ] end )
   return ( str:gsub( '........', function ( cc )
               return string.char( tonumber( cc, 2 ) )
            end ) )
end


local function from_basexx( str, alphabet, bits )
   local result = {}
   for i = 1, #str do
      local c = string.sub( str, i, i )
      if c ~= '=' then
         local index = string.find( alphabet, c )
         table.insert( result, number_to_bit( index - 1, bits ) )
      end
   end

   local value = table.concat( result )
   local pad = #value % 8
   return basexx.from_bit( string.sub( value, 1, #value - pad ) )
end



function basexx.from_base32( str )
   return from_basexx( string.upper( str ), base32Alphabet, 5 )
end

-------------------------------------------------------------------------------
-- END of Base32 decoding library
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
-- OTP Generation
-------------------------------------------------------------------------------

period = 30 --interval between two generated keys
length = 6  --length of OTP
        
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
        
function timestamp()
  return round (round(os.time())/period)
end

function otp(key, time)

end

-------------------------------------------------------------------------------
-- OTP Validation
-------------------------------------------------------------------------------
function qrCodeURL(site, secretKey)
	return "http://chart.apis.google.com/chart?cht=qr&chs=300x300&chl=otpauth://totp/"..site.."?secret="..secretKey.."&chld=H|0"
end




-------------------------------------------------------------------------------
-- Testing
-------------------------------------------------------------------------------
local test_code = "KKK67SDNLXIOG65U" -- must be at least 16 base 32 characters, keep this secret
print (basexx.from_base32(test_code))


