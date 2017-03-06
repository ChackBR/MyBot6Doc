#NoTrayIcon

#AutoIt3Wrapper_Icon=DebugTools\virus.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StringConstants.au3>

Global $Step1, $Step2, $Step3, $Step4
Global $tempFolder = @ScriptDir & "\COCBot\MOD_DocOC\Temp_Debug\"
Global $userMessage = $tempFolder & "\COCBot\MOD_DocOC\Report_Message.txt"
Global $p7zip = @ScriptDir & "\COCBot\MOD_DocOC\DebugTools\7za.exe"
Global $pcURL = @ScriptDir & "\lib\curl\curl.exe"
Global $pcURL_log = @ScriptDir & "\COCBot\MOD_DocOC\cURL_report.txt"
Global $pData = @ScriptDir & "\COCBot\MOD_DocOC\Debug_data.7z"

Local Const $sFont = "Comic Sans Ms"

DirCreate($tempFolder)
Screen1()

Func Screen1()

	$Step1 = GUICreate("Step 1/4 - Welcome !!!", 451, 396, 252, 201)
	GUISetBkColor(16777215)

	GUICtrlCreateLabel("Welcome to the MyBot.run bug reporter", 25, 30, 403, 30)
	GUICtrlSetFont(-1, 16, 400, 0, $sFont)
	GUICtrlCreateLabel("This assistant will help you to create a useful package containing", 15, 80, 421, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("all needed debug informations by devs.", 100, 100, 254, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	$btnStart = GUICtrlCreateButton("Start !!!", 155, 200, 141, 136)
	GUICtrlSetFont(-1, 20, 400, 0, $sFont)
	GUISetState(@SW_SHOW)

	While 1
		$NMSG = GUIGetMsg()
		Switch $NMSG
			Case $GUI_EVENT_CLOSE
				DirRemove($tempFolder, 1)
				Exit
			Case $btnStart
				Screen2()
		EndSwitch
	WEnd

EndFunc   ;==>Screen1

Func Screen2()

	GUIDelete($Step1)

	$Step2 = GUICreate("Step 2/4 - Problem description", 451, 396, 252, 201)
	GUISetBkColor(16777215)

	GUICtrlCreateLabel("Please, first, describe precisely the bug happened to you...", 35, 15, 380, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	$message = GUICtrlCreateEdit("", 15, 45, 421, 261, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
	$btnNext = GUICtrlCreateButton("Next >", 135, 325, 181, 56)
	GUICtrlSetFont(-1, 20, 400, 0, $sFont)
	GUISetState(@SW_SHOW)

	While 1
		$NMSG = GUIGetMsg()
		Switch $NMSG
			Case $GUI_EVENT_CLOSE
				DirRemove($tempFolder, 1)
				Exit
			Case $btnNext
				$res = GUICtrlRead($message)
				If $res = "" Then
					FileWrite($userMessage, "AUTO REPORT: Nothing reported by user")
				Else
					FileWrite($userMessage, $res)
				EndIf
				Screen3()
		EndSwitch
	WEnd

EndFunc   ;==>Screen2

Func Screen3()

	GUIDelete($Step2)

	$Step3 = GUICreate("Step 3/4 - Zipping needed files pending... Wait...", 451, 396, 252, 201)
	GUISetBkColor(16777215)

	GUICtrlCreateLabel("Please wait while the reporter zip needed", 20, 30, 418, 28)
	GUICtrlSetFont(-1, 16, 400, 0, $sFont)
	GUICtrlCreateLabel("files...", 190, 60, 67, 28)
	GUICtrlSetFont(-1, 16, 400, 0, $sFont)
	GUICtrlCreateLabel("That should not take a long time...", 115, 175, 220, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("That window will be closed automatically when finished...", 35, 240, 377, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUISetState(@SW_SHOW)

	If FileExists($pData) Then FileDelete("Debug_data.7z")
	DirCopy(@ScriptDir & "\Profiles\", $tempFolder & "\Profiles\", 1)
	DirCopy(@ScriptDir & "\lib\ImgLocDebugData\", $tempFolder & "\ImgLocDebugData\", 1)
	FileCopy(@ScriptDir & "MyBot.run.au3", $tempFolder, 1)
	ShellExecuteWait($p7zip, "a -t7z -mx9 " & $pData & " " & $tempFolder, "", "open")
	DirRemove($tempFolder, 1)
	Screen4()

	While 1
		$NMSG = GUIGetMsg()
		Switch $NMSG
			Case $GUI_EVENT_CLOSE
				DirRemove($tempFolder, 1)
				Exit
		EndSwitch
	WEnd

EndFunc   ;==>Screen3

Func Screen4()

	GUIDelete($Step3)

	$Step4 = GUICreate("Step 4/4 - Uploading and final report", 451, 396, 252, 201)
	GUISetBkColor(16777215)

	GUICtrlCreateLabel("We have almost finished...", 95, 30, 269, 28)
	GUICtrlSetFont(-1, 16, 400, 0, $sFont)
	GUICtrlCreateLabel("Now, all files are ready. By clicking on Upload, we will upload", 30, 90, 395, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("files and after, give you a download link.", 95, 115, 259, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("Then, click Finish. We will open bug report page on web browser", 15, 160, 416, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("There, create a thread, and write on it given download link.", 30, 185, 382, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	GUICtrlCreateLabel("Many thanks for taking the time to create that report :-) !!!", 40, 285, 370, 19)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)

	$btnUpload = GUICtrlCreateButton("Upload...", 15, 225, 80, 30)
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)
	$URL = GUICtrlCreateInput("After uploading, download link will appear there...", 100, 230, 331, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_READONLY))
	GUICtrlSetFont(-1, 10, 400, 0, $sFont)

	$btnFinish = GUICtrlCreateButton("Finish !!!", 135, 325, 181, 56)
	GUICtrlSetFont(-1, 20, 400, 0, $sFont)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUISetState(@SW_SHOW)

	While 1
		$NMSG = GUIGetMsg()
		Switch $NMSG
			Case $GUI_EVENT_CLOSE
				DirRemove($tempFolder, 1)
				Exit
			Case $btnUpload
				If FileExists($pData) Then

					$fileSize = FileGetSize($pData)
					If $fileSize > 1048576 Then
						GUICtrlSetData($URL, "Upload pending, please wait... File size: " & Round($fileSize / 1048576, 2) & "MB")
					Else
						GUICtrlSetData($URL, "Upload pending, please wait... File size: " & Round($fileSize / 1024, 2) & "KB")
					EndIf

					ShellExecuteWait($pcURL, "https://dropfile.to/getuploadserver -o " & $pcURL_log, "", "open", @SW_HIDE)
					$uploadURL = FileReadLine($pcURL_log)
					ShellExecuteWait($pcURL, "-F " & '"' & "file=@" & $pData & '"' & " " & $uploadURL & "/upload -o " & $pcURL_log, "", "open", @SW_HIDE)
					$res = FileReadLine($pcURL_log)
					If StringInStr($res, ":0", $STR_CASESENSE) Then
						$res2 = StringReplace($res, "\", "")
						Local $res3 = StringSplit($res2, '"', $STR_NOCOUNT)
						GUICtrlSetData($URL, $res3[5])
						GUICtrlSetState($btnFinish, $GUI_ENABLE)
						FileDelete($pcURL_log)
						FileDelete($pData)
					Else
						GUICtrlSetData($URL, 'Error: File: "Debug_data", upload it yourself.')
					EndIf

				Else
					GUICtrlSetData($URL, "Error: File not exists, please retry")
				EndIf

			Case $btnFinish
				GUIDelete($Step4)
				ShellExecute("https://mybot.run/forums/index.php?/topic/27601-mybotrun-dococ-v351-dec-sc-update/&page=3#replyForm")
				Exit
		EndSwitch
	WEnd

EndFunc   ;==>Screen4
