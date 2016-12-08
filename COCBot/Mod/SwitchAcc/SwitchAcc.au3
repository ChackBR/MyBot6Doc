; #FUNCTION# ====================================================================================================================
; Name ..........: Switch CoC Account
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN (based on original code & idea of NDTHUAN)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func InitiateSwitchAcc() ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.

   $ProfileList = _GUICtrlComboBox_GetListArray($cmbProfile)
   $nTotalProfile = _GUICtrlComboBox_GetCount($cmbProfile)
   $nCurProfile = _GuiCtrlComboBox_GetCurSel($cmbProfile) + 1

   Setlog($nTotalProfile & " profiles available")
   Setlog("Scanning through all profiles")

   For $i = 0 To $nTotalProfile - 1
	  _GUICtrlComboBox_SetCurSel($cmbProfile, $i)
	  cmbProfile()
   Next

   For $i = 0 to $nTotalProfile - 1
	  Switch $aProfileType[$i]
	  Case 1
		 Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i+1] & " - Active - Match with Account [" & $aMatchProfileAcc[$i] &"]")
	  Case 2
		 Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i+1] & " - Donate - Match with Account [" & $aMatchProfileAcc[$i] &"]")
	  Case 3
		 Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i+1] & " - Idle   - Match with Account [" & $aMatchProfileAcc[$i] &"]")
	  EndSwitch
   Next

   ; Counting CoC Accounts
#CS   If $icmbTotalCoCAcc = 0 Then
	  Local Const $XConnect = 431
	  Local Const $YConnect = 434
	  Local Const $ColorConnect = 4284458031      ;Connected Button: green
	  Setlog ("Starting counting available CoC Accounts")
	  Click(820, 585, 1, 0, "Click Setting")      ;Click setting
	  If _Sleepstatus(5000) Then Return
	  If _ColorCheck(_GetPixelColor($XConnect, $YConnect, True), Hex($ColorConnect, 6), 20) Then       ;Blue
		 Click($XConnect, $YConnect, 1, 0, "Click Connected")      ;Click Connect
	  EndIf
	  If _Sleepstatus(3000) Then Return
	  Click($XConnect, $YConnect, 1, 0, "Click DisConnect")      ;Click DisConnect
	  If _Sleepstatus(10000) Then Return

	  $i = 0
	  While $i <= 5
		 If _ColorCheck(_GetPixelColor(620, 310 - 38 * $i, True), "FFFFFF", 15) = False Then		; Grey
			$icmbTotalCoCAcc = $i+1
			ExitLoop
		 Else
			$i += 1
		 EndIf
	  WEnd
	  Click(762, 117, 1, 0, "Click Close")      ;Click close
	  If _Sleepstatus(2000) Then Return
	  Click(762, 117, 1, 0, "Click Close")      ;Click close
   EndIf   ; ====== Counting CoC Accounts
