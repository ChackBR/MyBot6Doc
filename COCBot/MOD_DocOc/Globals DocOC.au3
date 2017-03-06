; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables for DOCOC team
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; ================================================== BOT DocOc Version PART ================================================= ;

Global $g_sLastModversion = "" ;latest version from GIT
Global $g_sLastModmessage = "" ;message for last version
Global $g_sOldModversmessage = "" ;warning message for old bot

; ================================================== TREASURY COLLECT PART ================================================== ;

Global $g_ichkGoldTrCollect, $g_ichkElxTrCollect, $g_ichkDarkTrCollect
Global $g_ichkFullGoldTrCollect, $g_ichkFullElxTrCollect, $g_ichkFullDarkTrCollect
Global $g_itxtMinGoldTrCollect, $g_itxtMinElxTrCollect, $g_itxtMinDarkTrCollect
Global $g_ichkEnableTrCollect, $g_ichkForceTrCollect

; ================================================== BOT HUMANIZATION PART ================================================== ;

Global $g_iMinimumPriority, $g_iMaxActionsNumber, $g_iActionToDo
Global $g_aSetActionPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_sFrequenceChain = GetTranslated(42, 100, "Never|Sometimes|Frequently|Often|Very Often")
Global $g_sReplayChain = "1|2|4"
Global $g_ichkUseBotHumanization, $g_ichkUseAltRClick, $g_icmbMaxActionsNumber, $g_ichkCollectAchievements, $g_ichkLookAtRedNotifications

Global $g_iacmbPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iacmbMaxSpeed[2] = [0, 0]
Global $g_iacmbPause[2] = [0, 0]
Global $g_iahumanMessage[2] = ["", ""]

Global $g_acmbPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_acmbMaxSpeed[2] = [0, 0]
Global $g_acmbPause[2] = [0, 0]
Global $g_ahumanMessage[2] = ["", ""]

Global $g_aReplayDuration[2] = [0, 0] ; An array, [0] = Minute | [1] = Seconds
Global $g_bOnReplayWindow, $g_iReplayToPause

Global $g_iQuickMISX = 0, $g_iQuickMISY = 0
Global $g_iLastLayout = 0

; ================================================== BOT SuperXP PART ================================================== ;

Global $ichkEnableSuperXP = 0, $irbSXTraining = 1, $ichkSXBK = 0, $ichkSXAQ = 0, $ichkSXGW = 0, $iStartXP = 0, $iCurrentXP = 0, $iGainedXP = 0, $iGainedXPHour = 0, $itxtMaxXPtoGain = 500
Global $DebugSX = 0
;SuperXP / GoblinXP
Global Const $iDelayDropSuperXP1 = 500
Global Const $iDelayDropSuperXP2 = 1000
Global Const $iDelayDropSuperXP3 = 250
Global Const $iDelayPrepareSearchSuperXP = 500

Global $DpGoblinPicnic[3][4] = [[300, 205, 5, 5], [340, 140, 5, 5], [290, 220, 5, 5]]
Global $BdGoblinPicnic[3] = [0, "5000-7000", "6000-8000"] ; [0] = Queen, [1] = Warden, [2] = Barbarian King
Global $ActivatedHeroes[3] = [False, False, False] ; [0] = Queen, [1] = Warden, [2] = Barbarian King , Prevent to click on them to Activate Again And Again
Global Const $minStarsToEnd = 1
Global $canGainXP = False


Global $CurBaseRedLine[2] = ["", ""]
Global $DCD = "440,70|825,344|440,640|55,344"
Global $ECD = "440,22|860,344|440,670|2,344"


; Persian OCR to danateCC
Global $ichkExtraPersian = 0

; Warden Forced Ability
Global $iActivateWardenCondition = 0
Global $delayActivateW = 9
Global $HeroesTimerActivation[$eHeroCount] = [0,0,0]; $eHeroBarbarianKing | $eHeroArcherQueen | $eHeroGrandWarden

