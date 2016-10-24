; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func cmbProfile()
	saveConfig()

	FileClose($hLogFileHandle)
	$hLogFileHandle = ""		;- Writing log for each profile in SwitchAcc Mode - DEMEN (Special thanks to ezeck0001)
	FileClose($hAttackLogFileHandle)
	$hAttackLogFileHandle = ""	;- Writing log for each profile in SwitchAcc Mode - DEMEN (Special thanks to ezeck0001)

	; Setup the profile in case it doesn't exist.
	setupProfile()

	readConfig()
	applyConfig()
	saveConfig()

	SetLog("Profile " & $sCurrProfile & " loaded from " & $config, $COLOR_SUCCESS)
	btnUpdateProfile()			;- Refreshing setting of all profiles in SwitchAcc Mode - DEMEN

EndFunc   ;==>cmbProfile

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

; ============= SwitchAcc Mode ============= - DEMEN

Func btnAddConfirm()
	Switch @GUI_CtrlId
		Case $btnAdd
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_SHOW)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_HIDE)
		Case $btnConfirmAdd
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(637, 11, "Profile Already Exists"), GetTranslated(637, 12, "%s already exists.\r\nPlease choose another name for your profile.", $newProfileName))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			selectProfile()
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)

			If GUICtrlGetState($btnDelete) <> $GUI_ENABLE Then GUICtrlSetState($btnDelete, $GUI_ENABLE)
			If GUICtrlGetState($btnRename) <> $GUI_ENABLE Then GUICtrlSetState($btnRename, $GUI_ENABLE)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch @GUI_CtrlId
		Case $btnDelete
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslated(637, 8, "Delete Profile"), GetTranslated(637, 14, "Are you sure you really want to delete the profile?\r\nThis action can not be undone."))
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				deleteProfile()
				; reset inputtext
				GUICtrlSetData($txtVillageName, GetTranslated(637,4, "MyVillage"))
				If _GUICtrlComboBox_GetCount($cmbProfile) > 1 Then
					; select existing profile
					setupProfileComboBox()
					selectProfile()
				Else
					; create new default profile
					createProfile(True)
				EndIf
			EndIf
		Case $btnCancel
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch

	If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($btnDelete, $GUI_DISABLE)
		GUICtrlSetState($btnRename, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnDeleteCancel

Func btnRenameConfirm()
	Switch @GUI_CtrlId
		Case $btnRename
			GUICtrlSetData($txtVillageName, GUICtrlRead($cmbProfile))
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnRename, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_SHOW)
		Case $btnConfirmRename
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(7, 108, "Profile Already Exists"), $newProfileName & " " & GetTranslated(7, 109, "already exists.") & @CRLF & GetTranslated(7, 110, "Please choose another name for your profile"))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Rename the profile.
			renameProfile()
			setupProfileComboBox()
			selectProfile()

			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnRenameConfirm
Func cmbBotCond()
	If _GUICtrlComboBox_GetCurSel($cmbBotCond) = 15 Then
		If _GUICtrlComboBox_GetCurSel($cmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($cmbHoursStop, 1)
		GUICtrlSetState($cmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($cmbHoursStop, 0)
		GUICtrlSetState($cmbHoursStop, $GUI_DISABLE)
	EndIf
EndFunc   ;==>cmbBotCond

Func chkBotStop()
	If GUICtrlRead($chkBotStop) = $GUI_CHECKED Then
		GUICtrlSetState($cmbBotCommand, $GUI_ENABLE)
		GUICtrlSetState($cmbBotCond, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbBotCommand, $GUI_DISABLE)
		GUICtrlSetState($cmbBotCond, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBotStop
Func btnLocateBarracks()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateBarrack()
	$RunState = $wasRunState
	AndroidShield("btnLocateBarracks") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateBarracks

Func btnLocateArmyCamp()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateBarrack(True)
	$RunState = $wasRunState
	AndroidShield("btnLocateArmyCamp") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateArmyCamp

Func btnLocateClanCastle()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateClanCastle()
	$RunState = $wasRunState
	AndroidShield("btnLocateClanCastle") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateClanCastle

Func btnLocateSpellfactory()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateSpellFactory()
	$RunState = $wasRunState
	AndroidShield("btnLocateSpellfactory") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateSpellfactory

Func btnLocateDarkSpellfactory()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateDarkSpellFactory()
	$RunState = $wasRunState
	AndroidShield("btnLocateDarkSpellfactory") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateDarkSpellfactory

Func btnLocateKingAltar()
	LocateKingAltar()
EndFunc   ;==>btnLocateKingAltar


Func btnLocateQueenAltar()
	LocateQueenAltar()
EndFunc   ;==>btnLocateQueenAltar

Func btnLocateWardenAltar()
	LocateWardenAltar()
EndFunc   ;==>btnLocateWardenAltar

Func btnLocateTownHall()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateTownHall()
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslated(640, 72, "If you locating your TH because you upgraded,") & @CRLF & _
			GetTranslated(640, 73, "then you must restart bot!!!") & @CRLF & @CRLF & _
			GetTranslated(640, 74, "Click OK to restart bot, ") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 1, "Ok|Cancel"), GetTranslated(640, 76, "Close Bot Please!"), $stext, 120, $frmBot)
	If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		Local $stext = @CRLF & GetTranslated(640, 77, "Are you 100% sure you want to restart bot ?") & @CRLF & @CRLF & _
				GetTranslated(640, 78, "Click OK to close bot and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslated(640, 65, -1) & @CRLF
		Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 1, -1), GetTranslated(640, 76, -1), $stext, 120, $frmBot)
		If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
		If $MsgBox = 1 Then BotClose(False)
	EndIf
	$RunState = $wasRunState
	AndroidShield("btnLocateTownHall") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLocateTownHall



