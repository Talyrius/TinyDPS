--[[-----------------------------------------------------------------------------------------------------------------------------

	TinyDPS - Lightweight Damage Meter

	* written by Sideshow (Draenor EU)
	* initial release: May 21th, 2010
	* last update: October 22th, 2010

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

	Version 0.88
	* healing now includes (trackable) absorbs ('Power Word: Barrier' is not trackable)
	* optimized cpu usage: 'OnUpdate' halted when out of combat
	* optimized cpu usage: refreshing bar text is now much faster
	* various other optimizations, changes and tweaks

	Version 0.86
	* fixed tiny bug when swapping bar/text color
	* fixed boss tracking due to changes in patch 4.0.1

	Version 0.85
	* complete rewrite of data handling (collection and storage)
	* => fight history is now dynamic and can be completely turned off (default)
	* non damage pets (Wrath of Air Totem, etc.) are now ignored much faster (all languages, only english before)
	* changed some functions to prevent problems with saved variables and version
	* fixed a little bug with melee in the spell tracker
	* unchecking 'track spells' will now delete all spell data
	* resetting tinydps will not change to 'current fight' anymore
	* refreshing of bars can now be set to 1 second (default: 2)
	* minimap button is now disabled by default
	* lots of function rewrites and alround code cleaning

	Version 0.84
	* added: the position of the frame is now saved for all characters
	* added: a explicit reset of all saved variables and settings to prevent a bug with the spelltracker

	Version 0.83
	* fixed: bug with spell tracking

	Version 0.82
	* added: officer channel
	* fixed: cataclysm compatibility

	Version 0.81
	* fixed: tiny bug with raid colors from previous version. This changes nothing to the add-on actually, but it's just better

	Version 0.80
	* fixed: tiny bug with outline monochrome
	* changed: the default style is now more sexy ;)
	* changed: tracking of spells has been rewritten
	* changed: class colors will now use RAID_CLASS_COLORS (this changes nothing for most of us)
	* added: option to disable spell tracking completely (saves cpu and ram for the sake of tinyness)
	* the usual tiny adjustments and polish

	Version 0.79
	* (re-)added: option to autohide in pvp
	* (re-)added: option to autohide when solo
	* your dps is shown in the button tooltip (minimap)
	* some tiny adjustments not really worth mentioning

	Version 0.78
	* fixed: tiny bug with percentages (introduced in previous update)
	* changed: tiny adjustment in reporting
	* changed: simplified options menu
	* changed: updating TinyDPS will not reset your settings anymore

	Version 0.77
	* fixed: tiny bug with auto reset
	* fixed: evading mobs are now ignored (this fixes occasional empty fights)
	* added: option to only keep boss segments
	* cleaned up some scripts

	Version 0.76
	* fixed: some saved variables had the wrong location
	* fixed: on some rare occasion, bars would not update
	* optimized: "OnUpdate" event
	* optimized: "autoreset" on new group
	* optimized: combat check and fight splitting
	* optimized: updating of bars
	* => overall cpu savings up to 25%
	* added: you can now report top 3
	* minor interface adjustments

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
	* code optimization

	Version 0.37 BETA
	* initial public release





---------------------------------------------------------------------------------------------------------------------------------
--- variables -------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------]]



	local bar = {}
	local lastStamp = 0
	local tdpsShield = {}
	local px, com, key, arg
	local scrollPosition = 1
	local maxValue, barsWithValue
	local isMovingOrSizing = false



	local isValidEvent = {SPELL_SUMMON = true, SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true, SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true, SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isNewFightEvent = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true}
	local isMissed = {SWING_MISSED = true, RANGE_MISSED = true, SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true}
	local isHeal = {SPELL_PERIODIC_HEAL = true, SPELL_HEAL = true}
	local isDamage = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true}



	local isAbsorb = {

		-- Priest
		[17]    = true, -- Power Word: Shield
		--[62618] = true, -- Power Word: Barrier NOT TRACKABLE
		[47753] = true, -- Divine Aegis

		-- Paladin
		[86273] = true, -- Illuminated Healing TRACKABLE ?

		-- Death Knight
		[77535] = true, -- Blood Shield  TRACKABLE ?

	}



	local isExcludedPet = { -- database by myself (Sideshow)

		-- Various
		[15447] = true, -- Wrath of Air Totem
		[6112]  = true, -- Windfury Totem
		[5924]  = true, -- Cleansing Totem
		[2630]  = true, -- Earthbind Totem
		[5913]  = true, -- Tremor Totem
		[5925]  = true, -- Grounding Totem
		[10467] = true, -- Mana Tide Totem

		-- Mana Spring Totem
		[3573]  = true, -- Rank 1
		[7414]  = true, -- Rank 2
		[7415]  = true, -- Rank 3
		[7416]  = true, -- Rank 4
		[15489] = true, -- Rank 5
		[31186] = true, -- Rank 6
		[31189] = true, -- Rank 7
		[31190] = true, -- Rank 8

		-- Strength of Earth Totem
		[5874]  = true, -- Rank 1
		[5921]  = true, -- Rank 2
		[5922]  = true, -- Rank 3
		[7403]  = true, -- Rank 4
		[15464] = true, -- Rank 5
		[15479] = true, -- Rank 6
		[30647] = true, -- Rank 7
		[31129] = true, -- Rank 8

		-- Stoneskin Totem
		[5873]  = true, -- Rank 1
		[5919]  = true, -- Rank 2
		[5920]  = true, -- Rank 3
		[7366]  = true, -- Rank 4
		[7367]  = true, -- Rank 5
		[7368]  = true, -- Rank 6
		[15470] = true, -- Rank 7
		[15474] = true, -- Rank 8
		[31175] = true, -- Rank 9
		[31176] = true, -- Rank 10

		-- Totem of Wrath
		[17539] = true, -- Rank 1
		[30652] = true, -- Rank 2
		[30653] = true, -- Rank 3
		[30654] = true, -- Rank 4

		-- Stoneclaw Totem
		[3579]  = true, -- Rank 1
		[3911]  = true, -- Rank 2
		[3912]  = true, -- Rank 3
		[3913]  = true, -- Rank 4
		[7398]  = true, -- Rank 5
		[7399]  = true, -- Rank 6
		[15478] = true, -- Rank 7
		[31120] = true, -- Rank 8
		[31121] = true, -- Rank 9
		[31122] = true, -- Rank 10

		-- Flametongue Totem
		[5950]  = true, -- Rank 1
		[6012]  = true, -- Rank 2
		[7423]  = true, -- Rank 3
		[10557] = true, -- Rank 4
		[15485] = true, -- Rank 5
		[31132] = true, -- Rank 6
		[31158] = true, -- Rank 7
		[31133] = true, -- Rank 8

		-- Special
		[16486] = true, -- Web Wrap
		[28619] = true, -- Web Wrap
		[38028] = true, -- Web Wrap
		[29742] = true, -- Snake Wrap
		[38163] = true, -- Swarming Shadows
		[36619] = true, -- Bone Spike
		[38711] = true, -- Bone Spike
		[38712] = true, -- Bone Spike
		[2671]  = true, -- Mechanical Squirrel
		[10598] = true, -- Smolderweb Hatchling
		[10259] = true, -- Worg Pup
		[28306] = true, -- Anti-Magic Zone

	}



	local isBoss = { -- LibBossIDs-1.0 (Author: Elsia) http://www.wowace.com/addons/libbossids-1-0

		-- Ragefire Chasm
		[11517] = true, -- Oggleflint
		[11520] = true, -- Taragaman the Hungerer
		[11518] = true, -- Jergosh the Invoker
		[11519] = true, -- Bazzalan
		[17830] = true, -- Zelemar the Wrathful
		
		-- The Deadmines
		[644]   = true, -- Rhahk'Zor
		[3586]  = true, -- Miner Johnson
		[643]   = true, -- Sneed
		[642]   = true, -- Sneed's Shredder
		[1763]  = true, -- Gilnid
		[646]   = true, -- Mr. Smite
		[645]   = true, -- Cookie
		[647]   = true, -- Captain Greenskin
		[639]   = true, -- Edwin VanCleef
		[596]   = true, -- Brainwashed Noble, outside
		[626]   = true, -- Foreman Thistlenettle, outside
		[599]   = true, -- Marisa du'Paige, outside
		
		-- Wailing Caverns
		[5775]  = true, -- Verdan the Everliving
		[3670]  = true, -- Lord Pythas
		[3673]  = true, -- Lord Serpentis
		[3669]  = true, -- Lord Cobrahn
		[3654]  = true, -- Mutanus the Devourer
		[3674]  = true, -- Skum
		[3653]  = true, -- Kresh
		[3671]  = true, -- Lady Anacondra
		[5912]  = true, -- Deviate Faerie Dragon
		[3672]  = true, -- Boahn, outside
		[3655]  = true, -- Mad Magglish, outside
		[3652]  = true, -- Trigore the Lasher, outside
		
		-- Shadowfang Keep
		[3914]  = true, -- Rethilgore
		[3886]  = true, -- Razorclaw the Butcher
		[4279]  = true, -- Odo the Blindwatcher
		[3887]  = true, -- Baron Silverlaine
		[4278]  = true, -- Commander Springvale
		[4274]  = true, -- Fenrus the Devourer
		[3927]  = true, -- Wolf Master Nandos
		[14682] = true, -- Sever (Scourge invasion only)
		[4275]  = true, -- Archmage Arugal
		[3872]  = true, -- Deathsworn Captain
		
		-- Blackfathom Deeps
		[4887]  = true, -- Ghamoo-ra
		[4831]  = true, -- Lady Sarevess
		[12902] = true, -- Lorgus Jett
		[6243]  = true, -- Gelihast
		[12876] = true, -- Baron Aquanis
		[4830]  = true, -- Old Serra'kis
		[4832]  = true, -- Twilight Lord Kelris
		[4829]  = true, -- Aku'mai
		
		-- Stormwind Stockade
		[1716]  = true, -- Bazil Thredd
		[1663]  = true, -- Dextren Ward
		[1717]  = true, -- Hamhock
		[1666]  = true, -- Kam Deepfury
		[1696]  = true, -- Targorr the Dread
		[1720]  = true, -- Bruegal Ironknuckle
		
		-- Razorfen Kraul
		[4421]  = true, -- Charlga Razorflank
		[4420]  = true, -- Overlord Ramtusk
		[4422]  = true, -- Agathelos the Raging
		[4428]  = true, -- Death Speaker Jargba
		[4424]  = true, -- Aggem Thorncurse
		[6168]  = true, -- Roogug
		[4425]  = true, -- Blind Hunter
		[4842]  = true, -- Earthcaller Halmgar
		
		-- Gnomeregan
		[7800]  = true, -- Mekgineer Thermaplugg
		[7079]  = true, -- Viscous Fallout
		[7361]  = true, -- Grubbis
		[6235]  = true, -- Electrocutioner 6000
		[6229]  = true, -- Crowd Pummeler 9-60
		[6228]  = true, -- Dark Iron Ambassador
		[6231]  = true, -- Techbot, outside
		
		-- Scarlet Monastery: The Graveyard
		[3983]  = true, -- Interrogator Vishas
		[6488]  = true, -- Fallen Champion
		[6490]  = true, -- Azshir the Sleepless
		[6489]  = true, -- Ironspine
		[14693] = true, -- Scorn (Scourge invasion only)
		[4543]  = true, -- Bloodmage Thalnos
		[23682] = true, -- Headless Horseman
		[23800] = true, -- Headless Horseman
		
		-- Scarley Monastery: Library
		[3974]  = true, -- Houndmaster Loksey
		[6487]  = true, -- Arcanist Doan
		
		-- Scarley Monastery: Armory
		[3975]  = true, -- Herod
		
		-- Scarley Monastery: Cathedral
		[4542]  = true, -- High Inquisitor Fairbanks
		[3976]  = true, -- Scarlet Commander Mograine
		[3977]  = true, -- High Inquisitor Whitemane
		
		-- Razorfen Downs
		[7355]  = true, -- Tuten'kash
		[14686] = true, -- Lady Falther'ess (Scourge invasion only)
		[7356]  = true, -- Plaguemaw the Rotting
		[7357]  = true, -- Mordresh Fire Eye
		[8567]  = true, -- Glutton
		[7354]  = true, -- Ragglesnout
		[7358]  = true, -- Amnennar the Coldbringer
		
		-- Uldaman
		[7057]  = true, -- Digmaster Shovelphlange
		-- [2932]  = true, -- Magregan Deepshadow (Outside the instance, not elite)
		[6910]  = true, -- Revelosh
		[7228]  = true, -- Ironaya
		[7023]  = true, -- Obsidian Sentinel
		[7206]  = true, -- Ancient Stone Keeper
		[7291]  = true, -- Galgann Firehammer
		[4854]  = true, -- Grimlok
		[2748]  = true, -- Archaedas
		[6906]  = true, -- Baelog
		
		-- Zul'Farrak
		[10082] = true, -- Zerillis
		[10080] = true, -- Sandarr Dunereaver
		[7272]  = true, -- Theka the Martyr
		[8127]  = true, -- Antu'sul
		[7271]  = true, -- Witch Doctor Zum'rah
		[7274]  = true, -- Sandfury Executioner
		[7275]  = true, -- Shadowpriest Sezz'ziz
		[7796]  = true, -- Nekrum Gutchewer
		[7797]  = true, -- Ruuzlu
		[7267]  = true, -- Chief Ukorz Sandscalp
		[10081] = true, -- Dustwraith
		[7795]  = true, -- Hydromancer Velratha
		[7273]  = true, -- Gahz'rilla
		[7608]  = true, -- Murta Grimgut
		[7606]  = true, -- Oro Eyegouge
		[7604]  = true, -- Sergeant Bly
		
		-- Maraudon
		-- [13718] = true, -- The Nameless Prophet (Pre-instance)
		[13742] = true, -- Kolk <The First Khan>
		[13741] = true, -- Gelk <The Second Khan>
		[13740] = true, -- Magra <The Third Khan>
		[13739] = true, -- Maraudos <The Fourth Khan>
		[12236] = true, -- Lord Vyletongue
		[13738] = true, -- Veng <The Fifth Khan>
		[13282] = true, -- Noxxion
		[12258] = true, -- Razorlash
		[12237] = true, -- Meshlok the Harvester
		[12225] = true, -- Celebras the Cursed
		[12203] = true, -- Landslide
		[13601] = true, -- Tinkerer Gizlock
		[13596] = true, -- Rotgrip
		[12201] = true, -- Princess Theradras
		
		-- Temple of Atal'Hakkar
		[1063]  = true, -- Jade
		[5400]  = true, -- Zekkis
		[5713]  = true, -- Gasher
		[5715]  = true, -- Hukku
		[5714]  = true, -- Loro
		[5717]  = true, -- Mijan
		[5712]  = true, -- Zolo
		[5716]  = true, -- Zul'Lor
		[5399]  = true, -- Veyzhak the Cannibal
		[5401]  = true, -- Kazkaz the Unholy
		[8580]  = true, -- Atal'alarion
		[8443]  = true, -- Avatar of Hakkar
		[5711]  = true, -- Ogom the Wretched
		[5710]  = true, -- Jammal'an the Prophet
		[5721]  = true, -- Dreamscythe
		[5720]  = true, -- Weaver
		[5719]  = true, -- Morphaz
		[5722]  = true, -- Hazzas
		[5709]  = true, -- Shade of Eranikus
		
		-- The Blackrock Depths: Detention Block
		[9018]  = true, -- High Interrogator Gerstahn
		
		-- The Blackrock Depths: Halls of the Law
		[9025]  = true, -- Lord Roccor
		[9319]  = true, -- Houndmaster Grebmar
		
		-- The Blackrock Depths: Ring of Law (Arena)
		[9031]  = true, -- Anub'shiah
		[9029]  = true, -- Eviscerator
		[9027]  = true, -- Gorosh the Dervish
		[9028]  = true, -- Grizzle
		[9032]  = true, -- Hedrum the Creeper
		[9030]  = true, -- Ok'thor the Breaker
		[16059] = true, -- Theldren
		
		-- The Blackrock Depths: Outer Blackrock Depths
		[9024]  = true, -- Pyromancer Loregrain
		[9041]  = true, -- Warder Stilgiss
		[9042]  = true, -- Verek
		[9476]  = true, -- Watchman Doomgrip
		-- Dark Keepers, 6 of em: http://www.wowwiki.com/Dark_Keeper
		[9056]  = true, -- Fineous Darkvire
		[9017]  = true, -- Lord Incendius
		[9016]  = true, -- Bael'Gar
		[9033]  = true, -- General Angerforge
		[8983]  = true, -- Golem Lord Argelmach
		
		-- The Blackrock Depths: Grim Guzzler
		[9543]  = true, -- Ribbly Screwspigot
		[9537]  = true, -- Hurley Blackbreath
		[9502]  = true, -- Phalanx
		[9499]  = true, -- Plugger Spazzring
		[23872] = true, -- Coren Direbrew
		
		-- The Blackrock Depths: Inner Blackrock Depths
		[9156]  = true, -- Ambassador Flamelash
		[8923]  = true, -- Panzor the Invincible
		[17808] = true, -- Anger'rel
		[9039]  = true, -- Doom'rel
		[9040]  = true, -- Dope'rel
		[9037]  = true, -- Gloom'rel
		[9034]  = true, -- Hate'rel
		[9038]  = true, -- Seeth'rel
		[9036]  = true, -- Vile'rel
		[9938]  = true, -- Magmus
		[10076] = true, -- High Priestess of Thaurissan
		[8929]  = true, -- Princess Moira Bronzebeard
		[9019]  = true, -- Emperor Dagran Thaurissan
		
		-- Dire Maul: Arena
		[11447] = true, -- Mushgog
		[11498] = true, -- Skarr the Unbreakable
		[11497] = true, -- The Razza
		
		-- Dire Maul: East
		[14354] = true, -- Pusillin
		[14327] = true, -- Lethtendris
		[14349] = true, -- Pimgib
		[13280] = true, -- Hydrospawn
		[11490] = true, -- Zevrim Thornhoof
		[11492] = true, -- Alzzin the Wildshaper
		[16097] = true, -- Isalien
		
		-- Dire Maul: North
		[14326] = true, -- Guard Mol'dar
		[14322] = true, -- Stomper Kreeg
		[14321] = true, -- Guard Fengus
		[14323] = true, -- Guard Slip'kik
		[14325] = true, -- Captain Kromcrush
		[14324] = true, -- Cho'Rush the Observer
		[11501] = true, -- King Gordok
		
		-- Dire Maul: West
		[11489] = true, -- Tendris Warpwood
		[11487] = true, -- Magister Kalendris
		[11467] = true, -- Tsu'zee
		[11488] = true, -- Illyanna Ravenoak
		[14690] = true, -- Revanchion (Scourge Invasion)
		[11496] = true, -- Immol'thar
		[14506] = true, -- Lord Hel'nurath
		[11486] = true, -- Prince Tortheldrin
		
		-- Lower Blackrock Spire
		[10263] = true, -- Burning Felguard
		[9218]  = true, -- Spirestone Battle Lord
		[9219]  = true, -- Spirestone Butcher
		[9217]  = true, -- Spirestone Lord Magus
		[9196]  = true, -- Highlord Omokk
		[9236]  = true, -- Shadow Hunter Vosh'gajin
		[9237]  = true, -- War Master Voone
		[16080] = true, -- Mor Grayhoof
		[9596]  = true, -- Bannok Grimaxe
		[10596] = true, -- Mother Smolderweb
		[10376] = true, -- Crystal Fang
		[10584] = true, -- Urok Doomhowl
		[9736]  = true, -- Quartermaster Zigris
		[10220] = true, -- Halycon
		[10268] = true, -- Gizrul the Slavener
		[9718]  = true, -- Ghok Bashguud
		[9568]  = true, -- Overlord Wyrmthalak
		
		-- Stratholme: Scarlet Stratholme
		[10393] = true, -- Skul
		[14684] = true, -- Balzaphon (Scourge Invasion)
		-- [11082] = true, -- Stratholme Courier
		[11058] = true, -- Fras Siabi
		[10558] = true, -- Hearthsinger Forresten
		[10516] = true, -- The Unforgiven
		[16387] = true, -- Atiesh
		[11143] = true, -- Postmaster Malown
		[10808] = true, -- Timmy the Cruel
		[11032] = true, -- Malor the Zealous
		[11120] = true, -- Crimson Hammersmith
		[10997] = true, -- Cannon Master Willey
		[10811] = true, -- Archivist Galford
		[10813] = true, -- Balnazzar
		[16101] = true, -- Jarien
		[16102] = true, -- Sothos
		
		-- Stratholme: Undead Stratholme
		[10809] = true, -- Stonespine
		[10437] = true, -- Nerub'enkan
		[10436] = true, -- Baroness Anastari
		[11121] = true, -- Black Guard Swordsmith
		[10438] = true, -- Maleki the Pallid
		[10435] = true, -- Magistrate Barthilas
		[10439] = true, -- Ramstein the Gorger
		[10440] = true, -- Baron Rivendare (Stratholme)

		-- Stratholme: Defenders of the Chapel
		[17913] = true, -- Aelmar the Vanquisher
		[17911] = true, -- Cathela the Seeker
		[17910] = true, -- Gregor the Justiciar
		[17914] = true, -- Vicar Hieronymus
		[17912] = true, -- Nemas the Arbiter
		
		-- Scholomance
		[14861] = true, -- Blood Steward of Kirtonos
		[10506] = true, -- Kirtonos the Herald
		[14695] = true, -- Lord Blackwood (Scourge Invasion)
		[10503] = true, -- Jandice Barov
		[11622] = true, -- Rattlegore
		[14516] = true, -- Death Knight Darkreaver
		[10433] = true, -- Marduk Blackpool
		[10432] = true, -- Vectus
		[16118] = true, -- Kormok
		[10508] = true, -- Ras Frostwhisper
		[10505] = true, -- Instructor Malicia
		[11261] = true, -- Doctor Theolen Krastinov
		[10901] = true, -- Lorekeeper Polkelt
		[10507] = true, -- The Ravenian
		[10504] = true, -- Lord Alexei Barov
		[10502] = true, -- Lady Illucia Barov
		[1853]  = true, -- Darkmaster Gandling
		
		-- Upper Blackrock Spire
		[9816]  = true, -- Pyroguard Emberseer
		[10264] = true, -- Solakar Flamewreath
		[10509] = true, -- Jed Runewatcher
		[10899] = true, -- Goraluk Anvilcrack
		[10339] = true, -- Gyth
		[10429] = true, -- Warchief Rend Blackhand
		[10430] = true, -- The Beast
		[16042] = true, -- Lord Valthalak
		[10363] = true, -- General Drakkisath
		
		-- Zul'Gurub
		[14517] = true, -- High Priestess Jeklik
		[14507] = true, -- High Priest Venoxis
		[14510] = true, -- High Priestess Mar'li
		[11382] = true, -- Bloodlord Mandokir
		[15114] = true, -- Gahz'ranka
		[14509] = true, -- High Priest Thekal
		[14515] = true, -- High Priestess Arlokk
		[11380] = true, -- Jin'do the Hexxer
		[14834] = true, -- Hakkar
		[15082] = true, -- Gri'lek
		[15083] = true, -- Hazza'rah
		[15084] = true, -- Renataki
		[15085] = true, -- Wushoolay
		
		-- Onyxia's Lair
		[10184] = true, -- Onyxia
		
		-- Molten Core
		[12118] = true, -- Lucifron
		[11982] = true, -- Magmadar
		[12259] = true, -- Gehennas
		[12057] = true, -- Garr
		[12056] = true, -- Baron Geddon
		[12264] = true, -- Shazzrah
		[12098] = true, -- Sulfuron Harbinger
		[11988] = true, -- Golemagg the Incinerator
		[12018] = true, -- Majordomo Executus
		[11502] = true, -- Ragnaros
		
		-- Blackwing Lair
		[12435] = true, -- Razorgore the Untamed
		[13020] = true, -- Vaelastrasz the Corrupt
		[12017] = true, -- Broodlord Lashlayer
		[11983] = true, -- Firemaw
		[14601] = true, -- Ebonroc
		[11981] = true, -- Flamegor
		[14020] = true, -- Chromaggus
		[11583] = true, -- Nefarian
		[12557] = true, -- Grethok the Controller
		[10162] = true, -- Lord Victor Nefarius <Lord of Blackrock> (Also found in Blackrock Spire)
		
		-- Ruins of Ahn'Qiraj
		[15348] = true, -- Kurinnaxx
		[15341] = true, -- General Rajaxx
		[15340] = true, -- Moam
		[15370] = true, -- Buru the Gorger
		[15369] = true, -- Ayamiss the Hunter
		[15339] = true, -- Ossirian the Unscarred
		
		-- Temple of Ahn'Qiraj
		[15263] = true, -- The Prophet Skeram
		[15511] = true, -- Lord Kri
		[15543] = true, -- Princess Yauj
		[15544] = true, -- Vem
		[15516] = true, -- Battleguard Sartura
		[15510] = true, -- Fankriss the Unyielding
		[15299] = true, -- Viscidus
		[15509] = true, -- Princess Huhuran
		[15276] = true, -- Emperor Vek'lor
		[15275] = true, -- Emperor Vek'nilash
		[15517] = true, -- Ouro
		[15727] = true, -- C'Thun
		[15589] = true, -- Eye of C'Thun
		
		-- Naxxramas
		[30549] = true, -- Baron Rivendare (Naxxramas)
		[16803] = true, -- Death Knight Understudy
		[15930] = true, -- Feugen
		[15929] = true, -- Stalagg
		
		-- Naxxramas: Spider Wing
		[15956] = true, -- Anub'Rekhan
		[15953] = true, -- Grand Widow Faerlina
		[15952] = true, -- Maexxna
		
		-- Naxxramas: Abomination Wing
		[16028] = true, -- Patchwerk
		[15931] = true, -- Grobbulus
		[15932] = true, -- Gluth
		[15928] = true, -- Thaddius
		
		-- Naxxramas: Plague Wing
		[15954] = true, -- Noth the Plaguebringer
		[15936] = true, -- Heigan the Unclean
		[16011] = true, -- Loatheb
		
		-- Naxxramas: Deathknight Wing
		[16061] = true, -- Instructor Razuvious
		[16060] = true, -- Gothik the Harvester
		
		-- Naxxramas: The Four Horsemen
		[16065] = true, -- Lady Blaumeux
		[16064] = true, -- Thane Korth'azz
		[16062] = true, -- Highlord Mograine
		[16063] = true, -- Sir Zeliek
		
		-- Naxxramas: Frostwyrm Lair
		[15989] = true, -- Sapphiron
		[15990] = true, -- Kel'Thuzad
		[25465] = true, -- Kel'Thuzad
		
		
		-- Hellfire Citadel: Hellfire Ramparts
		[17306] = true, -- Watchkeeper Gargolmar
		[17308] = true, -- Omor the Unscarred
		[17537] = true, -- Vazruden
		[17307] = true, -- Vazruden the Herald
		[17536] = true, -- Nazan
		
		-- Hellfire Citadel: The Blood Furnace
		[17381] = true, -- The Maker
		[17380] = true, -- Broggok
		[17377] = true, -- Keli'dan the Breaker
		
		-- Coilfang Reservoir: Slave Pens
		[25740] = true, -- Ahune
		[17941] = true, -- Mennu the Betrayer
		[17991] = true, -- Rokmar the Crackler
		[17942] = true, -- Quagmirran
		
		-- Coilfang Reservoir: The Underbog
		[17770] = true, -- Hungarfen
		[18105] = true, -- Ghaz'an
		[17826] = true, -- Swamplord Musel'ek
		[17827] = true, -- Claw <Swamplord Musel'ek's Pet>
		[17882] = true, -- The Black Stalker
		
		-- Auchindoun: Mana-Tombs
		[18341] = true, -- Pandemonius
		[18343] = true, -- Tavarok
		[22930] = true, -- Yor (Heroic)
		[18344] = true, -- Nexus-Prince Shaffar
		
		-- Auchindoun: Auchenai Crypts
		[18371] = true, -- Shirrak the Dead Watcher
		[18373] = true, -- Exarch Maladaar
		
		-- Caverns of Time: Escape from Durnholde Keep
		[17848] = true, -- Lieutenant Drake
		[17862] = true, -- Captain Skarloc
		[18096] = true, -- Epoch Hunter
		[28132] = true, -- Don Carlos
		
		-- Auchindoun: Sethekk Halls
		[18472] = true, -- Darkweaver Syth
		[23035] = true, -- Anzu (Heroic)
		[18473] = true, -- Talon King Ikiss
		
		-- Coilfang Reservoir: The Steamvault
		[17797] = true, -- Hydromancer Thespia
		[17796] = true, -- Mekgineer Steamrigger
		[17798] = true, -- Warlord Kalithresh
		
		-- Auchindoun: Shadow Labyrinth
		[18731] = true, -- Ambassador Hellmaw
		[18667] = true, -- Blackheart the Inciter
		[18732] = true, -- Grandmaster Vorpil
		[18708] = true, -- Murmur
		
		-- Hellfire Citadel: Shattered Halls
		[16807] = true, -- Grand Warlock Nethekurse
		[20923] = true, -- Blood Guard Porung (Heroic)
		[16809] = true, -- Warbringer O'mrogg
		[16808] = true, -- Warchief Kargath Bladefist
		
		-- Caverns of Time: Opening the Dark Portal
		[17879] = true, -- Chrono Lord Deja
		[17880] = true, -- Temporus
		[17881] = true, -- Aeonus
		
		-- Tempest Keep: The Mechanar
		[19218] = true, -- Gatewatcher Gyro-Kill
		[19710] = true, -- Gatewatcher Iron-Hand
		[19219] = true, -- Mechano-Lord Capacitus
		[19221] = true, -- Nethermancer Sepethrea
		[19220] = true, -- Pathaleon the Calculator
		
		-- Tempest Keep: The Botanica
		[17976] = true, -- Commander Sarannis
		[17975] = true, -- High Botanist Freywinn
		[17978] = true, -- Thorngrin the Tender
		[17980] = true, -- Laj
		[17977] = true, -- Warp Splinter
		
		-- Tempest Keep: The Arcatraz
		[20870] = true, -- Zereketh the Unbound
		[20886] = true, -- Wrath-Scryer Soccothrates
		[20885] = true, -- Dalliah the Doomsayer
		[20912] = true, -- Harbinger Skyriss
		[20904] = true, -- Warden Mellichar
		
		-- Magisters' Terrace
		[24723] = true, -- Selin Fireheart
		[24744] = true, -- Vexallus
		[24560] = true, -- Priestess Delrissa
		[24664] = true, -- Kael'thas Sunstrider
		
		-- Karazhan
		[15550] = true, -- Attumen the Huntsman
		[16151] = true, -- Midnight
		[28194] = true, -- Tenris Mirkblood (Scourge invasion)
		[15687] = true, -- Moroes
		[16457] = true, -- Maiden of Virtue
		[15691] = true, -- The Curator
		[15688] = true, -- Terestian Illhoof
		[16524] = true, -- Shade of Aran
		[15689] = true, -- Netherspite
		[15690] = true, -- Prince Malchezaar
		[17225] = true, -- Nightbane
		[17229] = true, -- Kil'rek
		-- Chess event
		
		-- Karazhan: Servants' Quarters Beasts
		[16179] = true, -- Hyakiss the Lurker
		[16181] = true, -- Rokad the Ravager
		[16180] = true, -- Shadikith the Glider
		
		-- Karazhan: Opera Event
		[17535] = true, -- Dorothee
		[17546] = true, -- Roar
		[17543] = true, -- Strawman
		[17547] = true, -- Tinhead
		[17548] = true, -- Tito
		[18168] = true, -- The Crone
		[17521] = true, -- The Big Bad Wolf
		[17533] = true, -- Romulo
		[17534] = true, -- Julianne
		
		-- Gruul's Lair
		[18831] = true, -- High King Maulgar
		[19044] = true, -- Gruul the Dragonkiller
		
		-- Gruul's Lair: Maulgar's Ogre Council
		[18835] = true, -- Kiggler the Crazed
		[18836] = true, -- Blindeye the Seer
		[18834] = true, -- Olm the Summoner
		[18832] = true, -- Krosh Firehand
		
		-- Hellfire Citadel: Magtheridon's Lair
		[17257] = true, -- Magtheridon
		
		-- Zul'Aman: Animal Bosses
		[29024] = true, -- Nalorakk
		[28514] = true, -- Nalorakk
		[23576] = true, -- Nalorakk
		[23574] = true, -- Akil'zon
		[23578] = true, -- Jan'alai
		[28515] = true, -- Jan'alai
		[29023] = true, -- Jan'alai
		[23577] = true, -- Halazzi
		[28517] = true, -- Halazzi
		[29022] = true, -- Halazzi
		[24239] = true, -- Malacrass
		
		-- Zul'Aman: Final Bosses
		[24239] = true, -- Hex Lord Malacrass
		[23863] = true, -- Zul'jin
		
		-- Coilfang Reservoir: Serpentshrine Cavern
		[21216] = true, -- Hydross the Unstable
		[21217] = true, -- The Lurker Below
		[21215] = true, -- Leotheras the Blind
		[21214] = true, -- Fathom-Lord Karathress
		[21213] = true, -- Morogrim Tidewalker
		[21212] = true, -- Lady Vashj
		[21875] = true, -- Shadow of Leotheras
		
		-- Tempest Keep: The Eye
		[19514] = true, -- Al'ar
		[19516] = true, -- Void Reaver
		[18805] = true, -- High Astromancer Solarian
		[19622] = true, -- Kael'thas Sunstrider
		[20064] = true, -- Thaladred the Darkener
		[20060] = true, -- Lord Sanguinar
		[20062] = true, -- Grand Astromancer Capernian
		[20063] = true, -- Master Engineer Telonicus
		[21270] = true, -- Cosmic Infuser
		[21269] = true, -- Devastation
		[21271] = true, -- Infinity Blades
		[21268] = true, -- Netherstrand Longbow
		[21273] = true, -- Phaseshift Bulwark
		[21274] = true, -- Staff of Disintegration
		[21272] = true, -- Warp Slicer
		
		-- Caverns of Time: Battle for Mount Hyjal
		[17767] = true, -- Rage Winterchill
		[17808] = true, -- Anetheron
		[17888] = true, -- Kaz'rogal
		[17842] = true, -- Azgalor
		[17968] = true, -- Archimonde
		
		-- Black Temple
		[22887] = true, -- High Warlord Naj'entus
		[22898] = true, -- Supremus
		[22841] = true, -- Shade of Akama
		[22871] = true, -- Teron Gorefiend
		[22948] = true, -- Gurtogg Bloodboil
		[23420] = true, -- Essence of Anger
		[23419] = true, -- Essence of Desire
		[23418] = true, -- Essence of Suffering
		[22947] = true, -- Mother Shahraz
		[23426] = true, -- Illidari Council
		[22917] = true, -- Illidan Stormrage -- Not adding solo quest IDs for now
		[22949] = true, -- Gathios the Shatterer
		[22950] = true, -- High Nethermancer Zerevor
		[22951] = true, -- Lady Malande
		[22952] = true, -- Veras Darkshadow
		
		-- Sunwell Plateau
		[24891] = true, -- Kalecgos
		[25319] = true, -- Kalecgos
		[24850] = true, -- Kalecgos
		[24882] = true, -- Brutallus
		[25038] = true, -- Felmyst
		[25165] = true, -- Lady Sacrolash
		[25166] = true, -- Grand Warlock Alythess
		[25741] = true, -- M'uru
		[25315] = true, -- Kil'jaeden
		[25840] = true, -- Entropius
		[24892] = true, -- Sathrovarr the Corruptor
		
		
		-- Utgarde Keep: Main Bosses
		[23953] = true, -- Prince Keleseth (Utgarde Keep)
		[27390] = true, -- Skarvald the Constructor
		[24200] = true, -- Skarvald the Constructor
		[23954] = true, -- Ingvar the Plunderer
		[23980] = true, -- Ingvar the Plunderer
		
		-- Utgarde Keep: Secondary Bosses
		[27389] = true, -- Dalronn the Controller
		[24201] = true, -- Dalronn the Controller
		
		-- The Nexus
		[26798] = true, -- Commander Kolurg (Heroic)
		[26796] = true, -- Commander Stoutbeard (Heroic)
		[26731] = true, -- Grand Magus Telestra
		[26832] = true, -- Grand Magus Telestra
		[26928] = true, -- Grand Magus Telestra
		[26929] = true, -- Grand Magus Telestra
		[26930] = true, -- Grand Magus Telestra
		[26763] = true, -- Anomalus
		[26794] = true, -- Ormorok the Tree-Shaper
		[26723] = true, -- Keristrasza
		
		-- Azjol-Nerub
		[28684] = true, -- Krik'thir the Gatewatcher
		[28921] = true, -- Hadronox
		[29120] = true, -- Anub'arak
		
		-- Ahn'kahet: The Old Kingdom
		[29309] = true, -- Elder Nadox
		[29308] = true, -- Prince Taldaram (Ahn'kahet: The Old Kingdom)
		[29310] = true, -- Jedoga Shadowseeker
		[29311] = true, -- Herald Volazj
		[30258] = true, -- Amanitar (Heroic)
		
		-- Drak'Tharon Keep
		[26630] = true, -- Trollgore
		[26631] = true, -- Novos the Summoner
		[27483] = true, -- King Dred
		[26632] = true, -- The Prophet Tharon'ja
		[27696] = true, -- The Prophet Tharon'ja
		
		-- The Violet Hold
		[29315] = true, -- Erekem
		[29313] = true, -- Ichoron
		[29312] = true, -- Lavanthor
		[29316] = true, -- Moragg
		[29266] = true, -- Xevozz
		[29314] = true, -- Zuramat the Obliterator
		[31134] = true, -- Cyanigosa
		
		-- Gundrak
		[29304] = true, -- Slad'ran
		[29305] = true, -- Moorabi
		[29307] = true, -- Drakkari Colossus
		[29306] = true, -- Gal'darah
		[29932] = true, -- Eck the Ferocious (Heroic)
		
		-- Halls of Stone
		[27977] = true, -- Krystallus
		[27975] = true, -- Maiden of Grief
		[28234] = true, -- The Tribunal of Ages
		[27978] = true, -- Sjonnir The Ironshaper
		
		-- Halls of Lightning
		[28586] = true, -- General Bjarngrim
		[28587] = true, -- Volkhan
		[28546] = true, -- Ionar
		[28923] = true, -- Loken
		
		-- The Oculus
		[27654] = true, -- Drakos the Interrogator
		[27447] = true, -- Varos Cloudstrider
		[27655] = true, -- Mage-Lord Urom
		[27656] = true, -- Ley-Guardian Eregos
		
		-- Caverns of Time: Culling of Stratholme
		[26529] = true, -- Meathook
		[26530] = true, -- Salramm the Fleshcrafter
		[26532] = true, -- Chrono-Lord Epoch
		[32273] = true, -- Infinite Corruptor
		[26533] = true, -- Mal'Ganis
		[29620] = true, -- Mal'Ganis
		
		-- Utgarde Pinnacle
		[26668] = true, -- Svala Sorrowgrave
		[26687] = true, -- Gortok Palehoof
		[26693] = true, -- Skadi the Ruthless
		[26861] = true, -- King Ymiron
		
		-- Trial of the Champion: Alliance
		[35617] = true, -- Deathstalker Visceri <Grand Champion of Undercity>
		[35569] = true, -- Eressea Dawnsinger <Grand Champion of Silvermoon>
		[35572] = true, -- Mokra the Skullcrusher <Grand Champion of Orgrimmar>
		[35571] = true, -- Runok Wildmane <Grand Champion of the Thunder Bluff>
		[35570] = true, -- Zul'tore <Grand Champion of Sen'jin>
		
		-- Trial of the Champion: Horde
		[34702] = true, -- Ambrose Boltspark <Grand Champion of Gnomeregan>
		[34701] = true, -- Colosos <Grand Champion of the Exodar>
		[34705] = true, -- Marshal Jacob Alerius <Grand Champion of Stormwind>
		[34657] = true, -- Jaelyne Evensong <Grand Champion of Darnassus>
		[34703] = true, -- Lana Stouthammer <Grand Champion of Ironforge>
		
		-- Trial of the Champion: Neutral
		[34928] = true, -- Argent Confessor Paletress
		[35119] = true, -- Eadric the Pure
		[35451] = true, -- The Black Knight
		
		-- Forge of Souls
		[36497] = true, -- Bronjahm
		[36502] = true, -- Devourer of Souls
		
		-- Pit of Saron
		[36494] = true, -- Forgemaster Garfrost
		[36477] = true, -- Krick
		[36476] = true, -- Ick <Krick's Minion>
		[36658] = true, -- Scourgelord Tyrannus
		
		-- Halls of Reflection
		[38112] = true, -- Falric
		[38113] = true, -- Marwyn
		[37226] = true, -- The Lich King
		[38113] = true, -- Marvyn
		
		-- Obsidian Sanctum
		[30451] = true, -- Shadron
		[30452] = true, -- Tenebron
		[30449] = true, -- Vesperon
		[28860] = true, -- Sartharion
		
		-- Vault of Archavon
		[31125] = true, -- Archavon the Stone Watcher
		[33993] = true, -- Emalon the Storm Watcher
		[35013] = true, -- Koralon the Flamewatcher
		[38433] = true, --Toravon the Ice Watcher
		
		-- The Eye of Eternity
		[28859] = true, -- Malygos
		
		-- Ulduar: The Siege of Ulduar
		[33113] = true, -- Flame Leviathan
		[33118] = true, -- Ignis the Furnace Master
		[33186] = true, -- Razorscale
		[33293] = true, -- XT-002 Deconstructor
		[33670] = true, -- Aerial Command Unit
		[33329] = true, -- Heart of the Deconstructor
		[33651] = true, -- VX-001
		
		-- Ulduar: The Antechamber of Ulduar
		[32867] = true, -- Steelbreaker
		[32927] = true, -- Runemaster Molgeim
		[32857] = true, -- Stormcaller Brundir
		[32930] = true, -- Kologarn
		[33515] = true, -- Auriaya
		[34035] = true, -- Feral Defender
		[32933] = true, -- Left Arm
		[32934] = true, -- Right Arm
		[33524] = true, -- Saronite Animus
		
		-- Ulduar: The Keepers of Ulduar
		[33350] = true, -- Mimiron
		[32906] = true, -- Freya
		[32865] = true, -- Thorim
		[32845] = true, -- Hodir
		
		-- Ulduar: The Descent into Madness
		[33271] = true, -- General Vezax
		[33890] = true, -- Brain of Yogg-Saron
		[33136] = true, -- Guardian of Yogg-Saron
		[33288] = true, -- Yogg-Saron
		[32915] = true, -- Elder Brightleaf
		[32913] = true, -- Elder Ironbranch
		[32914] = true, -- Elder Stonebark
		[32882] = true, -- Jormungar Behemoth
		[33432] = true, -- Leviathan Mk II
		[34014] = true, -- Sanctum Sentry
		
		-- Ulduar: The Celestial Planetarium
		[32871] = true, -- Algalon the Observer
		
		-- Trial of the Crusader
		[34796] = true, -- Gormok
		[35144] = true, -- Acidmaw
		[34799] = true, -- Dreadscale
		[34797] = true, -- Icehowl
		
		[34780] = true, -- Jaraxxus
		
		[34461] = true, -- Tyrius Duskblade <Death Knight>
		[34460] = true, -- Kavina Grovesong <Druid>
		[34469] = true, -- Melador Valestrider <Druid>
		[34467] = true, -- Alyssia Moonstalker <Hunter>
		[34468] = true, -- Noozle Whizzlestick <Mage>
		[34465] = true, -- Velanaa <Paladin>
		[34471] = true, -- Baelnor Lightbearer <Paladin>
		[34466] = true, -- Anthar Forgemender <Priest>
		[34473] = true, -- Brienna Nightfell <Priest>
		[34472] = true, -- Irieth Shadowstep <Rogue>
		[34470] = true, -- Saamul <Shaman>
		[34463] = true, -- Shaabad <Shaman>
		[34474] = true, -- Serissa Grimdabbler <Warlock>
		[34475] = true, -- Shocuul <Warrior>
		
		[34458] = true, -- Gorgrim Shadowcleave <Death Knight>
		[34451] = true, -- Birana Stormhoof <Druid>
		[34459] = true, -- Erin Misthoof <Druid>
		[34448] = true, -- Ruj'kah <Hunter>
		[34449] = true, -- Ginselle Blightslinger <Mage>
		[34445] = true, -- Liandra Suncaller <Paladin>
		[34456] = true, -- Malithas Brightblade <Paladin>
		[34447] = true, -- Caiphus the Stern <Priest>
		[34441] = true, -- Vivienne Blackwhisper <Priest>
		[34454] = true, -- Maz'dinah <Rogue>
		[34444] = true, -- Thrakgar	<Shaman>
		[34455] = true, -- Broln Stouthorn <Shaman>
		[34450] = true, -- Harkzog <Warlock>
		[34453] = true, -- Narrhok Steelbreaker <Warrior>
		
		[35610] = true, -- Cat <Ruj'kah's Pet / Alyssia Moonstalker's Pet>
		[35465] = true, -- Zhaagrym <Harkzog's Minion / Serissa Grimdabbler's Minion>
		
		[34497] = true, -- Fjola Lightbane
		[34496] = true, -- Eydis Darkbane
		[34564] = true, -- Anub'arak (Trial of the Crusader)
		
		-- Icecrown Citadel
		[36612] = true, -- Lord Marrowgar
		[36855] = true, -- Lady Deathwhisper
		-- Gunship Battle
		[37813] = true, -- Deathbringer Saurfang
		[36626] = true, -- Festergut
		[36627] = true, -- Rotface
		[36678] = true, -- Professor Putricide
		[37972] = true, -- Prince Keleseth (Icecrown Citadel)
		[37970] = true, -- Prince Valanar
		[37973] = true, -- Prince Taldaram (Icecrown Citadel)
		[37955] = true, -- Queen Lana'thel
		[36789] = true, -- Valithria Dreamwalker
		[37950] = true, -- Valithria Dreamwalker (Phased)
		[37868] = true, -- Risen Archmage, Valitrhia Add
		[36791] = true, -- Blazing Skeleton, Valithria Add
		[37934] = true, -- Blistering Zombie, Valithria Add
		[37886] = true, -- Gluttonous Abomination, Valithria Add
		[37985] = true, -- Dream Cloud , Valithria "Add" 
		[36853] = true, -- Sindragosa
		[36597] = true, -- The Lich King (Icecrown Citadel)
		[37217] = true, -- Precious
		[37025] = true, -- Stinki
		[36661] = true, -- Rimefang <Drake of Tyrannus>
		
		--Ruby Sanctum (PTR 3.3.5)
		[39746] = true,	--Zarithrian
		[39747] = true, --Saviana
		[39751] = true, --Baltharus
		[39863] = true, -- Halion
		[39899] = true, -- Baltharus (Copy has an own id apparently)
		[40142] = true, -- Halion (twilight realm)

		-- World Dragons
		[14889] = true, -- Emeriss
		[14888] = true, -- Lethon
		[14890] = true, -- Taerar
		[14887] = true, -- Ysondre
		
		-- Azshara
		[14464] = true, -- Avalanchion
		[6109]  = true, -- Azuregos
		
		-- Un'Goro Crater
		[14461] = true, -- Baron Charr
		
		-- Silithus
		[15205] = true, -- Baron Kazum <Abyssal High Council>
		[15204] = true, -- High Marshal Whirlaxis <Abyssal High Council>
		[15305] = true, -- Lord Skwol <Abyssal High Council>
		[15203] = true, -- Prince Skaldrenox <Abyssal High Council>
		[14454] = true, -- The Windreaver
		
		-- Searing Gorge
		[9026]  = true, -- Overmaster Pyron
		
		-- Winterspring
		[14457] = true, -- Princess Tempestria
		
		-- Hellfire Peninsula
		[18728] = true, -- Doom Lord Kazzak
		[12397] = true, -- Lord Kazzak
		
		-- Shadowmoon Valley
		[17711] = true, -- Doomwalker
		
		-- Nagrand
		[18398] = true, -- Brokentoe
		[18069] = true, -- Mogor <Hero of the Warmaul>, friendly
		[18399] = true, -- Murkblood Twin
		[18400] = true, -- Rokdar the Sundered Lord
		[18401] = true, -- Skra'gath
		[18402] = true, -- Warmaul Champion

	}



	local function initialiseSavedVariables()

		tdps = {
			speed = 2,
			width = 180,
			version = -1,
			autoReset = true,
			swapColor = true,
			tooltipSpells = 3,
			tooltipTargets = 3,
			anchor = 'TOPLEFT',
			layout = 10,
			showRank = true,
			onlyBossSegments = false,
			showMinimapButton = false,
			maxBars = 10, spacing = 2, barHeight = 15,
			bar = {.9, .9, .9, 1}, barbackdrop = {1, 1, 1, .05}, border = {0, 0, 0, .8}, backdrop = {0, 0, 0, .8},
			font = {name = 'Interface\\AddOns\\TinyDPS\\Fonts\\Berlin Sans.ttf', size = 13, outline = 'Outline', shadow = 0},
			classColor = {}
		}

		for k,v in pairs(RAID_CLASS_COLORS) do -- copy global class colors
			tdps.classColor[k] = {}
			tdps.classColor[k].r = RAID_CLASS_COLORS[k].r
			tdps.classColor[k].g = RAID_CLASS_COLORS[k].g
			tdps.classColor[k].b = RAID_CLASS_COLORS[k].b
		end

		for k,v in pairs(tdps.classColor) do v.a = .8 end -- set all class colors to 80% opacity
		tdps.classColor['UNKNOWN'] = {r = .63, g = .58, b = .24, a = .8}

	end



	local function initialiseSavedVariablesPerCharacter()

		tdpsVersion = -1
		tdpsPet, tdpsPlayer, tdpsLink = {}, {}, {}
		tdpsFight = {{name = 'Overall Data', d = 0, h = 0}, {name = nil, boss = nil, d = 0, h = 0}}

		tdpsPartySize = 0
		tdpsSelectedFight = 1
		tdpsSelectedView = 'd'
		tdpsNumberOfFights = 2

	end



	initialiseSavedVariables()
	initialiseSavedVariablesPerCharacter()






---------------------------------------------------------------------------------------------------------------------------------
--- frames ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



	-- anchor frame
	CreateFrame('Frame', 'tdpsAnchor', UIParent)
	tdpsAnchor:SetWidth(5)
	tdpsAnchor:SetHeight(5)
	tdpsAnchor:SetMovable(1)
	tdpsAnchor:SetPoint('CENTER')
	tdpsAnchor:SetFrameStrata('BACKGROUND')
	tdpsAnchor:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = {left = 1, right = 1, top = 1, bottom = 1}})
	tdpsAnchor:SetBackdropColor(0,0,0,0)
	tdpsAnchor:SetBackdropBorderColor(0,0,0,0)



	-- main window
	CreateFrame('Frame', 'tdpsFrame', UIParent)
	tdpsFrame:SetWidth(tdps.width)
	tdpsFrame:SetHeight(tdps.barHeight+4)
	tdpsFrame:EnableMouse(1)
	tdpsFrame:EnableMouseWheel(1)
	tdpsFrame:SetResizable(1)
	tdpsFrame:SetPoint('TOPLEFT', tdpsAnchor, 'TOPLEFT')
	tdpsFrame:SetFrameStrata('MEDIUM')
	tdpsFrame:SetFrameLevel(1)
	tdpsFrame:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = {left = 1, right = 1, top = 1, bottom = 1}})



	-- main window animation
	local tdpsAnimationGroup = tdpsFrame:CreateAnimationGroup()   
	local tdpsAnimation = tdpsAnimationGroup:CreateAnimation('Alpha')
	tdpsAnimation:SetChange(-1)
	tdpsAnimation:SetDuration(.2)
	tdpsAnimation:SetScript('OnFinished', function(self, requested) tdpsRefresh() end)



	-- title font string
	tdpsFrame:CreateFontString('noData', 'OVERLAY')
	noData:SetPoint('CENTER', tdpsFrame, 'CENTER', 0, 1)
	noData:SetJustifyH('CENTER')
	noData:SetFont(tdps.font.name, tdps.font.size)
	noData:SetShadowColor(.1, .1, .1, 1)
	noData:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
	noData:SetTextColor(1, 1, 1, .07)
	noData:SetText('TinyDPS')
	


	-- resize frame
	CreateFrame('Frame', 'tdpsResizeFrame', tdpsFrame)
	tdpsResizeFrame:SetFrameStrata('MEDIUM')
	tdpsResizeFrame:SetFrameLevel(3)
	tdpsResizeFrame:SetWidth(6)
	tdpsResizeFrame:SetHeight(6)
	tdpsResizeFrame:SetPoint('BOTTOMRIGHT', tdpsFrame, 'BOTTOMRIGHT', 0, 0)
	tdpsResizeFrame:EnableMouse(1)
	tdpsResizeFrame:CreateTexture('tdpsResizeTexture')
	tdpsResizeTexture:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
	tdpsResizeTexture:SetTexCoord(.619, .760, .612, .762)
	tdpsResizeTexture:SetDesaturated(1)
	tdpsResizeTexture:SetAlpha(.2)
	tdpsResizeTexture:ClearAllPoints()
	tdpsResizeTexture:SetPoint('TOPLEFT', tdpsResizeFrame)
	tdpsResizeTexture:SetPoint('BOTTOMRIGHT', tdpsResizeFrame, 'BOTTOMRIGHT', 0, 0)
	


	-- minimap button frame
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



	-- local copy of global functions (faster)
	local toNum, GetTime, select, band = tonumber, GetTime, select, bit.band
	local floor, ceil, min, max, abs, random = math.floor, math.ceil, math.min, math.max, abs, random
	local t_sort, t_remove, t_insert = table.sort, table.remove, table.insert
	local pairs, ipairs, CreateFrame = pairs, ipairs, CreateFrame
	local GetNumRaidMembers, GetNumPartyMembers = GetNumRaidMembers, GetNumPartyMembers
	local find, sub, split, lower, len, fmt = strfind, strsub, strsplit, strlower, strlen, string.format
	local UnitName, UnitGUID, UnitClass = UnitName, UnitGUID, UnitClass
	local UnitIsPlayer, UnitCanCooperate, UnitAffectingCombat = UnitIsPlayer, UnitCanCooperate, UnitAffectingCombat



	-- random crap
	--local function round(num, idp) return floor(num * (10^(idp or 0)) + .5) / (10^(idp or 0)) end
	local function echo(str) print('|cfffef00fTinyDPS |cff82e2eb' .. (str or '')) end
	local function getClass(name) return select(2,UnitClass(name)) or 'UNKNOWN' end
	local function isPvpZone() if select(2,IsInInstance()) == 'pvp' or select(2,IsInInstance()) == 'arena' then return true end end



	local function report(channel, reportlength, destination)

		-- check whisper target
		if channel == 'WHISPER' and (not destination or not UnitIsPlayer(destination) or not UnitCanCooperate('player', destination)) then echo('Invalid or no target selected') return end

		-- make table for sorting
		local report = {}
		for k,v in pairs(tdpsPlayer) do
			local reportPlayer = {name = split('-', tdpsPlayer[k].name), n = tdpsPlayer[k].fight[tdpsSelectedFight][tdpsSelectedView], t = tdpsPlayer[k].fight[tdpsSelectedFight].t}
			local pet = tdpsPlayer[k]['pet']
			for i=1,#pet do
				-- add pet number
				reportPlayer.n = reportPlayer.n + tdpsPet[pet[i]].fight[tdpsSelectedFight][tdpsSelectedView]
				-- check time
				if tdpsPet[pet[i]].fight[tdpsSelectedFight].t > reportPlayer.t then reportPlayer.t = tdpsPet[pet[i]].fight[tdpsSelectedFight].t end
			end
			t_insert(report, reportPlayer)
		end
		t_sort(report, function(x,y) return x.n > y.n end)

		-- check if there is any data
		if not report[1] or report[1].n == 0 then echo('No data to report') return end

		-- output report title
		local title = {d = 'Damage Done for ', h = 'Healing Done for '}
		if tdpsSelectedFight == '2' then
			SendChatMessage(title[tdpsSelectedView] .. 'Last Fight', channel, nil, destination)
		else
			SendChatMessage(title[tdpsSelectedView] .. tdpsFight[tdpsSelectedFight].name, channel, nil, destination)
		end

		-- output the text lines
		for i=1,min(#report, reportlength) do
			if report[i].n > 0 then
				SendChatMessage(fmt('%i. %s    %i    %i%%    (%i)', i, report[i].name, report[i].n, report[i].n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, report[i].n/report[i].t), channel, nil, destination)
			end
		end

	end



	local function visibilityEvent()
		if tdpsFrame:IsVisible() then
			if (tdps.hidePvP and isPvpZone()) or (tdps.hideSolo and tdpsPartySize == 0) or (tdps.hideOOC and not UnitAffectingCombat('player')) then
				tdpsFrame:Hide()
			end
		else
			if not (tdps.hidePvP and isPvpZone()) and not (tdps.hideSolo and tdpsPartySize == 0) then
				if tdps.hideOOC and not UnitAffectingCombat('player') then return end
				tdpsFrame:Show()
			end
		end		
	end

	

	local function deleteSpellData()
		for _,v in pairs(tdpsPlayer) do
			for i=1,#v.fight do
				v.fight[i].ds, v.fight[i].hs = {}, {}
			end
		end
		for _,v in pairs(tdpsPet) do
			for i=1,#v.fight do
				v.fight[i].ds, v.fight[i].hs = {}, {}
			end
		end
		collectgarbage()
	end



	local fmtBar = { -- bits:   8 = dps    4 = percentage    2 = dmg    1 = short format    This means that 13 = 1101 = dps (short) and percentage
		[0]  = function(n, t) return '' end,
		[1]  = function(n, t) return '' end,
		[2]  = function(n, t) return fmt('%i', n) end,
		[3]  = function(n, t) return fmt('%.0fK', n/1000) end,
		[4]  = function(n, t) return fmt('%i%%', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100) end,
		[5]  = function(n, t) return fmt('%i%%', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100) end,
		[6]  = function(n, t) return fmt('%i%% %i', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t) end,
		[7]  = function(n, t) return fmt('%i%% %.0fK', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t/1000) end,
		[8]  = function(n, t) return fmt('%i', n/t) end,
		[9]  = function(n, t) return fmt('%.1fK', n/t/1000) end,
		[10] = function(n, t) return fmt('%i %i', n, n/t) end,
		[11] = function(n, t) return fmt('%.0fK %.1fK', n/1000, n/t/1000) end,
		[12] = function(n, t) return fmt('%i%% %i', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t) end,
		[13] = function(n, t) return fmt('%i%% %.1fK', n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t/1000) end,
		[14] = function(n, t) return fmt('%i %i%% %i', n, n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t) end,
		[15] = function(n, t) return fmt('%.0fK %i%% %.1fK', n/1000, n/tdpsFight[tdpsSelectedFight][tdpsSelectedView]*100, n/t/1000) end
	}



	function tdpsRefresh()

		maxValue, barsWithValue = 0, 0
		local n, t, h, p, g -- amount, time, height, pet, text, guid

		-- update all bar values
		for i=1,#bar do
			bar[i]:Hide()
			-- get numbers
			g = bar[i].guid    n, t, p = tdpsPlayer[g].fight[tdpsSelectedFight][tdpsSelectedView], tdpsPlayer[g].fight[tdpsSelectedFight].t, tdpsPlayer[g].pet
			for i=1,#p do n = n + tdpsPet[p[i]].fight[tdpsSelectedFight][tdpsSelectedView] if tdpsPet[p[i]].fight[tdpsSelectedFight].t > t then t = tdpsPet[p[i]].fight[tdpsSelectedFight].t end end
			-- update bar values
			if n > 0 then
				barsWithValue = barsWithValue + 1
				if n > maxValue then maxValue = n end
				bar[i].fontStringRight:SetText(fmtBar[tdps.layout](n, t))
				--setBarText[tdps.layout](i, n, t)
			end
			bar[i].n = n
		end

		-- sort all bars
		t_sort(bar, function(x,y) return x.n > y.n end)

		-- layout the bars
		px = -2
		if tdps.maxBars == 1 then
			for i=1,#bar do
				if bar[i].name == UnitName('player') and bar[i].n > 0 then
					bar[i]:SetMinMaxValues(0, maxValue)
					bar[i]:SetValue(bar[i].n)
					bar[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
					if tdps.showRank then bar[i].fontStringLeft:SetText(fmt('%i%s%s', i, '. ', bar[i].name)) else bar[i].fontStringLeft:SetText(bar[i].name) end
					px = px - tdps.barHeight - tdps.spacing
					bar[i]:Show()
				end
			end
		else
			for i=scrollPosition,min(barsWithValue,tdps.maxBars+scrollPosition-1) do
				bar[i]:SetMinMaxValues(0, maxValue)
				bar[i]:SetValue(bar[i].n)
				bar[i]:SetPoint('TOPLEFT', tdpsFrame, 'TOPLEFT', 2, px)
				if tdps.showRank then bar[i].fontStringLeft:SetText(fmt('%i%s%s', i, '. ', bar[i].name)) else bar[i].fontStringLeft:SetText(bar[i].name) end
				px = px - tdps.barHeight - tdps.spacing
				bar[i]:Show()
			end
		end

		-- set the frame height
		h = abs(px) + 2 - tdps.spacing
		if h < tdps.barHeight then tdpsFrame:SetHeight(tdps.barHeight+4) noData:Show() else tdpsFrame:SetHeight(h) noData:Hide() end

	end



	local function changeView(v) if tdpsSelectedView == v then return end tdpsSelectedView = v scrollPosition = 1 tdpsAnimationGroup:Play() end
	local function changeFight(f) if tdpsSelectedFight == f then return end CloseDropDownMenus() tdpsSelectedFight = f scrollPosition = 1 tdpsAnimationGroup:Play() end



	local function changeNumberOfFights()

		-- make or delete entries for global fight data
		while #tdpsFight > tdpsNumberOfFights do t_remove(tdpsFight) end
		while #tdpsFight < tdpsNumberOfFights do t_insert(tdpsFight, {name = nil, boss = nil, d = 0, h = 0}) end

		-- make or delete entries for combatants data
		for _,v in pairs(tdpsPlayer) do
			while #v.fight > tdpsNumberOfFights do t_remove(v.fight) end
			while #v.fight < tdpsNumberOfFights do t_insert(v.fight, {d = 0, ds = {}, h = 0, hs = {}, t = 0}) end
		end
		for _,v in pairs(tdpsPet) do
			while #v.fight > tdpsNumberOfFights do t_remove(v.fight) end
			while #v.fight < tdpsNumberOfFights do t_insert(v.fight, {d = 0, ds = {}, h = 0, hs = {}, t = 0}) end
		end

		-- adjust the current selected fight
		-- example: selected fight is 5; user disables fight history; we now have only 2 fights (overall and current); the new selected fight has to be 2
		while not tdpsFight[tdpsSelectedFight] do tdpsSelectedFight = tdpsSelectedFight - 1 end

		-- clean up memory
		collectgarbage()

	end



	local function changeSpacing(s) if s < 0 then tdps.spacing = 0 elseif s > 10 then tdps.spacing = 10 else tdps.spacing = s end tdpsRefresh() end
	local function changeMaxBars(v) tdps.maxBars = v scrollPosition = 1 tdpsRefresh() end
	local function changeBarHeight(h) if h < 2 then h = 2 elseif h > 40 then h = 40 end for i=1,#bar do bar[i]:SetHeight(h) end tdps.barHeight = h tdpsRefresh() end



	local function changeFont(name, size, outline, shadow)
		-- save parameters
		tdps.font.name = name
		if size < 4 then tdps.font.size = 4 elseif size > 30 then tdps.font.size = 30 else tdps.font.size = size end
		tdps.font.outline, tdps.font.shadow = outline, shadow
		-- set the font
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		noData:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
		for i=1,#bar do
			bar[i].fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
			bar[i].fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
			bar[i].fontStringLeft:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
			bar[i].fontStringRight:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
		end
	end



	local function changeBarColor()
		if tdps.swapColor then
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']].r, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].g, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].b, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].a)
				bar[i].fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			end
		else
			for i=1,#bar do
				bar[i]:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
				bar[i].fontStringLeft:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']].r, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].g, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].b, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].a)
				bar[i].fontStringRight:SetTextColor(tdps.classColor[tdpsPlayer[bar[i].guid]['class']].r, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].g, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].b, tdps.classColor[tdpsPlayer[bar[i].guid]['class']].a)
			end
		end
	end



	local function changeBarBackdropColor()
		for i=1,#bar do
			bar[i]:SetBackdropColor(tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4])
		end
	end



	local function newFight(target)

		tdpsNewFight = false
		if tdpsSelectedFight ~= 1 then scrollPosition = 1 end

		-- inserting a new table
		if tdpsFight[2].d + tdpsFight[2].h > 0 and ((tdps.onlyBossSegments and tdpsFight[2].boss) or not tdps.onlyBossSegments) then
			t_insert(tdpsFight, 2, {name = target, boss = false, d = 0, h = 0})
			t_remove(tdpsFight)
			for _,v in pairs(tdpsPlayer) do
				t_insert(v.fight, 2, {d = 0, ds = {}, h = 0, hs = {}, t = 0})
				t_remove(v.fight)
			end
			for _,v in pairs(tdpsPet) do
				t_insert(v.fight, 2, {d = 0, ds = {}, h = 0, hs = {}, t = 0})
				t_remove(v.fight)
			end

		-- resetting current fight
		else
			tdpsFight[2] = {name = target, boss = false, d = 0, h = 0}
			for _,v in pairs(tdpsPlayer) do
				v.fight[2] = {d = 0, ds = {}, h = 0, hs = {}, t = 0}
			end
			for _,v in pairs(tdpsPet) do
				v.fight[2] = {d = 0, ds = {}, h = 0, hs = {}, t = 0}
			end
		end

	end



	local function checkCombat()
		if tdpsNewFight then return end
		if UnitAffectingCombat('player') or UnitAffectingCombat('pet') then tdpsInCombat = true return end
		for i=1,GetNumRaidMembers() do
			if UnitAffectingCombat('raid'..i) or UnitAffectingCombat('raidpet'..i) then tdpsInCombat = true return end
		end
		for i=1,GetNumPartyMembers() do
			if UnitAffectingCombat('party'..i) or UnitAffectingCombat('partypet'..i) then tdpsInCombat = true return end
		end
		tdpsInCombat = false
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



	local function toggleMinimapButton()
		tdps.showMinimapButton = not tdps.showMinimapButton
		if tdps.showMinimapButton then tdpsRefresh() tdpsButtonFrame:Show() else tdpsButtonFrame:Hide() end
	end



	local function ver() echo('Version ' .. GetAddOnMetadata('TinyDPS', 'Version') .. ' by Sideshow (Draenor EU)') end
	local function help()
		ver()
		echo('Shift click to move, middle click to reset')
		echo('Mouse back/forward shows overall data/current fight')
		echo('Slash command: /tdps (this will toggle TinyDPS)')
		echo('Command options: /tpds [reset] [damage] [healing]')
	end



	local function reset()
		-- hide all bars
		for i=1,#bar do bar[i]:ClearAllPoints() bar[i]:Hide() end
		-- delete data
		tdpsPlayer, tdpsPet, tdpsLink, tdpsFight, bar = {}, {}, {}, {}, {}
		-- make new fight data
		t_insert(tdpsFight, {name = 'Overall Data', d = 0, h = 0})
		while #tdpsFight < tdpsNumberOfFights do t_insert(tdpsFight, 2, {name = nil, boss = false, d = 0, h = 0}) end
		-- reset scroll position
		scrollPosition = 1
		-- return to current fight if needed
		if tdpsSelectedFight > 2 then tdpsSelectedFight = 2 end
		-- reset the window
		tdpsFrame:SetHeight(tdps.barHeight+4)
		noData:Show()
		-- output message
		echo('All data has been reset')
	end



	SLASH_TINYDPS1, SLASH_TINYDPS2 = '/tinydps', '/tdps'
	function SlashCmdList.TINYDPS(msg, editbox)
		if lower(msg) == 'reset' then reset()
		elseif lower(msg) == 'help' or msg == '?' or msg == '/?' or msg == '-?' or lower(msg) == '/help' or lower(msg) == '-help' then help()
		--elseif lower(split(' ', msg)) == 'report' and select(2,split(' ', msg)) and select(3,split(' ', msg)) then report('CHANNEL', select(3,split(' ', msg)), select(2,split(' ', msg)))
		elseif lower(msg) == 'damage' then changeView('d')
		elseif lower(msg) == 'healing' then changeView('h')
		elseif msg == '' then
			if tdpsFrame:IsVisible() then tdpsFrame:Hide()
			else tdpsRefresh() tdpsFrame:Show() end
		end
	end



	local function scroll(d)
		if bar[1] and bar[1].n > 0 and scrollPosition - d > 0 and scrollPosition - d + tdps.maxBars <= barsWithValue + 1 and tdps.maxBars > 1 then
			scrollPosition = scrollPosition - d
			tdpsRefresh()
		end
	end



	local tdpsDropDown  = CreateFrame('Frame', 'tdpsDropDown', nil, 'UIDropDownMenuTemplate')
	local function tdpsMenu()
		tdpsMenuTable = {}
		tdpsMenuTable = {
			{ text = 'TinyDPS         ', isTitle = 1, notCheckable = 1 },
			{ text = 'Fight', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Overall      All Fights', checked = function() if tdpsSelectedFight == 1 then return true end end, func = function() changeFight(1) end },
					{ text = 'Current     ' .. (tdpsFight[2].name or '<Empty>'), checked = function() if tdpsSelectedFight == 2 then return true end end, func = function() changeFight(2) end },
					{ text = '', disabled = true, notCheckable = true },
					{ text = 'Show Damage', checked = function() if tdpsSelectedView == 'd' then return true end end, func = function() changeView('d') end },
					{ text = 'Show Healing', checked = function() if tdpsSelectedView == 'h' then return true end end, func = function() changeView('h') end },
					{ text = '', disabled = true, notCheckable = true },
					{ text = '     Reset All Data', notCheckable = true, func = function() reset() CloseDropDownMenus() end }
				}
			},
			{ text = 'Report', notCheckable = 1, hasArrow = true,
				menuList = {
					{ text = 'Top 3', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() report('SAY', 3) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() report('RAID', 3) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() report('PARTY', 3) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() report('GUILD', 3) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Officer', func = function() report('OFFICER', 3) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() report('WHISPER', 3, UnitName('target')) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Channel    ', notCheckable = 1, hasArrow = true, menuList = {} }
						}
					},
					{ text = 'Top 5', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() report('SAY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() report('RAID', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() report('PARTY', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() report('GUILD', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Officer', func = function() report('OFFICER', 5) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() report('WHISPER', 5, UnitName('target')) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Channel    ', notCheckable = 1, hasArrow = true, menuList = {} }
						}
					},
					{ text = 'Top 10    ', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Say', func = function() report('SAY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Raid', func = function() report('RAID', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Party', func = function() report('PARTY', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Guild', func = function() report('GUILD', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Officer', func = function() report('OFFICER', 10) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Whisper', func = function() report('WHISPER', 10, UnitName('target')) CloseDropDownMenus() end, notCheckable = 1 },
							{ text = 'Channel    ', notCheckable = 1, hasArrow = true, menuList = {} }
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
									{ text = 'Increase', func = function() changeFont(tdps.font.name, tdps.font.size + 1, tdps.font.outline, tdps.font.shadow) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeFont(tdps.font.name, tdps.font.size - 1, tdps.font.outline, tdps.font.shadow) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Font', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'Visitor', func = function() changeFont('Interface\\AddOns\\TinyDPS\\Fonts\\Visitor.ttf', tdps.font.size, tdps.font.outline, tdps.font.shadow) end, checked = function() if find(tdps.font.name, 'Visitor') then return true end end },
									{ text = 'Berlin Sans', func = function() changeFont('Interface\\AddOns\\TinyDPS\\Fonts\\Berlin Sans.ttf', tdps.font.size, tdps.font.outline, tdps.font.shadow) end, checked = function() if find(tdps.font.name, 'Berlin') then return true end end },
									{ text = 'Avant Garde', func = function() changeFont('Interface\\AddOns\\TinyDPS\\Fonts\\Avant Garde.ttf', tdps.font.size, tdps.font.outline, tdps.font.shadow) end, checked = function() if find(tdps.font.name, 'Avant') then return true end end },
									{ text = 'Franklin Gothic', func = function() changeFont('Interface\\AddOns\\TinyDPS\\Fonts\\Franklin Gothic.ttf', tdps.font.size, tdps.font.outline, tdps.font.shadow) end, checked = function() if find(tdps.font.name, 'Franklin') then return true end end }
								}
							},
							{ text = 'Layout', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'DPS', isNotRadio = true, func = function() if band(tdps.layout,8) > 0 then tdps.layout = tdps.layout - 8 else tdps.layout = tdps.layout + 8 end tdpsRefresh() end, checked = function() if band(tdps.layout,8) > 0 then return true end end, keepShownOnClick = 1 },
									{ text = 'Rank', isNotRadio = true, func = function() tdps.showRank = not tdps.showRank tdpsRefresh() end, checked = function() return tdps.showRank end, keepShownOnClick = 1 },
									{ text = 'Percent', isNotRadio = true, func = function() if band(tdps.layout,4) > 0 then tdps.layout = tdps.layout - 4 else tdps.layout = tdps.layout + 4 end tdpsRefresh() end, checked = function() if band(tdps.layout,4) > 0 then return true end end, keepShownOnClick = 1 },
									{ text = 'Amount', isNotRadio = true, func = function() if band(tdps.layout,2) > 0 then tdps.layout = tdps.layout - 2 else tdps.layout = tdps.layout + 2 end tdpsRefresh() end, checked = function() if band(tdps.layout,2) > 0 then return true end end, keepShownOnClick = 1 },
									{ text = 'Short Format', isNotRadio = true, func = function() if band(tdps.layout,1) > 0 then tdps.layout = tdps.layout - 1 else tdps.layout = tdps.layout + 1 end tdpsRefresh() end, checked = function() if band(tdps.layout,1) > 0 then return true end end, keepShownOnClick = 1 }
								}
							},
							{ text = 'Outline    ', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'None', isNotRadio = true, func = function() changeFont(tdps.font.name, tdps.font.size, '', 0) end, checked = function() if tdps.font.outline == '' and tdps.font.shadow == 0 then return true end end },
									{ text = 'Thin', isNotRadio = true, func = function() changeFont(tdps.font.name, tdps.font.size, 'Outline', 0) end, checked = function() if tdps.font.outline == 'Outline' and tdps.font.shadow == 0 then return true end end },
									{ text = 'Thick', isNotRadio = true, func = function() changeFont(tdps.font.name, tdps.font.size, 'Thickoutline', 0) end, checked = function() if tdps.font.outline == 'Thickoutline' and tdps.font.shadow == 0 then return true end end },
									{ text = 'Shadow', isNotRadio = true, func = function() changeFont(tdps.font.name, tdps.font.size, '', 1) end, checked = function() if tdps.font.outline == '' and tdps.font.shadow == 1 then return true end end },
									{ text = 'Monochrome', isNotRadio = true, func = function() changeFont(tdps.font.name, tdps.font.size, 'Outlinemonochrome', 0) end, checked = function() if tdps.font.outline == 'Outlinemonochrome' and tdps.font.shadow == 0 then return true end end }
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
									{ text = 'Increase', func = function() changeSpacing(tdps.spacing+1) end, notCheckable = 1, keepShownOnClick = 1 },
									{ text = 'Decrease', func = function() changeSpacing(tdps.spacing-1) end, notCheckable = 1, keepShownOnClick = 1 }
								}
							},
							{ text = 'Maximum    ', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = '1 (Yourself)', isNotRadio = true, func = function() changeMaxBars(1) end, checked = function() if tdps.maxBars == 1 then return true end end },
									{ text = '5', isNotRadio = true, func = function() changeMaxBars(5) end, checked = function() if tdps.maxBars == 5 then return true end end },
									{ text = '10', isNotRadio = true, func = function() changeMaxBars(10) end, checked = function() if tdps.maxBars == 10 then return true end end },
									{ text = '15', isNotRadio = true, func = function() changeMaxBars(15) end, checked = function() if tdps.maxBars == 15 then return true end end },
									{ text = '20', isNotRadio = true, func = function() changeMaxBars(20) end, checked = function() if tdps.maxBars == 20 then return true end end },
									{ text = '? (Unlimited)', isNotRadio = true, func = function() changeMaxBars(99) end, checked = function() if tdps.maxBars == 99 then return true end end }
								}
							}
						}
					},
					{ text = 'Colors', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Bars', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									changeBarColor()
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4] = red, green, blue, alpha
									changeBarColor()
								end,
								r = tdps.bar[1], g = tdps.bar[2], b = tdps.bar[3], opacity = 1 - tdps.bar[4],
								notCheckable = 1
							},
							{ text = 'Bar Backdrop', notClickable = 1,
								hasColorSwatch = true,
								swatchFunc = function()
									ColorPickerOkayButton:Hide()
									ColorPickerCancelButton:SetText('Close')
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4] = red, green, blue, alpha
									changeBarBackdropColor()
								end,
								hasOpacity = true,
								opacityFunc = function()
									local red, green, blue = ColorPickerFrame:GetColorRGB()
									local alpha = 1 - OpacitySliderFrame:GetValue()
									tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4] = red, green, blue, alpha
									changeBarBackdropColor()
								end,
								r = tdps.barbackdrop[1], g = tdps.barbackdrop[2], b = tdps.barbackdrop[3], opacity = 1 - tdps.barbackdrop[4],
								notCheckable = 1
							},
							{ text = 'Frame Border', notClickable = 1,
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
							{ text = 'Frame Backdrop        ', notClickable = 1,
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
							{ text = 'Dim Class Colors', notCheckable = 1, func = function() for _,v in pairs(tdps.classColor) do if v.a-.1 < 0 then v.a = 0 else v.a = v.a-.1 end end changeBarColor() end, keepShownOnClick = 1 },
							{ text = 'Reset Class Colors', notCheckable = 1, func = function() tdps.classColor = RAID_CLASS_COLORS for k,v in pairs(tdps.classColor) do v.a = 1 end tdps.classColor['UNKNOWN'] = {r = .63, g = .58, b = .24, a = 1} changeBarColor() end, keepShownOnClick = 1 },
							{ text = 'Swap Bar/Text Color', notCheckable = 1,
								func = function()
									tdps.swapColor = not tdps.swapColor
									if tdps.swapColor then
										tdpsMenuTable[4]['menuList'][3]['menuList'][1].text = 'Text'
										DropDownList3Button1:SetText('Text')
									else
										tdpsMenuTable[4]['menuList'][3]['menuList'][1].text = 'Bars'
										DropDownList3Button1:SetText('Bars')
									end
									changeBarColor()
								end,
								keepShownOnClick = 1
							}
						}
					},
					{ text = 'History', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Disabled', func = function() tdpsNumberOfFights = 2 changeNumberOfFights() CloseDropDownMenus() end, checked = function() if tdpsNumberOfFights == 2 then return true end end },
							{ text = '3 fights', func = function() tdpsNumberOfFights = 5 changeNumberOfFights() CloseDropDownMenus() end, checked = function() if tdpsNumberOfFights == 5 then return true end end },
							{ text = '5 fights', func = function() tdpsNumberOfFights = 7 changeNumberOfFights() CloseDropDownMenus() end, checked = function() if tdpsNumberOfFights == 7 then return true end end },
							{ text = '9 fights', func = function() tdpsNumberOfFights = 11 changeNumberOfFights() CloseDropDownMenus() end, checked = function() if tdpsNumberOfFights == 11 then return true end end }
						}
					},
					{ text = 'Toggles', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = 'Hide In PvP', isNotRadio = true, func = function() tdps.hidePvP = not tdps.hidePvP visibilityEvent() end, checked = function() return tdps.hidePvP end, keepShownOnClick = 1 },
							{ text = 'Hide When Solo', isNotRadio = true, func = function() tdps.hideSolo = not tdps.hideSolo visibilityEvent() end, checked = function() return tdps.hideSolo end, keepShownOnClick = 1 },
							{ text = 'Hide Out Of Combat', isNotRadio = true, func = function() tdps.hideOOC = not tdps.hideOOC visibilityEvent() end, checked = function() return tdps.hideOOC end, keepShownOnClick = 1 },
							{ text = '', disabled = true, notCheckable = true },
							{ text = 'Grow Upwards', isNotRadio = true, func = function() if tdps.anchor == 'TOPLEFT' then tdps.anchor = 'BOTTOMLEFT' else tdps.anchor = 'TOPLEFT' end tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor) end,  checked = function() if tdps.anchor == 'BOTTOMLEFT' then return true end end, keepShownOnClick = 1 },
							{ text = 'Minimap Button', isNotRadio = true, func = function() toggleMinimapButton() end, checked = function() return tdps.showMinimapButton end, keepShownOnClick = 1 },
							{ text = 'Track Spell Details', isNotRadio = true, func = function() tdps.trackSpells = not tdps.trackSpells if not tdps.trackSpells then deleteSpellData() end end, checked = function() return tdps.trackSpells end, keepShownOnClick = 1 },
							{ text = 'Reset On New Group', isNotRadio = true, func = function() tdps.autoReset = not tdps.autoReset end, checked = function() return tdps.autoReset end, keepShownOnClick = 1 },
							{ text = 'Refresh Every Second', isNotRadio = true, func = function() if tdps.speed == 2 then tdps.speed = 1 else tdps.speed = 2 end end, checked = function() if tdps.speed == 1 then return true end end, keepShownOnClick = 1 },
							{ text = 'Keep Only Boss Fights', isNotRadio = true, func = function() tdps.onlyBossSegments = not tdps.onlyBossSegments end, checked = function() return tdps.onlyBossSegments end, keepShownOnClick = 1 }
						}
					},
					{ text = 'Tooltips    ', notCheckable = 1, hasArrow = true,
						menuList = {
							{ text = tdps.tooltipSpells .. ' Spells', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'More',
										func = function()
											tdps.tooltipSpells = min(10, tdps.tooltipSpells + 1)
											DropDownList3Button1:SetText(tdps.tooltipSpells .. ' Spells')
											tdpsMenuTable[4]['menuList'][6]['menuList'][1].text = tdps.tooltipSpells .. ' Spells'
										end,
										notCheckable = 1,
										keepShownOnClick = 1
									},
									{ text = 'Less',
										func = function()
											tdps.tooltipSpells = max(0, tdps.tooltipSpells - 1)
											DropDownList3Button1:SetText(tdps.tooltipSpells .. ' Spells')
											tdpsMenuTable[4]['menuList'][6]['menuList'][1].text = tdps.tooltipSpells .. ' Spells'
										end,
										notCheckable = 1,
										keepShownOnClick = 1
									}
								}
							},
							{ text = tdps.tooltipTargets .. ' Targets    ', notCheckable = 1, hasArrow = true,
								menuList = {
									{ text = 'More',
										func = function()
											tdps.tooltipTargets = min(10, tdps.tooltipTargets + 1)
											DropDownList3Button2:SetText(tdps.tooltipTargets .. ' Targets    ')
											tdpsMenuTable[4]['menuList'][6]['menuList'][2].text = tdps.tooltipTargets .. ' Targets    '
										end,
										notCheckable = 1,
										keepShownOnClick = 1
									},
									{ text = 'Less',
										func = function()
											tdps.tooltipTargets = max(0, tdps.tooltipTargets - 1)
											DropDownList3Button2:SetText(tdps.tooltipTargets .. ' Targets    ')
											tdpsMenuTable[4]['menuList'][6]['menuList'][2].text = tdps.tooltipTargets .. ' Targets    '
										end,
										notCheckable = 1,
										keepShownOnClick = 1
									}
								}
							}
						}
					}
				}
			},
			{ text = 'Cancel', func = function() CloseDropDownMenus() end, notCheckable = 1 }
		}
		-- add fights to menu
		if tdpsNumberOfFights > 2 then
			t_insert(tdpsMenuTable[2]['menuList'], 3, { text = '', disabled = true, notCheckable = true })
		end
		for i=3,tdpsNumberOfFights do
			t_insert(tdpsMenuTable[2]['menuList'], i+1, { text = fmt('%s %i      %s', 'Fight', i-2, (tdpsFight[i].name or '<Empty>')), checked = function() if tdpsSelectedFight == (i) then return true end end, func = function() changeFight(i) end })
		end
		-- add channels to menu
		for i=1,20 do
			if select(2,GetChannelName(i)) then
				t_insert(tdpsMenuTable[3]['menuList'][1]['menuList'][7]['menuList'], {text = split(' ',select(2,GetChannelName(i))), func = function() report('CHANNEL', 3, i) CloseDropDownMenus() end, notCheckable = 1})
				t_insert(tdpsMenuTable[3]['menuList'][2]['menuList'][7]['menuList'], {text = split(' ',select(2,GetChannelName(i))), func = function() report('CHANNEL', 5, i) CloseDropDownMenus() end, notCheckable = 1})
				t_insert(tdpsMenuTable[3]['menuList'][3]['menuList'][7]['menuList'], {text = split(' ',select(2,GetChannelName(i))), func = function() report('CHANNEL', 10, i) CloseDropDownMenus() end, notCheckable = 1})
			end
		end
		-- adjust text string
		if tdps.swapColor then
			tdpsMenuTable[4]['menuList'][3]['menuList'][1].text = 'Text'
		else
			tdpsMenuTable[4]['menuList'][3]['menuList'][1].text = 'Bars'
		end
	end



	local function newBar(g)
		local dummybar = CreateFrame('Statusbar', 'tdpsStatusBar', tdpsFrame)
		dummybar:SetFrameStrata('MEDIUM')
		dummybar:SetFrameLevel(2)
		dummybar:SetOrientation('HORIZONTAL')
		dummybar:EnableMouse(1)
		dummybar:EnableMouseWheel(1)
		dummybar:SetWidth((tdps.width or 200) - 4)
		dummybar:SetHeight(tdps.barHeight)
		dummybar:Hide()
		dummybar:SetPoint('RIGHT', tdpsFrame, 'RIGHT', -2, 0)
		dummybar:SetBackdrop({bgFile = 'Interface\\AddOns\\TinyDPS\\Textures\\wglass.tga', edgeFile = 'Interface\\AddOns\\TinyDPS\\Textures\\blank.tga', tile = false, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
		dummybar:SetStatusBarTexture('Interface\\AddOns\\TinyDPS\\Textures\\wglass.tga')
		-- hidden info
		dummybar.name, dummybar.guid, dummybar.n = split('-', tdpsPlayer[g]['name']), g, 0
		-- scripts
		dummybar:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(dummybar)
			GameTooltip:SetText(tdpsPlayer[g]['name'])
			local f, v = tdpsSelectedFight, tdpsSelectedView
			-- tooltip title
			local title = {d = 'Damage', h = 'Healing'}
			if f == 2 then GameTooltip:AddLine(fmt('%s for %s', title[v], 'Current Fight'), 1, .85, 0)
			else GameTooltip:AddLine(fmt('%s for %s', title[v], tdpsFight[f].name), 1, .85, 0) end
			-- personal number
			GameTooltip:AddDoubleLine('Personal', fmt('%i (%i%%)', tdpsPlayer[self.guid].fight[f][v], tdpsPlayer[self.guid].fight[f][v]/(self.n)*100), 1, 1, 1, 1, 1, 1)
			-- pet number
			local pet, petAmount = tdpsPlayer[g]['pet'], 0
			for i=1,#pet do petAmount = petAmount + tdpsPet[pet[i]].fight[f][v] end
			if petAmount > 0 then GameTooltip:AddDoubleLine('By Pet(s)', fmt('%i (%i%%)', petAmount, petAmount/(self.n)*100), 1, 1, 1, 1, 1, 1) end
			-- spell details
			if tdps.trackSpells then
				-- merge the data of this player
				local mergedSpells, mergedMobs = {}, {}
				for k,v in pairs(tdpsPlayer[g].fight[f][v..'s']) do for kk,vv in pairs(v) do mergedSpells[k] = (mergedSpells[k] or 0) + vv mergedMobs[kk] = (mergedMobs[kk] or 0) + vv end end
				for i=1,#pet do for k,v in pairs(tdpsPet[pet[i]].fight[f][v..'s']) do for kk,vv in pairs(v) do mergedSpells[k] = (mergedSpells[k] or 0) + vv mergedMobs[kk] = (mergedMobs[kk] or 0) + vv end end end
				-- display spells
				if tdps.tooltipSpells > 0 then GameTooltip:AddLine('Top Abilities', 1, .85, 0) end
				local top = {} for k,v in pairs(mergedSpells) do top[#(top)+1] = {k,v} end
				t_sort(top,function(x,y) return x[2] > y[2] end)
				for i=1,tdps.tooltipSpells do if top[i] then GameTooltip:AddDoubleLine(fmt('%i. %s', i, top[i][1]), fmt('%i (%i%%)', top[i][2], top[i][2]/(self.n)*100), 1, 1, 1, 1, 1, 1) end end
				-- display targets
				if tdps.tooltipTargets > 0 then GameTooltip:AddLine('Top Targets', 1, .85, 0) end
				local top = {} for k,v in pairs(mergedMobs) do top[#(top)+1] = {k,v} end
				t_sort(top,function(x,y) return x[2] > y[2] end)
				for i=1,tdps.tooltipTargets do if top[i] then GameTooltip:AddDoubleLine(fmt('%i. %s', i, top[i][1]), fmt('%i (%i%%)', top[i][2], top[i][2]/(self.n)*100), 1, 1, 1, 1, 1, 1) end end
			end
			GameTooltip:Show()
		end)
		dummybar:SetScript('OnLeave', function(self) GameTooltip:Hide() end)
		dummybar:SetScript('OnMouseDown', function(self, button)
			if button == 'LeftButton' and IsShiftKeyDown() then GameTooltip:Hide() CloseDropDownMenus() isMovingOrSizing = true tdpsAnchor:StartMoving()
			elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') PlaySound('gsTitleOptionExit')
			elseif button == 'MiddleButton' then reset()
			elseif button == 'Button4' then changeFight(1)
			elseif button == 'Button5' then changeFight(2) end
		end)
		dummybar:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then
				tdpsAnchor:StopMovingOrSizing()
				isMovingOrSizing = nil
				tdpsFrame:ClearAllPoints()
				-- set position of frame
				tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)
				-- save position of anchor
				local point, relativeTo, relativePoint,  xOffset, yOffset = tdpsAnchor:GetPoint(1)
				tdpsAnchorPosition = {point, relativeTo, relativePoint,  xOffset, yOffset}
			end
		end)
		dummybar:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)
		-- numbers fontstring
		dummybar.fontStringRight = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.fontStringRight:SetPoint('RIGHT', -1, 1)
		dummybar.fontStringRight:SetJustifyH('RIGHT')
		dummybar.fontStringRight:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		dummybar.fontStringRight:SetShadowColor(.05, .05, .05, 1)
		dummybar.fontStringRight:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
		-- name fontstring
		dummybar.fontStringLeft = dummybar:CreateFontString(nil, 'OVERLAY')
		dummybar.fontStringLeft:SetPoint('LEFT', 1, 1)
		dummybar.fontStringLeft:SetPoint('RIGHT', dummybar.fontStringRight, 'LEFT', -2, 1)
		dummybar.fontStringLeft:SetJustifyH('LEFT')
		dummybar.fontStringLeft:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		dummybar.fontStringLeft:SetShadowColor(.05, .05, .05, 1)
		dummybar.fontStringLeft:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
		-- colors
		local classR, classG, classB, classA = tdps.classColor[tdpsPlayer[g]['class']].r, tdps.classColor[tdpsPlayer[g]['class']].g, tdps.classColor[tdpsPlayer[g]['class']].b, tdps.classColor[tdpsPlayer[g]['class']].a
		if tdps.swapColor then
			dummybar:SetStatusBarColor(classR, classG, classB, classA)
			dummybar.fontStringRight:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.fontStringLeft:SetTextColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
		else
			dummybar:SetStatusBarColor(tdps.bar[1], tdps.bar[2], tdps.bar[3], tdps.bar[4])
			dummybar.fontStringRight:SetTextColor(classR, classG, classB, classA)
			dummybar.fontStringLeft:SetTextColor(classR, classG, classB, classA)
		end
		dummybar:SetBackdropColor(tdps.barbackdrop[1], tdps.barbackdrop[2], tdps.barbackdrop[3], tdps.barbackdrop[4])
		dummybar:SetBackdropBorderColor(0, 0, 0, 0)
		-- save bar
		t_insert(bar, dummybar)
	end



	local function makeCombatant(k, n, pgl, c)
		if c == 'PET' then
			tdpsPet[k] = {name = n, guid = pgl, class = c, stamp = 0, fight = {}}
			while #tdpsPet[k].fight < tdpsNumberOfFights do t_insert(tdpsPet[k].fight, {d = 0, ds = {}, h = 0, hs = {}, t = 0}) end
		else
			tdpsPlayer[k] = {name = n, pet = pgl, class = c, stamp = 0, fight = {}}
			while #tdpsPlayer[k].fight < tdpsNumberOfFights do t_insert(tdpsPlayer[k].fight, {d = 0, ds = {}, h = 0, hs = {}, t = 0}) end
		end
	end



	local function trackSpell(amount, target, spell, dh)
		if tdps.trackSpells then
			local t = dh .. 's'
			if not com.fight[1][t][spell] then com.fight[1][t][spell] = {} end -- make the spell
			if not com.fight[2][t][spell] then com.fight[2][t][spell] = {} end
			com.fight[1][t][spell][target] = (com.fight[1][t][spell][target] or 0) + amount -- record the amount
			com.fight[2][t][spell][target] = (com.fight[2][t][spell][target] or 0) + amount
		end
	end