#CE

   If $icmbTotalCoCAcc > 0 then
	   $nTotalCoCAcc = $icmbTotalCoCAcc
	   Setlog ("Total CoC Account(s)is declared: " & $nTotalCoCAcc)
   Else
	   Setlog ("Total CoC Account(s) has not declared, default: " & $nTotalCoCAcc)
   EndIf


   ; Locating CoC Accounts
   If _ArrayMax($aAccPosY) > 0 Then
	   $MaxIdx = _ArrayMaxIndex($aAccPosY)
	   For $i = 1 to $nTotalCoCAcc
		   If $aAccPosY[$i-1] <= 0 Then $aAccPosY[$i-1] = $aAccPosY[$MaxIdx] + 73*($i-1-$MaxIdx)
		   Setlog("  >>> Y-coordinate Acc No. " & $i & " is located at: " & $aAccPosY[$i-1])
	   Next
   EndIf

   If _ArraySearch($aProfileType, 1) <> -1 Then								; There is at least one active profile
	  If $aProfileType[$nCurProfile-1] <> 1 Then							; Not Active profile
		 $i = _ArraySearch($aProfileType, 1)
		 Setlog("First starting with an active Profile [" & $i+1 &"] - CoC Acc [" & $aMatchProfileAcc[$i] & "]")
		 _GUICtrlComboBox_SetCurSel($cmbProfile, $i)						; Move to first active Profile
		 cmbProfile()
	  Else
		 Setlog("First starting with an active Profile [" & $nCurProfile &"] - CoC Acc [" & $aMatchProfileAcc[$nCurProfile - 1] & "].")
		 If $nCurProfile <> _GuiCtrlComboBox_GetCurSel($cmbProfile) + 1 Then
			_GUICtrlComboBox_SetCurSel($cmbProfile, $nCurProfile - 1)		; Return to Current Profile
			cmbProfile()
		 EndIf
	  EndIf
   Else																		; There is no active profile
	  $i = _ArraySearch($aProfileType, 2)
	  Setlog("Try to avoid Idle Profile. Switching to Profile [" & $i+1 &"] - CoC Acc [" & $aMatchProfileAcc[$i] & "]")
	  _GUICtrlComboBox_SetCurSel($cmbProfile, $i)							; Move to first Donate Profile
	  cmbProfile()
   EndIf

   $nCurProfile = _GuiCtrlComboBox_GetCurSel($cmbProfile) + 1

   For $i = 0 to $nTotalProfile - 1
	  $aTimerStart[$i] = 0
	  $aTimerEnd[$i] = 0
	  $aRemainTrainTime[$i] = 0
	  $aUpdateRemainTrainTime[$i] = 0
   Next

   Setlog ("Matching CoC Account with Bot Profile. Trying to Switch Account", $COLOR_BLUE)

   SwitchCOCAcc()
   If $bReMatchAcc = False Then runBot()

EndFunc

Func CheckWaitHero()	; get hero regen time remaining if enabled
    Local $iActiveHero
	Local $aHeroResult[3]
	$aTimeTrain[2] = 0

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("CheckWaitHero", $COLOR_PURPLE)

	$aHeroResult = getArmyHeroTime("all")

	If @error Then
		Setlog("getArmyHeroTime return error, exit Check Hero's wait time!", $COLOR_RED)
		Return ; if error, then quit Check Hero's wait time
	EndIf

	If $aHeroResult = "" Then
		Setlog("You have no hero or bad TH level detection Pls manually locate TH", $COLOR_RED)
		Return
	EndIf

	Setlog("Getting Hero's recover time, King: " & $aHeroResult[0] & " m, Queen: " & $aHeroResult[1] & " m, GW: " & $aHeroResult[2] & " m.")

	If _Sleep($iDelayRespond) Then Return
	If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Then ; check if hero is enabled to use/wait and set wait time
		For $pTroopType = $eKing To $eWarden ; check all 3 hero
			For $pMatchMode = $DB To $iModeCount - 1 ; check all attack modes
				If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
					SetLog("$pTroopType: " & NameOfTroop($pTroopType) & ", $pMatchMode: " & $sModeText[$pMatchMode], $COLOR_PURPLE)
					Setlog("TroopToBeUsed: " & IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) & ", Hero Wait Status: " & (BitOr($iHeroAttack[$pMatchMode], $iHeroWait[$pMatchMode]) = $iHeroAttack[$pMatchMode]), $COLOR_PURPLE)
				EndIf
				$iActiveHero = -1
				If IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And _
					 BitOr($iHeroAttack[$pMatchMode], $iHeroWait[$pMatchMode]) = $iHeroAttack[$pMatchMode] Then ; check if Hero enabled to wait
				$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
				EndIf
				If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
					; check exact time & existing time is less than new time
					If $aTimeTrain[2] < $aHeroResult[$iActiveHero] Then
						$aTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
					EndIf

					If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
						SetLog("Wait enabled: " & NameOfTroop($pTroopType) & ", Attack Mode:" & $sModeText[$pMatchMode] & ", Hero Time:" & $aHeroResult[$iActiveHero] & ", Wait Time: " & StringFormat("%.2f", $aTimeTrain[2]), $COLOR_PURPLE)
					EndIf
				EndIf
			Next
			If _Sleep($iDelayRespond) Then Return
		Next
	Else
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("getArmyHeroTime return all zero hero wait times", $COLOR_PURPLE)
	EndIf

	Setlog("Hero recover wait time: " & $aTimeTrain[2] & " minute(s)", $COLOR_BLUE)

 EndFunc ; CheckWaitHero

