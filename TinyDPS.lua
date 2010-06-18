--[[-----------------------------------------------------------------------------------------------------------------------------
--- header ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	TinyDPS - Written by Sideshow (Draenor EU)

	Version 0.71
	* fixed: small bug with overall healing
	* changed: settings are now saved per account
	* changed: tried to improve the options menu again
	* changed: command options (/tdps ? for help)
	* added: you can now report to channels
	* added: options for font shadow and outline
	* added: optional minimap button
	* re-added: "show only yourself"
	* loads of code tweaks

	Version 0.62 BETA
	* fixed: hitching problem
	* changed: context menu
	* added: option to hide when not in a group

	Version 0.61 BETA
	* fixed: bug causing error on displaying damage

	Version 0.60 BETA
	* added: auto reset on new group
	* added: option hide in pvp
	* added: spell detail
	* added: fight history
	* lots of code rewrite

	Version 0.42 BETA
	* fixed: detecting of pets of pets (read: greater fire/earth elementals)
	* changed: resizing is now with a tiny grip (bottom right of the frame)
	* added: you can now scroll
	* added: short dps format
	* many code tweaks

	Version 0.41 BETA
	* fixed: better pet tracking (also tracks water elementals now)
	* changed: reporting menu and code
	* changed: reworked color code and menu
	* added: there is now an option to show rank numbers
	* added: mousebutton3 resets data, mousebutton4 shows overall data, mousebutton5 shows current fight

	Version 0.40 BETA
	* fixed: problem with tracking of (some) players
	* fixed: bug with 'hide out of combat'
	* fixed: bug in reporting
	* changed: a new fight will now be started even when the first hit is a miss
	* changed: function names for scope security
	* added: you can change the anchor, meaning the frame can grow upwards now
	* added: you can separately show and hide damage, percentage or dps
	* added: no shared media yet, but I added a pixel-font for those who care :)

	Version 0.39 BETA
	* fixed: error in option 'show only yourself'
	* change: context menu cleaned once again
	* added: option to auto hide out of combat
	* added: commands: /tdps show | hide | reset
	* added: option to enable or disable DPS and Percent
	* code optimalization

	Version 0.37 BETA
	* initial public release





---------------------------------------------------------------------------------------------------------------------------------
--- variables -------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------]]

	local bar = {}
	local px, tmp, key
	local onUpdateElapsed = 0
	local maxValue, barsWithValue
	local scrollPosition = 1
	local isMovingOrSizing = nil

	local classColorDefault = {UNKNOWN = {.63, .58, .24, 1}, WARRIOR = {.78, .61, .43, 1}, MAGE = {.41, .80, .94, 1}, ROGUE = {1, .96, .41, 1}, DRUID = {1, .49, .04, 1}, HUNTER = {.67, .83, .45, 1}, SHAMAN = {.14, .35, 1, 1}, PRIEST = {1, 1, 1, 1}, WARLOCK = {.58, .51, .79, 1}, PALADIN = {.96, .55, .73, 1}, DEATHKNIGHT = { .77, .12, .23, 1}}
	local isValidEvent = {SPELL_SUMMON = true, SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true, SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true, SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isMissed = {SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isSpellDamage = {RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true}

	local function tdpsInitTables()
		tdpsPet = {}
		tdpsPlayer = {}
		tdpsPointer = {}
		tdps = {
			classColor = {},
			anchor = 'TOPLEFT',
			view = 'd', fight = 'c',
			autoReset = true,
			firstStart = true,
			swapColor = false,
			bar = {.5, .5, .5, .5},
			border = {0, 0, 0, .9},
			backdrop = {0, 0, 0, .9},
			showMinimapButton = true,
			hidden = false, hideOOC = false,
			grouped = false, combat = false,
			showTargets = true, showAbilities = false,
			maxBars = 10, spacing = 2, barHeight = 14,
			version = -1,
			totals = {od = 0, oh = 0, cd = 0, ch = 0, xd = 0, xh = 0, yd = 0, yh = 0, zd = 0, zh = 0},
			shortDPS = false, shortDamage = false, showDPS = true, showRank = true, showDamage = true, showPercent = false,
			font = {name = 'Interface\\AddOns\\TinyDPS\\Fonts\\Berlin Sans.ttf', size = 12, outline = '', shadowX = 1, shadowY = -1}
		}
		for k,v in pairs(classColorDefault) do tdps.classColor[k] = {unpack(classColorDefault[k])} end
	end

	tdpsInitTables()





---------------------------------------------------------------------------------------------------------------------------------
--- frames ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	-- mover frame
	CreateFrame('Frame', 'tdpsMover', UIParent)
	tdpsMover:SetWidth(5)
	tdpsMover:SetHeight(5)
	tdpsMover:SetMovable(1)
	tdpsMover:SetPoint('CENTER')
	tdpsMover:SetFrameStrata('BACKGROUND')
	tdpsMover:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
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
	tdpsFrame:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } })
	tdpsFrame:CreateFontString('noData', 'OVERLAY')
	noData:SetPoint('CENTER', tdpsFrame, 'CENTER', 0, 1)
	noData:SetJustifyH('CENTER')
	noData:SetFont(tdps.font.name, tdps.font.size)
	noData:SetShadowColor(.1, .1, .1, 1)
	noData:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
	noData:SetTextColor(1, 1, 1, .07)
	noData:SetText('TinyDPS')
	
	-- sizer frame
	CreateFrame('Frame', 'tdpsSizerFrame', tdpsFrame)
	tdpsSizerFrame:SetFrameStrata('MEDIUM')
	tdpsSizerFrame:SetFrameLevel(3)
	tdpsSizerFrame:SetWidth(6)
	tdpsSizerFrame:SetHeight(6)
	tdpsSizerFrame:SetPoint('BOTTOMRIGHT', tdpsFrame, 'BOTTOMRIGHT', 0, 0)
	tdpsSizerFrame:EnableMouse(1)
	tdpsSizerFrame:SetScript('OnEnter', function() tdpsSizerTexture:SetDesaturated(0) tdpsSizerTexture:SetAlpha(1) end)
	tdpsSizerFrame:SetScript('OnLeave', function() tdpsSizerTexture:SetDesaturated(1) tdpsSizerTexture:SetAlpha(.2) end)
	tdpsSizerFrame:SetScript('OnMouseDown', function() isMovingOrSizing = true tdpsFrame:SetMinResize(60, tdpsFrame:GetHeight()) tdpsFrame:SetMaxResize(400, tdpsFrame:GetHeight()) tdpsFrame:StartSizing() end)
	tdpsSizerFrame:SetScript('OnMouseUp', function() tdpsFrame:StopMovingOrSizing() tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) isMovingOrSizing = nil for i=1,#bar do bar[i]:SetWidth(tdpsFrame:GetWidth()-4) bar[i]:SetValue(0) end onUpdateElapsed = 3 end)
	tdpsSizerFrame:CreateTexture('tdpsSizerTexture')
	tdpsSizerTexture:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
	tdpsSizerTexture:SetTexCoord(0.619, 0.760, 0.612, 0.762)
	tdpsSizerTexture:SetDesaturated(1)
	tdpsSizerTexture:SetAlpha(.2)
	tdpsSizerTexture:ClearAllPoints()
	tdpsSizerTexture:SetPoint('TOPLEFT', tdpsSizerFrame)
	tdpsSizerTexture:SetPoint('BOTTOMRIGHT', tdpsSizerFrame, 'BOTTOMRIGHT', 0, 0)
	
	-- minimap button
	CreateFrame('Button', 'tdpsButtonFrame', Minimap)
	tdpsButtonFrame:SetHeight(30)
	tdpsButtonFrame:SetWidth(30)
	tdpsButtonFrame:SetMovable(1)
	tdpsButtonFrame:SetUserPlaced(1)
	tdpsButtonFrame:EnableMouse(1)
	tdpsButtonFrame:RegisterForDrag('LeftButton')
	tdpsButtonFrame:SetFrameStrata('MEDIUM')
	tdpsButtonFrame:SetPoint('CENTER', Minimap:GetWidth()/2*-1, Minimap:GetHeight()/2*-1)
	tdpsButtonFrame:CreateTexture('tdpsButtonTexture', 'BACKGROUND')
	tdpsButtonTexture:SetWidth(24)
	tdpsButtonTexture:SetHeight(24)
	tdpsButtonTexture:SetTexture('Interface\\AddOns\\TinyDPS\\Textures\\minimapbutton.blp')
	tdpsButtonTexture:SetPoint('CENTER')
	tdpsButtonFrame:SetNormalTexture(tdpsButtonTexture)
	tdpsButtonFrame:CreateTexture('tdpsButtonTexturePushed', 'BACKGROUND')
	tdpsButtonTexturePushed:SetWidth(24)
	tdpsButtonTexturePushed:SetHeight(24)
	tdpsButtonTexturePushed:SetTexture('Interface\\AddOns\\TinyDPS\\Textures\\minimapbutton.blp')
	tdpsButtonTexturePushed:SetPoint('CENTER', 1, -1)
	tdpsButtonFrame:SetPushedTexture(tdpsButtonTexturePushed)
	tdpsButtonFrame:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
	tdpsButtonFrame:CreateTexture('tdpsButtonOverlay', 'OVERLAY')
	tdpsButtonOverlay:SetWidth(53)
	tdpsButtonOverlay:SetHeight(53)
	tdpsButtonOverlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
	tdpsButtonOverlay:SetPoint('TOPLEFT')
	
	



