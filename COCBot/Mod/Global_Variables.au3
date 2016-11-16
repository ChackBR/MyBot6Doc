; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables - Mod.au3
; Description ...: Extension of MBR Global Variables for Mod
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; Attack Variables, constants and enums - Added by LunaEclipse
;

; SmartZap GUI variables
Global $ichkSmartZap = 1
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $itxtMinDE = 300

; SmartZap stats
Global $smartZapGain = 0
Global $numLSpellsUsed = 0

; Smart Zap Totals
Global $iOldsmartZapGain = 0
Global $iOldNumLTSpellsUsed = 0

; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6)
Global Const $drillLevelHold[6] = [	120, _
												225, _
												405, _
												630, _
												960, _
												1350]

; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6)
Global Const $drillLevelSteal[6] = [59, _
                                    102, _
												172, _
												251, _
												343, _
												479]

;
; AwesomeGamer
;

; DEB
Global $iChkDontRemove = 1
Global $chkDontRemove = True

; BarrackSpell
Global $iChkBarrackSpell, $chkBarrackSpell

; CSV Mod
Global $attackcsv_use_red_line = 1
Global $TroopDropNumber = 0
Global $remainingTroops[12][2]

; No League Search
Global $aNoLeague[4] = [30, 30, 0x616568, 20] ; No League Shield
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$iModeCount]

;
; MikeCoC
;

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$iModeCount], $iCSVSpeeds[13]
$isldSelectedCSVSpeed[$DB] = 5
$isldSelectedCSVSpeed[$LB] = 5
$iCSVSpeeds[0] = .1
$iCSVSpeeds[1] = .25
$iCSVSpeeds[2] = .5
$iCSVSpeeds[3] = .75
$iCSVSpeeds[4] = 1
$iCSVSpeeds[5] = 1.25
$iCSVSpeeds[6] = 1.5
$iCSVSpeeds[7] = 1.75
$iCSVSpeeds[8] = 2
$iCSVSpeeds[9] = 2.25
$iCSVSpeeds[10] = 2.5
$iCSVSpeeds[11] = 2.75
$iCSVSpeeds[12] = 3

;
; mandryd
;

; Max logout time
Global $TrainLogoutMaxTime, $TrainLogoutMaxTimeTXT


;
; DEMEN
;

; $aTabControlsStats[5] = [$hGUI_STATS_TAB, $hGUI_STATS_TAB_ITEM1, $hGUI_STATS_TAB_ITEM2, $hGUI_STATS_TAB_ITEM3, $hGUI_STATS_TAB_ITEM4]

; SwitchAcc
Global $profile = $sProfilePath & "\Profile.ini"
Global $aconfig[8]
Global $ichkSwitchAcc = 0

Global $icmbTotalCoCAcc		; 1 = 1 account, 2 = 2 accounts
Global $nTotalCoCAcc = 6
Global $ichkSmartSwitch = 1

Global $ichkCloseTraining = 0

Global $nCurProfile = 1
Global $ProfileList
Global $nTotalProfile = 1

Global $ProfileType			; Type of the Current Profile, 1 = active, 2 = donate, 3 = idle
Global $aProfileType[8]		; Type of the all Profiles, 1 = active, 2 = donate, 3 = idle

Global $MatchProfileAcc		; Account match with Current Profile
Global $aMatchProfileAcc[8]	; Accounts match with All Profiles

Global $DonateSwitchCounter = 0

Global $bReMatchAcc = False

Global $aTimerStart[8]
Global $aTimerEnd[8]
Global $aRemainTrainTime[8]
Global $aUpdateRemainTrainTime[8]
Global $nNexProfile
Global $nMinRemainTrain

Global $aCCRemainTime[8]
Global $aUpdateCCRemainTime[8]
Global $nMinCCRemain
Global $nNexProfileReqCC

Global $aAccPosY[6]


