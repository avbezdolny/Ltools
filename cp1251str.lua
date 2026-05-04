-- [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")
-- os.setlocale('ru_RU.CP1251', 'all')

function string.upper ( str ) return str:gsub ( "([a-zà-ÿ¸])", function ( c ) return string.char ( string.byte ( c ) - ( c == '¸' and 16 or 32 ) ) end ) end

function string.lower ( str ) return str:gsub ( "([A-ZÀ-ß¨])", function ( c ) return string.char ( string.byte ( c ) + ( c == '¸' and 16 or 32 ) ) end ) end
