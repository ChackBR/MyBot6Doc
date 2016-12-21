; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Control - Mod
; Description ...: Extended GUI Control for Mod
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Classic FourFingers
Func cmbDeployAB() ; avoid conflict between FourFinger and SmartAttack - DEMEN
   If _GUICtrlCombobox_GetCurSel($cmbDeployAB) = 4 Then
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_UNCHECKED)
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_DISABLE)
   Else
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_ENABLE)
   EndIf
EndFunc

Func cmbDeployDB() ; avoid conflict between FourFinger and SmartAttack - DEMEN
   If _GUICtrlCombobox_GetCurSel($cmbDeployDB) = 4 Then
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_UNCHECKED)
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_DISABLE)
   Else
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_ENABLE)
	  cmbDBMultiFinger()
   EndIf
EndFunc

Func setupProfileComboBoxswitch()
	For $x = 0 To 5
		GUICtrlSetData($cmbAccount[$x], "", "")
	Next

	For $x = 0 To 5
		GUICtrlSetData($cmbAccount[$x], $profileString, "<No Profiles>")
	Next
EndFunc   ;==>setupProfileComboBoxswitch

Func randomSleep($SleepTime, $Range = 0)

	If $RunState = False Then Return
	If $Range = 0 Then $Range = Round($SleepTime / 5)
	$SleepTimeF = Random($SleepTime - $Range, $SleepTime + $Range, 1)
	If $DebugClick = 1 Then Setlog("Default sleep : " & $SleepTime & " - Random sleep : " & $SleepTimeF, $COLOR_ORANGE)
	If _Sleep($SleepTimeF) Then Return

EndFunc   ;==>randomSleep
