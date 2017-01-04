; #FUNCTION# ====================================================================================================================
; Name ..........: drillSearch
; Description ...: Searches for the DE Drills in the base, and returns; X, Y location, and Level
; Syntax ........: drillSearch()
; Parameters ....: None
; Return values .: Array with data on Dark Elixir Drills found in search
; Author ........: LunaEclipse(March, 2016)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getNumberOfDrills($listPixelByLevel = -1)
	Local $aReturn
	Local $result = 0

	; Check to see if the function was passed an array with drill information
	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	If $listPixelByLevel[1] <> "" Then $result = $listPixelByLevel[0]
	If $DebugSmartZap = 1 Then SetLog("Total No. of Dark Elixir Drills = " & $result, $COLOR_DEBUG)

	Return $result
EndFunc   ;==>getNumberOfDrills

Func fillDrillArray($listPixelByLevel = -1)
	Local $result[0][5]
	
	Local $pixel[2], $pixelWithLevel, $level, $pixelStr
	Local $numDrills = getNumberOfDrills($listPixelByLevel)
	Local $invalid = false, $pixelerror = 5 ; 5 pixel error margin for DE drill search

	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	If $numDrills > 0 Then
		For $i = 1 To $numDrills
			$pixelWithLevel = StringSplit($listPixelByLevel[$i], "#")
			; If the string delimiter is not found, then try next string.
			If @error Then ContinueLoop

			If $DebugSmartZap = 1 Then
				Setlog("Drill search UBound($pixelWithLevel) = " & UBound($pixelWithLevel) - 1, $COLOR_DEBUG)
				For $j = 0 To UBound($pixelWithLevel) - 1
					Setlog("Drill search $pixelWithLevel[" & $j & "] = " & $pixelWithLevel[$j], $COLOR_DEBUG)
				Next
			EndIf

			$level = $pixelWithLevel[1]
			$pixelStr = StringSplit($pixelWithLevel[2], "-")
			$pixel[0] = $pixelStr[1]
			$pixel[1] = $pixelStr[2]

			; Debug Drill Search
			If $DebugSmartZap = 1 Then
				Setlog("Drill search $level = " & $level, $COLOR_DEBUG)
				For $j = 0 To UBound($pixelStr) - 1
					Setlog("Drill search $pixelStr[" & $j & "] = " & $pixelStr[$j], $COLOR_DEBUG)
				Next
			EndIf

			$invalid = false
			For $j = 0 To UBound($result) - 1
				If Abs($result[$j][0] - Number($pixel[0])) <= $pixelerror And Abs($result[$j][1] - Number($pixel[1])) <= $pixelerror Then
					$invalid = True
					ExitLoop
				EndIf
			Next

			If $invalid Then
				If $DebugSmartZap = 1 Then 
					SetLog("Dark Elixir Drill: [" & $pixel[0] & "," & $pixel[1] & "], Level: " & $level, $COLOR_DEBUG)
					SetLog("Found Duplicate Dark Elixir Drill", $COLOR_ERROR)
				EndIf
				ContinueLoop
			EndIf
			
			
			; Check to make sure the found drill is actually inside the valid COC Area
			If isInsideDiamond($pixel) Then
				Local $drill[1][5]
				$drill[0][0] = Number($pixel[0])
				$drill[0][1] = Number($pixel[1])
				$drill[0][2] = Number($level)
				$drill[0][3] = Ceiling(Number($aDrillLevelTotal[Number($level) - 1] * $fDarkStealFactor))
				$drill[0][4] = Ceiling(Number($drill[0][3] / $aDrillLevelHP[Number($level) - 1] * 400))
				_ArrayAdd($result, $drill)

				If $DebugSmartZap = 1 Then SetLog("Dark Elixir Drill: [" & $drill[0][0] & "," & $drill[0][1] & "], Level: " & $drill[0][2] & ", Hold: " & $drill[0][3] & ", Steal: " & $drill[0][4], $COLOR_DEBUG)
			Else
				If $DebugSmartZap = 1 Then 
					SetLog("Dark Elixir Drill: [" & $pixel[0] & "," & $pixel[1] & "], Level: " & $level, $COLOR_DEBUG)
					SetLog("Found Dark Elixir Drill with an invalid location.", $COLOR_ERROR)
				EndIf
			EndIf
		Next
	EndIf

	If $DebugSmartZap = 1 Then SetLog("$numDrills = " & $numDrills & ", UBound($result) = " & UBound($result), $COLOR_DEBUG)

	For $j = 0 To UBound($result) - 1
		Local $drillLvl = CheckDrillLvl($result[$j][0], $result[$j][1])
		If $drillLvl > 0 And $drillLvl <> $result[$j][2] Then
			If $DebugSmartZap = 1 Then SetLog("Correcting Drill Level, old = " & $result[$j][2] & ", new = " & $drillLvl, $COLOR_DEBUG)
			$result[$j][2] = Number($drillLvl)
			$result[$j][3] = Ceiling(Number($aDrillLevelTotal[Number($drillLvl) - 1] * $fDarkStealFactor))
			$result[$j][4] = Ceiling(Number($result[$j][3] / $aDrillLevelHP[Number($drillLvl) - 1] * 400))
		EndIf
	Next
	Return $result
EndFunc   ;==>fillDrillArray

Func getDrillArray()
	Local $result, $listPixelByLevel
	Local $numDrills = 0

	; Capture the screen
	_CaptureRegion2()

	; Get the results of a drill search
	$result = GetLocationDarkElixirWithLevel()
	; Split DLL return into an array
	$listPixelByLevel = StringSplit($result, "~")

	; Debugging purposes only
	If $DebugSmartZap = 1 Then
		Setlog("Drill search $result[0] = " & $result, $COLOR_DEBUG)

		; Get the number of drills for the loop
		$numDrills = getNumberOfDrills($listPixelByLevel)
		If $numDrills > 0 Then
			For $i = 1 To $numDrills
				; Debug the array entries.
				Setlog("Drill search $listPixelByLevel[" & $i & "] = " & $listPixelByLevel[$i], $COLOR_DEBUG)
			Next
		EndIf
	EndIf

	Return $listPixelByLevel
EndFunc   ;==>getDrillArray

Func drillSearch($listPixelByLevel = -1)
	; Not using SmartZap so lets just exit now
	If $ichkSmartZap <> 1 Then Return False

	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	Return fillDrillArray($listPixelByLevel)
EndFunc   ;==>drillSearch

Func CheckDrillLvl($x, $y)
	_CaptureRegion2($x - 50, $y - 50, $x + 40, $y + 40)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills\SmartZap"
	Local $Maxpositions = 1

	Local $aResult = multiMatches($directory, $Maxpositions, "FV", "FV")

	If $DebugSmartZap = 1 Then SetLog("CheckDrillLvl: UBound($aresult) = " & UBound($aresult), $COLOR_DEBUG)
	If UBound($aresult) > 1 Then
		Return $aresult[1][2]
	Else
		Return 0
	EndIf
EndFunc   ;==>CheckDrillLvl
