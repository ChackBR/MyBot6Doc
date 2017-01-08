; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRedArea
; Description ...:  See strategy below
; Syntax ........: _GetRedArea()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; 			Search red area
;			Split the result in 4 sides (global var) : Top Left / Bottom Left / Top Right / Bottom Right
;			Remove bad pixel (Suppose that pixel to deploy are in the green area)
;			Get pixel next the "out zone" , indeed the red color is very different and more uncertain
;			Sort each sides
;			Add each sides in one array (not use, but it can help to get closer pixel of all the red area)
Global $CurBaseRedLine[2] = ["", ""]


Func _GetRedArea($iMode = $REDLINE_IMGLOC)
	$nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5
	Local $result = 0

	If $iMatchMode = $LB And $iAtkAlgorithm[$LB] <> 1 And $iChkDeploySettings[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		$result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $debugSetlog Then Setlog("Debug: Redline with DES Side chosen")
	ElseIf $iMatchMode = $LB And $iAtkAlgorithm[$LB] <> 1 And $iChkDeploySettings[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		$result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $debugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea

		Switch $iMode
			Case $REDLINE_NONE ; No red line
				debugAttackCSV("$REDLINE_NONE")
				Local $listPixelBySide = ["NoRedLine", "", "", "", ""] ; Edges
				; previvous external points to deploy
				 $listPixelBySide[1] = getRedAreaSideBuilding("6,349|10,346|14,343|18,340|22,337|26,334|30,331|34,328|38,325|42,322|46,319|50,316|54,313|58,310|62,307|66,304|70,301|74,298|78,295|82,292|86,289|90,286|94,283|98,280|102,277|106,274|110,271|114,268|118,265|122,262|126,259|130,256|134,253|138,250|142,247|146,244|150,241|154,238|158,235|162,232|166,229|170,226|174,223|178,220|182,217|186,214|190,211|194,208|198,205|202,202|206,199|210,196|214,193|218,190|222,187|226,184|230,181|234,178|238,175|242,172|246,169|250,166|254,163|258,160|262,157|266,154|270,151|274,148|278,145|282,142|286,139|290,136|294,133|298,130|302,127|306,124|310,121|314,118|318,115|322,112|326,109|330,106|334,103|338,100|342,97|346,94|350,91|354,88|358,85|362,82|366,79|370,76|374,73|378,70|382,67|386,64|390,61|394,58|398,55|402,52|406,49|410,46|414,43|418,40|422,37|426,34|430,31")
				 $listPixelBySide[2] = getRedAreaSideBuilding("444,30|448,33|452,36|456,39|460,42|464,45|468,48|472,51|476,54|480,57|484,60|488,63|492,66|496,69|500,72|504,75|508,78|512,81|516,84|520,87|524,90|528,93|532,96|536,99|540,102|544,105|548,108|552,111|556,114|560,117|564,120|568,123|572,126|576,129|580,132|584,135|588,138|592,141|596,144|600,147|604,150|608,153|612,156|616,159|620,162|624,165|628,168|632,171|636,174|640,177|644,180|648,183|652,186|656,189|660,192|664,195|668,198|672,201|676,204|680,207|684,210|688,213|692,216|696,219|700,222|704,225|708,228|712,231|716,234|720,237|724,240|728,243|732,246|736,249|740,252|744,255|748,258|752,261|756,264|760,267|764,270|768,273|772,276|776,279|780,282|784,285|788,288|792,291|796,294|800,297|804,300|808,303|812,306|816,309|820,312|824,315|828,318|832,321|836,324|840,327|844,330|848,333|852,336|856,339|860,342|864,345|868,348")
				 $listPixelBySide[3] = getRedAreaSideBuilding("6,349|10,352|14,355|18,358|22,361|26,364|30,367|34,370|38,373|42,376|46,379|50,382|54,385|58,388|62,391|66,394|70,397|74,400|78,403|82,406|86,409|90,412|94,415|98,418|102,421|106,424|110,427|114,430|118,433|122,436|126,439|130,442|134,445|138,448|142,451|146,454|150,457|154,460|158,463|162,466|166,469|170,472|174,475|178,478|182,481|186,484|190,487|194,490|198,493|202,496|206,499|210,502|214,505|218,508|222,511|226,514|230,517|234,520|238,523|242,526|246,529|250,532|254,535|258,538|262,541|266,544|270,547|274,550|278,553|282,556|286,559|290,562|294,565|298,568|302,571|306,574|310,577|314,580|318,583|322,586|326,589|330,592|334,595|338,598|342,601|346,604|350,607|354,610|358,613|362,616|366,619|370,622|374,625")
				 $listPixelBySide[4] = getRedAreaSideBuilding("444,625|448,622|452,619|456,616|460,613|464,610|468,607|472,604|476,601|480,598|484,595|488,592|492,589|496,586|500,583|504,580|508,577|512,574|516,571|520,568|524,565|528,562|532,559|536,556|540,553|544,550|548,547|552,544|556,541|560,538|564,535|568,532|572,529|576,526|580,523|584,520|588,517|592,514|596,511|600,508|604,505|608,502|612,499|616,496|620,493|624,490|628,487|632,484|636,481|640,478|644,475|648,472|652,469|656,466|660,463|664,460|668,457|672,454|676,451|680,448|684,445|688,442|692,439|696,436|700,433|704,430|708,427|712,424|716,421|720,418|724,415|728,412|732,409|736,406|740,403|744,400|748,397|752,394|756,391|760,388|764,385|768,382|772,379|776,376|780,373|784,370|788,367|792,364|796,361|800,358|804,355|808,352|812,349")
			Case $REDLINE_IMGLOC_RAW ; ImgLoc raw red line routine
				debugAttackCSV("$REDLINE_IMGLOC_RAW")
				; ensure redline exists
				SearchRedLines()
				StoreRedLines($IMGLOCREDLINE)
				Local $listPixelBySide = getRedAreaSideBuilding()
			Case $REDLINE_IMGLOC ; New ImgLoc based deployable red line routine
				debugAttackCSV("$REDLINE_IMGLOC")
				; ensure redline exists
				SearchRedLines()
				StoreRedLines($IMGLOCREDLINE)
				Local $dropPoints = GetOffSetRedline("TL") & "|" & GetOffSetRedline("BL") & "|" & GetOffSetRedline("BR") & "|" & GetOffSetRedline("TR")
				Local $listPixelBySide = getRedAreaSideBuilding($dropPoints)
				#cs
					$PixelTopLeft = _SortRedline(GetOffSetRedline("TL"))
					$PixelBottomLeft =  _SortRedline(GetOffSetRedline("BL"))
					$PixelBottomRight = _SortRedline(GetOffSetRedline("BR"))
					$PixelTopRight =  _SortRedline(GetOffSetRedline("TR"))
					Local $listPixelBySide = ["ImgLoc", $PixelTopLeft, $PixelBottomLeft, $PixelBottomRight, $PixelTopRight]
				#ce
			Case $REDLINE_ORIGINAL ; Original red line routine
				Setlog("$REDLINE_ORIGINAL")
				Local $result = DllCall($hFuncLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		EndSwitch
		If $debugSetlog Then Setlog("Debug: Redline chosen")
	EndIf

	If IsArray($result) Then
		Local $listPixelBySide = StringSplit($result[0], "#")
	EndIf
	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Local $offsetArcher = 15

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]

	;If Milking Attack ($iAtkAlgorithm[$DB] = 2) or AttackCSV skip calc of troops further offset (archers drop points for standard attack)
	; but need complete calc if use standard attack after milking attack ($MilkAttackAfterStandardAtk =1) and use redarea ($iChkRedArea[$MA] = 1)
	;If $debugsetlog = 1 Then Setlog("REDAREA matchmode " & $iMatchMode & " atkalgorithm[0] = " & $iAtkAlgorithm[$DB] & " $MilkAttackAfterScriptedAtk = " & $MilkAttackAfterScriptedAtk , $COLOR_DEBUG1)
	If ($iMatchMode = $DB And $iAtkAlgorithm[$DB] = 2) Or ($iMatchMode = $DB And $ichkUseAttackDBCSV = 1) Or ($iMatchMode = $LB And $ichkUseAttackABCSV = 1) Then
		If $debugsetlog = 1 Then setlog("redarea no calc pixel further (quick)", $COLOR_DEBUG)
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = $PixelTopLeft[$i]
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = $PixelBottomLeft[$i]
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = $PixelTopRight[$i]
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = $PixelBottomRight[$i]
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
	Else
		If $debugsetlog = 1 Then setlog("redarea calc pixel further", $COLOR_DEBUG)
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = _GetOffsetTroopFurther($PixelTopLeft[$i], $eVectorLeftTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = _GetOffsetTroopFurther($PixelBottomLeft[$i], $eVectorLeftBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = _GetOffsetTroopFurther($PixelTopRight[$i], $eVectorRightTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = _GetOffsetTroopFurther($PixelBottomRight[$i], $eVectorRightBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
	EndIf

	If UBound($PixelTopLeft) < 10 Then
		$PixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
		$PixelTopLeftFurther = $PixelTopLeft
	EndIf
	If UBound($PixelBottomLeft) < 10 Then
		$PixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
		$PixelBottomLeftFurther = $PixelBottomLeft
	EndIf
	If UBound($PixelTopRight) < 10 Then
		$PixelTopRight = _GetVectorOutZone($eVectorRightTop)
		$PixelTopRightFurther = $PixelTopRight
	EndIf
	If UBound($PixelBottomRight) < 10 Then
		$PixelBottomRight = _GetVectorOutZone($eVectorRightBottom)
		$PixelBottomRightFurther = $PixelBottomRight
	EndIf

	debugRedArea($nameFunc & "  Size of arr pixel for TopLeft [" & UBound($PixelTopLeft) & "] /  BottomLeft [" & UBound($PixelBottomLeft) & "] /  TopRight [" & UBound($PixelTopRight) & "] /  BottomRight [" & UBound($PixelBottomRight) & "] ")

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>_GetRedArea

Func SortRedline($redline, $StartPixel, $EndPixel, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	For $i = 0 To $size - 1
		Local $sPoint = $aPoints[$i]
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then $aPoints[$i] = $aPoint
	Next
	Local $iInvalid = 0
	Local $s = PixelArrayToString(SortByDistance($aPoints, $StartPixel, $EndPixel, $iInvalid))
	Return $s
EndFunc   ;==>SortRedline

Func SortByDistance($PixelList, ByRef $StartPixel, ByRef $EndPixel, ByRef $iInvalid)

	If $debugSetlog = 1 Then SetDebugLog("SortByDistance Start = " & PixelToString($StartPixel, ',') & " : " & PixelArrayToString($PixelList, ","))
	Local $iMax = UBound($PixelList) - 1
	Local $iMin2 = 0
	Local $iMax2 = $iMax
	Local $Sorted[$iMax + 1]
	Local $PrevPixel = $StartPixel
	Local $PrevDistance = -1
	Local $totalDistances = 0
	Local $totalPoints = 0
	Local $firstPixel = [-1, -1], $lastPixel = [-1, 1]
	$iInvalid = 0

	For $i = 0 To $iMax
		Local $ClosestIndex = 0
		Local $ClosestDistance = 9999
		Local $ClosestPixel = [0, 0]
		Local $adjustMin = True
		Local $adjustMax = 0
		For $j = $iMin2 To $iMax2
			Local $Pixel = $PixelList[$j]
			If IsArray($Pixel) = 0 Then
				If $adjustMin Then $iMin2 = $j + 1
				If $adjustMax = $iMax Then $adjustMax = $j
				ContinueLoop
			EndIf
			$adjustMin = False
			$adjustMax = $iMax
			Local $d = GetPixelDistance($PrevPixel, $Pixel)
			If $d < $ClosestDistance Then
				$ClosestIndex = $j
				$ClosestDistance = $d
				$ClosestPixel = $Pixel
			EndIf
		Next
		$iMax2 = $adjustMax
		; skip drop points that are too far away
		Local $avgDistance = $totalDistances / $totalPoints
		Local $invalidPoint = $ClosestPixel[0] < 0 And $ClosestPixel[1] < 0
		If $invalidPoint Or ($PrevDistance > -1 And ($iMax - $i) / $iMax < 0.20 And ($ClosestDistance > $avgDistance * 10 Or ($ClosestDistance > $avgDistance * 3 And (GetPixelDistance($PrevPixel, $EndPixel) < 25 Or $ClosestDistance > $totalDistances / 2)))) Then
			; skip this pixel
			$iInvalid += 1
			If $invalidPoint = False Then
				$ClosestPixel[0] = -$ClosestPixel[0]
				$ClosestPixel[1] = -$ClosestPixel[1]
			EndIf
		Else
			If $firstPixel[0] = -1 Then $firstPixel = $ClosestPixel
			$lastPixel = $ClosestPixel
			$PrevPixel = $ClosestPixel
			$PrevDistance = $ClosestDistance
			$totalPoints += 1
			$totalDistances += $ClosestDistance
		EndIf
		$Sorted[$i] = $ClosestPixel
		$PixelList[$ClosestIndex] = 0
	Next

	; validate start and end pixel
	If GetPixelDistance($StartPixel, $firstPixel) > $avgDistance * 3 Then
		$StartPixel[0] = $firstPixel[0]
		$StartPixel[1] = $firstPixel[1]
	EndIf
	If GetPixelDistance($EndPixel, $lastPixel) > $avgDistance * 3 Then
		$EndPixel[0] = $lastPixel[0]
		$EndPixel[1] = $lastPixel[1]
	EndIf

	If $debugSetlog = 1 Then SetDebugLog("SortByDistance Done : " & PixelArrayToString($Sorted, ","))
	Return $Sorted

EndFunc   ;==>SortByDistance

Func PixelArrayToString(Const ByRef $PixelList, $sDelim = "-")
	If UBound($PixelList) < 1 Then Return ""
	Local $s = ""
	For $i = 0 To UBound($PixelList) - 1
		Local $Pixel = $PixelList[$i]
		$s &= "|" & PixelToString($Pixel, $sDelim)
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>PixelArrayToString

Func PixelToString(Const ByRef $Pixel, $sDelim = "-")
	Return $Pixel[0] & $sDelim & $Pixel[1]
EndFunc   ;==>PixelToString

Func _SortRedline($redline, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	Local $a1[$size + 1][2] = [[0, 0]]
	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then getRedAreaSideBuildingSetPoint($a1, $aPoint)
	Next
	Local $s = getRedAreaSideBuildingString($a1)
	Return $s
EndFunc   ;==>_SortRedline

Func getRedAreaSideBuildingSetPoint(ByRef $aSide, ByRef $aPoint)
	$aSide[0][0] += 1
	$aSide[$aSide[0][0]][0] = Int($aPoint[0])
	$aSide[$aSide[0][0]][1] = Int($aPoint[1])
EndFunc   ;==>getRedAreaSideBuildingSetPoint

Func getRedAreaSideBuildingString(ByRef $aSide)
	If UBound($aSide) < 2 Or $aSide[0][0] < 1 Then Return ""
	_ArraySort($aSide, 0, 1, $aSide[0][0], 0)
	Local $s = ""
	For $j = 1 To $aSide[0][0]
		$s &= ("|" & $aSide[$j][0] & "-" & $aSide[$j][1])
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>getRedAreaSideBuildingString

Func getRedAreaSideBuilding($redline = $IMGLOCREDLINE)
	;SetDebugLog("getRedAreaSideBuilding: " & $redline)
	Local $c = 0
	Local $a[5]
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	Local $a1[$size + 1][2] = [[0, 0]] ; Top Left
	Local $a2[$size + 1][2] = [[0, 0]] ; Bottom Left
	Local $a3[$size + 1][2] = [[0, 0]] ; Bottom Right
	Local $a4[$size + 1][2] = [[0, 0]] ; Top Right

	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, ",")
		If UBound($aPoint) > 1 Then
			$c += 1
			Local $i = GetPixelSection($aPoint[0], $aPoint[1])
			Switch $i
				Case 1 ; Top Left
					getRedAreaSideBuildingSetPoint($a1, $aPoint)
				Case 2 ; Bottom Left
					getRedAreaSideBuildingSetPoint($a2, $aPoint)
				Case 3 ; Bottom Right
					getRedAreaSideBuildingSetPoint($a3, $aPoint)
				Case 4 ; Top Right
					getRedAreaSideBuildingSetPoint($a4, $aPoint)
			EndSwitch
		EndIf
	Next
	$a[0] = $c
	$a[1] = getRedAreaSideBuildingString($a1)
	$a[2] = getRedAreaSideBuildingString($a2)
	$a[3] = getRedAreaSideBuildingString($a3)
	$a[4] = getRedAreaSideBuildingString($a4)
	;SetDebugLog("getRedAreaSideBuilding, Side " & $i & ": " & StringReplace($a[$i], "-", ","))
	Return $a
EndFunc   ;==>getRedAreaSideBuilding

Func GetPixelSection($x, $y)
	Local $isLeft = ($x <= $ExternalArea[2][0])
	Local $isTop = ($y <= $ExternalArea[0][1])
	If $isLeft Then
		If $isTop Then Return 1 ; Top Left
		Return 2 ; Bottom Left
	EndIf
	If $isTop Then Return 4 ; Top Right
	Return 3 ; Bottom Right
EndFunc   ;==>GetPixelSection

Func FindClosestToAxis(Const ByRef $PixelList)
	Local $Axis = [$ExternalArea[2][0], $ExternalArea[0][1]]
	Local $Search[2] = [9999, 9999]
	Local $Points[2]
	For $Pixel In $PixelList
		For $i = 0 To 1
			If Abs($Pixel[$i] - $Axis[$i]) < Abs($Search[$i] - $Axis[$i]) Then
				$Search[$i] = $Pixel[$i]
				$Points[$i] = $Pixel
			EndIf
		Next
	Next
	#cs
		Local $Order
		Local $OrderXY = [0, 1]
		Local $OrderYX = [1, 0]
		Local $FixStartEnd
		Switch $Side
		Case 1 ; Top Left
		$Order = $OrderYX
		Local $FixStartEnd = []
		Case 2 ; Bottom Left
		$Order = $OrderYX
		Case 3 ; Bottom Right
		$Order = $OrderXY
		Case 4 ; Top Right
		$Order = $OrderXY
		EndSwitch
	#ce
	For $i = 0 To 1
		If $Search[$i] = 9999 Then $Search[$i] = $Axis[$i]
	Next
	Return $Search
EndFunc   ;==>FindClosestToAxis

Func StoreRedLines($redLines)
	If IsArray($redLines) Then
		If StringLen($CurBaseRedLine[0]) > 30 Then Return $CurBaseRedLine
		Local $result = $redLines
		If IsArray($result) Then
			$CurBaseRedLine[0] = $result[0]
		EndIf
	Else
		If StringLen($CurBaseRedLine[0]) > 30 Then Return $CurBaseRedLine
		$CurBaseRedLine[0] = $redLines
	EndIf
	Return $CurBaseRedLine
EndFunc

Func IsRedLineAvailable()
	If StringLen($CurBaseRedLine[0]) > 30 Then Return True
	Return False
EndFunc

Func ResetRedLines()
	_ArrayClear($CurBaseRedLine)
	Return True
EndFunc