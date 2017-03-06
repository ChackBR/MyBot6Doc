; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: ProMac (2017), RoroTiti (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SaveConfig_DocOc()
	; ================================================== BOT HUMANIZATION PART ================================================== ;
	IniWriteS($g_sProfileConfigPath, "Humanization", "chkUseBotHumanization", $g_ichkUseBotHumanization)
	IniWriteS($g_sProfileConfigPath, "Humanization", "chkUseAltRClick", $g_ichkUseAltRClick)
	IniWriteS($g_sProfileConfigPath, "Humanization", "chkCollectAchievements", $g_ichkCollectAchievements)
	IniWriteS($g_sProfileConfigPath, "Humanization", "chkLookAtRedNotifications", $g_ichkLookAtRedNotifications)
	For $i = 0 To 12
		IniWriteS($g_sProfileConfigPath, "Humanization", "cmbPriority[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i]))
	Next
	For $i = 0 To 1
		IniWriteS($g_sProfileConfigPath, "Humanization", "cmbMaxSpeed[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_iacmbMaxSpeed[$i]))
	Next
	For $i = 0 To 1
		IniWriteS($g_sProfileConfigPath, "Humanization", "cmbPause[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPause[$i]))
	Next
	For $i = 0 To 1
		IniWriteS($g_sProfileConfigPath, "Humanization", "humanMessage[" & $i & "]", GUICtrlRead($g_ahumanMessage[$i]))
	Next
	IniWriteS($g_sProfileConfigPath, "Humanization", "cmbMaxActionsNumber", _GUICtrlComboBox_GetCurSel($g_icmbMaxActionsNumber))
	; ================================================== BOT HUMANIZATION END ================================================== ;

	; ================================================== TREASURY COLLECT PART ================================================== ;
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkEnableTrCollect", $g_ichkEnableTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkForceTrCollect", $g_ichkForceTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkGoldTrCollect", $g_ichkGoldTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkElxTrCollect", $g_ichkElxTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkDarkTrCollect", $g_ichkDarkTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "txtMinGoldTrCollect", GUICtrlRead($txtMinGoldTrCollect))
	IniWriteS($g_sProfileConfigPath, "Treasury", "txtMinElxTrCollect", GUICtrlRead($txtMinElxTrCollect))
	IniWriteS($g_sProfileConfigPath, "Treasury", "txtMinDarkTrCollect", GUICtrlRead($txtMinDarkTrCollect))
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkFullGoldTrCollect", $g_ichkFullGoldTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkFullElxTrCollect", $g_ichkFullElxTrCollect)
	IniWriteS($g_sProfileConfigPath, "Treasury", "chkFullDarkTrCollect", $g_ichkFullDarkTrCollect)
	; ================================================== TREASURY COLLECT END ================================================== ;

	; ================================================== GOBLINXP PART ================================================== ;
	IniWriteS($g_sProfileConfigPath, "attack", "EnableSuperXP", $ichkEnableSuperXP)
	IniWriteS($g_sProfileConfigPath, "attack", "SXTraining", $irbSXTraining)
	IniWriteS($g_sProfileConfigPath, "attack", "SXBK", $ichkSXBK)
	IniWriteS($g_sProfileConfigPath, "attack", "SXAQ", $ichkSXAQ)
	IniWriteS($g_sProfileConfigPath, "attack", "SXGW", $ichkSXGW)
	IniWriteS($g_sProfileConfigPath, "attack", "MaxXptoGain", GUICtrlRead($txtMaxXPtoGain))
	; ================================================== GOBLINXP END =================================================== ;

	; Extra Persian language on Donate
	IniWriteS($g_sProfileConfigPath, "donate", "chkExtraPersian", $ichkExtraPersian)

	; Warden Forced Ability
	IniWriteS($g_sProfileConfigPath, "attack", "ActivateWarden",$iActivateWardenCondition)
	IniWriteS($g_sProfileConfigPath, "attack", "delayActivateW", GUICtrlRead($g_hTxtWardenAbility))

EndFunc   ;==>SaveConfig_DocOc
