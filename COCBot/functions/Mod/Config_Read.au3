;
; MOD Config - Save Data
;


		; by AwesomeGamer
		$iChkDontRemove = IniRead($config, "troop", "DontRemove", "0")

		; SmartZap Settings - Added by LunaEclipse
		$ichkSmartZap = IniRead($config, "SmartZap", "UseSmartZap", "1")
		$ichkSmartZapDB = IniRead($config, "SmartZap", "ZapDBOnly", "1")
		$ichkSmartZapSaveHeroes = IniRead($config, "SmartZap", "THSnipeSaveHeroes", "1")
		$itxtMinDE = IniRead($config, "SmartZap", "MinDE", "300")

		; No League Search
		$iChkNoLeague[$DB] = IniRead($config, "search", "DBNoLeague", "0")
		$iChkNoLeague[$LB] = IniRead($config, "search", "ABNoLeague", "0")

		 ; CSV Deployment Speed Mod
		IniReadS($isldSelectedCSVSpeed[$DB], $config, "attack", "CSVSpeedDB", 3)
		IniReadS($isldSelectedCSVSpeed[$LB], $config, "attack", "CSVSpeedAB", 3)