; Attack Settings [Dec 2016] used on Classic Attack
Global Const $TopLeft[5][2] = [[62, 306], [156, 238], [221, 188], [288, 142], [383, 76]]
Global Const $TopRight[5][2] = [[486, 59], [586, 134], [652, 184], [720, 231], [817, 308]]
Global Const $BottomLeft[5][2] = [[20, 373], [101, 430], [171, 481], [244, 535], [346, 615]]
Global Const $BottomRight[5][2] = [[530, 615], [632, 535], [704, 481], [781, 430], [848, 373]]
Global Const $Edges[4] = [$BottomRight, $TopLeft, $BottomLeft, $TopRight]

; TH detection
Global $aTownHall[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]
Global $IMGLOCTHLOCATION
Global $IMGLOCTHNEAR
Global $IMGLOCTHFAR
Global $IMGLOCTHRDISTANCE

;: Viper CMD CSV

Global $debugDropSCommand = 0, $LocateMode = 1 ; Can be 1 OR 2, CURRENTLY 2 is not completed

Global $PixelEaglePos[2] = [-2, -2] ; -2 Means Not Changed still/First value,  -1 Means Changed But Reseted
Global $PixelInfernoPos[2] = [-2, -2] ; -2 Means Not Changed still/First value,  -1 Means Changed But Reseted
Global $PixelADefensePos[2] = [-2, -2] ; -2 Means Not Changed still/First value,  -1 Means Changed But Reseted
Global $storedEaglePos = ""
Global $storedInfernoPos = ""
Global $storedADefensePos = ""

Global $DebugSideP = 0
Global $dGoldMines = @ScriptDir & "\imgxml\Storages\SideP\GoldMines", $dDarkDrills = @ScriptDir & "\imgxml\Storages\SideP\Drills", $dElixirCollectors = @ScriptDir & "\imgxml\Storages\SideP\Collectors"
Global $allMinesFound[7][3], $allCollectorsFound[7][3], $allDrillsFound[3][3]

Global $isModeActive[$g_iModeCount] ; From Vilage Search in Middle of code. Moved here

;=================Multi Stat's GUI==========================================
Global $g_grpVillageSW[9], $g_icnPopOutSW[9]										;Static

Global $g_lblGoldNowSW[9], $g_lblElixirNowSW[9], $g_lblDarkNowSW[9]							; Values get Updated
Global $g_lblHrStatsGoldSW[9], $g_lblHrStatsElixirSW[9], $g_lblHrStatsDarkSW[9]				; Values get Updated

Global $g_icnGoldSW[9], $g_icnElixirSW[9], $g_icnDarkSW[9]							;Static
Global $g_lblUnitMeasureSW1[9], $g_lblUnitMeasureSW2[9], $g_lblUnitMeasureSW3[9]	;Static
Global $g_icnGemSW[9], $g_icnBuliderSW[9], $g_icnHourGlassSW[9]						;Static

Global $g_lblKingStatus[9], $g_lblQueenStatus[9], $g_lblWardenStatus[9]						; Values get Updated
Global $g_lblLabStatus[9],$g_lblGemNowSW[9], $g_lblBuilderNowSW[9], $g_lblTimeNowSW[9]		; Values get Updated

;================== POP - OUTS ==============================
Global $g_grpVillagePO[9], $g_icnPopOutEX[9]										;Static  -- declare for eval

Global $g_lblGoldNowPO[9], $g_lblElixirNowPO[9], $g_lblDarkNowPO[9]							; Values get Updated
Global $g_lblHrStatsGoldPO[9], $g_lblHrStatsElixirPO[9], $g_lblHrStatsDarkPO[9]				; Values get Updated

Global $g_icnGoldPO[9], $g_icnElixirPO[9], $g_icnDarkPO[9]							;Static
Global $g_lblUnitMeasurePO1[9], $g_lblUnitMeasurePO2[9], $g_lblUnitMeasurePO3[9]	;Static
Global $g_icnGemPO[9], $g_icnBuliderPO[9], $g_icnHourGlassPO[9]						;Static

