; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectDarkExtractors
; Description ...:Find all dark drills that meet requirements
; Syntax ........:MilkingDetectDarkExtractors()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectDarkExtractors()

	If $g_bMilkFarmAttackDarkDrills and Number($iDarkCurrent) >= number($g_iMilkFarmLimitDark) Then
		If $g_iDebugSetlog=1  and $g_bMilkFarmAttackDarkDrills Then setlog("skip attack of dark drills, current dark (" & $iDarkCurrent & ") >= limit (" & $g_iMilkFarmLimitDark & ")",$COLOR_DEBUG)
		If $g_iDebugSetlog=1  and $g_bMilkFarmAttackDarkDrills = False Then setlog("skip attack of dark drills",$COLOR_DEBUG)
		return 0
	Else
		If $g_iDebugSetlog=1 Then setlog("current dark (" & $iDarkCurrent & ") < limit (" & $g_iMilkFarmLimitDark & ")",$COLOR_DEBUG)
	EndIf


	Local $MilkFarmAtkPixelListDRILLSTR = ""
	If $g_bMilkFarmLocateDrill Then
		Local $hTimer = TimerInit()
		;03.01 locate extractors
		_CaptureRegion2()
		Local $DrillVect = StringSplit(GetLocationDarkElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
		Local $Drillfounds = UBound($DrillVect)
		Local $Drillmatch = 0
		Local $Drilldiscard = 0
		For $i = 0 To UBound($DrillVect) - 1
			;If $g_iDebugSetlog=1 Then Setlog($i & " : " & $DrillVect[$i])    			;[15:51:30] 0 : 2#405-325 -> level 6
			;03.02 check isinsidediamond
			Local $temp = StringSplit($DrillVect[$i], "#", 2) ;TEMP ["2", "404-325"]
			If UBound($temp) = 2 Then
				Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						;debug if need
						If $g_iDebugResourcesOffset = 1 Then
							Local $level = $temp[0]
							Local $type = "drill"
							Local $resourceoffsetx = 0
							Local $resourceoffsety = 0
							Local $px = StringSplit($MilkFarmOffsetDark[$level], "-", 2)
							$resourceoffsetx = $px[0]
							$resourceoffsety = $px[1]
							_CaptureRegion($pixel[0] + $resourceoffsetx - 30, $pixel[1] + $resourceoffsety - 30, $pixel[0] + $resourceoffsetx + 30, $pixel[1] + $resourceoffsety + 30)
							Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
							Local $multiplier = 2
							Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
							Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
							_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
							_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
							_GDIPlus_PenDispose($hPen)
							_GDIPlus_BrushDispose($hBrush)
							_GDIPlus_GraphicsDispose($hGraphic)
							DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" , False)
						EndIf
						;ok add if conditions satisfied
						If AmountOfResourcesInStructure("drill", $pixel, $temp[0]) Then
							$MilkFarmAtkPixelListDRILLSTR &= $temp[1] & "|"
							If MilkFarmObjectivesSTR_INSERT("ddrill", $temp[0], $temp[1]) > 0 Then
								$Drillmatch += 1
							Else
								$Drilldiscard += 1
							EndIf
						Else
							If $g_iDebugSetlog = 1 Then Setlog(" - discard #4 no match conditions", $COLOR_DEBUG)
							$Drilldiscard += 1
						EndIf
					Else
						If $g_iDebugSetlog = 1 Then Setlog(" - discard #3 out of insidediamond", $COLOR_DEBUG)
						$Drilldiscard += 1
					EndIf
				Else
					If $g_iDebugSetlog = 1 Then Setlog(" - discard #2 no pixel coordinate", $COLOR_DEBUG)
					$Drilldiscard += 1
				EndIf
			Else
				If $g_iDebugSetlog = 1 Then Setlog(" - discard #1 no valid point", $COLOR_DEBUG)
				$Drilldiscard += 1
			EndIf
		Next
		If StringLen($MilkFarmAtkPixelListDRILLSTR) > 1 Then $MilkFarmAtkPixelListDRILLSTR = StringLeft($MilkFarmAtkPixelListDRILLSTR, StringLen($MilkFarmAtkPixelListDRILLSTR) - 1)
		If $g_iDebugSetlog = 1 Then Setlog("> Drill Extractors to attack list: " & $MilkFarmAtkPixelListDRILLSTR, $COLOR_DEBUG)
		Local $htimerLocateDrill = Round(TimerDiff($hTimer) / 1000, 2)
		If $g_iDebugSetlog = 1 Then Setlog("> Drill Extractors found: " & $Drillfounds & " | match conditions: " & $Drillmatch & " | discard " & $Drilldiscard, $COLOR_INFO)
		If $g_iDebugSetlog = 1 Then SetLog("> Drill Extractors position detectecd in " & $htimerLocateDrill & " seconds", $COLOR_INFO)
		Return $Drillmatch
	Else
		Return 0
	EndIf



EndFunc   ;==>MilkingDetectDarkExtractors
