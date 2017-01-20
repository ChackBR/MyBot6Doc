
; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalSpell
; Description ...: Returns total count of spells available after call to getArmySpellCount()
; Syntax ........: GetCurTotalSpell()
; Parameters ....:
; Return values .: Total current spell count or -1 when not yet read
; Author ........: Separated from checkArmyCamp()
; Modified ......: MonkeyHunter (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetCurTotalSpell()
	;If $CurTotalSpell = False And $iTotalCountSpell > 0 Then Return -1
	Return $CurLSpell + _
			$CurHSpell + _
			$CurRSpell + _
			$CurJSpell + _
			$CurFSpell + _
			$CurCSpell + _
			$CurPSpell + _
			$CurHSpell + _
			$CurSkSpell + _
			$CurESpell
EndFunc   ;==>GetCurTotalSpell

; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalDarkSpell
; Description ...: Returns total count of dark spells available after call to getArmySpellCount()
; Return values .: Total current spell count or -1 when not yet read
; ===============================================================================================================================
Func GetCurTotalDarkSpell()
	;If $CurTotalSpell = False And $iTotalCountSpell > 0 Then Return -1
	Return $CurPSpell + _
			$CurHSpell + _
			$CurSkSpell + _
			$CurESpell
EndFunc   ;==>GetCurTotalDarkSpell
