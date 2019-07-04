--   ## WoW G910 XMIT - ©2016-19 J∆•Softcode (www.jdsoftcode.net) ##

-------------------------- DEFINE USER SLASH COMMANDS ------------------------

SLASH_G910CAL1         = "/G910calibrate"	-- used to place calibration pattern on the screen for 30 seconds
SLASH_G910CAL2         = "/G910cal"
SLASH_G910RESET1       = "/G910reset"		-- tell the app to reset the lights
SLASH_G910RESET2       = "/G910r"
SLASH_G910CDRESET1     = "/G910cdreset"		-- reset all the cooldown lights, take 12 seconds to process
SLASH_G910CDRESET2     = "/G910cdr"
SLASH_G910PROFILE11    = "/G910profile1"	-- activate color profile 1
SLASH_G910PROFILE21    = "/G910profile2"	-- activate color profile 2
SLASH_G910PROFILESWAP1 = "/G910profileswap"	-- toggle color profile
SLASH_G910TRIGGER1     = "/G910trigger"		-- for testing only
SLASH_G910ACTIONBARS1  = "/G910actionbars"	-- user preference to suppress action bar messages
SLASH_G910HELP91  	   = "/G910"			-- in-game help
SLASH_G910HELP92  	   = "/G910help"		-- in-game help
SLASH_G910TIME1		   = "/G910time"		-- sets transmit delay counter
SLASH_G910PROFILE1     = "/G910profile"		-- new expanded light profile command, follow with #, 1-9

SLASH_G910CAL3         = "/G810cal"			-- these vanity aliases added in 1.15
SLASH_G910RESET3       = "/G810r"
SLASH_G910CDRESET3     = "/G810cdr"
SLASH_G910PROFILE12    = "/G810profile1"	
SLASH_G910PROFILE22    = "/G810profile2"	
SLASH_G910PROFILESWAP2 = "/G810profileswap"	
SLASH_G910ACTIONBARS2  = "/G810actionbars"	
SLASH_G910HELP81  	   = "/G810"		
SLASH_G910HELP82  	   = "/G810help"	
SLASH_G910TIME2		   = "/G810time"
SLASH_G910PROFILE2     = "/G810profile"

SLASH_G910CAL4         = "/G410cal"
SLASH_G910RESET4       = "/G410r"
SLASH_G910CDRESET4     = "/G410cdr"
SLASH_G910PROFILE13    = "/G410profile1"	
SLASH_G910PROFILE23    = "/G410profile2"	
SLASH_G910PROFILESWAP3 = "/G410profileswap"	
SLASH_G910ACTIONBARS3  = "/G410actionbars"	
SLASH_G910HELP41  	   = "/G410"		
SLASH_G910HELP42  	   = "/G410help"	
SLASH_G910TIME3		   = "/G410time"
SLASH_G910PROFILE3     = "/G410profile"

SLASH_G910CAL5         = "/GProcal"
SLASH_G910RESET5       = "/GPror"
SLASH_G910CDRESET5     = "/GProcdr"
SLASH_G910PROFILE14    = "/GProprofile1"	
SLASH_G910PROFILE24    = "/GProprofile2"	
SLASH_G910PROFILESWAP4 = "/GProprofileswap"	
SLASH_G910ACTIONBARS4  = "/GProactionbars"	
SLASH_G910HELPP1  	   = "/GPro"		
SLASH_G910HELPP2  	   = "/GProhelp"	
SLASH_G910TIME4		   = "/GProtime"
SLASH_G910PROFILE4     = "/GProprofile"

SLASH_G910CAL6         = "/G513cal"
SLASH_G910RESET6       = "/G513r"
SLASH_G910CDRESET6     = "/G513cdr"
SLASH_G910PROFILE15    = "/G513profile1"	
SLASH_G910PROFILE25    = "/G513profile2"	
SLASH_G910PROFILESWAP5 = "/G513profileswap"	
SLASH_G910ACTIONBARS5  = "/G513actionbars"	
SLASH_G910HELP51  	   = "/G513"		
SLASH_G910HELP52  	   = "/G513help"	
SLASH_G910TIME5		   = "/G513time"
SLASH_G910PROFILE5     = "/G513profile"

SLASH_G910CAL7         = "/G512cal"
SLASH_G910RESET7       = "/G512r"
SLASH_G910CDRESET7     = "/G512cdr"
SLASH_G910PROFILE16    = "/G512profile1"	
SLASH_G910PROFILE26    = "/G512profile2"	
SLASH_G910PROFILESWAP6 = "/G512profileswap"	
SLASH_G910ACTIONBARS6  = "/G512actionbars"	
SLASH_G910HELP551  	   = "/G512"		
SLASH_G910HELP552  	   = "/G512help"	
SLASH_G910TIME6		   = "/G512time"
SLASH_G910PROFILE6     = "/G512profile"

-------------------------- ADD-ON GLOBALS ------------------------