---------------------------------------------------------------------------------------------------------------------------------
--- combat event handler --------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



	local function tdpsCombatEvent(self, event, ...)
	
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...
		
		-- check combat when outsider starts attacking an insider
		if isNewFightEvent[arg2] and arg5%8==0 and arg8%8~=0 then tdpsInCombat = true end
		
		-- boss check on kill
		if arg2 == 'PARTY_KILL' and not tdpsFight[2].boss then tdpsFight[2].name = arg7 tdpsFight[2].boss = isBoss[toNum(arg6:sub(7, 10), 16)] end

		-- absorbs
		if arg2 == 'SPELL_AURA_APPLIED' and isAbsorb[arg9] and arg5%8~=0 and arg8%8~=0 then tdpsShield[arg3..arg9..arg6] = arg13 return end
		if arg2 == 'SPELL_AURA_REMOVED' and isAbsorb[arg9] and arg5%8~=0 and arg8%8~=0 then tdpsShield[arg3..arg9..arg6] = nil return end
		if arg2 == 'SPELL_AURA_REFRESH' and isAbsorb[arg9] and arg5%8~=0 and arg8%8~=0 and tdpsShield[arg3..arg9..arg6] then
			if arg13 < tdpsShield[arg3..arg9..arg6] then
				tdpsCombatEvent(self, event, arg1, 'SPELL_HEAL', arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, tdpsShield[arg3..arg9..arg6] - arg13, 0, 0, 0)
			end
			tdpsShield[arg3..arg9..arg6] = arg13 return
		end

		-- filter
		if	arg5%8 == 0 -- source is outsider
			or not isValidEvent[arg2] -- invalid event
			or arg3 == '0x0000000000000000' -- environmental
			or sub(arg3,5,5) == '5' -- vehicular stuff
			or (band(arg8,16) > 0 and isDamage[arg2]) -- friendly fire
			or (band(arg8,16) == 0 and isHeal[arg2]) -- hostile healing
			or arg12 == 'EVADE' then -- evaded
			return
		end

		-- create summoned pets
		if arg2 == 'SPELL_SUMMON' then
			if UnitIsPlayer(arg4) and not isExcludedPet[toNum(arg6:sub(7, 10), 16)] then -- add pet when player summons
				-- make owner if necessary
				if not tdpsPlayer[arg3] then
					makeCombatant(arg3, arg4, {arg4..': '..arg7}, getClass(arg4))
					newBar(arg3)
				end
				-- make pointer
				tdpsLink[arg6] = arg4..': '..arg7
				-- make pet if it does not exist yet
				if not tdpsPet[arg4..': '..arg7] then makeCombatant(arg4..': '..arg7, arg7, arg6, 'PET') end
				-- add pet to owner if it's not there yet
				local found = nil for i=1,#tdpsPlayer[arg3]['pet'] do if tdpsPlayer[arg3]['pet'][i] == arg4..': '..arg7 then found = true break end end
				if not found then t_insert(tdpsPlayer[arg3]['pet'], arg4..': '..arg7) end
			elseif tdpsLink[arg3] then -- the summoner is also a pet (example: totem summons greater fire elemental)
				 -- ownername of owner
				local oo = split(':', tdpsLink[arg3])
				-- make pointer
				tdpsLink[arg6] = oo..': '..arg7
				-- make pet
				makeCombatant(oo..': '..arg7, arg7, arg6, 'PET')
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[UnitGUID(oo)]['pet'] do if tdpsPlayer[UnitGUID(oo)]['pet'][i] == oo..': '..arg7 then found = true break end end
				if not found then t_insert(tdpsPlayer[UnitGUID(oo)]['pet'], oo..': '..arg7) end
			end
			return
		end

		-- create player or a pet
		if not tdpsPlayer[arg3] and not tdpsLink[arg3] then
			if UnitIsPlayer(arg4) then
				makeCombatant(arg3, arg4, {}, getClass(arg4))
				newBar(arg3)
			elseif isPartyPet(arg3) then
				-- get owner
				local oGuid, oName = getPetOwnerGUID(arg3), getPetOwnerName(arg3)
				-- make owner if it does not exist yet
				if not tdpsPlayer[oGuid] then
					makeCombatant(oGuid, oName, {oName..': '..arg4}, getClass(oName))
					newBar(oGuid)
				end
				-- make pointer
				tdpsLink[arg3] = oName .. ': ' .. arg4
				-- make pet if it does not exist yet
				if not tdpsPet[oName..': '..arg4] then
					makeCombatant(oName..': '..arg4, arg4, arg3, 'PET')
				end
				-- add pet to owner if it's not there yet
				local found = nil
				for i=1,#tdpsPlayer[oGuid]['pet'] do if tdpsPlayer[oGuid]['pet'][i] == oName..': '.. arg4 then found = true break end end
				if not found then t_insert(tdpsPlayer[oGuid]['pet'], oName..': '.. arg4) end
			else
				return			
			end
		end

		-- select combatant
		if tdpsPlayer[arg3] then com = tdpsPlayer[arg3]
		elseif tdpsPet[tdpsLink[arg3]] then com = tdpsPet[tdpsLink[arg3]]
		else com = nil return end

		-- track numbers
		if isMissed[arg2] then
			tdpsInCombat = true
			if tdpsNewFight then newFight(arg7) end
		elseif isDamage[arg2] then
			tdpsInCombat = true
			if tdpsNewFight then newFight(arg7) end
			if arg2 == 'SWING_DAMAGE' then arg = arg9 trackSpell(arg, arg7, 'Melee', 'd') else arg = arg12 trackSpell(arg, arg7, arg10, 'd') end
			tdpsFight[1].d, tdpsFight[2].d = tdpsFight[1].d + arg, tdpsFight[2].d + arg
			com.fight[1].d, com.fight[2].d = com.fight[1].d + arg, com.fight[2].d + arg
		elseif isHeal[arg2] then
			arg = arg12 - arg13 -- effective healing
			if arg < 1 or not tdpsInCombat then return end -- quit on complete overheal or out of combat
			if tdpsNewFight then newFight(arg4) end
			trackSpell(arg, arg7, arg10, 'h')
			tdpsFight[1].h, tdpsFight[2].h = tdpsFight[1].h + arg, tdpsFight[2].h + arg
			com.fight[1].h, com.fight[2].h = com.fight[1].h + arg, com.fight[2].h + arg
		end

		-- add combat time
		arg = arg1 - com.stamp
		if arg < 3.5 then com.fight[1].t = com.fight[1].t + arg else com.fight[1].t = com.fight[1].t + 3.5 end
		if arg < 3.5 then com.fight[2].t = com.fight[2].t + arg else com.fight[2].t = com.fight[2].t + 3.5 end

		-- save time stamp
		com.stamp, lastStamp = arg1, GetTime()

		-- set onupdate
		if not tdpsAnchor:GetScript('OnUpdate') then tdpsAnchor:SetScript('OnUpdate', tdpsOnUpdate) end

	end






