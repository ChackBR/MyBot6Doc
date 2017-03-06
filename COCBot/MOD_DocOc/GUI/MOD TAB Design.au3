; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: ProMac (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_MOD = 0
Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0 , $g_hGUI_MOD_TAB_ITEM2 = 0 ,$g_hGUI_MOD_TAB_ITEM3 = 0, $g_hGUI_MOD_TAB_ITEM4 = 0, $g_hGUI_MOD_TAB_ITEM5 = 0

; TreasuryGUI
Global $chkEnableTrCollect = 0, $chkForceTrCollect = 0, $chkGoldTrCollect = 0, $txtMinGoldTrCollect = 0, $txtMinElxTrCollect = 0, $chkFullElxTrCollect = 0, $chkDarkTrCollect = 0, $txtMinDarkTrCollect = 0
Global $chkFullDarkTrCollect = 0, $chkElxTrCollect = 0, $chkFullGoldTrCollect = 0

; HumanizationGUI
Global $Icon1 = 0 , $chkUseBotHumanization = 0 , $chkUseAltRClick = 0 , $Label1 = 0 , $g_acmbPriority , $Label20 = 0 , $challengeMessage = 0 , $g_ahumanMessage, $Label2 = 0 , $Label4 = 0 , $Label3= 0
Global $Icon2 = 0 , $Label5 = 0 , $Label6 = 0 , $Label7 = 0 , $Label8 = 0
Global $Icon3 = 0 , $Label9 = 0 , $Label10 = 0 , $Label11 = 0 , $Label12 = 0
Global $Icon4 = 0 , $Label14 = 0 , $Label15 = 0 , $Label16 = 0 , $Label13 = 0
Global $Icon5 = 0 , $Label17 = 0 , $Label18 = 0 , $chkCollectAchievements = 0 , $chkLookAtRedNotifications = 0 , $cmbMaxActionsNumber = 0

; GoblinXP

Global $grpSuperXP = 0 , $chkEnableSuperXP = 0 , $rbSXTraining= 0 , $lblLOCKEDSX = 0 , $rbSXIAttacking = 0 , $txtMaxXPtoGain = 0
Global $chkSXBK = 0 , $chkSXAQ = 0 , $chkSXGW = 0
Global $DocXP1 = 0 , $DocXP2 = 0 , $DocXP3 = 0 ,$DocXP4 = 0
Global $lblXPatStart = 0 , $lblXPCurrent = 0 , $lblXPSXWon = 0 , $lblXPSXWonHour = 0

; Persian DonateCC

Global $chkExtraPersian = 0
#include "MOD - Profiles.au3"
#include "MBR GUI Design Child Stats - Multi.au3"

Func CreateMODTab()

	$g_hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
		$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600, 58, "Misc MODs"))
			OptionsGUI()
		$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600, 59, "Humanization"))
			HumanizationGUI()
		$g_hGUI_MOD_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600, 60, "Goblin XP"))
			GoblinXPGUI()
		$g_hGUI_MOD_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600, 36, "Profiles"))
			CreateModProfiles()
		$g_hGUI_MOD_TAB_ITEM5 = GUICtrlCreateTabItem("MultiStat's") ; Has to be outside of the Last Control to hide
			$g_hLastControlToHide = GUICtrlCreateDummy()
			ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]
			CreateMultiStatsGUI()
	GUICtrlCreateTabItem("")

	GUISwitch($g_hGUI_BOT)
		$g_hGUI_BOT_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslated(600, 37, "Stats"))
		; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
		CreateBotStats()
		GUICtrlCreateTabItem("")
EndFunc   ;==>CreateMODTab