Func MinRemainTrainAcc() 														; Check remain training time of all Active accounts and return the minimum remain training time

   $aRemainTrainTime[$nCurProfile-1] = _ArrayMax($aTimeTrain)				 	; remaintraintime of current account - in minutes
   $aTimerStart[$nCurProfile-1] = TimerInit() 									; start counting elapse of training time of current account

   For $i = 0 to $nTotalProfile - 1
	  If $aProfileType[$i] = 1 Then 											;	Only check Active profiles
		 If $aTimerStart[$i] <> 0 Then
			$aTimerEnd[$i] = Round(TimerDiff($aTimerStart[$i])/1000/60,2) 		; 	counting elapse of training time of an account from last army checking - in minutes
			$aUpdateRemainTrainTime[$i] = $aRemainTrainTime[$i]-$aTimerEnd[$i] 	;   updated remain train time of Active accounts
			If $aUpdateRemainTrainTime[$i] >= 0 Then
			   Setlog("Profile [" & $i+1 & "] - " & $ProfileList[$i+1] & " (Acc. " & $aMatchProfileAcc[$i] & ") will have full army in:" & $aUpdateRemainTrainTime[$i] & " minutes")
			Else
			   Setlog("Profile [" & $i+1 & "] - " & $ProfileList[$i+1] & " (Acc. " & $aMatchProfileAcc[$i] & ") was ready:" & -$aUpdateRemainTrainTime[$i] & " minutes ago")
			EndIf
		 Else ; for accounts first Run
			Setlog("Profile [" & $i+1 & "] - " & $ProfileList[$i+1] & " (Acc. " & $aMatchProfileAcc[$i] & ") has not been read its remain train time")
			$aUpdateRemainTrainTime[$i] = 0
		 EndIf
	  EndIf
   Next

   $nMinRemainTrain = _ArrayMax($aUpdateRemainTrainTime)
   For $i = 0 to $nTotalProfile - 1
	  If $aProfileType[$i] = 1 Then ;	Only check Active profiles
		 If $aUpdateRemainTrainTime[$i] <=  $nMinRemainTrain Then
			$nMinRemainTrain = $aUpdateRemainTrainTime[$i]
			$nNexProfile = $i + 1
		 EndIf
	  EndIf
   Next

EndFunc

Func SwitchProfile($SwitchCase) 										; Switch profile (1 = Active, 2 = Donate, 3 = Stay, 4 = switching continuosly) - DEMEN

   $nCurProfile = _GUICtrlComboBox_GetCurSel($cmbProfile)+1
   $aDonateProfile = _ArrayFindAll($aProfileType, 2)

   Switch $SwitchCase
   Case 1
	  Setlog("Switch to active Profile ["& $nNexProfile & "] - " & $ProfileList[$nNexProfile] & " (Acc. " & $aMatchProfileAcc[$nNexProfile-1] & ")")
	  _GUICtrlComboBox_SetCurSel($cmbProfile, $nNexProfile - 1)
	  cmbProfile()

   Case 2
	  $nNexProfile = $aDonateProfile[$DonateSwitchCounter] + 1
	  Setlog("Switch to Profile ["& $nNexProfile & "] - " & $ProfileList[$nNexProfile] & " (Acc. " & $aMatchProfileAcc[$nNexProfile - 1] & ") for donating")
	  _GUICtrlComboBox_SetCurSel($cmbProfile, $nNexProfile - 1)
	  $DonateSwitchCounter += 1
	  cmbProfile()

   Case 3
	 Setlog("Staying in this profile")

   Case 4
	 Setlog("Switching to next account")
	 $NextProfile = 1
	 If $nCurProfile < $nTotalProfile Then
		$NextProfile = $nCurProfile + 1
	 Else
		$NextProfile = 1
	 EndIf
	 While $aProfileType[$NextProfile-1] = 3
		If $NextProfile < $nTotalProfile Then
		   $NextProfile += 1
		Else
		   $NextProfile = 1
		EndIf
		If $aProfileType[$NextProfile-1] <> 3 Then ExitLoop
	  WEnd
     _GUICtrlComboBox_SetCurSel($cmbProfile, $NextProfile-1)
	  cmbProfile()
   EndSwitch

   If _Sleep(2000) Then Return

   $nCurProfile = _GUICtrlComboBox_GetCurSel($cmbProfile)+1

EndFunc

Func CheckSwitchAcc(); Switch CoC Account with or without sleep combo - DEMEN

	SetLog("Start SwitchAcc Mode")


   If IsMainPage() = False Then ClickP($aAway, 2, 250, "#0335")	; Sometimes the bot cannot open Army Overview Window, trying to click away first
   If IsMainPage() = False Then checkMainScreen()				; checkmainscreen (may restart CoC) if still fail to locate main page.
   getArmyTroopTime(True, False)

   If IsWaitforSpellsActive() Then
	  getArmySpellTime()
   Else
	  $aTimeTrain[1] = 0
   EndIf

   If IsWaitforHeroesActive() Then
	  CheckWaitHero()
   Else
	  $aTimeTrain[2] = 0
   EndIf

   ClickP($aAway, 1, 0, "#0000") ;Click Away

   If $aProfileType[$nCurProfile-1] = 2 Or _ArrayMax($aTimeTrain)> 3 Then
	  Local $SwitchCase
	  $aDonateProfile = _ArrayFindAll($aProfileType, 2)
	  MinRemainTrainAcc()

	  If $ichkSmartSwitch = 1 And _ArraySearch($aProfileType, 1) <> -1 Then		; Smart switch and there is at least 1 active profile
		 If $nMinRemainTrain <= 3 Then
			If $nCurProfile <> $nNexProfile Then
			   $SwitchCase = 1
			Else
			   $SwitchCase = 3
			EndIf
		 Else
			If $DonateSwitchCounter < UBound($aDonateProfile) Then
			   $SwitchCase = 2
			Else
			   If $nCurProfile <> $nNexProfile Then
				  $SwitchCase = 1
			   Else
				  $SwitchCase = 3
			   EndIf
			   $DonateSwitchCounter = 0
			EndIf
		 EndIf
	  Else
		 $SwitchCase = 4
	  EndIf

	  If $SwitchCase <> 3 Then
		 If $aProfileType[$nCurProfile-1] = 1 And $iPlannedRequestCCHoursEnable = 1 And $canRequestCC = True Then
			Setlog("Try Request troops before switching account", $COLOR_BLUE)
			RequestCC()
		 EndIf
		 SwitchProfile($SwitchCase)
		 checkMainScreen()
		 SwitchCOCAcc()
	  Else
		 SwitchProfile($SwitchCase)
	  EndIf

	  If $ichkCloseTraining >= 1 And $nMinRemainTrain > 3 And $SwitchCase <> 2 Then
		 VillageReport()
		 ReArm()
		 If $iPlannedRequestCCHoursEnable = 1 And $canRequestCC = True Then
			Setlog("Try Request troops before going to sleep", $COLOR_BLUE)
			RequestCC()
		 EndIf
		 PoliteCloseCoC()
		 $iShouldRearm = True
		 If $ichkCloseTraining = 2 Then CloseAndroid("SwitchAcc")
		 EnableGuiControls() ; enable emulator menu controls
		 SetLog("Enable emulator menu controls due long wait time!")
		 If $ichkCloseTraining = 1 Then
			 WaitnOpenCoC(($nMinRemainTrain - 1) * 60 * 1000, True)
		 Else
			 If _SleepStatus(($nMinRemainTrain - 1.5) * 60 * 1000) Then Return
			 OpenAndroid()
			 OpenCoC()
		 EndIf

		 SaveConfig()
		 readConfig()
		 applyConfig()
		 DisableGuiControls()
	  EndIf
	  If $SwitchCase <> 3 Then runBot()
   Else
	  Setlog("Army is getting ready soon, skip switching account")
	  If _Sleep(1000) Then Return
   EndIf

EndFunc; ==> Check & Switch CoC Account with / without sleep combo - DEMEN

