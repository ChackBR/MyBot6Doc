; #FUNCTION# ====================================================================================================================
; Name ..........: SmartSwitchAccount (v1)
; Description ...: This file contains all functions of SmartSwitchAccount feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti & Ezeck
; Modified ......: 01/10/2017
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================


Func SwitchAccount($Init = False, $ConfirmSync = False)
	Local $iRetry = 0

	If $ichkSwitchAccount = 1 And $g_bSwitchAcctPrereq Then
		If $Init Then $FirstInit = False

#cs ; not needed here also, Located in top part of While in runbot()
		;======Get Lab Status - Green = lab running=======
		If Not $Init And Not $ConfirmSync Then
			Setlog("Checking the Lab's Status - From Switch Account", $COLOR_INFO)
			If Labstatus() Then ; Faster Getting an Updated State of Lab Running, or Stopped
				GUICtrlSetBkColor($g_lblLabStatus[$CurrentAccount], $COLOR_GREEN)
				GUICtrlSetBkColor($g_lblLabStatusPO[$CurrentAccount], $COLOR_GREEN)
			EndIf	; other color states are painted in LabStatus
		EndIf
#ce
		checkMainScreen()
		Setlog("Starting SmartSwitchAccount...", $COLOR_SUCCESS)
		If Not $ConfirmSync Then MakeSummaryLog()

		If Not $Init And Not $ConfirmSync And $ichkDonateAccount[$CurrentAccount] = 0 Then GetWaitTime() ; gets wait time for current account

		If $ConfirmSync = True Then
			SetLog("ReSync of SmartSwitchAccount...", $COLOR_INFO)
			$NextAccount = $CurrentAccount
			$CurrentAccount = 0
			GetYCoordinates($NextAccount)

		ElseIf $Init Then
			SetLog("Initialization of SmartSwitchAccount...", $COLOR_INFO)
			$CurrentAccount = 1
			$FirstLoop = 2 ; Don't Ask.. It Just Works...
			FindFirstAccount()
			$NextAccount = $CurrentAccount
			GetYCoordinates($NextAccount)
			;SetLog("Loop Count : " & $FirstLoop & "  Account in Use Count : " & $TotalAccountsInUse, $COLOR_INFO)
			$g_iFirstRun = 1 ; To Update Stats as First Run for each Account

		ElseIf $FirstLoop <= $TotalAccountsInUse And Not $Init Then
			SetLog("Continue initialization of SmartSwitchAccount...", $COLOR_INFO)
			$NextAccount = $CurrentAccount
			Do
				$NextAccount += 1
				If $NextAccount > $TotalAccountsOnEmu Then $NextAccount = 1
			Until $ichkCanUse[$NextAccount] = 1
			$FirstLoop += 1
			SetLog("Next Account will be : " & $NextAccount, $COLOR_INFO)
			GetYCoordinates($NextAccount)
			$g_iFirstRun = 1 ; To Update Stats as First Run for each Account

		ElseIf $FirstLoop > $TotalAccountsInUse And Not $Init Then
			SetLog("Switching to next Account...", $COLOR_INFO)
			;SetLog("Loop Count : " & $FirstLoop & "  Account in Use Count : " & $TotalAccountsInUse, $COLOR_INFO)
			GetNextAccount()
			GetYCoordinates($NextAccount)
		EndIf

		If $ichkDonateAccount[$CurrentAccount] = 1 Then ; Set Gui Label for Donate or Looting CurrentAccount BackGround Color Green
			GUICtrlSetData($g_lblTimeNowSW[$CurrentAccount], "Donating")
			GUICtrlSetBkColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_GREEN)
			GUICtrlSetColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_BLACK)

			GUICtrlSetData($g_lblTimeNowPO[$CurrentAccount], "Donating")
			GUICtrlSetBkColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_GREEN)
			GUICtrlSetColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_BLACK)
		Else
			GUICtrlSetData($g_lblTimeNowSW[$CurrentAccount], "Looting")
			GUICtrlSetBkColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_GREEN)
			GUICtrlSetColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_BLACK)

			GUICtrlSetData($g_lblTimeNowPO[$CurrentAccount], "Looting")
			GUICtrlSetBkColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_GREEN)
			GUICtrlSetColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_BLACK)
		EndIf

		If _Sleep($iDelayRespond) Then Return

		If $NextAccount = $CurrentAccount And Not $Init And $FirstLoop >= $TotalAccountsInUse Then
			SetLog("Next Account is already the account we are on, no need to change...", $COLOR_SUCCESS)
		Else
			If Not $Init And Not $ConfirmSync And $ichkDonateAccount[$CurrentAccount] = 0 Then
				SetLog("Trying to Request Troops before switching...", $COLOR_INFO)
				RequestCC()
				If _Sleep(500) Then Return
			EndIf

			Switch SWProcess()
				Case 4 To 6 ;Three Attempts then Restart Emulator
					$iRetry += 1
					If $iRetry >= 3 Then
						;Restart emulator
						$iRetry = 0
						$Init = False
						$FirstInit = True
						CloseCoC(True)
						ZoomOut()
						If Not $g_bRunState Then Return
						checkMainScreen()
						runBot()
					EndIf
					If $Init Then
						SwitchAccount(True)
					Else
						SwitchAccount()
					EndIf

				Case 3

					;More Serious Problem - Just restart No Retry's
					;Switch account reset first start condition
					$Init = False
					$FirstInit = True
					CloseCoC(True)
					ZoomOut()
					If Not $g_bRunState Then Return
					checkMainScreen()
					runBot()
				Case 1 To 2
					Setlog(">>Switch Process Successful<<")
			EndSwitch
			$iRetry = 0

			;============Update stat's and GUI Lables =======
			If Not $Init Then
				If $ichkDonateAccount[$CurrentAccount] = 1 Then ; Set Gui Label for Donate or Looting CurrentAccount BackGround Color Green
					GUICtrlSetData($g_lblTimeNowSW[$CurrentAccount], "Donate")
					GUICtrlSetBkColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_YELLOW)
					GUICtrlSetColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_BLACK)

					GUICtrlSetData($g_lblTimeNowPO[$CurrentAccount], "Donate")
					GUICtrlSetBkColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_YELLOW)
					GUICtrlSetColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_BLACK)
				Else
					GUICtrlSetData($g_lblTimeNowSW[$CurrentAccount], Round($CurrentAccountWaitTime, 2))
					GUICtrlSetBkColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_YELLOW)
					GUICtrlSetColor($g_lblTimeNowSW[$CurrentAccount], $COLOR_BLACK)

					GUICtrlSetData($g_lblTimeNowPO[$CurrentAccount], Round($CurrentAccountWaitTime, 2))
					GUICtrlSetBkColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_YELLOW)
					GUICtrlSetColor($g_lblTimeNowPO[$CurrentAccount], $COLOR_BLACK)
				EndIf

				If $ichkDonateAccount[$NextAccount] = 1 Then ; Set Gui Label for Donate or Looting CurrentAccount BackGround Color Green
					GUICtrlSetData($g_lblTimeNowSW[$NextAccount], "Donating")
					GUICtrlSetBkColor($g_lblTimeNowSW[$NextAccount], $COLOR_GREEN)
					GUICtrlSetColor($g_lblTimeNowSW[$NextAccount], $COLOR_BLACK)

					GUICtrlSetData($g_lblTimeNowPO[$NextAccount], "Donating")
					GUICtrlSetBkColor($g_lblTimeNowPO[$NextAccount], $COLOR_GREEN)
					GUICtrlSetColor($g_lblTimeNowPO[$NextAccount], $COLOR_BLACK)
				Else
					GUICtrlSetData($g_lblTimeNowSW[$NextAccount], "Looting")
					GUICtrlSetBkColor($g_lblTimeNowSW[$NextAccount], $COLOR_GREEN)
					GUICtrlSetColor($g_lblTimeNowSW[$NextAccount], $COLOR_BLACK)

					GUICtrlSetData($g_lblTimeNowPO[$NextAccount], "Looting")
					GUICtrlSetBkColor($g_lblTimeNowPO[$NextAccount], $COLOR_GREEN)
					GUICtrlSetColor($g_lblTimeNowPO[$NextAccount], $COLOR_BLACK)
				EndIf
			EndIf
			;===================================================

			$CurrentAccount = $NextAccount
			If $Init Or $ConfirmSync Then
				$NextProfile = _GUICtrlComboBox_GetCurSel($cmbAccount[$CurrentAccount])
				_GUICtrlComboBox_SetCurSel($g_hcmbProfile, $NextProfile)
				cmbProfile()
			Else
				$NextProfile = _GUICtrlComboBox_GetCurSel($cmbAccount[$NextAccount])
				_GUICtrlComboBox_SetCurSel($g_hcmbProfile, $NextProfile)
				cmbProfile()
			EndIf
			If _Sleep($iDelayRespond) Then Return
			IdentifyDonateOnly()
			waitMainScreen()
			VillageReport(False, False, True)
			CheckArmyCamp(True, True) ; Update troops first after switch

			If _Sleep(500) Then Return
			If $ichkDonateAccount[$CurrentAccount] = 1 Then
				TrainDonateOnlyLoop()
			Else
				runBot()
			EndIf
		EndIf
	Else ;ok
		$FirstInit = False
	EndIf ;ok

