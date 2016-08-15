; #FUNCTION# ====================================================================================================================
; Name ..........: PushBullet
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Antidote (2015-03)
; Modified ......: Sardo and Didipe (2015-05) rewrite code
;				   kgns (2015-06) $pushLastModified addition
;				   Sardo (2015-06) compliant with new pushbullet syntax (removed title)
;				   Boju(2016-05)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>

;Prevent crashes
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
Func MyErrFunc()
  ;SetLog("COM Error!"    & @CRLF  & @CRLF & _
  ;           "err.description is: " & @TAB & $oMyError.description  & @CRLF & _
  ;           "err.windescription:"   & @TAB & $oMyError.windescription & @CRLF & _
  ;           "err.number is: "       & @TAB & hex($oMyError.number,8)  & @CRLF & _
  ;           "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
  ;           "err.scriptline is: "   & @TAB & $oMyError.scriptline   & @CRLF & _
  ;           "err.source is: "       & @TAB & $oMyError.source       & @CRLF & _
  ;           "err.helpfile is: "       & @TAB & $oMyError.helpfile     & @CRLF & _
  ;           "err.helpcontext is: " & @TAB & $oMyError.helpcontext _
  ;          )
Endfunc

Func _RemoteControlPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or $pRemote = 0 Then Return
	If $PushBulletEnabled = 1 Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		Local $pushbulletApiUrl
		If $pushLastModified = 0 Then
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
		Else
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
		EndIf
		$oHTTP.Open("Get", $pushbulletApiUrl, False)
		$access_token = $PushBulletToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText

		Local $modified = _StringBetween($Result, '"modified":', ',', "", False)
		If UBound($modified) > 0 Then
			$pushLastModified = Number($modified[0]) ; modified date of the newest push that we received
			$pushLastModified -= 120 ; back 120 seconds to avoid loss of messages
		EndIf

		Local $findstr = StringRegExp(StringUpper($Result), '"BODY":"BOT')
		If $findstr = 1 Then
			Local $body = _StringBetween($Result, '"body":"', '"', "", False)
			Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
			For $x = UBound($body) - 1 To 0 Step -1
				If $body <> "" Or $iden <> "" Then
					$body[$x] = StringUpper(StringStripWS($body[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
					$iden[$x] = StringStripWS($iden[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)

					Switch $body[$x]
						Case GetTranslated(620, 1, "BOT") & " " & GetTranslated(620, 14, "HELP")
							Local $txtHelp = GetTranslated(620, 13, "You can remotely control your bot sending commands following this syntax:")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " " & GetTranslated(620, 14, -1) & GetTranslated(620, 2, " - send this help message")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " " & GetTranslated(620, 15, "DELETE") & GetTranslated(620, 3, " - delete all your previous PushBullet messages")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 16, "RESTART") & GetTranslated(620, 4, " - restart the bot named <Village Name> and Android Emulator")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 17, "STOP") & GetTranslated(620, 5, " - stop the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 18, "PAUSE") & GetTranslated(620, 6, " - pause the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 19, "RESUME") & GetTranslated(620, 7, " - resume the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 20, "STATS") & GetTranslated(620, 8, " - send Village Statistics of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 21, "LOG") & GetTranslated(620, 9, " - send the current log file of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 22, "LASTRAID") & GetTranslated(620, 10, " - send the last raid loot screenshot of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 23, "LASTRAIDTXT") & GetTranslated(620, 11, " - send the last raid loot values of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620, 24, "SCREENSHOT") & GetTranslated(620, 12, " - send a screenshot of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> SENDCHAT <TEXT> - send TEXT in clan chat of <Village Name>"
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " <" & $iOrigPushBullet & "> GETCHATS <STOP|NOW|INTERVAL> - select any of this three option to do"
							$txtHelp &= '\n'
							$txtHelp &= '\n' & GetTranslated(620, 25, "Examples:")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620, 18, "PAUSE")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " " & GetTranslated(620, 15, "DELETE")
							$txtHelp &= '\n' & GetTranslated(620, 1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620, 24, "SCREENSHOT")
							;_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,26, "Request for Help") & "\n" & $txtHelp)
							;_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,26, "Request for Help") & "\n")
							SetLog("Pushbullet: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 18, -1) ;"PAUSE"
							If $TPaused = False And $Runstate = True Then
								If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
									SetLog("PushBullet: Unable to pause during attack", $COLOR_RED)
									_PushBullet($iOrigPushBullet & " | " & GetTranslated(620, 86, "Request to Pause") & "\n" & GetTranslated(620, 87, "Unable to pause during attack, try again later."))
								ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
									ReturnHome(False, False)
									$Is_SearchLimit = True
									$Is_ClientSyncError = False
									UpdateStats()
									$Restart = True
									TogglePauseImpl("Push")
								Else
									TogglePauseImpl("Push")
								EndIf
							Else
								SetLog("Pushbullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 86, "Request to Pause") & "\n" & GetTranslated(620, 88, "Your bot is currently paused, no action was taken"))
							EndIf
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 19, -1) ;"RESUME"
							If $TPaused = True And $Runstate = True Then
								TogglePauseImpl("Push")
							Else
								SetLog("Pushbullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 27, "Request to Resume") & "\n" & GetTranslated(620, 28, "Your bot is currently resumed, no action was taken"))
							EndIf
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & GetTranslated(620, 15, -1) ;"DELETE"
							_DeletePushOfPushBullet()
							SetLog("Pushbullet: Your request has been received.", $COLOR_GREEN)
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 21, -1) ;"LOG"
							SetLog("Pushbullet: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
							_PushFileToPushBullet($sLogFName, GetTranslated(620, 29, "logs"), "text/plain; charset=utf-8", $iOrigPushBullet & " | " & GetTranslated(620, 30, "Current Log") & " \n")
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 22, -1) ;"LASTRAID"
							If $AttackFile <> "" Then
								_PushFileToPushBullet($AttackFile, GetTranslated(620, 31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620, 32, "Last Raid") & " \n" & $AttackFile)
							Else
								_PushToPushBullet(@HOUR & ":" & @MIN &" - " & $iOrigPushBullet & " - Last Raid - [S]"& _NumberFormat($SearchCount) &"\n[G]" & _NumberFormat(int($iGoldLast/1000+$iGoldLastBonus/1000)) & "k [E]" & _NumberFormat(int($iElixirLast/1000+$iElixirLastBonus/1000)) & "k [DE]" & _NumberFormat($iDarkLast+$iDarkLastBonus) & " [T]" & _NumberFormat($iTrophyLast))
							EndIf
							SetLog("Pushbullet: Push Last Raid Snapshot...", $COLOR_GREEN)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(20, 23, -1) ;"LASTRAIDTXT"
							SetLog("Pusbullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 34, "Last Raid txt") & "\n" & "[" & GetTranslated(620, 35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620, 36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620, 37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620, 38, "T") & "]: " & $iTrophyLast)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 20, -1) ;"STATS"
							SetLog("Pushbullet: Your request has been received. Statistics sent", $COLOR_GREEN)
							PushMsgToPushBullet ("AttackCountStats")
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 24, -1) ;"SCREENSHOT"
							SetLog("Pushbullet: ScreenShot request received", $COLOR_GREEN)
							$RequestScreenshot = 1
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 16, -1) ;"RESTART"
							_DeleteMessageOfPushBullet($iden[$x])
							SetLog("Your request has been received. Bot and Android Emulator restarting...", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 46, "Request to Restart") & "..." & "\n" & GetTranslated(620, 47, "Your bot and Android Emulator are now restarting") & "...")
							SaveConfig()
							_Restart()
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620, 17, -1) ;"STOP"
							_DeleteMessageOfPushBullet($iden[$x])
							SetLog("Your request has been received. Bot is now stopped", $COLOR_GREEN)
							If $Runstate = True Then
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 48, "Request to Stop") & "..." & "\n" & GetTranslated(620, 49, "Your bot is now stopping") & "...")
								btnStop()
								AutoStart()
							Else
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 48, "Request to Stop") & "..." & "\n" & GetTranslated(620, 50, "Your bot is currently stopped, no action was taken"))
							EndIf
									;=================================== "TheRevenor Notify" ===================================
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " SCREENSHOTHD"
							SetLog("Pushbullet: ScreenShot HD request received", $COLOR_GREEN)
							$RequestScreenshot = 1
							$RequestScreenshotHD = 1
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " BUILDER"
							SetLog("Pushbullet: Builder Status request received", $COLOR_GREEN)
							$RequestBuilderInfo = 1
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " SHIELD"
							SetLog("Pushbullet: Shield Status request received", $COLOR_GREEN)
							$RequestShieldInfo = 1
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " TOP"
							SetLog("Pushbullet: Your request has been received. Top Gain & Zap Statistics sent", $COLOR_GREEN)
							Local $txtStats = " | Top Gain & Zap Stats Village Report" & "\n" & "\n[G]: " & _NumberFormat($topgoldloot) & "\n[E]: "
							  $txtStats & = _NumberFormat($topelixirloot) & "\n[D]: " & _NumberFormat($topdarkloot) & "\n[T]: " & $toptrophyloot
							  $txtStats & = "\n[Z]: " & _NumberFormat($smartZapGain) & "\n[S]: " & _NumberFormat($numLSpellsUsed)
							_PushToPushBullet($iOrigPushBullet & $txtStats)
							_DeleteMessageOfPushBullet($iden[$x])
									;=================================== "Chat Bot" ===================================
						Case Else
							If StringInStr($body[$x], StringUpper($iOrigPushBullet) & " SENDCHAT") Then
								$FoundChatMessage = 1
								$chatMessage = StringRight($body[$x], StringLen($body[$x]) - StringLen("BOT " & StringUpper($iOrigPushBullet) & " SENDCHAT "))
								$chatMessage = StringLower($chatMessage)
								ChatbotPushbulletQueueChat($chatMessage)
								_PushToPushBullet($iOrigPushBullet & " | Chat queued, will send on next idle")
								_DeleteMessageOfPushBullet($iden[$x])
							ElseIf StringInStr($body[$x], StringUpper($iOrigPushBullet) & " GETCHATS") Then
								$FoundChatMessage = 1
								$Interval = StringRight($body[$x], StringLen($body[$x]) - StringLen("BOT " & StringUpper($iOrigPushBullet) & " GETCHATS "))
								If $Interval = "STOP" Then
									ChatbotPushbulletStopChatRead()
									_PushToPushBullet($iOrigPushBullet & " | Stopping interval sending")
								ElseIf $Interval = "NOW" Then
									ChatbotPushbulletQueueChatRead()
									_PushToPushBullet($iOrigPushBullet & " | Command queued, will send clan chat image on next idle")
								Else
									If Number($Interval) <> 0 Then
										ChatbotPushbulletIntervalChatRead(Number($Interval))
										_PushToPushBullet($iOrigPushBullet & " | Command queued, will send clan chat image on interval")
									Else
										SetLog("Chatbot: incorrect command syntax, Example: BOT <VillageName> GETCHATS NOW|STOP|INTERVAL", $COLOR_RED)
										_PushToPushBullet($iOrigPushBullet & " | Command not recognized" & "\n" & "Example: BOT <VillageName> GETCHATS NOW|STOP|INTERVAL")
									EndIf
								EndIf
									_DeleteMessageOfPushBullet($iden[$x])
							ElseIf $body[$x] = "BOT START" Then ;TheRevenor Start
								btnStart()
								SetLog("Pushbullet: Your request has been received. Bot is now Started", $COLOR_BLUE)
								_PushToPushBullet("Request to Start..." & "\n" & "Your bot is now Starting.")
								_DeleteMessageOfPushBullet($iden[$x])
							Else
								Local $lenstr = StringLen(GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "")
								Local $teststr = StringLeft($body[$x], $lenstr)
								If $teststr = (GetTranslated(620, 1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "") Then
								SetLog("Pushbullet: received command syntax wrong, command ignored.", $COLOR_RED)
									_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 51, "Command not recognized") & "\n" & GetTranslated(620, 52, "Please push BOT HELP to obtain a complete command list."))
									_DeleteMessageOfPushBullet($iden[$x])
								EndIf
							EndIf
					EndSwitch
					$body[$x] = ""
					$iden[$x] = ""
				EndIf
			Next
		EndIf
	EndIf

	If $TelegramEnabled = 1 Then
		$lastmessage = GetLastMsg()
        If $lastmessage = "\/start" And $lastremote <> $lastuid Then
			$lastremote = $lastuid
			Getchatid(GetTranslated(18, 48, "select your remote"))
		Else
			local $body2 = _StringProper(StringStripWS($lastmessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
			If $lastremote <> $lastuid Then
				$lastremote = $lastuid
				Switch $body2
					Case GetTranslated(18, 2, "Help") & "\u2753"
						Local $txtHelp = GetTranslated(18, 17, "You can remotely control your bot by selecting this key")
						$txtHelp &= "\n" & GetTranslated(18, 18, "HELP - send this help message")
						$txtHelp &= "\n" & GetTranslated(18, 19, "DELETE  - Use this if Remote dont respond to your request")
						$txtHelp &= "\n" & GetTranslated(18, 20, "RESTART - restart the bot and bluestacks")
						$txtHelp &= "\n" & GetTranslated(18, 21, "STOP - stop the bot")
						$txtHelp &= "\n" & GetTranslated(18, 22, "PAUSE - pause the bot")
						$txtHelp &= "\n" & GetTranslated(18, 23, "RESUME   - resume the bot")
						$txtHelp &= "\n" & GetTranslated(18, 24, "STATS - send Village Statistics")
						$txtHelp &= "\n" & GetTranslated(18, 102, "LOG - send the Bot log file")
						$txtHelp &= "\n" & GetTranslated(18, 25, "LASTRAID - send the last raid loot screenshot. you should check Take Loot snapshot in End Battle Tab ")
						$txtHelp &= "\n" & GetTranslated(18, 26, "LASTRAIDTXT - send the last raid loot values")
						$txtHelp &= "\n" & GetTranslated(18, 27, "SCREENSHOT - send a screenshot")
						$txtHelp &= "\n" & GetTranslated(18, 28, "POWER - select power option")
						$txtHelp &= "\n" & GetTranslated(18, 104, "RESETSTATS - reset Village Statistics")
						$txtHelp &= "\n" & GetTranslated(18, 105, "DONATEON <TROOPNAME> <QUANTITY> - turn on donate for troop & quantity")
						$txtHelp &= "\n" & GetTranslated(18, 106, "DONATEOFF <TROOPNAME> <QUANTITY> - turn off donate for troop & quantity")
						$txtHelp &= "\n" & GetTranslated(18, 107, "T&S_STATS - send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslated(18, 108, "HALTATTACKON - Turn On 'Halt Attack' in the 'Misc' Tab with the default options")
						$txtHelp &= "\n" & GetTranslated(18, 109, "HALTATTACKOFF - Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= "\n" & GetTranslated(18, 110, "SWITCHPROFILE <PROFILENAME> - Swap Profile Village and restart bot")
						$txtHelp &= "\n" & GetTranslated(18, 111, "GETCHATS <INTERVAL|NOW|STOP> - to get the latest clan chat as an image")
						$txtHelp &= "\n" & GetTranslated(18, 112, "SENDCHAT <chat message> - to send a chat to your clan")
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 29, "Request for Help") & "\n" & $txtHelp)
						SetLog("Telegram: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
					Case GetTranslated(18, 3, "Pause") & "\u2016"
						If $TPaused = False And $Runstate = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("Telegram: Unable to pause during attack", $COLOR_RED)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 30, "Request to Pause") & "\n" & GetTranslated(18, 134, "Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$Is_SearchLimit = True
								$Is_ClientSyncError = True
								;UpdateStats()
								$Restart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog("Telegram: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 30, "Request to Pause") & "\n" & GetTranslated(18, 93, "Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(18, 4, "Resume") & "\u25b6"
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Telegram: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 31, "Request to Resume") & "\n" & GetTranslated(18, 94, "Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(18, 5, "Delete") & "\ud83d\udeae"
						;$oHTTP2.Open("Get", $url & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
						;$oHTTP2.Send()
						SetLog("Telegram: Your request has been received.", $COLOR_GREEN)
					Case GetTranslated(18, 102, "Log") & "\ud83d\udcd1"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
						_PushFileToPushBullet2($sLogFName, "logs", "text\/plain; charset=utf-8", $iOrigPushBullet & " | Current Log " & "\n")
					Case GetTranslated(18, 6, "Power") & "\ud83d\udca1"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". POWER option now sent", $COLOR_GREEN)
						;$oHTTP2.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						;$oHTTP2.SetRequestHeader("Content-Type", "application/json")
						;local $pPush3 = '{"text": "' & GetTranslated(18,49,"select POWER option") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,7,"Hibernate")&'\n\u26a0\ufe0f","'&GetTranslated(18,8,"Shut down")&'\n\u26a0\ufe0f","'&GetTranslated(18,9,"Standby")&'\n\u26a0\ufe0f"],["'&GetTranslated(18,10,"Cancel")&'"]],"one_time_keyboard": true,"resize_keyboard":true}}'
						;$oHTTP2.Send($pPush3)
					Case GetTranslated(18, 7, "Hibernate") & "\u26a0\ufe0f"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Hibernate PC", $COLOR_GREEN)
						Getchatid(GetTranslated(18, 50, "PC got Hibernate"))
						Shutdown(64)
					Case GetTranslated(18, 8, "Shut down") & "\u26a0\ufe0f"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Shut down PC", $COLOR_GREEN)
						Getchatid(GetTranslated(18, 51, "PC got Shutdown"))
						Shutdown(5)
					Case GetTranslated(18, 9, "Standby") & "\u26a0\ufe0f"
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Standby PC", $COLOR_GREEN)
						Getchatid(GetTranslated(18, 52, "PC got Standby"))
						Shutdown(32)
					Case GetTranslated(18, 10, "Cancel")
						SetLog("Telegram: Your request has been received from " & $iOrigPushBullet & ". Cancel Power option", $COLOR_GREEN)
						Getchatid(GetTranslated(18, 53, "canceled"))
					Case GetTranslated(18, 11, "Lastraid") & "\ud83d\udc7e"
						If $LootFileName <> "" Then
							_PushToPushBullet($LootFileName, "Loots", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(18, 95, "Last Raid") & "\n" & $LootFileName)
						Else
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 32, "There is no last raid screenshot."))
						EndIf
						SetLog("Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
					Case GetTranslated(18, 12, "LastRaidTxt") & "\ud83d\udc7e"
						SetLog("Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 33, "Last Raid txt") & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
					Case GetTranslated(18, 13, "Stats") & "\ud83d\udcca"
						SetLog("Telegram: Your request has been received. Statistics sent", $COLOR_GREEN)
						Local $GoldGainPerHour = 0
						Local $ElixirGainPerHour = 0
						Local $DarkGainPerHour = 0
						Local $TrophyGainPerHour = 0
						If $FirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $iDarkStart <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($iTrophyTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslated(18,34,"Stats Village Report") & "\n" & GetTranslated(18, 35, "At Start") & "\n[G]: " & _NumberFormat($iGoldStart) & " [E]: "
							  $txtStats &= _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart
							  $txtStats &= "\n\n" & GetTranslated(18,36,"Now (Current Resources)") & "\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent)
							  $txtStats &= " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount
							  $txtStats &= "\n\n" & GetTranslated(11,26,"Gain per Hour") & ":\n[G]: " & $GoldGainPerHour & " [E]: " & $ElixirGainPerHour
							  $txtStats &= "\n[D]: " & $DarkGainPerHour & " [T]: " & $TrophyGainPerHour
							  $txtStats &= "\n\n" & GetTranslated(18,37,"No. of Free Builders") & ": " & $iFreeBuilderCount & "\n[" & GetTranslated(18, 38, "No. of Wall Up") & "]: G: "
							  $txtStats &= $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(18, 39, "Attacked") & ": "
							  $txtStats &= GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(18, 40, "Skipped") & ": " & $iSkippedVillageCount
						_PushToPushBullet($iOrigPushBullet & $txtStats)
					Case GetTranslated(18, 14, "Screenshot") & "\ud83c\udfa6"
						SetLog("Telegram: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
						$RequestScreenshotHD = 1
					Case GetTranslated(18, 15, "Restart") & "\u21aa"
						SetLog("Telegram: Your request has been received. Bot and BS restarting...", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 41, "Request to Restart...") & "\n" & GetTranslated(18, 42, "Your bot and BS are now restarting..."))
						SaveConfig()
						_Restart()
					Case GetTranslated(18, 16, "Stop") & "\u270b"
						SetLog("Telegram: Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 43, "Request to Stop...") & "\n" & GetTranslated(18, 44, "Your bot is now stopping..."))
							btnStop()
						Else
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 43, "Request to Stop...") & "\n" & GetTranslated(18, 45, "Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslated(18, 99, "ResetStats") & "\ud83d\udcca"
						btnResetStats()
						SetLog("Telegram: Your request has been received. Statistics resetted", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 113, "Request for ResetStats has been resetted."))
					Case GetTranslated(18, 98, "T&S_Stats") & "\ud83d\udcca"
						SetLog("Telegram: Your request has been received. Sending Troop/Spell Stats...", $COLOR_GREEN)
						Local $txtTroopStats = " | " & GetTranslated(18, 114, "Troops/Spells set to Train") & ":\n" & "Barbs:" & $BarbComp & " Arch:" & $ArchComp & " Gobl:" & $GoblComp
						$txtTroopStats &= "\n" & "Giant:" & $GiantComp & " WallB:" & $WallComp & " Wiza:" & $WizaComp
						$txtTroopStats &= "\n" & "Balloon:" & $BallComp & " Heal:" & $HealComp & " Dragon:" & $DragComp & " Pekka:" & $PekkComp
						$txtTroopStats &= "\n" & "Mini:" & $MiniComp & " Hogs:" & $HogsComp & " Valks:" & $ValkComp
						$txtTroopStats &= "\n" & "Golem:" & $GoleComp & " Witch:" & $WitcComp & " Lava:" & $LavaComp
						$txtTroopStats &= "\n" & "LSpell:" & $iLightningSpellComp & " HeSpell:" & $iHealSpellComp & " RSpell:" & $iRageSpellComp & " JSpell:" & $iJumpSpellComp
						$txtTroopStats &= "\n" & "FSpell:" & $iFreezeSpellComp & " PSpell:" & $iPoisonSpellComp & " ESpell:" & $iEarthSpellComp & " HaSpell:" & $iHasteSpellComp & "\n"
						$txtTroopStats &= "\n" & GetTranslated(18, 115, "Current Trained Troops & Spells") & ":"
						For $i = 0 To UBound($TroopSpellStats) - 1
							If $TroopSpellStats[$i][0] <> "" Then
								$txtTroopStats &= "\n" & $TroopSpellStats[$i][0] & ":" & $TroopSpellStats[$i][1]
							EndIf
						Next
						$txtTroopStats &= "\n\n" & GetTranslated(18, 116, "Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
						_PushToPushBullet($iOrigPushBullet & $txtTroopStats)
					Case GetTranslated(18, 100, "HaltAttackOn") & "\u25fb"
						GUICtrlSetState($chkBotStop, $GUI_CHECKED)
						btnStop()
						btnStart()
					Case GetTranslated(18, 101, "HaltAttackOff") & "\u25b6"
						GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
						btnStop()
						btnStart()
								;=================================== "Chat Bot" ===================================
					Case Else
						If StringInStr($body2, "SENDCHAT") Then
							$FoundChatMessage = 1
							$chatMessage = StringRight($body2, StringLen($body2) - StringLen("SENDCHAT "))
							$chatMessage = StringLower($chatMessage)
							ChatbotPushbulletQueueChat($chatMessage)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 97, "Chat queued, will send on next idle"))
						ElseIf StringInStr($body2, "GETCHATS") Then
							$FoundChatMessage = 1
							$Interval = StringRight($body2, StringLen($body2) - StringLen("GETCHATS "))
							If $Interval = "STOP" Then
								ChatbotPushbulletStopChatRead()
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 117, "Stopping interval sending"))
							ElseIf $Interval = "NOW" Then
								ChatbotPushbulletQueueChatRead()
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 118, "Command queued, will send clan chat image on next idle"))
							Else
								If Number($Interval) <> 0 Then
									ChatbotPushbulletIntervalChatRead(Number($Interval))
									_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 119, "Command queued, will send clan chat image on interval"))
								Else
									SetLog("Telegram: received command syntax wrong, command ignored.", $COLOR_RED)
									_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 46, "Command not recognized") & "\n" & GetTranslated(18, 47, "Please push BOT HELP to obtain a complete command list."))
								EndIf
							EndIf
						ElseIf StringInStr($body2, "DONATEON") Then
							$DonateAtivated = 0
							$TroopType = StringRight($body2, StringLen($body2) - StringLen("DONATEON "))
							If StringInStr($TroopType, "GOLEM") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 6)))
								SetLog("Telegram: Request to Donate Golem has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumGole, $TroopQuantity)
								$GoleComp = $TroopQuantity
								GUICtrlSetState($ChkDonateGolems, $GUI_CHECKED)
								$iChkDonateGolems = 1
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "LAVA") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 5)))
								SetLog("Telegram: Request to Donate Lava Hounds has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumLava, $TroopQuantity)
								$LavaComp = $TroopQuantity
								GUICtrlSetState($chkDonateLavaHounds, $GUI_CHECKED)
								$ichkDonateLavaHounds = 1
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "PEKKA") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 6)))
								SetLog("Telegram: Request to Donate Pekkas has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumPekk, $TroopQuantity)
								$PekkComp = $TroopQuantity
								GUICtrlSetState($ChkDonatePekkas, $GUI_CHECKED)
								$iChkDonatePekkas = 1
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "BALLOON") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 5)))
								SetLog("Telegram: Request to Donate Balloons has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumBall, $TroopQuantity)
								$BallComp = $TroopQuantity
								GUICtrlSetState($chkDonateBalloons, $GUI_CHECKED)
								$ichkDonateBalloons = 1
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "HOGS") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 4)))
								SetLog("Telegram: Request to Donate Hog Riders has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumHogs, $TroopQuantity)
								$HogsComp = $TroopQuantity
								GUICtrlSetState($ChkDonateHogRiders, $GUI_CHECKED)
								$iChkDonateHogRiders = 1
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "DRAGON") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 7)))
								SetLog("Telegram: Request to Donate Dragons has been activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumDrag, $TroopQuantity)
								$DragComp = $TroopQuantity
								GUICtrlSetState($ChkDonateDragons, $GUI_CHECKED)
								$iChkDonateDragons = 1
								$DonateAtivated = 1
							Else
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 120, "DONATEON Failed, Invalid TroopType") & "\n" & GetTranslated(18, 121, "Available Troops: GOLEM|LAVA|PEKKA|BALLOON|HOGS|DRAGON") & "\n" & GetTranslated(18, 122, "Example: DONATEON GOLEM 1"))
								$DonateAtivated = 0
							EndIf
							If $DonateAtivated = 1 Then
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 123, "DONATE Activated") & "\n" & GetTranslated(18, 124, "Troops updated with") & ": " & $TroopType)
							EndIf
						ElseIf StringInStr($body2, "DONATEOFF") Then
							$DonateAtivated = 0
							$TroopType = StringRight($body2, StringLen($body2) - StringLen("DONATEOFF "))
							If StringInStr($TroopType, "GOLEM") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 6)))
								SetLog("Telegram: Request to Donate Golems has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumGole, $TroopQuantity)
								$GoleComp = $TroopQuantity
								GUICtrlSetState($ChkDonateGolems, $GUI_UNCHECKED)
								$iChkDonateGolems = 0
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "LAVA") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 5)))
								SetLog("Telegram: Request to Donate Lava Hounds has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumLava, $TroopQuantity)
								$LavaComp = $TroopQuantity
								GUICtrlSetState($chkDonateLavaHounds, $GUI_UNCHECKED)
								$ichkDonateLavaHounds = 0
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "PEKKA") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 6)))
								SetLog("Telegram: Request to Donate Pekkas has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumPekk, $TroopQuantity)
								$PekkComp = $TroopQuantity
								GUICtrlSetState($ChkDonatePekkas, $GUI_UNCHECKED)
								$iChkDonatePekkas = 0
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "BALLOON") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 5)))
								SetLog("Telegram: Request to Donate Balloons has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumBall, $TroopQuantity)
								$BallComp = $TroopQuantity
								GUICtrlSetState($chkDonateBalloons, $GUI_UNCHECKED)
								$ichkDonateBalloons = 0
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "HOGS") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 4)))
								SetLog("Telegram: Request to Donate Hog Riders has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumHogs, $TroopQuantity)
								$HogsComp = $TroopQuantity
								GUICtrlSetState($ChkDonateHogRiders, $GUI_UNCHECKED)
								$iChkDonateHogRiders = 0
								$DonateAtivated = 1
							ElseIf StringInStr($TroopType, "DRAGON") Then
								$TroopQuantity = Number(StringRight($TroopType, (StringLen($TroopType) - 7)))
								SetLog("Telegram: Request to Donate Dragons has been de-activated", $COLOR_GREEN)
								GUICtrlSetData($txtNumDrag, $TroopQuantity)
								$DragComp = $TroopQuantity
								GUICtrlSetState($ChkDonateDragons, $GUI_UNCHECKED)
								$iChkDonateDragons = 0
								$DonateAtivated = 1
							Else
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 125, "DONATEOFF Failed, Invalid TroopType") & "\n" & GetTranslated(18, 121, "Available Troops: GOLEM|LAVA|PEKKA|BALLOON|HOGS|DRAGON") & "\n" & GetTranslated(18, 126, "Example: DONATEOFF GOLEM 1"))
								$DonateAtivated = 0
							EndIf
							If $DonateAtivated = 1 Then
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 127, "DONATE Deactivated") & "\n" & GetTranslated(18, 124, "Troops updated with") & ": " & $TroopType)
							EndIf
						ElseIf StringInStr($body2, "SWITCHPROFILE") Then
							$VillageSelect = StringRight($body2, StringLen($body2) - StringLen("SWITCHPROFILE "))
							Local $iIndex = _GUICtrlComboBox_FindString($cmbProfile, $VillageSelect)
							If $iIndex = -1 Then
								SetLog("Telegram: Profile Switch failed", $COLOR_RED)
								$profileString = StringReplace(_GUICtrlComboBox_GetList($cmbProfile), "|", "\n")
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 128, "Error Switch Profile") & ":\n" & GetTranslated(18, 129, "Available Profiles") & ":\n" & $profileString)
							Else
								btnStop()
								_GUICtrlComboBox_SetCurSel($cmbProfile, $iIndex)
								cmbProfile()
								SetLog("Telegram: Profile Switch success!", $COLOR_GREEN)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 130, "Switched to Profile") & ": " & $VillageSelect & GetTranslated(18, 131, " Success!"))
								btnStart()
							EndIf
						ElseIf StringInStr($body2, "START") Then ;TheRevenor Start
								btnStart()
								SetLog("Telegram: Your request has been received. Bot is now Started", $COLOR_BLUE)
								_PushToPushBullet("Request to Start..." & "\n" & "Your bot is now Starting.")
						Else
							SetLog("Telegram: received command '" & $body2 & "' syntax wrong, command ignored.", $COLOR_RED)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18,46,"Command received '" & $body2 & "' not recognized") & "\n" & GetTranslated(18,47,"Please push BOT HELP to obtain a complete command list."))
						EndIf
				EndSwitch
			EndIf
		EndIf
	EndIf

EndFunc   ;==>_RemoteControlPushBullet

Func _PushBullet($pMessage = "")
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return
	If $PushBulletEnabled = 1 Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		;$access_token = $PushBulletToken
		$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
		$oHTTP.SetCredentials($PushBulletToken, "", 0)
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText
		Local $device_iden = _StringBetween($Result, 'iden":"', '"')
		Local $device_name = _StringBetween($Result, 'nickname":"', '"')
		Local $device = ""
		Local $pDevice = 1
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$oHTTP.SetCredentials($PushBulletToken, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	If $TelegramEnabled = 1 Then
		$access_token2 = $TelegramToken
		$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates", False)
		$oHTTP2.Send()
		$Result = $oHTTP2.ResponseText
		local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		$chat_id2 = _ArrayPop($chat_id)
		$oHTTP2.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendmessage", False)
		;$oHTTP2.SetRequestHeader("Content-Type", "application/json")
		$oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
	    Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & '.' & @MIN & "." & @SEC
		local $pPush3 = '{"text":"' & $pMessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
		$oHTTP2.Send($pPush3)
	EndIf

EndFunc   ;==>_PushBullet

Func _PushToPushBullet($pMessage, $1 = "", $2 = "", $3 = "")
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return
	If $PushBulletEnabled = 1 Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$access_token = $PushBulletToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf

	If $TelegramEnabled = 1 Then
		$access_token2 = $TelegramToken
		$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$url = "https://api.telegram.org/bot"
		$oHTTP2.Open("Post", $url & $access_token2 & "/sendMessage", False)
		$oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

		Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & '.' & @MIN & "." & @SEC
		Local $pPush3 = '{"text":"' & $pMessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
		$oHTTP2.Send($pPush3)
	EndIf
EndFunc   ;==>_PushToPushBullet

Func GetLastMsg()
    If $TelegramEnabled = 0 Or $TelegramToken = "" Then Return
	$access_token2 = $TelegramToken
	$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates", False)
	$oHTTP2.Send()
	$Result = $oHTTP2.ResponseText
	;SetLog("Telegram Result=" & $Result, $COLOR_RED)

	Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$chat_id2 = _ArrayPop($chat_id)

	Local $uid = _StringBetween($Result, 'update_id":', '"message"') ;take update id
	$lastuid = StringTrimRight(_ArrayPop($uid), 2)


	;SetLog("Telegram chat_id=" & $chat_id2, $COLOR_RED)
	;SetLog("Telegram lastuid=" & $lastuid, $COLOR_RED)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result, 'text":"', '"}}') ;take message
		Local $lastmessage = _ArrayPop($rmessage) ;take last message
		;SetLog("Telegram: $lastmessage=" & $lastmessage, $COLOR_RED)
	EndIf


	$oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates?offset=" & $lastuid, False)
	$oHTTP2.Send()
	$Result2 = $oHTTP2.ResponseText

	;local $chat_id_ = _StringBetween($Result2, 'm":{"id":', ',"f')
	;local $chat_id2_ = _Arraypop($chat_id_)

	;local $uid_ = _StringBetween($Result2, 'update_id":', '"message"' ) ;take update id
	;$lastuid_ = StringTrimRight(_Arraypop($uid_), 2)

	;SetLog("Telegram Result2=" & $Result2, $COLOR_PURPLE)
	;SetLog("Telegram chat_id2_=" & $chat_id2_, $COLOR_PURPLE)
	;SetLog("Telegram lastuid_=" & $lastuid_, $COLOR_PURPLE)

	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result2, 'text":"', '"}}') ;take message
		Local $lastmessage = _ArrayPop($rmessage) ;take last message
		If $lastmessage = "" Then
			Local $rmessage = _StringBetween($Result2, 'text":"', '","entities"') ;take message
			Local $lastmessage = _ArrayPop($rmessage) ;take last message
		EndIf
		; Fix for Telegram v3.8.x on Android by CDudz
		;If StringLeft($rmessage, 18) = "SELECT YOUR REMOTE" Then
		;	local $lastmessage = _Arraypop(StringTrimLeft($rmessage, 29))
		;EndIf
		;SetLog("Telegram: $lastmessage2=" & $lastmessage, $COLOR_PURPLE)
		Return $lastmessage
	EndIf

