------------------------------------------------------------------------------
-- This file is part of the PharaohStroy MMORPG client                      --
-- Copyright ?2020-2022 Prime Zeng                                          --
--                                                                          --
-- This program is free software: you can redistribute it and/or modify     --
-- it under the terms of the GNU Affero General Public License as           --
-- published by the Free Software Foundation, either version 3 of the       --
-- License, or (at your option) any later version.                          --
--                                                                          --
-- This program is distributed in the hope that it will be useful,          --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU Affero General Public License for more details.                      --
--                                                                          --
-- You should have received a copy of the GNU Affero General Public License --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
------------------------------------------------------------------------------

local WzNode = {}

WzNode.__index = function(table, key) 
    
    if(type(key) == "number") then
        key = key..""
    end

    if(type(key) == "table") then
        key = key:toString()
    end

    local node = table.children[key]
    if type(node) == "table" then
        return node
    end

    if(node ~= nil) then -- replace rawPtr to children table
        local sub = WzNode.new(node,key)
        table.children[key] = sub
        return sub
    end

    return nil
end

function WzNode:toInt(default)
    return wz.toInt(self.rawPtr,default or 0)
end

function WzNode:toString(default)
    return wz.toString(self.rawPtr,default or "")
end

function WzNode:toReal(default)
    return wz.toReal(self.rawPtr,default or 0)
end

function WzNode:toVector()
    return wz.toVector(self.rawPtr)
end


function WzNode:foreach(callback)
    for k, v in pairs(self.children) do
        callback(k,WzNode.new(v,k))
    end
end


--@param identity is an optional arg
function WzNode.new(path,identity)
    local instance = {}
    setmetatable(instance,WzNode)
    if path ~= nil then

        if type(path) == "userdata" then
            instance.children = wz.expand(path)
            instance.rawPtr = path
            instance.identity = identity
        else
            instance.children = wz.flat(path)
        end

        for k,v in pairs(WzNode) do
            instance[k] = v
        end

    end
    return instance
end


return WzNode