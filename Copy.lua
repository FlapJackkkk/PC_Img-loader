-- this is just to copy and paste into your executor. Fyi this is also organized so it can be edited

local HttpService = game:GetService("HttpService")
local TARGET_COLOR = Color3.fromRGB(248, 248, 248)
local MyAircraft = workspace:FindFirstChild(game.Players.LocalPlayer.Name .. " Aircraft")

print("------------------------------------------")
print(" PROJECTOR INITIALIZING...")

if not MyAircraft then
    warn(" ERROR: Could not find your Aircraft folder")
    warn("Check if your name is correct in the Explorer.")
    return
end


print("🔍 Searching for blocks with Color (248, 248, 248)...")
local blocks = {}
for _, v in pairs(MyAircraft:GetDescendants()) do
    if v:IsA("BasePart") and v.Color == TARGET_COLOR then
        table.insert(blocks, v)
    end
end

if #blocks == 0 then
    warn("ERROR: No blocks with RGB 248, 248, 248 found in your aircraft!")
    return
else
    print("Found " .. #blocks .. " potential pixels.")
end

print("Naming and organizing grid...")
table.sort(blocks, function(a, b)
    if math.abs(a.Position.Y - b.Position.Y) < 0.1 then
        return a.Position.X < b.Position.X
    end
    return a.Position.Y > b.Position.Y
end)

for i, block in ipairs(blocks) do
    local x = ((i - 1) % 39) + 1
    local y = math.floor((i - 1) / 39) + 1
    block.Name = x .. "_" .. y
    block:SetAttribute("IsPixel", true)
end
print("Grid Organization Complete.")


local function updatePixels()

    if not isfile("image_data.json") then 
        warn("📂 Waiting for 'image_data.json' in MacSploit Workspace...")
        return 
    end
    

    local content = readfile("image_data.json")
    if not content or content == "" then
        print("⚠️ JSON file is currently empty (Python might be writing to it).")
        return
    end

  
    local success, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if success and data then
        local paintedCount = 0
        for y = 1, 39 do
            for x = 1, 39 do
                if data[y] and data[y][x] then
                    local colorData = data[y][x]
                    local block = MyAircraft:FindFirstChild(x .. "_" .. y, true)
                    if block then
                        block.Color = Color3.new(colorData.r, colorData.g, colorData.b)
                        paintedCount = paintedCount + 1
                    end
                end
            end
        end
        print("Success: Painted " .. paintedCount .. " pixels from JSON.")
    else
        warn("Failed to decode JSON. Check if Python script is running correctly.")
    end
end


task.spawn(function()
    print("Projector Loop Started. Refreshing every 1 second.")
    print("------------------------------------------")
    while true do
        updatePixels()
        task.wait(1) 
    end
end)
