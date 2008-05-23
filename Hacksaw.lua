--[[-------------------------------------------------------------------------
  Copyright (c) 2007, Kyahx
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of this AddOn nor the names of its contributors
        may be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]
assert(KCT, "WTF?! WARE IZ KCT?!!?1")
--[[-------------------------------------------------------------------------
    Settings -- You can mess with these
---------------------------------------------------------------------------]]

local textoverrides = {
    ["*"] = { isStaggered = nil, },
    ["AURA_END"] = { r = 0.4, g = 0.7, b = 0.4, },
    ["AURA_END_HARMFUL"] = { r = 0.7, g = 0.4, b = 0.4, },
}

local textsubs = {
    ["*"] = {
        ["<"] = "[",
        [">"] = "]",
    },
    ["AURA_START"] = {
        APPEND = { "+ ", " +" },
    },
    ["AURA_END"] = {
        APPEND = { "- ", " -" },
        [" fades"] = "",
    },
    ["AURA_START_HARMFUL"] = {
        --FUNC = function(v) KCT:Print("Test"..v) end,
        APPEND = { "+ ", " +" },
    },
    ["AURA_END_HARMFUL"] = {
        APPEND = { "- ", " -" },
        [" fades"] = "",
    },
}

--[[-------------------------------------------------------------------------
    Magic Funcs -- Don't touch crap below here
---------------------------------------------------------------------------]]

function KCT:ApplyOverrides()
    for type,table in pairs(COMBAT_TEXT_TYPE_INFO) do
        for k,v in pairs(textoverrides["*"]) do
            table[k] = v
        end
        if textoverrides[type] then
            for k,v in pairs(textoverrides[type]) do
                table[k] = v
            end
        end
    end
end

local gsub = string.gsub
local function logic(msg, k, v)
    if type(v) == 'table' and k == 'APPEND' then
        msg = (v[1] or "")..msg..(v[2] or "")
    elseif type(v) == 'function' and k == 'FUNC' then
        msg = v(msg) or msg
    else
        msg = gsub(msg, k, v)
    end
    
    return msg
end

function KCT:Cutcut(msg, msgType)
    for k,v in pairs(textsubs["*"]) do
        msg = logic(msg, k, v)
    end
    
    if textsubs[msgType] then
        for k,v in pairs(textsubs[msgType]) do
            msg = logic(msg, k, v)
        end
    end
    
    return msg
end

--[[-------------------------------------------------------------------------
    Psudo Custom Crap Support
---------------------------------------------------------------------------]]

function KCT:RegisterNewFilter(datatype, data)
    if not type(data) == 'table' then
        self:Print("ERROR!  Data passed must be a table")
    end
    
    if datatype == "OVERRIDES" then
        textoverrides = data
    elseif datatype == "SUBS" then
        textsubs = data
    else
        self:Print("ERROR!  Type must be \"OVERRIDES\" or \"SUBS\"")
    end
    
    self:ApplyOverrides()
end
