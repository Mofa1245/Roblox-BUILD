-- buildloader.lua (host this file)
local HttpService = game:GetService("HttpService")
local buildUrl = "https://raw.githubusercontent.com/Mofa1245/Roblox-BUILD/main/build.json"

local function parseVector3(str)
	local x, y, z = str:match("([-%d.]+),([-%d.]+),([-%d.]+)")
	return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
end

local function parseRotation(str)
	local x, y, z = str:match("([-%d.]+),([-%d.]+),([-%d.]+)")
	return CFrame.Angles(math.rad(tonumber(x)), math.rad(tonumber(y)), math.rad(tonumber(z)))
end

local function createPart(data)
	local part = Instance.new("Part")
	part.Position = parseVector3(data.Position)
	part.Size = parseVector3(data.Size)
	part.Anchored = data.Anchored
	part.CanCollide = data.CanCollide
	part.Transparency = 0 -- Make it visible for testing
	part.BrickColor = BrickColor.new("Bright red")
	part.CFrame = CFrame.new(part.Position) * parseRotation(data.Rotation)
	part.Parent = workspace
end

local function loadBuild()
	local success, response = pcall(function()
		return HttpService:GetAsync(buildUrl)
	end)

	if success then
		local buildData = HttpService:JSONDecode(response)
		for _, partData in pairs(buildData.WoodBlock or {}) do
			createPart(partData)
		end
		print("✅ Build loaded successfully!")
	else
		warn("❌ Failed to fetch build:", response)
	end
end

loadBuild()
