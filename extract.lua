local filename = "manual.of"
local file = io.open(filename)
if not file then
    error(string.format("could not open %s", filename))
end
local content = file:read("a")

local function repl_func(what, cont)
    cont = string.sub(cont, 2, -2)
    local lut = {
        apii = function(c) return "" end,
        x = function(c) return c end,
        id = function(c) return c end,
        ANSI = function(c) return c end,
        def = function(c) return c end,
        defid = function(c) return c end,
        idx = function(c) return c end,
        Lid = function(c) return c end,
        En = function(c) return c end,
        emph = function(c) return c end,
        emphx = function(c) return c end,
        rep = function(c) return c end,
        itemize = function(c) return c end,
        verbatim = function(c) return c end,
        Q = function(c) return c end,
        M = function(c) return c end,
        N = function(c) return c end,
        T = function(c) return c end,
        description = function(c) return c end,
        see = function(c) return c end,
        seeC = function(c) return c end,
        seeF = function(c) return c end,
        Char = function(c) return c end,
        St = function(c) return c end,
    }
    if not lut[what] then
        error(string.format("trying to format entry '%s', which is unknown", what))
    end
    return lut[what](cont)
end

for entry in string.gmatch(content, "APIEntry(%b{})") do
    -- strip braces
    entry = string.sub(entry, 2, -2)
    entry = string.gsub(entry, "%@(%w+)(%b{})", repl_func)
    if not string.match(entry, "typedef") then
        local title = string.match(entry, "([%w_]+)%s*%b()")
        local body = string.sub(entry, string.find(entry, "|") + 1)
        local filename = string.format("man3/%s.3", title)
        print(string.format("writing %s", filename))
        local entryfile = io.open(filename, "w")
        entryfile:write(string.format('.TH %s 3l ""\n', title))
        entryfile:write(string.format('%s\n', body))
        --entryfile:write(entry)
        entryfile:close()
    end
end
