; #FUNCTION# ====================================================================================================================
; Name ..........: Config save - Mod.au3
; Description ...: Extension of saveConfig() for Mod
; Syntax ........: saveConfig()
; Parameters ....: NA
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

	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))

	; Multi Finger (LunaEclipse)
	IniWrite($config, "MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger))

;
; DEMEN
;

	; Config save for SwitchAcc Mode - DEMEN
	If GUICtrlRead($radActiveProfile) = $GUI_CHECKED Then														; 1 = Active, 2 = Donate, 3 = Idle
		IniWrite($config, "Switch Account", "Profile Type", 1)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 1)
	 ElseIf GUICtrlRead($radDonateProfile) = $GUI_CHECKED Then
		IniWrite($config, "Switch Account", "Profile Type", 2)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 2)
	 Else
		IniWrite($config, "Switch Account", "Profile Type", 3)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 3)
	EndIf

	IniWrite($config, "Switch Account", "Match Profile Acc", _GUICtrlCombobox_GetCurSel($cmbMatchProfileAcc))	 ; 0 = No Acc (idle), 1 = Acc 1, 2 = Acc 2, etc.

	If GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED Then
		IniWrite($profile, "Switch Account", "Enable", 1)
	Else
		IniWrite($profile, "Switch Account", "Enable", 0)
	EndIf

	IniWrite($profile, "Switch Account", "Total Coc Account", _GUICtrlCombobox_GetCurSel($cmbTotalAccount))	; 0 = AutoDetect, 1 = 1 Acc, 2 = 2 Acc, etc.

	If GUICtrlRead($radSmartSwitch) = $GUI_CHECKED Then
	   IniWrite($profile, "Switch Account", "Smart Switch", 1)
	Else
	   IniWrite($profile, "Switch Account", "Smart Switch", 0)
	EndIf

	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
		If GUICtrlRead($radCloseCoC) = $GUI_CHECKED Then
			IniWrite($profile, "Switch Account", "Sleep Combo", 1)		; Sleep Combo = 1 => Close CoC
		Else
			IniWrite($profile, "Switch Account", "Sleep Combo", 2)		; Sleep Combo = 2 => Close Android
		EndIf
	Else
		IniWrite($profile, "Switch Account", "Sleep Combo", 0)
	EndIf

	For $i = 1 to 6
		IniWriteS($profile, "Acc Location", "yAccNo." & $i, $aAccPosY[$i-1])
	Next