---------------------------------------------------------------------------------------------------------------------------------
--- functions -------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local bitband, select = bit.band, select
	local floor, ceil, min, max, abs, rand = math.floor, math.ceil, math.min, math.max, abs, random
	local tablesort, tableremove, tableinsert = table.sort, table.remove, table.insert
	local pairs, ipairs, PlaySoundFile, CreateFrame = pairs, ipairs, PlaySoundFile, CreateFrame
	local GetNumRaidMembers, GetNumPartyMembers = GetNumRaidMembers, GetNumPartyMembers
	local find, sub, split, lower = strfind, strsub, strsplit, strlower
	local UnitName, UnitGUID, UnitClass = UnitName, UnitGUID, UnitClass
	local UnitIsPlayer, UnitCanCooperate, UnitAffectingCombat = UnitIsPlayer, UnitCanCooperate, UnitAffectingCombat

	local function echo(str) print('|cfffee00fTinyDPS |cffffff9f' .. (str or '')) end

	local function getFightName(f)
		-- method: the name of a fight is the mob who received the most damage during that fight
		if f == 'o' then return 'Overall Data' end
		local merge = {}
		for _,p in pairs(tdpsPlayer) do
			for k,v in pairs(p[f..'dt']) do
				if merge[k] then merge[k] = merge[k] + v
				else merge[k] = v end
			end
		end
		for _,p in pairs(tdpsPet) do
			for k,v in pairs(p[f..'dt']) do
				if merge[k] then merge[k] = merge[k] + v
				else merge[k] = v end
			end
		end
		local top = {} for k,v in pairs(merge) do top[#(top)+1] = {k,v} end
		tablesort(top,function(x,y) return x[2] > y[2] end)
		if top[1] and top[1][1] then return top[1][1] else return '<Empty>' end
	end

	local function getClass(name) return select(2,UnitClass(name)) or 'UNKNOWN' end

	local function round(num, idp) return floor(num * (10^(idp or 0)) + .5) / (10^(idp or 0)) end

	local function fmtDamage(n)
		if tdps.shortDamage then
			if n > 999999 then return round(n/1e6,1) .. 'M'
			elseif n > 99999 then return round(n/1e3,0) .. 'K'
			elseif n > 9999 then return round(n/1e3,1) .. 'K' end
		end
		return n
	end

	local function fmtDPS(d)
		if d < 100 then return round(d,1)
		elseif tdps.shortDPS and d > 9999 then return round(d/1000,0)..'K'
		elseif tdps.shortDPS and d > 999 then return round(d/1000,1)..'K'
		else return floor(d) end
	end

	local function fmtTime(s)
		if s < 100 then return round(s,1) .. 's'
		else return floor(s) .. 's' end
	end

	local function fmtPercent(p)
		if p < 10 then return round(p,1)..'%'
		else return round(p,0)..'%' end
	end

	local function updateBars(sortBars)
		maxValue, barsWithValue, key = 0, 0, tdps.fight .. tdps.view
		local g, n, s, txt, pets
		-- loop all bars
		for i=1,#bar do
			bar[i]:Hide()
			-- get numbers
			g = bar[i].guid
			n, s, txt  = tdpsPlayer[g][key], tdpsPlayer[g][tdps.fight], ''
			pets = tdpsPlayer[g]['pets'] for i=1,#pets do n = n + tdpsPet[pets[i]][key] if tdpsPet[pets[i]][tdps.fight] > s then s = tdpsPet[pets[i]][tdps.fight] end end
			-- update bar values
			if n > 0 then
				barsWithValue = barsWithValue + 1
				if n > maxValue then maxValue = n end
				if tdps.showDamage then txt = fmtDamage(n) end
				if tdps.showPercent then txt = txt .. ' ' .. fmtPercent(n/tdps.totals[key]*100) end
				if tdps.showDPS then txt = txt .. ' ' .. fmtDPS(n/s) end
				bar[i].fontStringRight:SetText(txt)
			end
			bar[i].n = n
		end
		-- position the bars
		px = -2
		if sortBars then tablesort(bar, function(x,y) return x.n > y.n end) end
		if tdps.maxBars == 1 then
			for i=1,#bar do
				if bar[i].name == UnitName('player') and bar[i].n > 0 then
					bar[i]:SetMinMaxValues(0, maxValue)
					bar[i]:SetValue(bar[i].n)
					bar[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
					if tdps.showRank then bar[i].fontStringLeft:SetText(i..'. '..bar[i].name) else bar[i].fontStringLeft:SetText(bar[i].name) end
					px = px - tdps.barHeight - tdps.spacing
					bar[i]:Show()
				end
			end
		else
			for i=scrollPosition,min(barsWithValue,tdps.maxBars+scrollPosition-1) do
				bar[i]:SetMinMaxValues(0, maxValue)
				bar[i]:SetValue(bar[i].n)
				bar[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
				if tdps.showRank then bar[i].fontStringLeft:SetText(i..'. '..bar[i].name) else bar[i].fontStringLeft:SetText(bar[i].name) end
				px = px - tdps.barHeight - tdps.spacing
				bar[i]:Show()
			end
		end
		-- set frame height
		local h = abs(px) + 2 - tdps.spacing
		if h < tdps.barHeight then tdpsFrame:SetHeight(tdps.barHeight+4) noData:Show() else tdpsFrame:SetHeight(h) noData:Hide() end
	end

	local function changeView(v)
		if v == 'd' then tdps.view = 'd' else tdps.view = 'h' end
		scrollPosition = 1
		updateBars(true)
	end

	local function changeFight(s)
		if tdps.fight ~= s then
			CloseDropDownMenus()
			tdps.fight = s
			scrollPosition = 1
			updateBars(true)
		end
	end

	local function changeSpacing(s) if s < 0 then tdps.spacing = 0 elseif s > 10 then tdps.spacing = 10 else tdps.spacing = s end updateBars(true) end
	local function changeMaxBars(v) tdps.maxBars = v scrollPosition = 1 updateBars(true) end
	local function changeBarHeight(h) if h < 2 then h = 2 elseif h > 40 then h = 40 end for i=1,#bar do bar[i]:SetHeight(h) end tdps.barHeight = h updateBars(true) end

	local function changeFontSize(s)
		if s < 4 then s = 4 elseif s > 30 then s = 30 end
		tdps.font.size = s
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		for i=1,#bar do
			bar[i].fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
			bar[i].fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		end
	end

	local function changeFontName(f)
		tdps.font.name = 'Interface\\AddOns\\TinyDPS\\Fonts\\' .. f
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		for i=1,#bar do
			bar[i].fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
			bar[i].fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		end
	end
	
	local function changeFontShadow(s)
		tdps.font.shadowX, tdps.font.shadowY = s, s*-1
		noData:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
		for i=1,#bar do
			bar[i].fontStringLeft:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
			bar[i].fontStringRight:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
		end
	end
	
	local function changeFontOutline(o)
		tdps.font.outline = o
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		for i=1,#bar do
			bar[i].fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
			bar[i].fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		end
	end

	local function newFight(t)
		tdps.combat = true
		tdps.newFight = false
		if tdps.fight ~= 'o' then scrollPosition = 1 end
		tdps.totals.zd, tdps.totals.zh = tdps.totals.yd, tdps.totals.yh
		tdps.totals.yd, tdps.totals.yh = tdps.totals.xd, tdps.totals.xh
		tdps.totals.xd, tdps.totals.xh = tdps.totals.cd, tdps.totals.ch
		tdps.totals.cd, tdps.totals.ch = 0, 0
		for _,v in pairs(tdpsPlayer) do
			v.zd, v.zdt, v.zds, v.zh, v.zht, v.zhs, v.z = v.yd, v.ydt, v.yds, v.yh, v.yht, v.yhs, v.y
			v.yd, v.ydt, v.yds, v.yh, v.yht, v.yhs, v.y = v.xd, v.xdt, v.xds, v.xh, v.xht, v.xhs, v.x
			v.xd, v.xdt, v.xds, v.xh, v.xht, v.xhs, v.x = v.cd, v.cdt, v.cds, v.ch, v.cht, v.chs, v.c
			v.cd, v.cdt, v.cds, v.ch, v.cht, v.chs, v.c = 0, {}, {}, 0, {}, {}, 0
		end
		for _,v in pairs(tdpsPet) do
			v.zd, v.zdt, v.zds, v.zh, v.zht, v.zhs, v.z = v.yd, v.ydt, v.yds, v.yh, v.yht, v.yhs, v.y
			v.yd, v.ydt, v.yds, v.yh, v.yht, v.yhs, v.y = v.xd, v.xdt, v.xds, v.xh, v.xht, v.xhs, v.x
			v.xd, v.xdt, v.xds, v.xh, v.xht, v.xhs, v.x = v.cd, v.cdt, v.cds, v.ch, v.cht, v.chs, v.c
			v.cd, v.cdt, v.cds, v.ch, v.cht, v.chs, v.c = 0, {}, {}, 0, {}, {}, 0
		end
	end

	local function checkCombat()
		if UnitAffectingCombat('player') or UnitAffectingCombat('pet') then return true end
		for i=1,GetNumRaidMembers() do
			if UnitAffectingCombat('raid'..i) or UnitAffectingCombat('raidpet'..i) then return true end
		end
		for i=1,GetNumPartyMembers() do
			if UnitAffectingCombat('party'..i) or UnitAffectingCombat('partypet'..i) then return true end
		end
		return false
	end
	
	local function checkGroup()
		if GetNumPartyMembers() + GetNumRaidMembers() > 0 then
			return true
		end
		return false
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

	local function isExcludedPet(p) -- works only in english clients ...
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

	local function changeBarColors()
		if tdps.swapColor then
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
				bar[i].fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			end
		else
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].fontStringLeft:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
				bar[i].fontStringRight:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
			end
		end
	end

	local function toggleMinimapButton()
		tdps.showMinimapButton = not tdps.showMinimapButton
		if tdps.showMinimapButton then updateBars(true) tdpsButtonFrame:Show()
		else tdpsButtonFrame:Hide() end
	end

	local function help(i)
		if i == 1 then
			echo('Version ' .. GetAddOnMetadata('TinyDPS', 'Version') .. ' by Sideshow (Draenor EU)')
		elseif i == 2 then
			echo('Shift click to move, middle click to reset')
			echo('Mouse back/forward shows overall data/current fight')
		elseif i == 3 then
			echo('Slash command: /tdps (this will toggle TinyDPS)')
			echo('Command options: /tpds [reset] [damage] [healing]')
		end
	end

	local function reset()
		tdps.fight = 'c'
		for i=1,#bar do bar[i]:ClearAllPoints() bar[i]:Hide() end
		tdpsPlayer, tdpsPet, tdpsPointer, bar = {}, {}, {}, {}
		for k,v in pairs(tdps.totals) do tdps.totals[k] = 0 end
		scrollPosition = 1
		tdpsFrame:SetHeight(tdps.barHeight+4)
		noData:Show()
		echo('All data has been reset')
	end

	local function report(channel, reportlength, destination)
		-- check for whisper target
		if channel == 'WHISPER' and (not destination or not UnitIsPlayer(destination) or not UnitCanCooperate('player', destination)) then echo('Invalid or no target selected') return end
		-- make table to sort
		key = tdps.fight .. tdps.view
		local report = {}
		for k,v in pairs(tdpsPlayer) do
			local reportPlayer = {name = tdpsPlayer[k].name, n = tdpsPlayer[k][key], t = tdpsPlayer[k][tdps.fight]}
			local pets = tdpsPlayer[k]['pets']
			for i=1,#pets do
				-- add pet number
				reportPlayer.n = reportPlayer.n + tdpsPet[pets[i]][key]
				-- check time
				if tdpsPet[pets[i]][tdps.fight] > reportPlayer.t then reportPlayer.t = tdpsPet[pets[i]][tdps.fight] end
			end
			tableinsert(report, reportPlayer)
		end
		tablesort(report, function(x,y) return x.n > y.n end)
		-- check if there is data
		if not report[1] or report[1].n == 0 then echo('No data to report') return end
		-- title
		local title = {d = 'Damage Done for ', h = 'Healing Done for '}
		SendChatMessage(title[tdps.view] .. getFightName(tdps.fight), channel, nil, destination)
		-- output
		for i=1,min(#report, reportlength) do
			if report[i].n > 0 then
				SendChatMessage(i .. '. ' .. split('-', report[i].name) .. ':   ' .. report[i].n .. '   ' .. fmtPercent(report[i].n/tdps.totals[key]*100) .. '   (' .. round(report[i].n/report[i].t,0) .. ')', channel, nil, destination)
			end
		end
	end

	SLASH_TINYDPS1, SLASH_TINYDPS2 = '/tinydps', '/tdps'
	function SlashCmdList.TINYDPS(msg, editbox)
		if lower(msg) == 'reset' then reset()
		elseif lower(msg) == 'help' or msg == '?' or msg == '/?' or msg == '-?' or lower(msg) == '/help' or lower(msg) == '-help' then help(1) help(2) help(3)
		--elseif lower(split(' ', msg)) == 'report' and select(2,split(' ', msg)) and select(3,split(' ', msg)) then report('CHANNEL', select(3,split(' ', msg)), select(2,split(' ', msg)))
		elseif lower(msg) == 'damage' then changeView('d')
		elseif lower(msg) == 'healing' then changeView('h')
		elseif msg == '' then
			if tdpsFrame:IsVisible() then tdpsFrame:Hide() tdps.hidden = true
			else updateBars(true) tdpsFrame:Show() tdps.hidden = false end
		else
			help(3)
		end
	end

	local tdpsDropDown  = CreateFrame('Frame', 'tdpsDropDown', nil, 'UIDropDownMenuTemplate')
	local function tdpsMenu()
		tdpsMenuTable = {}
		tdpsMenuTable = {
			{ text = 'TinyDPS', isTitle = 1, notCheckable = 1 },
			{ text = 'File', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Overall Data', checked = function() if tdps.fight == 'o' then return true end end, func = function() changeFight('o') end },
					{ text = 'Current Fight', checked = function() if tdps.fight == 'c' then return true end end, func = function() changeFight('c') end },
					{ text = getFightName('x'), checked = function() if tdps.fight == 'x' then return true end end, func = function() changeFight('x') end },
					{ text = getFightName('y'), checked = function() if tdps.fight == 'y' then return true end end, func = function() changeFight('y') end },
					{ text = getFightName('z'), checked = function() if tdps.fight == 'z' then return true end end, func = function() changeFight('z') end },
					{ text = '', disabled = true },
					{ text = 'Reset All Data', func = function() reset() CloseDropDownMenus() end }
				}
			},
			{ text = 'View', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Damage', checked = function() if tdps.view == 'd' then return true end end, func = function() changeView('d') end },
					{ text = 'Healing', checked = function() if tdps.view == 'h' then return true end end, func = function() changeView('h') end }
				}
			},
			{ text = 'Report', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Top 5', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() report('SAY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() report('RAID', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() report('PARTY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() report('GUILD', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() report('WHISPER', 5, UnitName('target')) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Channel  ', notCheckable = 1, hasArrow = true, menuList = {} }
						}
					},
					{ text = 'Top 10', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() report('SAY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() report('RAID', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() report('PARTY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() report('GUILD', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() report('WHISPER', 10, UnitName('target')) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Channel  ', notCheckable = 1, hasArrow = true, menuList = {} }
						}
					}
				}
			},
			{ text = 'Options', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Text', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Size', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Increase', func = function() changeFontSize(tdps.font.size+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeFontSize(tdps.font.size-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Font', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Visitor', func = function() changeFontName('Visitor.ttf') end, checked = function() if find(tdps.font.name, 'Visitor') then return true end end },
									{ text = 'Berlin Sans', func = function() changeFontName('Berlin Sans.ttf') end, checked = function() if find(tdps.font.name, 'Berlin') then return true end end },
									{ text = 'Avant Garde', func = function() changeFontName('Avant Garde.ttf') end, checked = function() if find(tdps.font.name, 'Avant') then return true end end },
									{ text = 'Franklin Gothic', func = function() changeFontName('Franklin Gothic.ttf') end, checked = function() if find(tdps.font.name, 'Franklin') then return true end end }
								}
							},
							{ text = 'Layout', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'DPS', func = function() tdps.showDPS = not tdps.showDPS updateBars(true) end, checked = function() return tdps.showDPS end, keepShownOnClick = 1 },
									{ text = 'Rank', func = function() tdps.showRank = not tdps.showRank updateBars(true) end, checked = function() return tdps.showRank end, keepShownOnClick = 1 },
									{ text = 'Percent', func = function() tdps.showPercent = not tdps.showPercent updateBars(true) end, checked = function() return tdps.showPercent end, keepShownOnClick = 1 },
									{ text = 'Damage', func = function() tdps.showDamage = not tdps.showDamage updateBars(true) end, checked = function() return tdps.showDamage end, keepShownOnClick = 1 },
									{ text = 'Short DPS', func = function() tdps.shortDPS = not tdps.shortDPS updateBars(true) end, checked = function() return tdps.shortDPS end, keepShownOnClick = 1 },
									{ text = 'Short Damage', func = function() tdps.shortDamage = not tdps.shortDamage updateBars(true) end, checked = function() return tdps.shortDamage end, keepShownOnClick = 1 }
								}
							},
							{ text = 'Outline', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'None', func = function() changeFontOutline('') changeFontShadow(0) end, checked = function() if tdps.font.outline == '' and tdps.font.shadowX == 0 then return true end end },
									{ text = 'Thin', func = function() changeFontOutline('Outline') changeFontShadow(0) end, checked = function() if tdps.font.outline == 'Outline' and tdps.font.shadowX == 0 then return true end end },
									{ text = 'Thick', func = function() changeFontOutline('Thickoutline') changeFontShadow(0) end, checked = function() if tdps.font.outline == 'Thickoutline' and tdps.font.shadowX == 0 then return true end end },
									{ text = 'Shadow', func = function() changeFontOutline('') changeFontShadow(1) end, checked = function() if tdps.font.outline == '' and tdps.font.shadowX == 1 then return true end end },
									{ text = 'Monochrome', func = function() changeFontOutline('Monochrome') changeFontShadow(0) end, checked = function() if tdps.font.outline == 'Monochrome' and tdps.font.shadowX == 0 then return true end end }
								}
							}
						}
					},
					{ text = 'Bars', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Height', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Increase', func = function() changeBarHeight(tdps.barHeight+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeBarHeight(tdps.barHeight-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Spacing', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Increase', func = function() changeSpacing((tdps.spacing or 0)+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeSpacing((tdps.spacing or 0)-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Maximum', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = '1 (Yourself)', func = function() changeMaxBars(1) end, checked = function() if tdps.maxBars == 1 then return true end end },
									{ text = '5', func = function() changeMaxBars(5) end, checked = function() if tdps.maxBars == 5 then return true end end },
									{ text = '10', func = function() changeMaxBars(10) end, checked = function() if tdps.maxBars == 10 then return true end end },
									{ text = '15', func = function() changeMaxBars(15) end, checked = function() if tdps.maxBars == 15 then return true end end },
									{ text = '20', func = function() changeMaxBars(20) end, checked = function() if tdps.maxBars == 20 then return true end end },
									{ text = '? (Unlimited)', func = function() changeMaxBars(99) end, checked = function() if tdps.maxBars == 99 then return true end end }
								}
							}
						}
					},
					{ text = 'Colors', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Bar Color', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									changeBarColors()
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									changeBarColors()
								end,
								r = tdps.bar[1], g = tdps.bar[2], b = tdps.bar[3], opacity = 1 - tdps.bar[4],
								notCheckable = 1
							},
							{ text = 'Border Color', notClickable = 1,
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
							{ text = 'Backdrop Color              ', notClickable = 1,
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
							{ text = 'Dim Class Colors', notCheckable = 1, func = function() for c,v in pairs(tdps.classColor) do if v[4]-.1 < 0 then v[4] = 0 else v[4] = v[4]-.1 end end changeBarColors() end, keepShownOnClick = 1 },
							{ text = 'Reset Class Colors', notCheckable = 1, func = function() tdps.classColor = {} for c,_ in pairs(classColorDefault) do tdps.classColor[c] = {unpack(classColorDefault[c])} end changeBarColors() end, keepShownOnClick = 1 },
							{ text = 'Swap Bar/Class Color', notCheckable = 1, func = function() tdps.swapColor = not tdps.swapColor changeBarColors() end, keepShownOnClick = 1 },
						}
					},
					{ text = 'Anchor', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Top', func = function() tdps.anchor = 'TOPLEFT' tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint('TOPLEFT', tdpsMover, 'TOPLEFT') end, checked = function() if tdps.anchor == 'TOPLEFT' then return true end end },
							{ text = 'Bottom', func = function() tdps.anchor = 'BOTTOMLEFT' tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint('BOTTOMLEFT', tdpsMover, 'BOTTOMLEFT') end,  checked = function() if tdps.anchor == 'BOTTOMLEFT' then return true end end }
						}
					},
					{ text = 'Tooltips', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Show Targets', func = function() tdps.showTargets = not tdps.showTargets end, checked = function() return tdps.showTargets end, keepShownOnClick = 1 },
							{ text = 'Show Abilities', func = function() tdps.showAbilities = not tdps.showAbilities end, checked = function() return tdps.showAbilities end, keepShownOnClick = 1 }
						}
					},
					{ text = 'More ...', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Show Minimap Button', func = function() toggleMinimapButton() end, checked = function() return tdps.showMinimapButton end, keepShownOnClick = 1 },
							{ text = 'Auto Reset On New Group', func = function() tdps.autoReset = not tdps.autoReset end, checked = function() return tdps.autoReset end, keepShownOnClick = 1 },
							{ text = 'Auto Toggle On Combat Status', func = function() tdps.autoToggle = not tdps.autoToggle end, checked = function() return tdps.autoToggle end, keepShownOnClick = 1 }
						}
					}
				}
			},
			--{ text = 'Close Menu', func = function() CloseDropDownMenus() end, notCheckable = 1 }
		}
		-- add report channels
		local insert
		for i=1,20 do
			if select(2,GetChannelName(i)) then
				insert = { text = split(' ',select(2,GetChannelName(i))), func = function() report('CHANNEL', 5, i) CloseDropDownMenus() end, notCheckable = 1 }
				tableinsert(tdpsMenuTable[4]['menuList'][1]['menuList'][6]['menuList'], insert)
				insert = { text = split(' ',select(2,GetChannelName(i))), func = function() report('CHANNEL', 10, i) CloseDropDownMenus() end, notCheckable = 1 }
				tableinsert(tdpsMenuTable[4]['menuList'][2]['menuList'][6]['menuList'], insert)
			end
		end
	end

	local function scroll(d)
		if bar[1] and bar[1].n > 0 and scrollPosition - d > 0 and scrollPosition - d + tdps.maxBars <= barsWithValue + 1 and tdps.maxBars > 1 then
			scrollPosition = scrollPosition - d
			updateBars(true)
		end
	end

	local function newBar(g)
		local dummybar = CreateFrame('Statusbar', 'tdpsStatusBar', tdpsFrame)
		dummybar:SetFrameStrata('MEDIUM')
		dummybar:SetFrameLevel(2)
		dummybar:SetOrientation('HORIZONTAL')
		dummybar:EnableMouse(1)
		dummybar:EnableMouseWheel(1)
		dummybar:SetWidth(tdpsFrame:GetWidth() - 4)
		dummybar:SetHeight(tdps.barHeight)
		dummybar:Hide()
		dummybar:SetPoint('RIGHT', tdpsFrame, 'RIGHT', -2, 0)
		dummybar:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
		dummybar:SetStatusBarTexture('Interface\\AddOns\\TinyDPS\\Textures\\wglass.tga')
		dummybar:SetBackdropColor(0, 0, 0, 0)
		dummybar:SetBackdropBorderColor(0, 0, 0, 0)
		-- hidden info
		dummybar.name, dummybar.guid, dummybar.n = split('-', tdpsPlayer[g]['name']), g, 0
		-- scripts
		dummybar:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(dummybar)
			GameTooltip:SetText(tdpsPlayer[g]['name'])
			key = tdps.fight .. tdps.view
			-- tooltip title
			local title = {d = 'Damage for ', h = 'Healing for ', o = 'Overall Data', c = 'Current Fight', x = 'Previous Fight', y = 'Previous Fight', z = 'Previous Fight'}
			GameTooltip:AddLine(title[tdps.view] .. title[tdps.fight], 1, .85, 0)
			-- personal number
			GameTooltip:AddDoubleLine('Personal', tdpsPlayer[self.guid][key] .. ' (' .. fmtPercent(tdpsPlayer[self.guid][key]/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1)
			-- pet number
			local pets, petAmount = tdpsPlayer[g]['pets'], 0
			for i=1,#pets do petAmount = petAmount + tdpsPet[pets[i]][key] end
			if petAmount > 0 then GameTooltip:AddDoubleLine('By Pet(s)', petAmount .. ' (' .. fmtPercent(petAmount/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1) end
			-- top abilities
			if tdps.showAbilities then
				GameTooltip:AddLine('Top Abilities', 1, .85, 0)
				local mergedTop = {} for k,v in pairs(tdpsPlayer[g][key..'s']) do mergedTop[k] = v end
				for i=1,#pets do
					for k,v in pairs(tdpsPet[pets[i]][key..'s']) do
						if mergedTop[k] then mergedTop[k] = mergedTop[k] + v
						else mergedTop[k] = v end
					end
				end
				-- make indexed top so we can sort
				local top = {} for k,v in pairs(mergedTop) do top[#(top)+1] = {k,v} end
				tablesort(top,function(x,y) return x[2] > y[2] end)
				for i=1,3 do if top[i] then GameTooltip:AddDoubleLine(i .. '. ' .. top[i][1], top[i][2].. ' (' .. fmtPercent(top[i][2]/(self.n)*100) .. ')', 1, 1, 1, 1, 1, 1) end end
			end
			-- top targets
			if tdps.showTargets then
				GameTooltip:AddLine('Top Targets', 1, .85, 0)
				local mergedTop = {} for k,v in pairs(tdpsPlayer[g][key..'t']) do mergedTop[k] = v end
				for i=1,#pets do
					for k,v in pairs(tdpsPet[pets[i]][key..'t']) do
						if mergedTop[k] then mergedTop[k] = mergedTop[k] + v
						else mergedTop[k] = v end
					end
				end
				-- make indexed top so we can sort
				local top = {} for k,v in pairs(mergedTop) do top[#(top)+1] = {k,v} end
				tablesort(top,function(x,y) return x[2] > y[2] end)
				for i=1,3 do if top[i] then GameTooltip:AddDoubleLine(i .. '. ' .. top[i][1], top[i][2].. ' (' .. fmtPercent(top[i][2]/(self.n)*100) .. ')', 1, 1, 1, 1, 1, 1) end end
			end
			GameTooltip:Show()
		end)
		dummybar:SetScript('OnLeave', function(self) GameTooltip:Hide() end)
		dummybar:SetScript('OnMouseDown', function(self, button)
			if button == 'LeftButton' and IsShiftKeyDown() then GameTooltip:Hide() CloseDropDownMenus() isMovingOrSizing = true tdpsMover:StartMoving()
			elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU')
			elseif button == 'MiddleButton' then reset()
			elseif button == 'Button4' then changeFight('o')
			elseif button == 'Button5' then changeFight('c') end
		end)
		dummybar:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() isMovingOrSizing = nil tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) end
		end)
		dummybar:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)
		-- numbers fontstring
		dummybar.fontStringRight = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.fontStringRight:SetPoint('RIGHT', -1, 1)
		dummybar.fontStringRight:SetJustifyH('RIGHT')
		dummybar.fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		dummybar.fontStringRight:SetShadowColor(.05, .05, .05, 1)
		dummybar.fontStringRight:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
		-- name fontstring
		dummybar.fontStringLeft = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.fontStringLeft:SetPoint('LEFT', 1, 1)
		dummybar.fontStringLeft:SetPoint('RIGHT', dummybar.fontStringRight, 'LEFT', -2, 1)
		dummybar.fontStringLeft:SetJustifyH('LEFT')
		dummybar.fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		dummybar.fontStringLeft:SetShadowColor(.05, .05, .05, 1)
		dummybar.fontStringLeft:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
		-- colors
		local classR, classG, classB, classA = unpack(tdps.classColor[tdpsPlayer[g]['class']])
		if tdps.swapColor then
			dummybar:SetStatusBarColor(classR, classG, classB, classA)
			dummybar.fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
		else
			dummybar:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.fontStringRight:SetTextColor(classR, classG, classB, classA)
			dummybar.fontStringLeft:SetTextColor(classR, classG, classB, classA)
		end
		-- save bar
		tableinsert(bar, dummybar)
	end

	local function makeCombatant(k, n, pgl, c)
		if c == 'PET' then
			tdpsPet[k] = {
				name = n, guid = pgl, class = c, stamp = 0
				,od = 0, odt = {}, ods = {}, oh = 0, oht = {}, ohs = {}, o = 0
				,cd = 0, cdt = {}, cds = {}, ch = 0, cht = {}, chs = {}, c = 0
				,xd = 0, xdt = {}, xds = {}, xh = 0, xht = {}, xhs = {}, x = 0
				,yd = 0, ydt = {}, yds = {}, yh = 0, yht = {}, yhs = {}, y = 0
				,zd = 0, zdt = {}, zds = {}, zh = 0, zht = {}, zhs = {}, z = 0
			}
		else
			tdpsPlayer[k] = {
				name = n, pets = pgl, class = c, stamp = 0
				,od = 0, odt = {}, ods = {}, oh = 0, oht = {}, ohs = {}, o = 0
				,cd = 0, cdt = {}, cds = {}, ch = 0, cht = {}, chs = {}, c = 0
				,xd = 0, xdt = {}, xds = {}, xh = 0, xht = {}, xhs = {}, x = 0
				,yd = 0, ydt = {}, yds = {}, yh = 0, yht = {}, yhs = {}, y = 0
				,zd = 0, zdt = {}, zds = {}, zh = 0, zht = {}, zhs = {}, z = 0
			}
		end
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
				if not tdpsPlayer[arg3] then
					makeCombatant(arg3, arg4, {arg4..': '..arg7}, getClass(arg4))
					newBar(arg3)
				end
				-- make pointer
				tdpsPointer[arg6] = arg4..': '..arg7
				-- make pet if it does not exist yet
				if not tdpsPet[arg4..': '..arg7] then makeCombatant(arg4..': '..arg7, arg7, arg6, 'PET') end
				-- add pet to owner if it's not there yet
				local found = nil for i=1,#tdpsPlayer[arg3]['pets'] do if tdpsPlayer[arg3]['pets'][i] == arg4..': '..arg7 then found = true break end end
				if not found then tableinsert(tdpsPlayer[arg3]['pets'], arg4..': '..arg7) end
			elseif tdpsPointer[arg3] then -- the summoner is also a pet (example: totem summons greater fire elemental)
				 -- ownername of owner
				local oo = split(':', tdpsPointer[arg3])
				-- make pointer
				tdpsPointer[arg6] = oo..': '..arg7
				-- make pet
				makeCombatant(oo..': '..arg7, arg7, arg6, 'PET')
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[UnitGUID(oo)]['pets'] do if tdpsPlayer[UnitGUID(oo)]['pets'][i] == oo..': '..arg7 then found = true break end end
				if not found then tableinsert(tdpsPlayer[UnitGUID(oo)]['pets'], oo..': '..arg7) end
			end return
		end

		-- add player or a pet
		if not tdpsPlayer[arg3] and not tdpsPointer[arg3] then
			if UnitIsPlayer(arg4) then
				makeCombatant(arg3, arg4, {}, getClass(arg4))
				newBar(arg3)
				tdpsCombatEvent(self, event, ...)
			elseif isPartyPet(arg3) then
				-- get owner
				local oGuid, oName = getPetOwnerGUID(arg3), getPetOwnerName(arg3)
				-- make owner if it does not exist yet
				if not tdpsPlayer[oGuid] then
					makeCombatant(oGuid, oName, {oName..': '..arg4}, getClass(oName))
					newBar(oGuid)
				end
				-- make pointer
				tdpsPointer[arg3] = oName .. ': ' .. arg4
				-- make pet if it does not exist yet
				if not tdpsPet[oName..': '..arg4] then
					makeCombatant(oName..': '..arg4, arg4, arg3, 'PET')
				end
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[oGuid]['pets'] do if tdpsPlayer[oGuid]['pets'][i] == oName..': '.. arg4 then found = true break end end
				if not found then tableinsert(tdpsPlayer[oGuid]['pets'], oName..': '.. arg4) end
				tdpsCombatEvent(self, event, ...)
			end
			return
		end

		-- select combatant
		if UnitIsPlayer(arg4) then tmp = tdpsPlayer[arg3]
		elseif tdpsPet[tdpsPointer[arg3]] then tmp = tdpsPet[tdpsPointer[arg3]]
		else return	end

		-- add numbers
		if tdps.newFight and isMissed[arg2] then newFight(arg7) -- check if we need to start a new fight, even if first hit is a miss
		elseif isSpellDamage[arg2] then
			if tdps.newFight then newFight(arg7) end
			tdps.totals.od = tdps.totals.od + arg12
			tdps.totals.cd = tdps.totals.cd + arg12
			tmp.od = tmp.od + arg12
			tmp.cd = tmp.cd + arg12
			if tmp.odt[arg7] then tmp.odt[arg7] = tmp.odt[arg7] + arg12 else tmp.odt[arg7] = arg12 end
			if tmp.cdt[arg7] then tmp.cdt[arg7] = tmp.cdt[arg7] + arg12 else tmp.cdt[arg7] = arg12 end
			if tmp.ods[arg10] then tmp.ods[arg10] = tmp.ods[arg10] + arg12 else tmp.ods[arg10] = arg12 end
			if tmp.cds[arg10] then tmp.cds[arg10] = tmp.cds[arg10] + arg12 else tmp.cds[arg10] = arg12 end
		elseif arg2 == 'SWING_DAMAGE' then
			if tdps.newFight then newFight(arg7) end
			tdps.totals.od = tdps.totals.od + arg9
			tdps.totals.cd = tdps.totals.cd + arg9
			tmp.od = tmp.od + arg9
			tmp.cd = tmp.cd + arg9
			if tmp.odt[arg7] then tmp.odt[arg7] = tmp.odt[arg7] + arg9 else tmp.odt[arg7] = arg9 end
			if tmp.cdt[arg7] then tmp.cdt[arg7] = tmp.cdt[arg7] + arg9 else tmp.cdt[arg7] = arg9 end
			if tmp.ods.Melee then tmp.ods.Melee = tmp.ods.Melee + arg9 else tmp.ods.Melee = arg9 end
			if tmp.cds.Melee then tmp.cds.Melee = tmp.cds.Melee + arg9 else tmp.cds.Melee = arg9 end
		elseif arg2 == 'SPELL_PERIODIC_HEAL' or arg2 == 'SPELL_HEAL' then
			arg12 = arg12 - arg13 -- effective healing
			if arg12 == 0 or not tdps.combat then return end -- stop on complete overheal or out of combat
			tdps.totals.oh = tdps.totals.oh + arg12
			tdps.totals.ch = tdps.totals.ch + arg12
			tmp.oh = tmp.oh + arg12
			tmp.ch = tmp.ch + arg12
			if tmp.oht[arg7] then tmp.oht[arg7] = tmp.oht[arg7] + arg12 else tmp.oht[arg7] = arg12 end
			if tmp.cht[arg7] then tmp.cht[arg7] = tmp.cht[arg7] + arg12 else tmp.cht[arg7] = arg12 end
			if tmp.ohs[arg10] then tmp.ohs[arg10] = tmp.ohs[arg10] + arg12 else tmp.ohs[arg10] = arg12 end
			if tmp.chs[arg10] then tmp.chs[arg10] = tmp.chs[arg10] + arg12 else tmp.chs[arg10] = arg12 end
		end

		-- add combat time
		tmp.o = tmp.o + min(3.5, arg1 - tmp.stamp)
		tmp.c = tmp.c + min(3.5, arg1 - tmp.stamp)

		-- save time stamp
		tmp.stamp = arg1

	end





