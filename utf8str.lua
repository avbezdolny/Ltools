-- [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
-- os.setlocale('ru_RU.UTF-8', 'all')

require("utf8")  -- lua 5.3+

local ru_lower_to_upper = {
    ["а"] = "А", ["б"] = "Б", ["в"] = "В", ["г"] = "Г",
    ["д"] = "Д", ["е"] = "Е", ["ё"] = "Ё", ["ж"] = "Ж",
    ["з"] = "З", ["и"] = "И", ["й"] = "Й", ["к"] = "К",
    ["л"] = "Л", ["м"] = "М", ["н"] = "Н", ["о"] = "О",
    ["п"] = "П", ["р"] = "Р", ["с"] = "С", ["т"] = "Т",
    ["у"] = "У", ["ф"] = "Ф", ["х"] = "Х", ["ц"] = "Ц",
    ["ч"] = "Ч", ["ш"] = "Ш", ["щ"] = "Щ", ["ъ"] = "Ъ",
    ["ы"] = "Ы", ["ь"] = "Ь", ["э"] = "Э", ["ю"] = "Ю",
    ["я"] = "Я"
}

local ru_upper_to_lower = {
    ["А"] = "а", ["Б"] = "б", ["В"] = "в", ["Г"] = "г",
    ["Д"] = "д", ["Е"] = "е", ["Ё"] = "ё", ["Ж"] = "ж",
    ["З"] = "з", ["И"] = "и", ["Й"] = "й", ["К"] = "к",
    ["Л"] = "л", ["М"] = "м", ["Н"] = "н", ["О"] = "о",
    ["П"] = "п", ["Р"] = "р", ["С"] = "с", ["Т"] = "т",
    ["У"] = "у", ["Ф"] = "ф", ["Х"] = "х", ["Ц"] = "ц",
    ["Ч"] = "ч", ["Ш"] = "ш", ["Щ"] = "щ", ["Ъ"] = "ъ",
    ["Ы"] = "ы", ["Ь"] = "ь", ["Э"] = "э", ["Ю"] = "ю",
    ["Я"] = "я"
}

function utf8_upper(text)
    local result = ''
    for p, c in utf8.codes(text) do
        local char = utf8.char(c)
        char = ru_lower_to_upper[char] or string.upper(char)
        result = result .. char
    end
    return result
end

function utf8_lower(text)
    local result = ''
    for p, c in utf8.codes(text) do
        local char = utf8.char(c)
        char = ru_upper_to_lower[char] or string.lower(char)
        result = result .. char
    end
    return result
end
