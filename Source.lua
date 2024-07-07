-- < Services > --
local CollectionService = game:GetService('CollectionService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local TweenService = game:GetService("TweenService")
local Players = game:GetService('Players')
local Debris = game:GetService('Debris')
local Timer = require(game.ReplicatedStorage.Modules.Timer)


--[[ 
		
		
		HOW TO USE
		
		RootPart = Part to reference
		XLimit, ZLimit, YLimit = Maximum variance between root position
		Speed = How fast the parts go (Amount of time it takes to tween)
		Color1, Color2 = COLORS TO VARY BETWEEN
		Count = AMOUNT OF PARTS SPAWNED
		MinTime = Lowest amount of time it takes for each to spawn vice versa with time. (x100)

		**EXAMPLE**

		local module = require(game.ReplicatedStorage.Modules.GravityModule)


		while true do
			module.Spawn(script.Parent, 20, BrickColor.new(Color3.fromRGB(98, 37, 209)), BrickColor.new(Color3.new(0, 0, 0)), 7, 7, 2, 1, 25, 50)
			task.wait(5)
		end
]]

-- < Module > --
local Module = {}

function Module.Spawn(RootPart : BasePart, Count : NumberValue, Color1 : BrickColor, Color2 : BrickColor, XLimit : NumberValue, ZLimit : NumberValue, YLimit : NumberValue, Speed : NumberValue, MinTime : NumberValue, MaxTime : NumberValue)
	local Sphere = script.Sphere
	if not Sphere then
		error('Sphere model not found in GravityModule.')
		return
	end

	local Colors = {
		Color1;
		Color2;
	}
	
	local DefaultMinTime, DefaultMaxTime = 25,50
	
	if not MinTime or MaxTime then
		MinTime, MaxTime = DefaultMinTime,DefaultMaxTime
	end
	
	for i = 1, Count do
		task.wait(math.random(MinTime, MaxTime) / 100 )
		local SphereClone = Sphere:Clone()
		SphereClone.Name = "Sphere"..i
		SphereClone.BrickColor = Colors[math.random(1, #Colors)]
		SphereClone.Transparency = 0
		SphereClone.CanCollide = false
		SphereClone.Material = Enum.Material.Neon

		local SpawnOffset = Vector3.new(math.random(-10, XLimit), math.random(-10, YLimit), math.random(-10, ZLimit))
		local SpawnPosition = RootPart.Position + SpawnOffset
		local SpawnCFrame = CFrame.new(SpawnPosition)
		local TargetCFrame = RootPart.CFrame * CFrame.new(SpawnOffset)

		SphereClone.CFrame = SpawnCFrame * CFrame.new(0, 10, 0) 
		SphereClone.Parent = workspace.World.Effects

		task.spawn(function()
			
			local GrowInfo = TweenInfo.new(0.35)
			local GrowGoal = {Size = Vector3.new(0.495, 5.525, 0.289)}

			local GrowTween = TweenService:Create(SphereClone, GrowInfo, GrowGoal)
			GrowTween:Play()
			
			local FallInfo = TweenInfo.new(Speed)
			local FallGoal = {CFrame = TargetCFrame}

			local FallTween = TweenService:Create(SphereClone, FallInfo, FallGoal)
			FallTween:Play()
			FallTween.Completed:Connect(function()
				local ShrinkInfo = TweenInfo.new(0.35)
				local ShrinkGoal = {Size = Vector3.new(0,0,0)}

				local ShrinkTween = TweenService:Create(SphereClone, ShrinkInfo, ShrinkGoal)
				ShrinkTween:Play()
				ShrinkTween.Completed:Connect(function()
					SphereClone:Destroy()
				end)
			end)
		end)
	end
end

return Module