G910inCalibrationMode = 0				--  flag to suspend event processing (and update user message)
G910calCountdown = 0
G910chatInputOpen = false				--  flag to know chat window state and if just changed
G910whisperLight = false				--  flag to not send unnecessary stopChatLights
G910cinematicMovieMode = false			--  flag to come out of movie mode upon moving
G910wasMoney = 0						--  used to tell if money is coming in or going out
G910oldSpecialization = 0				--  used to tell if spec changed or just a talent (new for 7.0)
G910oldPlayerHealthQuartile = 0			--  used to store and compare player health for combat light timing (2.0)
G910isAtForge = false					--  used to track if artifact forge is open or closed (1.6 add)
G910playerOutOfControlEvent = false		--  used as back-up method to prevent short-term inactive ability msgs (1.7 add)
G910playerInCombat = false				--  used for health pulse rate sending (2.0) and to confirm ok to echo out of combat
G910loadingScreenActive = true			--  used to temporarily suspend sending messages when WoW zone loading screen is showing
G910cooldownUpdateTimer = 0.0			--	heartbeat for the cooldowns
G910updateCooldownsInterval = 1.0		--  many seconds between cooldown updates  
G910healthUpdateTimer = 0.0				--  heartbeat for the combat health updates
G910XmitMinTransmitDelay = 0.20			--  delay between each transmit phase (sec) / based on saved variable
G910cooldownZone1 = { 1, 2, 3, 4, 5, 6} --  which action slots are in what messaging zone (zones 1 & 2 get offset for stances/stealth)
G910cooldownZone2 = { 7, 8, 9,10,11,12}
G910cooldownZone3 = {61,62,63,64,65,66}
G910cooldownZone4 = {67,68,69,70,71,72}
G910cooldownZone5 = {49,50,51,52,53,54}
G910cooldownMark = {}					-- know what's been flagged as on cooldown so won't send again (indexed by action slot ID)

G910healthCodes = {"z", "y", "x", "w"}	--  used to send player health for combat light timing (2.0)

--G910SuppressCooldowns 				--  saved variable in the .toc (applies across all characters)
--G910UserTimeFactor = 15				--  saved variable in the .toc (applies across all characters)

-------------------------- THE SLASH COMMANDS EXECUTE CODE HERE ------------------------

