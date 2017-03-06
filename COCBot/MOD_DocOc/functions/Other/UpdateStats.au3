; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........: kaganus (06-2015)
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (02-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
#include-once
;Completed Conversions
;g_iStatsLastAttack, g_iStatsBonusLast, g_iStatsStartedWith
; [$CurrentAccount]  iDarkCurrent
Global $ResetStats = 0

Func UpdateStats($bForceUpdateAll = False)
	Local $bDonateTroopsStatsChanged = False, $bDonateSpellsStatsChanged = False

	Local Static $iOldFreeBuilderCount[9], $iOldTotalBuilderCount[9], $iOldGemAmount[9] ; builder and gem amounts
	Local Static $iOldGoldCurrent[9], $iOldElixirCurrent[9], $iOldDarkCurrent[9], $iOldTrophyCurrent[9] ; current stats
	Local Static $iOldSkippedVillageCount[9], $iOldDroppedTrophyCount[9] ; skipped village and dropped trophy counts
	Local Static $iOldSearchCost[9], $iOldTrainCostElixir[9], $iOldTrainCostDElixir[9] ; search and train troops cost
	Local Static $iOldGoldFromMines[9], $iOldElixirFromCollectors[9], $iOldDElixirFromDrills[9] ; number of resources gain by collecting mines, collectors, drills
	Local Static $iOldNbrOfWallsUppedGold[9], $iOldNbrOfWallsUppedElixir[9], $iOldNbrOfBuildingsUppedGold[9], $iOldNbrOfBuildingsUppedElixir[9], $iOldNbrOfHeroesUpped[9] ; number of wall, building, hero upgrades with gold, elixir, delixir
	Local Static $iOldCostGoldWall[9], $iOldCostElixirWall[9], $iOldCostGoldBuilding[9], $iOldCostElixirBuilding[9], $iOldCostDElixirHero[9] ; wall, building and hero upgrade costs
	Local Static $iOldAttackedCount = 0, $iOldAttackedVillageCount[9][$g_iModeCount + 1] ; number of attack villages for DB, LB, TB, TS
	Local Static $iOldTotalGoldGain[9][$g_iModeCount + 1], $iOldTotalElixirGain[9][$g_iModeCount + 1], $iOldTotalDarkGain[9][$g_iModeCount + 1], $iOldTotalTrophyGain[9][$g_iModeCount + 1] ; total resource gains for DB, LB, TB, TS
	Local Static $iOldNbrOfDetectedMines[9][$g_iModeCount + 1], $iOldNbrOfDetectedCollectors[9][$g_iModeCount + 1], $iOldNbrOfDetectedDrills[9][$g_iModeCount + 1] ; number of mines, collectors, drills detected for DB, LB, TB
	Local Static $iOldNbrOfTHSnipeFails[9], $iOldNbrOfTHSnipeSuccess[9] ; number of fails and success while TH Sniping
	Local static $s_iOldSmartZapGain[9], $s_iOldNumLSpellsUsed[9], $s_iOldNumEQSpellsUsed[9]

	
	Local Static $iOldGoldTotal = 0, $iOldElixirTotal = 0, $iOldDarkTotal = 0, $iOldTrophyTotal = 0 ; total stats
	Local Static $iOldGoldLast = 0, $iOldElixirLast = 0, $iOldDarkLast = 0, $iOldTrophyLast = 0 ; loot and trophy gain from last raid
	Local Static $iOldGoldLastBonus = 0, $iOldElixirLastBonus = 0, $iOldDarkLastBonus = 0 ; bonus loot from last raid
	Local Static $iOldNbrOfOoS = 0 ; number of Out of Sync occurred

	Local Static $topgoldloot = 0
	Local Static $topelixirloot = 0
	Local Static $topdarkloot = 0
	Local Static $topTrophyloot = 0

	If $g_iFirstRun = 1 Then
		;GUICtrlSetState($g_hLblResultStatsTemp, $GUI_HIDE)
		GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)

		GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW + $GUI_DISABLE) ; $GUI_DISABLE to trigger default view in btnVillageStat
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
		If $iDarkCurrent <> "" Then
			GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)
		Else
			GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
			GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
		EndIf
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
		btnVillageStat("UpdateStats")

		; First Start Values

		$g_iStatsStartedWith[$CurrentAccount][$eLootGold] = $iGoldCurrent
		$g_iStatsStartedWith[$CurrentAccount][$eLootElixir] = $iElixirCurrent
		$g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] = $iDarkCurrent
		$g_iStatsStartedWith[$CurrentAccount][$eLootTrophy] = $iTrophyCurrent