EndFunc   ;==>SwitchAccount


Func SWProcess()
	; return 1 switch account Worked.
	; return 2 Already on the right account...
	; Errors
	; Return 3 Unknow error restart needed
	; return 4 Settings Page did not open
	; return 5 Account List Not Found
	; Return 6 Confirm button did not appear
	;============Start the Switch Process, Click setting===============
	Local $iCount

	Click(820, 590, 1, 0, "Click Setting")
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks
	;====================================================================

	;==========Wait for red x - then preform DoubleClick======================
	$iCount = 0 ; Sleep(5000) if needed.
	While Not _ColorCheck(_GetPixelColor(766, 101, True), Hex(0xF88088, 6), 20)
		If _Sleep(100) Then Return
		$iCount += 1
		If $iCount = 50 Then
			Setlog("Settings Page did not open")
			Return 4 ; Settings Page did not open
		EndIf

	WEnd
	If _Sleep(100) Then Return ; Some Delays to slow down the click
	;The Double Click check for either green or red then click twice
	If _ColorCheck(_GetPixelColor(408, 408, True), "D0E878", 20) Then
		Click(440, 420, 2, 750, "Click Connect Twice with long pause")
	ElseIf _ColorCheck(_GetPixelColor(408, 408, True), "F07078", 20) Then
		Click(440, 420, 1, 750, "Click Connect Once with long pause")
	EndIf
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks
	;=================================================

	;===========Google Play animation ==============
	$iCount = 0 ; Sleep(5000) if needed. Wait for Google Play animation
	While Not _ColorCheck(_GetPixelColor(550, 450, True), Hex(0x0B8043, 6), 20) ; Green
		If _Sleep(50) Then Return
		$iCount += 1
		If $iCount = 100 Then ExitLoop
	WEnd
	;ClickP($aAway, 1, 0, "#0167") ;Click Away - disable Google Play animation
	If $iCount < 100 Then
		ClickP($aAway, 1, 0, "#0167") ;Click Away - disable Google Play animation
	EndIf
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks
	;================================================

	;===========Wait for White in Account List=======
	If _Sleep(50) Then Return
	$iCount = 0 ; sleep(10000) or until account list appears
	While Not _ColorCheck(_GetPixelColor(165, 330, True), Hex(0xFFFFFF, 6), 20)
		If _Sleep(100) Then Return
		$iCount += 1
		If $iCount = 100 Then
			Setlog("Account List Not Found")
			Return 5
		EndIf
	WEnd
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks
	Click(430, $yCoord) ; Click Account
	If _Sleep(100) Then Return ; Some Delays to slow down the clicks

	;=================================================

	;=========Get Results from Wait For Next Step()==
	If _Sleep($iDelayRespond) Then Return
	WaitForNextStep()
	;=====Do Based off of next step result ====
	If $NextStep = 1 Then ; All Was Good.. click load, type confirm, click confirm
		Setlog("Load button appeared", $COLOR_SUCCESS)

		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(520, 430)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks

		;Fancy delay to wait for Enter Confirm text box
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(587, 16, True), Hex(0xF88088, 6), 20)
			If _Sleep(100) Then Return
			$iCount += 1
			If $iCount = 50 Then ExitLoop
		WEnd
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(360, 195)
		If _Sleep(250) Then Return
		AndroidSendText("CONFIRM")

		$iCount = 0 ; Another Fancy Sleep wait for Click Confirm Button
		While Not _ColorCheck(_GetPixelColor(480, 200, True), "71BB1E", 20)
			If _Sleep(100) Then Return
			$iCount += 1
			If $iCount = 100 Then
				SetLog("Confirm Button did Not Appear")
				Return 6
			EndIf
		WEnd
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Click(530, 195)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Return 1
		;================"Already on the right account=====================
	ElseIf $NextStep = 2 Then ; wait for next step result says we match no switch needed
		Setlog("Already on the right account...", $COLOR_SUCCESS)
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		ClickP($aAway, 1, 0, "#0167") ;Click Away
		If _Sleep(100) Then Return ; Some Delays to slow down the clicks
		Return 2
		;=================Was a problem ============
	ElseIf $NextStep = 0 Then ; Was a problem
		SetLog("Error when trying to go to the next step... skipping...", $COLOR_ERROR)

		Return 3
	EndIf
	;================================================
