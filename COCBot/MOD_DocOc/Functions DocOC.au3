; #FUNCTION# ====================================================================================================================
; Name ..........: DocOC Functions
; Description ...: This file Includes several files in the current script.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


#include "functions\Other\CheckVersion.au3"
#include "functions\Other\ArrayFunctions.au3"

#include "functions\Search\multiSearch.au3"

#include "functions\Village\TreasuryCollect.au3"
#include "functions\Village\SuperXP.au3"

#include "functions\Attack\ReturnHome.au3"

#include "functions\Attack\Attack Algorithms\algorithm_AllTroops.au3"

#include "functions\Attack\RedArea\DropTroop.au3"
#include "functions\Attack\RedArea\GetLocation.au3"
#include "functions\Attack\RedArea\_GetRedArea.au3"

#include "functions\Attack\Troops\DropOnEdge.au3"
#include "functions\Attack\Troops\DropOnEdges.au3"
#include "functions\Attack\Troops\LauchTroop.au3"
#include "functions\Attack\Troops\CheckHeroesHealth.au3"
#include "functions\Attack\Troops\GetXPosOfArmySlot.au3"
#include "functions\Attack\Troops\ReadTroopQuantity.au3"

#include "functions\Attack\SmartZap\smartZap.au3"

#include "functions\Attack\AttackCSV\ParseAttackCSV.au3"
#include "functions\Attack\AttackCSV\DropTroopFromINI.au3"
#include "functions\Attack\AttackCSV\ZapCmd.au3"
#include "functions\Attack\AttackCSV\SideP.au3"
#include "functions\Attack\AttackCSV\UpdateTroopQuantity.au3"
#include "functions\Attack\AttackCSV\DropSpellFromINIOnDefense.au3"
#include "functions\Attack\AttackCSV\ParseAttackCSV_Read_SIDE_variables.au3"

#include "functions\BotHumanization\BotHumanization.au3"
#include "functions\BotHumanization\AttackNDefenseActions.au3"
#include "functions\BotHumanization\BestClansNPlayersActions.au3"
#include "functions\BotHumanization\ChatActions.au3"
#include "functions\BotHumanization\ClanActions.au3"
#include "functions\BotHumanization\ClanWarActions.au3"

#include "functions\Config\saveConfig.au3"
#include "functions\Config\readConfig.au3"
#include "functions\Config\applyConfig.au3"

#include "functions\Village\DonateCC.au3"

#include "functions\Image Search\imglocTHSearch.au3"
#include "functions\Image Search\imglocAuxiliary.au3"

#include "functions\Other\UpdateStats.au3"

;Files With Switch Account Changes
#include "functions\Village\SmartSwitchAcc.au3"
#include "functions\Config\profileFunctions.au3"
#include "functions\Other\CheckPrerequisites.au3"
#include "functions\Village\VillageReport.au3"
#include "functions\Other\CheckDisplay.au3"
#include "functions\Attack\AttackReport.au3"
#include "functions\Other\SetLog.au3"
#include "functions\Main Screen\checkObstacles.au3"
#include "functions\Other\Update Stats SwitchMode.au3"
#include "functions\Village\Notify.au3"
#include "functions\Village\GainCost.au3"
#include "functions\Search\PrepareSearch.au3" 
#include "functions\Search\VillageSearch.au3" 
#include "functions\Village\DropTrophy.au3"
#include "functions\Village\UpgradeWall.au3"
#include "functions\Village\UpgradeBuilding.au3"
#include "functions\Village\UpgradeHeroes.au3"
#include "functions\CreateArmy\getArmyHeroStatus.au3"

#include "SimpleQuickTrain.au3"
#include "AttackNowButtom.au3"