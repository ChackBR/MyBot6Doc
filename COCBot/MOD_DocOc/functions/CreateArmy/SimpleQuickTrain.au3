; #FUNCTION# ====================================================================================================================
; Name ..........: SmartQuickTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Functions used:
; 	getArmyCapacityOnTrainTroops($x_start, $y_start)   -> Gets quantity of troops in army Window
;	GetOCRCurrent($x_start, $y_start)
;	ISArmyWindow($writelogs = False, $TabNumber = 0)
;	OpenTrainTabNumber($Num)
; 	MakingDonatedTroops()
;	TrainArmyNumber($Num)
; 	QuickTrain()


Func SimpleQuickTrain()

	Setlog("Simple Quick Train")

	Local $CheckTroop[4] = [810, 186, 0xCFCFC8, 15] ; the gray background
	Local $FullTroopQueueSkipTrain = False
	Local $FullSpellQueueSkipTrain = False
	Local $iFillArcher = 0

	If $g_bRunstate = False Then Return

	OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1000) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 160)

	Setlog(" - Current queue/capacity: " & $ArmyCamp[0] & "/" & $ArmyCamp[1])

	$iFillArcher = ($ichkFillArcher = 1) ? GUICtrlRead($g_iTxtFillArcher) : 0

	Switch $ArmyCamp[0] - $ArmyCamp[1]
		Case -$ArmyCamp[1] To -$iFillArcher - 1
			SetLog(" »» Not full troop camp")

		Case -$iFillArcher To 0
			If $ArmyCamp[0] - $ArmyCamp[1] < 0 Then
				SetLog(" »» Fill some archers")
				Local $ArchToMake = $ArmyCamp[1] - $ArmyCamp[0]
				If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, 500)
				SetLog(" » Trained " & $ArchToMake & " archer(s)!")
			Else
				SetLog(" »» Zero queue")
			EndIf

		Case 1 To $ArmyCamp[1] - $iFillArcher - 1
			SetLog(" »» Not full queue. Delete queued troops")
			If ISArmyWindow(False, $TrainTroopsTAB) Then
				For $i = 0 To 11
					If _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then
						Local $x = 0
						While _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False
							If _Sleep(20) Then Return
							If $g_bRunstate = False Then Return
							PureClick($CheckTroop[0] - $i * 70, 202, 2, 50)
							$x += 1
							If $x = 250 Then ExitLoop
						WEnd
						ExitLoop
					EndIf
				Next
			EndIf

		Case $ArmyCamp[1] - $iFillArcher To $ArmyCamp[1]
			If $ArmyCamp[0] - $ArmyCamp[1] < $ArmyCamp[1] Then
				SetLog(" »» Fill some archers")
				Local $ArchToMake = $ArmyCamp[1] * 2 - $ArmyCamp[0]
				If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, 500)
				SetLog(" » Trained " & $ArchToMake & " archer(s)!")
			Else
				SetLog(" »» Full queue")
			EndIf
			$FullTroopQueueSkipTrain = True
	EndSwitch

	OpenTrainTabNumber($BrewSpellsTAB)
	If _Sleep(1000) Then Return
	If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return

	Local $SpellCamp = GetOCRCurrent(48, 160)
	Setlog(" - Current queue/capacity: " & $SpellCamp[0] & "/" & $SpellCamp[1])

	Switch $SpellCamp[0] - $SpellCamp[1]
		Case -$SpellCamp[1] To -1
			If $ichkFillEQ = 0 Or $SpellCamp[0] - $SpellCamp[1] < -1 Then
				SetLog(" »» Not full spell camp")
			Else
				SetLog(" »» Fill with 1 EQ spell")
				If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
				SetLog(" » Brewed 1 EQ spell!")
			EndIf

		Case 0
			SetLog(" »» Full spell camp, Zero queue")

		Case 1 To $SpellCamp[1] - 1

			If $ichkFillEQ = 0 Or $SpellCamp[0] - $SpellCamp[1] < $SpellCamp[1] - 1 Then
				SetLog(" »» Not full queue, Delete queued spells")
				If ISArmyWindow(False, $BrewSpellsTAB) Then
					SetLog(" »» Spell Tab open")
					For $i = 0 To 11
						If _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then
							Local $x = 0
							While _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False
								If _Sleep(20) Then Return
								If $g_bRunstate = False Then Return
								PureClick($CheckTroop[0] - $i * 70, 202, 2, 50)
								$x += 1
								If $x = 22 Then ExitLoop
							WEnd
							ExitLoop
						EndIf
					Next
				EndIf
			Else
				SetLog(" »» Fill with 1 EQ spell")
				If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
				SetLog(" » Brewed 1 EQ spell!")
			EndIf

		Case $SpellCamp[1]
			SetLog(" »» Full queue")
			$FullSpellQueueSkipTrain = True
	EndSwitch

	If $FullTroopQueueSkipTrain = False Or $FullSpellQueueSkipTrain = False Then MakeQuickTrain()

	ClickP($aAway, 2, 0, "#0000") ;Click Away

EndFunc   ;==>SimpleQuickTrain

Func MakeQuickTrain()

	If GUICtrlRead($hRadio_Army1) = $GUI_CHECKED Then QuickTrain(1, False, False)
	If GUICtrlRead($hRadio_Army2) = $GUI_CHECKED Then QuickTrain(2, False, False)
	If GUICtrlRead($hRadio_Army3) = $GUI_CHECKED Then QuickTrain(3, False, False)

EndFunc   ;==>MakeQuickTrain


