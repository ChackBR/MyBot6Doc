; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file controls the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: ProMac (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func DisableSX()
	GUICtrlSetState($chkEnableSuperXP, $GUI_UNCHECKED)
	$ichkEnableSuperXP = 0

	For $i = $grpSuperXP To $lblXPSXWonHour
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

	GUICtrlSetState($lblLOCKEDSX, BitOR($GUI_SHOW, $GUI_ENABLE))
EndFunc   ;==>DisableSX

Func SXSetXP($toSet = "")
	If $toSet = "S" Or $toSet = "" Then GUICtrlSetData($lblXPatStart, $iStartXP)
	If $toSet = "C" Or $toSet = "" Then GUICtrlSetData($lblXPCurrent, $iCurrentXP)
	If $toSet = "W" Or $toSet = "" Then GUICtrlSetData($lblXPSXWon, $iGainedXP)
	$iGainedXPHour = Round($iGainedXP / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)
	If $toSet = "H" Or $toSet = "" Then GUICtrlSetData($lblXPSXWonHour, _NumberFormat($iGainedXPHour))

EndFunc   ;==>SXSetXP


Func chkEnableSuperXP()

	If GUICtrlRead($chkEnableSuperXP) = $GUI_CHECKED Then
		GUICtrlSetState($rbSXTraining, $GUI_ENABLE)
		GUICtrlSetState($rbSXIAttacking, $GUI_ENABLE)
		GUICtrlSetState($chkSXBK, $GUI_ENABLE)
		GUICtrlSetState($chkSXAQ, $GUI_ENABLE)
		GUICtrlSetState($chkSXGW, $GUI_ENABLE)
		GUICtrlSetState($txtMaxXPtoGain, $GUI_ENABLE)
	Else
		GUICtrlSetState($rbSXTraining, $GUI_DISABLE)
		GUICtrlSetState($rbSXIAttacking, $GUI_DISABLE)
		GUICtrlSetState($chkSXBK, $GUI_DISABLE)
		GUICtrlSetState($chkSXAQ, $GUI_DISABLE)
		GUICtrlSetState($chkSXGW, $GUI_DISABLE)
		GUICtrlSetState($txtMaxXPtoGain, $GUI_DISABLE)
	EndIf

EndFunc   ;==>chkEnableSuperXP


Func chkEnableSuperXP2()

	$ichkEnableSuperXP = GUICtrlRead($chkEnableSuperXP) = $GUI_CHECKED ? 1 : 0
	$irbSXTraining = GUICtrlRead($rbSXTraining) = $GUI_CHECKED ? 1 : 2
	$ichkSXBK = (GUICtrlRead($chkSXBK) = $GUI_CHECKED) ? $eHeroKing : $eHeroNone
	$ichkSXAQ = (GUICtrlRead($chkSXAQ) = $GUI_CHECKED) ? $eHeroQueen : $eHeroNone
	$ichkSXGW = (GUICtrlRead($chkSXGW) = $GUI_CHECKED) ? $eHeroWarden : $eHeroNone
	$itxtMaxXPtoGain = Int(GUICtrlRead($txtMaxXPtoGain))

EndFunc   ;==>chkEnableSuperXP2


; DOC OC ADD - CLASSIC FFF
Func cmbDeployDB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB) = 4 Then
		For $i = $g_hChkSmartAttackRedAreaDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		For $i = $g_hChkSmartAttackRedAreaDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
EndFunc   ;==>cmbDeployDB

Func cmbDeployAB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesAB) = 4 Then
		For $i = $g_hChkSmartAttackRedAreaAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_UNCHECKED)
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		For $i = $g_hChkSmartAttackRedAreaAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	EndIf
EndFunc   ;==>cmbDeployAB


; Extra PErsian language to Donate
Func Donatelang()
	$ichkExtraPersian = (GUICtrlRead($chkExtraPersian) = $GUI_CHECKED) ? 1 : 0
EndFunc

; Warden Force ability
Func CheckWardenTimer()

	If GUICtrlRead($g_hChkUseWardenAbility) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtWardenAbility, $GUI_ENABLE)
		$iActivateWardenCondition = 1
	Else
		GUICtrlSetState($g_hTxtWardenAbility, $GUI_DISABLE)
		$iActivateWardenCondition = 0
	EndIf

EndFunc

Func delayWardenTimer()

	$delayActivateW = Int(GUICtrlRead($g_hTxtWardenAbility)) * 1000

EndFunc