;		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootGold], True))
;		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootElixir], True))
;		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootTrophy], True))

;		If $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "" Then
;			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir], True))
;		EndIf
		$g_iFirstRun = 0
	EndIf

	GUICtrlSetState($btnResetStats, $GUI_ENABLE)

;	Return ; Remove for  Multi

; Update Values of all Stats

	If $g_iFirstAttack = 1 Then
		$g_iFirstAttack = 2
	EndIf

	;Update Stats Gain Tab
		;Update TH Lvl

	;Update League Lvl
		;Updated in AttackReport

	;StartWith
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootGold], True))
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootElixir], True))
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootTrophy], True))

		If $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir], True))
		EndIf

	;Gain Per Hour
	If $g_iFirstAttack = 2 Then
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootGold] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		If $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootDarkElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		EndIf
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootTrophy] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")

	;UPDATE PER HOUR STATS IN BOTTOM BAR
		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootGold] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		If $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_iStatsTotalGain[$CurrentAccount][$eLootDarkElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf
	EndIf

	; Total Gain
	If $bForceUpdateAll = True Or ($iOldGoldTotal <> $g_iStatsTotalGain[$CurrentAccount][$eLootGold] And ($g_iFirstAttack = 2 Or $ResetStats = 1)) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], _NumberFormat($g_iStatsTotalGain[$CurrentAccount][$eLootGold]))
		$iOldGoldTotal = $g_iStatsTotalGain[$CurrentAccount][$eLootGold]
	EndIf

	If $bForceUpdateAll = True Or ($iOldElixirTotal <> $g_iStatsTotalGain[$CurrentAccount][$eLootElixir] And ($g_iFirstAttack = 2 Or $ResetStats = 1)) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], _NumberFormat($g_iStatsTotalGain[$CurrentAccount][$eLootElixir]))
		$iOldElixirTotal = $g_iStatsTotalGain[$CurrentAccount][$eLootElixir]
	EndIf

	If $bForceUpdateAll = True Or ($iOldDarkTotal <> $g_iStatsTotalGain[$CurrentAccount][$eLootDarkElixir] And (($g_iFirstAttack = 2 And $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "") Or $ResetStats = 1)) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], _NumberFormat($g_iStatsTotalGain[$CurrentAccount][$eLootDarkElixir]))
		$iOldDarkTotal = $g_iStatsTotalGain[$CurrentAccount][$eLootDarkElixir]
	EndIf

	If $bForceUpdateAll = True Or ($iOldTrophyTotal <> $g_iStatsTotalGain[$CurrentAccount][$eLootTrophy] And ($g_iFirstAttack = 2 Or $ResetStats = 1)) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], _NumberFormat($g_iStatsTotalGain[$CurrentAccount][$eLootTrophy]))
		$iOldTrophyTotal = $g_iStatsTotalGain[$CurrentAccount][$eLootTrophy]
	EndIf


	;Last Attack
	If $bForceUpdateAll = True Or $iOldGoldLast <> $g_iStatsLastAttack[$CurrentAccount][$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], _NumberFormat($g_iStatsLastAttack[$CurrentAccount][$eLootGold]))
		$iOldGoldLast = $g_iStatsLastAttack[$CurrentAccount][$eLootGold]
	EndIf

	If $bForceUpdateAll = True Or $iOldElixirLast <> $g_iStatsLastAttack[$CurrentAccount][$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], _NumberFormat($g_iStatsLastAttack[$CurrentAccount][$eLootElixir]))
		$iOldElixirLast = $g_iStatsLastAttack[$CurrentAccount][$eLootElixir]
	EndIf

	If $bForceUpdateAll = True Or $iOldDarkLast <> $g_iStatsLastAttack[$CurrentAccount][$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], _NumberFormat($g_iStatsLastAttack[$CurrentAccount][$eLootDarkElixir]))
		$iOldDarkLast = $g_iStatsLastAttack[$CurrentAccount][$eLootDarkElixir]
	EndIf

	If $bForceUpdateAll = True Or $iOldTrophyLast <> $g_iStatsLastAttack[$CurrentAccount][$eLootTrophy] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], _NumberFormat($g_iStatsLastAttack[$CurrentAccount][$eLootTrophy]))
		$iOldTrophyLast = $g_iStatsLastAttack[$CurrentAccount][$eLootTrophy]
	EndIf


	;League Bonus
	If $bForceUpdateAll = True Or $iOldGoldLastBonus <> $g_iStatsBonusLast[$CurrentAccount][$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], _NumberFormat($g_iStatsBonusLast[$CurrentAccount][$eLootGold]))
		$iOldGoldLastBonus = $g_iStatsBonusLast[$CurrentAccount][$eLootGold]
	EndIf

	If $bForceUpdateAll = True Or $iOldElixirLastBonus <> $g_iStatsBonusLast[$CurrentAccount][$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], _NumberFormat($g_iStatsBonusLast[$CurrentAccount][$eLootElixir]))
		$iOldElixirLastBonus = $g_iStatsBonusLast[$CurrentAccount][$eLootElixir]
	EndIf

	If $bForceUpdateAll = True Or $iOldDarkLastBonus <> $g_iStatsBonusLast[$CurrentAccount][$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootDarkElixir], _NumberFormat($g_iStatsBonusLast[$CurrentAccount][$eLootDarkElixir]))
		$iOldDarkLastBonus = $g_iStatsBonusLast[$CurrentAccount][$eLootDarkElixir]
	EndIf


	;Top Loot
	If Number($g_iStatsLastAttack[$CurrentAccount][$eLootGold]) > Number($topgoldloot) Then
		$topgoldloot = $g_iStatsLastAttack[$CurrentAccount][$eLootGold]
		GUICtrlSetData($g_ahLblStatsTop[$eLootGold], _NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$CurrentAccount][$eLootElixir]) > Number($topelixirloot) Then
		$topelixirloot = $g_iStatsLastAttack[$CurrentAccount][$eLootElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootElixir], _NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$CurrentAccount][$eLootDarkElixir]) > Number($topdarkloot) Then
		$topdarkloot = $g_iStatsLastAttack[$CurrentAccount][$eLootDarkElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir], _NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$CurrentAccount][$eLootTrophy]) > Number($topTrophyloot) Then
		$topTrophyloot = $g_iStatsLastAttack[$CurrentAccount][$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy], _NumberFormat($topTrophyloot))
	EndIf