EndFunc   ;==>SWProcess

Func GetYCoordinates($AccountNumber)
	Local $res
	$res = DllCall($g_sLibPath & "\SmartSwitchAcc_Formulas.dll", "int", "SwitchAccY", "int", $TotalAccountsOnEmu, "int", $AccountNumber)
	$yCoord = $res[0]

EndFunc   ;==>GetYCoordinates

Func GetWaitTime()

	$aTimeTrain[0] = 0
	$aTimeTrain[1] = 0
	Local $HeroesRemainingWait[3] = [0, 0, 0]

	openArmyOverview()
	Sleep(1500)
	getArmyTroopTime()
	If IsWaitforSpellsActive() Then getArmySpellTime()
	If IsWaitforHeroesActive() Then
		If _Sleep($iDelayRespond) Then Return

		If GUICtrlRead($g_hChkABActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkABKingWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hChkABQueenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hChkABWardenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf
		If GUICtrlRead($g_hchkDBActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkDBKingWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hchkDBQueenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hchkDBWardenWait) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf
		If GUICtrlRead($g_hchkTSActivateSearches) = $GUI_CHECKED Then
			If GUICtrlRead($g_hchkTSKingAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[0] = getArmyHeroTime($eKing)
			EndIf
			If GUICtrlRead($g_hchkTSQueenAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[1] = getArmyHeroTime($eQueen)
			EndIf
			If GUICtrlRead($g_hchkTSWardenAttack) = $GUI_CHECKED Then
				$HeroesRemainingWait[2] = getArmyHeroTime($eWarden)
			EndIf
		EndIf

		If $HeroesRemainingWait[0] > 0 Then SetLog("King time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)
		If $HeroesRemainingWait[1] > 0 Then SetLog("Queen time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)
		If $HeroesRemainingWait[2] > 0 Then SetLog("Warden time: " & $HeroesRemainingWait[0] & ".00 min", $COLOR_INFO)

		If _Sleep($iDelayRespond) Then Return

	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away

	Local $MaxTime[3] = [$aTimeTrain[0], $aTimeTrain[1], _ArrayMax($HeroesRemainingWait)]
	$CurrentAccountWaitTime = _ArrayMax($MaxTime)
	$AllAccountsWaitTime[$CurrentAccount] = $CurrentAccountWaitTime
	$TimerDiffStart[$CurrentAccount] = TimerInit()
	If $CurrentAccountWaitTime = 0 Then
		SetLog("Wait time for current Account : training finished, Chief ;P !", $COLOR_SUCCESS)
	Else
		SetLog("Wait time for current Account : " & Round($CurrentAccountWaitTime, 2) & " minutes", $COLOR_SUCCESS)
	EndIf
	If _Sleep($iDelayRespond) Then Return

EndFunc   ;==>GetWaitTime


Func FindFirstAccount()

	For $x = 1 To 8
		$NextAccount = $x
		If $ichkCanUse[$x] = 1 Then ExitLoop
	Next
	$CurrentAccount = $NextAccount
	$NextProfile = _GUICtrlComboBox_GetCurSel($cmbAccount[$NextAccount])
	_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $NextProfile)
	cmbProfile()
EndFunc   ;==>FindFirstAccount

Func GetNextAccount()
	Local $FinishedSince
	Local $NextDAccount
	If $MustGoToDonateAccount = 1 And $TotalDAccountsInUse <> 0 And $ichkDonateAccount[$CurrentAccount] = 0 Then

		SetLog("Time to go to Donate Account...", $COLOR_SUCCESS)

		$NextDAccount = $CurrentDAccount
		Do
			$NextDAccount += 1
			If $NextDAccount > $TotalAccountsOnEmu Then $NextDAccount = 1
		Until $ichkCanUse[$NextDAccount] = 1 And $ichkDonateAccount[$NextDAccount] = 1

		If _Sleep($iDelayRespond) Then Return

		SetLog("So, next Account will be : " & $NextDAccount, $COLOR_SUCCESS)

		If _Sleep($iDelayRespond) Then Return

		$CurrentDAccount = $NextDAccount
		;		$CurrentAccount = $NextDAccount
		$NextAccount = $NextDAccount
		$MustGoToDonateAccount = 0

	Else

		For $x = 1 To 8
			If $ichkCanUse[$x] = 1 And $ichkDonateAccount[$x] = 0 Then
				$TimerDiffEnd[$x] = TimerDiff($TimerDiffStart[$x])
				$AllAccountsWaitTimeDiff[$x] = Round($AllAccountsWaitTime[$x] * 60 * 1000 - $TimerDiffEnd[$x])
				If Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000, 2) < 0 Then
					$FinishedSince = StringReplace(Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000, 2), "-", "")
					SetLog("Account " & $x & " wait time left : training finished since " & $FinishedSince & " minutes", $COLOR_SUCCESS)
				Else
					SetLog("Account " & $x & " wait time left : " & Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000, 2) & " minutes", $COLOR_SUCCESS)
				EndIf
			EndIf
		Next

		If _Sleep($iDelayRespond) Then Return

		$NextAccount = _ArrayMinIndex($AllAccountsWaitTimeDiff, 1, 1, 8)
		SetLog("So, next Account will be : " & $NextAccount, $COLOR_SUCCESS)

		If _Sleep($iDelayRespond) Then Return

		$MustGoToDonateAccount = 1

	EndIf

EndFunc   ;==>GetNextAccount

Func MakeSummaryLog()
;	cmbAccountsQuantity()
	CheckAccountsInUse()
	CheckDAccountsInUse()
	SetLog("SmartSwitchAccount Summary : " & $TotalAccountsOnEmu & " Accounts - " & $TotalAccountsInUse & " in use - " & $TotalDAccountsInUse & " Donate Accounts", $COLOR_ORANGE)
EndFunc   ;==>MakeSummaryLog

Func TrainDonateOnlyLoop() ; not used func

	If $ichkDonateAccount[$CurrentAccount] = 1 Then
		$g_iCommandStop = 3 ; Set the commandStops
		VillageReport()
		Collect()
		randomSleep(2000)
		DonateCC()
		randomSleep(2000)

		DonateCC()
		randomSleep(2000)

		CheckArmyCamp(True, True)
		If _Sleep($iDelayIdle1) Then Return
		If ($fullArmy = False Or $bFullArmySpells = False) And $bTrainEnabled = True Then
			SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ACTION)
			$g_iCommandStop = 0
			TrainRevamp()
			randomSleep(10000)
		EndIf

		DonateCC()
		randomSleep(2000)

		DonateCC()
		randomSleep(2000)

		CheckArmyCamp(True, True) ; Only Train if Camps not Full
		If _Sleep($iDelayIdle1) Then Return
		If ($fullArmy = False Or $bFullArmySpells = False) And $bTrainEnabled = True Then
			SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ACTION)
			$g_iCommandStop = 0
			TrainRevamp()
			randomSleep(2000)
		EndIf
		SwitchAccount()
	EndIf
