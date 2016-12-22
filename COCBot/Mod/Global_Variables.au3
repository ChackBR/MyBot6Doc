; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables - Mod.au3
; Description ...: Extension of MBR Global Variables for Mod
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; Global Variables
;

;
; mandryd
;

; Max logout time
Global $TrainLogoutMaxTime, $TrainLogoutMaxTimeTXT

;
; LunaEclipse
;

; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 0

Global Enum  $eCCSpell = $eHaSpell + 1

;
; ================================================== SmartSwitchAccount PART ================================================== ;
;
Global $chkCanUse[6] = [0, 0, 0, 0, 0, 0]
Global $chkDonateAccount[6] = [0, 0, 0, 0, 0, 0]
Global $cmbAccount[6] = [0, 0, 0, 0, 0, 0]

Global $ichkCanUse[6] = [0, 0, 0, 0, 0, 0]
Global $ichkDonateAccount[6] = [0, 0, 0, 0, 0, 0]
Global $icmbAccount[6] = [0, 0, 0, 0, 0, 0]

Global $icmbAccountsQuantity = 0

Global $AllAccountsWaitTimeDiff[6] = [0, 0, 0, 0, 0, 0]
Global $AllAccountsWaitTime[6] = [0, 0, 0, 0, 0, 0]

Global $CurrentAccountWaitTime = 0

Global $TimerDiffStart[6] = [0, 0, 0, 0, 0, 0]
Global $TimerDiffEnd[6] = [0, 0, 0, 0, 0, 0]

Global $Init = False
Global $TotalAccountsOnEmu = 0
Global $CurrentAccount = 1
Global $CurrentDAccount = 1
Global $FirstLoop = 0
Global $FirstInit = True
Global $MustGoToDonateAccount = 0
Global $yCoord, $HeroesRemainingWait, $TotalAccountsInUse, $TotalDAccountsInUse, $ichkSwitchAccount, $NextAccount, $NextProfile
Global $cycleCount = 0
Global $IsDonateAccount = 0

Global $SSAConfig = $sProfilePath & "\Profile.ini"

Global 	$profileString = ""

; ================================================== SmartSwitchAccount END ================================================== ;
