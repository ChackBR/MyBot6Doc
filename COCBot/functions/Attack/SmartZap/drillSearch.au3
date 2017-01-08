; #FUNCTION# ====================================================================================================================
; Name ..........: drillSearch
; Description ...: Searches for the DE Drills in the base, and returns; X, Y location, and Level
; Syntax ........: drillSearch()
; Parameters ....: None
; Return values .: Array with data on Dark Elixir Drills found in search
; Author ........: TripleM(January, 2017)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func drillSearch()
	Local $aReturnResult[0][4]
	Local $pixelerror = 15

	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 0 ; Return all found Positions
	Local $aResult = multiMatches($directory, $Maxpositions, "ECD", "ECD")

	For $iResult = 1 To UBound($aResult) - 1 			; Loop through all resultrows, skipping first row, which is searcharea, each matched img has its own row, if no resultrow, for is skipped
		If _Sleep(10) Then Return
		Local $aTemp[0][2]
		_ArrayAdd($aTemp, $aResult[$iResult][5]) 		; Copy Positionarray to temp array
		_ArrayColInsert($aTemp, 2)						; Adding Level Column
		_ArrayColInsert($aTemp, 3)						; Adding Hold Column
		For $iRow = 0 To UBound($aTemp) - 1
			$aTemp[$iRow][2] = $aResult[$iResult][2] 	; Setting Level Column to Result Level
		Next
		_ArrayAdd($aReturnResult, $aTemp)				; Adding temp array to return array
	Next

	Local $iResult = 0
	While $iResult < Ubound($aReturnResult)
		If _Sleep(10) Then Return
		; Removing Duplicate Drills
		Local $jResult = $iResult + 1
		While $jResult < Ubound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) <= $pixelerror And Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $pixelerror Then
				$aReturnResult[$iResult][2] = _Min(Number($aReturnResult[$iResult][2]), Number($aReturnResult[$jResult][2]))
				If $DebugSmartZap = 1 Then 
					SetLog("Found Duplicate Dark Elixir Drill: [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "], Level: " & $aReturnResult[$jResult][2], $COLOR_DEBUG)
				EndIf
				_ArrayDelete($aReturnResult, $jResult)
			EndIf
			$jResult += 1
		WEnd
		; Correcting Drilllevel
		Local $iDrillLevel = CheckDrillLvl($aReturnResult[$iResult][0], $aReturnResult[$iResult][1])
		If $iDrillLevel > 0 And $aReturnResult[$iResult][2] <> $iDrillLevel Then
			If $DebugSmartZap = 1 Then SetLog("Correcting Drill Level, old = " & $aReturnResult[$iResult][2] & ", new = " & $iDrillLevel, $COLOR_DEBUG)
			$aReturnResult[$iResult][2] = $iDrillLevel
		EndIf
		; Adjusting Hold
		$aReturnResult[$iResult][3] = Ceiling(Number($aDrillLevelTotal[$aReturnResult[$iResult][2] - 1] * $fDarkStealFactor))
		If $DebugSmartZap = 1 Then 
			SetLog(($iResult + 1) & ". Valid Drill: [" & $aReturnResult[$iResult][0] & "," & $aReturnResult[$iResult][1] & "], Level: " & $aReturnResult[$iResult][2] & ", Hold: " & $aReturnResult[$iResult][3], $COLOR_DEBUG)
		EndIf
		$iResult += 1
	WEnd

	Return $aReturnResult
EndFunc   ;==>drillSearch

Func CheckDrillLvl($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills_lv"
	Local $Maxpositions = 1

	Local $aResult = multiMatches($directory, $Maxpositions, "FV", "FV", "", 0, 1000, False)

	If $DebugSmartZap = 1 Then SetLog("CheckDrillLvl: UBound($aresult) = " & UBound($aResult), $COLOR_DEBUG)
	If UBound($aResult) > 1 Then
		If $DebugSmartZap = 1 Then SetLog("CheckDrillLvl: $aresult[" & (UBound($aResult) - 1) & "][2] = " & $aResult[UBound($aResult) - 1][2], $COLOR_DEBUG)
		Return $aResult[UBound($aResult) - 1][2]
	EndIf
	Return 0
EndFunc   ;==>CheckDrillLvl
