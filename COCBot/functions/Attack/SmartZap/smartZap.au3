; #FUNCTION# ====================================================================================================================
; Name ..........: smartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: smartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(March, 2016)
; Modified ......: TheRevenor(November, 2016), ProMac(December, 2016), TheRevenor(December, 2016), TripleM(January, 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func displayZapLog($aDarkDrills, ByRef $Spells)
	; Create the log entry string
	Local $drillStealableString = "Drills Lvl/Estimated Amount left: "
	Local $spellsLeftString = "Spells left: "
	; Loop through the array and add results to the log entry string
	For $i = 0 To UBound($aDarkDrills) - 1
		If $i = 0 Then
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= "Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		Else
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= ", Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		EndIf
	Next
	If $Spells[0][4] + $Spells[1][4] + $Spells[2][4] = 0 Then
		$spellsLeftString &= "None"
	Else
		If $Spells[2][4] > 0 Then $spellsLeftString &= $Spells[2][4] & " " & NameOfTroop($Spells[2][1], 1)
		If $Spells[2][4] > 0 And $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= ", "
		If $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= $Spells[0][4] + $Spells[1][4] & " " & NameOfTroop($Spells[1][1], 1)
	EndIf
	; Display the drill string if it contains any information
	If $drillStealableString <> "Drills Lvl/Estimated Amount left: " Then
		If $ichkNoobZap = 0 Then
			SetLog($drillStealableString, $COLOR_INFO)
		Else
			If $DebugSmartZap = 1 Then SetLog($drillStealableString, $COLOR_DEBUG)
		EndIf
	EndIf
	If $spellsLeftString <> "Spells left: " Then
		SetLog($spellsLeftString, $COLOR_INFO)
	EndIf
EndFunc   ;==>displayZapLog

Func getDarkElixir()
	Local $searchDark = "", $iCount = 0

	;Setlog("Getting Dark Elixir Values.")
	If _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x282020, 6), 10) Or _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5) Then ; check if the village have a Dark Elixir Storage
		While $searchDark = ""
			$searchDark = getDarkElixirVillageSearch(48, 126) ; Get updated Dark Elixir value
			$oldSearchDark = $searchDark
			$iCount += 1
			;If $DebugSmartZap = 1 Then Setlog("$searchDark = " & Number($searchDark) & ", $oldSearchDark = " & Number($oldSearchDark), $COLOR_DEBUG)
			If $iCount > 15 Then ExitLoop ; Check a couple of times in case troops are blocking the image
			If _Sleep($DelaySmartZap1) Then Return
		WEnd
	Else
		$searchDark = False
		If $DebugSmartZap = 1 Then SetLog(" - No DE detected.", $COLOR_DEBUG)
	EndIf

	Return $searchDark
EndFunc   ;==>getDarkElixir

Func getDrillOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $iTownHallLevel
		Case 0 To 7
			$result = 2
		Case 8
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getDrillOffset

Func getSpellOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $iTownHallLevel
		Case 0 To 4
			$result = -1
		Case 5, 6
			; Town hall 5 and 6 have lightning spells, but why would you want to zap?
			$result = -1
		Case 7, 8
			$result = 2
		Case 9
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getSpellOffset

