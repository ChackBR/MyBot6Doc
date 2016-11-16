; #FUNCTION# ====================================================================================================================
; Name ..........: Config apply
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

	; by AwesomeGamer
	If $iChkDontRemove = 1 Then
		GUICtrlSetState($chkDontRemove, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDontRemove, $GUI_UNCHECKED)
	EndIf

	If $iChkBarrackSpell = 1 Then
		GUICtrlSetState($chkBarrackSpell, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkBarrackSpell, $GUI_UNCHECKED)
	EndIf
	
	; SmartZap Settings - Added by LunaEclipse
	If $ichkSmartZap = 1 Then
		GUICtrlSetState($chkSmartLightSpell, $GUI_CHECKED)
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkSmartLightSpell, $GUI_UNCHECKED)
	EndIf
	If $ichkSmartZapDB = 1 Then
		GUICtrlSetState($chkSmartZapDB, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_UNCHECKED)
	EndIf
	If $ichkSmartZapSaveHeroes = 1 Then
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtMinDark, $itxtMinDE)

	; No League Search
	If $iChkNoLeague[$DB] = 1 Then
		GUICtrlSetState($chkDBNoLeague, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDBNoLeague, $GUI_UNCHECKED)
	EndIf

	If $iChkNoLeague[$LB] = 1 Then
		GUICtrlSetState($chkABNoLeague, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkABNoLeague, $GUI_UNCHECKED)
	EndIf

	; CSV Deployment Speed Mod
	GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
	GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
	sldSelectedSpeedDB()
	sldSelectedSpeedAB()
	
	;Max logout time
	If $TrainLogoutMaxTime = 1 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_CHECKED)
	ElseIf $TrainLogoutMaxTime = 0 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtTrainLogoutMaxTime, $TrainLogoutMaxTimeTXT)	

   ; SwitchAcc- DEMEN
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
