; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckHeroesHealth()

	If $checkKPower Or $checkQPower Or $checkWPower Then
		ForceCaptureRegion() ; ensure no screenshot caching kicks in

		Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aKingHealthCopy[0] = GetXPosOfArmySlot($King, 68) + 2
		Local $aQueenHealthCopy = $aQueenHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aQueenHealthCopy[0] = GetXPosOfArmySlot($Queen, 68) + 3
		Local $aWardenHealthCopy = $aWardenHealth
		$aWardenHealthCopy[0] = GetXPosOfArmySlot($Warden, 68)
		If _Sleep($iDelayRespond) Then Return ; improve pause button response

		If $debugSetlog = 1 Then
			Setlog(" CheckHeroesHealth started ")
			Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $bCapturePixel)
			Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $bCapturePixel)
			Local $WardenPixelColor = _GetPixelColor($aWardenHealthCopy[0], $aWardenHealthCopy[1], $bCapturePixel)
		EndIf

		If $checkKPower And $iActivateKQCondition = "Auto" Then
			If $debugSetlog = 1 Then Setlog(" King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aKingHealthCopy, $bCapturePixel, "Red") Then
				SetLog("King is getting weak, Activating King's power", $COLOR_INFO)
				SelectDropTroop($King)
				$checkKPower = False
				$HeroesTimerActivation[0] = 0 ; Reset Timer
			EndIf
		EndIf
		If $checkQPower And $iActivateKQCondition = "Auto" Then
			If $debugSetlog = 1 Then Setlog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aQueenHealthCopy, $bCapturePixel, "Red") Then
				SetLog("Queen is getting weak, Activating Queen's power", $COLOR_INFO)
				SelectDropTroop($Queen)
				$checkQPower = False
				$HeroesTimerActivation[1] = 0 ; Reset Timer
			EndIf
		EndIf
		If $checkWPower And $iActivateWardenCondition = 0 And $iActivateKQCondition = "Auto" Then
			If $debugSetlog = 1 Then Setlog(" Grand Warden _GetPixelColor(" & $aWardenHealthCopy[0] & "," & $aWardenHealthCopy[1] & "): " & $WardenPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aWardenHealthCopy, $bCapturePixel, "Red") Then
				SetLog("Grand Warden is getting weak, Activating Warden's power", $COLOR_INFO)
				SelectDropTroop($Warden)
				$checkWPower = False
				$HeroesTimerActivation[2] = 0 ; Reset Timer
			EndIf
		EndIf

		If $iActivateKQCondition = "Manual" Or $iActivateWardenCondition = 1 Then

			Local $CorrectTimer[3] = [0, 0, 0] ; seconds

			If $HeroesTimerActivation[0] <> 0 Then $CorrectTimer[0] = Ceiling(TimerDiff($HeroesTimerActivation[0]) / 1000) ; seconds
			If $HeroesTimerActivation[1] <> 0 Then $CorrectTimer[1] = Ceiling(TimerDiff($HeroesTimerActivation[1]) / 1000) ; seconds
			If $HeroesTimerActivation[2] <> 0 Then $CorrectTimer[2] = Ceiling(TimerDiff($HeroesTimerActivation[2]) / 1000) ; seconds


			If $checkKPower And $iActivateKQCondition = "Manual" Then
				If $delayActivateKQ / 1000 <= $CorrectTimer[0] Then
					SetLog("Activating King's power", $COLOR_INFO)
					SetLog("Activating after " & $CorrectTimer[0] & "'s", $COLOR_INFO)
					SelectDropTroop($King)
					$checkKPower = False
					$HeroesTimerActivation[0] = 0 ; Reset Timer
				EndIf
			EndIf

			If $checkQPower And $iActivateKQCondition = "Manual" Then
				If $delayActivateKQ / 1000 <= $CorrectTimer[1] Then
					SetLog("Activating Queen's power", $COLOR_INFO)
					SetLog("Activating after " & $CorrectTimer[1] & "'s", $COLOR_INFO)
					SelectDropTroop($Queen)
					$checkQPower = False
					$HeroesTimerActivation[1] = 0 ; Reset Timer
				EndIf
			EndIf

			If $checkWPower And ($iActivateKQCondition = "Manual" Or $iActivateWardenCondition = 1) Then
				If ($iActivateWardenCondition = 1 And $delayActivateW / 1000 <= $CorrectTimer[2]) Or _  	; check the forced timer just for Warden
					($iActivateKQCondition = "Manual" And $delayActivateKQ / 1000 <= $CorrectTimer[2]) Then ; check regulat timer from ALL heroes
					SetLog("Activating Warden's power", $COLOR_INFO)
					SetLog("Activating after " & $CorrectTimer[2] & "'s", $COLOR_INFO)
					SelectDropTroop($Warden)
					$checkWPower = False
					$HeroesTimerActivation[2] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return ; improve pause button response
	EndIf
EndFunc   ;==>CheckHeroesHealth