---------------------------------------------------------------------------------------------------------------------------------
--- scripts ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local function tdpsAddonLoaded(self, event)
		-- reinitialize on version mismatch
		if GetAddOnMetadata('TinyDPS', 'Version') ~= tdps.version then tdpsInitTables() tdpsFrame:SetHeight(tdps.barHeight+4)
		-- else just remake the bars
		else for k,_ in pairs(tdpsPlayer) do newBar(k) end updateBars(true) end
		-- save version
		tdps.version = GetAddOnMetadata('TinyDPS', 'Version')
		-- set font properties
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		noData:SetShadowOffset(tdps.font.shadowX, tdps.font.shadowY)
		-- set colors
		tdpsFrame:SetBackdropBorderColor(tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4])
		tdpsFrame:SetBackdropColor(tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4])
		-- hide when necessary
		if tdps.hidden or (tdps.autoToggle and not tdps.combat) then tdpsFrame:Hide() end
		-- set anchor
		tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor)
		-- minimap button
		if tdps.showMinimapButton then tdpsButtonFrame:Show()
		else tdpsButtonFrame:Hide() end
		-- reset events
		tdpsFrame:UnregisterEvent('ADDON_LOADED')
		tdpsFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		tdpsFrame:SetScript('OnEvent', tdpsCombatEvent)
	end

	tdpsFrame:RegisterEvent('ADDON_LOADED')
	tdpsFrame:SetScript('OnEvent', tdpsAddonLoaded)

	local function tdpsHideEvents(self, event)
		if event == 'PLAYER_REGEN_ENABLED' then
			-- check if we need to hide
			if tdpsFrame:IsVisible() and tdps.autoToggle then tdpsFrame:Hide() end
		elseif event == 'PLAYER_REGEN_DISABLED' then
			-- check if we need to show
			if not tdpsFrame:IsVisible() and tdps.autoToggle then tdpsFrame:Show() end
		end
	end

	tdpsMover:RegisterEvent('PLAYER_REGEN_ENABLED')
	tdpsMover:RegisterEvent('PLAYER_REGEN_DISABLED')
	tdpsMover:SetScript('OnEvent', tdpsHideEvents)

	local function tdpsOnUpdate(self, elapsed)
		onUpdateElapsed = onUpdateElapsed + elapsed
		if onUpdateElapsed > 2 then
			onUpdateElapsed = 0
			tdps.combat = checkCombat()
			-- check if next attack will start a new fight
			if not tdps.combat then tdps.newFight = true end
			-- check for auto reset
			if tdps.autoReset and not tdps.grouped and checkGroup() then reset() end
			tdps.grouped = checkGroup()
			-- check for update
			if tdpsFrame:IsVisible() and not isMovingOrSizing then updateBars(tdps.combat) end
		end
	end

	local function tdpsOnUpdateStart(self, elapsed)
		onUpdateElapsed = onUpdateElapsed + elapsed
		if onUpdateElapsed > 2.5 then
			if tdps.firstStart then help(1) help(2) help(3) tdps.firstStart = false end
			tdpsMover:SetScript('OnUpdate', tdpsOnUpdate)
		end
	end

	tdpsMover:SetScript('OnUpdate', tdpsOnUpdateStart)

	tdpsFrame:SetScript('OnMouseDown', function(self, button)
		if button == 'LeftButton' and IsShiftKeyDown() then CloseDropDownMenus() GameTooltip:Hide() isMovingOrSizing = true tdpsMover:StartMoving()
		elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU')
		elseif button == 'MiddleButton' then reset()
		elseif button == 'Button4' then changeFight('o')
		elseif button == 'Button5' then changeFight('c') end
	end)

	tdpsFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() isMovingOrSizing = nil tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) end
	end)
	
	tdpsFrame:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)

	tdpsButtonFrame:SetScript('OnMouseDown', function(self, button)
		if button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') end
	end)

	tdpsButtonFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then
			if tdpsFrame:IsVisible() then tdpsFrame:Hide() tdps.hidden = true
			else updateBars(true) tdpsFrame:Show() tdps.hidden = false end
			PlaySound('gsTitleOptionExit')
		end
	end)
	
	local function tdpsOnUpdateButton(self, elapsed)
		local x, y = Minimap:GetCenter()
		local cx, cy = GetCursorPosition()
		x, y = cx / self:GetEffectiveScale() - x, cy / self:GetEffectiveScale() - y
		if x > Minimap:GetWidth()/2+tdpsButtonFrame:GetWidth()/2 then x = Minimap:GetWidth()/2+tdpsButtonFrame:GetWidth()/2 end
		if x < Minimap:GetWidth()/2*-1-tdpsButtonFrame:GetWidth()/2 then x = Minimap:GetWidth()/2*-1-tdpsButtonFrame:GetWidth()/2 end
		if y > Minimap:GetHeight()/2+tdpsButtonFrame:GetHeight()/2 then y = Minimap:GetHeight()/2+tdpsButtonFrame:GetHeight()/2 end
		if y < Minimap:GetHeight()/2*-1-tdpsButtonFrame:GetHeight()/2 then y = Minimap:GetHeight()/2*-1-tdpsButtonFrame:GetHeight()/2 end
		tdpsButtonFrame:ClearAllPoints()
		tdpsButtonFrame:SetPoint('CENTER', x, y)
	end

	tdpsButtonFrame:SetScript('OnDragStart', function(self, button)
		tdpsButtonFrame:SetScript('OnUpdate', tdpsOnUpdateButton)
	end)

	tdpsButtonFrame:SetScript('OnDragStop', function(self, button)
		tdpsButtonFrame:SetScript('OnUpdate', nil)
	end)

	tdpsButtonFrame:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(tdpsButtonFrame)
		GameTooltip:SetText('TinyDPS')
		GameTooltip:AddLine('Click to toggle', 1, 1, 1, 1)
		GameTooltip:Show()
	end)

	tdpsButtonFrame:SetScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)