EndFunc   ;==>TrainDonateOnlyLoop

Func CheckAccountsInUse()

	$TotalAccountsInUse = 8
	For $x = 1 To 8
		If $ichkCanUse[$x] = 0 Then
			$AllAccountsWaitTimeDiff[$x] = 999999999999
			$TotalAccountsInUse -= 1
		EndIf
	Next

EndFunc   ;==>CheckAccountsInUse

Func CheckDAccountsInUse()

	$TotalDAccountsInUse = 0
	For $x = 1 To 8
		If $ichkDonateAccount[$x] = 1 Then
			$AllAccountsWaitTimeDiff[$x] = 999999999999
			$TotalDAccountsInUse += 1
		EndIf
	Next

EndFunc   ;==>CheckDAccountsInUse

Func cmbAccountsQuantity()

	$TotalAccountsOnEmu = _GUICtrlComboBox_GetCurSel($cmbAccountsQuantity) + 2

	For $i = $chkCanUse[1] To $chkDonateAccount[8]
		GUICtrlSetState($i, $GUI_SHOW)
	Next

	If $TotalAccountsOnEmu >= 1 And $TotalAccountsOnEmu < 8 Then
		For $i = $chkCanUse[$TotalAccountsOnEmu + 1] To $chkDonateAccount[8]
			GUICtrlSetState($i, $GUI_HIDE)
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	EndIf

	chkAccountsProperties()

