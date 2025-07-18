#Requires AutoHotkey v2.0.0
#SingleInstance Force

#Include ScriptLib\cLogging.ahk
#Include ScriptLib\cSettings.ahk
#Include Gui\UpdatingGUI.ahk

/** @type {cLog} */
Out := cLog(A_ScriptDir "\Secondaries.log", true, 3, false)

S.initSettings()

Dialog := UpdatingGUI()
Dialog.Show()
closedScript := false
If (WinExist("WW2 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")) {
    WinClose("WW2 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")
    Out.I("Closed main script")
    closedScript := true
}

Try {
    If (FileExist("Install.zip")) {
        FileDelete("Install.zip")
        Out.I("Removed old Install.zip")
    }
    Download("https://github.com/nobodyscripts/wizardswheel2script/archive/refs/heads/main.zip", "Install.zip")
} Catch Error As uperr {
    Dialog.Hide()
    MsgBox("Error occured during update download:`r`n" uperr.Message)
    Out.E("Install.zip download failed with error.")
    Out.E(uperr)
    ExitApp()
}
If (!FileExist("Install.zip")) {
    Dialog.Hide()
    Out.I("Install.zip failed to download.")
    MsgBox("Error: Zip failed to download.")
    ExitApp()
}
Try {
    Out.I("Install.zip downloaded. Unpacking.")
    DirCopy("Install.zip", A_ScriptDir, 1)
    DirCopy(A_ScriptDir "\wizardswheel2script-main", A_ScriptDir, 2)
    DirDelete(A_ScriptDir "\wizardswheel2script-main", 1)
    FileDelete(A_ScriptDir "\Install.zip")
} Catch Error As unpackerr {
    Dialog.Hide()
    MsgBox("Error occured during update:`r`n" unpackerr.Message " " unpackerr.Extra)
    Out.E("Update failed to extract with error.")
    Out.E(unpackerr)
    ExitApp()
}
Dialog.Hide()
MsgBox("WW2 Script Update Completed.")
If (closedScript) {
    Run("WizardsWheel2.ahk")
}
ExitApp()