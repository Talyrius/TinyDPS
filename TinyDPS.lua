---------------------------------------------------------------------------------------------------------------------------------
--- header ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	-- TinyDPS
	-- Written by Sideshow (Draenor EU)

	-- 1 name, 2 player: petlist / pet: petguid, 3 class, 4 timestamp
	-- 5 overall damage, 6 overall attacked, 7 overall healing, 8 overall healed, 9 overall time
	-- 10 current damage, 11 current attacked, 12 current healing, 13 current healed, 14 current time
	-- 15 previous damage, 16 previous attacked, 17 previous healing, 18 previous healed, 19 previous time

	-- 1 overall damage total, 2 overall healing total, 3 current damage total, 4 current healing total, 5 previous damage total, 6 previous healing total

	-- 0.42 BETA
	-- fixed: detecting of pets of pets (read: greater fire/earth elementals)
	-- changed: resizing is now with a tiny grip (bottom right of the frame)
	-- added: you can now scroll
	-- added: short dps format
	-- many code tweaks

	-- 0.41 BETA
	-- fixed: better pet tracking (also tracks water elementals now)
	-- changed: reporting menu and code
	-- changed: reworked color code and menu
	-- added: there is now an option to show rank numbers
	-- added: mousebutton3 resets data, mousebutton4 shows overall data, mousebutton5 shows current fight

	-- 0.40 BETA
	-- fixed: problem with tracking of (some) players
	-- fixed: bug with 'hide out of combat'
	-- fixed: bug in reporting
	-- changed: a new fight will now be started even when the first hit is a miss
	-- changed: function names for scope security
	-- added: you can change the anchor, meaning the frame can grow upwards now
	-- added: you can separately show and hide damage, percentage or dps
	-- added: no shared media yet, but I added a pixel-font for those who care :)

	-- 0.39 BETA
	-- fixed: error in option 'show only yourself'
	-- change: context menu cleaned once again
	-- added: option to auto hide out of combat
	-- added: commands: /tdps show | hide | reset
	-- added: option to enable or disable DPS and Percent
	-- code optimalization

	-- 0.37 BETA
	-- initial release




---------------------------------------------------------------------------------------------------------------------------------
--- variables -------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local b, px, tmp, t , inCombat, subTitle, maxValue, barsWithValue, scrollPosition = {}, 0, nil, 0, nil, '', 0, 0, 1
	local i1, i2, i3, t1 = 5, 6, 9, 1

	local classColorDefault = {UNKNOWN = {0, 0, 0, 1}, WARRIOR = {.78, .61, .43, 1}, MAGE = {.41, .80, .94, 1}, ROGUE = {1, .96, .41, 1}, DRUID = {1, .49, .04, 1}, HUNTER = {.67, .83, .45, 1}, SHAMAN = {.14, .35, 1, 1}, PRIEST = {1, 1, 1, 1}, WARLOCK = {.58, .51, .79, 1}, PALADIN = {.96, .55, .73, 1}, DEATHKNIGHT = { .77, .12, .23, 1}}
	local isValidEvent = {SPELL_SUMMON = true, SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true, SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true, SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isMissed = {SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isSpellDamage = {RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true}

	local function tdpsInitTables()
		tdpsPet = {}
		tdpsPlayer = {}
		tdpsPointer = {}
		tdps = {}
			tdps.view = 1
			tdps.segment = 1
			tdps.anchor = 'TOPLEFT'
			tdps.hideOOC = false
			tdps.hideAlways = false
			tdps.visible = 99
			tdps.fontSize = 12
			tdps.seperator = 2
			tdps.barHeight = 14
			tdps.shortDPS = false
			tdps.shortDamage = false
			tdps.showDPS = true
			tdps.showRank = false
			tdps.showDamage = true
			tdps.showPercent = false
			tdps.firstStart = true
			tdps.swapBarClassColor = false
			tdps.totals = {0, 0, 0, 0, 0, 0}
			tdps.version = GetAddOnMetadata('TinyDPS', 'Version')
			tdps.fontName = 'Interface\\AddOns\\TinyDPS\\Fonts\\Franklin Gothic.ttf'
			tdps.bar = {.5, .5, .5, .5}
			tdps.border = {0, 0, 0, .8}
			tdps.backdrop = {0, 0, 0, .8}
			tdps.classColor = {WARRIOR = {.78, .61, .43, 1}, MAGE = {.41, .80, .94, 1}, ROGUE = {1, .96, .41, 1}, DRUID = {1, .49, .04, 1}, HUNTER = {.67, .83, .45, 1}, SHAMAN = {.14, .35, 1, 1}, PRIEST = {1, 1, 1, 1}, WARLOCK = {.58, .51, .79, 1}, PALADIN = {.96, .55, .73, 1}, DEATHKNIGHT = { .77, .12, .23, 1}}
	end

	tdpsInitTables()





---------------------------------------------------------------------------------------------------------------------------------
--- TinyDPS frame ---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	-- mover frame
	CreateFrame('Frame', 'tdpsMover', UIParent)
	tdpsMover:SetWidth(5)
	tdpsMover:SetHeight(5)
	tdpsMover:SetMovable(1)
	tdpsMover:SetPoint('CENTER')
	tdpsMover:SetFrameStrata('BACKGROUND')
	tdpsMover:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
	tdpsMover:SetBackdropColor(0,0,0,0)
	tdpsMover:SetBackdropBorderColor(0,0,0,0)

	-- main window
	CreateFrame('Frame', 'tdpsFrame', UIParent)
	tdpsFrame:SetWidth(128)
	tdpsFrame:SetHeight(tdps.barHeight+4)
	tdpsFrame:EnableMouse(1)
	tdpsFrame:EnableMouseWheel(1)
	tdpsFrame:SetResizable(1)
	tdpsFrame:SetPoint('TOPLEFT', tdpsMover, 'TOPLEFT')
	tdpsFrame:SetFrameStrata('MEDIUM')
	tdpsFrame:SetFrameLevel(1)
	tdpsFrame:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } })

	-- 'TinyDPS' string
	tdpsFrame:CreateFontString('Nodata', 'OVERLAY')
	Nodata:SetPoint('CENTER', tdpsFrame, 'CENTER', 0, 1)
	Nodata:SetJustifyH('CENTER')
	Nodata:SetFont(tdps.fontName, tdps.fontSize)
	Nodata:SetShadowColor(.1, .1, .1, 1)
	Nodata:SetShadowOffset(1, -1)
	Nodata:SetTextColor(1, 1, 1, .1)
	Nodata:SetText('TinyDPS')
	