; Stats Tab Misc
	;Section Run
		;runtime - updated in func settime
		;Nbr Of Oos Left as a total/ Not per Account
		If $bForceUpdateAll = True Or $iOldNbrOfOoS <> $iNbrOfOoS Then
			GUICtrlSetData($g_hLblNbrOfOoS, $iNbrOfOoS)
			$iOldNbrOfOoS = $iNbrOfOoS
		EndIf

		;Attacked Per Account
			;Updated In updateStats in the section attack

		;Skipped Per Account
		If $bForceUpdateAll = True Or $iOldSkippedVillageCount[$CurrentAccount] <> $g_iSkippedVillageCount[$CurrentAccount] Then
			GUICtrlSetData($g_hLblResultVillagesSkipped, _NumberFormat($g_iSkippedVillageCount[$CurrentAccount], True))
			GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($g_iSkippedVillageCount[$CurrentAccount], True))
			$iOldSkippedVillageCount[$CurrentAccount] = $g_iSkippedVillageCount[$CurrentAccount]
		EndIf

		;Dropped Trophies Per Account
		If $bForceUpdateAll = True Or $iOldDroppedTrophyCount[$CurrentAccount] <> $g_iDroppedTrophyCount[$CurrentAccount] Then
			GUICtrlSetData($g_hLblResultTrophiesDropped, _NumberFormat($g_iDroppedTrophyCount[$CurrentAccount], True))
			$iOldDroppedTrophyCount[$CurrentAccount] = $g_iDroppedTrophyCount[$CurrentAccount]
		EndIf

	;Section Cost & Collect
		;Search Cost
		If $bForceUpdateAll = True Or $iOldSearchCost[$CurrentAccount] <> $g_iSearchCost[$CurrentAccount] Then
			GUICtrlSetData($g_hLblSearchCost, _NumberFormat($g_iSearchCost[$CurrentAccount], True))
			$iOldSearchCost[$CurrentAccount] = $g_iSearchCost[$CurrentAccount]
		EndIf

		;Train Cost Elixir
		If $bForceUpdateAll = True Or $iOldTrainCostElixir[$CurrentAccount] <> $g_iTrainCostElixir[$CurrentAccount] Then
			GUICtrlSetData($g_hLblTrainCostElixir, _NumberFormat($g_iTrainCostElixir[$CurrentAccount], True))
			$iOldTrainCostElixir[$CurrentAccount] = $g_iTrainCostElixir[$CurrentAccount]
		EndIf

		;Train Cost DElixir
		If $bForceUpdateAll = True Or $iOldTrainCostDElixir[$CurrentAccount] <> $g_iTrainCostDElixir[$CurrentAccount] Then
			GUICtrlSetData($g_hLblTrainCostDElixir, _NumberFormat($g_iTrainCostDElixir[$CurrentAccount], True))
			$iOldTrainCostDElixir[$CurrentAccount] = $g_iTrainCostDElixir[$CurrentAccount]
		EndIf

		;Gold Collected
		If $bForceUpdateAll = True Or $iOldGoldFromMines[$CurrentAccount] <> $g_iGoldFromMines[$CurrentAccount] Then
			GUICtrlSetData($g_hLblGoldFromMines, _NumberFormat($g_iGoldFromMines[$CurrentAccount], True))
			$iOldGoldFromMines[$CurrentAccount] = $g_iGoldFromMines[$CurrentAccount]
		EndIf

		;Elixir Collected
		If $bForceUpdateAll = True Or $iOldElixirFromCollectors[$CurrentAccount] <> $g_iElixirFromCollectors[$CurrentAccount] Then
			GUICtrlSetData($g_hLblElixirFromCollectors, _NumberFormat($g_iElixirFromCollectors[$CurrentAccount], True))
			$iOldElixirFromCollectors[$CurrentAccount] = $g_iElixirFromCollectors[$CurrentAccount]
		EndIf

		;Dark Collected
		If $bForceUpdateAll = True Or $iOldDElixirFromDrills[$CurrentAccount] <> $g_iDElixirFromDrills[$CurrentAccount] Then
			GUICtrlSetData($g_hLblDElixirFromDrills, _NumberFormat($g_iDElixirFromDrills[$CurrentAccount], True))
			$iOldDElixirFromDrills[$CurrentAccount] = $g_iDElixirFromDrills[$CurrentAccount]
		EndIf

	;Section Upgrades Made
		;walls by Gold
		If $bForceUpdateAll = True Or $iOldNbrOfWallsUppedGold[$CurrentAccount] <> Number($g_iNbrOfWallsUppedGold[$CurrentAccount]) Then
			GUICtrlSetData($g_hLblWallGoldMake, Number($g_iNbrOfWallsUppedGold[$CurrentAccount]))
			$iOldNbrOfWallsUppedGold[$CurrentAccount] = Number($g_iNbrOfWallsUppedGold[$CurrentAccount])
			WallsStatsMAJ()
		EndIf

		;walls by elixir
		If $bForceUpdateAll = True Or $iOldNbrOfWallsUppedElixir[$CurrentAccount] <> Number($g_iNbrOfWallsUppedElixir[$CurrentAccount]) Then
			GUICtrlSetData($g_hLblWallElixirMake, Number($g_iNbrOfWallsUppedElixir[$CurrentAccount]))
			$iOldNbrOfWallsUppedElixir[$CurrentAccount] = Number($g_iNbrOfWallsUppedElixir[$CurrentAccount])
			WallsStatsMAJ()
		EndIf

		;building by gold
		If $bForceUpdateAll = True Or $iOldNbrOfBuildingsUppedGold[$CurrentAccount] <> $g_iNbrOfBuildingsUppedGold[$CurrentAccount] Then
			GUICtrlSetData($g_hLblNbrOfBuildingUpgGold, $g_iNbrOfBuildingsUppedGold[$CurrentAccount])
			$iOldNbrOfBuildingsUppedGold[$CurrentAccount] = $g_iNbrOfBuildingsUppedGold[$CurrentAccount]
		EndIf

		;building by elixir
		If $bForceUpdateAll = True Or $iOldNbrOfBuildingsUppedElixir[$CurrentAccount] <> $g_iNbrOfBuildingsUppedElixir[$CurrentAccount] Then
			GUICtrlSetData($g_hLblNbrOfBuildingUpgElixir, $g_iNbrOfBuildingsUppedElixir[$CurrentAccount])
			$iOldNbrOfBuildingsUppedElixir[$CurrentAccount] = $g_iNbrOfBuildingsUppedElixir[$CurrentAccount]
		EndIf

		;Hero upgrade
		If $bForceUpdateAll = True Or $iOldNbrOfHeroesUpped[$CurrentAccount] <> $g_iNbrOfHeroesUpped[$CurrentAccount] Then
			GUICtrlSetData($g_hLblNbrOfHeroUpg, $g_iNbrOfHeroesUpped[$CurrentAccount])
			$iOldNbrOfHeroesUpped[$CurrentAccount] = $g_iNbrOfHeroesUpped[$CurrentAccount]
		EndIf
		
	;Section Upgrade Costs
		;wall cost gold
		If $bForceUpdateAll = True Or $iOldCostGoldWall[$CurrentAccount] <> $g_iCostGoldWall[$CurrentAccount] Then
			GUICtrlSetData($g_hLblWallUpgCostGold, _NumberFormat($g_iCostGoldWall[$CurrentAccount], True))
			$iOldCostGoldWall[$CurrentAccount] = $g_iCostGoldWall[$CurrentAccount]
		EndIf

		;wall cost elixir
		If $bForceUpdateAll = True Or $iOldCostElixirWall[$CurrentAccount] <> $g_iCostElixirWall[$CurrentAccount] Then
			GUICtrlSetData($g_hLblWallUpgCostElixir, _NumberFormat($g_iCostElixirWall[$CurrentAccount], True))
			$iOldCostElixirWall[$CurrentAccount] = $g_iCostElixirWall[$CurrentAccount]
		EndIf

		;building cost gold
		If $bForceUpdateAll = True Or $iOldCostGoldBuilding[$CurrentAccount] <> $g_iCostGoldBuilding[$CurrentAccount] Then
			GUICtrlSetData($g_hLblBuildingUpgCostGold, _NumberFormat($g_iCostGoldBuilding[$CurrentAccount], True))
			$iOldCostGoldBuilding[$CurrentAccount] = $g_iCostGoldBuilding[$CurrentAccount]
		EndIf

		;building cost elixir
		If $bForceUpdateAll = True Or $iOldCostElixirBuilding[$CurrentAccount] <> $g_iCostElixirBuilding[$CurrentAccount] Then
			GUICtrlSetData($g_hLblBuildingUpgCostElixir, _NumberFormat($g_iCostElixirBuilding[$CurrentAccount], True))
			$iOldCostElixirBuilding[$CurrentAccount] = $g_iCostElixirBuilding[$CurrentAccount]
		EndIf

		;upgrade cost dark elixir
		If $bForceUpdateAll = True Or $iOldCostDElixirHero[$CurrentAccount] <> $g_iCostDElixirHero[$CurrentAccount] Then
			GUICtrlSetData($g_hLblHeroUpgCost, _NumberFormat($g_iCostDElixirHero[$CurrentAccount], True))
			$iOldCostDElixirHero[$CurrentAccount] = $g_iCostDElixirHero[$CurrentAccount]
		EndIf

