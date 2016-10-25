; SmartZap Settings
Func chkSmartLightSpell()
    If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
        GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
        GUICtrlSetState($txtMinDark, $GUI_ENABLE)
        $ichkSmartZap = 1
    Else
        GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
        GUICtrlSetState($txtMinDark, $GUI_DISABLE)
        $ichkSmartZap = 0
    EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkSmartZapDB()
    If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
    Else
        $ichkSmartZapDB = 0
    EndIf
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
    Else
        $ichkSmartZapSaveHeroes = 0
    EndIf
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

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
   EndIf
EndFunc

; CSV Deployment Speed Mod
Func sldSelectedSpeedDB()
	$isldSelectedCSVSpeed[$DB] = GUICtrlRead($sldSelectedSpeedDB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$DB]] & "x";
	IF $isldSelectedCSVSpeed[$DB] = 4 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedDB, $speedText & " speed")
EndFunc   ;==>sldSelectedSpeedDB

Func sldSelectedSpeedAB()
	$isldSelectedCSVSpeed[$LB] = GUICtrlRead($sldSelectedSpeedAB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$LB]] & "x";
	IF $isldSelectedCSVSpeed[$LB] = 4 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedAB, $speedText & " speed")

EndFunc   ;==>sldSelectedSpeedAB

; Attack Now Button (Useful for CSV Testing) By MR.ViPeR ;;;;
Func AttackNowDB()
	If $RunState Then Return
	Sleep(2000)
	$iMatchMode = $DB			; Select Dead Base As Attack Type
	$iAtkAlgorithm[$DB] = 1		; Select Scripted Attack
	$scmbDBScriptName = GuiCtrlRead($cmbScriptNameDB)		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$iMatchMode = $DB			; Select Dead Base As Attack Type
	$RunState = True
	PrepareAttack($iMatchMode)	; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()					; Fire xD
	$RunState = False
EndFunc   ;==>AttackNow Dead Base

Func AttackNowAB()
	If $RunState Then Return
	Sleep(2000)
	$iMatchMode = $LB			; Select Live Base As Attack Type
	$iAtkAlgorithm[$LB] = 1		; Select Scripted Attack
	$scmbABScriptName = GuiCtrlRead($cmbScriptNameAB)		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$iMatchMode = $LB			; Select Live Base As Attack Type
	$RunState = True
	PrepareAttack($iMatchMode)	; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()					; Fire xD
	$RunState = False
EndFunc   ;==>AttackNow Live Base

; Actions While Training (SleepMode, HibernateMode, SwitchAcc) - DEMEN

 Func radProfileType()
	If GUICtrlRead($radIdleProfile) = $GUI_CHECKED Then
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	EndIf
	btnUpdateProfile()
 EndFunc   ;==>radProfileType

 Func cmbMatchProfileAcc()

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) = 0 Then
		GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	EndIf

    If _GUICtrlComboBox_GetCurSel($cmbTotalAccount) <> 0 And _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) > _GUICtrlComboBox_GetCurSel($cmbTotalAccount) Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] exceeds Total Account declared" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	   btnUpdateProfile()
	EndIf

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) <> 0 And _ArraySearch($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc)) <> -1 Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] has been assigned to Profile [" & _ArraySearch($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc)) + 1 & "]" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	   btnUpdateProfile()
	EndIf

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) <> 0 And UBound(_ArrayFindAll($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc))) > 1 Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] has been assigned to another profile" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	   btnUpdateProfile()
	EndIf

 EndFunc   ;==>cmbMatchProfileAcc

 Func btnUpdateProfile()

    saveConfig()
	setupProfile()
	readConfig()
	applyConfig()
	saveConfig()

   $ProfileList = _GUICtrlComboBox_GetListArray($cmbProfile)
   $nTotalProfile = _GUICtrlComboBox_GetCount($cmbProfile)

   For $i = 0 To 7
	  If $i <= $nTotalProfile - 1 Then
		 $aconfig[$i] = $sProfilePath & "\" & $ProfileList[$i + 1] & "\config.ini"
		 $aProfileType[$i] = IniRead($aconfig[$i], "Switch Account", "Profile Type", 3)
		 $aMatchProfileAcc[$i] = IniRead($aconfig[$i], "Switch Account", "Match Profile Acc", "")

		 If $i <= 3 Then
			For $j = $grpVillageAcc[$i] To $lblHourlyStatsDarkAcc[$i]
			   GUICtrlSetState($j, $GUI_SHOW)
			Next
		 EndIf

		 Switch $aProfileType[$i]
		 Case 1
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Active")
			GUICtrlSetState($lblProfileList[$i], $GUI_ENABLE)
			If $i <= 3 Then GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Active)")

		 Case 2
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Donate")
			GUICtrlSetState($lblProfileList[$i], $GUI_ENABLE)
			If $i <= 3 Then
			   GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Donate)")
			   For $j = $aStartHide[$i] To $lblHourlyStatsDarkAcc[$i]
				  GUICtrlSetState($j, $GUI_HIDE)
			   Next
			EndIf
		 Case 3
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Idle")
			GUICtrlSetState($lblProfileList[$i], $GUI_DISABLE)
			If $i <= 3 Then
			   GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Idle)")
			   For $j = $aStartHide[$i] To $lblHourlyStatsDarkAcc[$i]
				  GUICtrlSetState($j, $GUI_HIDE)
			   Next
			EndIf
		 EndSwitch

	  Else
		 GUICtrlSetData($lblProfileList[$i], "")
		 If $i <= 3 Then
			For $j = $grpVillageAcc[$i] to $lblHourlyStatsDarkAcc[$i]
			   GUICtrlSetState($j, $GUI_HIDE)
			Next
		 EndIf
	  EndIf
   Next

 EndFunc

 Func chkSwitchAcc()
	If GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED Then
	   If _GUICtrlComboBox_GetCount($cmbProfile) <= 1 Then
		  GUICtrlSetState($chkSwitchAcc, $GUI_UNCHECKED)
		  MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable SwitchAcc Mode" & @CRLF & "You have only " & _GUICtrlComboBox_GetCount($cmbProfile) & " Profile set", 30, $hGUI_BOT)
	   Else
		  For $i = $lblTotalAccount To $radNormalSwitch
			 GUICtrlSetState($i, $GUI_ENABLE)
		  Next
		  If GUICtrlRead($radNormalSwitch) = $GUI_CHECKED And GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
			 GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
		  EndIf
	   EndIf
	Else
		For $i = $lblTotalAccount To $radNormalSwitch
			 GUICtrlSetState($i, $GUI_DISABLE)
		  Next
	EndIf
 EndFunc   ;==>chkSwitchAcc

 Func radNormalSwitch()
	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
	   GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
	   MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable Sleep Mode together with Normal Switch Mode", 30, $hGUI_BOT)
	EndIf
 EndFunc   ;==>radNormalSwitch  - Normal Switch is not on the same boat with Sleep Combo

Func chkUseTrainingClose()
	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED And GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED And GUICtrlRead($radNormalSwitch) = $GUI_CHECKED Then
	   GUICtrlSetState($chkUseTrainingClose, $GUI_UNCHECKED)
	   MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable Sleep Mode together with Normal Switch Mode", 30, $hGUI_BOT)
	EndIf
EndFunc   ;==>chkUseTrainingClose
