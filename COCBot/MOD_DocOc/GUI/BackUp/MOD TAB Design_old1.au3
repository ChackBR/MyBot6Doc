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

Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0

Global $chkEnableTrCollect = 0 , $chkForceTrCollect = 0 , $chkGoldTrCollect = 0 , $txtMinGoldTrCollect = 0 , $txtMinElxTrCollect = 0 , $chkFullElxTrCollect = 0 , $chkDarkTrCollect = 0 , $txtMinDarkTrCollect = 0 , $chkFullDarkTrCollect = 0

Func CreateMODTab()

	$g_hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,58,"Treasury"))
	TreasuryGUI()

	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]

	GUICtrlCreateTabItem("")

EndFunc

Func TreasuryGUI()

	 Local $x = 25, $y = 45

	LOcal $Group1 = GUICtrlCreateGroup("Treasury Collect", $x, $y, 440, 105)

		$x -= 2

		GUICtrlCreatePic(@ScriptDir & "\images\Treasury.jpg", $x + 12, $y + 25, 70, 38.6)
		$chkEnableTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 1, "Enable"), $x + 93, $y + 35, 52, 17)
		GUICtrlSetOnEvent(-1, "chkEnableTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 50, "Check to enable automatic Treasury collecion"))
		$chkForceTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 2, "Always collect Treasury"), $x + 15, $y + 75, 127, 17)
		GUICtrlSetOnEvent(-1, "chkForceTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 51, "Check to force Treasury collection" & _
		@CRLF & "Treasury will be collected all the time, ignoring any criteria"))

		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 160, $y + 15, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 160, $y + 45, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y + 75, 24, 24)

		$chkGoldTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 3, "Collect when Gold <"), $x + 190, $y + 18, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 52, "When your Village Gold is below this value, it will collect Treasury"))
		$txtMinGoldTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 17, 56, 21, BitOR($ES_CENTER,$ES_NUMBER))
		$chkFullGoldTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 4, "When full"), $x + 370, $y + 18, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 53, "When your Gold level in Treasury is full, it will colect it to empty Treasury"))

		$chkElxTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 5, "Collect when Elixir <"), $x + 190, $y + 48, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 54, "When your Village Elixir is below this value, it will collect Treasury"))
		$txtMinElxTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 47, 56, 21, BitOR($ES_CENTER,$ES_NUMBER))
		$chkFullElxTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 6, "When full"), $x + 370, $y + 48, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 55, "When your Elixir level in Treasury is full, it will colect it to empty Treasury"))

		$chkDarkTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 7, "Collect when Dark <"), $x + 190, $y + 78, 112, 17)
		GUICtrlSetOnEvent(-1, "chkResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 56, "When your Village Dark is below this value, it will collect Treasury"))
		$txtMinDarkTrCollect = GUICtrlCreateInput("200000", $x + 305, $y + 77, 56, 21, BitOR($ES_CENTER,$ES_NUMBER))
		$chkFullDarkTrCollect = GUICtrlCreateCheckbox(GetTranslated(800, 8, "When full"), $x + 370, $y + 78, 67, 17)
		GUICtrlSetOnEvent(-1, "chkFullResTrCollect")
		_GUICtrlSetTip(-1, GetTranslated(800, 57, "When your Dark level in Treasury is full, it will colect it to empty Treasury"))

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc