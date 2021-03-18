local os = require("os")
local component = require("component")
local sides = require("sides")
local gpu = component.gpu

--turbine controllers
local turbines = component.list("it_gas_turbine")
local testTurbine = component.proxy("c3df8ef1-c9cb-43aa-ac75-9c3744f166d3")
--startup generators
local power = {
    "fae2c75d-4bdf-4a26-ac0c-13b9022222f7", 
    "4bcf3212-b833-4e82-b96a-f3778d540d2e", 
    "05bf3b7d-e8e0-4895-80e6-200a108803f5", 
    "54e0238a-920e-43ec-ac77-43468b67dab9"}

--redstone components
local redstoneLight = component.proxy("fb2716c3-5350-4ce5-ac24-d7e425f84e2d")
local redstoneSiren = component.proxy("6aaca029-a5d7-4ce8-a992-41b9d0cf67a9")
local redstoneButton = component.proxy("cbc9e179-8841-4f82-8e37-c4981fafea25")

--colors
local green = 0x1eff00
local red = 0xff0000

local function turbinesController()
    if redstoneButton.getInput(sides.west) == 15 then
        --check if turbines are running
        if testTurbine.getSpeed() == 0 then
            print("Starting turbines...")
            --power
            for i, gen in ipairs(power) do
                local proxy = component.proxy(gen)
                proxy.setOutput(sides.bottom, 15)
            end
            --turbines controller
            for t in turbines do
                local proxy = component.proxy(t)
                proxy.enableComputerControl(true)
                proxy.setEnabled(true)
            end
            --light
            redstoneLight.setOutput(sides.bottom, 15)
            --siren and cut power
            redstoneSiren.setOutput(sides.west, 15)
            os.sleep(11)
            for i, gen in ipairs(power) do
                local proxy = component.proxy(gen)
                proxy.setOutput(sides.bottom, 0)
            end
            redstoneSiren.setOutput(sides.west, 0)

            gpu.setForeground(green)
            print("Turbines on")
        end

    elseif testTurbine.getSpeed() > 0 then
        --power
        for i, gen in ipairs(power) do
            local proxy = component.proxy(gen)
            proxy.setOutput(sides.bottom, 0)
        end
        --turbines controller
        for t in turbines do
            local proxy = component.proxy(t)
            proxy.enableComputerControl(true)
            proxy.setEnabled(false)
        end
        --light
        redstoneLight.setOutput(sides.bottom, 0)

        gpu.setForeground(red)
        print("Turbines off")
        os.sleep(20)
    end
end

while true do
    turbinesController()
    os.sleep(1)
end