; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Gui Design
; Description ...: This file Includes GUI Design of @RoroTiti's Bot Humanization feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti 21/10/2016
; Modified ......: TheRevenor 22/10/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

$chkUseBotHumanization = GUICtrlCreateCheckbox(GetTranslated(42, 0, "Enable Bot Humanization"), 10, 30, 137, 17)
	GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$chkUseAltRClick = GUICtrlCreateCheckbox(GetTranslated(42, 1, "Make ALL BOT clicks random"), 280, 30, 162, 17)
	GUICtrlSetOnEvent(-1, "chkUseAltRClick")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

GUICtrlCreateGroup(GetTranslated(42, 2, "Settings"), 4, 55, 440, 335)

Local $x = 0, $y = 20

$x += 10
$y += 50

	$Icon1 = GUICtrlCreateIcon($pIconLib, $eIcnChat, $x, $y + 5, 32, 32)
	$Label1 = GUICtrlCreateLabel(GetTranslated(42, 3, "Read the Clan Chat"), $x + 40, $y + 5, 110, 17)
	$cmbPriority[0] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label2 = GUICtrlCreateLabel(GetTranslated(42, 4, "Read the Global Chat"), $x + 240, $y + 5, 110, 17)
	$cmbPriority[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label4 = GUICtrlCreateLabel(GetTranslated(42, 5, "Say..."), $x + 40, $y + 30, 31, 17)
	$humanMessage[0] = GUICtrlCreateInput(GetTranslated(42, 6, "Hello !"), $x + 75, $y + 25, 121, 21)
	$Label3 = GUICtrlCreateLabel(GetTranslated(42, 7, "Or"), $x + 205, $y + 30, 15, 17)
	$humanMessage[1] = GUICtrlCreateInput(GetTranslated(42, 8, "Re !"), $x + 225, $y + 25, 121, 21)
	$cmbPriority[2] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label20 = GUICtrlCreateLabel(GetTranslated(42, 9, "Launch Challenges with message"), $x + 40, $y + 55, 170, 17)
	$challengeMessage = GUICtrlCreateInput(GetTranslated(42, 10, "Can you beat my village ?"), $x + 205, $y + 50, 141, 21)
	$cmbPriority[12] = GUICtrlCreateCombo("", $x + 355, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")

$y += 81

	$Icon2 = GUICtrlCreateIcon($pIconLib, $eIcnRepeat, $x, $y + 5, 32, 32)
	$Label5 = GUICtrlCreateLabel(GetTranslated(42, 11, "Watch Defenses"), $x + 40, $y + 5, 110, 17)
	$cmbPriority[3] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
		GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$Label6 = GUICtrlCreateLabel(GetTranslated(42, 12, "Watch Attacks"), $x + 40, $y + 30, 110, 17)
	$cmbPriority[4] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
		GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$Label7 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
	$cmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $ReplayChain, "2")
	$Label8 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
	$cmbPause[0] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")

$y += 56

	$Icon3 = GUICtrlCreateIcon($pIconLib, $eIcnClan, $x, $y + 5, 32, 32)
	$Label9 = GUICtrlCreateLabel(GetTranslated(42, 15, "Watch War log"), $x + 40, $y + 5, 110, 17)
	$cmbPriority[5] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label10 = GUICtrlCreateLabel(GetTranslated(42, 16, "Visit Clanmates"), $x + 40, $y + 30, 110, 17)
	$cmbPriority[6] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label11 = GUICtrlCreateLabel(GetTranslated(42, 17, "Look at Best Players"), $x + 240, $y + 5, 110, 17)
	$cmbPriority[7] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label12 = GUICtrlCreateLabel(GetTranslated(42, 18, "Look at Best Clans"), $x + 240, $y + 30, 110, 17)
	$cmbPriority[8] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")

$y += 56

	$Icon4 = GUICtrlCreateIcon($pIconLib, $eIcnSwords, $x, $y + 5, 32, 32)
	$Label14 = GUICtrlCreateLabel(GetTranslated(42, 19, "Look at Current War"), $x + 40, $y + 5, 110, 17)
	$cmbPriority[9] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label16 = GUICtrlCreateLabel(GetTranslated(42, 20, "Watch Replays"), $x + 40, $y + 30, 110, 17)
	$cmbPriority[10] = GUICtrlCreateCombo("", $x + 155, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
		GUICtrlSetOnEvent(-1, "cmbWarReplay")
	$Label13 = GUICtrlCreateLabel(GetTranslated(42, 13, "Max Replay Speed") & " ", $x + 240, $y + 5, 110, 17)
	$cmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $ReplayChain, "2")
	$Label15 = GUICtrlCreateLabel(GetTranslated(42, 14, "Pause Replay"), $x + 240, $y + 30, 110, 17)
	$cmbPause[1] = GUICtrlCreateCombo("", $x + 355, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")

$y += 56

	$Icon5 = GUICtrlCreateIcon($pIconLib, $eIcnLoop, $x, $y + 5, 32, 32)
	$Label17 = GUICtrlCreateLabel(GetTranslated(42, 21, "Do nothing"), $x + 40, $y + 5, 110, 17)
	$cmbPriority[11] = GUICtrlCreateCombo("", $x + 155, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $FrequenceChain, "Never")
	$Label18 = GUICtrlCreateLabel(GetTranslated(42, 22, "Max Actions by Loop"), $x + 240, $y + 5, 103, 17)
	$cmbMaxActionsNumber = GUICtrlCreateCombo("", $x + 355, $y, 75, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "1|2|3|4|5", "2")

$y += 25

	$chkCollectAchievements = GUICtrlCreateCheckbox(GetTranslated(42, 23, "Collect achievements automatically"), $x + 40, $y, 182, 17)
		GUICtrlSetOnEvent(-1, "chkCollectAchievements")
		GUICtrlSetState(-1, $GUI_UNCHECKED)

	$chkLookAtRedNotifications = GUICtrlCreateCheckbox(GetTranslated(42, 24, "Look at red/purple flags on buttons"), $x + 240, $y, 187, 17)
		GUICtrlSetOnEvent(-1, "chkLookAtRedNotifications")
		GUICtrlSetState(-1, $GUI_UNCHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

For $i = $Icon1 To $chkLookAtRedNotifications
	GUICtrlSetState($i, $GUI_DISABLE)
Next