---------------------------------------------------------------------------------------------------------------------------------
--- functions -------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local bitband, select = bit.band, select
	local floor, ceil, min, max, abs, rand = math.floor, math.ceil, math.min, math.max, abs, random
	local tablesort, tableremove, tableinsert = table.sort, table.remove, table.insert
	local pairs, ipairs = pairs, ipairs
	local UnitAffectingCombat = UnitAffectingCombat
	local PlaySoundFile = PlaySoundFile
	local GetNumRaidMembers, GetNumPartyMembers = GetNumRaidMembers, GetNumPartyMembers
	local CreateFrame = CreateFrame
	local find, sub, split, lower, tonum = strfind, strsub, strsplit, strlower, tonumber
	local UnitName, UnitGUID, UnitClass = UnitName, UnitGUID, UnitClass
	local UnitIsPlayer, UnitCanCooperate = UnitIsPlayer, UnitCanCooperate

	local function tdpsGetIndex()
		if tdps.segment == 1 and tdps.view == 1 then i1 = 5 i2 = 6 i3 = 9 t1 = 1 subTitle = 'Damage for Overall Data'
		elseif tdps.segment == 1 and tdps.view == 2 then i1 = 7 i2 = 8 i3 = 9 t1 = 2 subTitle = 'Healing for Overall Data'
		elseif tdps.segment == 2 and tdps.view == 1 then i1 = 10 i2 = 11 i3 = 14 t1 = 3 subTitle = 'Damage for Current Fight'
		elseif tdps.segment == 2 and tdps.view == 2 then i1 = 12 i2 = 13 i3 = 14 t1 = 4 subTitle = 'Healing for Current Fight'
		elseif tdps.segment == 3 and tdps.view == 1 then i1 = 15 i2 = 16 i3 = 19 t1 = 5 subTitle = 'Damage for Previous Fight'
		elseif tdps.segment == 3 and tdps.view == 2 then i1 = 17 i2 = 18 i3 = 19 t1 = 6 subTitle = 'Healing for Previous Fight'
		end
	end

	local function round(num, idp)
	  local mult = 10^(idp or 0)
	  return floor(num * mult + .5) / mult
	end

	local function getClass(name)
		return select(2,UnitClass(name)) or 'UNKNOWN'
	end

	local function formatDamage(n) if tdps.shortDamage then if n > 999999 then return round(n/1e6,1) .. 'M' elseif n > 99999 then return round(n/1e3,0) .. 'K' elseif n > 9999 then return round(n/1e3,1) .. 'K' end end return n end
	local function formatDPS(d) if d < 100 then return round(d,1) elseif tdps.shortDPS and d > 9999 then return round(d/1000,0)..'K' else return floor(d) end end
	local function formatTime(s) if s < 100 then return round(s,1) .. 's' else return floor(s) .. 's' end end --local m = 0 --while s >= 60 do s = s - 60 m = m + 1 end --if m > 0 then return m .. 'm ' .. s .. 's' end --return s .. 's'
	local function formatPercent(p) return round(p,1)..'%' end

	local function tdpsUpdate()
		maxValue, barsWithValue = 0, 0
		-- configure the bars
		for i=1,#b do
			b[i]:Hide()
			-- get own numbers
			local n, s, str  = tdpsPlayer[b[i].guid][i1], tdpsPlayer[b[i].guid][i3], ''
			-- add pet numbers
			local pets = tdpsPlayer[b[i].guid][2] for i=1,#pets do n = n + tdpsPet[pets[i]][i1] if tdpsPet[pets[i]][i3] > s then s = tdpsPet[pets[i]][i3] end end
			-- update values
			if n > 0 then
				barsWithValue = barsWithValue + 1
				if n > maxValue then maxValue = n end
				if tdps.showDamage then str = formatDamage(n) end
				if tdps.showPercent then str = str .. ' ' .. formatPercent(n/tdps.totals[t1]*100) end
				if tdps.showDPS then str = str .. ' ' .. formatDPS(n/s) end
				b[i].numbersFS:SetText(str)
			end
			b[i].n = n
		end
		-- position the bars
		px = -2
		tablesort(b,function(x,y) return x.n > y.n end)
		for i=scrollPosition,min(barsWithValue,tdps.visible+scrollPosition-1) do
			b[i]:SetMinMaxValues(0, maxValue)
			b[i]:SetValue(b[i].n)
			b[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
			if tdps.showRank then b[i].nameFS:SetText(i..'. '..b[i].name) else b[i].nameFS:SetText(b[i].name) end
			px = px - tdps.barHeight - tdps.seperator
			b[i]:Show()
		end
		-- set frame height
		local h = abs(px) + 2 - tdps.seperator
		if h < tdps.barHeight then tdpsFrame:SetHeight(tdps.barHeight+4) Nodata:Show() else tdpsFrame:SetHeight(h) Nodata:Hide() end
	end

	local function changeView(v) tdps.view = v tdpsGetIndex() scrollPosition = 1 tdpsUpdate() end
	local function changeSegment(s) tdps.segment = s tdpsGetIndex() scrollPosition = 1 tdpsUpdate() end
	local function changeSeperator(s) if s < 0 then tdps.seperator = 0 elseif s > 10 then tdps.seperator = 10 else tdps.seperator = s end tdpsUpdate() end
	local function changeVisible(v) tdps.visible = v scrollPosition = 1 tdpsUpdate() end
	local function changeBarHeight(h) if h < 2 then h = 2 elseif h > 40 then h = 40 end for i=1,#b do b[i]:SetHeight(h) end tdps.barHeight = h tdpsUpdate() end
	local function changeFontSize(s) if s < 4 then s = 4 elseif s > 30 then s = 30 end Nodata:SetFont(tdps.fontName, s) for i=1,#b do b[i].nameFS:SetFont(tdps.fontName, s) b[i].numbersFS:SetFont(tdps.fontName, s) end tdps.fontSize = s tdpsUpdate() end
	local function changeFont(f) f = 'Interface\\AddOns\\TinyDPS\\Fonts\\' .. f Nodata:SetFont(f, tdps.fontSize) for i=1,#b do b[i].nameFS:SetFont(f, tdps.fontSize) b[i].numbersFS:SetFont(f, tdps.fontSize) end tdps.fontName = f tdpsUpdate() end

	local function newFight(t)
		tdps.newFight = nil
		if tdps.segment ~= 1 then scrollPosition = 1 end
		tdps.totals[5] = tdps.totals[3]
		tdps.totals[6] = tdps.totals[4]
		tdps.totals[3] = 0
		tdps.totals[4] = 0
		for _,v in pairs(tdpsPlayer) do
			v[15] = v[10] v[16] = v[11] v[17] = v[12] v[18] = v[13] v[19] = v[14] -- copy current fight to previous fight
			v[10] = 0 v[11] = {} v[12] = 0 v[13] = {} v[14] = 0 -- make current fight empty
		end
		for _,v in pairs(tdpsPet) do
			v[15] = v[10] v[16] = v[11] v[17] = v[12] v[18] = v[13] v[19] = v[14]
			v[10] = 0 v[11] = {} v[12] = 0 v[13] = {} v[14] = 0
		end
	end

	local function isCombat()
		if UnitAffectingCombat('player') then return true end
		for i=1,GetNumRaidMembers() do
			if UnitAffectingCombat('raid'..i) then return true end -- or UnitAffectingCombat('raidpet'..i)
		end
		for i=1,GetNumPartyMembers() do
			if UnitAffectingCombat('party'..i) then return true end -- or UnitAffectingCombat('partypet'..i)
		end
	end

	local function getPetOwnerName(petguid)
		local n, s
		if petguid == UnitGUID('pet') then n, s = UnitName('player') if s then return n..'-'..s else return n end
		else
			for i=1,GetNumRaidMembers() do
				if petguid == UnitGUID('raidpet'..i) then n, s = UnitName('raid'..i) if s then return n..'-'..s else return n end end
			end
			for i=1,GetNumPartyMembers() do
				if petguid == UnitGUID('partypet'..i) then n, s = UnitName('party'..i) if s then return n..'-'..s else return n end end
			end
		end
	end

	local function getPetOwnerGUID(petguid)
		if petguid == UnitGUID('pet') then return UnitGUID('player')
		else
			for i=1,GetNumRaidMembers() do
				if petguid == UnitGUID('raidpet'..i) then return UnitGUID('raid'..i) end
			end
			for i=1,GetNumPartyMembers() do
				if petguid == UnitGUID('partypet'..i) then return UnitGUID('party'..i) end
			end
		end
	end
	
	local function isPartyPet(petguid)
		if petguid == UnitGUID('pet') then return true
		else
			for i=1,GetNumRaidMembers() do
				if petguid == UnitGUID('raidpet'..i) then return true end
			end
			for i=1,GetNumPartyMembers() do
				if petguid == UnitGUID('partypet'..i) then return true end
			end
		end
	end

	local function isExcludedPet(p) -- works only in english clients at the moment...
		-- exclude a shitload of totems
		if find(p,'Wrath of Air Totem') or find(p,'Mana Spring') or find(p,'Strength of Earth Totem') or find(p,'Windfury Totem') or find(p,'Cleansing Totem')	or find(p,'Stoneskin Totem') or find(p,'Totem of Wrath')
		or find(p,'Earthbind Totem') or find(p,'Tremor Totem') or find(p,'Stoneclaw Totem') or find(p,'Grounding Totem') or find(p,'Flametongue Totem') or find(p,'Mana Tide')
		-- exclude summons by debuffs
		or p=='Web Wrap' or p=='Snake Wrap' or p=='Swarming Shadows' or p=='Bone Spike'
		-- some vanity pets trigger a spell_summon
		or p=='Worg Pup' or p=='Mechanical Squirrel' or p=='Smolderweb Hatchling'
		-- some randoms
		or p=='Anti-Magic Zone'
			then return true end
	end

	function updateAllBarColors()
		if tdps.swapBarClassColor then
			for i=1,#b do
				b[i]:SetStatusBarColor(tdps.classColor[tdpsPlayer[b[i].guid][3]][1], tdps.classColor[tdpsPlayer[b[i].guid][3]][2], tdps.classColor[tdpsPlayer[b[i].guid][3]][3], tdps.classColor[tdpsPlayer[b[i].guid][3]][4])
				b[i].nameFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				b[i].numbersFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			end
		else
			for i=1,#b do
				b[i]:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				b[i].nameFS:SetTextColor(tdps.classColor[tdpsPlayer[b[i].guid][3]][1], tdps.classColor[tdpsPlayer[b[i].guid][3]][2], tdps.classColor[tdpsPlayer[b[i].guid][3]][3], tdps.classColor[tdpsPlayer[b[i].guid][3]][4])
				b[i].numbersFS:SetTextColor(tdps.classColor[tdpsPlayer[b[i].guid][3]][1], tdps.classColor[tdpsPlayer[b[i].guid][3]][2], tdps.classColor[tdpsPlayer[b[i].guid][3]][3], tdps.classColor[tdpsPlayer[b[i].guid][3]][4])
			end
		end
	end

	local function tdpsHelp(v)
		if v == 'ver' then
			print('|cfffee00fTinyDPS |cffffff9fVersion ' .. GetAddOnMetadata('TinyDPS', 'Version'))
			print('|cfffee00fTinyDPS |cffffff9fWritten by Sideshow (Draenor EU)')
		elseif v == 'help' then
			print('|cfffee00fTinyDPS |cffffff9fShift-left click to move the window.')
			print('|cfffee00fTinyDPS |cffffff9fPress middle mouse button to reset all data.')
			print('|cfffee00fTinyDPS |cffffff9fMouse back/forward to switch between overall data and current fight.')
		else
			print('|cfffee00fTinyDPS |cffffff9fCommands: /tdps show | hide | reset | help')
		end
	end

	local function tdpsReset()
		for i=1,#b do b[i]:ClearAllPoints() b[i]:Hide() end
		tdpsPlayer, tdpsPet, tdpsPointer, b = {}, {}, {}, {}
		tdps.totals = {0, 0, 0, 0, 0, 0}
		scrollPosition = 1
		tdpsFrame:SetHeight(tdps.barHeight+4)
		Nodata:Show()
		collectgarbage()
		print('|cffffee00TinyDPS |cffffff9fAll data has been reset')
		PlaySoundFile('Sound\\Interface\\PickUp\\PickUpParchment_Paper.wav')
	end

	SLASH_TINYDPS1, SLASH_TINYDPS2 = '/tinydps', '/tdps'
	function SlashCmdList.TINYDPS(msg, editbox)
		if lower(msg) == 'reset' then tdpsReset()
		elseif lower(msg) == 'hide' then tdpsFrame:Hide() tdps.hideAlways = true CloseDropDownMenus()
		elseif lower(msg) == 'show' then tdps.hideAlways = false tdps.hideOOC = false tdpsUpdate() tdpsFrame:Show()
		elseif lower(msg) == 'help' then tdpsHelp('help')
		else tdpsHelp() end
	end

	local function tdpsReport(channel, length)
		if not b[1] or b[1]:GetValue() == 0 then print("|cffffee00TinyDPS |cffffff9fNo data to report") return end
		if channel == 'WHISPER' and (not UnitIsPlayer('target') or not UnitCanCooperate('player', 'target')) then print('|cffffee00TinyDPS |cffffff9fInvalid or no target selected') return end
		-- get grand total
		SendChatMessage('Total ' .. subTitle, channel, nil, UnitName('target')) -- .. '  ' .. tdps.totals[t1]
		tdpsUpdate()
		-- report
		for i=1,min(#b, length) do
			if b[i] and b[i].n > 0 then
				-- get time
				local s = tdpsPlayer[b[i].guid][i3]
				-- add pet numbers
				local pets = tdpsPlayer[b[i].guid][2] for i=1,#pets do if tdpsPet[pets[i]][i3] > s then s = tdpsPet[pets[i]][i3] end end
				-- print
				SendChatMessage(i .. '.  ' .. b[i].name .. '  ' .. b[i].n .. '  ' .. formatPercent(b[i].n/tdps.totals[t1]*100) .. '  (' .. formatDPS(b[i].n/s) .. ')', channel, nil, UnitName('target'))
			end
		end
	end

	local tdpsDropDown, tdpsMenuTable = CreateFrame('Frame', 'tdpsDropDown', nil, 'UIDropDownMenuTemplate'), nil
	local function tdpsMenu()
		tdpsMenuTable = {}
		tdpsMenuTable = {
			{ text = 'TinyDPS          ', isTitle = 1, notCheckable = 1 }, --{ text = ' ', disabled = true },
			{ text = 'File', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Overall Data', checked = function() if tdps.segment == 1 then return true end end, func = function() if tdps.segment ~= 1 then changeSegment(1) end end },
					{ text = 'Current Fight', checked = function() if tdps.segment == 2 then return true end end, func = function() if tdps.segment ~= 2 then changeSegment(2) end end },
					{ text = 'Previous Fight', checked = function() if tdps.segment == 3 then return true end end, func = function() if tdps.segment ~= 3 then changeSegment(3) end end },
					{ text = 'Show Damage', checked = function() if tdps.view == 1 then return true end end, func = function() if tdps.view ~= 1 then changeView(1) end end },
					{ text = 'Show Healing', checked = function() if tdps.view == 2 then return true end end, func = function() if tdps.view ~= 2 then changeView(2) end end },
					{ text = ' ', disabled = true },
					{ text = 'Reset Data Now', func = function() tdpsReset() CloseDropDownMenus() end }
				}
			},
			{ text = 'Report', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Top 5', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() tdpsReport('SAY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() tdpsReport('RAID', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() tdpsReport('PARTY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() tdpsReport('GUILD', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() tdpsReport('WHISPER', 5) CloseDropDownMenus() end, notCheckable = 1 }
						}
					},
					{ text = 'Top 10', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() tdpsReport('SAY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() tdpsReport('RAID', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() tdpsReport('PARTY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() tdpsReport('GUILD', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() tdpsReport('WHISPER', 10) CloseDropDownMenus() end, notCheckable = 1 }
						}
					}
				}
			},
			{ text = 'Options', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Font', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Size', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Increase', func = function() changeFontSize(tdps.fontSize+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeFontSize(tdps.fontSize-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Name', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Visitor', func = function() changeFont('Visitor.ttf') end, checked = function() if find(tdps.fontName, 'Visitor') then return true end end },
									{ text = 'Berlin Sans', func = function() changeFont('Berlin Sans.ttf') end, checked = function() if find(tdps.fontName, 'Berlin') then return true end end },
									{ text = 'Avant Garde', func = function() changeFont('Avant Garde.ttf') end, checked = function() if find(tdps.fontName, 'Avant') then return true end end },
									{ text = 'Franklin Gothic', func = function() changeFont('Franklin Gothic.ttf') end, checked = function() if find(tdps.fontName, 'Franklin') then return true end end }
								}
							}
						}
					},
					{ text = 'Colors', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Bar', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									updateAllBarColors()
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									updateAllBarColors()
								end,
								r = tdps.bar[1], g = tdps.bar[2], b = tdps.bar[3], opacity = 1 - tdps.bar[4],
								notCheckable = 1
							},
							{ text = 'Border', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdpsFrame:SetBackdropBorderColor(red, green, blue, alpha)
									tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4] = red, green, blue, alpha
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdpsFrame:SetBackdropBorderColor(red, green, blue, alpha)
									tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4] = red, green, blue, alpha
								end,
								r = tdps.border[1], g = tdps.border[2], b = tdps.border[3], opacity = 1 - tdps.border[4],
								notCheckable = 1
							},
							{ text = 'Backdrop', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdpsFrame:SetBackdropColor(red, green, blue, alpha)
									tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4] = red, green, blue, alpha
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdpsFrame:SetBackdropColor(red, green, blue, alpha)
									tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4] = red, green, blue, alpha
								end,
								r = tdps.backdrop[1], g = tdps.backdrop[2], b = tdps.backdrop[3], opacity = 1 - tdps.backdrop[4],
								notCheckable = 1
							},
							{ text = 'Dim Class Colors', notCheckable = 1, func = function() for c,v in pairs(tdps.classColor) do if v[4]-.1 < 0 then v[4] = 0 else v[4] = v[4]-.1 end end updateAllBarColors() end, keepShownOnClick = 1 },
							{ text = 'Reset Class Colors', notCheckable = 1, func = function() for c,_ in pairs(tdps.classColor) do tdps.classColor[c] = {unpack(classColorDefault[c])} end updateAllBarColors() end, keepShownOnClick = 1 },
							{ text = 'Swap Bar/Class Color', notCheckable = 1, func = function() tdps.swapBarClassColor = not tdps.swapBarClassColor updateAllBarColors() end, keepShownOnClick = 1 },
							--{ text = 'Warrior', notClickable = 1 },{ text = 'Rogue', notClickable = 1 },{ text = 'Paladin', notClickable = 1 },{ text = 'Priest', notClickable = 1 },
							--{ text = 'Shaman', notClickable = 1 },{ text = 'Hunter', notClickable = 1 },{ text = 'Druid', notClickable = 1 },{ text = 'Deathknight', notClickable = 1 },
							--{ text = 'Warlock', notClickable = 1 },{ text = 'Mage', notClickable = 1,
								--hasColorSwatch = true,
								--swatchFunc = function()
									--ColorPickerOkayButton:Hide()
									--ColorPickerCancelButton:SetText('Close')
									--local red, green, blue = ColorPickerFrame:GetColorRGB()
									--local alpha = 1 - OpacitySliderFrame:GetValue()
									--tdps.classColor['MAGE'][1], tdps.classColor['MAGE'][2], tdps.classColor['MAGE'][3], tdps.classColor['MAGE'][4] = red, green, blue, alpha
									--updateAllBarColors()
								--end,
								--hasOpacity = true,
								--opacityFunc = function()
									--local red, green, blue = ColorPickerFrame:GetColorRGB()
									--local alpha = 1 - OpacitySliderFrame:GetValue()
									--tdps.classColor['MAGE'][1], tdps.classColor['MAGE'][2], tdps.classColor['MAGE'][3], tdps.classColor['MAGE'][4] = red, green, blue, alpha
									--updateAllBarColors()
								--end,
								--r = tdps.classColor['MAGE'][1], g = tdps.classColor['MAGE'][2], b = tdps.classColor['MAGE'][3], opacity = 1 - tdps.classColor['MAGE'][4],
								--notCheckable = 1
							--}
						}
					},
					{ text = 'Anchor', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Top', func = function() tdps.anchor = 'TOPLEFT' tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint('TOPLEFT', tdpsMover, 'TOPLEFT') end, checked = function() if tdps.anchor == 'TOPLEFT' then return true end end },
							{ text = 'Bottom', func = function() tdps.anchor = 'BOTTOMLEFT' tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint('BOTTOMLEFT', tdpsMover, 'BOTTOMLEFT') end,  checked = function() if tdps.anchor == 'BOTTOMLEFT' then return true end end }
						}
					},
					{ text = 'Bar Text', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Show DPS', func = function() tdps.showDPS = not tdps.showDPS tdpsUpdate() end, checked = function() return tdps.showDPS end, keepShownOnClick = 1 },
							{ text = 'Show Rank', func = function() tdps.showRank = not tdps.showRank tdpsUpdate() end, checked = function() return tdps.showRank end, keepShownOnClick = 1 },
							{ text = 'Show Percent', func = function() tdps.showPercent = not tdps.showPercent tdpsUpdate() end, checked = function() return tdps.showPercent end, keepShownOnClick = 1 },
							{ text = 'Show Damage', func = function() tdps.showDamage = not tdps.showDamage tdpsUpdate() end, checked = function() return tdps.showDamage end, keepShownOnClick = 1 },
							{ text = 'Short DPS Format', func = function() tdps.shortDPS = not tdps.shortDPS tdpsUpdate() end, checked = function() return tdps.shortDPS end, keepShownOnClick = 1 },
							{ text = 'Short Damage Format', func = function() tdps.shortDamage = not tdps.shortDamage tdpsUpdate() end, checked = function() return tdps.shortDamage end, keepShownOnClick = 1 }
						}
					},
					{ text = 'Bar Height', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Increase', func = function() changeBarHeight(tdps.barHeight+1) end, notCheckable = 1, keepShownOnClick = 1 },
							{ text = 'Decrease', func = function() changeBarHeight(tdps.barHeight-1) end, notCheckable = 1, keepShownOnClick = 1 }
						}
					},
					{ text = 'Bar Seperator', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Increase', func = function() changeSeperator((tdps.seperator or 0)+1) end, notCheckable = 1, keepShownOnClick = 1 },
							{ text = 'Decrease', func = function() changeSeperator((tdps.seperator or 0)-1) end, notCheckable = 1, keepShownOnClick = 1 }
						}
					},
					{ text = 'Visible Players', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'All', func = function() changeVisible(99) end, checked = function() if tdps.visible == 99 then return true end end },
							{ text = 'Maximum 5', func = function() changeVisible(5) end, checked = function() if tdps.visible == 5 then return true end end },
							{ text = 'Maximum 10', func = function() changeVisible(10) end, checked = function() if tdps.visible == 10 then return true end end },
							{ text = 'Maximum 15', func = function() changeVisible(15) end, checked = function() if tdps.visible == 15 then return true end end },
							{ text = 'Maximum 20', func = function() changeVisible(20) end, checked = function() if tdps.visible == 20 then return true end end }
						}
					},
					{ text = 'More', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Hide Out of Combat', func = function() tdps.hideOOC = not tdps.hideOOC CloseDropDownMenus() t = 3 end, checked = function() return tdps.hideOOC end, keepShownOnClick = 1 }
						}
					},
				}
			},
			{ text = 'Close Menu', func = function() CloseDropDownMenus() end, notCheckable = 1 }
		}
	end

	local function scroll(d)
		if b[1] and b[1].n > 0 and scrollPosition - d > 0 and scrollPosition - d + tdps.visible <= barsWithValue + 1 then
			scrollPosition = scrollPosition - d
			tdpsUpdate()
		end
	end

	local function tdpsMakeBar(g)
		local classR, classG, classB, classA = unpack(tdps.classColor[tdpsPlayer[g][3]])
		-- status bar
		local dummybar = CreateFrame('Statusbar', 'tdpsStatusBar' .. tdpsPlayer[g][1], tdpsFrame)
		dummybar:SetFrameStrata('MEDIUM')
		dummybar:SetFrameLevel(2)
		dummybar:SetOrientation('HORIZONTAL')
		dummybar:EnableMouse(1)
		dummybar:EnableMouseWheel(1)
		dummybar:SetWidth(tdpsFrame:GetWidth() - 4)
		dummybar:SetHeight(tdps.barHeight)
		dummybar:Hide()
		dummybar:SetPoint('RIGHT', tdpsFrame, 'RIGHT', -2, 0)
		dummybar:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
		dummybar:SetStatusBarTexture('Interface\\AddOns\\TinyDPS\\Textures\\wglass')
		dummybar:SetBackdropColor(0, 0, 0, 0)
		dummybar:SetBackdropBorderColor(0, 0, 0, 0)
		-- hidden bar info
		dummybar.name, dummybar.guid, dummybar.n = split('-', tdpsPlayer[g][1]), g, 0
		-- bar scripts
		dummybar:SetScript('OnEnter', function(self)
			tdpsMover:SetScript('OnUpdate', nil)
			GameTooltip:SetOwner(dummybar)
			GameTooltip:SetText(tdpsPlayer[g][1])
			GameTooltip:AddLine(subTitle, 1, .85, 0)
			local pets, combatTime, petAmount = tdpsPlayer[g][2], tdpsPlayer[g][i3], 0
			for i=1,#pets do petAmount = petAmount + tdpsPet[pets[i]][i1] end --if tdpsPet[pets[i]][i3] > combatTime then combatTime = tdpsPet[pets[i]][i3] end
			GameTooltip:AddDoubleLine('Personal', tdpsPlayer[self.guid][i1] .. ' (' .. formatPercent(tdpsPlayer[self.guid][i1]/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1)
			--for i=1,#pets do
				--if tdpsPet[pets[i]][i3] > combatTime then combatTime = tdpsPet[pets[i]][i3] end
				--if tdpsPet[pets[i]][i1] > 0 then
					--GameTooltip:AddDoubleLine('Pet ' .. tdpsPet[pets[i]][1], tdpsPet[pets[i]][i1] .. ' (' .. formatPercent(tdpsPet[pets[i]][i1]/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1)
				--end
			--end
			if petAmount > 0 then GameTooltip:AddDoubleLine('By Pet(s)', petAmount .. ' (' .. formatPercent(petAmount/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1) end
			--GameTooltip:AddDoubleLine('Activity', formatTime(combatTime), 1, 1, 1, 1, 1, 1)
			-- make top damaged or healed
			if tdps.view == 1 then GameTooltip:AddLine('Top Damaged Targets', 1, .85, 0)
			elseif tdps.view == 2 then GameTooltip:AddLine('Top Healed Targets', 1, .85, 0) end
			local mergedTop = {} for k,v in pairs(tdpsPlayer[g][i2]) do mergedTop[k] = v end
			for i=1,#pets do
				for k,v in pairs(tdpsPet[pets[i]][i2]) do
					if mergedTop[k] then mergedTop[k] = mergedTop[k] + v
					else mergedTop[k] = v end
				end
			end
			-- make indexed top so we can sort
			local top = {} for k,v in pairs(mergedTop) do top[#(top)+1] = {k,v} end
			tablesort(top,function(x,y) return x[2] > y[2] end)
			for i=1,3 do if top[i] then GameTooltip:AddDoubleLine(i .. '. ' .. top[i][1], top[i][2].. ' (' .. formatPercent(top[i][2]/(self.n)*100) .. ')', 1, 1, 1, 1, 1, 1) end end
			GameTooltip:Show()
		end)
		dummybar:SetScript('OnLeave', function(self) tdpsMover:SetScript('OnUpdate', tdpsOnUpdate) GameTooltip:Hide() end)
		dummybar:SetScript('OnMouseDown', function(self, button)
			GameTooltip:Hide()
			CloseDropDownMenus()
			if button == 'LeftButton' and IsShiftKeyDown() then tdpsMover:StartMoving()
			elseif button == 'MiddleButton' then tdpsReset()
			elseif button == 'Button4' then if tdps.segment ~= 1 then changeSegment(1) end
			elseif button == 'Button5' then if tdps.segment ~= 2 then changeSegment(2) end
			end
		end)
		dummybar:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() tdpsFrame:StopMovingOrSizing() tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor)
			elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') end
		end)
		dummybar:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)
		-- numbers fontstring
		dummybar.numbersFS = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.numbersFS:SetPoint('RIGHT', -1, 1)
		dummybar.numbersFS:SetJustifyH('RIGHT')
		dummybar.numbersFS:SetFont(tdps.fontName, tdps.fontSize)
		dummybar.numbersFS:SetShadowColor(.05, .05, .05, 1)
		dummybar.numbersFS:SetShadowOffset(1, -1)
		-- name fontstring
		dummybar.nameFS = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.nameFS:SetPoint('LEFT', 1, 1)
		dummybar.nameFS:SetPoint('RIGHT', dummybar.numbersFS, 'LEFT', -2, 1)
		dummybar.nameFS:SetJustifyH('LEFT')
		dummybar.nameFS:SetFont(tdps.fontName, tdps.fontSize)
		dummybar.nameFS:SetShadowColor(.05, .05, .05, 1)
		dummybar.nameFS:SetShadowOffset(1, -1)
		-- colors
		if tdps.swapBarClassColor then
			dummybar:SetStatusBarColor(classR, classG, classB, classA)
			dummybar.numbersFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.nameFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
		else
			dummybar:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.numbersFS:SetTextColor(classR, classG, classB, classA)
			dummybar.nameFS:SetTextColor(classR, classG, classB, classA)
		end
		-- save bar
		tableinsert(b, dummybar)
	end





---------------------------------------------------------------------------------------------------------------------------------
--- eventhandler ----------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local function tdpsCombatEvent(self, event, ...)

		-- return when source is outsider, invalid event, environmental, vehicular, friendly fire, hostile healing
		if arg5 % 8 == 0 or not isValidEvent[arg2] or arg3 == '0x0000000000000000' or sub(arg3,5,5) == '5' or (bitband(arg8,16) > 0 and (isSpellDamage[arg2] or arg2 == 'SWING_DAMAGE')) or (bitband(arg8,16) == 0 and (arg2 == 'SPELL_PERIODIC_HEAL' or arg2 == 'SPELL_HEAL')) then return end

		-- summon event
		if arg2 == 'SPELL_SUMMON' then
			if UnitIsPlayer(arg4) and not isExcludedPet(arg7) then -- add pet when player summons
				-- make owner if necessary
				if not tdpsPlayer[arg3] then tdpsPlayer[arg3] = { arg4, {arg4..': '..arg7}, getClass(arg4), 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 } tdpsMakeBar(arg3) end
				-- make pointer
				tdpsPointer[arg6] = arg4..': '..arg7
				-- make pet if it does not exist yet
				if not tdpsPet[arg4..': '..arg7] then tdpsPet[arg4..': '..arg7] = { arg7, arg6, 'PET', 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 } end
				-- add pet to owner if it's not there yet
				local found = nil for i=1,#tdpsPlayer[arg3][2] do if tdpsPlayer[arg3][2][i] == arg4..': '..arg7 then found = true break end end
				if not found then tableinsert(tdpsPlayer[arg3][2], arg4..': '..arg7) end
			elseif tdpsPointer[arg3] then -- the summoner is a pet himself (for example a totem summons a greater fire elemental)
				 -- ownername of owner
				local oOO = split(':', tdpsPointer[arg3])
				-- make pointer
				tdpsPointer[arg6] = oOO..': '..arg7
				-- make pet
				tdpsPet[oOO..': '..arg7] = { arg7, arg6, 'PET', 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 }
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[UnitGUID(oOO)][2] do if tdpsPlayer[UnitGUID(oOO)][2][i] == oOO..': '..arg7 then found = true break end end
				if not found then tableinsert(tdpsPlayer[UnitGUID(oOO)][2], oOO..': '..arg7) end
			end return
		end

		-- add player or a pet
		if not tdpsPlayer[arg3] and not tdpsPointer[arg3] then
			if UnitIsPlayer(arg4) then
				tdpsPlayer[arg3] = { arg4, {}, getClass(arg4), 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 }
				tdpsMakeBar(arg3)
				tdpsCombatEvent(self, event, ...)
			elseif isPartyPet(arg3) then
				-- get owner
				local ownerGuid, ownerName = getPetOwnerGUID(arg3), getPetOwnerName(arg3)
				-- make owner if it does not exist yet
				if not tdpsPlayer[ownerGuid] then
					tdpsPlayer[ownerGuid] = { ownerName, {ownerName..': '..arg4}, getClass(ownerName), 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 }
					tdpsMakeBar(ownerGuid)
				end
				-- make pointer
				tdpsPointer[arg3] = ownerName .. ': ' .. arg4
				-- make pet if it does not exist yet
				if not tdpsPet[ownerName..': '..arg4] then
					tdpsPet[ownerName..': '..arg4] = { arg4, arg3, 'PET', 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0, 0, {}, 0, {}, 0 }
				end
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[ownerGuid][2] do if tdpsPlayer[ownerGuid][2][i] == ownerName..': '.. arg4 then found = true break end end
				if not found then tableinsert(tdpsPlayer[ownerGuid][2], ownerName..': '.. arg4) end
				tdpsCombatEvent(self, event, ...)
			end
			return
		end

		-- add numbers
		if UnitIsPlayer(arg4) then tmp = tdpsPlayer[arg3] elseif tdpsPet[tdpsPointer[arg3]] then tmp = tdpsPet[tdpsPointer[arg3]] else return end
		if tdps.newFight and isMissed[arg2] then newFight() -- check if we need to start a new fight, even if first hit is a miss
		elseif isSpellDamage[arg2] then
			if tdps.newFight then newFight() end -- check if we need to start a new fight
			tdps.totals[1] = tdps.totals[1] + arg12 -- add damage to total for overall data
			tdps.totals[3] = tdps.totals[3] + arg12 -- add damage to totals for current fight
			tmp[10] = tmp[10] + arg12 -- add damage to current fight
			tmp[5] = tmp[5] + arg12 -- add damage to overall data
			if tmp[11][arg7] then tmp[11][arg7] = tmp[11][arg7] + arg12 else tmp[11][arg7] = arg12 end -- add target info to current fight
			if tmp[6][arg7] then tmp[6][arg7] = tmp[6][arg7] + arg12 else tmp[6][arg7] = arg12 end -- add target info to overall data
		elseif arg2 == 'SWING_DAMAGE' then
			if tdps.newFight then newFight() end
			tdps.totals[1] = tdps.totals[1] + arg9
			tdps.totals[3] = tdps.totals[3] + arg9
			tmp[10] = tmp[10] + arg9
			tmp[5] = tmp[5] + arg9
			if tmp[11][arg7] then tmp[11][arg7] = tmp[11][arg7] + arg9 else tmp[11][arg7] = arg9 end
			if tmp[6][arg7] then tmp[6][arg7] = tmp[6][arg7] + arg9 else tmp[6][arg7] = arg9 end
		elseif (arg2 == 'SPELL_PERIODIC_HEAL' or arg2 == 'SPELL_HEAL') then
			if arg12 - arg13 == 0 or not inCombat then return end -- stop on complete overheal or out of combat
			--if tdps.newFight then newFight() end
			tdps.totals[2] = tdps.totals[2] + arg12 - arg13
			tdps.totals[4] = tdps.totals[4] + arg12 - arg13			
			tmp[12] = tmp[12] + arg12 - arg13
			tmp[7] = tmp[7] + arg12 - arg13
			if tmp[13][arg7] then tmp[13][arg7] = tmp[13][arg7] + arg12 - arg13 else tmp[13][arg7] = arg12 - arg13 end
			if tmp[8][arg7] then tmp[8][arg7] = tmp[8][arg7] + arg12 - arg13 else tmp[8][arg7] = arg12 - arg13 end
		end

		-- add combat time
		if arg1 - tmp[4] < 3.5 then
			tmp[9] = tmp[9] + (arg1 - tmp[4]) -- overall data
			tmp[14] = tmp[14] + (arg1 - tmp[4]) -- current fight
		else
			tmp[9] = tmp[9] + 3.5 -- overall data
			tmp[14] = tmp[14] + 3.5 -- current fight
		end

		-- save time stamp
		tmp[4] = arg1
	end





---------------------------------------------------------------------------------------------------------------------------------
--- scripts ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local function tdpsVariablesLoaded(self, event)
		-- reinitialize on version mismatch
		if GetAddOnMetadata('TinyDPS', 'Version') ~= tdps.version then tdpsInitTables() tdpsGetIndex() tdpsFrame:SetHeight(tdps.barHeight+4)
		-- else just remake the bars
		else for k,_ in pairs(tdpsPlayer) do tdpsMakeBar(k) end tdpsGetIndex() tdpsUpdate() end
		-- set fontsize
		Nodata:SetFont(tdps.fontName, tdps.fontSize)
		-- set colors
		tdpsFrame:SetBackdropBorderColor(tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4])
		tdpsFrame:SetBackdropColor(tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4])
		-- hidden or not
		if (not isCombat() and tdps.hideOOC) or tdps.hideAlways then tdpsFrame:Hide() end
		-- anchor
		tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor)
		-- reset events
		tdpsMover:UnregisterEvent('VARIABLES_LOADED')
		tdpsMover:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		tdpsMover:SetScript('OnEvent', tdpsCombatEvent)
	end

	tdpsMover:RegisterEvent('VARIABLES_LOADED')
	tdpsMover:SetScript('OnEvent', tdpsVariablesLoaded)

	function tdpsOnUpdate(self, elapsed)
		t = t + elapsed
		if t > 2 then
			t = 0
			inCombat = isCombat()
			if inCombat then
				if not tdps.hideAlways then tdpsFrame:Show() end
			else
				tdps.newFight = true
				if tdps.hideOOC and tdpsFrame:IsVisible() then tdpsFrame:Hide() end
			end
			if tdpsFrame:IsVisible() then tdpsUpdate() end
		end
	end

	local function tdpsOnUpdateStart(self, elapsed)
		t = t + elapsed
		if t > 2 then
			if tdps.firstStart then tdpsHelp('ver') tdps.firstStart = false end
			tdpsMover:SetScript('OnUpdate', tdpsOnUpdate)
		end
	end

	tdpsMover:SetScript('OnUpdate', tdpsOnUpdateStart)

	tdpsFrame:SetScript('OnMouseDown', function(self, button)
		CloseDropDownMenus()
		GameTooltip:Hide()
		if button == 'LeftButton' and IsShiftKeyDown() then tdpsMover:StartMoving()
		elseif button == 'MiddleButton' then tdpsReset()
		elseif button == 'Button4' then if tdps.segment ~= 1 then changeSegment(1) end
		elseif button == 'Button5' then if tdps.segment ~= 2 then changeSegment(2) end
		end
	end)

	tdpsFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() tdpsFrame:StopMovingOrSizing() tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor)
		elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') end
	end)
	
	tdpsFrame:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)
	
	
	-- sizer frame
	CreateFrame('Frame', 'tdpsSizer', tdpsFrame)
	tdpsSizer:SetFrameStrata('MEDIUM')
	tdpsSizer:SetFrameLevel(3)
	tdpsSizer:SetWidth(6)
	tdpsSizer:SetHeight(6)
	tdpsSizer:SetPoint('BOTTOMRIGHT', tdpsFrame, 'BOTTOMRIGHT', 0, 0)
	tdpsSizer:EnableMouse(1)
	tdpsSizer:SetScript('OnEnter', function() tdpsMover:SetScript('OnUpdate', nil) tdpsSizerTexture:SetDesaturated(0) tdpsSizerTexture:SetAlpha(1) end)
	tdpsSizer:SetScript('OnLeave', function() tdpsMover:SetScript('OnUpdate', tdpsOnUpdate) tdpsSizerTexture:SetDesaturated(1) tdpsSizerTexture:SetAlpha(.2) end)
	tdpsSizer:SetScript('OnMouseDown', function() tdpsFrame:SetMinResize(60, tdpsFrame:GetHeight()) tdpsFrame:SetMaxResize(400, tdpsFrame:GetHeight()) tdpsFrame:StartSizing() end)
	tdpsSizer:SetScript('OnMouseUp', function() tdpsMover:StopMovingOrSizing() tdpsFrame:StopMovingOrSizing() tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) for i=1,#b do b[i]:SetWidth(tdpsFrame:GetWidth()-4) b[i]:SetValue(0) end tdpsUpdate() end)
	tdpsSizer:CreateTexture('tdpsSizerTexture')
	tdpsSizerTexture:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
	tdpsSizerTexture:SetTexCoord(0.619, 0.760, 0.612, 0.762)
	tdpsSizerTexture:SetDesaturated(1)
	tdpsSizerTexture:SetAlpha(.2)
	tdpsSizerTexture:ClearAllPoints()
	tdpsSizerTexture:SetPoint('TOPLEFT', tdpsSizer)
	tdpsSizerTexture:SetPoint('BOTTOMRIGHT', tdpsSizer, 'BOTTOMRIGHT', 0, 0)