;Stats TAB ATTACKS

	$iAttackedCount = 0
	For $i = 0 To $g_iModeCount ; Totals Gained by Attack type; ts, dead base, alive base, weak base
		If $bForceUpdateAll = True Or $iOldAttackedVillageCount[$CurrentAccount][$i] <> $g_iAttackedVillageCount[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblAttacked[$i], _NumberFormat($g_iAttackedVillageCount[$CurrentAccount][$i], True))
			$iOldAttackedVillageCount[$CurrentAccount][$i] = $g_iAttackedVillageCount[$CurrentAccount][$i]
		EndIf
		$iAttackedCount += $g_iAttackedVillageCount[$CurrentAccount][$i]

		If $bForceUpdateAll = True Or $iOldTotalGoldGain[$CurrentAccount][$i] <> $g_iTotalGoldGain[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblTotalGoldGain[$i], _NumberFormat($g_iTotalGoldGain[$CurrentAccount][$i], True))
			$iOldTotalGoldGain[$CurrentAccount][$i] = $g_iTotalGoldGain[$CurrentAccount][$i]
		EndIf

		If $bForceUpdateAll = True Or $iOldTotalElixirGain[$CurrentAccount][$i] <> $g_iTotalElixirGain[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblTotalElixirGain[$i], _NumberFormat($g_iTotalElixirGain[$CurrentAccount][$i], True))
			$iOldTotalElixirGain[$CurrentAccount][$i] = $g_iTotalElixirGain[$CurrentAccount][$i]
		EndIf

		If $bForceUpdateAll = True Or $iOldTotalDarkGain[$CurrentAccount][$i] <> $g_iTotalDarkGain[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblTotalDElixirGain[$i], _NumberFormat($g_iTotalDarkGain[$CurrentAccount][$i], True))
			$iOldTotalDarkGain[$CurrentAccount][$i] = $g_iTotalDarkGain[$CurrentAccount][$i]
		EndIf

		If $bForceUpdateAll = True Or $iOldTotalTrophyGain[$CurrentAccount][$i] <> $g_iTotalTrophyGain[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblTotalTrophyGain[$i], _NumberFormat($g_iTotalTrophyGain[$CurrentAccount][$i], True))
			$iOldTotalTrophyGain[$CurrentAccount][$i] = $g_iTotalTrophyGain[$CurrentAccount][$i]
		EndIf
	Next

	;UPDATED TO MISC STAT TAB
	If $bForceUpdateAll = True Or $iOldAttackedCount <> $iAttackedCount Then
		GUICtrlSetData($g_hLblResultVillagesAttacked, _NumberFormat($iAttackedCount, True))
		GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($iAttackedCount, True))
		$iOldAttackedCount = $iAttackedCount
	EndIf
	;END UPDATED TO MISC STAT TAB
		

	For $i = 0 To $g_iModeCount
		If $i = $TS Then ContinueLoop
		If $bForceUpdateAll = True Or $iOldNbrOfDetectedMines[$CurrentAccount][$i] <> $g_iNbrOfDetectedMines[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedMines[$i], $g_iNbrOfDetectedMines[$CurrentAccount][$i])
			$iOldNbrOfDetectedMines[$CurrentAccount][$i] = $g_iNbrOfDetectedMines[$CurrentAccount][$i]
		EndIf

		If $bForceUpdateAll = True Or $iOldNbrOfDetectedCollectors[$CurrentAccount][$i] <> $g_iNbrOfDetectedCollectors[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedCollectors[$i], $g_iNbrOfDetectedCollectors[$CurrentAccount][$i])
			$iOldNbrOfDetectedCollectors[$CurrentAccount][$i] = $g_iNbrOfDetectedCollectors[$CurrentAccount][$i]
		EndIf

		If $bForceUpdateAll = True Or $iOldNbrOfDetectedDrills[$CurrentAccount][$i] <> $g_iNbrOfDetectedDrills[$CurrentAccount][$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedDrills[$i], $g_iNbrOfDetectedDrills[$CurrentAccount][$i])
			$iOldNbrOfDetectedDrills[$CurrentAccount][$i] = $g_iNbrOfDetectedDrills[$CurrentAccount][$i]
		EndIf
	Next

	If $bForceUpdateAll = True Or $iOldNbrOfTHSnipeFails[$CurrentAccount] <> $g_iNbrOfTHSnipeFails[$CurrentAccount] Then
		GUICtrlSetData($g_hLblNbrOfTSFailed, $g_iNbrOfTHSnipeFails[$CurrentAccount])
		$iOldNbrOfTHSnipeFails[$CurrentAccount] = $g_iNbrOfTHSnipeFails[$CurrentAccount]
	EndIf

	If $bForceUpdateAll = True Or $iOldNbrOfTHSnipeSuccess[$CurrentAccount] <> $g_iNbrOfTHSnipeSuccess[$CurrentAccount] Then
		GUICtrlSetData($g_hLblNbrOfTSSuccess, $g_iNbrOfTHSnipeSuccess[$CurrentAccount])
		$iOldNbrOfTHSnipeSuccess[$CurrentAccount] = $g_iNbrOfTHSnipeSuccess[$CurrentAccount]
	EndIf

	;SECTION SMART ZAP
		;smartzap Gain
		If $bForceUpdateAll = True Or $s_iOldSmartZapGain[$CurrentAccount] <> $g_iSmartZapGain[$CurrentAccount] Then
			GUICtrlSetData($g_hLblSmartZap, _NumberFormat($g_iSmartZapGain[$CurrentAccount], True))
			$s_iOldSmartZapGain[$CurrentAccount] = $g_iSmartZapGain[$CurrentAccount]
		EndIf

		; SmartZap Spells Used
		If $bForceUpdateAll = True Or $s_iOldNumLSpellsUsed[$CurrentAccount] <> $g_iNumLSpellsUsed[$CurrentAccount] Then
			GUICtrlSetData($g_hLblSmartLightningUsed, _NumberFormat($g_iNumLSpellsUsed[$CurrentAccount], True))
			$s_iOldNumLSpellsUsed[$CurrentAccount] = $g_iNumLSpellsUsed[$CurrentAccount]
		EndIf

		; EarthQuake Spells Used
		If $bForceUpdateAll = True Or $s_iOldNumEQSpellsUsed[$CurrentAccount] <> $g_iNumEQSpellsUsed[$CurrentAccount] Then
			GUICtrlSetData($g_hLblSmartEarthQuakeUsed, _NumberFormat($g_iNumEQSpellsUsed[$CurrentAccount], True))
			$s_iOldNumEQSpellsUsed[$CurrentAccount] = $g_iNumEQSpellsUsed[$CurrentAccount]
		EndIf
	
