--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
# VocalCombat v0.0.2-alpha                                                    #
# Author: Zaydok                                                              #
# Last Modified: July 30th, 2014                                              #
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
	ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_System, 'VocalCombat v0.0.1a loaded successfully! You\'re a vocal beast!', '' )
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
	-- Filter all other interrupts not cast by player on target other than self
	if target:GetName() == self.playerUnit:GetName() then return end
	-- Filter spell cancels
	if interruptingSpell.strCastResult == 'Spell was cancelled' then return end
	-- If legitimate interrupt
	if caster:GetName() == self.playerUnit:GetName() then
		-- Vocalize interrupt via chat
		ChatSystemLib.PostOnChannel( ChatSystemLib.ChatChannel_Say, 'Interrupted [IA Max = ' .. target:GetInterruptArmorMax() .. '] ' ..target:GetName() .. '\'s ' .. targetSpell:GetName() .. '!', '' )
		-- Vocalize remaining interrupt CD's via chat
	end
end

-- Create instance of VocalCombat and initialize it
local VocalCombatInst = VocalCombat:new()
VocalCombatInst:Init()