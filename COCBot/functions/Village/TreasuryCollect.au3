; #FUNCTION# ====================================================================================================================
; Name ..........: Treasury Collect
; Description ...: This file contains all functions of @RoroTiti's Treasury Collect feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti 14/01/2017
; Modified ......: ---
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

; ================================================== MAIN PART ================================================== ;

Func CollectTreasury()

	If $ichkEnableTrCollect = 1 Then

		Setlog("Collecting treasury...", $COLOR_INFO)

		If OpenTreasuryMenu() Then

			If _ColorCheck(_GetPixelColor(430, 510, True), "60AC10", 20) Then

				If $ichkForceTrCollect = 1 Then
					CollectTreasuryStand()
				Else

					Local $iNeedToCollect = 0

					If $ichkGoldTrCollect = 1 And (GUICtrlRead($txtMinGoldTrCollect) > $iGoldCurrent) Then
						Setlog("Gold amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkGoldTrCollect = 1 Then
						Setlog("Gold amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $ichkElxTrCollect = 1 And (GUICtrlRead($txtMinElxTrCollect) > $iElixirCurrent) Then
						Setlog("Elixir amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkElxTrCollect = 1 Then
						Setlog("Elixir amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $ichkDarkTrCollect = 1 And (GUICtrlRead($txtMinDarkTrCollect) > $iDarkCurrent) Then
						Setlog("Dark amount is below minimum, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkDarkTrCollect = 1 Then
						Setlog("Dark amount is above minimum...", $COLOR_ORANGE)
					EndIf

					If $ichkFullGoldTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 284, True), "40AC00", 20) Then
						Setlog("Gold is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkFullGoldTrCollect = 1 Then
						Setlog("Gold is not full...", $COLOR_ORANGE)
					EndIf

					If $ichkFullElxTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 318, True), "40AC00", 20) Then
						Setlog("Elixir is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkFullElxTrCollect = 1 Then
						Setlog("Elixir is not full...", $COLOR_ORANGE)
					EndIf

					If $ichkFullDarkTrCollect = 1 And _ColorCheck(_GetPixelColor(688, 351, True), "40AC00", 20) Then
						Setlog("Dark is full, need to collect treasury", $COLOR_SUCCESS1)
						$iNeedToCollect += 1
					ElseIf $ichkFullElxTrCollect = 1 Then
						Setlog("Dark is not full...", $COLOR_ORANGE)
					EndIf

					If $iNeedToCollect > 1 Then
						SetLog($iNeedToCollect & " conditions met to collect treasury, collecting...", $COLOR_ACTION1)
						CollectTreasuryStand()
					ElseIf $iNeedToCollect = 1 Then
						SetLog($iNeedToCollect & " condition met to collect treasury, collecting...", $COLOR_ACTION1)
						CollectTreasuryStand()
					Else
						SetLog("No condition met to collect treasury, skipping...", $COLOR_WARNING)
					EndIf

				EndIf

			Else
				SetLog("Collect button unavailable, treasury empty... skipping...", $COLOR_WARNING)
			EndIf
		EndIf

	EndIf

EndFunc   ;==>CollectTreasury

Func CollectTreasuryStand()

	If _ColorCheck(_GetPixelColor(690, 210, True), "FFFFFF", 20) Then ; check treasury menu
		Click(435, 490)
		randomSleep(1500)

		If _ColorCheck(_GetPixelColor(520, 450, True), "60AD10", 20) And _ColorCheck(_GetPixelColor(590, 280, True), "E8E8E0", 20) Then ; check okay button
			Click(520, 430)
			SetLog("Treasury collected successfully", $COLOR_SUCCESS)
		Else
			SetLog("Error when trying to find Okay button... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to find Treasury menu... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>CollectTreasuryStand


Func OpenTreasuryMenu()

	If $aCCPos[0] = -1 Or $aCCPos[1] = -1 Then

		Setlog("Clan Castle unlocated, please, locate it manually. skipping...", $COLOR_ERROR)
		Return False

	Else

		Click($aCCPos[0], $aCCPos[1])
		randomSleep(1500)

		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Treasury", 480, 610, 650, 710) Then ; search for treasury button

			Click($QuickMISX + 480, $QuickMISY + 610)
			randomSleep(1500)

		Else
			SetLog("Error when trying to open Treasury menu... skipping...", $COLOR_WARNING)
			Return False
		EndIf
		Return True

	EndIf

EndFunc   ;==>OpenTreasuryMenu
; ================================================== GUI PART ================================================== ;

Func chkEnableTrCollect()

	If GUICtrlRead($chkEnableTrCollect) = $GUI_CHECKED Then
		$ichkEnableTrCollect = 1
		For $i = $chkForceTrCollect To $chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkResTrCollect()
		chkFullResTrCollect()
		chkForceTrCollect()
	Else
		$ichkEnableTrCollect = 0
		For $i = $chkForceTrCollect To $chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

EndFunc   ;==>chkEnableTrCollect

Func chkForceTrCollect()

	If GUICtrlRead($chkForceTrCollect) = $GUI_CHECKED Then
		$ichkForceTrCollect = 1
		For $i = $chkGoldTrCollect To $chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		$ichkForceTrCollect = 0
		For $i = $chkGoldTrCollect To $chkFullDarkTrCollect
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkResTrCollect()
		chkFullResTrCollect()
	EndIf

EndFunc   ;==>chkForceTrCollect

Func chkResTrCollect()

	If GUICtrlRead($chkGoldTrCollect) = $GUI_CHECKED Then
		$ichkGoldTrCollect = 1
		GUICtrlSetState($txtMinGoldTrCollect, $GUI_ENABLE)
	Else
		$ichkGoldTrCollect = 0
		GUICtrlSetState($txtMinGoldTrCollect, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkElxTrCollect) = $GUI_CHECKED Then
		$ichkElxTrCollect = 1
		GUICtrlSetState($txtMinElxTrCollect, $GUI_ENABLE)
	Else
		$ichkElxTrCollect = 0
		GUICtrlSetState($txtMinElxTrCollect, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkDarkTrCollect) = $GUI_CHECKED Then
		$ichkDarkTrCollect = 1
		GUICtrlSetState($txtMinDarkTrCollect, $GUI_ENABLE)
	Else
		$ichkDarkTrCollect = 0
		GUICtrlSetState($txtMinDarkTrCollect, $GUI_DISABLE)
	EndIf

	chkFullResTrCollect()

EndFunc   ;==>chkResTrCollect

Func chkFullResTrCollect()

	If GUICtrlRead($chkFullGoldTrCollect) = $GUI_CHECKED Then
		$ichkFullGoldTrCollect = 1
	Else
		$ichkFullGoldTrCollect = 0
	EndIf

	If GUICtrlRead($chkFullElxTrCollect) = $GUI_CHECKED Then
		$ichkFullElxTrCollect = 1
	Else
		$ichkFullElxTrCollect = 0
	EndIf

	If GUICtrlRead($chkFullDarkTrCollect) = $GUI_CHECKED Then
		$ichkFullDarkTrCollect = 1
	Else
		$ichkFullDarkTrCollect = 0
	EndIf

EndFunc   ;==>chkFullResTrCollect
