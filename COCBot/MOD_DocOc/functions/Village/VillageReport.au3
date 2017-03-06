; #FUNCTION# ====================================================================================================================
; Name ..........: VillageReport
; Description ...: This function will report the village free and total builders, gold, elixir, dark elixir and gems.
;                  It will also update the statistics to the GUI.
; Syntax ........: VillageReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (2015-feb-10)
; Modified ......: Safar46 (2015), Hervidero (2015), KnowJack (June-2015) , ProMac (2015), Sardo 2015-08, MonkeyHunter(6-2106)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageReport($bBypass = False, $bSuppressLog = False, $bForceUpdateAll = False)
	PureClickP($aAway, 1, 0, "#0319") ;Click Away
	If _Sleep($iDelayVillageReport1) Then Return

	Switch $bBypass
		Case False
			If Not $bSuppressLog Then SetLog("Village Report", $COLOR_INFO)
		Case True
			If Not $bSuppressLog Then SetLog("Updating Village Resource Values", $COLOR_INFO)
		Case Else
			If Not $bSuppressLog Then SetLog("Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	getBuilderCount($bSuppressLog) ; update builder data
	If _Sleep($iDelayRespond) Then Return

	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
	If Not $bSuppressLog Then Setlog(" [T]: " & _NumberFormat($iTrophyCurrent), $COLOR_SUCCESS)

	If _ColorCheck(_GetPixelColor(837, 134, True), Hex(0x302030, 6), 15) Then ; check if the village have a Dark Elixir Storage
		$iGoldCurrent = getResourcesMainScreen(696, 23)
		$iElixirCurrent = getResourcesMainScreen(696, 74)
		$iDarkCurrent =  getResourcesMainScreen(728, 123)
		$iGemAmount = getResourcesMainScreen(740, 171)
		If Not $bSuppressLog Then SetLog(" [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [GEM]: " & _NumberFormat($iGemAmount), $COLOR_SUCCESS)
	Else
		$iGoldCurrent = getResourcesMainScreen(701, 23)
		$iElixirCurrent = getResourcesMainScreen(701, 74)
		$iDarkCurrent = ""
		$iGemAmount = getResourcesMainScreen(719, 123)
		If Not $bSuppressLog Then SetLog(" [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [GEM]: " & _NumberFormat($iGemAmount), $COLOR_SUCCESS)
	EndIf
	
	; Have not Ran thru whole bot code to replace all the $iGoldCurrent With its Multi Account Replacement
	; Of $g_iStatsCurrent[$CurrentAccount][$eLootGold], So Both Variables Co exist, Same is true for
	; For the Group below This line to the =====End Group==== Line
	$g_iStatsCurrent[$CurrentAccount][$eLootGold] = $iGoldCurrent
	$g_iStatsCurrent[$CurrentAccount][$eLootElixir] = $iElixirCurrent
	$g_iStatsCurrent[$CurrentAccount][$eLootDarkElixir] = $iDarkCurrent
	$g_iStatsCurrent[$CurrentAccount][$eLootTrophy] = $iTrophyCurrent
	$g_iGemAmount[$CurrentAccount] = $iGemAmount
	$g_iFreeBuilderCount[$CurrentAccount] = $iFreeBuilderCount
	$g_iTotalBuilderCount[$CurrentAccount] = $iTotalBuilderCount
	;=======================End Group================================
	
	If $bBypass = False Then ; update stats
		UpdateStats($bForceUpdateAll)
	EndIf
	
	Local $i = 0
	While _ColorCheck(_GetPixelColor(819, 39, True), Hex(0xF8FCFF, 6), 20) = True ; wait for Builder/shop to close
		$i += 1
		If _Sleep($iDelayVillageReport1) Then Return
		If $i >= 20 Then ExitLoop
	WEnd

EndFunc   ;==>VillageReport
