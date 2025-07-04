﻿#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 8
#SingleInstance Force
#Warn All, StdOut

; ------------------- Readme -------------------
/**
 * See Readme.md for readme
 * Run this file to load script, run this to activate gui and hotkeys
 */

/** @type {cLog} */
Global Out := cLog(A_ScriptDir "\WizardsWheel2.log", true, 3, false)

/** @type {cToolTip} */
Global gToolTip := cToolTip()

/** Update checking class, checks version against github in a low bandwidth approach
 * @type {UpdateChecker} */
Global Updater := UpdateChecker()

Updater.ZipDownload := "https://github.com/nobodyscripts/wizardswheel2script/archive/refs/heads/main.zip"
Updater.ZipFolder := "wizardswheel2script-main"
Updater.RemoteJson := "https://raw.githubusercontent.com/nobodyscripts/wizardswheel2script/main/Version.json"
Updater.ScriptName := "WW2 NobodyScript"

/** @type {cGameWindow} */
Global Window := cGameWindow("Wizard's Wheel 2 ahk_class UnityWndClass ahk_exe Wizard's Wheel 2.exe", 1278, 664)

#Include Gui\MainGUI.ahk

#Include ScriptLib\cGameWindow.ahk
#Include ScriptLib\cLogging.ahk
#Include ScriptLib\cSettings.ahk
#Include ScriptLib\cUpdateChecker.ahk
#Include ScriptLib\cToolTip.ahk

#Include Lib\cHotkeysInitScript.ahk
#Include Lib\Misc.ahk

#Include Modules\ActiveBattle.ahk
#Include Modules\Dimension.ahk
#Include Modules\EventItemReset.ahk
#Include Modules\IronChef.ahk
#Include Modules\ItemEnchanter.ahk
#Include Modules\Village.ahk

SendMode("Input") ; Support for vm
; Can be Input, Event, Play, InputThenPlay if Input doesn't work for you

DetectHiddenWindows(true)
Persistent() ; Prevent the script from exiting automatically.

If (!S.initSettings()) {
    MsgBox(
        "Script failed to load settings, script closing, try restarting.")
    ExitApp()
}

Out.I("Script loaded")
RunGui()
; Setup script hotkeys
CreateScriptHotkeys()

; ------------------- Script Triggers -------------------

CreateScriptHotkeys() {
    Hotkey("*" Scriptkeys.GetHotkey("AutoClicker"), fAutoClicker)
    HotIfWinActive(Window.Title)
    Hotkey("*" Scriptkeys.GetHotkey("Exit"), fExitapp)
    Hotkey("*" Scriptkeys.GetHotkey("Reload"), fReload)
    Hotkey("*" Scriptkeys.GetHotkey("GameResize"), fGameResize)
    Hotkey("*" Scriptkeys.GetHotkey("ActiveBattle"), fActiveBattle)
    Hotkey("*" Scriptkeys.GetHotkey("EventItemReset"), fEventItemReset)
    Hotkey("*" Scriptkeys.GetHotkey("IronChef"), fIronChef)
    Hotkey("*" Scriptkeys.GetHotkey("ItemEnchant"), ItemEnchanterElevated)
    Hotkey("*" Scriptkeys.GetHotkey("DimensionPushing"), fDimensionPushing)
}

fReload(*) {
    Reload()
}
fExitapp(*) {
    Exitapp()
}

Global ClipBoardInUseBlock := false
#HotIf WinActive(Window.Title) and MouseIsOver(Window.Title) and S.Get("DebugAll")
    ~LButton:: {
        screenx := screeny := windowx := windowy := clientx := clienty := 0
        CoordMode("Mouse", "Screen")
        MouseGetPos(&screenx, &screeny)
        CoordMode("Mouse", "Window")
        MouseGetPos(&windowx, &windowy)
        CoordMode("Mouse", "Client")
        MouseGetPos(&clientx, &clienty)

        Out.D(
            ;"Screen:`t" screenx ", " screeny "`n"
            ;"Window:`t" windowx ", " windowy "`n"
            "Mouse1 click Client: " clientx ", " clienty " Color: #" SubStr(PixelGetColor(clientx, clienty), 3)
            " - pos-1: " clientx - 1 ", " clienty - 1 " Color: #" SubStr(PixelGetColor(clientx - 1, clienty - 1), 3
            )
            ;"Current zone colour: " Points.ZoneSample.GetColour()
        )
        Out.D("cPoint(" clientx ", " clienty ").IsColour(" PixelGetColor(clientx, clienty) ")")
        ;A_Clipboard := "cPoint(" clientx ", " clienty ")"
    }

    ~WheelDown:: {
        Out.D("Wheel down")
    }

    ~WheelUp:: {
        Out.D("Wheel up")
    }
#HotIf

MouseIsOver(WinTitle) {
    MouseGetPos , , &Win
    Return WinExist(WinTitle " ahk_id " Win)
}

fAutoClicker(*) {
    Static on11 := false
    Out.I("F11: Pressed")
    ;Window.Exist()
    If (on11 := !on11) {
        While (on11) {
            MouseClick("left", , , , , "D")
            Sleep(17)
            ; Must be higher than 16.67 which is a single frame of 60fps
            MouseClick("left", , , , , "U")
            Sleep(17)
        }
    } Else {
        ; Do one click when killing, so that we reset the click state
        MouseClick("left", , , , , "D")
        Sleep(17)
        MouseClick("left", , , , , "U")
        Sleep(17)
        Reload()
    }
}

fGameResize(*) {
    Out.I("F12: Pressed")
    If (!Window.Exist()) {
        Return
    }
    If (WinGetMinMax(Window.Title) != 0) {
        WinRestore(Window.Title)
    }
    ; Changes size of client window for windows 11
    WinMove(, , 1294, 703, Window.Title)
    WinWait(Window.Title)
    Window.Exist()
    If (Window.W != "1278" || Window.H != "664") {
        Out.I(
            "Resized window to 1294*703 client size should be 1278*664, found: " Window
            .W "*" Window.H)
    }
}