SlashCmdList["G910CAL"] = function(msg, theEditFrame)		--  /G910calibrate
	ChatFrame1:AddMessage( "G910xmit is in calibration mode for the next 30 seconds.")
	G910pendingMessage = ""				--reset the message systemn
	G910XmitPhase = 1
	G910XmitCounter = 0
	G910chatInputOpen = false			--forget the chat window was open (so "e" doesn't fire after 30 sec)
	G910SetupGuardPixels()
	G910GuardPixels(0)
	G910xmitD7Texture:SetTexture("Interface\\AddOns\\G910xmit\\06")	-- calibration pattern
	G910xmitD6Texture:SetTexture("Interface\\AddOns\\G910xmit\\07")
	G910xmitD5Texture:SetTexture("Interface\\AddOns\\G910xmit\\05")
	G910xmitD4Texture:SetTexture("Interface\\AddOns\\G910xmit\\04")
	G910xmitD3Texture:SetTexture("Interface\\AddOns\\G910xmit\\03")
	G910xmitD2Texture:SetTexture("Interface\\AddOns\\G910xmit\\01")
	G910xmitD1Texture:SetTexture("Interface\\AddOns\\G910xmit\\02")
	G910inCalibrationMode = 3
	G910calCountdown = 30.0
end

SlashCmdList["G910RESET"] = function(msg, theEditFrame)		--  /G910reset    Reset all the flashing lights
	ChatFrame1:AddMessage( "G910xmit: Sending reset signal to WoW G910.")
	G910pendingMessage = ""				--reset the message system
	G910XmitPhase = 1
	--G910XmitCounter = 0
	G910SendMessage("R")
	G910whisperLight = false
	G910playerOutOfControlEvent = false
	G910playerInCombat = false
	G910loadingScreenActive = false
end

SlashCmdList["G910CDRESET"] = function(msg, theEditFrame)		--  /G910cdreset    Send full set of action bar status msgs
	if G910SuppressCooldowns then
		ChatFrame1:AddMessage( "G910xmit is set to ignore action bar updates. Type \"/G910actionbars on\" to enable.")
	else
		ChatFrame1:AddMessage( "G910xmit: Resetting all keyboard lights for action bars.")
		G910suspendCooldownUpdate = true
		resetTheCooldowns()
		C_Timer.After(5.0, function() G910suspendCooldownUpdate = false end)
	end
end

SlashCmdList["G910PROFILE1"] = function(msg, theEditFrame)		--  LEGACY /G910profile1    Activate lighting profile
	G910SendMessage("1")
end

SlashCmdList["G910PROFILE2"] = function(msg, theEditFrame)		--  LEGACY /G910profile2    Activate lighting profile
	G910SendMessage("2")
end

SlashCmdList["G910PROFILESWAP"] = function(msg, theEditFrame)	--  LEGACY /G910profileswap    Activate lighting profile
	G910SendMessage("p")
end

SlashCmdList["G910PROFILE"] = function(msg, theEditFrame)		--  /G910profile X     Switch to lighting profile X
	local profileNum = math.floor(tonumber(msg))
	if profileNum and (profileNum > 0 and profileNum < 10) then		-- is a number, and in the valid range
		G910SendMessage(tostring(profileNum))
	else
		ChatFrame1:AddMessage( "G910xmit: Type \"/G910profile x\" where x is a number between 1 and 9.")
	end
end

SlashCmdList["G910TRIGGER"] = function(msg, theEditFrame)		-- send arbitrary command for testing
	ChatFrame1:AddMessage( "G910xmit: Sending ‘"..msg.."’ to WoW G910.")
	G910SendMessage(msg)
end

SlashCmdList["G910ACTIONBARS"] = function(msg, theEditFrame)		-- to send, or not, cooldown updates (added in 1.10)
	if msg == "off" then
		G910SuppressCooldowns = true
		ChatFrame1:AddMessage("G910xmit will ignore action bar updates. Uncheck \"Show action bar cooldowns\" in WoW G910.")
	elseif msg == "on" then
		G910SuppressCooldowns = false
		ChatFrame1:AddMessage("G910xmit will track and send all action bar update messages. Enable 'Show action bar cooldowns' in WoW G910.")
	else
		if G910SuppressCooldowns then
			ChatFrame1:AddMessage("G910xmit is ignoring action bar changes. Type again with \"on\" to enable.")
		else
			ChatFrame1:AddMessage("G910xmit is sending action bar updates. Type again with \"off\" to disable.")
		end
	end
end

SlashCmdList["G910HELP9"] = function(msg, theEditFrame)				-- in-game AddOn help
	G910showHelp("910")
end

SlashCmdList["G910HELP8"] = function(msg, theEditFrame)				-- in-game AddOn help
	G910showHelp("810")
end

SlashCmdList["G910HELP4"] = function(msg, theEditFrame)				-- in-game AddOn help
	G910showHelp("410")
end

SlashCmdList["G910HELPP"] = function(msg, theEditFrame)				-- in-game AddOn help
	G910showHelp("pro")
end

SlashCmdList["G910HELP5"] = function(msg, theEditFrame)				-- in-game AddOn help
	G910showHelp("513")
end

SlashCmdList["G910HELP55"] = function(msg, theEditFrame)			-- in-game AddOn help
	G910showHelp("512")
end

function G910showHelp(name)											-- added in 1.15
	ChatFrame1:AddMessage ("|cffffff00HELP for WoW G"..name.." and G910xmit.|cff00ff66 Find more at |rwww.jdsoftcode.net/warcraft")
	ChatFrame1:AddMessage ("|cff00ff66  Type /g"..name.."r to reset stuck animations.")
	ChatFrame1:AddMessage ("|cff00ff66  Type /g"..name.."cdr to reset and resync the cooldown lights.")
	ChatFrame1:AddMessage ("|cff00ff66  Type /g"..name.."profile # to change lighting colors.")
	ChatFrame1:AddMessage ("|cff00ff66  Type /g"..name.."time to adjust messaging rate.")
	ChatFrame1:AddMessage ("|cff00ff66  See main application help on lighting profiles, suspending cooldown updates, and setup calibration.|r")
end

SlashCmdList["G910TIME"] = function(msg, theEditFrame)				-- change transmit rate
	local newTime = tonumber(msg)
	if newTime then		-- it is a number
		if newTime > 0 and newTime <= 50 then
			G910UserTimeFactor = newTime
		else
			G910UserTimeFactor = 20
		end
	end
	G910XmitMinTransmitDelay = G910UserTimeFactor/100
	ChatFrame1:AddMessage ("G910xmit message rate is "..G910UserTimeFactor)
end


-------------------------- PLUG INTO EVENTS OF INTEREST ------------------------

function G910xmit_OnLoad(frame)
	--print("G910xmit_OnLoad()")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")	-- environment ready
	
	frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN") -- (sometimes) cooldown for an actionbar or inventory slot starts; v1.15 add
	
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")		-- out of combat
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")	-- into combat
	
	frame:RegisterEvent("CINEMATIC_START")			-- Only fires for cinematics using in-game engine, not pre-rendered movies
	frame:RegisterEvent("CINEMATIC_STOP")
	frame:RegisterEvent("PLAY_MOVIE")				-- fires for pre-rendered movies but has no "done with movie" call
	
	frame:RegisterEvent("PLAYER_MONEY") 			-- player gains or loses money

	frame:RegisterEvent("ACHIEVEMENT_EARNED")
	frame:RegisterEvent("PLAYER_LEVEL_UP")

	frame:RegisterEvent("PLAYER_ALIVE")  			-- both release from death to a graveyard AND accept a rez before releasing spirit; fires at login too
	frame:RegisterEvent("PLAYER_UNGHOST") 			-- back to life after being a ghost (but not if accept player rez)
	frame:RegisterEvent("PLAYER_DEAD") 				-- player just died
	frame:RegisterEvent("PLAYER_CONTROL_GAINED")	-- try and avoid dimming cooldowns for short-term events; 1.7 add
	frame:RegisterEvent("PLAYER_CONTROL_LOST")
	
	frame:RegisterEvent("CHAT_MSG_WHISPER")			-- player receives a whisper from another player's character.
	frame:RegisterEvent("CHAT_MSG_BN_WHISPER")		-- Fires when you receive a whisper though Battle.net
	frame:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")-- Fires everytime you send a whisper though Battle.net
	frame:RegisterEvent("PLAYER_STARTED_MOVING")	-- started forward/backward/strafe. Not jumping, turning, or taking a taxi.
	
	frame:RegisterEvent("READY_CHECK")				-- ready check is triggered.
	frame:RegisterEvent("ROLE_POLL_BEGIN")			-- role check is triggered.   v2.0 add
	--frame:RegisterEvent("CHAT_MSG_RAID_WARNING")	-- raid leader raid warning received // no, this will often come at bad times for animation
	frame:RegisterEvent("DUEL_REQUESTED")			-- these next 5 added in 1.6
	
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")-- player switches talent builds. in WoW 7.0, this triggers every time a talent is changed
	frame:RegisterEvent("HEARTHSTONE_BOUND")
	
	frame:RegisterEvent("TRANSMOGRIFY_SUCCESS")
	frame:RegisterEvent("ARTIFACT_UPDATE")
	frame:RegisterEvent("ARTIFACT_CLOSE")
	frame:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")		--new for WoW 8.0; add in AddOn 2.0
	frame:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED")		--new for WoW 8.0; add in AddOn 2.0
	
	frame:RegisterEvent("AZERITE_ESSENCE_ACTIVATED")			--new for WoW 8.2
	--frame:RegisterEvent("AZERITE_ESSENCE_ACTIVATION_FAILED")	--new for WoW 8.2
	frame:RegisterEvent("AZERITE_ESSENCE_CHANGED")				--new for WoW 8.2
	frame:RegisterEvent("AZERITE_ESSENCE_FORGE_CLOSE")			--new for WoW 8.2
	frame:RegisterEvent("AZERITE_ESSENCE_FORGE_OPEN")			--new for WoW 8.2
	frame:RegisterEvent("AZERITE_ESSENCE_MILESTONE_UNLOCKED")	--new for WoW 8.2
	--frame:RegisterEvent("AZERITE_ESSENCE_UPDATE")				--new for WoW 8.2
	--frame:RegisterEvent("PENDING_AZERITE_ESSENCE_CHANGED")		--new for WoW 8.2
		
	frame:RegisterEvent("LOADING_SCREEN_ENABLED")		--add in AddOn 2.0
	frame:RegisterEvent("LOADING_SCREEN_DISABLED")		--add in AddOn 2.0

	G910XmitPhase = 0					-- status of the toggling guard textures
	G910XmitTransmitCounter = 0			-- counts up to G910XmitMinTransmitDelay between each message xmit phase
	G910suspendCooldownUpdate = true	-- on login and /reload, cooldown updates will be suspended to reduce turbulence
	G910pendingMessage = ""	
end

-------------------------- EVENT ROUTINES CALLED BY WOW ------------------------

---##################################
---#########  ON_EVENT   ############
---##################################
function G910xmit_OnEvent(frame, event, ...)
	--print("G910 Event: "..event)
	local arg1, arg2 = ...;
	if (G910inCalibrationMode == true) then 
		return
	end
    if event == "PLAYER_ENTERING_WORLD" then        -- set stuff up
    	--print("PLAYER_ENTERING_WORLD")
        G910xmit:Show()
        G910SetupGuardPixels()
        G910GuardPixels(0)
        G910wasMoney = GetMoney()
        G910oldSpecialization = GetSpecialization()
        G910isAtForge = false   
        C_Timer.After(1.5, function() G910SendMessage("e") end) -- send message chat field has closed
        G910chatInputOpen = false               				-- and remember it's closed
        G910oldPlayerHealthQuartile = healthQuartile( UnitHealth("player") / UnitHealthMax("player") )
        if G910UserTimeFactor == nil or G910UserTimeFactor <= 0 or G910UserTimeFactor > 50 then
        	G910UserTimeFactor = 15
        end
        G910XmitMinTransmitDelay = G910UserTimeFactor/100	--  delay between each transmit phase (sec)        
        G910loadingScreenActive = false
        -- Initial cooldown setup handled by initial talent event sent my game
    elseif event == "LOADING_SCREEN_ENABLED" then           -- new in 2.0 
    	G910suspendCooldownUpdate = true
        G910loadingScreenActive = true
    elseif event == "LOADING_SCREEN_DISABLED" then          -- new in 2.0
        G910loadingScreenActive = false
        C_Timer.After(2.0, function() G910suspendCooldownUpdate = false end)
    elseif event == "PLAYER_STARTED_MOVING" then    -- Clear the whisper light & movie mode upon moving.
        if G910whisperLight then
            G910SendMessage("i")
            G910whisperLight = false
        end
        if G910cinematicMovieMode then
            G910SendMessage("V")
            G910cinematicMovieMode = false
        end
    elseif event == "PLAYER_CONTROL_LOST" then      -- added in 1.7
        G910playerOutOfControlEvent = true
    elseif event == "PLAYER_CONTROL_GAINED" then    -- added in 1.7
        G910playerOutOfControlEvent = false
    elseif event == "PLAYER_REGEN_DISABLED" then    -- Into combat
        checkAndSendHealthPulseRateUpdate()
        G910healthUpdateTimer = GetTime() + 2.0
        G910SendMessage("C")
        G910playerInCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then     -- Out of combat
        C_Timer.After(0.01, function() G910SendMessage("O") end) -- ensure it goes
        G910playerInCombat = false
		C_Timer.After(5.0, function() if G910playerInCombat==false then G910SendMessage("O") end end)
				-- after 5 seconds, send it again (1.14 add, out in 2.0, back in on 2.1)
    elseif event == "TRANSMOGRIFY_SUCCESS" then     -- added in 1.6
        searchAndDestroy("J")                       -- added in 1.8 to stop multiple plays (one sent for each item xmogged)
        G910SendMessage("J")
    elseif event == "PLAYER_MONEY" then
        local moneyGain = GetMoney() - G910wasMoney
        if     (moneyGain <= -10000)                      then G910SendMessage("g")
        elseif (moneyGain > -10000 and moneyGain <= -100) then G910SendMessage("s") 
        elseif (moneyGain > -100 and moneyGain < 0)       then G910SendMessage("m") 
        elseif (moneyGain > 0 and moneyGain < 100)        then G910SendMessage("M") 
        elseif (moneyGain >= 100 and moneyGain < 10000)   then G910SendMessage("S") 
        else                                                   G910SendMessage("G")
        end
        G910wasMoney = GetMoney()
    elseif event == "ACHIEVEMENT_EARNED" then       -- a cheesement
        G910SendMessage("A")
    elseif event == "PLAYER_LEVEL_UP" then          -- Ding!
        G910SendMessage("A")
    elseif event == "PLAYER_DEAD" then              -- Stood in the fire
        G910SendMessage("D")
    elseif event == "PLAYER_ALIVE" then             -- got player rez while face-down -OR- released to graveyard & still dead
        if ((UnitIsDeadOrGhost("player") == false) or (UnitIsDeadOrGhost("player") == nil)) then
                                                    -- because ==1 means must have released to graveyard but is actually still dead
            C_Timer.After(0.01, function() G910SendMessage("U") end) -- ensure it goes
            C_Timer.After(5.0, function() G910SendMessage("U") end)  -- send it again after 5 seconds (1.14 add (G910extraAliveAgain), out in 2.0, back in 2.1)
        end                                         
    elseif event == "PLAYER_UNGHOST" then           -- transition from ghost form to alive after running back to corpse or spirit healer
        C_Timer.After(0.01, function() G910SendMessage("U") end) -- ensure it goes
        C_Timer.After(5.0, function() G910SendMessage("U") end)  -- send it again after 5 seconds (1.14 add (G910extraAliveAgain), out in 2.0, back in 2.1)
    elseif event == "READY_CHECK" then              -- Leeeeeeroyyyyyy!!!
        G910SendMessage("H")
    elseif event == "DUEL_REQUESTED" then           -- added in 1.6
        G910SendMessage("H")
    elseif event == "ROLE_POLL_BEGIN" then          -- added in 2.0
        G910SendMessage("r")
    --elseif event == "CHAT_MSG_RAID_WARNING" then  -- added in 2.0   There is too much going on during a fight for a /rw on keyboard lights to work well
    --    G910SendMessage("f")
    elseif event == "HEARTHSTONE_BOUND" then        -- added in 1.6
        G910SendMessage("h")
    elseif event == "CINEMATIC_START" then          -- Into a movie -- fires for new character in-game movie, garrison building reveal, etc.
        if G910cinematicMovieMode == false then         -- does not fire for in-game pre-renders like Lich King death
            G910SendMessage("W")
            G910cinematicMovieMode = true
        end
    elseif event == "CINEMATIC_STOP" then           -- Out of an in-game movie
        G910SendMessage("V")
        G910cinematicMovieMode = false
    elseif event == "PLAY_MOVIE" then               -- Fires for in-game pre-rendered movies, like WoD end-of-zone movies. No "done" signal
        if G910cinematicMovieMode == false then         -- don't send second darken signal if one already went (player might stack movie plays)
            G910SendMessage("W")
            G910cinematicMovieMode = true
        end
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then-- changed spec; major overhaul in 1.15
        --print("ACTIVE_TALENT_GROUP_CHANGED "..arg1.."  "..arg2)
        if (arg2==0) then                           -- arg2 == 0 only upon initial character login to the game world
            G910suspendCooldownUpdate = true						-- pause automatic updating
            C_Timer.After(2.0, resetTheCooldowns)                   -- full, no-blink update after things settle down, else all show not ready
            C_Timer.After(6.0, function() G910suspendCooldownUpdate = false end)
        else
            local specNow = GetSpecialization()
            --print("  specNow = "..specNow.."  G910oldSpecialization = "..G910oldSpecialization)
            if specNow ~= G910oldSpecialization then        -- if the actual spec has changed and not just a talent,
            	C_Timer.After(0.01, function() G910SendMessage("T") end)       -- play the animation. Calling directly often failed due to more C_Timers immediately after
                G910suspendCooldownUpdate = true			-- pause automatic updating
                C_Timer.After(2.1, resetTheCooldowns)       -- catch some early ones right after animation to show progress
                C_Timer.After(8.0, resetTheCooldowns)       -- certain spells take a long time to show ready
                C_Timer.After(10.1, function() G910suspendCooldownUpdate = false end)
    	        G910oldSpecialization = specNow
            end
        end
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then    -- added in 1.15; this really doesn't fire like the API description says
		G910updateTheCooldowns()
		G910cooldownUpdateTimer = GetTime() + G910updateCooldownsInterval 
    elseif event == "CHAT_MSG_WHISPER" then         -- Got a whisper
        if not G910whisperLight then
            G910SendMessage("I")
            G910whisperLight = true
        end
    elseif event == "CHAT_MSG_BN_WHISPER" then      -- Got a Battle.net whisper
        if not G910whisperLight then
            G910SendMessage("I")
            G910whisperLight = true
        end
    elseif event == "CHAT_MSG_BN_WHISPER_INFORM" then-- player sent a battlenet whisper, so cancel whisper light
        if G910whisperLight then
            G910SendMessage("i")
            G910whisperLight = false
        end
    elseif event == "ARTIFACT_UPDATE" then          -- added in 1.6
        if C_ArtifactUI.IsAtForge() then        -- Only if player is currently at the forge...
            if G910isAtForge then               -- if this update is happening while the forge is open
		-- Code Removed; since WoW 8.0, Legion artifact weapons cannot be upgraded
            else                                -- if we were not previously at the forge, play opening forge animation
                G910SendMessage("F")
                G910isAtForge = true
            end
        end
    elseif event == "ARTIFACT_CLOSE" then           -- added in 1.6
        if G910isAtForge then               -- if we were at the forge, then play animation
            G910SendMessage("f")
            G910isAtForge = false
        end
    elseif event == "AZERITE_ITEM_POWER_LEVEL_CHANGED" then     -- when the necklace levels up
        G910SendMessage("n")
    elseif event == "AZERITE_ITEM_EXPERIENCE_CHANGED" then      -- every time the necklace XP bar moves
        G910SendMessage("n")
        
    elseif event == "AZERITE_ESSENCE_ACTIVATED" then	-- new ability dropped onto center of necklace
    	print("AZERITE_ESSENCE_ACTIVATED  arg1 = "..arg1)
        G910SendMessage("n")
    --elseif event == "AZERITE_ESSENCE_ACTIVATION_FAILED" then
    --	print("AZERITE_ESSENCE_ACTIVATION_FAILED")
    elseif event == "AZERITE_ESSENCE_CHANGED" then
    	print("AZERITE_ESSENCE_CHANGED")
    elseif event == "AZERITE_ESSENCE_FORGE_CLOSE" then
    	--print("AZERITE_ESSENCE_FORGE_CLOSE")
        G910SendMessage("f")
    elseif event == "AZERITE_ESSENCE_FORGE_OPEN" then
    	--print("AZERITE_ESSENCE_FORGE_OPEN")
        G910SendMessage("F")
    elseif event == "AZERITE_ESSENCE_MILESTONE_UNLOCKED" then
    	print("AZERITE_ESSENCE_MILESTONE_UNLOCKED")
    --elseif event == "AZERITE_ESSENCE_UPDATE" then
    --	print("AZERITE_ESSENCE_UPDATE")
    --elseif event == "PENDING_AZERITE_ESSENCE_CHANGED" then
    --	print("PENDING_AZERITE_ESSENCE_CHANGED")
        
    end
end


---##################################
---#########  ON_UPDATE   ###########
---##################################
function G910xmit_OnUpdate(frame, elapsed)
	--If we're blocked by a loading screen, do nothing.
	if (G910loadingScreenActive == true) then
		return								-- should reduce losing alive/dead messages zoning in/out of instances
	end
	-- If in calibration mode, update the clock and leave.
	if G910calCountdown > 0 then
		handleCalibrationCountdown(elapsed)
		return
	end
	-- Either update the current message blinker or display next message in queue
	if G910XmitPhase > 0 then
		G910XmitTransmitCounter = G910XmitTransmitCounter + elapsed
		if G910XmitTransmitCounter >= G910XmitMinTransmitDelay then		-- added in 1.12; simplified in 2.0
			G910XmitTransmitCounter = 0
			if G910XmitPhase == 2 then						--first phase with new msg and blinker off complete, so turn on the blinker
				G910GuardPixels(1)
				G910XmitPhase = 1
			elseif G910XmitPhase == 1 then					--second phase has had adequate time to be scanned so configure for next message
				--G910GuardPixels(0)
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
			putMsgOnPixels(nextMessage,color)
		else
			putMsgOnPixels(nextMessage)
		end
		G910pendingMessage = string.sub(G910pendingMessage,2)	--remove first char
		G910GuardPixels(0)
		G910XmitPhase = 2
		G910XmitTransmitCounter = 0
	end
	-- If a chat window opened or closed, signal the app
	if GetCurrentKeyBoardFocus() == nil then		-- is a typing window open for input? (no window = nil)
		if G910chatInputOpen == true then			-- if no typing field has focus, then if I think one does,
			G910SendMessage("e")					-- send message chat field has closed
			G910chatInputOpen = false				-- and remember it's closed
		end
	else
		if G910chatInputOpen == false then			-- if a typing field has focus, but didn't before,
			G910SendMessage("E")					-- send message chat field has opened
			G910chatInputOpen = true				-- and remember it's open
		end
	end
	-- Periodically update the status of the action bar cooldowns
	local now = GetTime()
	if now > G910cooldownUpdateTimer then
		G910updateTheCooldowns()
		G910cooldownUpdateTimer = now + G910updateCooldownsInterval 	-- update cooldowns periodically
	end
	-- Periodically update the health % of the player if in combat
	if (G910playerInCombat == true) and (now > G910healthUpdateTimer) then
		checkAndSendHealthPulseRateUpdate()
		G910healthUpdateTimer = now + 2.0			-- update health pulsing every 2 seconds
	end
end


function handleCalibrationCountdown(elapsed)
	G910calCountdown = G910calCountdown - elapsed
	if ( (G910inCalibrationMode==3) and (G910calCountdown<20) ) then
		ChatFrame1:AddMessage( "G910xmit is in calibration mode for the next 20 seconds.")
		G910inCalibrationMode = 2
	elseif ( (G910inCalibrationMode==2) and (G910calCountdown<10 ) ) then
		ChatFrame1:AddMessage( "G910xmit is in calibration mode for the next 10 seconds.")
		G910inCalibrationMode = 1			
	elseif ( G910calCountdown <= 0 ) then
		G910calCountdown = 0
		ChatFrame1:AddMessage( "G910xmit is now out of calibration mode.")
		G910inCalibrationMode = 0
	end
end


function searchAndDestroy(theMsg)		-- retuns true if theMsg found and removed
	local count = 0
	local wasFound = false
	G910pendingMessage, count = string.gsub(G910pendingMessage, theMsg, "", 1)	-- replace one of theMsg with nothing
	if count > 0 then
		wasFound = true
	end
	return wasFound
end


-------------------------- TO TAP OUT THE BITS ------------------------

function putMsgOnPixels(msg,color)		-- color is nil when this is called with just putMsgOnPixels(msg)
	--ChatFrame1:AddMessage("putting "..msg.." on the color pixels using color "..tostring(color))
	local bitmask = 1
	local texture = "07"			-- use white pixels when color is nil
	if color     == "R" then 
		texture = "01" 
	elseif color == "G" then 
		texture = "02" 
	elseif color == "B" then 
		texture = "04" 
	elseif color == "M" then 
		texture = "05" 
	elseif color == "C" then 
		texture = "06" 
	end
	local theCode = string.byte(msg)
	--print("analyzing byte" .. theCode)
	for i = 1,7 do
		if bit.band(theCode,bitmask) > 0 then		-- uses C library that Blizzard included
			_G["G910xmitD"..i.."Texture"]:SetTexture("Interface\\AddOns\\G910xmit\\"..texture)
		else
			_G["G910xmitD"..i.."Texture"]:SetTexture("Interface\\AddOns\\G910xmit\\00")
		end	
		bitmask = bitmask * 2						-- proven faster than bit shifting
	end
end


function G910SendMessage(message)
	--print("G910SendMessage with "..message)
	if message == "T" then						-- have spec change jump ahead of cooldown changes that leak thru
		G910pendingMessage = message				-- in fact, purge everything else since spec change happens when it's "quiet"
	elseif (message == "C" or message == "O" or message == "e" ) then  -- prioritize combat status and chat close
		G910pendingMessage = message .. G910pendingMessage
	else
		G910pendingMessage = G910pendingMessage .. message
		--print("G910pendingMessage = "..G910pendingMessage)
	end
	--print ("Added <"..message.."> message; pendingMessage length now "..string.len(G910pendingMessage) )
end


function G910GuardPixels(state)
	if state == 0 then
		G910xmitR2Texture:SetTexture("Interface\\AddOns\\G910xmit\\00")
		G910xmitL2Texture:SetTexture("Interface\\AddOns\\G910xmit\\00")
	else
		G910xmitR2Texture:SetTexture("Interface\\AddOns\\G910xmit\\07")
		G910xmitL2Texture:SetTexture("Interface\\AddOns\\G910xmit\\01")
	end	
end
	
	
function G910SetupGuardPixels()		
	G910xmitR1Texture:SetTexture("Interface\\AddOns\\G910xmit\\07")
	G910xmitL1Texture:SetTexture("Interface\\AddOns\\G910xmit\\01")
end

-------------------------- TO ADJUST COMBAT PULSE RATE  ------------------------

function checkAndSendHealthPulseRateUpdate()
	local newQuartile = healthQuartile (  (UnitHealth("player") + UnitGetTotalAbsorbs("player") ) / UnitHealthMax("player") )
	if newQuartile ~= G910oldPlayerHealthQuartile then 
		G910SendMessage(G910healthCodes[newQuartile])
		G910oldPlayerHealthQuartile = newQuartile
	end
end


function healthQuartile(testVal)
	if testVal < 0.26 then 
		return 1
	elseif testVal < 0.51 then 
		return 2
	elseif testVal < 0.76 then 
		return 3
	else
		return 4
	end
end

--------------------------  TO TRACK AND UPDATE ACTION BARS ------------------------

function G910updateTheCooldowns()
	if ( G910SuppressCooldowns ~= true ) and ( G910suspendCooldownUpdate ~= true ) then	-- v1.10 add; speed things up (a tiny bit) if cooldowns aren't wanted.
		if ( shouldTheCooldownsBeSuspended() == false ) then							-- ignore cooldowns while on a taxi, out of control, or dead
			local offset = determineBarOffset()
			if scanCooldownFlagsTrueIfChanged(G910cooldownZone1, offset) then
				sendMessageFixingAnyOverlaps(G910cooldownZone1, "!R")
			end
			if scanCooldownFlagsTrueIfChanged(G910cooldownZone2, offset) then
				sendMessageFixingAnyOverlaps(G910cooldownZone2, "!B")
			end
			if scanCooldownFlagsTrueIfChanged(G910cooldownZone3, 0) then
				sendMessageFixingAnyOverlaps(G910cooldownZone3, "!G")
			end
			if scanCooldownFlagsTrueIfChanged(G910cooldownZone4, 0) then
				sendMessageFixingAnyOverlaps(G910cooldownZone4, "!M")
			end
			if scanCooldownFlagsTrueIfChanged(G910cooldownZone5, 0) then
				sendMessageFixingAnyOverlaps(G910cooldownZone5, "!C")
			end
		end
	end
end


function sendMessageFixingAnyOverlaps(cooldownZone, zonePrefix)		-- v2.2 add: makes things better for my rogue
	local newMsg = zonePrefix .. buildCooldownChar(cooldownZone)
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
		G910SendMessage(newMsg)
	end	
end


function resetTheCooldowns()		-- complete rewrite (again) for 2.0
	local msg
	local offset = determineBarOffset()
	setCooldownFlags(G910cooldownZone1, offset)
	setCooldownFlags(G910cooldownZone2, offset)
	setCooldownFlags(G910cooldownZone3, 0)
	setCooldownFlags(G910cooldownZone4, 0)
	setCooldownFlags(G910cooldownZone5, 0)
	msg = "c"		-- tells app to suppress flashing for next 5 messages 
	msg = msg .. "!R" .. buildCooldownChar(G910cooldownZone1)
	msg = msg .. "!B" .. buildCooldownChar(G910cooldownZone2)
	msg = msg .. "!G" .. buildCooldownChar(G910cooldownZone3)
	msg = msg .. "!M" .. buildCooldownChar(G910cooldownZone4)
	msg = msg .. "!C" .. buildCooldownChar(G910cooldownZone5)
	G910SendMessage(msg)
end


function shouldTheCooldownsBeSuspended()
	local suspendThem = false
	if ( G910playerOutOfControlEvent or
	     UnitOnTaxi("player") or
	     C_LossOfControl.GetNumEvents() > 0 or
	     UnitIsDeadOrGhost("player") or
	     HasVehicleActionBar() or				-- these 3 adds in 1.10 from Tuller and zork on the wowinterface.com forums
	     HasOverrideActionBar() or						-- this for Darkmoon Fair cannon & shooting gallery
	     HasTempShapeshiftActionBar() ) then 
	     	suspendThem = true 
	end
	return  suspendThem
end


function setCooldownFlags(cooldownZone, offset)
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


function scanCooldownFlagsTrueIfChanged(cooldownZone, offset)
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


function buildCooldownChar(cooldownZone)
	local byte
	byte =        G910cooldownMark[cooldownZone[1]]*64 + G910cooldownMark[cooldownZone[2]]*32 + G910cooldownMark[cooldownZone[3]]*16
	byte = byte + G910cooldownMark[cooldownZone[4]]*8  + G910cooldownMark[cooldownZone[5]]*4  + G910cooldownMark[cooldownZone[6]]*2  +  1
	return string.char(byte)
end


function determineBarOffset()
	local offset = 0
	local barOffset = GetBonusBarOffset()
	if barOffset > 0 then
		offset = 12*(barOffset+5)	-- looks at rogue stealth bars, shadow priest bars, warrior stances, and druid forms(?)
	end
	return offset
end
