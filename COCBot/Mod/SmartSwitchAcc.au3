; #FUNCTION# ====================================================================================================================
; Name ..........: SmartSwitchAccount (v1)
; Description ...: This file contains all functions of SmartSwitchAccount feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 01/10/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================

Func SwitchAccount($Init = False)

	If $ichkSwitchAccount = 1 Then

		If $Init Then $FirstInit = False

		Setlog("Starting SmartSwitchAccount...", $COLOR_GREEN)

		MakeSummaryLog()
		If Not $IsDonateAccount Then GetWaitTime()

		If $CurrentAccountWaitTime = 0 And Not $Init And Not $IsDonateAccount Then

			SetLog("Your Army is ready so I stay here, I'm a thug !!! ;P", $COLOR_GREEN)

		Else

			If $Init Then
				SetLog("Initialization of SmartSwitchAccount...", $COLOR_BLUE)
				$FirstLoop = 1
				$NextAccount = 1
				GetYCoordinates($NextAccount)
			ElseIf $FirstLoop < $TotalAccountsInUse And Not $Init Then
				SetLog("Continue initialization of SmartSwitchAccount...", $COLOR_BLUE)
				$NextAccount = $CurrentAccount
				Do
					$NextAccount += 1
					If $NextAccount > $TotalAccountsOnEmu Then $NextAccount = 1
				Until $ichkCanUse[$NextAccount] = 1
				$FirstLoop += 1
				SetLog("Next Account will be : " & $NextAccount, $COLOR_BLUE)
				GetYCoordinates($NextAccount)
			ElseIf $FirstLoop >= $TotalAccountsInUse And Not $Init Then
				SetLog("Switching to next Account...", $COLOR_BLUE)
				GetNextAccount()
				GetYCoordinates($NextAccount)
			EndIf

			If $NextAccount = $CurrentAccount And Not $Init And $FirstLoop >= $TotalAccountsInUse Then

				SetLog("Next Account is already the account we are on, no need to change...", $COLOR_GREEN)

			Else

				Sleep(500)
				Click(820, 590)
				Sleep(1500)
				If _ColorCheck(_GetPixelColor(431, 434, True), Hex(4284458031, 6), 20) Then
					Click(440, 420, 1, 0, "Click Connected")
					Sleep(500)
				EndIf
				Click(440, 420, 1, 0, "Click Disconnected")

				Sleep(8000)
				Click(430, $yCoord)
				Sleep(8000)
				If _ColorCheck(_GetPixelColor(431, 434, True), Hex(4284458031, 6), 20) Then
					Setlog("Already on the right account...", $COLOR_GREEN)
					Sleep(500)
					ClickP($aAway, 1, 0, "#0167") ;Click Away
				Else
					Click(520, 430)
					Sleep(1500)
					Click(360, 195)
					AndroidSendText("CONFIRM")
					Sleep(1500)
					Click(530, 195)
				EndIf

				$CurrentAccount = $NextAccount

				If $Init Then
					$NextProfile = _GUICtrlComboBox_GetCurSel($cmbAccount[1])
					_GUICtrlComboBox_SetCurSel($cmbProfile, $NextProfile)
					cmbProfile()
				Else
					$NextProfile = _GUICtrlComboBox_GetCurSel($cmbAccount[$NextAccount])
					_GUICtrlComboBox_SetCurSel($cmbProfile, $NextProfile)
					cmbProfile()
				EndIf

				IdentifyDonateOnly()
				checkMainScreen()
				runBot()

			EndIf
		EndIf
	Else

		$FirstInit = False

	EndIf

EndFunc   ;==>SwitchAccount

Func GetYCoordinates($AccountNumber)

	$yCoord = (352 - 36 * $TotalAccountsOnEmu) + (72 * $AccountNumber)

EndFunc   ;==>GetYCoordinates

Func GetWaitTime()

	$aTimeTrain[0] = 0
	$aTimeTrain[1] = 0
	$HeroesRemainingWait = 0

	openArmyOverview()
	Sleep(1500)
	getArmyTroopTime()
	If IsWaitforSpellsActive() Then getArmySpellTime()
	If IsWaitforHeroesActive() Then $HeroesRemainingWait = getArmyHeroTime("all")
	ClickP($aAway, 1, 0, "#0167") ;Click Away

	Local $MaxTime[3] = [$aTimeTrain[0], $aTimeTrain[1], $HeroesRemainingWait]
	$CurrentAccountWaitTime = _ArrayMax($MaxTime)
	$AllAccountsWaitTime[$CurrentAccount] = $CurrentAccountWaitTime
	$TimerDiffStart[$CurrentAccount] = ($TimerDiffStart[$CurrentAccount] * 60 * 1000)
	$TimerDiffStart[$CurrentAccount] = TimerInit()

	If $CurrentAccountWaitTime = 0 Then
		SetLog("Wait time for current Account : Training finished, Chief ;P !", $COLOR_GREEN)
	Else
		SetLog("Wait time for current Account : " & $CurrentAccountWaitTime & " minutes", $COLOR_GREEN)
	EndIf

EndFunc   ;==>GetWaitTime

Func CheckAccountsInUse()

	$TotalAccountsInUse = 5
	For $x = 1 To 5
		If $ichkCanUse[$x] = 0 Then
			$AllAccountsWaitTimeDiff[$x] = 999999999999
			$TotalAccountsInUse -= 1
		EndIf
	Next

EndFunc   ;==>CheckAccountsInUse

