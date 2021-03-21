local component = require "component"
local sides = require "sides"
local os = require "os"

local tube = component.proxy("19cba457-3e22-48e5-b090-ad494aed3a47")

--add here any new compressor
local compressorRedstoneControllers = {
    "824b13bf-f881-4bb9-81fa-a3855b735eec",
    "841908e3-4606-4a24-beca-dc69fdf2e4e4",
    "b318e5f0-d5e7-4ca0-a7a0-be803bd82131"
    }

local compressors = {}
for i, comp in ipairs(compressorRedstoneControllers) do
    compressors[i] = component.proxy(comp)
end
local testCompressor = compressors[1]

while true do
    if tube.getPressure() >= 18.0 and testCompressor.getOutput(sides.bottom) == 15 then
        for _, c in ipairs(compressors) do
            c.setOutput(sides.bottom, 0)
        end
    elseif tube.getPressure() < 18.0 and testCompressor.getOutput(sides.bottom) == 0 then --if compressors aren't running already
        for _, c in ipairs(compressors) do
            c.setOutput(sides.bottom, 15)
        end
    end
    os.sleep(10)
end