Func OptionsGUI()
	Local $x = 5, $y = 30

	Local $Group1 = GUICtrlCreateGroup("Treasury Collect", $x, $y, 440, 105)

	$x -= 2

	GUICtrlCreatePic(@ScriptDir & "\images\Treasury.jpg", $x + 12, $y + 25, 70, 38.6)
	$chkEnableTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 1, "Enable"), $x + 93, $y + 35, 52, 17)
		GUICtrlSetOnEvent(-1, "chkEnableTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 50, "Check to enable automatic Treasury collecion"))
	$chkForceTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 2, "Always collect Treasury"), $x + 15, $y + 75, 127, 17)
		GUICtrlSetOnEvent(-1, "chkForceTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 51, "Check to force Treasury collection" & _
			@CRLF & "Treasury will be collected all the time, ignoring any criteria"))

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 160, $y + 15, 24, 24)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 160, $y + 45, 24, 24)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 160, $y + 75, 24, 24)

	$chkGoldTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 3, "Collect when Gold <"), $x + 190, $y + 18, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 52, "When your Village Gold is below this value, it will collect Treasury"))
	$txtMinGoldTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 17, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$chkFullGoldTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 4, "When full"), $x + 370, $y + 18, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 53, "When your Gold level in Treasury is full, it will colect it to empty Treasury"))

	$chkElxTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 5, "Collect when Elixir <"), $x + 190, $y + 48, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 54, "When your Village Elixir is below this value, it will collect Treasury"))
	$txtMinElxTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 47, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$chkFullElxTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 6, "When full"), $x + 370, $y + 48, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 55, "When your Elixir level in Treasury is full, it will colect it to empty Treasury"))

	$chkDarkTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 7, "Collect when Dark <"), $x + 190, $y + 78, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 56, "When your Village Dark is below this value, it will collect Treasury"))
	$txtMinDarkTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 77, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	$chkFullDarkTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 8, "When full"), $x + 370, $y + 78, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 57, "When your Dark level in Treasury is full, it will colect it to empty Treasury"))

	chkEnableTrCollect()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 110
	$x = 5
	Local $Group2 = GUICtrlCreateGroup("Donate Options", $x, $y, 440, 40)
		$chkExtraPersian = GUICtrlCreateCheckbox(GetTranslated(800,100, "Enable Persian Alphabet Recognition for Donations"), $x + 12, $y + 15 , -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(800,101, "Check this to enable the Persian Alphabet Recognition."))
			GUICtrlSetOnEvent(-1, "Donatelang")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $sTxtTip = ""
    $x = 25
	$y = 205
	Local $Group3 = GUICtrlCreateGroup(GetTranslated(634,1, "Hero Abilities"), $x - 20, $y - 20, 440, 60)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x-10, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x+ 15, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x+ 40, $y, 24, 24)

	   $x += 70
	   $y -= 4
		   $g_hRadAutoAbilities = GUICtrlCreateRadio(GetTranslated(634,2, "Auto activate (red zone)"), $x, $y-4 , -1, -1)
		   $sTxtTip = GetTranslated(634,3, "Activate the Ability when the Hero becomes weak.") & @CRLF & GetTranslated(634,4, "Heroes are checked and activated individually.")
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetState(-1, $GUI_CHECKED)

	   $y += 15
		   $g_hRadManAbilities = GUICtrlCreateRadio(GetTranslated(634,5, "Timed after") & ":", $x , $y , -1, -1)
			   $sTxtTip = GetTranslated(634,6, "Activate the Ability on a timer.") & @CRLF & GetTranslated(634,7, "All Heroes are activated at the same time.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1, $GUI_UNCHECKED)

		   $g_hTxtManAbilities = GUICtrlCreateInput("9", $x + 80, $y+3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(634,8, "Set the time in seconds for Timed Activation of Hero Abilities.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 2)
		   GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 115, $y + 4, -1, -1)

		$x += 150
		$y -= 15

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x - 7, $y + 2, 32, 32)

		$y += 12
		   $g_hChkUseWardenAbility = GUICtrlCreateCheckbox(GetTranslated(634,9, "Force after") & ":", $x + 30, $y, -1, -1)
			   $sTxtTip = GetTranslated(634,10, "Use the ability of the Grand Warden on a timer.")
			   GUICtrlSetOnEvent(-1, "CheckWardenTimer")
			   _GUICtrlSetTip(-1, $sTxtTip)

			CheckWardenTimer()

		   $g_hTxtWardenAbility = GUICtrlCreateInput("9", $x + 110, $y+3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(634,11, "Set the time in seconds for Timed Activation of Grand Warden Ability.")
			   GUICtrlSetOnEvent(-1, "delayWardenTimer")
			   _GUICtrlSetTip(-1, $sTxtTip)

		   GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 145, $y + 4, -1, -1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TreasuryGUI

Func HumanizationGUI()

	Local $x , $y

	$chkUseBotHumanization = GUICtrlCreateCheckbox(GetTranslated(42, 0, "Enable Bot Humanization"), 10, 30, 137, 17)
 		GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
 		GUICtrlSetState(-1, $GUI_UNCHECKED)

	$chkUseAltRClick = GUICtrlCreateCheckbox(GetTranslated(42, 1, "Make ALL BOT clicks random"), 280, 30, 162, 17)
 		GUICtrlSetOnEvent(-1, "chkUseAltRClick")
 		GUICtrlSetState(-1, $GUI_UNCHECKED)

 	GUICtrlCreateGroup(GetTranslated(42, 2, "Settings"), 4, 55, 440, 335)

 	Local $x = 0, $y = 20

 	$x += 10
 	$y += 50

 		$Icon1 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnChat, $x, $y + 5, 32, 32)
 		$Label1 = GUICtrlCreateLabel(GetTranslated(42, 3, "Read the Clan Chat"), $x + 40, $y + 5, 110, 17)
 		$g_acmbPriority[0] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label2 = GUICtrlCreateLabel(GetTranslated(42, 4, "Read the Global Chat"), $x + 240, $y + 5, 110, 17)
 		$g_acmbPriority[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label4 = GUICtrlCreateLabel(GetTranslated(42, 5, "Say..."), $x + 40, $y + 30, 31, 17)
 		$g_ahumanMessage[0] = GUICtrlCreateInput(GetTranslated(42, 6, "Hello !"), $x + 75, $y + 25, 121, 21)
 		$Label3 = GUICtrlCreateLabel(GetTranslated(42, 7, "Or"), $x + 205, $y + 30, 15, 17)
 		$g_ahumanMessage[1] = GUICtrlCreateInput(GetTranslated(42, 8, "Re !"), $x + 225, $y + 25, 121, 21)
 		$g_acmbPriority[2] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label20 = GUICtrlCreateLabel(GetTranslated(42, 9, "Launch Challenges with message"), $x + 40, $y + 55, 170, 17)
		$challengeMessage = GUICtrlCreateInput(GetTranslated(42, 10, "Can you beat my village ?"), $x + 205, $y + 50, 141, 21)
 		$g_acmbPriority[12] = GUICtrlCreateCombo("", $x + 355, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

 	$y += 81

 		$Icon2 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRepeat, $x, $y + 5, 32, 32)
 		$Label5 = GUICtrlCreateLabel(GetTranslated(42, 11, "Watch Defenses"), $x + 40, $y + 5, 110, 17)
 		$g_acmbPriority[3] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 			GUICtrlSetOnEvent(-1, "cmbStandardReplay")
 		$Label6 = GUICtrlCreateLabel(GetTranslated(42, 12, "Watch Attacks"), $x + 40, $y + 30, 110, 17)
 		$g_acmbPriority[4] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 			GUICtrlSetOnEvent(-1, "cmbStandardReplay")
 		$Label7 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
 		$g_acmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sReplayChain, "2")
 		$Label8 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
 		$g_acmbPause[0] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

 	$y += 56

 		$Icon3 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnClan, $x, $y + 5, 32, 32)
 		$Label9 = GUICtrlCreateLabel(GetTranslated(42, 15, "Watch War log"), $x + 40, $y + 5, 110, 17)
 		$g_acmbPriority[5] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label10 = GUICtrlCreateLabel(GetTranslated(42, 16, "Visit Clanmates"), $x + 40, $y + 30, 110, 17)
 		$g_acmbPriority[6] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label11 = GUICtrlCreateLabel(GetTranslated(42, 17, "Look at Best Players"), $x + 240, $y + 5, 110, 17)
 		$g_acmbPriority[7] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label12 = GUICtrlCreateLabel(GetTranslated(42, 18, "Look at Best Clans"), $x + 240, $y + 30, 110, 17)
 		$g_acmbPriority[8] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

 	$y += 56

 		$Icon4 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSwords, $x, $y + 5, 32, 32)
 		$Label14 = GUICtrlCreateLabel(GetTranslated(42, 19, "Look at Current War"), $x + 40, $y + 5, 110, 17)
 		$g_acmbPriority[9] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label16 = GUICtrlCreateLabel(GetTranslated(42, 20, "Watch Replays"), $x + 40, $y + 30, 110, 17)
 		$g_acmbPriority[10] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 			GUICtrlSetOnEvent(-1, "cmbWarReplay")
 		$Label13 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
 		$g_acmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sReplayChain, "2")
 		$Label15 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
 		$g_acmbPause[1] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

 	$y += 56

 		$Icon5 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLoop, $x, $y + 5, 32, 32)
 		$Label17 = GUICtrlCreateLabel(GetTranslated(42, 21, "Do nothing"), $x + 40, $y + 5, 110, 17)
 		$g_acmbPriority[11] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
 		$Label18 = GUICtrlCreateLabel(GetTranslated(42, 22, "Max Actions by Loop"), $x + 240, $y + 5, 103, 17)
 		$cmbMaxActionsNumber = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
 			GUICtrlSetData(-1, "1|2|3|4|5", "2")

 	$y += 25

 		$chkCollectAchievements = GUICtrlCreateCheckbox(GetTranslated(42, 23, "Collect achievements automatically"), $x + 40, $y, 182, 17)
 			GUICtrlSetOnEvent(-1, "chkCollectAchievements")
 			GUICtrlSetState(-1, $GUI_UNCHECKED)

 		$chkLookAtRedNotifications = GUICtrlCreateCheckbox(GetTranslated(42, 24, "Look at red/purple flags on buttons"), $x + 240, $y, 187, 17)
 			GUICtrlSetOnEvent(-1, "chkLookAtRedNotifications")
 			GUICtrlSetState(-1, $GUI_UNCHECKED)

 	GUICtrlCreateGroup("", -99, -99, 1, 1)

 	For $i = $Icon1 To $chkLookAtRedNotifications
 		GUICtrlSetState($i, $GUI_DISABLE)
 	Next

	chkUseBotHumanization()