;STATS TAB DONATIONS
	For $i = 0 To $eTroopCount - 1
		If $g_aiDonateStatsTroops[$i][0] <> $g_aiDonateStatsTroops[$i][1] Then
			GUICtrlSetData($g_hLblDonTroop[$i], _NumberFormat($g_aiDonateStatsTroops[$i][0], True))
			$g_iTotalDonateStatsTroops += ($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1])
			$g_iTotalDonateStatsTroopsXP += (($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1]) * $g_aiTroopDonateXP[$i])
			$g_aiDonateStatsTroops[$i][1] = $g_aiDonateStatsTroops[$i][0]
			$bDonateTroopsStatsChanged = True
		EndIf
	Next
	If $bDonateTroopsStatsChanged Then
		GUICtrlSetData($g_hLblTotalTroopsQ, _NumberFormat($g_iTotalDonateStatsTroops, True))
		GUICtrlSetData($g_hLblTotalTroopsXP, _NumberFormat($g_iTotalDonateStatsTroopsXP, True))
		$bDonateTroopsStatsChanged = False
	EndIf

	For $i = 0 To $eSpellCount - 1
		If $g_aiDonateStatsSpells[$i][0] <> $g_aiDonateStatsSpells[$i][1] And $i <> $eSpellClone Then
			GUICtrlSetData($g_hLblDonSpell[$i], _NumberFormat($g_aiDonateStatsSpells[$i][0], True))
			$g_iTotalDonateStatsSpells += ($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1])
			$g_iTotalDonateStatsSpellsXP += (($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1]) * $g_aiSpellDonateXP[$i])
			$g_aiDonateStatsSpells[$i][1] = $g_aiDonateStatsSpells[$i][0]
			$bDonateSpellsStatsChanged = True
		EndIf
	Next

	If $bDonateSpellsStatsChanged Then
		GUICtrlSetData($g_hLblTotalSpellsQ, _NumberFormat($g_iTotalDonateStatsSpells, True))
		GUICtrlSetData($g_hLblTotalSpellsXP, _NumberFormat($g_iTotalDonateStatsSpellsXP, True))
		$bDonateSpellsStatsChanged = False
	EndIf