EndFunc   ;==>cmbAccountsQuantity

Func chkSwitchAccount()

	If GUICtrlRead($chkEnableSwitchAccount) = $GUI_CHECKED Then
		GUICtrlSetState($g_icnPopOutSW[0], $GUI_HIDE)
		;HideShowMultiStat("SHOW")
		For $i = $lblNB To $chkDonateAccount[8]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbAccountsQuantity()
		;chkAccountsProperties()
		$ichkSwitchAccount = 1
	Else
		GUICtrlSetState($g_icnPopOutSW[0], $GUI_SHOW)
		HideShowMultiStat("HIDE")
		For $i = $lblNB To $chkDonateAccount[8]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		$ichkSwitchAccount = 0
	EndIf

EndFunc   ;==>chkSwitchAccount

Func chkAccountsProperties()

	For $h = 1 To 8

		If GUICtrlRead($chkCanUse[$h]) = $GUI_CHECKED Then
			For $i = $cmbAccount[$h] To $chkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			$ichkCanUse[$h] = 1
			GUICtrlSetState($g_icnGoldSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnElixirSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnDarkSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnGemSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnBuliderSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnHourGlassSW[$h], $GUI_SHOW)
			If GUICtrlGetState($g_lblKingStatus[$h]) <> BitOR($GUI_HIDE, $GUI_ENABLE) Then
				GUICtrlSetState($g_lblKingStatus[$h], $GUI_SHOW)
			EndIf
			If GUICtrlGetState($g_lblQueenStatus[$h]) <> BitOR($GUI_HIDE, $GUI_ENABLE) Then
				GUICtrlSetState($g_lblQueenStatus[$h], $GUI_SHOW)
			EndIf
			If GUICtrlGetState($g_lblWardenStatus[$h]) <> BitOR($GUI_HIDE, $GUI_ENABLE) Then
				GUICtrlSetState($g_lblWardenStatus[$h], $GUI_SHOW)
			EndIf
			GUICtrlSetState($g_lblLabStatus[$h], $GUI_SHOW)
			GUICtrlSetState($g_lblUnitMeasureSW1[$h], $GUI_SHOW)
			GUICtrlSetState($g_lblUnitMeasureSW2[$h], $GUI_SHOW)
			GUICtrlSetState($g_lblUnitMeasureSW3[$h], $GUI_SHOW)
			GUICtrlSetState($g_lblTimeNowSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_grpVillageSW[$h], $GUI_SHOW)
			GUICtrlSetState($g_icnPopOutSW[$h], $GUI_SHOW)
		Else
			For $i = $cmbAccount[$h] To $chkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_DISABLE)
				GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
			$ichkCanUse[$h] = 0
			GUICtrlSetState($g_icnGoldSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnElixirSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnDarkSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnGemSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnBuliderSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnHourGlassSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblKingStatus[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblQueenStatus[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblWardenStatus[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblLabStatus[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblUnitMeasureSW1[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblUnitMeasureSW2[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblUnitMeasureSW3[$h], $GUI_HIDE)
			GUICtrlSetState($g_lblTimeNowSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_grpVillageSW[$h], $GUI_HIDE)
			GUICtrlSetState($g_icnPopOutSW[$h], $GUI_HIDE)

		EndIf

		If GUICtrlRead($chkDonateAccount[$h]) = $GUI_CHECKED Then

			$ichkDonateAccount[$h] = 1
		Else
			$ichkDonateAccount[$h] = 0
		EndIf

	Next

EndFunc   ;==>chkAccountsProperties

Func IdentifyDonateOnly()

	If $ichkDonateAccount[$CurrentAccount] = 1 Then
		SetLog("Current Account is a Train/Donate Only Account...", $COLOR_DEBUG1)
	Else
		SetLog("Current Account is not a Train/Donate Only Account...", $COLOR_DEBUG1)
	EndIf

EndFunc   ;==>IdentifyDonateOnly

Func WaitForNextStep()
	Local $CheckStep

	SetLog("Waiting for Load button or Already Connected...", $COLOR_INFO)

	$CheckStep = 0

	While (Not (IsLoadButton() Or AlreadyConnected())) And $CheckStep < 150
		If _Sleep(200) Then Return
		$CheckStep += 1
	WEnd

	If $IsLoadButton Then
		$NextStep = 1
	ElseIf $AlreadyConnected Then
		$NextStep = 2
	Else
		$NextStep = 0
	EndIf

EndFunc   ;==>WaitForNextStep

Func IsLoadButton()

	$IsLoadButton = _ColorCheck(_GetPixelColor(480, 441, True), "60B010", 20)
	Return $IsLoadButton

EndFunc   ;==>IsLoadButton

Func AlreadyConnected()

	$AlreadyConnected = _ColorCheck(_GetPixelColor(408, 408, True), "D0E878", 20)
	Return $AlreadyConnected

EndFunc   ;==>AlreadyConnected

Func AppendLineToSSALog($AtkReportLine)

	If $ichkSwitchAccount = 1 Then
		If $LastDate <> _NowDate() Then
			$LastDate = _NowDate()
			FileWriteLine($SSAAtkLog, @CRLF)
			FileWriteLine($SSAAtkLog, _NowDate())
			FileWriteLine($SSAAtkLog, @CRLF)
			FileWriteLine($SSAAtkLog, "                    --------  LOOT --------       ----- BONUS ------")
			FileWriteLine($SSAAtkLog, @CRLF)
			FileWriteLine($SSAAtkLog, "Ac| TIME|TROP.| SRC|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L.")
		EndIf
		If FileWriteLine($SSAAtkLog, $AtkReportLine) = 0 Then Setlog("Error when trying to add Attack Report line to multi account log...", $COLOR_ERROR)
	EndIf

EndFunc   ;==>AppendLineToSSALog

Func LabStatus()
	Static $sLabUpgradeTimeStatic[9]
	Local $TimeDiff, $aArray, $Result
	Local $iRemainingTimeMin, $sTime
	If $aLabPos[0] <= 0 Or $aLabPos[1] <= 0 Then
		SetLog("Laboratory Location not found!", $COLOR_ERROR)
		LocateLab() ; Lab location unknown, so find it.
		If $aLabPos[0] = 0 Or $aLabPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_ERROR)
			GUICtrlSetBkColor($g_lblLabStatus[$CurrentAccount], $COLOR_RED)
			GUICtrlSetBkColor($g_lblLabStatusPO[$CurrentAccount], $COLOR_RED)
			Return False
		EndIf
	EndIf

	If $sLabUpgradeTimeStatic[$CurrentAccount] <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $sLabUpgradeTimeStatic[$CurrentAccount]) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $g_iDebugSetlog = 1 Then SetLog(" Lab end time: " & $sLabUpgradeTimeStatic[$CurrentAccount] & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)
	If $g_bRunState = False Then Return

	If $TimeDiff <= 0 Then
		SetLog("Checking Laboratory Activity Status ...", $COLOR_INFO)
	Else
		SetLog("Laboratory is Running. ", $COLOR_INFO)
		Return True
	EndIf

	BuildingClickP($aLabPos, "#0197") ;Click Laboratory
	If _Sleep($iDelayLaboratory1) Then Return ; Wait for window to open

	; Find Research Button
	Local $offColors[4][3] = [[0x708CB0, 37, 34], [0x603818, 50, 43], [0xD5FC58, 61, 8], [0x000000, 82, 0]] ; 2nd pixel Blue blade, 3rd pixel brown handle, 4th pixel Green cross, 5th black button edge
	Global $ButtonPixel = _MultiPixelSearch(433, 565 + $g_iBottomOffsetY, 562, 619 + $g_iBottomOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 30) ; Black pixel of button edge
	If IsArray($ButtonPixel) Then
		If $g_iDebugSetlog = 1 Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			Setlog("#1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 37, $ButtonPixel[1] + 34, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 50, $ButtonPixel[1] + 43, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 61, $ButtonPixel[1] + 8, True), $COLOR_DEBUG)
		EndIf
		If $g_iDebugImageSave = 1 Then DebugImageSave("LabUpgrade_") ; Debug Only
		Click($ButtonPixel[0] + 40, $ButtonPixel[1] + 25, 1, 0, "#0198") ; Click Research Button
		If _Sleep($iDelayLaboratory1) Then Return ; Wait for window to open
	Else
		Setlog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $iDelayLaboratory4, "#0199")
		GUICtrlSetBkColor($g_lblLabStatus[$CurrentAccount], $COLOR_YELLOW)
		GUICtrlSetBkColor($g_lblLabStatusPO[$CurrentAccount], $COLOR_YELLOW)
		Return False
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(625, 250 + $g_iMidOffsetY, True), Hex(0x60AC10, 6), 20) Or _ColorCheck(_GetPixelColor(660, 250 + $g_imidOffsetY, True), Hex(0x60AC10, 6), 20) Then
		SetLog("Laboratory is Running. ", $COLOR_INFO)
		If _Sleep($iDelayLaboratory2) Then Return
		; upgrade in process and time not recorded?  Then update completion time!
		If $sLabUpgradeTimeStatic[$CurrentAccount] = "" Or $TimeDiff <= 0 Then
			$Result = getRemainTLaboratory(336, 260) ; Try to read white text showing actual time left for upgrade
			If $g_iDebugSetlog = 1 Then Setlog($aLabTroops[$g_iCmbLaboratory][3] & " OCR Remaining Lab Time = " & $Result, $COLOR_DEBUG)
			$aArray = StringSplit($Result, ' ', BitOR($STR_CHRSPLIT, $STR_NOCOUNT)) ;separate days, hours, minutes, seconds
			If IsArray($aArray) Then
				$iRemainingTimeMin = 0
				For $i = 0 To UBound($aArray) - 1 ; step through array and compute minutes remaining
					$sTime = ""
					Select
						Case StringInStr($aArray[$i], "d", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "d"
							$iRemainingTimeMin += (Int($sTime) * 24 * 60) ; change days to minutes and add
						Case StringInStr($aArray[$i], "h", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "h"
							$iRemainingTimeMin += (Int($sTime) * 60) ; change hours to minutes and add
						Case StringInStr($aArray[$i], "m", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "m"
							$iRemainingTimeMin += Int($sTime) ; add minutes
						Case StringInStr($aArray[$i], "s", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "s"
							$iRemainingTimeMin += Int($sTime) / 60 ; Add seconds
						Case Else
							Setlog("Remaining lab time OCR invalid:" & $aArray[$i], $COLOR_WARNING)
							ClickP($aAway, 2, $iDelayLaboratory4, "#0328")
							GUICtrlSetBkColor($g_lblLabStatus[$CurrentAccount], $COLOR_RED)
							GUICtrlSetBkColor($g_lblLabStatusPO[$CurrentAccount], $COLOR_RED)
							Return False
					EndSelect

					If $g_iDebugSetlog = 1 Then Setlog("Remain Lab Time: " & $aArray[$i] & ", Minutes= " & $iRemainingTimeMin, $COLOR_DEBUG)
				Next

				$sLabUpgradeTimeStatic[$CurrentAccount] = _DateAdd('n', Ceiling($iRemainingTimeMin), _NowCalc()) ; add the time required to NOW to finish the upgrade
				If @error Then _logErrorDateAdd(@error)
				SetLog("Updated Lab finishing time: " & $sLabUpgradeTimeStatic[$CurrentAccount], $COLOR_SUCCESS)
			Else
				If $g_iDebugSetlog = 1 Then Setlog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
			EndIf
		EndIf
		ClickP($aAway, 2, $iDelayLaboratory4, "#0359")
		Return True
	Else
		SetLog("Laboratory has Stopped", $COLOR_INFO)
		ClickP($aAway, 2, $iDelayLaboratory4, "#0359")
		GUICtrlSetBkColor($g_lblLabStatus[$CurrentAccount], $COLOR_RED)
		GUICtrlSetBkColor($g_lblLabStatusPO[$CurrentAccount], $COLOR_RED)
		Return False
	EndIf
EndFunc   ;==>LabStatus

Func HeroStatsStaus()
	Local $sKingStatus, $sQueenStatus, $sWardenStatus
		;OPEN ARMY TRAIN WINDOW
			If ISArmyWindow(False, $ArmyTAB) = False Then
				OpenArmyWindow()
				If _Sleep(1500) Then Return
			EndIf
		;GET HERO STATUS
			$sKingStatus = ArmyHeroStatus(0) ; Called with a Variable so the return value has some where to go.
			$sQueenStatus = ArmyHeroStatus(1) ; Update Colors are inclueded in calling the ArmyHeroStatus Func
			$sWardenStatus = ArmyHeroStatus(2)

		;CLOSE ARMY WINDOW
			ClickP($aAway, 2, 0, "#0346") ;Click Away
			If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
EndFunc ; HeroStatsStaus()