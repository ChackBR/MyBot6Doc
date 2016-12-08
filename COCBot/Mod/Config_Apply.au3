; #FUNCTION# ====================================================================================================================
; Name ..........: Config apply - Mod.au3
; Description ...: Extension of applyConfig() for Mod
; Syntax ........: applyConfig()
; Parameters ....:
; Return values .:
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

;
; DEMEN
;

	; Config Apply for SwitchAcc Mode - DEMEN
	Switch $ProfileType
	Case 1
	   GUICtrlSetState($radActiveProfile, $GUI_CHECKED)
	Case 2
	   GUICtrlSetState($radDonateProfile, $GUI_CHECKED)
	Case 3
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	EndSwitch

	_GUICtrlCombobox_SetCurSel($cmbMatchProfileAcc, $MatchProfileAcc)

 	If $ichkSwitchAcc = 1 Then
 		GUICtrlSetState($chkSwitchAcc, $GUI_CHECKED)
 	Else
 		GUICtrlSetState($chkSwitchAcc, $GUI_UNCHECKED)
 	EndIf

	If $ichkSmartSwitch = 1 Then
	   GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
 	Else
	   GUICtrlSetState($radNormalSwitch, $GUI_CHECKED)
 	EndIf

	chkSwitchAcc()

	_GUICtrlCombobox_SetCurSel($cmbTotalAccount, $icmbTotalCoCAcc)	; 0 = AutoDetect

	If $ichkCloseTraining >= 1 Then
		GUICtrlSetState($chkUseTrainingClose, $GUI_CHECKED)
		If $ichkCloseTraining = 1 Then
			GUICtrlSetState($radCloseCoC, $GUI_CHECKED)
		Else
			GUICtrlSetState($radCloseAndroid, $GUI_CHECKED)
		EndIf
	Else
		GUICtrlSetState($chkUseTrainingClose, $GUI_UNCHECKED)
	EndIf
	EndIf
	GUICtrlSetData($txtTrainLogoutMaxTime, $TrainLogoutMaxTimeTXT)	