Global $g_lblKingStatusPO[9], $g_lblQueenStatusPO[9], $g_lblWardenStatusPO[9]				; Values get Updated
Global $g_lblLabStatusPO[9],$g_lblGemNowPO[9], $g_lblBuilderNowPO[9], $g_lblTimeNowPO[9]	; Values get Updated
Global $hGuiPopOut , $hGuiPopOut0, $hGuiPopOut1, $hGuiPopOut2, $hGuiPopOut3
Global $hGuiPopOut4, $hGuiPopOut5, $hGuiPopOut6, $hGuiPopOut7, $hGuiPopOut8
Global $g_iMonitorX, $g_iMonitorY
;======================== STATS ====================================================
Global $g_iFreeBuilderCount[9], $g_iTotalBuilderCount[9], $g_iGemAmount[9] ; builder and gem amounts

Global $g_iStatsCurrent[9][$eLootCount] = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
Global $g_iStatsStartedWith[9][$eLootCount] = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
Global $g_iStatsLastAttack[9][$eLootCount] = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
Global $g_iStatsBonusLast[9][$eLootCount] = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
Global $g_iStatsTotalGain[9][$eLootCount] = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
Global $g_iSkippedVillageCount[9], $g_iDroppedTrophyCount[9] ; skipped village and dropped trophy counts
Global $g_iSearchCost[9], $g_iTrainCostElixir[9], $g_iTrainCostDElixir[9] ; search and train troops cost
Global $g_iGoldFromMines[9], $g_iElixirFromCollectors[9], $g_iDElixirFromDrills[9] ; number of resources gain by collecting mines, collectors, drills
Global $g_iNbrOfWallsUppedGold[9], $g_iNbrOfWallsUppedElixir[9], $g_iNbrOfBuildingsUppedGold[9], $g_iNbrOfBuildingsUppedElixir[9], $g_iNbrOfHeroesUpped[9] ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $g_iCostGoldWall[9], $g_iCostElixirWall[9], $g_iCostGoldBuilding[9], $g_iCostElixirBuilding[9], $g_iCostDElixirHero[9] ; wall, building and hero upgrade costs
Global $g_iAttackedVillageCount[9][$g_iModeCount + 3] ; number of attack villages for DB, LB, TB, TS
Global $g_iTotalGoldGain[9][$g_iModeCount + 3], $g_iTotalElixirGain[9][$g_iModeCount + 3], $g_iTotalDarkGain[9][$g_iModeCount + 3], $g_iTotalTrophyGain[9][$g_iModeCount + 3] ; total resource gains for DB, LB, TB, TS
Global $g_iNbrOfDetectedMines[9][$g_iModeCount + 3], $g_iNbrOfDetectedCollectors[9][$g_iModeCount + 3], $g_iNbrOfDetectedDrills[9][$g_iModeCount + 3] ; number of mines, collectors, drills detected for DB, LB, TB
Global $g_iNbrOfTHSnipeFails[9], $g_iNbrOfTHSnipeSuccess[9] ; number of fails and success while TH Sniping
Global $g_iSmartZapGain[9], $g_iNumEQSpellsUsed[9], $g_iNumLSpellsUsed[9]

Global $Init = False, $FirstInit = True, $ichkSwitchAccount
Global $SSAConfig = $g_sProfilePath & "\Profile.ini"
Global $SSAAtkLog = $g_sProfilePath & "\SmartSwitchAccount_Attack_Report.txt"
Global $ichkCanUse[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $ichkDonateAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $icmbAccount[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $isModeActive[$g_iModeCount] ; From Vilage Search in Middle of code. Moved here

; DOnateCC debug Button

Global $DonationWindowY = 0


; Switch account
Global $g_bSwitchAcctPrereq = False
Global $AllAccountsWaitTimeDiff[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ; stored as Milli sec ;Updated time left to train
Global $AllAccountsWaitTime[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]  ; Stored as min time ;reported as time needed to train troops
Global $TimerDiffStart[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ;the start and stop timer counters
Global $TimerDiffEnd[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0] ;the start and stop timer counters

Global $CurrentAccountWaitTime = 0

Global $TotalAccountsOnEmu = 0, $CurrentDAccount = 1, $FirstLoop = 0
Global $MustGoToDonateAccount = 0
Global $yCoord, $HeroesRemainingWait, $TotalAccountsInUse, $TotalDAccountsInUse,  $NextAccount, $NextProfile
Global $AlreadyConnected, $IsLoadButton, $NextStep, $LastDate = ""
