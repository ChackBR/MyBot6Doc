; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...:
; Syntax ........:
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

	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))

	; Multi Finger (LunaEclipse)
	IniWrite($config, "MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger))

	; SSA
	IniWrite($SSAConfig, "SwitchAccount", "chkEnableSwitchAccount", $ichkSwitchAccount)
	IniWrite($SSAConfig, "SwitchAccount", "cmbAccountsQuantity", _GUICtrlComboBox_GetCurSel($cmbAccountsQuantity))
	For $i = 1 To 5
		IniWrite($SSAConfig, "SwitchAccount", "chkCanUse[" & $i & "]", $ichkCanUse[$i])
		IniWrite($SSAConfig, "SwitchAccount", "chkDonateAccount[" & $i & "]", $ichkDonateAccount[$i])
		IniWrite($SSAConfig, "SwitchAccount", "cmbAccount[" & $i & "]", _GUICtrlComboBox_GetCurSel($cmbAccount[$i]))
	Next