Func SwitchCOCAcc()
   Local Const $XConnect = 431
   Local Const $YConnect = 434
   Local Const $ColorConnect = 4284458031      ;Connected Button: green

   Setlog ("Switching CoC Account to match with Bot Profile ", $COLOR_BLUE)

   Click(820, 585, 1, 0, "Click Setting")      ;Click setting
   If _Sleepstatus(5000) Then Return

   If _ColorCheck(_GetPixelColor($XConnect, $YConnect, True), Hex($ColorConnect, 6), 20) Then       ;Blue
	  Click($XConnect, $YConnect, 1, 0, "Click Connected")      ;Click Connect
   EndIf

   If _Sleepstatus(3000) Then Return

   Click($XConnect, $YConnect, 1, 0, "Click DisConnect")      ;Click DisConnect

   If _Sleepstatus(10000) Then Return


   Local $nCurCoCAcc
   $nCurCoCAcc = $aMatchProfileAcc[$nCurProfile-1]
   Setlog ("Switching to Account [" & $nCurCoCAcc & "]")

   If $aAccPosY[$nCurCoCAcc-1] > 0 Then
	   Click(383, $aAccPosY[$nCurCoCAcc-1], 1, 0, "Click Account " & $nCurCoCAcc)      ;Click Account - DEMEN
   Else
	   Click(383, 373.5 - ($nTotalCoCAcc - 1)*36.5 + 73*($nCurCoCAcc - 1), 1, 0, "Click Account " & $nCurCoCAcc)      ;Click Account - DEMEN
   EndIf

   If _Sleepstatus(10000) Then Return

   If _ColorCheck(_GetPixelColor($XConnect, $YConnect, True), Hex($ColorConnect, 6), 20) Then       ;Blue
	  Setlog("Already in current account")
	  ClickP($aAway, 1, 0, "#0167") ;Click Away
	  If _Sleep(2000) Then Return
	  $bReMatchAcc = False
   Else
	  $idx = 0
	  While $idx <= 15
		 If _ColorCheck(_GetPixelColor(443, 430, True), Hex(4284390935, 6), 20) Then
			Setlog("Load button appears")
			If _Sleepstatus(1000) Then Return
			Click(443, 430, 1, 0, "Click Load")      ;Click Load
			ExitLoop
		 Else
			Setlog("Wait!")
			If _Sleepstatus(1000) Then Return
			$idx += 1
			If $idx = 15 Then
				Setlog("Switching account fail, reloading CoC", $COLOR_RED)
				$bReMatchAcc = True
				WaitnOpenCoC(5000,true)
				runBot()
			EndIf
		 EndIf
	  WEnd

;~ 	  $idx = 0
;~ 	  While _ColorCheck(_GetPixelColor(443, 430, True), Hex(4284390935, 6), 20) And $idx <= 40
;~ 		 If _Sleepstatus(1000) Then Return
;~ 		 Click(443, 430, 1, 0, "Click Load")      ;Click Load
;~ 		 $idx = $idx + 1
;~ 	  WEnd

	  If _Sleepstatus(5000) Then Return
	  PureClick(353, 180, 1, 0, "Click Text box")      ;Click Text box
	  If _Sleepstatus(2000) Then Return
	  AndroidSendText("CONFIRM")

	  $idx = 0
	  While $idx <= 10
		 If _ColorCheck(_GetPixelColor(480, 200, True), "71BB1E", 20) Then
			Setlog("Typing CONFIRM completed, ready to click 'OKAY'")
			ExitLoop
		 Else
			If _Sleepstatus(1000) Then Return
			$idx = $idx + 1
		 EndIf
	  WEnd

	  If _ColorCheck(_GetPixelColor(480, 200, True), "71BB1E", 20) Then
		 If _Sleepstatus(1000) Then Return
		 PureClick(480, 200, 1, 0, "Click CONFIRM")      ;Click CONFIRM
		 Setlog("OKAY button clicked")
		 Setlog("please wait 15 seconds for loading CoC")
		 If _Sleepstatus(3000) Then Return
		 ClickP($aAway, 1, 0, "#0167") ;Click Away
		 If _Sleepstatus(15000) Then Return
		 $bReMatchAcc = False
		 $iShouldRearm = True
	   Else
		 Setlog("Error in typing CONFIRM or finding OKAY button, reloading CoC", $COLOR_RED)
		 $bReMatchAcc = True
		 WaitnOpenCoC(5000,true)
		 runBot()
	  EndIf
   EndIf
EndFunc     ;==> SwitchCOCAcc