EndFunc

Func GoblinXPGUI()

	Local $x = 25, $y = 50, $xStart = 25, $yStart = 50

	$grpSuperXP = GUICtrlCreateGroup(GetTranslated(700, 1, "Goblin XP"), $x - 20, $y - 20, 440, 305)
		$chkEnableSuperXP = GUICtrlCreateCheckbox(GetTranslated(700, 2, "Enable Goblin XP"), $x, $y, 102, 17)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP")
			$rbSXTraining = GUICtrlCreateRadio(GetTranslated(700, 3, "Farm XP during troops Training"), $x, $y + 23, 165, 17)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
			$lblLOCKEDSX = GUICtrlCreateLabel(GetTranslated(700, 13, "LOCKED"), $x + 210, $y + 23, 173, 50)
			GUICtrlSetFont(-1, 30, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
			GUICtrlSetState(-1, $GUI_HIDE)
			$rbSXIAttacking = GUICtrlCreateRadio(GetTranslated(700, 4, "Farm XP instead of Attacking"), $x, $y + 46, 158, 17)
			GUICtrlCreateLabel (GetTranslated(700, 14, "Max XP to Gain") & ":", $x, $y + 69, -1, 17)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
			$txtMaxXPtoGain = GUICtrlCreateInput("500", $x + 85, $y + 67, 70, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 8)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
	$x += 129
	$y += 100
		GUICtrlCreateLabel(GetTranslated(700, 5, "Use"), $x - 35, $y + 13, 23, 17)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x, $y, 32, 32)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 40, $y, 32, 32)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x + 80, $y, 32, 32)
		GUICtrlCreateLabel(GetTranslated(700, 6, "to gain XP"), $x + 123, $y + 13, 53, 17)
	$x += 10
		$chkSXBK = GUICtrlCreateCheckbox("", $x, $y + 35, 17, 17)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
		$chkSXAQ = GUICtrlCreateCheckbox("", $x + 40, $y + 35, 17, 17)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
		$chkSXGW = GUICtrlCreateCheckbox("", $x + 80, $y + 35, 17, 17)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")

	$x = $xStart + 25
	$y += 73
		GUICtrlCreateLabel("", $x - 25, $y, 5, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP1 = GUICtrlCreateLabel(GetTranslated(700, 7, "XP at Start"), $x - 20, $y, 98, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP2 = GUICtrlCreateLabel(GetTranslated(700, 8, "Current XP"), $x + 63 + 15, $y, 104, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP3 = GUICtrlCreateLabel(GetTranslated(700, 9, "XP Won"), $x + 71 + 76 + 35, $y, 103, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP4 = GUICtrlCreateLabel(GetTranslated(700, 10, "XP Won/Hour"), $x + 69 + 55 + 110 + 45, $y, 87, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		;GUICtrlCreateGroup("", $x - 28, $y - 7, 395, 29)
	$y += 15
			GUICtrlCreateLabel("", $x - 25, $y + 7, 5, 36)
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPatStart = GUICtrlCreateLabel("0", $x - 20, $y + 7, 99, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPCurrent = GUICtrlCreateLabel("0", $x + 78, $y + 7, 105, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWon = GUICtrlCreateLabel("0", $x + 182, $y + 7, 97, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWonHour = GUICtrlCreateLabel("0", $x + 279, $y + 7, 87, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)

	$x = $xStart
	$y += 57
		GUICtrlCreateLabel(GetTranslated(700, 11, "Goblin XP attack continuously the TH of Goblin Picnic to farm XP."), $x, $y, 312, 17)
		GUICtrlCreateLabel(GetTranslated(700, 12, "At each attack, you win 5 XP"), $x, $y + 20, 306, 17)

	chkEnableSuperXP()

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc
