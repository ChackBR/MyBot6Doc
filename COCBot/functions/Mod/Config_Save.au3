;
; MOD Config - Save Data
;

	; DEB - by AwesomeGamer
	If GUICtrlRead($chkDontRemove) = $GUI_CHECKED Then
		IniWriteS($config, "troop", "DontRemove", 1)
	Else
		IniWriteS($config, "troop", "DontRemove", 0)
	EndIf

	If GUICtrlRead($chkBarrackSpell) = $GUI_CHECKED Then
		IniWrite($config, "Spells", "BarrackSpell", 1)
	Else
		IniWrite($config, "Spells", "BarrackSpell", 0)
	EndIf

	; SmartZap - by LunaEclipse
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		IniWrite($config, "SmartZap", "UseSmartZap", 1)
	Else
		IniWrite($config, "SmartZap", "UseSmartZap", 0)
	EndIf
	If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
		IniWrite($config, "SmartZap", "ZapDBOnly", 1)
	Else
		IniWrite($config, "SmartZap", "ZapDBOnly", 0)
	EndIf
	If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
		IniWrite($config, "SmartZap", "THSnipeSaveHeroes", 1)
	Else
		IniWrite($config, "SmartZap", "THSnipeSaveHeroes", 0)
	EndIf
	IniWrite($config, "SmartZap", "MinDE", GUICtrlRead($txtMinDark))

	; No League Search
	If GUICtrlRead($chkDBNoLeague) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBNoLeague", 1)
	Else
		IniWrite($config, "search", "DBNoLeague", 0)
	EndIf

	If GUICtrlRead($chkABNoLeague) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABNoLeague", 1)
	Else
		IniWrite($config, "search", "ABNoLeague", 0)
	EndIf

   ; CSV Deployment Speed Mod
	IniWriteS($config, "attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
	IniWriteS($config, "attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])

	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))

    ; SwitchAcc Mode - DEMEN
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
