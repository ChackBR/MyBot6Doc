; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
; Return values .: NA
; Author ........:
; Modified ......: ProMac (2017), RoroTiti (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ApplyConfig_DocOc($TypeReadSave)
	Switch $TypeReadSave
		Case "Save"
			; ================================================== BOT HUMANIZATION PART ================================================== ;
			$g_ichkUseBotHumanization = GUICtrlRead($chkUseBotHumanization) = $GUI_CHECKED ? 1 : 0
			$g_ichkUseAltRClick = GUICtrlRead($chkUseAltRClick) = $GUI_CHECKED ? 1 : 0
			$g_ichkCollectAchievements = GUICtrlRead($chkCollectAchievements) = $GUI_CHECKED ? 1 : 0
			$g_ichkLookAtRedNotifications = GUICtrlRead($chkLookAtRedNotifications) = $GUI_CHECKED ? 1 : 0
			For $i = 0 To 12
				$g_iacmbPriority[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
			Next
			For $i = 0 To 1
				$g_iacmbMaxSpeed[$i] = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				$g_iacmbPause[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPause[$i])
			Next
			For $i = 0 To 1
				$g_iahumanMessage[$i] = GUICtrlRead($g_ahumanMessage[$i])
			Next
			$g_icmbMaxActionsNumber = _GUICtrlComboBox_GetCurSel($g_icmbMaxActionsNumber)
			; ================================================== BOT HUMANIZATION END ================================================== ;

			; ================================================== TREASURY COLLECT PART ================================================== ;
			$g_ichkEnableTrCollect = GUICtrlRead($chkEnableTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkForceTrCollect = GUICtrlRead($chkForceTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkGoldTrCollect = GUICtrlRead($chkGoldTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkElxTrCollect = GUICtrlRead($chkElxTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkDarkTrCollect = GUICtrlRead($chkDarkTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullGoldTrCollect = GUICtrlRead($chkFullGoldTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullElxTrCollect = GUICtrlRead($chkFullElxTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_ichkFullDarkTrCollect = GUICtrlRead($chkFullDarkTrCollect) = $GUI_CHECKED ? 1 : 0
			$g_itxtMinGoldTrCollect = GUICtrlRead($txtMinGoldTrCollect)
			$g_itxtMinElxTrCollect = GUICtrlRead($txtMinElxTrCollect)
			$g_itxtMinDarkTrCollect = GUICtrlRead($txtMinDarkTrCollect)
			; ================================================== TREASURY COLLECT END ================================================== ;

			; ================================================== GOBLINXP PART ================================================== ;

			$ichkEnableSuperXP = GUICtrlRead($chkEnableSuperXP) = $GUI_CHECKED ? 1 : 0
			$irbSXTraining = GUICtrlRead($rbSXTraining) = $GUI_CHECKED ? 1 : 2
			$ichkSXBK = (GUICtrlRead($chkSXBK) = $GUI_CHECKED) ? $eHeroKing : $eHeroNone
			$ichkSXAQ = (GUICtrlRead($chkSXAQ) = $GUI_CHECKED) ? $eHeroQueen : $eHeroNone
			$ichkSXGW = (GUICtrlRead($chkSXGW) = $GUI_CHECKED) ? $eHeroWarden : $eHeroNone
			$itxtMaxXPtoGain = Int(GUICtrlRead($txtMaxXPtoGain))

			; ================================================== GOBLINXP END =================================================== ;

			; Extra Persian language on Donate
			$ichkExtraPersian = (GUICtrlRead($chkExtraPersian) = $GUI_CHECKED) ? 1 : 0


			;SWITCH ACCOUNT
			$ichkSwitchAccount = (GUICtrlRead($chkEnableSwitchAccount) = $GUI_CHECKED) ? 1 : 0
			$icmbAccountsQuantity = _GUICtrlComboBox_GetCurSel($cmbAccountsQuantity)
			For $i = 1 To 8
				$ichkCanUse[$i] = (GUICtrlRead($chkCanUse) = $GUI_CHECKED) ? 1 : 0
				$ichkDonateAccount[$i] = (GUICtrlRead($chkDonateAccount) = $GUI_CHECKED) ? 1 : 0
				$icmbAccount[$i] = _GUICtrlComboBox_GetCurSel($cmbAccount[$i])
			Next

		Case "Read"
			; ================================================== BOT HUMANIZATION PART ================================================== ;
			GUICtrlSetState($chkUseBotHumanization, $g_ichkUseBotHumanization = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkUseAltRClick, $g_ichkUseAltRClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkCollectAchievements, $g_ichkCollectAchievements = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkLookAtRedNotifications, $g_ichkLookAtRedNotifications = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseBotHumanization()
			For $i = 0 To 12
				_GUICtrlComboBox_SetCurSel($g_acmbPriority[$i], $g_iacmbPriority[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbMaxSpeed[$i], $g_iacmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbPause[$i], $g_iacmbPause[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_ahumanMessage[$i], $g_iahumanMessage[$i])
			Next
			_GUICtrlComboBox_SetCurSel($g_icmbMaxActionsNumber, $g_icmbMaxActionsNumber)
			cmbStandardReplay()
			cmbWarReplay()
			; ================================================== BOT HUMANIZATION END ================================================== ;

			; ================================================== TREASURY COLLECT PART ================================================== ;
			GUICtrlSetState($chkEnableTrCollect, $g_ichkEnableTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkForceTrCollect, $g_ichkForceTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkGoldTrCollect, $g_ichkGoldTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkElxTrCollect, $g_ichkElxTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkDarkTrCollect, $g_ichkDarkTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkFullGoldTrCollect, $g_ichkFullGoldTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkFullElxTrCollect, $g_ichkFullElxTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkFullDarkTrCollect, $g_ichkFullDarkTrCollect = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($txtMinGoldTrCollect, $g_itxtMinGoldTrCollect)
			GUICtrlSetData($txtMinElxTrCollect, $g_itxtMinElxTrCollect)
			GUICtrlSetData($txtMinDarkTrCollect, $g_itxtMinDarkTrCollect)
			chkEnableTrCollect()
			; ================================================== TREASURY COLLECT END ================================================== ;

			; ================================================== GOBLINXP PART ================================================== ;

			GUICtrlSetState($chkEnableSuperXP, $ichkEnableSuperXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)

			chkEnableSuperXP()

			GUICtrlSetState($rbSXTraining, ($irbSXTraining = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($rbSXIAttacking, ($irbSXTraining = 2) ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetData($txtMaxXPtoGain, $itxtMaxXPtoGain)

			GUICtrlSetState($chkSXBK, $ichkSXBK = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXAQ, $ichkSXAQ = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXGW, $ichkSXGW = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)

			; ================================================== GOBLINXP END =================================================== ;

			; Extra Persian language on Donate
			GUICtrlSetState($chkExtraPersian, ($ichkExtraPersian = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)


	; Smart Switch Account
			GUICtrlSetState($chkEnableSwitchAccount, ($ichkSwitchAccount = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($cmbAccountsQuantity, $icmbAccountsQuantity)

			For $i = 1 To 8
				GUICtrlSetState($chkCanUse[$i], ($ichkCanUse[$i] = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($chkDonateAccount[$i], ($ichkDonateAccount[$i] = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($cmbAccount[$i], $icmbAccount[$i])
			Next
			chkSwitchAccount()
	EndSwitch
EndFunc   ;==>ApplyConfig_DocOc
