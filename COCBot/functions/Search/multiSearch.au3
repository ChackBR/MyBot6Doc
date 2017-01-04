; #FUNCTION# ====================================================================================================================
; Name ..........: multiSearch
; Description ...: Various functions to return information from a multiple tile search
; Syntax ........:
; Parameters ....: None
; Return values .: An array of values of detected defense levels and information
; Author ........: LunaEclipse(April 2016)
; Modified ......: MR.ViPER (October-2016), MR.ViPER (November-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func updateMultiSearchStats($aResult, $statFile = "")
	Switch $statFile
		Case $statChkWeakBase
			updateWeakBaseStats($aResult)
		Case Else
			; Don't log stats at present
	EndSwitch
EndFunc   ;==>updateMultiSearchStats

Func addInfoToDebugImage($hGraphic, $hPen, $fileName, $x, $y)
	; Draw the location on the image
	_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPen)

	; Store the variables needed for writing the text
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate("Tahoma")
	Local $hFont = _GDIPlus_FontCreate($hFamily, 12, 2)
	Local $tLayout = _GDIPlus_RectFCreate($x + 10, $y, 0, 0)
	Local $sString = String($fileName)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)

	; Write the level found on the image
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)

	; Dispose all resources
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
EndFunc   ;==>addInfoToDebugImage

Func captureDebugImage($aResult, $subDirectory)
	Local $coords

	If IsArray($aResult) Then
		; Create the directory in case it doesn't exist
		DirCreate($dirTempDebug & $subDirectory)

		; Store a copy of the image handle
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)

		; Create the timestamp and filename
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $fileName = String($Date & "_" & $Time & ".png")

		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

		; Edit the image with information about items found
		For $i = 1 To UBound($aResult) - 1
			; Check to make sure there is results to display
			If Number($aResult[$i][4]) > 0 Then
				; Retrieve the coords sub-array
				$coords = $aResult[$i][5]

				If IsArray($coords) Then
					; Loop through all found points for the item and add them to the image
					For $j = 0 To UBound($coords) - 1
						addInfoToDebugImage($hGraphic, $hPen, $aResult[$i][0], $coords[$j][0], $coords[$j][1])
					Next
				EndIf
			EndIf
		Next

		; Display the time take for the search
		_GDIPlus_GraphicsDrawString($hGraphic, "Time Taken:" & $aResult[0][2] & " " & $aResult[0][3], 350, 50, "Verdana", 20)

		; Save the image and release any memory
		_GDIPlus_ImageSaveToFile($editedImage, $dirTempDebug & $subDirectory & "\" & $fileName)
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($editedImage)
	EndIf
EndFunc   ;==>captureDebugImage

Func returnPropertyValue($key, $property)
	; Get the property
	Local $aValue = DllCall($hImgLib, "str", "GetProperty", "str", $key, "str", $property)
	If @error Then _logErrorDLLCall($pImgLib, @error)
	Return $aValue[0]
EndFunc   ;==>getProperty

Func updateResultsRow(ByRef $aResult, $redLines = "")
	; Create the local variable to do the counting
	Local $numberFound = 0

	If IsArray($aResult) Then
		; Loop through the results to get the total number of objects found
		If UBound($aResult) > 1 Then
			For $j = 1 To UBound($aResult) - 1
				$numberFound +=	Number($aResult[$j][4])
			Next
		EndIf

		; Store the redline data in case we need to do more searches
		$aResult[0][0] = $redLines
		$aResult[0][1] = $numberFound ; Store the total number found
	Else
		; Not an array, so we are not going to do anything, this should only happen if there is a problem
	EndIf
EndFunc   ;==>updateResultsRow

Func multiMatches($directory, $maxReturnPoints = 0, $fullCocAreas = "DCD", $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup arrays, including default return values for $return
	Local $aResult[1][6] = [["", 0, 0, "Seconds", "", ""]], $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue

	; Capture the screen for comparison
	If $forceCaptureRegion = True Then _CaptureRegion2()

	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	If @error Then _logErrorDLLCall($pImgLib, @error)

	; Get the redline data
	$aValue = DllCall($hImgLib, "str", "GetProperty", "str", "redline", "str", "")
	If @error Then _logErrorDLLCall($pImgLib, @error)
	$redLines = $aValue[0]

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys) + 1][6]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i + 1][0] = returnPropertyValue($aKeys[$i], "filename")
			$aResult[$i + 1][1] = returnPropertyValue($aKeys[$i], "objectname")
			$aResult[$i + 1][2] = returnPropertyValue($aKeys[$i], "objectlevel")
			$aResult[$i + 1][3] = returnPropertyValue($aKeys[$i], "fillLevel")
			$aResult[$i + 1][4] = returnPropertyValue($aKeys[$i], "totalobjects")

			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			ReDim $aCoordArray[UBound($aCoords)][2]

			; Loop through the found coords
			For $j = 0 To UBound($aCoords) - 1
				; Split the coords into an array
				$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[$j][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[$j][1] = $aCoordsSplit[1] ; Y coord.
				EndIf
			Next

			; Store the coords array as a sub-array
			$aResult[$i + 1][5] = $aCoordArray
		Next
	EndIf

	; Updated the results row of the array, no need to assign to a variable, because the array is passed ByRef,
	; so the function updates the array that is passed as a parameter.
	updateResultsRow($aResult, $redLines)
	updateMultiSearchStats($aResult, $statFile)

	Return $aResult
EndFunc   ;==>multiMatches

Func multiMatchesPixelOnly($directory, $maxReturnPoints = 0, $fullCocAreas = $ECD, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000, $x1 = 0, $y1 = 0, $x2 = $GAME_WIDTH, $y2 = $GAME_HEIGHT, $bCaptureNew = True, $xDiff = Default, $yDiff = Default, $forceReturnString = False, $saveSourceImg = False)
	; Setup arrays, including default return values for $return
	Local $Result = ""
	Local $res

	; Capture the screen for comparison
	If $bCaptureNew Then
		_CaptureRegion2($x1, $y1, $x2, $y2)
		; Perform the search
		$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
		If @error Then _logErrorDLLCall($pImgLib, @error)
		If $saveSourceImg = True Then _GDIPlus_ImageSaveToFile(_GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2), @ScriptDir & "\multiMatchesPixelOnly.png")
		$aValue = DllCall($hImgLib, "str", "GetProperty", "str", "redline", "str", "")
		$redLines = $aValue[0]
	Else
		Local $hClone = CloneAreaToSearch($x1, $y1, $x2, $y2)
		$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hClone, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
		If @error Then _logErrorDLLCall($pImgLib, @error)
		If $saveSourceImg = True Then _GDIPlus_ImageSaveToFile(_GDIPlus_BitmapCreateFromHBITMAP($hClone), @ScriptDir & "\multiMatchesPixelOnly.png")
		$aValue = DllCall($hImgLib, "str", "GetProperty", "str", "redline", "str", "")
		$redLines = $aValue[0]
	EndIf

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			$Result &= returnPropertyValue($aKeys[$i], "objectpoints") & "|"
		Next
	EndIf

	If StringLen($Result) > 0 Then
		If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
		If ($xDiff <> Default) Or ($yDiff <> Default) Then
			If $xDiff = Default Then $xDiff = 0
			If $yDiff = Default Then $yDiff = 0

			DelPosWithDiff($Result, $xDiff, $yDiff, True)

			Return $Result
		EndIf
	EndIf
	Return $Result
