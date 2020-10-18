--   ## WoW G910 XMIT - ©2016-20 J∆•Softcode (www.jdsoftcode.net)		  ##
--   ##     Unified lua code for Classic, Retail to BfA, and Shadowlands  ##

-------------------------- DEFINE USER'S SLASH COMMANDS ------------------------

if _G["SLASH_G910CAL1"] == nil then 	-- WoW calls this init code twice; only want it to run once
	local keyboards = { "G910", "G810", "G410", "GPro", "G512", "G513", "G915", "G815", "G213" }
		-- keyboards array can be a maximum of 9 items since only one digit is allowed in SLASH_NAME global name (1 to 9)
	local commands = {	CAL         = "cal",
						RESET       = "r",
						CDRESET     = "cdr",
						PROFILE		= "profile",
						PROFILE1    = "profile1",
						PROFILE2    = "profile2",
						PROFILESWAP = "profileswap",
						ACTIONBARS  = "actionbars",
						TIME        = "time",
						REMEMBER    = "rememberprofile" }
	for i = 1, #keyboards do
		for funcName, toType in pairs(commands) do
			_G["SLASH_G910"..funcName..i] = "/"..keyboards[i]..toType	-- e.g. SLASH_G910CDRESET2 = "/G810cdr"
		end
		-- next, create help commands customized to each keyboard name
		_G["SLASH_G910HELP"..keyboards[i].."1"] = "/"..keyboards[i]
		_G["SLASH_G910HELP"..keyboards[i].."2"] = "/"..keyboards[i].."help"
		SlashCmdList["G910HELP"..keyboards[i]] = function(msg, theEditFrame)
			G910xmit:showHelp(keyboards[i])
		end
	end
end
SLASH_G910TRIGGER1     = "/G910trigger"		-- just for testing

-------------------------- ADD-ON GLOBALS ------------------------

G910xmit = {}							-- namespace for all addon functions.

G910inCalibrationMode = 0				--  flag to suspend event processing (and update user message)
G910calCountdown = 0
G910chatInputOpen = false				--  flag to know chat window state and if just changed
G910whisperLight = false				--  flag to not send unnecessary stopChatLights
G910cinematicMovieMode = false			--  flag to come out of movie mode upon moving
G910wasMoney = 0						--  used to tell if money is coming in or going out
G910wasAnima = 0						--  used to tell in anima is coming in
G910oldSpecialization = 0				--  NON-CLASSIC: used to tell if spec changed or just a talent (new for 7.0)
G910unspentTalentPoints = 0				--  CLASSIC: used to tell when talent points spent
G910oldPlayerHealthQuartile = 0			--  used to store and compare player health for combat light timing (2.0)
G910isAtForge = false					--  NON-CLASSIC: used to track if artifact forge is open or closed (1.6 add)
G910playerOutOfControlEvent = false		--  used as back-up method to prevent short-term inactive ability msgs (1.7 add)
G910playerInCombat = false				--  used for health pulse rate sending (2.0) and to confirm ok to echo out of combat
G910loadingScreenActive = true			--  used to temporarily suspend sending messages when WoW zone loading screen is showing
G910cooldownUpdateTimer = 0.0			--	heartbeat for the cooldowns
G910updateCooldownsInterval = 1.0		--  many seconds between cooldown updates  
G910healthUpdateTimer = 0.0				--  heartbeat for the combat health updates
G910XmitMinTransmitDelay = 0.20			--  delay between each transmit phase (sec) / based on saved variable
G910needAutomaticReset = false			--  used when detecting missing textures to force an automatic reset
G910automaticResetTime = 0.0			--     used with with the above
G910skipFirstResendMsg = true			--     but cut down on the spam 1st time
G910travelingInBetween = false			--  used for repeated travel animation

G910InBetweenZoneName1 = "Oribos"		-- same
G910InBetweenZoneName2 = "The In-Between"

G910cooldownZone1 = { 1, 2, 3, 4, 5, 6} --  which action slots are in what messaging zone (zones 1 & 2 get offset for stances/stealth)
G910cooldownZone2 = { 7, 8, 9,10,11,12}
G910cooldownZone3 = {61,62,63,64,65,66}
G910cooldownZone4 = {67,68,69,70,71,72}
G910cooldownZone5 = {49,50,51,52,53,54}
G910cooldownMark = {}					-- know what's been flagged as on cooldown so won't send again (indexed by action slot ID)

G910healthCodes = {"z", "y", "x", "w"}	--  used to send player health for combat light timing (2.0)

G910colorToTexture = {	R = "01",		-- used by putMsgOnPixels (new in 2.5)
						G = "02",
						B = "04",
						M = "05",
						C = "06" }
G910texturePath = "Interface\\AddOns\\G910xmit\\"
G910WoWClassic = select(4, GetBuildInfo()) < 20000
--G910SuppressCooldowns 				--  saved variable in the .toc (applies across all characters on the same realm)
--G910UserTimeFactor = 15				--  saved variable in the .toc
--G910ProfileMemory{}					--  saved variable in the .toc


-------------------------- THE SLASH COMMANDS EXECUTE CODE HERE ------------------------
-- N.B. "self:" is not valid in slash command invokes; use G910xmit:

SlashCmdList["G910CAL"] = function(msg, theEditFrame)		--  /G910calibrate
	ChatFrame1:AddMessage( "G910xmit: In calibration mode for the next 30 seconds.")
	G910pendingMessage = ""				--reset the message systemn
	G910XmitPhase = 1
	G910XmitCounter = 0
	G910chatInputOpen = false			--forget the chat window was open (so "e" doesn't fire after 30 sec)
	G910xmit:setupGuardPixels()
	G910xmit:guardPixels(0)
	G910xmitFrameD7Texture:SetTexture(G910texturePath.."06")	-- calibration pattern
	G910xmitFrameD6Texture:SetTexture(G910texturePath.."07")
	G910xmitFrameD5Texture:SetTexture(G910texturePath.."05")
	G910xmitFrameD4Texture:SetTexture(G910texturePath.."04")
	G910xmitFrameD3Texture:SetTexture(G910texturePath.."03")
	G910xmitFrameD2Texture:SetTexture(G910texturePath.."01")
	G910xmitFrameD1Texture:SetTexture(G910texturePath.."02")
	G910inCalibrationMode = 3
	G910calCountdown = 30.0
end

SlashCmdList["G910RESET"] = function(msg, theEditFrame)		--  /G910reset    Reset all the flashing lights
	ChatFrame1:AddMessage( "G910xmit: Sending reset signal to WoW G910.")
	G910pendingMessage = ""				--reset the message system
	G910XmitPhase = 1
	--G910XmitCounter = 0
	G910xmit:sendMessage("R")
	G910whisperLight = false
	G910playerOutOfControlEvent = false
	G910playerInCombat = false
	G910loadingScreenActive = false
	C_Timer.After(1.0, function() G910xmit:applyRememberedProfile() end)
end

SlashCmdList["G910CDRESET"] = function(msg, theEditFrame)		--  /G910cdreset    Send full set of action bar status msgs
	if G910SuppressCooldowns then
		ChatFrame1:AddMessage( "G910xmit: Ignoring action bar updates. Type \"/G910actionbars on\" to enable.")
	else
		ChatFrame1:AddMessage( "G910xmit: Re-syncing all action bar keyboard lights.")
		G910suspendCooldownUpdate = true
		G910xmit:resetTheCooldowns()
		C_Timer.After(5.0, function() G910suspendCooldownUpdate = false end)
	end
end

SlashCmdList["G910PROFILE1"] = function(msg, theEditFrame)		--  LEGACY /G910profile1    Activate lighting profile
	G910xmit:sendMessage("1")
end

SlashCmdList["G910PROFILE2"] = function(msg, theEditFrame)		--  LEGACY /G910profile2    Activate lighting profile
	G910xmit:sendMessage("2")
end

SlashCmdList["G910PROFILESWAP"] = function(msg, theEditFrame)	--  LEGACY /G910profileswap    Activate lighting profile
	G910xmit:sendMessage("p")
end

SlashCmdList["G910PROFILE"] = function(msg, theEditFrame)		--  /G910profile X     Switch to lighting profile X
	if msg and tonumber(msg) then							-- if a number,
		local profileNum = math.floor(tonumber(msg))
		if (profileNum > 0 and profileNum < 10) then		--        and in the valid range
			G910xmit:sendMessage(tostring(profileNum))
		else
			ChatFrame1:AddMessage( "G910xmit: Type \"/G910profile x\" where x is a number between 1 and 9.")
		end
	else
			ChatFrame1:AddMessage( "G910xmit: Type \"/G910profile x\" where x is a number between 1 and 9.")
	end
end

SlashCmdList["G910REMEMBER"] = function(msg, theEditFrame)	--   /G910rememberprofile X    Always apply X when this char/spec logs in
	local report
	local specNow
	if msg and tonumber(msg) then							-- is a number,
		local profileNum = math.floor(tonumber(msg))
		if profileNum and (profileNum > 0 and profileNum < 10) then		-- is a number, and in the valid range
			local playerName = GetUnitName("player", true)
			if G910WoWClassic then
				G910ProfileMemory[playerName] =  profileNum
			else
				specNow = GetSpecialization()
				local nameAndSpec = playerName .. tostring(specNow)
				G910ProfileMemory[nameAndSpec] =  profileNum
			end
			G910xmit:sendMessage(tostring(profileNum))
			report = "G910xmit: Remembering to show profile "..profileNum.." for "..playerName
			if not G910WoWClassic then
				report = report .. " in "..(select(2, GetSpecializationInfo(specNow)) or "no").." spec."
			end
			ChatFrame1:AddMessage(report)
		else
			ChatFrame1:AddMessage( "G910xmit: Type \"/G910rememberprofile x\" where x is a number between 1 and 9.")
		end
	else		-- if the command is used without a numeric argument, show memorized table
		ChatFrame1:AddMessage( "WoW G910 memorized lighting profiles:")
		--table.sort( G910ProfileMemory ) does not work, and #G910ProfileMemory is always 0
		local arrayCopyForSort = {}
		for characterDescriptor, profileNum in pairs(G910ProfileMemory) do
			--ChatFrame1:AddMessage( "   Profile "..profileNum.." used for Name/Spec #: "..characterDescriptor)
			table.insert(arrayCopyForSort, {name = characterDescriptor, theProfile = profileNum } )
		end
		table.sort(arrayCopyForSort, function(a,b) return a.name < b.name end)  -- sort by name from A to Z
		if G910WoWClassic then
			report = ""
		else
			report = "name/spec#: "
		end
		if #arrayCopyForSort == 0 then		-- if the G910ProfileMemory is actually empty
			ChatFrame1:AddMessage( "   None. To add, type \"/G910rememberprofile x\" where x is a number between 1 and 9.")
		else
			for i = 1,#arrayCopyForSort do
				ChatFrame1:AddMessage( "   Profile "..arrayCopyForSort[i].theProfile.." used for "..report..arrayCopyForSort[i].name)	
			end
		end
	end
end

SlashCmdList["G910TRIGGER"] = function(msg, theEditFrame)		-- send arbitrary command for testing
	ChatFrame1:AddMessage( "G910xmit: Sending ‘"..msg.."’ to WoW G910.")
	G910xmit:sendMessage(msg)
end

SlashCmdList["G910ACTIONBARS"] = function(msg, theEditFrame)		-- to send, or not, cooldown updates (added in 1.10)
	if msg == "off" then
		G910SuppressCooldowns = true
		ChatFrame1:AddMessage("G910xmit: Now will ignore action bar updates. Uncheck \"Show action bar cooldowns\" in WoW G910.")
	elseif msg == "on" then
		G910SuppressCooldowns = false
		ChatFrame1:AddMessage("G910xmit: Now will track and send all action bar update messages. Enable 'Show action bar cooldowns' in WoW G910.")
	else
		if G910SuppressCooldowns then
			ChatFrame1:AddMessage("G910xmit: Ignoring action bar changes. Type again with \"on\" to enable.")
		else
			ChatFrame1:AddMessage("G910xmit: Sending action bar updates. Type again with \"off\" to disable.")
		end
	end
end

function G910xmit:showHelp(name)											-- added in 1.15
	local report = "."
	ChatFrame1:AddMessage ("|cffffff00HELP for WoW G910 and G910xmit.|cff00ff66 Find more at |rwww.jdsoftcode.net")
	ChatFrame1:AddMessage ("|cff00ff66  Type |r/"..name.."r|cff00ff66 to restore color profile.")
	ChatFrame1:AddMessage ("|cff00ff66  Type |r/"..name.."cdr|cff00ff66 to fix the action bar ready lights (cooldown reset).")
	ChatFrame1:AddMessage ("|cff00ff66  Type |r/"..name.."profile #|cff00ff66 to change lighting colors.")
	if not G910WoWClassic then
		report = " & spec."
	end
	ChatFrame1:AddMessage ("|cff00ff66  Type |r/"..name.."rememberprofile #|cff00ff66 to always recall profile # on this character"..report)
	ChatFrame1:AddMessage ("|cff00ff66  Type |r/"..name.."time|cff00ff66 to adjust messaging rate.")
	ChatFrame1:AddMessage ("|cff00ff66  See help in the main app for more on lighting profiles and calibration setup.|r")
end

SlashCmdList["G910TIME"] = function(msg, theEditFrame)				-- change transmit rate
	local newTime = tonumber(msg)
	if newTime then		-- it is a number
		if newTime > 0 and newTime <= 50 then
			G910UserTimeFactor = newTime
		else
			G910UserTimeFactor = 15
		end
	end
	G910XmitMinTransmitDelay = G910UserTimeFactor/100
	ChatFrame1:AddMessage ("G910xmit: Message rate is "..G910UserTimeFactor)
end


-------------------------- PLUG INTO EVENTS OF INTEREST ------------------------

function G910xmit:OnLoad()
	--print("G910xmit_OnLoad()")
	--while FrameUtil.registerFrameForEvents(self, {event}) is an option, it's no faster
	local f = G910xmitFrame						-- defined by the XML
	f:RegisterEvent("PLAYER_ENTERING_WORLD")	-- environment ready
	f:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN") -- (sometimes) cooldown for an actionbar or inventory slot starts; v1.15 add
	f:RegisterEvent("PLAYER_REGEN_ENABLED")		-- out of combat
	f:RegisterEvent("PLAYER_REGEN_DISABLED")	-- into combat
	f:RegisterEvent("CINEMATIC_START")			-- Only fires for cinematics using in-game engine, not pre-rendered movies
	f:RegisterEvent("CINEMATIC_STOP")
	f:RegisterEvent("PLAY_MOVIE")				-- fires for pre-rendered movies but has no "done with movie" call
	f:RegisterEvent("PLAYER_MONEY") 			-- player gains or loses money
	f:RegisterEvent("PLAYER_LEVEL_UP")
	f:RegisterEvent("PLAYER_ALIVE")  			-- both release from death to a graveyard AND accept a rez before releasing spirit; fires at login too
	f:RegisterEvent("PLAYER_UNGHOST") 			-- back to life after being a ghost (but not if accept player rez)
	f:RegisterEvent("PLAYER_DEAD") 				-- player just died
	f:RegisterEvent("PLAYER_CONTROL_GAINED")	-- try and avoid dimming cooldowns for short-term events; 1.7 add
	f:RegisterEvent("PLAYER_CONTROL_LOST")
	f:RegisterEvent("CHAT_MSG_WHISPER")			-- player receives a whisper from another player's character.
	f:RegisterEvent("CHAT_MSG_BN_WHISPER")		-- Fires when you receive a whisper though Battle.net
	f:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")-- Fires everytime you send a whisper though Battle.net
	f:RegisterEvent("PLAYER_STARTED_MOVING")	-- started forward/backward/strafe. Not jumping, turning, or taking a taxi.
	f:RegisterEvent("READY_CHECK")				-- ready check is triggered.	
	f:RegisterEvent("DUEL_REQUESTED")			-- added in 1.6
	f:RegisterEvent("HEARTHSTONE_BOUND")
	f:RegisterEvent("LOADING_SCREEN_ENABLED")		--add in AddOn 2.0
	f:RegisterEvent("LOADING_SCREEN_DISABLED")		--add in AddOn 2.0
	
	if not G910WoWClassic then
		f:RegisterEvent("NEW_TOY_ADDED")
		f:RegisterEvent("ROLE_POLL_BEGIN")			-- role check is triggered.   v2.0 add
		f:RegisterEvent("ACHIEVEMENT_EARNED")
		f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")-- player switches talent builds. in WoW 7.0, this triggers every time a talent is changed
		f:RegisterEvent("TRANSMOGRIFY_SUCCESS")
		f:RegisterEvent("ARTIFACT_UPDATE")
		f:RegisterEvent("ARTIFACT_CLOSE")
		f:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")		--new for WoW 8.0; add in AddOn 2.0
		f:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED")		--new for WoW 8.0; add in AddOn 2.0	
		f:RegisterEvent("AZERITE_ESSENCE_ACTIVATED")			--new for WoW 8.2
		f:RegisterEvent("AZERITE_ESSENCE_FORGE_CLOSE")			--new for WoW 8.2
		f:RegisterEvent("AZERITE_ESSENCE_FORGE_OPEN")			--new for WoW 8.2
		f:RegisterEvent("AZERITE_ESSENCE_CHANGED")				--new for WoW 8.2

		f:RegisterEvent("ZONE_CHANGED_NEW_AREA")					-- check to see if we're in In Between
		f:RegisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")		-- opening "Sanctum Upgrades" vendor/window. (transit network, anima conductor, adventures, custom). Uses 5 currencies
		f:RegisterEvent("COVENANT_SANCTUM_INTERACTION_ENDED")		-- closing "sanctum Upgrades" vendor/window. fires 2x each time.
		f:RegisterEvent("SOULBIND_FORGE_INTERACTION_STARTED") -- fired when first opened Forge of Bonds to pick 1 of 3 ppl & talents
		f:RegisterEvent("SOULBIND_FORGE_INTERACTION_ENDED")  -- Forge of Binding window closed.
		f:RegisterEvent("RUNEFORGE_LEGENDARY_CRAFTING_OPENED")		-- when opening the Runeforging window by the giant chained guy
		f:RegisterEvent("RUNEFORGE_LEGENDARY_CRAFTING_CLOSED")		-- when closing the Runeforging window by the giant chained guy
		f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")					-- fires when logging in and changing zones
	end

	G910XmitPhase = 0					-- status of the toggling guard textures
	G910XmitTransmitCounter = 0			-- counts up to G910XmitMinTransmitDelay between each message xmit phase
	G910suspendCooldownUpdate = true	-- on login and /reload, cooldown updates will be suspended to reduce turbulence
	G910pendingMessage = ""	
end

-------------------------- EVENT ROUTINES CALLED BY WOW ------------------------

---##################################
---#########  ON_EVENT   ############
---##################################
function G910xmit:OnEvent(event, ...)
	--print("G910 Event: "..event)
	local arg1, arg2 = ...;
	if (G910inCalibrationMode == true) then 
		return
	end
    if event == "PLAYER_ENTERING_WORLD" then        -- set stuff up
    	--print("PLAYER_ENTERING_WORLD")
        G910xmitFrame:Show()
        self:setupGuardPixels()
        self:guardPixels(0)
        G910wasMoney = GetMoney()
        if G910WoWClassic then
        	G910unspentTalentPoints = UnitCharacterPoints("player")
        else
			G910oldSpecialization = GetSpecialization()
	        _, G910wasAnima = C_CurrencyInfo.GetCurrencyInfo(1813)
	        if G910wasAnima == nil then G910wasAnima = 0 end
        end
		G910isAtForge = false
        C_Timer.After(1.5, function() self:sendMessage("e") end) -- send message chat field has closed
        G910chatInputOpen = false               				-- and remember it's closed
        G910oldPlayerHealthQuartile = self:healthQuartile( UnitHealth("player") / UnitHealthMax("player") )
        if G910UserTimeFactor == nil or G910UserTimeFactor <= 0 or G910UserTimeFactor > 50 then
        	G910UserTimeFactor = 15
        end
        G910XmitMinTransmitDelay = G910UserTimeFactor/100	--  delay between each transmit phase (sec)        
        G910SuppressCooldowns = G910SuppressCooldowns or false		-- if stored variable is nil, make it false
        G910loadingScreenActive = false
        G910travelingInBetween = false
        G910ProfileMemory = G910ProfileMemory or {}
		if G910WoWClassic then
			G910suspendCooldownUpdate = true						-- pause automatic updating
			C_Timer.After(1.0, function() self:applyRememberedProfile() end)
			C_Timer.After(2.0, function() self:resetTheCooldowns() end)                   -- full, no-blink update after things settle down, else all show not ready
			C_Timer.After(4.5, function() self:resetTheCooldowns() end)                   -- swapping characters was not updating everything on just 1 call
			C_Timer.After(6.0, function() G910suspendCooldownUpdate = false end)
		end
		G910skipFirstResendMsg = true
        -- in Retail, initial cooldown setup handled by initial talent event sent by game
    elseif event == "LOADING_SCREEN_ENABLED" then           -- new in 2.0 
    	G910suspendCooldownUpdate = true
        G910loadingScreenActive = true
    elseif event == "LOADING_SCREEN_DISABLED" then          -- new in 2.0
        G910loadingScreenActive = false
        C_Timer.After(2.0, function() G910suspendCooldownUpdate = false end)
    elseif event == "PLAYER_STARTED_MOVING" then    -- Clear the whisper light & movie mode upon moving.
        if G910whisperLight then
            self:sendMessage("i")
            G910whisperLight = false
        end
        if G910cinematicMovieMode then
            self:sendMessage("V")
            G910cinematicMovieMode = false
        end
    elseif event == "PLAYER_CONTROL_LOST" then      -- added in 1.7
        G910playerOutOfControlEvent = true
    elseif event == "PLAYER_CONTROL_GAINED" then    -- added in 1.7
        G910playerOutOfControlEvent = false
    elseif event == "PLAYER_REGEN_DISABLED" then    -- Into combat
        self:checkAndSendHealthPulseRateUpdate()
        G910healthUpdateTimer = GetTime() + 2.0
        self:sendMessage("C")
        G910playerInCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then     -- Out of combat
        C_Timer.After(0.01, function() self:sendMessage("O") end) -- ensure it goes
        G910playerInCombat = false
		C_Timer.After(5.0, function() if G910playerInCombat==false then self:sendMessage("O") end end)
				-- after 5 seconds, send it again (1.14 add, out in 2.0, back in on 2.1)
    elseif event == "TRANSMOGRIFY_SUCCESS" then     -- added in 1.6
        self:searchAndDestroy("J")                       -- added in 1.8 to stop multiple plays (one sent for each item xmogged)
        self:sendMessage("J")
    elseif event == "NEW_TOY_ADDED" then
        self:sendMessage("J")
    elseif event == "PLAYER_MONEY" then
        local moneyGain = GetMoney() - G910wasMoney
        if     (moneyGain <= -10000)                      then self:sendMessage("g")
        elseif (moneyGain > -10000 and moneyGain <= -100) then self:sendMessage("s") 
        elseif (moneyGain > -100 and moneyGain < 0)       then self:sendMessage("m") 
        elseif (moneyGain > 0 and moneyGain < 100)        then self:sendMessage("M") 
        elseif (moneyGain >= 100 and moneyGain < 10000)   then self:sendMessage("S") 
        else                                                   self:sendMessage("G")
        end
        G910wasMoney = GetMoney()
    elseif event == "ACHIEVEMENT_EARNED" then       -- a cheesement
        self:sendMessage("A")
    elseif event == "PLAYER_LEVEL_UP" then          -- Ding!
        self:sendMessage("A")
    elseif event == "PLAYER_DEAD" then              -- Stood in the fire
        self:sendMessage("D")
    elseif event == "PLAYER_ALIVE" then             -- got player rez while face-down -OR- released to graveyard & still dead
        if ((UnitIsDeadOrGhost("player") == false) or (UnitIsDeadOrGhost("player") == nil)) then
                                                    -- because ==1 means must have released to graveyard but is actually still dead
            C_Timer.After(0.01, function() self:sendMessage("U") end) -- ensure it goes
            C_Timer.After(5.0, function() self:sendMessage("U") end)  -- send it again after 5 seconds (1.14 add (G910extraAliveAgain), out in 2.0, back in 2.1)
        end                                         
    elseif event == "PLAYER_UNGHOST" then           -- transition from ghost form to alive after running back to corpse or spirit healer
        C_Timer.After(0.01, function() self:sendMessage("U") end) -- ensure it goes
        C_Timer.After(5.0, function() self:sendMessage("U") end)  -- send it again after 5 seconds (1.14 add (G910extraAliveAgain), out in 2.0, back in 2.1)
    elseif event == "READY_CHECK" then              -- Leeeeeeroyyyyyy!!!
        self:sendMessage("H")
    elseif event == "DUEL_REQUESTED" then           -- added in 1.6
        self:sendMessage("H")
    elseif event == "ROLE_POLL_BEGIN" then          -- added in 2.0
        self:sendMessage("r")
    --elseif event == "CHAT_MSG_RAID_WARNING" then  -- added in 2.0   There is too much going on during a fight for a /rw on keyboard lights to work well
    --    self:sendMessage("f")
    elseif event == "HEARTHSTONE_BOUND" then        -- added in 1.6
        self:sendMessage("h")
    elseif event == "CINEMATIC_START" then          -- Into a movie -- fires for new character in-game movie, garrison building reveal, etc.
        if G910cinematicMovieMode == false then         -- does not fire for in-game pre-renders like Lich King death
            self:sendMessage("W")
            G910cinematicMovieMode = true
        end
    elseif event == "CINEMATIC_STOP" then           -- Out of an in-game movie
        self:sendMessage("V")
        G910cinematicMovieMode = false
    elseif event == "PLAY_MOVIE" then               -- Fires for in-game pre-rendered movies, like WoD end-of-zone movies. No "done" signal
        if G910cinematicMovieMode == false then         -- don't send second darken signal if one already went (player might stack movie plays)
            self:sendMessage("W")
            G910cinematicMovieMode = true
        end
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then-- changed spec; major overhaul in 1.15. EVENT DOES NOT EXIST in CLASSIC
        --print("ACTIVE_TALENT_GROUP_CHANGED "..arg1.."  "..arg2)
        if (arg2==0) then                           -- arg2 == 0 only upon initial character login to the game world
            G910suspendCooldownUpdate = true						-- pause automatic updating
            C_Timer.After(1.0, function() self:applyRememberedProfile() end)
            C_Timer.After(2.0, function() self:resetTheCooldowns() end)                   -- full, no-blink update after things settle down, else all show not ready
            C_Timer.After(4.5, function() self:resetTheCooldowns() end)                   -- swapping characters was not updating everything on just 1 call
            C_Timer.After(6.0, function() G910suspendCooldownUpdate = false end)
        else
            local specNow = GetSpecialization()
            --print("  specNow = "..specNow.."  G910oldSpecialization = "..G910oldSpecialization)
            if specNow ~= G910oldSpecialization then        -- if the actual spec has changed and not just a talent,
            	C_Timer.After(0.01, function() self:sendMessage("T") end)       -- play the animation. Calling directly often failed due to more C_Timers immediately after
                G910suspendCooldownUpdate = true			-- pause automatic updating
	            C_Timer.After(1.0, function() self:applyRememberedProfile() end)
                C_Timer.After(2.1, function() self:resetTheCooldowns() end)       -- catch some early ones right after animation to show progress
                C_Timer.After(4.5, function() self:resetTheCooldowns() end)       -- show more progress
                C_Timer.After(8.0, function() self:resetTheCooldowns() end)       -- certain spells take a long time to show ready
                C_Timer.After(10.1, function() G910suspendCooldownUpdate = false end)
    	        G910oldSpecialization = specNow
            end
        end
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then    -- added in 1.15; this really doesn't fire like the API description says
		self:updateTheCooldowns()
		G910cooldownUpdateTimer = GetTime() + G910updateCooldownsInterval 
    elseif event == "CHAT_MSG_WHISPER" then         -- Got a whisper
        if not G910whisperLight then
            self:sendMessage("I")
            G910whisperLight = true
        end
    elseif event == "CHAT_MSG_BN_WHISPER" then      -- Got a Battle.net whisper
        if not G910whisperLight then
            self:sendMessage("I")
            G910whisperLight = true
        end
    elseif event == "CHAT_MSG_BN_WHISPER_INFORM" then-- player sent a battlenet whisper, so cancel whisper light
        if G910whisperLight then
            self:sendMessage("i")
            G910whisperLight = false
        end
    elseif event == "ARTIFACT_UPDATE" then          -- added in 1.6
        if C_ArtifactUI.IsAtForge() then        -- Only if player is currently at the forge...
            if G910isAtForge then               -- if this update is happening while the forge is open
				-- Code Removed; since WoW 8.0, Legion artifact weapons cannot be upgraded
            else                                -- if we were not previously at the forge, play opening forge animation
                self:sendMessage("F")
                G910isAtForge = true
            end
        end
    elseif event == "ARTIFACT_CLOSE" then           -- added in 1.6
        if G910isAtForge then               -- if we were at the forge, then play animation
            self:sendMessage("f")
            G910isAtForge = false
        end
    elseif event == "AZERITE_ITEM_POWER_LEVEL_CHANGED" then     -- when the necklace levels up
        self:sendMessage("n")
    elseif event == "AZERITE_ITEM_EXPERIENCE_CHANGED" then      -- every time the necklace XP bar moves
        self:sendMessage("N")
    elseif event == "AZERITE_ESSENCE_ACTIVATED" then			-- new ability dropped onto center of necklace
        self:sendMessage("n")
    elseif event == "AZERITE_ESSENCE_FORGE_CLOSE" then
        self:sendMessage("f")
    elseif event == "AZERITE_ESSENCE_FORGE_OPEN" then
        self:sendMessage("F")        
    elseif event == "AZERITE_ESSENCE_CHANGED" then				-- new ability added to list from item in inventory
        self:sendMessage("a")      
        
    elseif event == "ZONE_CHANGED_NEW_AREA" then
    	C_Timer.After(0.1, function() G910travelingInBetween = self:inAnimationZone()  end)	-- UI needs a chance to react to change
    elseif event == "RUNEFORGE_LEGENDARY_CRAFTING_OPENED" then
    	self:sendMessage("j")
    elseif event == "SOULBIND_FORGE_INTERACTION_STARTED" then
    	self:sendMessage("k")
    elseif event == "COVENANT_SANCTUM_INTERACTION_STARTED" then
    	self:sendMessage("l")	-- lowercase L
    elseif event == "COVENANT_SANCTUM_INTERACTION_ENDED" or event == "RUNEFORGE_LEGENDARY_CRAFTING_CLOSED" or event == "SOULBIND_FORGE_INTERACTION_ENDED" then
        self:searchAndDestroy("K")            -- sometimes triggered twice my game; only play once.
    	self:sendMessage("K")
    elseif event == "CURRENCY_DISPLAY_UPDATE" then
    	if ( arg2 ~= nil and arg1 ~= nil and arg1 == 1813 ) then
			if arg2 > G910wasAnima then
				self:sendMessage("L")
			end
			G910wasAnima = arg2
    	end
    else
    	print("G910xmit: Registered for but didn't handle "..event)  
    end
    
end


---##################################
---#########  ON_UPDATE   ###########
---##################################
function G910xmit:OnUpdate(elapsed)
	--If we're blocked by a loading screen, do nothing.
	if (G910loadingScreenActive == true) then
		return								-- should reduce losing alive/dead messages zoning in/out of instances
	end
	-- If in calibration mode, update the clock and leave.
	if G910calCountdown > 0 then
		self:handleCalibrationCountdown(elapsed)
		return
	end
	-- Either update the current message blinker or display next message in queue
	if G910XmitPhase > 0 then
		G910XmitTransmitCounter = G910XmitTransmitCounter + elapsed
		if G910XmitTransmitCounter >= G910XmitMinTransmitDelay then		-- added in 1.12; simplified in 2.0
			G910XmitTransmitCounter = 0
			if G910XmitPhase == 2 then						--first phase with new msg and blinker off complete, so turn on the blinker
				self:guardPixels(1)
				G910XmitPhase = 1
			elseif G910XmitPhase == 1 then					--second phase has had adequate time to be scanned so configure for next message
				--self:guardPixels(0)
				G910XmitPhase = 0
			end
		end
	elseif string.len(G910pendingMessage) > 0 then
		nextMessage = string.sub(G910pendingMessage,1,1)
		--print("nextMessage = "..nextMessage)
		if (nextMessage == "!" ) then				-- internal flag indicating a message to be sent using color pixels
			color = string.sub(G910pendingMessage,2,2)   -- ! with nothing else is an error
			nextMessage = string.sub(G910pendingMessage,3,3)
			G910pendingMessage = string.sub(G910pendingMessage,3)	--remove first two chars (3rd removed below)
			self:putMsgOnPixels(nextMessage,color)
		else
			self:putMsgOnPixels(nextMessage)
		end
		G910pendingMessage = string.sub(G910pendingMessage,2)	--remove first char
		self:guardPixels(0)
		G910XmitPhase = 2
		G910XmitTransmitCounter = 0
	end
	-- If a chat window opened or closed, signal the app
	if GetCurrentKeyBoardFocus() == nil then		-- is a typing window open for input? (no window = nil)
		if G910chatInputOpen == true then			-- if no typing field has focus, then if I think one does,
			self:sendMessage("e")					-- send message chat field has closed
			G910chatInputOpen = false				-- and remember it's closed
		end
	else
		if G910chatInputOpen == false then			-- if a typing field has focus, but didn't before,
			self:sendMessage("E")					-- send message chat field has opened
			G910chatInputOpen = true				-- and remember it's open
		end
	end
	-- Periodically update the status of the action bar cooldowns
	local now = GetTime()
	if now > G910cooldownUpdateTimer then
		self:updateTheCooldowns()
		G910cooldownUpdateTimer = now + G910updateCooldownsInterval 	-- update cooldowns periodically
		-- CLASSIC: Also use this once-per-second loop to notice when talents spent
		if G910WoWClassic then
			local unspentNow = UnitCharacterPoints("player")
			if unspentNow ~= G910unspentTalentPoints then
				if unspentNow < G910unspentTalentPoints then
					C_Timer.After(0.01, function() self:sendMessage("T") end)
				end
				G910unspentTalentPoints = unspentNow
			end
		end
		-- Also use this 1/sec timer to pulse In Between travel animation
		if G910travelingInBetween and UnitOnTaxi("player") then
			self:sendMessage("B")
		end
	end
	-- Periodically update the health % of the player if in combat
	if (G910playerInCombat == true) and (now > G910healthUpdateTimer) then
		self:checkAndSendHealthPulseRateUpdate()
		G910healthUpdateTimer = now + 2.0			-- update health pulsing every 2 seconds
	end
	-- Periodically do automatic reset if missing textures detected
	if (G910needAutomaticReset) then
		if G910automaticResetTime == 0.0 then
			G910automaticResetTime = GetTime() + 8.0	-- collect up to 8 seconds of missed textures then fire reset
			if G910skipFirstResendMsg then
				G910skipFirstResendMsg = false
			else
				print("G910xmit: Sorry, WoW couldn't send every message; will try again in a few seconds.")
			end
		elseif GetTime() > G910automaticResetTime then
			ChatFrame1:AddMessage( "G910xmit: Re-synching.")
			G910pendingMessage = ""				--reset the message system
			G910XmitPhase = 1
			G910xmit:sendMessage("-")
			G910whisperLight = false
			G910playerOutOfControlEvent = false
			G910playerInCombat = false
			G910loadingScreenActive = false
			C_Timer.After(0.1, function() G910xmit:applyRememberedProfile() end)
			if not G910SuppressCooldowns then
				G910suspendCooldownUpdate = true
				C_Timer.After(0.5, function() G910xmit:resetTheCooldowns() end)
				C_Timer.After(5.0, function() G910suspendCooldownUpdate = false end)
			end
			G910needAutomaticReset = false
			G910automaticResetTime = 0.0
		end
	end
end


function G910xmit:handleCalibrationCountdown(elapsed)
	G910calCountdown = G910calCountdown - elapsed
	if ( (G910inCalibrationMode==3) and (G910calCountdown<20) ) then
		ChatFrame1:AddMessage( "G910xmit: In calibration mode for the next 20 seconds.")
		G910inCalibrationMode = 2
	elseif ( (G910inCalibrationMode==2) and (G910calCountdown<10 ) ) then
		ChatFrame1:AddMessage( "G910xmit: In calibration mode for the next 10 seconds.")
		G910inCalibrationMode = 1			
	elseif ( G910calCountdown <= 0 ) then
		G910calCountdown = 0
		ChatFrame1:AddMessage( "G910xmit: Out of calibration mode.")
		G910inCalibrationMode = 0
	end
end


function G910xmit:searchAndDestroy(theMsg)		-- retuns true if theMsg found and removed
	local count = 0
	local wasFound = false
	G910pendingMessage, count = string.gsub(G910pendingMessage, theMsg, "", 1)	-- replace one of theMsg with nothing
	if count > 0 then
		wasFound = true
	end
	return wasFound
end


-------------------------- TO TAP OUT THE BITS ------------------------

function G910xmit:putMsgOnPixels(msg,color)		-- color is nil when this is called with just self:putMsgOnPixels(msg)
	--ChatFrame1:AddMessage("putting "..msg.." on the color pixels using color "..tostring(color))
	local bitmask = 1
	local texture = "07"			-- use white pixels when color is nil
	if G910colorToTexture[color] then
		texture = G910colorToTexture[color] 
	end
	local theCode = string.byte(msg)	
	--print("analyzing byte" .. theCode)
	for i = 1,7 do
		if bit.band(theCode,bitmask) > 0 then		-- uses C library that Blizzard included
			_G["G910xmitFrameD"..i.."Texture"]:SetTexture(G910texturePath..texture)
			if not _G["G910xmitFrameD"..i.."Texture"]:IsObjectLoaded() then
				G910needAutomaticReset = true
			end
		else
			_G["G910xmitFrameD"..i.."Texture"]:SetTexture(G910texturePath.."00")
		end	
		bitmask = bitmask * 2						-- proven faster than bit shifting
	end
end


function G910xmit:sendMessage(message)
	--print("G910SendMessage with "..message)
	if message == "T" and not G910WoWClassic then		-- In retail, have spec change jump ahead of cooldown changes that leak thru
		G910pendingMessage = message				-- in fact, in retail, purge everything else since spec change happens when it's "quiet"
	elseif (message == "C" or message == "O" or message == "e" ) then  -- prioritize combat status and chat close
		G910pendingMessage = message .. G910pendingMessage
	else
		G910pendingMessage = G910pendingMessage .. message
		--print("G910pendingMessage = "..G910pendingMessage)
	end
	--print ("Added <"..message.."> message; pendingMessage length now "..string.len(G910pendingMessage) )
end


function G910xmit:guardPixels(state)
	if state == 0 then
		G910xmitFrameR2Texture:SetTexture(G910texturePath.."00")
		G910xmitFrameL2Texture:SetTexture(G910texturePath.."00")
	else
		G910xmitFrameR2Texture:SetTexture(G910texturePath.."07")
		G910xmitFrameL2Texture:SetTexture(G910texturePath.."01")
		if not ( G910xmitFrameR2Texture:IsObjectLoaded() and G910xmitFrameL2Texture:IsObjectLoaded() ) then
			G910needAutomaticReset = true
		end
	end	
end


function G910xmit:setupGuardPixels()		
	G910xmitFrameR1Texture:SetTexture(G910texturePath.."07")
	G910xmitFrameL1Texture:SetTexture(G910texturePath.."01")
end

-------------------------- TO ADJUST COMBAT PULSE RATE  ------------------------

function G910xmit:checkAndSendHealthPulseRateUpdate()
	local effectiveHealth = UnitHealth("player")
	if not G910WoWClassic then
		effectiveHealth = effectiveHealth + UnitGetTotalAbsorbs("player")
	end
	local newQuartile = self:healthQuartile (  ( effectiveHealth ) / UnitHealthMax("player") )
	if newQuartile ~= G910oldPlayerHealthQuartile then 
		self:sendMessage(G910healthCodes[newQuartile])
		G910oldPlayerHealthQuartile = newQuartile
	end
end


function G910xmit:healthQuartile(testVal)
	if testVal < 1 then
		return 1 + math.floor(testVal * 4)		-- 0-0.24 is 1;  0.24-0.49 is 2;  etc.
	else
		return 4
	end
end

--------------------------  TO TRACK AND UPDATE ACTION BARS ------------------------

function G910xmit:updateTheCooldowns()
	if ( not G910SuppressCooldowns ) and ( G910suspendCooldownUpdate ~= true ) then	-- v1.10 add; speed things up (a tiny bit) if cooldowns aren't wanted.
		if ( self:shouldTheCooldownsBeSuspended() == false ) then							-- ignore cooldowns while on a taxi, out of control, or dead
			local offset = self:determineBarOffset()
			if self:scanCooldownFlagsTrueIfChanged(G910cooldownZone1, offset) then
				self:sendMessageFixingAnyOverlaps(G910cooldownZone1, "!R")
			end
			if self:scanCooldownFlagsTrueIfChanged(G910cooldownZone2, offset) then
				self:sendMessageFixingAnyOverlaps(G910cooldownZone2, "!B")
			end
			if self:scanCooldownFlagsTrueIfChanged(G910cooldownZone3, 0) then
				self:sendMessageFixingAnyOverlaps(G910cooldownZone3, "!G")
			end
			if self:scanCooldownFlagsTrueIfChanged(G910cooldownZone4, 0) then
				self:sendMessageFixingAnyOverlaps(G910cooldownZone4, "!M")
			end
			if self:scanCooldownFlagsTrueIfChanged(G910cooldownZone5, 0) then
				self:sendMessageFixingAnyOverlaps(G910cooldownZone5, "!C")
			end
		end
	end
end


function G910xmit:sendMessageFixingAnyOverlaps(cooldownZone, zonePrefix)		-- v2.2 add: makes things better for my rogue
	local newMsg = zonePrefix .. self:buildCooldownChar(cooldownZone)
	local foundAt = string.find(G910pendingMessage, zonePrefix)  	--does the existing message queue contain a related message?
	if foundAt ~= nil then
		local existingByte = string.byte(G910pendingMessage, foundAt+2)		
		local newByte = string.byte(newMsg, 3)
		if newByte == existingByte then								--if all the bits are the same, i.e. wanting add the identical message
			--do nothing; skip adding the new message
			--print(">>> skipped adding a duplicate "..zonePrefix.." message")
		elseif bit.bxor(newByte, existingByte) == 0x7E then  		-- if all 6 meaningful bits are reversed; 0x7E=0b01111110
			local oldMsg = zonePrefix .. string.char(existingByte)
			G910pendingMessage = string.gsub(G910pendingMessage, oldMsg, "")	-- replace oldMsg with nothing / purge it
			--print(">>> purged existing message of type "..zonePrefix.." from the queue")
		else														-- if 1 to 5 of the bits are different
			G910pendingMessage = string.sub(G910pendingMessage, 1, foundAt-1) .. newMsg .. string.sub(G910pendingMessage, foundAt+3, -1)  -- replace existing msg with new value
			--print(">>> replaced existing message of type "..zonePrefix.." in queue")
		end
	else
		self:sendMessage(newMsg)
	end	
end


function G910xmit:resetTheCooldowns()		-- complete rewrite (again) for 2.0
	local msg
	local offset = self:determineBarOffset()
	self:setCooldownFlags(G910cooldownZone1, offset)
	self:setCooldownFlags(G910cooldownZone2, offset)
	self:setCooldownFlags(G910cooldownZone3, 0)
	self:setCooldownFlags(G910cooldownZone4, 0)
	self:setCooldownFlags(G910cooldownZone5, 0)
	msg = "c"		-- tells app to suppress flashing for next 5 messages 
	msg = msg .. "!R" .. self:buildCooldownChar(G910cooldownZone1)
	msg = msg .. "!B" .. self:buildCooldownChar(G910cooldownZone2)
	msg = msg .. "!G" .. self:buildCooldownChar(G910cooldownZone3)
	msg = msg .. "!M" .. self:buildCooldownChar(G910cooldownZone4)
	msg = msg .. "!C" .. self:buildCooldownChar(G910cooldownZone5)
	self:sendMessage(msg)
end


function G910xmit:shouldTheCooldownsBeSuspended()
	local suspendThem = false
	if ( G910playerOutOfControlEvent or
	     UnitOnTaxi("player") or
	     UnitIsDeadOrGhost("player") or
	     HasTempShapeshiftActionBar() ) then 	-- added in 1.10 from Tuller and zork on the wowinterface.com forums
	     	suspendThem = true 
	end
	if not suspendThem and not G910WoWClassic then
		if ( HasVehicleActionBar() or			-- added in 1.10 from Tuller and zork on the wowinterface.com forums
			 C_LossOfControl.GetActiveLossOfControlDataCount() > 0 or	-- call changed in 9.0.1
	         HasOverrideActionBar() ) then		-- this for Darkmoon Fair cannon & shooting gallery
	         	suspendThem = true
	    end
	end
	return  suspendThem
end


function G910xmit:setCooldownFlags(cooldownZone, offset)
	for i = 1,6 do
		_,hasCooldown,_ = GetActionCooldown(cooldownZone[i]+offset)
		if IsUsableAction(cooldownZone[i]+offset) and hasCooldown < 1.6 then
			G910cooldownMark[cooldownZone[i]] = 0
		else
			G910cooldownMark[cooldownZone[i]] = 1
		end
		--print("setCooldownFlags G910cooldownMark["..(cooldownZone[i] or "nil").."] = "..(G910cooldownMark[cooldownZone[i]] or "nil"))
	end
end


function G910xmit:scanCooldownFlagsTrueIfChanged(cooldownZone, offset)
	--print("scanCooldownFlagsTrueIfChanged  offset "..offset)
	local changed = false
	for i = 1,6 do
		_,hasCooldown,_ = GetActionCooldown(cooldownZone[i]+offset)
		if IsUsableAction(cooldownZone[i]+offset) and hasCooldown < 1.6 then
			if G910cooldownMark[cooldownZone[i]] == 1 then
				G910cooldownMark[cooldownZone[i]] = 0
				changed = true
			end
		else
			if G910cooldownMark[cooldownZone[i]] == 0 then 
				G910cooldownMark[cooldownZone[i]] = 1
				changed = true
			end
		end
		--print("scanCooldownFlagsTrueIfChanged G910cooldownMark["..(cooldownZone[i] or "nil").."] = "..(G910cooldownMark[cooldownZone[i]] or "nil"))
	end
	return changed
end


function G910xmit:buildCooldownChar(cooldownZone)
	local byte
	byte =        G910cooldownMark[cooldownZone[1]]*64 + G910cooldownMark[cooldownZone[2]]*32 + G910cooldownMark[cooldownZone[3]]*16
	byte = byte + G910cooldownMark[cooldownZone[4]]*8  + G910cooldownMark[cooldownZone[5]]*4  + G910cooldownMark[cooldownZone[6]]*2  +  1
	return string.char(byte)
end


function G910xmit:determineBarOffset()
	local offset = 0
	local barOffset = GetBonusBarOffset()
	if barOffset > 0 then
		offset = 12*(barOffset+5)	-- looks at rogue stealth bars, shadow priest bars, warrior stances, and druid forms(?)
	end
	return offset
end


--------------------------  PROFILE MEMORY RESTORE ------------------------

function G910xmit:applyRememberedProfile()
	local playerName = GetUnitName("player", true)
	local newProfile
	if G910WoWClassic then
		newProfile = G910ProfileMemory[playerName]	-- will be nil if this table index does not exist
	else
		local specNow = GetSpecialization()
		local nameAndSpec = playerName .. tostring(specNow)
		newProfile = G910ProfileMemory[nameAndSpec]	-- will be nil if this table index does not exist
	end
	if newProfile and newProfile > 0 and newProfile < 10 then
		self:sendMessage(tostring(newProfile))
	end
end


-------------------------  ZONE CHECK  -----------------------------

function G910xmit:inAnimationZone()
	if GetZoneText()==G910InBetweenZoneName1 or GetZoneText()==G910InBetweenZoneName2 then
		return true
	else
		return false
	end
end
