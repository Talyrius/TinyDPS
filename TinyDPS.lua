--[[-----------------------------------------------------------------------------------------------------------------------------
--- header ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	TinyDPS
	Written by Sideshow (Draenor EU)
	
	0.62 BETA
	*fixed: hitching problem
	*changed: context menu
	*added: option to hide when not in a group

	0.61 BETA
	* fixed: bug causing error on displaying damage

	0.60 BETA
	* added: auto reset
	* added: option hide in pvp
	* added: spell detail
	* added: fight history
	* lots of code rewrite

	0.42 BETA
	* fixed: detecting of pets of pets (read: greater fire/earth elementals)
	* changed: resizing is now with a tiny grip (bottom right of the frame)
	* added: you can now scroll
	* added: short dps format
	* many code tweaks

	0.41 BETA
	* fixed: better pet tracking (also tracks water elementals now)
	* changed: reporting menu and code
	* changed: reworked color code and menu
	* added: there is now an option to show rank numbers
	* added: mousebutton3 resets data, mousebutton4 shows overall data, mousebutton5 shows current fight

	0.40 BETA
	* fixed: problem with tracking of (some) players
	* fixed: bug with 'hide out of combat'
	* fixed: bug in reporting
	* changed: a new fight will now be started even when the first hit is a miss
	* changed: function names for scope security
	* added: you can change the anchor, meaning the frame can grow upwards now
	* added: you can separately show and hide damage, percentage or dps
	* added: no shared media yet, but I added a pixel-font for those who care :)

	0.39 BETA
	* fixed: error in option 'show only yourself'
	* change: context menu cleaned once again
	* added: option to auto hide out of combat
	* added: commands: /tdps show | hide | reset
	* added: option to enable or disable DPS and Percent
	* code optimalization

	0.37 BETA
	* initial release





---------------------------------------------------------------------------------------------------------------------------------
--- variables -------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------]]

	local bar = {}
	local px, tmp
	local onUpdateElapsed = 0
	local inCombat = nil
	local maxValue, barsWithValue
	local scrollPosition = 1
	local isMovingOrSizing = nil

	local classColorDefault = {UNKNOWN = {0, 0, 0, 1}, WARRIOR = {.78, .61, .43, 1}, MAGE = {.41, .80, .94, 1}, ROGUE = {1, .96, .41, 1}, DRUID = {1, .49, .04, 1}, HUNTER = {.67, .83, .45, 1}, SHAMAN = {.14, .35, 1, 1}, PRIEST = {1, 1, 1, 1}, WARLOCK = {.58, .51, .79, 1}, PALADIN = {.96, .55, .73, 1}, DEATHKNIGHT = { .77, .12, .23, 1}}
	local isValidEvent = {SPELL_SUMMON = true, SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true, SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true, SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isMissed = {SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isSpellDamage = {RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true}

	local function tdpsInitTables()
		tdpsPet = {}
		tdpsPlayer = {}
		tdpsPointer = {}
		tdps = {
			view = 'd',
			segment = 'c',
			anchor = 'TOPLEFT',
			inGroup = false,
			visible = 5,
			fontSize = 12,
			spacing = 2,
			barHeight = 14,
			shortDPS = false,
			shortDamage = false,
			showDPS = true,
			showRank = true,
			showDamage = true,
			showPercent = false,
			autoReset = true,
			firstStart = true,
			swapColor = false,
			showTargets = true,
			showAbilities = true,
			bar = {.5, .5, .5, .5},
			border = {0, 0, 0, .8},
			backdrop = {0, 0, 0, .8},
			version = GetAddOnMetadata('TinyDPS', 'Version'),
			hide = {always = false, ooc = false, pvp = false, solo = false},
			fontName = 'Interface\\AddOns\\TinyDPS\\Fonts\\Franklin Gothic.ttf',
			classColor = {},
			totals = {['od'] = 0, ['oh'] = 0, ['cd'] = 0, ['ch'] = 0, ['1d'] = 0, ['1h'] = 0, ['2d'] = 0, ['2h'] = 0, ['3d'] = 0, ['3h'] = 0}
		}
		for c,_ in pairs(classColorDefault) do tdps.classColor[c] = {unpack(classColorDefault[c])} end
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

	-- 'nothing to display' string
	tdpsFrame:CreateFontString('noData', 'OVERLAY')
	noData:SetPoint('CENTER', tdpsFrame, 'CENTER', 0, 1)
	noData:SetJustifyH('CENTER')
	noData:SetFont(tdps.fontName, tdps.fontSize)
	noData:SetShadowColor(.1, .1, .1, 1)
	noData:SetShadowOffset(1, -1)
	noData:SetTextColor(1, 1, 1, .1)
	noData:SetText('TinyDPS')
	
	-- sizer frame
	CreateFrame('Frame', 'tdpsSizer', tdpsFrame)
	tdpsSizer:SetFrameStrata('MEDIUM')
	tdpsSizer:SetFrameLevel(3)
	tdpsSizer:SetWidth(6)
	tdpsSizer:SetHeight(6)
	tdpsSizer:SetPoint('BOTTOMRIGHT', tdpsFrame, 'BOTTOMRIGHT', 0, 0)
	tdpsSizer:EnableMouse(1)
	tdpsSizer:SetScript('OnEnter', function() tdpsSizerTexture:SetDesaturated(0) tdpsSizerTexture:SetAlpha(1) end)
	tdpsSizer:SetScript('OnLeave', function() tdpsSizerTexture:SetDesaturated(1) tdpsSizerTexture:SetAlpha(.2) end)
	tdpsSizer:SetScript('OnMouseDown', function() isMovingOrSizing = true tdpsFrame:SetMinResize(60, tdpsFrame:GetHeight()) tdpsFrame:SetMaxResize(400, tdpsFrame:GetHeight()) tdpsFrame:StartSizing() end)
	tdpsSizer:SetScript('OnMouseUp', function() tdpsFrame:StopMovingOrSizing() tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) isMovingOrSizing = nil for i=1,#bar do bar[i]:SetWidth(tdpsFrame:GetWidth()-4) bar[i]:SetValue(0) end tdpsUpdate() end)
	tdpsSizer:CreateTexture('tdpsSizerTexture')
	tdpsSizerTexture:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
	tdpsSizerTexture:SetTexCoord(0.619, 0.760, 0.612, 0.762)
	tdpsSizerTexture:SetDesaturated(1)
	tdpsSizerTexture:SetAlpha(.2)
	tdpsSizerTexture:ClearAllPoints()
	tdpsSizerTexture:SetPoint('TOPLEFT', tdpsSizer)
	tdpsSizerTexture:SetPoint('BOTTOMRIGHT', tdpsSizer, 'BOTTOMRIGHT', 0, 0)
	





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

	local function getFightName(f)
		-- method: the name of a fight is the mob who received the most damage during that fight
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

	local function round(num, idp)
		return floor(num * (10^(idp or 0)) + .5) / (10^(idp or 0))
	end

	local function getClass(name)
		return select(2,UnitClass(name)) or 'UNKNOWN'
	end

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

	function tdpsUpdate()
		maxValue, barsWithValue = 0, 0
		-- configure the bars
		for i=1,#bar do
			bar[i]:Hide()
			-- get own numbers
			local g = bar[i].guid
			local n, s, txt  = tdpsPlayer[g][tdps.segment..tdps.view], tdpsPlayer[g][tdps.segment..'t'], ''
			-- add pet numbers
			local pets = tdpsPlayer[g]['pets'] for i=1,#pets do n = n + tdpsPet[pets[i]][tdps.segment..tdps.view] if tdpsPet[pets[i]][tdps.segment..'t'] > s then s = tdpsPet[pets[i]][tdps.segment..'t'] end end
			-- update values
			if n > 0 then
				barsWithValue = barsWithValue + 1
				if n > maxValue then maxValue = n end
				if tdps.showDamage then txt = fmtDamage(n) end
				if tdps.showPercent then txt = txt .. ' ' .. fmtPercent(n/tdps.totals[tdps.segment..tdps.view]*100) end
				if tdps.showDPS then txt = txt .. ' ' .. fmtDPS(n/s) end
				bar[i].numbersFS:SetText(txt)
			end
			bar[i].n = n
		end
		-- position the bars
		px = -2
		tablesort(bar,function(x,y) return x.n > y.n end)
		for i=scrollPosition,min(barsWithValue,tdps.visible+scrollPosition-1) do
			bar[i]:SetMinMaxValues(0, maxValue)
			bar[i]:SetValue(bar[i].n)
			bar[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
			if tdps.showRank then bar[i].nameFS:SetText(i..'. '..bar[i].name) else bar[i].nameFS:SetText(bar[i].name) end
			px = px - tdps.barHeight - tdps.spacing
			bar[i]:Show()
		end
		-- set frame height
		local h = abs(px) + 2 - tdps.spacing
		if h < tdps.barHeight then tdpsFrame:SetHeight(tdps.barHeight+4) noData:Show() else tdpsFrame:SetHeight(h) noData:Hide() end
	end

	local function changeView()
		if tdps.view == 'd' then tdps.view = 'h'
		else tdps.view = 'd' end
		scrollPosition = 1
		tdpsUpdate()
	end

	local function changeSegment(s)
		if tdps.segment ~= s then
			CloseDropDownMenus()
			tdps.segment = s
			scrollPosition = 1
			tdpsUpdate()
		end
	end

	local function changeSpacing(s) if s < 0 then tdps.spacing = 0 elseif s > 10 then tdps.spacing = 10 else tdps.spacing = s end tdpsUpdate() end
	local function changeVisible(v) tdps.visible = v scrollPosition = 1 tdpsUpdate() end
	local function changeBarHeight(h) if h < 2 then h = 2 elseif h > 40 then h = 40 end for i=1,#bar do bar[i]:SetHeight(h) end tdps.barHeight = h tdpsUpdate() end
	local function changeFontSize(s) if s < 4 then s = 4 elseif s > 30 then s = 30 end noData:SetFont(tdps.fontName, s) for i=1,#bar do bar[i].nameFS:SetFont(tdps.fontName, s) bar[i].numbersFS:SetFont(tdps.fontName, s) end tdps.fontSize = s tdpsUpdate() end
	local function changeFont(f) f = 'Interface\\AddOns\\TinyDPS\\Fonts\\' .. f noData:SetFont(f, tdps.fontSize) for i=1,#bar do bar[i].nameFS:SetFont(f, tdps.fontSize) bar[i].numbersFS:SetFont(f, tdps.fontSize) end tdps.fontName = f tdpsUpdate() end

	local function newFight(t)
		tdps.newFight = nil
		inCombat = true
		if tdps.segment ~= 'c' then scrollPosition = 1 end
		tdps.totals['3d'], tdps.totals['3h'] = tdps.totals['2d'], tdps.totals['2h']
		tdps.totals['2d'], tdps.totals['2h'] = tdps.totals['1d'], tdps.totals['1h']
		tdps.totals['1d'], tdps.totals['1h'] = tdps.totals['cd'], tdps.totals['ch']
		tdps.totals['cd'], tdps.totals['ch'] = 0, 0
		for _,v in pairs(tdpsPlayer) do
			v['3d'], v['3dt'], v['3ds'], v['3h'], v['3ht'], v['3hs'], v['3t'] = v['2d'], v['2dt'], v['2ds'], v['2h'], v['2ht'], v['2hs'], v['2t']
			v['2d'], v['2dt'], v['2ds'], v['2h'], v['2ht'], v['2hs'], v['2t'] = v['1d'], v['1dt'], v['1ds'], v['1h'], v['1ht'], v['1hs'], v['1t']
			v['1d'], v['1dt'], v['1ds'], v['1h'], v['1ht'], v['1hs'], v['1t'] = v['cd'], v['cdt'], v['cds'], v['ch'], v['cht'], v['chs'], v['ct']
			v['cd'], v['cdt'], v['cds'], v['ch'], v['cht'], v['chs'], v['ct'] = 0, {}, {}, 0, {}, {}, 0
		end
		for _,v in pairs(tdpsPet) do
			v['3d'], v['3dt'], v['3ds'], v['3h'], v['3ht'], v['3hs'], v['3t'] = v['2d'], v['2dt'], v['2ds'], v['2h'], v['2ht'], v['2hs'], v['2t']
			v['2d'], v['2dt'], v['2ds'], v['2h'], v['2ht'], v['2hs'], v['2t'] = v['1d'], v['1dt'], v['1ds'], v['1h'], v['1ht'], v['1hs'], v['1t']
			v['1d'], v['1dt'], v['1ds'], v['1h'], v['1ht'], v['1hs'], v['1t'] = v['cd'], v['cdt'], v['cds'], v['ch'], v['cht'], v['chs'], v['ct']
			v['cd'], v['cdt'], v['cds'], v['ch'], v['cht'], v['chs'], v['ct'] = 0, {}, {}, 0, {}, {}, 0
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

	local function updateAllBarColors()
		if tdps.swapColor then
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
				bar[i].nameFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].numbersFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			end
		else
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].nameFS:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
				bar[i].numbersFS:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']][1], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][2], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][3], tdps.classColor[tdpsPlayer[bar[i].guid]['class']][4])
			end
		end
	end

	local function tdpsHelp(v)
		if v == 'ver' then
			print('|cfffee00fTinyDPS |cffffff9fVersion ' .. GetAddOnMetadata('TinyDPS', 'Version'))
			--print('|cfffee00fTinyDPS |cffffff9fWritten by Sideshow (Draenor EU)')
		elseif v == 'help' then
			print('|cfffee00fTinyDPS |cffffff9fPress middle mouse button to reset all data')
			print('|cfffee00fTinyDPS |cffffff9fLeft click while holding shift to move the window')
			print('|cfffee00fTinyDPS |cffffff9fMouse back/forward to switch between overall/current fight')
		else
			print('|cfffee00fTinyDPS |cffffff9fCommands: /tdps show | hide | reset | help')
		end
	end

	local function tdpsReset()
		tdps.segment = 'c'
		for i=1,#bar do bar[i]:ClearAllPoints() bar[i]:Hide() end
		tdpsPlayer, tdpsPet, tdpsPointer, bar = {}, {}, {}, {}
		tdps.totals = {['od'] = 0, ['oh'] = 0, ['cd'] = 0, ['ch'] = 0, ['1d'] = 0, ['1h'] = 0, ['2d'] = 0, ['2h'] = 0, ['3d'] = 0, ['3h'] = 0}
		scrollPosition = 1
		tdpsFrame:SetHeight(tdps.barHeight+4)
		noData:Show()
		print('|cffffee00TinyDPS |cffffff9fAll data has been reset')
		--PlaySoundFile('Sound\\Interface\\PickUp\\PickUpParchment_Paper.wav')
	end

	SLASH_TINYDPS1, SLASH_TINYDPS2 = '/tinydps', '/tdps'
	function SlashCmdList.TINYDPS(msg, editbox)
		if lower(msg) == 'reset' then tdpsReset()
		elseif lower(msg) == 'hide' then tdpsFrame:Hide() tdps.hide.always = true CloseDropDownMenus()
		elseif lower(msg) == 'show' then for k,v in pairs(tdps.hide) do tdps.hide[k] = false end tdpsUpdate() tdpsFrame:Show()
		elseif lower(msg) == 'help' then tdpsHelp('help')
		else tdpsHelp() end
	end

	local function tdpsReport(channel, length)
		if not bar[1] or bar[1]:GetValue() == 0 then print("|cffffee00TinyDPS |cffffff9fNo data to report") return end
		if channel == 'WHISPER' and (not UnitIsPlayer('target') or not UnitCanCooperate('player', 'target')) then print('|cffffee00TinyDPS |cffffff9fInvalid or no target selected') return end
		local key = tdps.segment .. tdps.view
		-- title
		if key == 'od' then SendChatMessage('Damage Done for Overall Data', channel, nil, UnitName('target'))
		elseif key == 'oh' then SendChatMessage('Healing Done for Overall Data', channel, nil, UnitName('target'))
		elseif key == 'cd' then SendChatMessage('Damage Done for ' .. getFightName('c'),  channel, nil, UnitName('target'))
		elseif key == 'ch' then SendChatMessage('Healing Done for ' .. getFightName('c'), channel, nil, UnitName('target'))
		elseif key == '1d' then SendChatMessage('Damage Done for ' .. getFightName(1), channel, nil, UnitName('target'))
		elseif key == '1h' then SendChatMessage('Healing Done for ' .. getFightName(1), channel, nil, UnitName('target'))
		elseif key == '2d' then SendChatMessage('Damage Done for ' .. getFightName(2), channel, nil, UnitName('target'))
		elseif key == '2h' then SendChatMessage('Healing Done for ' .. getFightName(2), channel, nil, UnitName('target'))
		elseif key == '3d' then SendChatMessage('Damage Done for ' .. getFightName(3), channel, nil, UnitName('target'))
		elseif key == '3h' then SendChatMessage('Healing Done for ' .. getFightName(3), channel, nil, UnitName('target')) end
		tdpsUpdate()
		-- report
		for i=1,min(#bar, length) do
			if bar[i] and bar[i].n > 0 then
				-- get time
				local s = tdpsPlayer[bar[i].guid][tdps.segment..'t']
				-- add pet numbers
				local pets = tdpsPlayer[bar[i].guid]['pets'] for i=1,#pets do if tdpsPet[pets[i]][tdps.segment..'t'] > s then s = tdpsPet[pets[i]][tdps.segment..'t'] end end
				-- print
				SendChatMessage(i .. '. ' .. bar[i].name .. ':   ' .. bar[i].n .. '   ' .. fmtPercent(bar[i].n/tdps.totals[tdps.segment..tdps.view]*100) .. '   (' .. fmtDPS(bar[i].n/s) .. ')', channel, nil, UnitName('target'))
			end
		end
	end

	local tdpsDropDown, tdpsMenuTable = CreateFrame('Frame', 'tdpsDropDown', nil, 'UIDropDownMenuTemplate'), nil
	local function tdpsMenu()
		tdpsMenuTable = {}
		tdpsMenuTable = {
			{ text = 'TinyDPS           ', isTitle = 1, notCheckable = 1 },
			{ text = 'File', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Overall Data', checked = function() if tdps.segment == 'o' then return true end end, func = function() changeSegment('o') end },
					{ text = 'Current Fight', checked = function() if tdps.segment == 'c' then return true end end, func = function() changeSegment('c') end },
					{ text = getFightName(1), checked = function() if tdps.segment == '1' then return true end end, func = function() changeSegment('1') end },
					{ text = getFightName(2), checked = function() if tdps.segment == '2' then return true end end, func = function() changeSegment('2') end },
					{ text = getFightName(3), checked = function() if tdps.segment == '3' then return true end end, func = function() changeSegment('3') end },
					{ text = '', disabled = true },
					{ text = 'Reset All Data', func = function() tdpsReset() CloseDropDownMenus() end }
				}
			},
			{ text = 'View', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Damage', checked = function() if tdps.view == 'd' then return true end end, func = function() changeView() end },
					{ text = 'Healing', checked = function() if tdps.view == 'h' then return true end end, func = function() changeView() end }
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
					{ text = 'Bars', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Text', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Show DPS', func = function() tdps.showDPS = not tdps.showDPS tdpsUpdate() end, checked = function() return tdps.showDPS end, keepShownOnClick = 1 },
									{ text = 'Show Rank', func = function() tdps.showRank = not tdps.showRank tdpsUpdate() end, checked = function() return tdps.showRank end, keepShownOnClick = 1 },
									{ text = 'Show Percent', func = function() tdps.showPercent = not tdps.showPercent tdpsUpdate() end, checked = function() return tdps.showPercent end, keepShownOnClick = 1 },
									{ text = 'Show Damage', func = function() tdps.showDamage = not tdps.showDamage tdpsUpdate() end, checked = function() return tdps.showDamage end, keepShownOnClick = 1 },
									{ text = 'Short DPS Format', func = function() tdps.shortDPS = not tdps.shortDPS tdpsUpdate() end, checked = function() return tdps.shortDPS end, keepShownOnClick = 1 },
									{ text = 'Short Damage Format', func = function() tdps.shortDamage = not tdps.shortDamage tdpsUpdate() end, checked = function() return tdps.shortDamage end, keepShownOnClick = 1 }
								}
							},
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
							{ text = 'Font Size', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Increase', func = function() changeFontSize(tdps.fontSize+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeFontSize(tdps.fontSize-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Font Name', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Visitor', func = function() changeFont('Visitor.ttf') end, checked = function() if find(tdps.fontName, 'Visitor') then return true end end },
									{ text = 'Berlin Sans', func = function() changeFont('Berlin Sans.ttf') end, checked = function() if find(tdps.fontName, 'Berlin') then return true end end },
									{ text = 'Avant Garde', func = function() changeFont('Avant Garde.ttf') end, checked = function() if find(tdps.fontName, 'Avant') then return true end end },
									{ text = 'Franklin Gothic', func = function() changeFont('Franklin Gothic.ttf') end, checked = function() if find(tdps.fontName, 'Franklin') then return true end end }
								}
							},
							{ text = 'Bars Shown', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Unlimited', func = function() changeVisible(99) end, checked = function() if tdps.visible == 99 then return true end end },
									{ text = 'Maximum 5', func = function() changeVisible(5) end, checked = function() if tdps.visible == 5 then return true end end },
									{ text = 'Maximum 10', func = function() changeVisible(10) end, checked = function() if tdps.visible == 10 then return true end end },
									{ text = 'Maximum 15', func = function() changeVisible(15) end, checked = function() if tdps.visible == 15 then return true end end },
									{ text = 'Maximum 20', func = function() changeVisible(20) end, checked = function() if tdps.visible == 20 then return true end end }
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
							{ text = 'Backdrop Color', notClickable = 1,
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
							{ text = 'Reset Class Colors', notCheckable = 1, func = function() tdps.classColor = {} for c,_ in pairs(classColorDefault) do tdps.classColor[c] = {unpack(classColorDefault[c])} end updateAllBarColors() end, keepShownOnClick = 1 },
							{ text = 'Swap Bar/Class Color', notCheckable = 1, func = function() tdps.swapColor = not tdps.swapColor updateAllBarColors() end, keepShownOnClick = 1 },
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
							--}{ text = 'Warrior', notClickable = 1 },{ text = 'Rogue', notClickable = 1 },{ text = 'Paladin', notClickable = 1 },{ text = 'Priest', notClickable = 1 },{ text = 'Shaman', notClickable = 1 },{ text = 'Hunter', notClickable = 1 },{ text = 'Druid', notClickable = 1 },{ text = 'Deathknight', notClickable = 1 },
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
							{ text = 'Show Top Targets', func = function() tdps.showTargets = not tdps.showTargets end, checked = function() return tdps.showTargets end, keepShownOnClick = 1 },
							{ text = 'Show Top Abilities', func = function() tdps.showAbilities = not tdps.showAbilities end, checked = function() return tdps.showAbilities end, keepShownOnClick = 1 }
						}
					},
					{ text = 'More ...', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Hide When Solo', func = function() tdps.hide.solo = not tdps.hide.solo onUpdateElapsed = 3 end, checked = function() return tdps.hide.solo end, keepShownOnClick = 1 },
							{ text = 'Hide In PvP Zone', func = function() tdps.hide.pvp = not tdps.hide.pvp onUpdateElapsed = 3 end, checked = function() return tdps.hide.pvp end, keepShownOnClick = 1 },
							{ text = 'Hide Out Of Combat', func = function() tdps.hide.ooc = not tdps.hide.ooc onUpdateElapsed = 3 end, checked = function() return tdps.hide.ooc end, keepShownOnClick = 1 },
							{ text = 'Reset On New Group', func = function() tdps.autoReset = not tdps.autoReset end, checked = function() return tdps.autoReset end, keepShownOnClick = 1 }
						}
					},
				}
			},
			{ text = 'Close Menu', func = function() CloseDropDownMenus() end, notCheckable = 1 }
		}
	end

	local function scroll(d)
		if bar[1] and bar[1].n > 0 and scrollPosition - d > 0 and scrollPosition - d + tdps.visible <= barsWithValue + 1 then
			scrollPosition = scrollPosition - d
			tdpsUpdate()
		end
	end

	local function makeBar(g)
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
		dummybar:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
		dummybar:SetStatusBarTexture('Interface\\AddOns\\TinyDPS\\Textures\\wglass')
		dummybar:SetBackdropColor(0, 0, 0, 0)
		dummybar:SetBackdropBorderColor(0, 0, 0, 0)
		-- hidden bar info
		dummybar.name, dummybar.guid, dummybar.n = split('-', tdpsPlayer[g]['name']), g, 0
		-- bar scripts
		dummybar:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(dummybar)
			GameTooltip:SetText(tdpsPlayer[g]['name'])
			local key = tdps.segment .. tdps.view
			-- title
			if key == 'od' then GameTooltip:AddLine('Damage for Overall Data', 1, .85, 0)
			elseif key == 'oh' then GameTooltip:AddLine('Healing for Overall Data', 1, .85, 0)
			elseif key == 'cd' then GameTooltip:AddLine('Damage for Current Fight', 1, .85, 0)
			elseif key == 'ch' then GameTooltip:AddLine('Healing for Current Fight', 1, .85, 0)
			elseif key == '1d' then GameTooltip:AddLine('Damage for Previous Fight', 1, .85, 0)
			elseif key == '1h' then GameTooltip:AddLine('Healing for Previous Fight', 1, .85, 0)
			elseif key == '2d' then GameTooltip:AddLine('Damage for Previous Fight', 1, .85, 0)
			elseif key == '2h' then GameTooltip:AddLine('Healing for Previous Fight', 1, .85, 0)
			elseif key == '3d' then GameTooltip:AddLine('Damage for Previous Fight', 1, .85, 0)
			elseif key == '3h' then GameTooltip:AddLine('Healing for Previous Fight', 1, .85, 0) end
			-- numbers
			local pets, petAmount = tdpsPlayer[g]['pets'], 0
			for i=1,#pets do petAmount = petAmount + tdpsPet[pets[i]][key] end
			GameTooltip:AddDoubleLine('Personal', tdpsPlayer[self.guid][key] .. ' (' .. fmtPercent(tdpsPlayer[self.guid][key]/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1)
			if petAmount > 0 then GameTooltip:AddDoubleLine('By Pet(s)', petAmount .. ' (' .. fmtPercent(petAmount/(self.n)*100) .. ')' , 1, 1, 1, 1, 1, 1) end
			-- top abilities
			if tdps.showAbilities then
				GameTooltip:AddLine('Top 3 Abilities', 1, .85, 0)
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
				GameTooltip:AddLine('Top 3 Targets', 1, .85, 0)
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
			elseif button == 'MiddleButton' then tdpsReset()
			elseif button == 'Button4' then changeSegment('o')
			elseif button == 'Button5' then changeSegment('c') end
		end)
		dummybar:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() isMovingOrSizing = nil tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) end
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
		local classR, classG, classB, classA = unpack(tdps.classColor[tdpsPlayer[g]['class']])
		if tdps.swapColor then
			dummybar:SetStatusBarColor(classR, classG, classB, classA)
			dummybar.numbersFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.nameFS:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
		else
			dummybar:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.numbersFS:SetTextColor(classR, classG, classB, classA)
			dummybar.nameFS:SetTextColor(classR, classG, classB, classA)
		end
		-- save bar
		tableinsert(bar, dummybar)
	end

	local function makeCombatant(key, name, pgl, class)
		if class == 'PET' then
			tdpsPet[key] = {
				['name'] = name
				,['guid'] = pgl
				,['class'] = class
				,['stamp'] = 0
				,['od'] = 0, ['odt'] = {}, ['ods'] = {}, ['oh'] = 0, ['oht'] = {}, ['ohs'] = {}, ['ot'] = 0
				,['cd'] = 0, ['cdt'] = {}, ['cds'] = {}, ['ch'] = 0, ['cht'] = {}, ['chs'] = {}, ['ct'] = 0
				,['1d'] = 0, ['1dt'] = {}, ['1ds'] = {}, ['1h'] = 0, ['1ht'] = {}, ['1hs'] = {}, ['1t'] = 0
				,['2d'] = 0, ['2dt'] = {}, ['2ds'] = {}, ['2h'] = 0, ['2ht'] = {}, ['2hs'] = {}, ['2t'] = 0
				,['3d'] = 0, ['3dt'] = {}, ['3ds'] = {}, ['3h'] = 0, ['3ht'] = {}, ['3hs'] = {}, ['3t'] = 0
			}
		else
			tdpsPlayer[key] = {
				['name'] = name
				,['pets'] = pgl
				,['class'] = class
				,['stamp'] = 0
				,['od'] = 0, ['odt'] = {}, ['ods'] = {}, ['oh'] = 0, ['oht'] = {}, ['ohs'] = {}, ['ot'] = 0
				,['cd'] = 0, ['cdt'] = {}, ['cds'] = {}, ['ch'] = 0, ['cht'] = {}, ['chs'] = {}, ['ct'] = 0
				,['1d'] = 0, ['1dt'] = {}, ['1ds'] = {}, ['1h'] = 0, ['1ht'] = {}, ['1hs'] = {}, ['1t'] = 0
				,['2d'] = 0, ['2dt'] = {}, ['2ds'] = {}, ['2h'] = 0, ['2ht'] = {}, ['2hs'] = {}, ['2t'] = 0
				,['3d'] = 0, ['3dt'] = {}, ['3ds'] = {}, ['3h'] = 0, ['3ht'] = {}, ['3hs'] = {}, ['3t'] = 0
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
					makeBar(arg3)
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
				local oOO = split(':', tdpsPointer[arg3])
				-- make pointer
				tdpsPointer[arg6] = oOO..': '..arg7
				-- make pet
				makeCombatant(oOO..': '..arg7, arg7, arg6, 'PET')
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[UnitGUID(oOO)]['pets'] do if tdpsPlayer[UnitGUID(oOO)]['pets'][i] == oOO..': '..arg7 then found = true break end end
				if not found then tableinsert(tdpsPlayer[UnitGUID(oOO)]['pets'], oOO..': '..arg7) end
			end return
		end

		-- add player or a pet
		if not tdpsPlayer[arg3] and not tdpsPointer[arg3] then
			if UnitIsPlayer(arg4) then
				makeCombatant(arg3, arg4, {}, getClass(arg4))
				makeBar(arg3)
				tdpsCombatEvent(self, event, ...)
			elseif isPartyPet(arg3) then
				-- get owner
				local ownerGuid, ownerName = getPetOwnerGUID(arg3), getPetOwnerName(arg3)
				-- make owner if it does not exist yet
				if not tdpsPlayer[ownerGuid] then
					makeCombatant(ownerGuid, ownerName, {ownerName..': '..arg4}, getClass(ownerName))
					makeBar(ownerGuid)
				end
				-- make pointer
				tdpsPointer[arg3] = ownerName .. ': ' .. arg4
				-- make pet if it does not exist yet
				if not tdpsPet[ownerName..': '..arg4] then
					makeCombatant(ownerName..': '..arg4, arg4, arg3, 'PET')
				end
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[ownerGuid]['pets'] do if tdpsPlayer[ownerGuid]['pets'][i] == ownerName..': '.. arg4 then found = true break end end
				if not found then tableinsert(tdpsPlayer[ownerGuid]['pets'], ownerName..': '.. arg4) end
				tdpsCombatEvent(self, event, ...)
			end
			return
		end

		-- select combatant
		if UnitIsPlayer(arg4) then
			tmp = tdpsPlayer[arg3]
		elseif tdpsPet[tdpsPointer[arg3]] then
			tmp = tdpsPet[tdpsPointer[arg3]]
		else return	end
		
		-- add numbers
		if tdps.newFight and isMissed[arg2] then newFight(arg7) -- check if we need to start a new fight, even if first hit is a miss
		elseif isSpellDamage[arg2] then
			if tdps.newFight then newFight(arg7) end
			tdps.totals['od'] = tdps.totals['od'] + arg12
			tdps.totals['cd'] = tdps.totals['cd'] + arg12
			tmp['od'] = tmp['od'] + arg12
			tmp['cd'] = tmp['cd'] + arg12
			if tmp['odt'][arg7] then tmp['odt'][arg7] = tmp['odt'][arg7] + arg12 else tmp['odt'][arg7] = arg12 end
			if tmp['cdt'][arg7] then tmp['cdt'][arg7] = tmp['cdt'][arg7] + arg12 else tmp['cdt'][arg7] = arg12 end
			if tmp['ods'][arg10] then tmp['ods'][arg10] = tmp['ods'][arg10] + arg12 else tmp['ods'][arg10] = arg12 end
			if tmp['cds'][arg10] then tmp['cds'][arg10] = tmp['cds'][arg10] + arg12 else tmp['cds'][arg10] = arg12 end
		elseif arg2 == 'SWING_DAMAGE' then
			if tdps.newFight then newFight(arg7) end
			tdps.totals['od'] = tdps.totals['od'] + arg9
			tdps.totals['cd'] = tdps.totals['cd'] + arg9
			tmp['od'] = tmp['od'] + arg9
			tmp['cd'] = tmp['cd'] + arg9
			if tmp['odt'][arg7] then tmp['odt'][arg7] = tmp['odt'][arg7] + arg9 else tmp['odt'][arg7] = arg9 end
			if tmp['cdt'][arg7] then tmp['cdt'][arg7] = tmp['cdt'][arg7] + arg9 else tmp['cdt'][arg7] = arg9 end
			if tmp['ods']['Melee'] then tmp['ods']['Melee'] = tmp['ods']['Melee'] + arg9 else tmp['ods']['Melee'] = arg9 end
			if tmp['cds']['Melee'] then tmp['cds']['Melee'] = tmp['cds']['Melee'] + arg9 else tmp['cds']['Melee'] = arg9 end
		elseif arg2 == 'SPELL_PERIODIC_HEAL' or arg2 == 'SPELL_HEAL' then
			arg12 = arg12 - arg13 -- effective healing
			if arg12 == 0 or not inCombat then return end -- stop on complete overheal or out of combat
			tdps.totals['oh'] = tdps.totals['ch'] + arg12
			tdps.totals['ch'] = tdps.totals['ch'] + arg12
			tmp['oh'] = tmp['oh'] + arg12
			tmp['ch'] = tmp['ch'] + arg12
			if tmp['oht'][arg7] then tmp['oht'][arg7] = tmp['oht'][arg7] + arg12 else tmp['oht'][arg7] = arg12 end
			if tmp['cht'][arg7] then tmp['cht'][arg7] = tmp['cht'][arg7] + arg12 else tmp['cht'][arg7] = arg12 end
			if tmp['ohs'][arg10] then tmp['ohs'][arg10] = tmp['ohs'][arg10] + arg12 else tmp['ohs'][arg10] = arg12 end
			if tmp['chs'][arg10] then tmp['chs'][arg10] = tmp['chs'][arg10] + arg12 else tmp['chs'][arg10] = arg12 end
		end

		-- add combat time
		if arg1 - tmp['stamp'] < 3.5 then
			tmp['ot'] = tmp['ot'] + (arg1 - tmp['stamp'])
			tmp['ct'] = tmp['ct'] + (arg1 - tmp['stamp'])
		else
			tmp['ot'] = tmp['ot'] + 3.5
			tmp['ct'] = tmp['ct'] + 3.5
		end

		-- save time stamp
		tmp['stamp'] = arg1
	end





---------------------------------------------------------------------------------------------------------------------------------
--- scripts ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	local function tdpsVariablesLoaded(self, event)
		-- reinitialize on version mismatch
		if GetAddOnMetadata('TinyDPS', 'Version') ~= tdps.version then tdpsInitTables() tdpsFrame:SetHeight(tdps.barHeight+4)
		-- else just remake the bars
		else for k,_ in pairs(tdpsPlayer) do makeBar(k) end tdpsUpdate() end
		-- set fontsize
		noData:SetFont(tdps.fontName, tdps.fontSize)
		-- set colors
		tdpsFrame:SetBackdropBorderColor(tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4])
		tdpsFrame:SetBackdropColor(tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4])
		-- hide when necessary
		if (tdps.hide.ooc and not isCombat()) or (tdps.hide.pvp and (select(2,IsInInstance()) == 'pvp' or select(2,IsInInstance()) == 'arena')) or tdps.hide.always or (tdps.hide.solo and GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0) then tdpsFrame:Hide() end
		-- set anchor
		tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor)
		-- reset events
		tdpsMover:UnregisterEvent('VARIABLES_LOADED')
		tdpsMover:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		tdpsMover:SetScript('OnEvent', tdpsCombatEvent)
	end

	tdpsMover:RegisterEvent('VARIABLES_LOADED')
	tdpsMover:SetScript('OnEvent', tdpsVariablesLoaded)

	function tdpsOnUpdate(self, elapsed)
		onUpdateElapsed = onUpdateElapsed + elapsed
		if onUpdateElapsed > 2 then
			onUpdateElapsed = 0
			inCombat = isCombat()
			-- check if we need to auto reset
			if tdps.autoReset and not tdps.inGroup and (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) then tdpsReset() tdps.inGroup = true end
			if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then tdps.inGroup = true else tdps.inGroup = false end
			-- show or hide the frame
			if not tdps.hide.always and not (tdps.hide.ooc and not inCombat) and not (tdps.hide.pvp and (select(2,IsInInstance()) == 'pvp' or select(2,IsInInstance()) == 'arena')) and not (tdps.hide.solo and not tdps.inGroup) then
				if not tdpsFrame:IsVisible() then tdpsFrame:Show() end
			elseif tdpsFrame:IsVisible() then tdpsFrame:Hide() CloseDropDownMenus() end
			-- check for new fight
			if not inCombat then tdps.newFight = true end
			-- update when needed
			if tdpsFrame:IsVisible() and not isMovingOrSizing then tdpsUpdate() end
		end
	end

	local function tdpsOnUpdateStart(self, elapsed)
		onUpdateElapsed = onUpdateElapsed + elapsed
		if onUpdateElapsed > 2 then
			if tdps.firstStart then tdpsHelp('ver') tdps.firstStart = false end
			tdpsMover:SetScript('OnUpdate', tdpsOnUpdate)
		end
	end

	tdpsMover:SetScript('OnUpdate', tdpsOnUpdateStart)

	tdpsFrame:SetScript('OnMouseDown', function(self, button)
		if button == 'LeftButton' and IsShiftKeyDown() then CloseDropDownMenus() GameTooltip:Hide() isMovingOrSizing = true tdpsMover:StartMoving()
		elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU')
		elseif button == 'MiddleButton' then tdpsReset()
		elseif button == 'Button4' then changeSegment('o')
		elseif button == 'Button5' then changeSegment('c') end
	end)

	tdpsFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then tdpsMover:StopMovingOrSizing() isMovingOrSizing = nil tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsMover, tdps.anchor) end
	end)
	
	tdpsFrame:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)