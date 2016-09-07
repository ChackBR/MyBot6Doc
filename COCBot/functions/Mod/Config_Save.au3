;
; MOD Config - Save Data
;

	; by AwesomeGamer
	If GUICtrlRead($chkDontRemove) = $GUI_CHECKED Then
		IniWriteS($config, "troop", "DontRemove", 1)
	Else
		IniWriteS($config, "troop", "DontRemove", 0)
	EndIf

	; SmartZap Settings - Added by LunaEclipse
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