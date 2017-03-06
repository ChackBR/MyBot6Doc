; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
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

Func ReadConfig_DocOc()
	; ================================================== BOT HUMANIZATION PART ================================================== ;
	IniReadS($g_ichkUseBotHumanization, $g_sProfileConfigPath, "Humanization", "chkUseBotHumanization", 0, "int")
	IniReadS($g_ichkUseAltRClick, $g_sProfileConfigPath, "Humanization", "chkUseAltRClick", 0, "int")
	IniReadS($g_ichkCollectAchievements, $g_sProfileConfigPath, "Humanization", "chkCollectAchievements", 0, "int")
	IniReadS($g_ichkLookAtRedNotifications, $g_sProfileConfigPath, "Humanization", "chkLookAtRedNotifications", 0, "int")
	For $i = 0 To 12
		IniReadS($g_iacmbPriority[$i], $g_sProfileConfigPath, "Humanization", "cmbPriority[" & $i & "]", 0, "int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbMaxSpeed[$i], $g_sProfileConfigPath, "Humanization", "cmbMaxSpeed[" & $i & "]", 1, "int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbPause[$i], $g_sProfileConfigPath, "Humanization", "cmbPause[" & $i & "]", 0, "int")
	Next
	For $i = 0 To 1
		$g_iahumanMessage[$i] = IniRead($g_sProfileConfigPath, "Humanization", "humanMessage[" & $i & "]", "")
	Next
	IniReadS($g_icmbMaxActionsNumber, "Humanization", "cmbMaxActionsNumber", 1, "int")
	; ================================================== BOT HUMANIZATION END ================================================== ;

	; ================================================== TREASURY COLLECT PART ================================================== ;
	IniReadS($g_ichkEnableTrCollect, $g_sProfileConfigPath, "Treasury", "chkEnableTrCollect", 0, "int")
	IniReadS($g_ichkForceTrCollect, $g_sProfileConfigPath, "Treasury", "chkForceTrCollect", 0, "int")
	IniReadS($g_ichkGoldTrCollect, $g_sProfileConfigPath, "Treasury", "chkGoldTrCollect", 0, "int")
	IniReadS($g_ichkElxTrCollect, $g_sProfileConfigPath, "Treasury", "chkElxTrCollect", 0, "int")
	IniReadS($g_ichkDarkTrCollect, $g_sProfileConfigPath, "Treasury", "chkDarkTrCollect", 0, "int")
	IniReadS($g_itxtMinGoldTrCollect, $g_sProfileConfigPath, "Treasury", "txtMinGoldTrCollect", 200000, "int")
	IniReadS($g_itxtMinElxTrCollect, $g_sProfileConfigPath, "Treasury", "txtMinElxTrCollect", 200000, "int")
	IniReadS($g_itxtMinDarkTrCollect, $g_sProfileConfigPath, "Treasury", "txtMinDarkTrCollect", 50000, "int")
	IniReadS($g_ichkFullGoldTrCollect, $g_sProfileConfigPath, "Treasury", "chkFullGoldTrCollect", 0, "int")
	IniReadS($g_ichkFullElxTrCollect, $g_sProfileConfigPath, "Treasury", "chkFullElxTrCollect", 0, "int")
	IniReadS($g_ichkFullDarkTrCollect, $g_sProfileConfigPath, "Treasury", "chkFullDarkTrCollect", 0, "int")
	; ================================================== TREASURY COLLECT END ================================================== ;

	; ================================================== GOBLINXP PART ================================================== ;

	IniReadS($ichkEnableSuperXP, $g_sProfileConfigPath, "attack", "EnableSuperXP", 0, "int")
	IniReadS($irbSXTraining, $g_sProfileConfigPath, "attack", "SXTraining", 1, "int")
	IniReadS($itxtMaxXPtoGain, $g_sProfileConfigPath, "attack", "MaxXptoGain", 500, "int")
	IniReadS($ichkSXBK, $g_sProfileConfigPath, "attack", "SXBK", $eHeroNone)
	IniReadS($ichkSXAQ, $g_sProfileConfigPath, "attack", "SXAQ", $eHeroNone)
	IniReadS($ichkSXGW, $g_sProfileConfigPath, "attack", "SXGW", $eHeroNone)

	; ================================================== GOBLINXP END =================================================== ;

	; Extra Persian language on Donate
	IniReadS($ichkExtraPersian, $g_sProfileConfigPath, "donate", "chkExtraPersian", 0, "int")

	; Smart Switch Account
	IniReadS($ichkSwitchAccount, $SSAConfig, "SwitchAccount", "chkEnableSwitchAccount", "0")
	IniReadS($icmbAccountsQuantity, $SSAConfig, "SwitchAccount", "cmbAccountsQuantity", "0")
	For $i = 1 To 8
		IniReadS($ichkCanUse[$i], $SSAConfig, "SwitchAccount", "chkCanUse[" & $i & "]", "0")
		IniReadS($ichkDonateAccount[$i], $SSAConfig, "SwitchAccount", "chkDonateAccount[" & $i & "]", "0")
		IniReadS($icmbAccount[$i], $SSAConfig, "SwitchAccount", "cmbAccount[" & $i & "]", "0")
		If $icmbAccount[$i] = -1 Then $icmbAccount[$i] = 0
	Next
EndFunc   ;==>ReadConfig_DocOc