EndFunc   ;==>multiMatchesPixelOnly

Func CloneAreaToSearch($x, $y, $x1, $y1)
	Local $hClone, $hImage, $iX, $iY, $hBMP
	$iX = $x1 - $x
	$iY = $y1 - $y
	If StringInStr($iX, "-") > 0 Or StringInStr($iY, "-") > 0 Or $iX = 0 Or $iY = 0 Then Return $hHBitmap2
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
	$hClone = _GDIPlus_BitmapCloneArea($hImage, $x, $y, $iX, $iY)
	$hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hClone)
	Return $hBMP
EndFunc   ;==>CloneAreaToSearch

; DelPosWithDiff Can be used to delete positions found by multiple images for ONE Object, $Arr Parameter should be 2D Array, [1][2]
Func DelPosWithDiff(ByRef $Input, $xDiff, $yDiff, $ReturnAsString = True, $And = True)
	If IsArray($Input) Then
		_DelPosWithDiff1($Input, $xDiff, $yDiff, $ReturnAsString, $And)
	Else
		_DelPosWithDiff2($Input, $xDiff, $yDiff, $ReturnAsString, $And)
	EndIf
EndFunc

Func _DelPosWithDiff1(ByRef $Arr, $xDiff, $yDiff, $ReturnAsString = True, $And = True)
	Local $iStart = 0
	Local $iXDiff = 0, $iYDiff = 0
	Local $IndexesToDelete = ""
	For $i = $iStart To (UBound($Arr) - 1)
		For $j = $i + 1 To (UBound($Arr) - 1)
			$iXDiff = Number(Abs(Number(Number($Arr[$i][0]) - Number($Arr[$j][0]))))
			$iYDiff = Number(Abs(Number(Number($Arr[$i][1]) - Number($Arr[$j][1]))))
			If $And = True Then
				If ($iXDiff <= $xDiff) And ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			Else
				If ($iXDiff <= $xDiff) Or ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			EndIf
			$iXDiff = 0
			$iYDiff = 0
		Next
	Next
	If StringRight($IndexesToDelete, 1) = "," Then $IndexesToDelete = StringLeft($IndexesToDelete, (StringLen($IndexesToDelete) - 1))
	If StringLen($IndexesToDelete) > 0 Then
		Local $tmpArr[UBound($Arr)][2]
		Local $splitedToDelete
		If StringInStr($IndexesToDelete, ",") > 0 Then
			$splitedToDelete = StringSplit($IndexesToDelete, ",", 2)
		Else
			$splitedToDelete = _StringEqualSplit($IndexesToDelete, StringLen($IndexesToDelete))
		EndIf

		Local $searchResult = -1

		For $i = 0 To (UBound($Arr) - 1)
			$searchResult = _ArraySearch($splitedToDelete, $i)
			If $searchResult > -1 And StringLen($splitedToDelete[$searchResult]) > 0 Then ContinueLoop ; If The Array Index Should be Deleted
			$tmpArr[$i][0] = $Arr[$i][0]
			$tmpArr[$i][1] = $Arr[$i][1]
		Next
		_ArryRemoveBlanks($tmpArr)
		$Arr = $tmpArr
	EndIf

	If $ReturnAsString = True Then
		Local $ToReturn = ""
		For $k = 0 To (UBound($Arr) - 1)
			$ToReturn &= $Arr[$k][0] & "," & $Arr[$k][1] & "|"
		Next
		If StringRight($ToReturn, 1) = "|" Then $ToReturn = StringLeft($ToReturn, (StringLen($ToReturn) - 1))
		$Arr = $ToReturn
		Return $ToReturn
	EndIf
EndFunc   ;==>_DelPosWithDiff1

Func _DelPosWithDiff2(ByRef $sResult, $xDiff, $yDiff, $ReturnAsString = True, $And = True)
	Local $tmpSplitedPositions
	If StringInStr($sResult, "|") > 0 Then
		$tmpSplitedPositions = StringSplit($sResult, "|", 2)
	Else
		$tmpSplitedPositions = _StringEqualSplit($sResult, StringLen($sResult))
	EndIf
	Local $splitedPositions[UBound($tmpSplitedPositions)][2]
	For $j = 0 To (UBound($tmpSplitedPositions) - 1)
		If StringInStr($tmpSplitedPositions[$j], ",") Then
			$splitedPositions[$j][0] = StringSplit($tmpSplitedPositions[$j], ",", 2)[0]
			$splitedPositions[$j][1] = StringSplit($tmpSplitedPositions[$j], ",", 2)[1]
		EndIf
	Next

	Local $Arr = $splitedPositions

	Local $iStart = 0
	Local $iXDiff = 0, $iYDiff = 0
	Local $IndexesToDelete = ""
	For $i = $iStart To (UBound($Arr) - 1)
		For $j = $i + 1 To (UBound($Arr) - 1)
			$iXDiff = Number(Abs(Number(Number($Arr[$i][0]) - Number($Arr[$j][0]))))
			$iYDiff = Number(Abs(Number(Number($Arr[$i][1]) - Number($Arr[$j][1]))))
			If $And = True Then
				If ($iXDiff <= $xDiff) And ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			Else
				If ($iXDiff <= $xDiff) Or ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			EndIf
			$iXDiff = 0
			$iYDiff = 0
		Next
	Next
	If StringRight($IndexesToDelete, 1) = "," Then $IndexesToDelete = StringLeft($IndexesToDelete, (StringLen($IndexesToDelete) - 1))
	If StringLen($IndexesToDelete) > 0 Then
		Local $tmpArr[UBound($Arr)][2]
		Local $splitedToDelete
		If StringInStr($IndexesToDelete, ",") > 0 Then
			$splitedToDelete = StringSplit($IndexesToDelete, ",", 2)
		Else
			$splitedToDelete = _StringEqualSplit($IndexesToDelete, StringLen($IndexesToDelete))
		EndIf

		Local $searchResult = -1

		For $i = 0 To (UBound($Arr) - 1)
			$searchResult = _ArraySearch($splitedToDelete, $i)
			If $searchResult > -1 And StringLen($splitedToDelete[$searchResult]) > 0 Then ContinueLoop ; If The Array Index Should be Deleted
			$tmpArr[$i][0] = $Arr[$i][0]
			$tmpArr[$i][1] = $Arr[$i][1]
		Next
		_ArryRemoveBlanks($tmpArr)
		$Arr = $tmpArr
	EndIf

	If $ReturnAsString = True Then
		Local $ToReturn = ""
		For $k = 0 To (UBound($Arr) - 1)
			$ToReturn &= $Arr[$k][0] & "," & $Arr[$k][1] & "|"
		Next
		If StringRight($ToReturn, 1) = "|" Then $ToReturn = StringLeft($ToReturn, (StringLen($ToReturn) - 1))
		$sResult = $ToReturn
		Return $ToReturn
	EndIf

	Return $Arr
EndFunc   ;==>_DelPosWithDiff2

Func VerifyMMPOResult($Result)
	If StringLen($Result) > 2 And StringInStr($Result, ",") > 0 Then Return True
	Return False
EndFunc   ;==>VerifyMMPOResult

Func GetHighestImageSize($directory, $addX = 0, $addY = 0)
	Local $ToReturn[2] = [-1, -1]
	Local $imgList = _FileListToArray($directory, "*", 1, True)
	Local $hImage, $iX, $iY
	For $i = 1 To (UBound($imgList) - 1)
		$hImage = _GDIPlus_BitmapCreateFromFile($imgList[$i])
		$iX &= _GDIPlus_ImageGetWidth($hImage) & "|"
		$iY &= _GDIPlus_ImageGetHeight($hImage) & "|"
		_GDIPlus_ImageDispose($hImage)
	Next
	If StringRight($iX, 1) = "|" Then $iX = StringLeft($iX, (StringLen($iX) - 1))
	If StringRight($iY, 1) = "|" Then $iY = StringLeft($iY, (StringLen($iY) - 1))
	$iX = StringSplit($iX, "|", 2)
	$iY = StringSplit($iY, "|", 2)
	$ToReturn[0] = Number(_ArrayMax($iX, 1)) + $addX
	$ToReturn[1] = Number(_ArrayMax($iY, 1)) + $addY
	Return $ToReturn
EndFunc   ;==>GetHighestImageSize

Func returnMultipleMatchesOwnVillage($directory, $maxReturnPoints = 0, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatch search, but pass "ECD" for the redlines and full coc area
	; so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, $maxReturnPoints, "ECD", "ECD", $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnMultipleMatchesOwnVillage

Func returnSingleMatchOwnVillage($directory, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatch search, with 1 return point but pass "ECD" for the redlines
	; and full coc area so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, 1, "ECD", "ECD", $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnSingleMatchOwnVillage

Func returnAllMatches($directory, $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search with 0 for the Max return points parameter
	Local $aResult = multiMatches($directory, 0, "DCD", $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnAllMatches

Func returnAllMatchesDefense($directory, $statFile = "", $minLevel = 0, $maxLevel = 1000, $x1 = 0, $y1 = 0, $x2 = $GAME_WIDTH, $y2 = $GAME_HEIGHT, $bCaptureNew = True, $xDiff = Default, $yDiff = Default)
	; This is simple, just do a multiMatches search with 0 for the Max return points parameter

	;Local $aResult = multiMatches2($directory, 0, $DCD, $CurBaseRedLine, $statFile, $minLevel, $maxLevel)
	Local $aResult = multiMatchesPixelOnly($directory, 0, $DCD, $CurBaseRedLine, $statFile, $minLevel, $maxLevel, $x1, $y1, $x2, $y2, $bCaptureNew, $xDiff, $yDiff, True, False)

	Return $aResult
EndFunc   ;==>returnAllMatchesDefense

Func returnHighestLevelSingleMatch($directory, $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, "DCD", $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the highest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a higher level then currently stored
			If Number($aResult[$i][2]) > Number($return[2]) Then
				; Store the data because its higher
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnHighestLevelSingleMatch

Func returnLowestLevelSingleMatch($directory, $returnMax = 100, $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", $returnMax + 1, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, "DCD", $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the lowest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a lower level then currently stored
			If Number($aResult[$i][2]) < Number($return[2]) Then
				; Store the data because its lower
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnLowestLevelSingleMatch

Func returnMultipleMatches($directory, $maxReturnPoints = 0, $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search specifying the Max return points parameter
	Local $aResult = multiMatches($directory, $maxReturnPoints, "DCD", $redLines, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnMultipleMatches

Func returnSingleMatch($directory, $redLines = "DCD", $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, "DCD", $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnSingleMatch