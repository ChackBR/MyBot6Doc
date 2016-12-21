; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........:
; Parameters ....:
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; MOD Config - Save Data
;

	;Max logout time
	If $TrainLogoutMaxTime = 1 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_CHECKED)
	ElseIf $TrainLogoutMaxTime = 0 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtTrainLogoutMaxTime, $TrainLogoutMaxTimeTXT)

	; Multi Finger (LunaEclipse)
	_GUICtrlComboBox_SetCurSel($cmbDBMultiFinger,$iMultiFingerStyle)
	cmbDBMultiFinger()

	;
	; SSA
	;

	If $ichkSwitchAccount = 1 Then
		GUICtrlSetState($chkEnableSwitchAccount, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkEnableSwitchAccount, $GUI_UNCHECKED)
	EndIf
	_GUICtrlComboBox_SetCurSel($cmbAccountsQuantity, $icmbAccountsQuantity)

	For $i = 1 To 5
		If $ichkCanUse[$i] = 1 Then
			GUICtrlSetState($chkCanUse[$i], $GUI_CHECKED)
		Else
			GUICtrlSetState($chkCanUse[$i], $GUI_UNCHECKED)
		EndIf
		If $ichkDonateAccount[$i] = 1 Then
			GUICtrlSetState($chkDonateAccount[$i], $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDonateAccount[$i], $GUI_UNCHECKED)
		EndIf
		_GUICtrlComboBox_SetCurSel($cmbAccount[$i], $icmbAccount[$i])
	Next

	chkSwitchAccount()