Func smartZap($minDE = -1)
	Local $searchDark, $oldSearchDark = 0, $performedZap = False, $dropPoint
	Local $aSpells [3][5] = [["Own", $eLSpell, -1, -1, 0 ] _		; Own/Donated, SpellType, AttackbarPosition, Level, Count
							, ["Donated", $eLSpell, -1, -1, 0] _
							, ["Donated", $eESpell, -1, -1, 0]]

	; If smartZap is not checked, exit.
	If $DebugSmartZap = 1 Then SetLog("$ichkSmartZap = " & $ichkSmartZap & " | $ichkNoobZap = " & $ichkNoobZap, $COLOR_DEBUG)
	If $ichkSmartZap <> 1 Then Return $performedZap
	If $ichkSmartZap = 1 And $ichkNoobZap = 0 Then
		SetLog("====== You have activated SmartZap Mode ======", $COLOR_ERROR)
	ElseIf $ichkNoobZap = 1 Then
		SetLog("====== You have activated NoobZap Mode ======", $COLOR_ERROR)
	EndIf

	; Use UI Setting if no Min DE is specified
	If $minDE = -1 Then $minDE = Number($itxtMinDE)

	; Get Dark Elixir value, if no DE value exists, exit.
	$searchDark = getDarkElixirVillageSearch(48, 126)
	If Number($searchDark) = 0 Then
		SetLog("No Dark Elixir so lets just exit!", $COLOR_INFO)
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
	EndIf

	; Check to see if the DE Storage is already full
	If isDarkElixirFull() Then
		SetLog("No need to zap!", $COLOR_INFO)
		If $DebugSmartZap = 1 Then SetLog("isDarkElixirFull(): " & isDarkElixirFull(), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("isDarkElixirFull(): " & isDarkElixirFull(), $COLOR_DEBUG)
	EndIf

	; Check to make sure the account is high enough level to store DE.
	If $iTownHallLevel < 7 Then
		SetLog("You do not have the ability to store Dark Elixir, time to go home!", $COLOR_ERROR)
		If $DebugSmartZap = 1 Then SetLog("Your Town Hall Lvl: " & Number($iTownHallLevel), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("Your Town Hall Lvl: " & Number($iTownHallLevel), $COLOR_DEBUG)
	EndIf

	; Check to ensure there is at least the minimum amount of DE available.
	If (Number($searchDark) < Number($minDE)) Then
		SetLog("Dark Elixir is below minimum value [" & Number($itxtMinDE) & "], Exiting Now!", $COLOR_INFO)
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("$searchDark = " & Number($searchDark) & " | $itxtMinDE = " & Number($itxtMinDE), $COLOR_DEBUG)
	EndIf

	If $DebugSmartZap = 1 Then
		SetLog("$itxtExpectedDE| Expected DE value:" & Number($itxtExpectedDE), $COLOR_DEBUG)
		SetLog("$ichkTimeStopAtk[$DB] = " & $ichkTimeStopAtk[$DB] & ", $txtDBTimeStopAtk = " & $sTimeStopAtk[$DB] & "s", $COLOR_DEBUG)
	EndIf

	; Check match mode
	If $DebugSmartZap = 1 Then SetLog("$ichkSmartZapDB = " & $ichkSmartZapDB, $COLOR_DEBUG)
	If $ichkSmartZapDB = 1 And $iMatchMode <> $DB Then
		SetLog("Not a dead base so lets just go home!", $COLOR_INFO)
		Return $performedZap
	EndIf

	; Get the number of lightning/EQ spells
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $eLSpell Then
			If $aSpells[0][4] = 0 Then
				If $DebugSmartZap = 1 Then SetLog(NameOfTroop($atkTroops[$i][0], 0) & ": " & $atkTroops[$i][1], $COLOR_DEBUG)
				$aSpells[0][2] = $i
				$aSpells[0][3] = Number($GlobalLSpelllevel)		; Get the Level on Attack bar
				$aSpells[0][4] = $atkTroops[$i][1]
			Else
				If $DebugSmartZap = 1 Then SetLog("Donated " & NameOfTroop($atkTroops[$i][0], 0) & ": " & $atkTroops[$i][1], $COLOR_DEBUG)
				$aSpells[1][2] = $i
				$aSpells[1][3] = Number($GlobalLSpelllevel)		; Get the Level on Attack bar
				$aSpells[1][4] = $atkTroops[$i][1]
			EndIf
		EndIf
		If $atkTroops[$i][0] = $eESpell Then
			If $DebugSmartZap = 1 Then SetLog(NameOfTroop($atkTroops[$i][0], 0) & ": " & $atkTroops[$i][1], $COLOR_DEBUG)
			$aSpells[2][2] = $i
			$aSpells[2][3] = Number($GlobalEQSpelllevel)		; Get the Level on Attack bar
			$aSpells[2][4]= $atkTroops[$i][1]
		EndIf
	Next

	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & NameOfTroop($aSpells[0][1], 1) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & NameOfTroop($aSpells[1][1], 1) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf

	If $aSpells[2][4] > 0 And $ichkEarthQuakeZap = 1 Then
		SetLog(" - Number of " & NameOfTroop($aSpells[2][1], 1) & " (Lvl " & $aSpells[2][3] & "): " & Number($aSpells[2][4]), $COLOR_INFO)
    Else
		$aSpells[2][4] = 0 ; remove the EQ , is not to use it
	EndIf

	; Get Drill locations and info
	Local $aDarkDrills = drillSearch()
	
	Local $strikeOffsets = [0, 12]
	Local $drillLvlOffset, $spellAdjust, $numDrills, $testX, $testY, $tempTestX, $tempTestY, $strikeGain, $expectedDE
	Local $error = 5 ; 5 pixel error margin for DE drill search

	; Get the number of drills
	If UBound($aDarkDrills) = 0 Then
		SetLog("No drills found, time to go home!", $COLOR_INFO)
		Return $performedZap
	Else
		SetLog(" - Number of Dark Elixir Drills: " & UBound($aDarkDrills), $COLOR_INFO)
	EndIf

	_ArraySort($aDarkDrills, 1, 0, 0, 3)

	; Offset the drill level based on town hall level
	$drillLvlOffset = getDrillOffset()
	If $DebugSmartZap = 1 Then SetLog("Drill Level Offset is: " & Number($drillLvlOffset), $COLOR_DEBUG)

	; Offset the number of spells based on town hall level
	$spellAdjust = getSpellOffset()
	If $DebugSmartZap = 1 Then SetLog("Spell Adjust is: " & Number($spellAdjust), $COLOR_DEBUG)

	Local $itotalStrikeGain = 0

	; Loop while you still have spells and the first drill in the array has Dark Elixir, if you are town hall 7 or higher
	While IsAttackPage() And $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > 0 And UBound($aDarkDrills) > 0 And $spellAdjust <> -1
		Local $Spellused = $eLSpell
		Local $skippedZap = True
		; Store the DE value before any Zaps are done.
		Local $oldSearchDark = $searchDark
		CheckHeroesHealth()

		If ($searchDark < Number($itxtMinDE)) Then
			SetLog("Dark Elixir is below minimum value [" & Number($itxtMinDE) & "], Exiting Now!", $COLOR_INFO)
			Return $performedZap
		EndIf

		; Create the log entry string for amount stealable
		displayZapLog($aDarkDrills, $aSpells)

		; If you activate N00bZap, drop lightning on any DE drill
		If $ichkNoobZap = 1 Then
			SetLog("NoobZap is going to attack any drill.", $COLOR_ACTION)
			$Spellused = zapDrill($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

			$performedZap = True
			$skippedZap = False
			If _Sleep($DelaySmartZap4) Then Return
		Else
			; If you have max lightning spells, drop lightning on any level DE drill
			If $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (4 - $spellAdjust) Then
				SetLog("First condition: " & 4 - $spellAdjust & "+ Spells so attack any drill.", $COLOR_INFO)
				$Spellused = zapDrill($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False
				If _Sleep($DelaySmartZap4) Then Return

				; If you have one less then max, drop it on drills level (3 - drill offset)
			ElseIf $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (3 - $spellAdjust) And $aDarkDrills[0][2] > (3 - $drillLvlOffset) Then
				SetLog("Second condition: Attack Lvl " & 3 - Number($drillLvlOffset) & "+ drills if you have " & 3 - Number($spellAdjust) & "+ spells", $COLOR_INFO)
				$Spellused = zapDrill($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False
				If _Sleep($DelaySmartZap4) Then Return

				; If the collector is higher than lvl (4 - drill offset) and collector is estimated more than 30% full
			ElseIf $aDarkDrills[0][2] > (4 - $drillLvlOffset) And ($aDarkDrills[0][3] / $aDrillLevelHold[$aDarkDrills[0][2] - 1]) > 0.3 Then
				SetLog("Third condition: Attack Lvl " & 4 - Number($drillLvlOffset) & "+ drills with more then 30% estimated DE if you have less than " & 4 - Number($spellAdjust) & " spells", $COLOR_INFO)
				$Spellused = zapDrill($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False
				If _Sleep($DelaySmartZap4) Then Return

			Else
				$skippedZap = True
				SetLog("Drill did not match any attack conditions, so we will remove it from the list.", $COLOR_ACTION)
				_ArrayDelete($aDarkDrills, 0)
			EndIf
		EndIf

		; Get the DE Value after SmartZap has performed its actions.
		$searchDark = getDarkElixir()

		; No Dark Elixir Left
		If Not $searchDark Or $searchDark = 0 Then
			SetLog("No Dark Elixir so lets just exit!", $COLOR_INFO)
			SetDebugLog("$searchDark = " & Number($searchDark))
			Return $performedZap
		Else
			If $DebugSmartZap = 1 Then SetLog("$searchDark = " & Number($searchDark), $COLOR_DEBUG)
		EndIf

		; Check to make sure we actually zapped
		If $skippedZap = False Then
			If $DebugSmartZap = 1 Then Setlog("$oldSearchDark = [" & Number($oldSearchDark) & "] - $searchDark = [" & Number($searchDark) & "]", $COLOR_DEBUG)
			$strikeGain = Number($oldSearchDark - $searchDark)
			If $DebugSmartZap = 1 Then Setlog("$strikeGain = " & Number($strikeGain), $COLOR_DEBUG)

			If $Spellused = $eESpell  Then
				$iNumEQSpellsUsed += 1
				$expectedDE = Ceiling(Number($aDrillLevelTotal[$aDarkDrills[0][2] - 1] * $fDarkStealFactor * $aEQSpellDmg[$aSpells[2][3] - 1] * $fDarkFillLevel))
			Else
				$iNumLSpellsUsed += 1
				If $ichkNoobZap = 0 Then
					$expectedDE = Ceiling(Number($aDrillLevelTotal[$aDarkDrills[0][2] - 1] / $aDrillLevelHP[$aDarkDrills[0][2] - 1] * $fDarkStealFactor * $aLSpellDmg[$aSpells[0][3] - 1] * $fDarkFillLevel))
				Else
					$expectedDE = $itxtExpectedDE
				EndIf
			EndIf

			If $DebugSmartZap = 1 Then Setlog("$expectedDE = " & Number($expectedDE), $COLOR_DEBUG)

			; If change in DE is less than expected, remove the Drill from list. else, subtract change from assumed total
			If $strikeGain < $expectedDE And $expectedDE <> -1 Then
				_ArrayDelete($aDarkDrills, 0)
				SetLog("Gained: " & $strikeGain & ", Expected: " & $expectedDE, $COLOR_INFO)
				SetLog("Last zap gained less DE then expected, removing the drill from the list.", $COLOR_ACTION)
			ElseIf Not ReCheckDrillExist($aDarkDrills[0][0], $aDarkDrills[0][1]) Then ; Recheck will detect IF exist the drill or was destroyed
				; Was destroyed let's remove the drill from array
				_ArrayDelete($aDarkDrills, 0)
				SetLog("Gained: " & Number($strikeGain) & ", drill was destroyed.", $COLOR_INFO)
			Else
				$aDarkDrills[0][3] -= $strikeGain
				SetLog("Gained: " & Number($strikeGain) & ", adjusting amount left in this drill.", $COLOR_INFO)
			EndIf

			$itotalStrikeGain += $strikeGain
			$iSmartZapGain += $strikeGain
			SetLog("Total DE from SmartZap/NoobZap: " & Number($itotalStrikeGain), $COLOR_INFO)

		EndIf

		; Resort the array
		_ArraySort($aDarkDrills, 1, 0, 0, 3)

		If _Sleep($DelaySmartZap1) Then Return
	WEnd

	Return $performedZap
EndFunc   ;==>smartZap

; This function taken and modified by the CastSpell function to make Zapping works
Func zapDrill(ByRef $Spells, $x, $y)
	Local $iSpell
	For $i = 0 to UBound($Spells) - 1
		If $Spells[$i][4] > 0 Then
			$iSpell = $i
		EndIf
	Next 
	If $Spells[$iSpell][2] > -1 Then
		SetLog("Dropping " & $Spells[$iSpell][0] & " " & String(NameOfTroop($Spells[$iSpell][1], 0)), $COLOR_ACTION)
		SelectDropTroop($Spells[$iSpell][2])
		If _Sleep($iDelayCastSpell1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
		$Spells[$iSpell][4] -= 1
	Else
		If $DebugSmartZap = 1 Then SetLog("No " & String(NameOfTroop($Spells[$iSpell][1], 0)) & " Found", $COLOR_DEBUG)
	EndIf
	Return $Spells[$iSpell][1]
EndFunc   ;==>zapDrill

Func ReCheckDrillExist($x, $y)
	If _Sleep($DelaySmartZap4) Then Return ; 4 seconds to disappear dust and bars
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 1

	Local $aResult = multiMatches($directory, $Maxpositions, "FV", "FV", "", 0, 1000, False) ; Setting Force Captureregion to false, else it will recapture the whole screen, finding any drill

	If UBound($aResult) > 1 Then
		If $DebugSmartZap = 1 Then SetLog("ReCheckDrillExist: Yes| " & UBound($aResult), $COLOR_SUCCESS)
		Return True
	Else
		If $DebugSmartZap = 1 Then SetLog("ReCheckDrillExist: No| " & UBound($aResult), $COLOR_ERROR)
	EndIf
	Return False
EndFunc   ;==>ReCheckDrillExist