Func CheckDAccountsInUse()

	$TotalDAccountsInUse = 0
	For $x = 1 To 5
		If $ichkDonateAccount[$x] = 1 Then
			$AllAccountsWaitTimeDiff[$x] = 999999999999
			$TotalDAccountsInUse += 1
		EndIf
	Next

EndFunc   ;==>CheckDAccountsInUse

Func GetNextAccount()

	If $MustGoToDonateAccount = 1 And $TotalDAccountsInUse <> 0 Then

		SetLog("Time to go to Donate Account...", $COLOR_GREEN)

		$NextDAccount = $CurrentDAccount
		Do
			$NextDAccount += 1
			If $NextDAccount > $TotalAccountsOnEmu Then $NextDAccount = 1
		Until $ichkCanUse[$NextDAccount] = 1 And $ichkDonateAccount[$NextDAccount] = 1


		SetLog("So, next Account will be : " & $NextDAccount, $COLOR_GREEN)

		$CurrentDAccount = $NextDAccount
		$CurrentAccount = $NextDAccount
		$NextAccount = $NextDAccount
		$MustGoToDonateAccount = 0

	Else

		For $x = 1 To 5
			If $ichkCanUse[$x] = 1 And $ichkDonateAccount[$x] = 0 Then
				$TimerDiffEnd[$x] = TimerDiff($TimerDiffStart[$x])
				$AllAccountsWaitTimeDiff[$x] = Round($AllAccountsWaitTime[$x] * 60 * 1000 - $TimerDiffEnd[$x])
				If Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000, 2) <= 0 Then
					$FinishedSince = StringReplace(Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000), "-", "")
					SetLog("Account " & $x & " wait time left : Training finished since " & $FinishedSince & " minutes", $COLOR_GREEN)
				Else
					SetLog("Account " & $x & " wait time left : " & Round($AllAccountsWaitTimeDiff[$x] / 60 / 1000) & " minutes", $COLOR_GREEN)
				EndIf
			EndIf
		Next
		$NextAccount = _ArrayMinIndex($AllAccountsWaitTimeDiff, 1, 1, 5)
		SetLog("So, next Account will be : " & $NextAccount, $COLOR_GREEN)

		$MustGoToDonateAccount = 1

	EndIf

EndFunc   ;==>GetNextAccount

Func cmbAccountsQuantity()

	$TotalAccountsOnEmu = _GUICtrlComboBox_GetCurSel($cmbAccountsQuantity) + 2

	For $i = $chkCanUse[1] To $chkDonateAccount[5]
		GUICtrlSetState($i, $GUI_SHOW)
	Next

	If $TotalAccountsOnEmu >= 1 And $TotalAccountsOnEmu < 5 Then
		For $i = $chkCanUse[$TotalAccountsOnEmu + 1] To $chkDonateAccount[5]
			GUICtrlSetState($i, $GUI_HIDE)
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	EndIf

	chkAccountsProperties()

EndFunc   ;==>cmbAccountsQuantity

Func chkSwitchAccount()

	If GUICtrlRead($chkEnableSwitchAccount) = $GUI_CHECKED Then
		For $i = $lblNB To $chkDonateAccount[5]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbAccountsQuantity()
		chkAccountsProperties()
		$ichkSwitchAccount = 1
	Else
		For $i = $lblNB To $chkDonateAccount[5]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		$ichkSwitchAccount = 0
	EndIf

EndFunc   ;==>chkSwitchAccount

Func MakeSummaryLog()

	cmbAccountsQuantity()
	CheckAccountsInUse()
	CheckDAccountsInUse()

	SetLog("SmartSwitchAccount Summary : " & $TotalAccountsOnEmu & " Accounts - " & $TotalAccountsInUse & " in use - " & $TotalDAccountsInUse & " Donate Accounts", $COLOR_ORANGE)

EndFunc   ;==>MakeSummaryLog

Func chkAccountsProperties()

	For $h = 1 To 5

		If GUICtrlRead($chkCanUse[$h]) = $GUI_CHECKED Then
			For $i = $cmbAccount[$h] To $chkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			$ichkCanUse[$h] = 1
		Else
			For $i = $cmbAccount[$h] To $chkDonateAccount[$h]
				GUICtrlSetState($i, $GUI_DISABLE)
				GUICtrlSetState($i, $GUI_UNCHECKED)
			Next
			$ichkCanUse[$h] = 0
		EndIf

		If GUICtrlRead($chkDonateAccount[$h]) = $GUI_CHECKED Then
			$ichkDonateAccount[$h] = 1
		Else
			$ichkDonateAccount[$h] = 0
		EndIf

	Next

EndFunc   ;==>chkAccountsProperties

Func TrainDonateOnlyLoop()

	If $IsDonateAccount = 1 Then

		DonateCC()
		randomSleep(1000)
		DonateCC()

		randomSleep(2000)
		TrainRevamp()
		randomSleep(10000)

		DonateCC()
		randomSleep(1000)
		DonateCC()

		randomSleep(2000)
		TrainRevamp()
		randomSleep(2000)

		SwitchAccount()

	EndIf

EndFunc   ;==>TrainDonateOnlyLoop

Func IdentifyDonateOnly()

	If $ichkSwitchAccount = 1 And $ichkDonateAccount[$CurrentAccount] = 1 And ($FirstLoop >= $TotalAccountsInUse) Then
		$IsDonateAccount = True
		SetLog("Current Account is a Train/Donate Only Account...", $COLOR_ORANGE)
	Else
		$IsDonateAccount = False
		SetLog("Current Account is not a Train/Donate Only Account...", $COLOR_ORANGE)
	EndIf

EndFunc   ;==>IdentifyDonateOnly