;STATS UPDATE BOTTOM BAR
	If $bForceUpdateAll = True Or $iOldFreeBuilderCount[$CurrentAccount] <> $g_iFreeBuilderCount[$CurrentAccount] Or $iOldTotalBuilderCount[$CurrentAccount] <> $g_iTotalBuilderCount[$CurrentAccount] Then
		GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount[$CurrentAccount] & "/" & $g_iTotalBuilderCount[$CurrentAccount])
		$iOldFreeBuilderCount[$CurrentAccount] = $g_iFreeBuilderCount[$CurrentAccount]
		$iOldTotalBuilderCount[$CurrentAccount] = $g_iTotalBuilderCount[$CurrentAccount]
	EndIf

	If $bForceUpdateAll = True Or $iOldGemAmount[$CurrentAccount] <> $g_iGemAmount[$CurrentAccount] Then
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount[$CurrentAccount], True))
		$iOldGemAmount[$CurrentAccount] = $g_iGemAmount[$CurrentAccount]
	EndIf

	If $bForceUpdateAll = True Or $iOldGoldCurrent[$CurrentAccount] <> $g_iStatsCurrent[$CurrentAccount][$eLootGold] Then
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_iStatsCurrent[$CurrentAccount][$eLootGold], True))
		$iOldGoldCurrent[$CurrentAccount] = $g_iStatsCurrent[$CurrentAccount][$eLootGold]
	EndIf

	If $bForceUpdateAll = True Or $iOldElixirCurrent[$CurrentAccount] <> $g_iStatsCurrent[$CurrentAccount][$eLootElixir] Then
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_iStatsCurrent[$CurrentAccount][$eLootElixir], True))
		$iOldElixirCurrent[$CurrentAccount] = $g_iStatsCurrent[$CurrentAccount][$eLootElixir]
	EndIf

	If $bForceUpdateAll = True Or ($iOldDarkCurrent[$CurrentAccount] <> $g_iStatsCurrent[$CurrentAccount][$eLootDarkElixir] And $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "") Then
		GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_iStatsCurrent[$CurrentAccount][$eLootDarkElixir], True))
		$iOldDarkCurrent[$CurrentAccount] = $g_iStatsCurrent[$CurrentAccount][$eLootDarkElixir]
	EndIf

	If $bForceUpdateAll = True Or $iOldTrophyCurrent[$CurrentAccount] <> $g_iStatsCurrent[$CurrentAccount][$eLootTrophy] Then
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_iStatsCurrent[$CurrentAccount][$eLootTrophy], True))
		$iOldTrophyCurrent[$CurrentAccount] = $g_iStatsCurrent[$CurrentAccount][$eLootTrophy]
	EndIf

	
