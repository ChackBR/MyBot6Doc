; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: Additional functions for UpdateStats
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func UpdateStatsForSwitchAcc()

	GUICtrlSetData($lblResultSkippedHourNow, $aSkippedVillageCountAcc[$nCurProfile -1])		;	Counting skipped village at Bottom GUI
	GUICtrlSetData($lblResultAttackedHourNow, $aAttackedCountAcc[$nCurProfile -1])			;	Counting attacked village at Bottom GUI

    For $i = 0 To 3
	   GUICtrlSetData($lblGoldLootAcc[$i], _NumberFormat($aGoldTotalAcc[$i]))
	   GUICtrlSetData($lblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aGoldTotalAcc[$i] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h")

	   GUICtrlSetData($lblElixirLootAcc[$i], _NumberFormat($aElixirTotalAcc[$i]))
	   GUICtrlSetData($lblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aElixirTotalAcc[$i] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h")

	   If $iDarkStart <> "" Then
		  GUICtrlSetData($lblDarkLootAcc[$i], _NumberFormat($aDarkTotalAcc[$i]))
		  GUICtrlSetData($lblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aDarkTotalAcc[$i] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h")
	   EndIf

	   GUICtrlSetData($lblResultGoldNowAcc[$i], _NumberFormat($aGoldCurrentAcc[$i], True))
	   GUICtrlSetData($lblResultElixirNowAcc[$i], _NumberFormat($aElixirCurrentAcc[$i], True))
	   If $iDarkStart <> "" Then
		  GUICtrlSetData($lblResultDeNowAcc[$i], _NumberFormat($aDarkCurrentAcc[$i], True))
	   EndIf
	   GUICtrlSetData($lblResultTrophyNowAcc[$i], _NumberFormat($aTrophyCurrentAcc[$i], True))
	   GUICtrlSetData($lblResultGemNowAcc[$i], _NumberFormat($aGemAmountAcc[$i], True))
	   GUICtrlSetData($lblResultBuilderNowAcc[$i], $aFreeBuilderCountAcc[$i] & "/" & $aTotalBuilderCountAcc[$i])
	Next		; ============= Update Gain stats per each account

	If $FirstAttack = 2 Then
		GUICtrlSetData($lblResultGoldHourNow, _NumberFormat(Round($aGoldTotalAcc[$nCurProfile-1] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($lblResultElixirHourNow, _NumberFormat(Round($aElixirTotalAcc[$nCurProfile-1] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		If $iDarkStart <> "" Then
			GUICtrlSetData($lblResultDEHourNow, _NumberFormat(Round($aDarkTotalAcc[$nCurProfile-1] / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf
	EndIf		; ============= Update Gain Stats at Bottom GUI

EndFunc   ;==>UpdateStatsForSwitchAcc

Func ResetStatsForSwitchAcc()

	For $i = 0 To $nTotalProfile-1 ; SwitchAcc Mod - Demen
	   $aGoldTotalAcc[$i] = 0
	   $aElixirTotalAcc[$i] = 0
	   $aDarkTotalAcc[$i] = 0
	   $aAttackedCountAcc[$i] = 0
	   $aSkippedVillageCountAcc[$i] = 0
	Next

EndFunc   ;==>ResetStatsForSwitchAcc

Func UpdateStatsForSmartZap()
	If $iOldSmartZapGain <> $smartZapGain Then
		GUICtrlSetData($lblSmartZap, _NumberFormat($smartZapGain, True))
		$iOldSmartZapGain = $smartZapGain
	EndIf

	If $iOldNumLTSpellsUsed <> $numLSpellsUsed Then
		GUICtrlSetData($lblLightningUsed, _NumberFormat($numLSpellsUsed, True))
		$iOldNumLTSpellsUsed = $numLSpellsUsed
 	EndIf
EndFunc    ;==>UpdateStatsForSmartZap

Func ResetStatsForSmartZap()

	$smartZapGain = 0
	$numLSpellsUsed = 0

EndFunc   ;==>ResetStatsForSmartZap