---------------------------------------------------------------------------------------------------------------------------------
--- scripts ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



	tdpsFrame:RegisterEvent('ADDON_LOADED')



	tdpsFrame:SetScript('OnEvent', function(self, event)

		-- global version mismatch
		if GetAddOnMetadata('TinyDPS', 'Version') ~= tdps.version then -- and '0.86' ~= tdps.version
			initialiseSavedVariables()
			echo('Global variables have been reset to version ' .. GetAddOnMetadata('TinyDPS', 'Version'))
			tdps.version = GetAddOnMetadata('TinyDPS', 'Version') -- save new version
		end

		-- character version mismatch
		if GetAddOnMetadata('TinyDPS', 'Version') ~= tdpsVersion then
			initialiseSavedVariablesPerCharacter()
			echo('Character variables have been reset to version ' .. GetAddOnMetadata('TinyDPS', 'Version'))
			tdpsFrame:SetHeight(tdps.barHeight + 4)
			tdpsVersion = GetAddOnMetadata('TinyDPS', 'Version') -- save new version
		end

		-- set position of anchor
		if tdpsAnchorPosition then
			tdpsAnchor:ClearAllPoints()
			tdpsAnchor:SetPoint(tdpsAnchorPosition[1], tdpsAnchorPosition[2], tdpsAnchorPosition[3], tdpsAnchorPosition[4], tdpsAnchorPosition[5])
		end

		-- remake bars if any
		for k,_ in pairs(tdpsPlayer) do newBar(k) end

		-- set font and colors
		noData:SetFont(tdps.font.name, tdps.font.size, tdps.font.outline)
		noData:SetShadowOffset(tdps.font.shadow, tdps.font.shadow * -1)
		tdpsFrame:SetBackdropBorderColor(tdps.border[1], tdps.border[2], tdps.border[3], tdps.border[4])
		tdpsFrame:SetBackdropColor(tdps.backdrop[1], tdps.backdrop[2], tdps.backdrop[3], tdps.backdrop[4])

		-- hide when necessary
		visibilityEvent()

		-- set position of frame
		tdpsFrame:ClearAllPoints() tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)

		-- minimap button
		if tdps.showMinimapButton then tdpsButtonFrame:Show() else tdpsButtonFrame:Hide() end

		-- reset events
		tdpsFrame:UnregisterEvent('ADDON_LOADED')
		tdpsFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		tdpsFrame:SetScript('OnEvent', tdpsCombatEvent)

	end)



	tdpsAnchor:RegisterEvent('PLAYER_REGEN_ENABLED')
	tdpsAnchor:RegisterEvent('PLAYER_REGEN_DISABLED')
	tdpsAnchor:RegisterEvent('PARTY_MEMBERS_CHANGED')
	tdpsAnchor:RegisterEvent('PLAYER_ENTERING_WORLD')



	tdpsAnchor:SetScript('OnEvent', function(self, event, ...)
		visibilityEvent()
		if event == 'PARTY_MEMBERS_CHANGED' then
			if tdps.autoReset and tdpsPartySize == 0 and max(GetNumPartyMembers(), GetNumRaidMembers()) > 0 then reset() end
			tdpsPartySize = max(GetNumPartyMembers(), GetNumRaidMembers())
		end
	end)



	local delay = 0
	function tdpsOnUpdate(self, elapsed)
		delay = delay + elapsed
		if delay > tdps.speed then
			checkCombat()
			if not tdpsInCombat then
				tdpsNewFight = true
				tdpsAnchor:SetScript('OnUpdate', nil)
			end
			if tdpsFrame:IsVisible() and not isMovingOrSizing and not tdpsAnimationGroup:IsPlaying() then tdpsRefresh() end
			delay = 0
		end
	end
	tdpsAnchor:SetScript('OnUpdate', tdpsOnUpdate)



	tdpsFrame:SetScript('OnMouseDown', function(self, button)
		if button == 'LeftButton' and IsShiftKeyDown() then CloseDropDownMenus() GameTooltip:Hide() isMovingOrSizing = true tdpsAnchor:StartMoving()
		elseif button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') PlaySound('gsTitleOptionExit')
		elseif button == 'MiddleButton' then reset()
		elseif button == 'Button4' then changeFight(1)
		elseif button == 'Button5' then changeFight(2) end
	end)



	tdpsFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then 
			tdpsAnchor:StopMovingOrSizing()
			isMovingOrSizing = nil
			tdpsFrame:ClearAllPoints()
			-- set position of frame
			tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)
			-- save position of anchor
			local point, relativeTo, relativePoint,  xOffset, yOffset = tdpsAnchor:GetPoint(1)
			tdpsAnchorPosition = {point, relativeTo, relativePoint,  xOffset, yOffset}
		end
	end)



	tdpsFrame:SetScript('OnMouseWheel', function(self, direction) scroll(direction) end)






