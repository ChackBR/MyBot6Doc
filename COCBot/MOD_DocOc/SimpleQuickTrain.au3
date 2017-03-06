; #FUNCTION# ====================================================================================================================
; Name ..........: SimpleQuickTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Chack++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SimpleQuickTrain( $NeedOpenArmy = False, $nLoop = 3 )
	Local $i
	Local $Num
	Setlog("Simple Quick Train")
	If $g_bRunState = False Then Return
	$Num = $g_iQuickTrainArmyNum
	If $NeedOpenArmy Then
		OpenArmyWindow()
		If _Sleep(500) Then Return
	EndIf
	OpenTrainTabNumber($QuickTrainTAB, "CheckCamp()")
	For $i = 1 TO $nLoop
		If _Sleep(500) Then Return
		If $Num > 1 Then
			If $Num > 2 Then
				TrainArmyNumber( $Num - 2 )
				If _Sleep(250) Then Return
			EndIf
			TrainArmyNumber( $Num - 1 )
			If _Sleep(250) Then Return
		EndIf
		TrainArmyNumber($Num)
		If _Sleep(500) Then Return
	Next
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

EndFunc	;==>SimpleQuickTrain