Func btnResetBuilding()
	Local $wasRunState = $RunState
	$RunState = True
	While 1
		If _Sleep(500) Then Return ; add small delay before display message window
		If FileExists($building) Then ; Check for building.ini file first
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			Local $stext = @CRLF & GetTranslated(640, 63, "Click OK to Delete and Reset all Building info,") & @CRLF & @CRLF & _
					GetTranslated(640, 64, "NOTE =>> Bot will exit and need to be restarted when complete") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
			Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 1, "Ok|Cancel"), GetTranslated(640, 67, "Delete Building Infomation ?"), $stext, 120, $frmBot)
			If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
			If $MsgBox = 1 Then
				Local $stext = @CRLF & GetTranslated(640, 68, "Are you 100% sure you want to delete Building information ?") & @CRLF & @CRLF & _
						GetTranslated(640, 69, "Click OK to Delete and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslated(640, 65, -1) & @CRLF
				Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 1, -1), GetTranslated(640, 67, -1), $stext, 120, $frmBot)
				If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
				If $MsgBox = 1 Then
					Local $Result = FileDelete($building)
					If $Result = 0 Then
						Setlog("Unable to remove building.ini file, please use manual method", $COLOR_ERROR)
					Else
						BotClose(False)
					EndIf
				EndIf
			EndIf
		Else
			Setlog("Building.ini file does not exist", $COLOR_INFO)
		EndIf
		ExitLoop
	WEnd
	$RunState = $wasRunState
	AndroidShield("btnResetBuilding") ; Update shield status due to manual $RunState
EndFunc   ;==>btnResetBuilding

Func btnLab()
	Local $wasRunState = $RunState
	$RunState = True
	ZoomOut()
	LocateLab()
	$RunState = $wasRunState
	AndroidShield("btnLab") ; Update shield status due to manual $RunState
EndFunc   ;==>btnLab

Func chkTrophyAtkDead()
	If GUICtrlRead($chkTrophyAtkDead) = $GUI_CHECKED Then
		$ichkTrophyAtkDead = 1
		GUICtrlSetState($txtDTArmyMin, $GUI_ENABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_ENABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_ENABLE)
	Else
		$ichkTrophyAtkDead = 0
		GUICtrlSetState($txtDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyAtkDead

Func chkTrophyRange()
	If GUICtrlRead($chkTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($txtdropTrophy, $GUI_ENABLE)
		GUICtrlSetState($txtMaxTrophy, $GUI_ENABLE)
		GUICtrlSetState($chkTrophyHeroes, $GUI_ENABLE)
		GUICtrlSetState($chkTrophyAtkDead, $GUI_ENABLE)
		chkTrophyAtkDead()
	Else
		GUICtrlSetState($txtdropTrophy, $GUI_DISABLE)
		GUICtrlSetState($txtMaxTrophy, $GUI_DISABLE)
		GUICtrlSetState($chkTrophyHeroes, $GUI_DISABLE)
		GUICtrlSetState($chkTrophyAtkDead, $GUI_DISABLE)
		GUICtrlSetState($txtDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyRange
