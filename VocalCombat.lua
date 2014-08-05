--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
# VocalCombat v0.0.4-alpha                                                    #
# Author: Zaydok                                                              #
# Last Modified: August 4th, 2014                                             #
-------------------------------------------------------------------------------
--]]---------------------------------------------------------------------------

--[[ TODO:
	* Interrupt Armor changes
	* Group buffs
	* Display spells that could of been interrupted if not interrupted
	* Configuration UI
	* Communicate current CDs on interrupt abilities
--]]

-- Load dependencies
require 'Window'

-- Define VocalCombat Module
local VocalCombat = {}

-- Create instance of the AddOn class
function VocalCombat:new( AddOn )
	-- Create instance of the AddOn class if one is not provided
	AddOn = AddOn or {}
	-- Use self as a metatable for AddOn
	setmetatable( AddOn, self )
	-- Inherit from AddOn
	self.__index = self
	-- Initialization variables here
	self.isUIHidden = true
	self.playerUnit = {}
	self.goodCastResults = {}
	-- Return instance of AddOn class
	return AddOn
end

-- Initialize VocalCombat
function VocalCombat:Init()
	-- Import localized text
	-- L = VocalCombatLocalization
	-- Register VocalCombat w/ Apollo
	Apollo.RegisterAddon( self )
end

-- Handle OnLoad
function VocalCombat:OnLoad()
	-- Register slash command
	-- Apollo.RegisterSlashCommand( 'vc', 'OnSlashCommand', self )
	-- Register event listeners
	-- Apollo.RegisterEventHandler( 'CombatLogModifyInterruptArmor', 'OnCombatLogModifyInterruptArmor' )
	Apollo.RegisterEventHandler( 'CombatLogInterrupted', 'OnCombatLogInterrupted', self )
	-- Load UI (hidden by default)
	-- self.windowMain = Apollo.LoadForm( 'VocalCombat.xml', 'VocalCombatUI', nil, self )
	-- self.windowMain:Show( false )
	-- Display successfully loaded message to system chat
	ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_System, 'VocalCombat v0.0.4-alpha loaded successfully! You\'re a vocal beast!', '' )
	-- Get playerUnit
	self.playerUnit = GameLib.GetPlayerUnit()
end

-- Handle slash command /vc
-- function VocalCombat:OnSlashCommand()
	-- Show config UI
	--self.windowMain:Show( true )
-- end

-- Handle CombatLogModifyInterruptArmor event
-- function VocalCombat:OnCombatLogModifyInterruptArmor( modification )
	-- Coming soon!
-- end

-- Handle CombatLogInterrupted event
function VocalCombat:OnCombatLogInterrupted( interrupt )
	local caster = interrupt.unitCaster
	local target = interrupt.unitTarget
	local targetSpell = interrupt.splCallingSpell
	local interruptingSpell = interrupt.splInterruptingSpell
	-- Make sure player unit info is available
	if self.playerUnit == {} then
		-- Get playerUnit
		self.playerUnit = GameLib.GetPlayerUnit()
	end
	-- Filter interrupt events where the player and target are the same
	if target:GetName() == self.playerUnit:GetName() then return end
	-- If cast result is good
	if VocalCombat:IsGoodCastResult( interrupt.eCastResult ) then
		-- Filter interrupt notifications to those where the player was the caster
		if caster:GetName() == self.playerUnit:GetName() then
			-- Vocalize interrupt via chat
			ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Say, 'Interrupted [IA Max = ' .. target:GetInterruptArmorMax() .. '] ' ..target:GetName() .. '\'s ' .. targetSpell:GetName() .. '!', '' )
		end
	else -- Cast result not worthy of notification, spell cancel, etc.
		return
	end
end

-- Cast result helper function
function VocalCombat:IsGoodCastResult( resultCode )
	-- Populate table with good cast result codes
	self.goodCastResults = {
		36 -- 'You are Stunned'
	}
	-- Loop through good cast results to see if current result code is one
	do
		local i = 1
		while i <= #self.goodCastResults do
			if resultCode == self.goodCastResults[ i ] then
				return true
			end
			i = i + 1
		end
	end
	return false
end

-- Create instance of VocalCombat and initialize it
local VocalCombatInst = VocalCombat:new()
VocalCombatInst:Init()