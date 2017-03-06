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
Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0 , $g_hGUI_MOD_TAB_ITEM2 = 0

; TreasuryGUI
Global $chkEnableTrCollect = 0, $chkForceTrCollect = 0, $chkGoldTrCollect = 0, $txtMinGoldTrCollect = 0, $txtMinElxTrCollect = 0, $chkFullElxTrCollect = 0, $chkDarkTrCollect = 0, $txtMinDarkTrCollect = 0
Global $chkFullDarkTrCollect = 0, $chkElxTrCollect = 0, $chkFullGoldTrCollect = 0

; HumanizationGUI



Func CreateMODTab()

	$g_hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600, 58, "Treasury"))
	TreasuryGUI()
	$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600, 59, "Humanization"))
	HumanizationGUI()
	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateMODTab

Func TreasuryGUI()

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

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>TreasuryGUI

Func HumanizationGUI()

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

		$Icon1 = GUICtrlCreateIcon($pIconLib, $eIcnChat, $x, $y + 5, 32, 32)
		$Label1 = GUICtrlCreateLabel(GetTranslated(42, 3, "Read the Clan Chat"), $x + 40, $y + 5, 110, 17)
		$acmbPriority[0] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label2 = GUICtrlCreateLabel(GetTranslated(42, 4, "Read the Global Chat"), $x + 240, $y + 5, 110, 17)
		$acmbPriority[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label4 = GUICtrlCreateLabel(GetTranslated(42, 5, "Say..."), $x + 40, $y + 30, 31, 17)
		$ahumanMessage[0] = GUICtrlCreateInput(GetTranslated(42, 6, "Hello !"), $x + 75, $y + 25, 121, 21)
		$Label3 = GUICtrlCreateLabel(GetTranslated(42, 7, "Or"), $x + 205, $y + 30, 15, 17)
		$ahumanMessage[1] = GUICtrlCreateInput(GetTranslated(42, 8, "Re !"), $x + 225, $y + 25, 121, 21)
		$acmbPriority[2] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label20 = GUICtrlCreateLabel(GetTranslated(42, 9, "Launch Challenges with message"), $x + 40, $y + 55, 170, 17)
		$challengeMessage = GUICtrlCreateInput(GetTranslated(42, 10, "Can you beat my village ?"), $x + 205, $y + 50, 141, 21)
		$acmbPriority[12] = GUICtrlCreateCombo("", $x + 355, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 81

		$Icon2 = GUICtrlCreateIcon($pIconLib, $eIcnRepeat, $x, $y + 5, 32, 32)
		$Label5 = GUICtrlCreateLabel(GetTranslated(42, 11, "Watch Defenses"), $x + 40, $y + 5, 110, 17)
		$acmbPriority[3] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
			GUICtrlSetOnEvent(-1, "cmbStandardReplay")
		$Label6 = GUICtrlCreateLabel(GetTranslated(42, 12, "Watch Attacks"), $x + 40, $y + 30, 110, 17)
		$acmbPriority[4] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
			GUICtrlSetOnEvent(-1, "cmbStandardReplay")
		$Label7 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
		$acmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sReplayChain, "2")
		$Label8 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
		$acmbPause[0] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

		$Icon3 = GUICtrlCreateIcon($pIconLib, $eIcnClan, $x, $y + 5, 32, 32)
		$Label9 = GUICtrlCreateLabel(GetTranslated(42, 15, "Watch War log"), $x + 40, $y + 5, 110, 17)
		$acmbPriority[5] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label10 = GUICtrlCreateLabel(GetTranslated(42, 16, "Visit Clanmates"), $x + 40, $y + 30, 110, 17)
		$acmbPriority[6] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label11 = GUICtrlCreateLabel(GetTranslated(42, 17, "Look at Best Players"), $x + 240, $y + 5, 110, 17)
		$acmbPriority[7] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label12 = GUICtrlCreateLabel(GetTranslated(42, 18, "Look at Best Clans"), $x + 240, $y + 30, 110, 17)
		$acmbPriority[8] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

		$Icon4 = GUICtrlCreateIcon($pIconLib, $eIcnSwords, $x, $y + 5, 32, 32)
		$Label14 = GUICtrlCreateLabel(GetTranslated(42, 19, "Look at Current War"), $x + 40, $y + 5, 110, 17)
		$acmbPriority[9] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
		$Label16 = GUICtrlCreateLabel(GetTranslated(42, 20, "Watch Replays"), $x + 40, $y + 30, 110, 17)
		$acmbPriority[10] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")
			GUICtrlSetOnEvent(-1, "cmbWarReplay")
		$Label13 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
		$acmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sReplayChain, "2")
		$Label15 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
		$acmbPause[1] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $g_sFrequenceChain, "Never")

	$y += 56

		$Icon5 = GUICtrlCreateIcon($pIconLib, $eIcnLoop, $x, $y + 5, 32, 32)
		$Label17 = GUICtrlCreateLabel(GetTranslated(42, 21, "Do nothing"), $x + 40, $y + 5, 110, 17)
		$acmbPriority[11] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
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


EndFunc