EndFunc ;==>GetLastMsg

Func ansi2unicode($str)
	Local $keytxt = StringSplit($str, "\n", 1)
	Local $aSRE = StringRegExp($keytxt[2], "\\u(....)", 3)
	For $i = 0 To UBound($aSRE) - 1
		$keytxt[1] &= BinaryToString("0x" & $aSRE[$i], 3)
		;$keytxt[1] = StringReplace($keytxt[2], "\u" & $aSRE[$i], BinaryToString("0x" & $aSRE[$i], 3))
	Next
	If $keytxt[0] > 2 Then
		$ansiStr = "\n" & $keytxt[1] & "\n" & $keytxt[2]
	Else
		$ansiStr = "\n" & $keytxt[1]
	EndIf
	Return $ansiStr
EndFunc ;==>ansi2unicode


Func Getchatid($msgtitle)
	$access_token2 = $TelegramToken
	$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$url = "https://api.telegram.org/bot"
	$oHTTP2.Open("Post", $url & $access_token2 & "/sendMessage", False)
	$oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
	;$oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
	;$oHTTP2.SetRequestHeader("Content-Type", "application/json")

	Local $pPush3 = '{"text": "' & $msgtitle & '", "chat_id":' & $chat_id2 & ', "reply_markup": {"keyboard": [["' & GetTranslated(18, 16, "Stop") _
			 & '\u270b","' & GetTranslated(18, 3, "Pause") & '\u2016","' & GetTranslated(18, 15, "Restart") & '\u21aa","' & GetTranslated(18, 4, "Resume") & '\u25b6"],["' _
			 & GetTranslated(18, 2, "Help") & '\u2753","' & GetTranslated(18, 5, "Delete") & '\ud83d\udeae","' & GetTranslated(18, 102, "Log") & '\ud83d\udcd1","' & GetTranslated(18, 11, "Lastraid") & '\ud83d\udc7e"],["' _
			 & GetTranslated(18, 14, "Screenshot") & '\ud83c\udfa6","' & GetTranslated(18, 12, "LastRaidTxt") & '\ud83d\udc7e","' & GetTranslated(18, 6, "Power") & '\ud83d\udca1"],["' _
			 & GetTranslated(18, 13, "Stats") & '\ud83d\udcca","' & GetTranslated(18, 98, "T&S_Stats") & '\ud83d\udcca","' & GetTranslated(18, 99, "ResetStats") & '\ud83d\udcca"],["' _
			 & GetTranslated(18, 100, "HaltAttackOn") & '\u25fb","' & GetTranslated(18, 101, "HaltAttackOff") & '\u25b6"]],"one_time_keyboard": false,"resize_keyboard":true}}'
	$oHTTP2.Send($pPush3)

	$lastremote = $lastuid

EndFunc   ;==>Getchatid


Func _PushFileToPushBullet($File, $Folder, $FileType, $body)
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return
	If $PushBulletEnabled = 1 Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			$access_token = $PushBulletToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog("Pusbullet: Unable to send file " & $File, $COLOR_RED)
				_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 53, "Unable to Upload File") & "\n" & GetTranslated(620, 54, "Occured an error type") & " 1 " & GetTranslated(620, 55, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Pushbullet: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 53, "Unable to Upload File") & "\n" & GetTranslated(620, 54, "Occured an error type") & " 2 " & GetTranslated(620, 55, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf

	If $TelegramEnabled = 1 Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $TelegramToken
			$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $chat_id2 & ' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP2.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto", False)
			$oHTTP2.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP2.Send($pPush)
		Else
			SetLog("Telegram: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 54, "Unable to Upload File") & "\n" & GetTranslated(18, 55, "Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
EndFunc   ;==>_PushFileToPushBullet

Func _PushFileToPushBullet2($File, $Folder, $FileType, $body)
	If $TelegramEnabled = 0 Or $TelegramToken = "" Then Return
	If $TelegramEnabled = 1 Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $TelegramToken
			$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/SendDocument"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $chat_id2 & ' " -F document=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '";filename="' & StringTrimRight($File, 3) & 'txt"', "", @SW_HIDE)
			$oHTTP2.Open("Post", $telegram_url, False)
			$oHTTP2.SetRequestHeader("Content-Type", "application/json")
			Local $pPush2 = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '"}'
			$oHTTP2.Send($pPush2)
		Else
			SetLog("Telegram: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 54, "Unable to Upload File") & "\n" & GetTranslated(18, 55, "Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
EndFunc   ;==>_PushFileToPushBullet2


Func _DeletePushOfPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==>_DeletePushOfPushBullet

Func _DeleteMessageOfPushBullet($iden)
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""
EndFunc   ;==>_DeleteMessageOfPushBullet

Func PushMsgToPushBullet($Message, $Source = "")
	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pRemote = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 56, "Bot restarted"))
		Case "OutOfSync"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 57, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620, 58, "Attacking now") & "...")
		Case "LastRaid"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $iAlertPBLastRaidTxt = 1 Then
				_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 34, "Last Raid txt") & "\n" & "[" & GetTranslated(620, 35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620, 36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620, 37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620, 38, "T") & "]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Pushbullet/Telegram: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pLastRaidImg = 1 Then
				_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN & "." & @SEC
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " " & GetTranslated(620, 35, "G") & $iGoldLast & " " & GetTranslated(620, 36, "E") & $iElixirLast & " " & GetTranslated(620, 37, "D") & $iDarkLast & " " & GetTranslated(620, 38, "T") & $iTrophyLast & " " & GetTranslated(620, 59, "S") & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Pushbullet/Telegram: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFileToPushBullet($AttackFile, GetTranslated(620, 31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620, 32, "Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 60, "Found Wall level") & " " & $icmbWalls + 4 & "\n" & " " & GetTranslated(620, 61, "Wall segment has been located") & "...\n" & GetTranslated(620, 62, "Upgrading") & "...")
		Case "SkypWalls"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 63, "Cannot find Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(620, 64, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 1. " & GetTranslated(620, 65, "Another Device has connected") & "\n" & GetTranslated(620, 66, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603, 14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603, 9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603, 8, "seconds"))
		Case "AnotherDevice60"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 2. " & GetTranslated(620, 65, "Another Device has connected") & "\n" & GetTranslated(620, 66, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603, 9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603, 8, "seconds"))
		Case "AnotherDevice"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 3. " & GetTranslated(620, 65, "Another Device has connected") & "\n" & GetTranslated(620, 66, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603, 8, "seconds"))
		Case "TakeBreak"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pTakeAbreak = 1 AND $PersonalBreakNotified = False Then
				_PushToPushBullet(@HOUR & ":" & @MIN &" - " & $iOrigPushBullet & " | Personal Break.." & "\n" & GetTranslated(620, 67, "Chief, we need some rest!") & "\n" & GetTranslated(620, 68, "Village must take a break.."))
				$PersonalBreakNotified = True
			Endif
		Case "CocError"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 69, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pRemote = 1 And $Source = "Push" Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 70, "Request to Pause") & "..." & "\n" & GetTranslated(620, 71, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pRemote = 1 And $Source = "Push" Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 72, "Request to Resume") & "..." & "\n" & GetTranslated(620, 73, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 74, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620, 75, "skip(s)") & "\n" & GetTranslated(620,76, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pMatchFound = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & $sModeText[$iMatchMode] & " " & GetTranslated(620, 89, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620, 75, "skip(s)") & "\n" & "[" & GetTranslated(620, 35, "G") & "]: " & _NumberFormat($searchGold) & "; [" & GetTranslated(620, 36, "E") & "]: " & _NumberFormat($searchElixir) & "; [" & GetTranslated(620, 37, "D") & "]: " & _NumberFormat($searchDark) & "; [" & GetTranslated(620, 38, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 77, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620, 78, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 79, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620, 80, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 81, "No Upgrade Gold Button") & "\n" & GetTranslated(620, 81, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 82, "No Upgrade Elixir Button") & "\n" & GetTranslated(620, 83, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN & "." & @SEC
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
			If $RequestScreenshotHD = 1 Then
				$hBitmap_Scaled = $hBitmap
			Else
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620, 84, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
			SetLog("Pushbullet/Telegram: Screenshot sent!", $COLOR_GREEN)
			$RequestScreenshot = 0
			$RequestScreenshotHD = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "DeleteAllMessages"
			_DeletePushOfPushBullet()
			SetLog("PushBullet/Telegram: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPBPushesNow = False ; reset value
		Case "CampFull"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $ichkAlertPBCampFull = 1 Then
				If $ichkAlertPBCampFullTest = 0 Then
					_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620, 85, "Your Army Camps are now Full"))
					$ichkAlertPBCampFullTest = 1
				EndIf
			EndIf
		Case "CurrentSearchCount"
			If $PushBulletEnabled = 1 Then
				If mod($searchcount,$SearchNotifyCountTXT) = 0 And isarray($SearchNotifyCountMsgIden) Then
					_DeleteMessageOfPushBullet($SearchNotifyCountMsgIden[0]) ;Delete old searching messages
				EndIf
				Local $Time = @HOUR & ":" & @MIN & ":" & @SEC
				$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
				$access_token = $PushBulletToken
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "note", "body": "' & $Time &" - " & $iOrigPushBullet & " - Searching - [S]"& _NumberFormat($SearchCount) & '"}'
				$oHTTP.Send($pPush)
				$Result = $oHTTP.ResponseText
				$SearchNotifyCountMsgIden = _StringBetween($Result, '"iden":"', '"', "", False) ;store pushbullet IDEN so the msg can be deleted later
				;SetLog("Pushbullet IDEN = " & $SearchNotifyCountMsgIden[0]) ;debugging purposes
			ElseIf $TelegramEnabled = 1 Then
				Local $Time = @HOUR & ":" & @MIN & ":" & @SEC
				_PushToPushBullet($Time &" - " & $iOrigPushBullet & " - Searching - [S]"& _NumberFormat($SearchCount))
			EndIf
		Case "AttackCountStats" ;Send stats every xxx attacks
				Local $Time = @HOUR & ":" & @MIN & ":" & @SEC
				Local $time2 = _TicksToTime(Int(TimerDiff($sTimer) + $iTimePassed), $hour, $min, $sec)
				Local $tempruntime = StringFormat("%02i:%02i:%02i", $hour, $min, $sec)
				_PushToPushBullet($Time &" - " & $iOrigPushBullet & " - Stats Report" & "\nStart @ "& $StartTime & "\n[G]" & _NumberFormat(round($iGoldStart/1000000,2)) & "m [E]" & _NumberFormat(round($iElixirStart/1000000,2)) & "m [D]" & _NumberFormat(round($iDarkStart/1000,1)) & "k [T]" & $iTrophyStart & "\n\nCurrent @ " & $Time & "\n[G]" & _NumberFormat(round($iGoldCurrent/1000000,2)) & "m [E]" & _NumberFormat(round($iElixirCurrent/1000000,2)) & "m [D]" & _NumberFormat(round($iDarkCurrent/1000,1)) & "k [T]" & $iTrophyCurrent & "\n\nHourly Stats: (Runtime "& $tempruntime & ")\n[G]"& _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "k [E]" & _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "k [D]" & Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000) & " [T]" & _NumberFormat(Round($iTrophyTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & "\n\nGems: " & $iGemAmount & ", Free Builders: " & $iFreeBuilderCount & "\n[Walls Upgraded] G: " & $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\nAttacked: " & GUICtrlRead($lblresultvillagesattacked) & "/" & GUICtrlRead($lblresultvillagesskipped) & ", Army " &$CurCamp & "/" & $TotalCamp)
		Case "CheckBuilderIdle"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $ichkAlertBuilderIdle = 1 Then
				Local $iAvailBldr = $iFreeBuilderCount - $iSaveWallBldr
				If $iAvailBldr > 0 Then
					If $iReportIdleBuilder <> $iAvailBldr Then
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(18, 132, "You have") & " " & $iAvailBldr & GetTranslated(18, 133, " builder(s) idle."))
						SetLog("Pushbullet/Telegram: You have " & $iAvailBldr & " builder(s) idle.", $COLOR_GREEN)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		; TheRevenor
		Case "BuilderInfo"
			Click(0, 0, 5)
			Click(274, 8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN & "." & @SEC
			_CaptureRegion(233, 74, 435, 240)
				Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
				_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
				_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Buider Information" & "\n" & $Screnshotfilename)
				SetLog("Pushbullet/Telegram: Builder Information sent!", $COLOR_GREEN)
				$RequestBuilderInfo = 0
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg2) Then Return
					Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
				If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
				Click(0, 0, 5)
		Case "ShieldInfo"
			Click(0, 0, 5)
			Click(435, 8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN & "." & @SEC
			_CaptureRegion(200, 165, 660, 568)
				Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
				_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
				_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
				SetLog("Pushbullet/Telegram: Shield Information sent!", $COLOR_GREEN)
				$RequestShieldInfo = 0
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg2) Then Return
					Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
					If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
					Click(0, 0, 5)
	EndSwitch
EndFunc   ;==>PushMsgToPushBullet

Func _DeleteOldPushesOfPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Or $ichkDeleteOldPBPushes = 0 Then Return
	;local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False) ; limit to 48h read push, antiban purpose
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $findstr = StringRegExp($Result, ',"created":')
	Local $msgdeleted = 0
	If $findstr = 1 Then
		Local $body = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		Local $created = _StringBetween($Result, '"created":', ',', "", False)
		If IsArray($body) And IsArray($iden) And IsArray($created) Then
			For $x = 0 To UBound($created) - 1
				If $iden <> "" And $created <> "" Then
					Local $hdif = _DateDiff('h', _GetDateFromUnix($created[$x]), $timeUTC)
					If $hdif >= $icmbHoursPushBullet Then
							setlog("Pushbullet, deleted message: (+" & $hdif & "h)" & $body[$x] )
						$msgdeleted += 1
						_DeleteMessageOfPushBullet($iden[$x])
						;else
						;	setlog("Pushbullet, skipped message: (+" & $hdif & "h)" & $body[$x] )
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		setlog("Pushbullet: removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ", $COLOR_GREEN)
		;_PushToPushBullet($iOrigPushBullet & " | removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ")
	EndIf
EndFunc   ;==>_DeleteOldPushesOfPushBullet
