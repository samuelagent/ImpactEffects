--[[
Author: samuelagent

This is a module that provides an easy method to create impact effects. Do note that all of the default particles and sounds in this module 
(If you have the rbxm) are ACS assets. This is intended to be for gun impact effects, but can be repurposed for other things.

---------------------------------------------------------------------------------------------------------------------------------------------

[No Return] Function > WorldEffects.ProduceImpact(Material: Enum.Material, Position: Vector3, Normal: Vector3, PlaySound: Boolean | Optional)
	Takes in three required arguments and an option fourth one to create an attachment containing the sound and particles
	which subsequently played. If the PlaySound parameter is false, then the sound will not play.

---------------------------------------------------------------------------------------------------------------------------------------------
]]

--// Services
local Debris = game:GetService("Debris")

--// Constants
local Effects = {} do
	for _, EffectGroup in ipairs(script.EffectGroups:GetChildren()) do
		Effects[EffectGroup.Name] = {
			Sounds = EffectGroup.Sounds:GetChildren(),
			Particles = EffectGroup.Particles
		}
	end
end

local GroupMap = {
	[Enum.Material.CrackedLava] = Effects.One,
	[Enum.Material.Cobblestone] = Effects.One,
	[Enum.Material.Sandstone] = Effects.One,
	[Enum.Material.Limestone] = Effects.One,
	[Enum.Material.Concrete] = Effects.One,
	[Enum.Material.Granite] = Effects.One,
	[Enum.Material.Asphalt] = Effects.One,
	[Enum.Material.Granite] = Effects.One,
	[Enum.Material.Basalt] = Effects.One,
	[Enum.Material.Slate] = Effects.One	,
	[Enum.Material.Brick] = Effects.One,
	[Enum.Material.Rock] = Effects.One,
	
	[Enum.Material.WoodPlanks] = Effects.Two,
	[Enum.Material.Wood] = Effects.Two,
	
	[Enum.Material.Fabric] = Effects.Three,

	[Enum.Material.LeafyGrass] = Effects.Four,
	[Enum.Material.Ground] = Effects.Four,
	[Enum.Material.Grass] = Effects.Four,
	[Enum.Material.Sand] = Effects.Four,
	[Enum.Material.Snow] = Effects.Four,
	[Enum.Material.Mud] = Effects.Four,

	[Enum.Material.SmoothPlastic] = Effects.Five,
	[Enum.Material.Plastic] = Effects.Five,
	
	[Enum.Material.CorrodedMetal] = Effects.Six,
	[Enum.Material.DiamondPlate] = Effects.Six,
	[Enum.Material.Metal] = Effects.Six,
}

--> Module <--
local WorldEffects = {}

--// Internals
function WorldEffects._GetSound(EffectGroup)
	local Index = math.random(1, #EffectGroup.Sounds)
	local Original = EffectGroup.Sounds[Index]
	local NewSound = Original:Clone()
	
	return NewSound
end

--// Methods
function WorldEffects.ProduceImpact(Material: Enum.Material, Position: Vector3, Normal: Vector3, PlaySound: Boolean | Optional)
	local Effects = GroupMap[Material] or Effects.Misc
	
	local Attachment = Instance.new("Attachment")
	Attachment.CFrame = CFrame.new(Position, Position + Normal)
	Attachment.Parent = workspace.Terrain
	
	local NewParticles = Effects.Particles:Clone()
	NewParticles.Parent = Attachment
	NewParticles:Emit(NewParticles.Rate)
	
	if PlaySound ~= false then
		local Sound = WorldEffects._GetSound(Effects)
		Sound.PlayOnRemove = true
		Sound.Parent = Attachment
		Sound:Destroy()
	end

	Debris:AddItem(Attachment, NewParticles.Lifetime.Max)
end

return WorldEffects
