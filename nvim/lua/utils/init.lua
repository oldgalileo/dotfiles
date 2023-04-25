local Util = require("lazy.core.util")

local Pkg = {}

--@param name string
function Pkg.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

return Pkg