---------------------------------------------------------------------------------------------------------------------------------
--- minimap button scripts ------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



	tdpsButtonFrame:SetScript('OnMouseDown', function(self, button)
		if button == 'RightButton' then tdpsMenu() EasyMenu(tdpsMenuTable, tdpsDropDown, 'cursor', 0, 0, 'MENU') PlaySound('gsTitleOptionExit') end
	end)

	tdpsButtonFrame:SetScript('OnMouseUp', function(self, button)
		if button == 'LeftButton' then
			if tdpsFrame:IsVisible() then tdpsFrame:Hide()
			else tdpsRefresh() tdpsFrame:Show() end
			PlaySound('gsTitleOptionExit')
		end
	end)



	tdpsButtonFrame:SetScript('OnDragStart', function(self, button)
		tdpsButtonFrame:SetScript('OnUpdate', function(self, elapsed)
			local x, y = Minimap:GetCenter()
			local cx, cy = GetCursorPosition()
			x, y = cx / self:GetEffectiveScale() - x, cy / self:GetEffectiveScale() - y
			if x > Minimap:GetWidth()/2+tdpsButtonFrame:GetWidth()/2 then x = Minimap:GetWidth()/2+tdpsButtonFrame:GetWidth()/2 end
			if x < Minimap:GetWidth()/2*-1-tdpsButtonFrame:GetWidth()/2 then x = Minimap:GetWidth()/2*-1-tdpsButtonFrame:GetWidth()/2 end
			if y > Minimap:GetHeight()/2+tdpsButtonFrame:GetHeight()/2 then y = Minimap:GetHeight()/2+tdpsButtonFrame:GetHeight()/2 end
			if y < Minimap:GetHeight()/2*-1-tdpsButtonFrame:GetHeight()/2 then y = Minimap:GetHeight()/2*-1-tdpsButtonFrame:GetHeight()/2 end
			tdpsButtonFrame:ClearAllPoints()
			tdpsButtonFrame:SetPoint('CENTER', x, y)
		end)
	end)

	tdpsButtonFrame:SetScript('OnDragStop', function(self, button) tdpsButtonFrame:SetScript('OnUpdate', nil) end)



	tdpsButtonFrame:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(tdpsButtonFrame)
		GameTooltip:SetText('TinyDPS')
		if tdpsPlayer[UnitGUID('player')] then
			GameTooltip:AddDoubleLine('Current:', fmt('%i %i', tdpsPlayer[UnitGUID('player')].fight[2].d, tdpsPlayer[UnitGUID('player')].fight[2].d / tdpsPlayer[UnitGUID('player')].fight[2].t), 1, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine('Overall:', fmt('%i %i', tdpsPlayer[UnitGUID('player')].fight[1].d, tdpsPlayer[UnitGUID('player')].fight[1].d / tdpsPlayer[UnitGUID('player')].fight[1].t), 1, 1, 1, 1, 1, 1, 1)
		end
		GameTooltip:Show()
	end)

	tdpsButtonFrame:SetScript('OnLeave', function(self) GameTooltip:Hide() end)






---------------------------------------------------------------------------------------------------------------------------------
--- resizing scripts ------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



	tdpsResizeFrame:SetScript('OnEnter', function() tdpsResizeTexture:SetDesaturated(0) tdpsResizeTexture:SetAlpha(1) end)
	tdpsResizeFrame:SetScript('OnLeave', function() tdpsResizeTexture:SetDesaturated(1) tdpsResizeTexture:SetAlpha(.2) end)
	tdpsResizeFrame:SetScript('OnMouseDown', function() isMovingOrSizing = true tdpsFrame:SetMinResize(60, tdpsFrame:GetHeight()) tdpsFrame:SetMaxResize(400, tdpsFrame:GetHeight()) tdpsFrame:StartSizing() end)



	tdpsResizeFrame:SetScript('OnMouseUp', function()
		tdpsFrame:StopMovingOrSizing()
		tdpsFrame:ClearAllPoints()
		tdpsFrame:SetPoint(tdps.anchor, tdpsAnchor, tdps.anchor)
		isMovingOrSizing = nil
		tdps.width = tdpsFrame:GetWidth()
		for i=1,#bar do bar[i]:SetWidth(tdps.width-4) bar[i]:SetValue(0) end
		tdpsRefresh()
	end)





