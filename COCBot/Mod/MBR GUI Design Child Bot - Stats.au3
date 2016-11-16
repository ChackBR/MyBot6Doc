; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Design - Stats Mod
; Description ...: Extension of GUI Design Child Bot - Stats
; Syntax ........:
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

;TAB Profile Stats - SwitchAcc Mode - DEMEN
$hGUI_STATS_TAB_ITEM4 = GUICtrlCreateTabItem("Profile Stats")


Local $xStart = 25, $yStart = 45
$x = $xStart
$y = $yStart

Global $aGoldTotalAcc[8], $aElixirTotalAcc[8], $aDarkTotalAcc[8], $aAttackedCountAcc[8], $aSkippedVillageCountAcc[8]
Global $aGoldCurrentAcc[8], $aElixirCurrentAcc[8], $aGoldCurrentAcc[8],$aDarkCurrentAcc[8], $aTrophyCurrentAcc[8], $aGemAmountAcc[8], $aFreeBuilderCountAcc[8], $aTotalBuilderCountAcc[8]
Global $lblGoldLootAcc[8], $lblElixirLootAcc[8], $lblDarkLootAcc[8], $lblHourlyStatsGoldAcc[8], $lblHourlyStatsElixirAcc[8], $lblHourlyStatsDarkAcc[8]
Global $grpVillageAcc[8], $lblResultGoldNowAcc[8], $lblResultElixirNowAcc[8], $lblResultDENowAcc[8], $lblResultTrophyNowAcc[8], $lblResultBuilderNowAcc[8], $lblResultGemNowAcc[8]
Global $aStartHide[8]

$grpProfileStats = GUICtrlCreateGroup("Gain stats per Profile", $x - 22, $y - 15, 427, 330)
   For $i = 0 To 3
	   $x = $xStart - 60
	   $y = $yStart

	   $grpVillageAcc[$i] = GUICtrlCreateGroup(GetTranslated(603,32, "Village"), $x + 70, $y + $i * 80, 170, 73)
		 $y += 17
		 $picResultGoldNowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 140, $y + $i * 80, 16, 16)
			$lblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
		 $picResultTrophyNowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 220, $y + $i * 80, 16, 16)
			$lblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + 155, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
		 $y += 17
		 $picResultElixirNowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 140, $y + $i * 80, 16, 16)
			$lblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
		 $picResultBuilderNowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x + 220, $y + $i * 80, 16, 16)
			$lblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + 155, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
		 $y += 17
		 $picResultDENowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 140, $y + $i * 80, 16, 16)
			$lblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
		 $picResultGemNowAcc = GUICtrlCreateIcon ($pIconLib, $eIcnGem, $x + 220, $y + $i * 80, 16, 16)
			$lblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + 155, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)

	  $x += 180
	  $y = $yStart
	   $aStartHide[$i] = GUICtrlCreateDummy()
	   $grpTotalLootAcc = GUICtrlCreateGroup(GetTranslated(632,20, "Total Gain"), $x + 70, $y + $i * 80 , 90, 73)
		 $y += 17
		 $picGoldLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 140, $y + $i * 80, 16, 16)
			$lblGoldLootAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,21, "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			GUICtrlSetTip(-1, $txtTip)
		 $y += 17
		 $picElixirLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 140, $y + $i * 80, 16, 16)
			$lblElixirLootAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,23, "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			GUICtrlSetTip(-1, $txtTip)
		 $y += 17
		 $picDarkLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 140, $y + $i * 80, 16, 16)
			$lblDarkLootAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,24, "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			GUICtrlSetTip(-1, $txtTip)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	  $x += 100
	  $y = $yStart
	  $grpHourlyStatsAcc = GUICtrlCreateGroup(GetTranslated(632,26, "Gain per Hour"), $x + 70, $y + $i * 80 , 90, 73)
		$y += 17
		$picGoldLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 140, $y + $i * 80, 16, 16)
			$lblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,27, "Gold gain per hour")
			GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picElixirLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 140, $y + $i * 80, 16, 16)
			$lblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,28, "Elixir gain per hour")
			GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picDarkLootAcc = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 140, $y + $i * 80, 16, 16)
			$lblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel("", $x + 75, $y + 1 + $i * 80, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,29, "Dark Elixir gain per hour")
			GUICtrlSetTip(-1, $txtTip)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)

   Next

GUICtrlCreateGroup("", -99, -99, 1, 1)
;-->TAB Gain Separate - Stats Per Profile - SwitchAcc Mode - DEMEN