;MISC CODE
	If $ResetStats = 1 Then
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($iGoldCurrent, True))
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($iElixirCurrent, True))
		If $g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($iDarkCurrent, True))
		EndIf
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($iTrophyCurrent, True))
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], "")
		GUICtrlSetData($g_hLblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, "") ;GUI BOTTOM
		$ResetStats = 0
	EndIf

UpdateStatsSwitchMode($bForceUpdateAll)	; Enable when Function is added.

EndFunc   ;==>UpdateStats

Func ResetStats()
	$ResetStats = 1
	$g_iFirstAttack = 0
	$g_iTimePassed = 0
	$g_hTimerSinceStarted = TimerInit()
	GUICtrlSetData($g_hLblResultRuntime, "00:00:00")
	GUICtrlSetData($g_hLblResultRuntimeNow, "00:00:00")
	$g_iStatsStartedWith[$CurrentAccount][$eLootGold] = $iGoldCurrent
	$g_iStatsStartedWith[$CurrentAccount][$eLootElixir] = $iElixirCurrent
	$g_iStatsStartedWith[$CurrentAccount][$eLootDarkElixir] = $iDarkCurrent
	$g_iStatsStartedWith[$CurrentAccount][$eLootTrophy] = $iTrophyCurrent
	
	Dim $g_iStatsTotalGain[9][$eLootCount]
	Dim $g_iStatsLastAttack[9][$eLootCount]
	Dim $g_iStatsBonusLast[9][$eLootCount]
	Dim $g_iSkippedVillageCount[9]
	Dim $g_iDroppedTrophyCount[9]
	Dim $g_iSearchCost[9] 
	Dim $g_iTrainCostElixir[9] 
	Dim $g_iTrainCostDElixir[9] 
	Dim $g_iGoldFromMines[9]
	Dim $g_iElixirFromCollectors[9]
	Dim $g_iDElixirFromDrills[9]
	Dim $iNbrOfWallsUppedGold[9]
	Dim $iNbrOfWallsUppedElixir[9]
	Dim $iNbrOfBuildingsUppedGold[9]
	Dim $iNbrOfBuildingsUppedElixir[9]
	Dim $iNbrOfHeroesUpped[9]
	Dim $g_iCostGoldWall[9]
	Dim $g_iCostElixirWall[9]
	Dim $g_iCostGoldBuilding[9]
	Dim $g_iCostElixirBuilding[9]
	Dim $g_iCostDElixirHero[9]
	
	Dim $g_iAttackedVillageCount[9][$g_iModeCount + 3]
	Dim $g_iTotalGoldGain[9][$g_iModeCount + 3]
	Dim $g_iTotalElixirGain[9][$g_iModeCount + 3]
	Dim $g_iTotalDarkGain[9][$g_iModeCount + 3]
	Dim $g_iTotalTrophyGain[9][$g_iModeCount + 3]
	Dim $iNbrOfDetectedMines[9][$g_iModeCount + 3]
	Dim $iNbrOfDetectedCollectors[9][$g_iModeCount + 3]
	Dim $iNbrOfDetectedDrills[9][$g_iModeCount + 3]
	Dim $iNbrOfTHSnipeFails[9]
	Dim $iNbrOfTHSnipeSuccess[9]
	Dim $g_iSmartZapGain[9]
	Dim $g_iNumLSpellsUsed[9]
	Dim $g_iNumEQSpellsUsed[9]
	$iNbrOfOoS = 0

	
	For $i = 0 To $eTroopCount - 1
		$g_aiDonateStatsTroops[$i][0] = 0
	Next

	For $i = 0 To $eSpellCount - 1
		If $i <> $eSpellClone Then
			$g_aiDonateStatsSpells[$i][0] = 0
		EndIf
	Next

	$g_iTotalDonateStatsTroops = 0
	$g_iTotalDonateStatsTroopsXP = 0
	$g_iTotalDonateStatsSpells = 0
	$g_iTotalDonateStatsSpellsXP = 0

	UpdateStats()
EndFunc   ;==>ResetStats

Func WallsStatsMAJ()  ; No Need for arrays here for Multi account stat trace. Should be handled by profile, save, and read.
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] -= Number($iNbrOfWallsUpped)
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 5] += Number($iNbrOfWallsUpped)
	$iNbrOfWallsUpped = 0
	For $i = 4 To 12
		GUICtrlSetData($g_ahWallsCurrentCount[$i], $g_aiWallsCurrentCount[$i])
	Next
	SaveConfig()
EndFunc   ;==>WallsStatsMAJ
