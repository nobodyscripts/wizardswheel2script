#Requires AutoHotkey v2.0

fEventItemReset() {
    socketcount := 0
    itemcount := 0
    starttime := A_Now
    Log("Started")
    loop {
        Sleep(300)

        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 34) ; Close inv
            Sleep(150)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 101) ; Close inv
            Sleep(150)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 101) ; Close inv
            Sleep(650)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1238, 31, 51) ; Options
            Sleep(550)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(946, 381, 51) ; Load Save
            Sleep(550)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(624, 525, 51) ; Play
            Sleep(1750)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(915, 231, 51) ; Igloo
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            ;fSlowClick(535, 250, 51) ; Buy row 1 l
            ;fSlowClick(960, 250, 51) ; Buy row 1 r
            ;fSlowClick(551, 343, 51) ; Buy row 2 l
            ;fSlowClick(960, 343, 51) ; Buy row 2 r
            fSlowClick(551, 431, 51) ; Buy row 3 l
            ;fSlowClick(960, 431, 51) ; Buy row 3 r
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1014, 57, 51) ; Close shop
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1052, 624, 51) ; Open inv
            Sleep(400)
        }
        itemcount++
        ItemFarmTooltop(itemcount, socketcount, starttime)
        if (WinActive(WW2WindowTitle)) {
            ; Weapon slot
            ;colourSocket := PixelGetColor(WinRelPosW(244), WinRelPosH(279))
            ; Armour slot
            /*             colourSocket := PixelGetColor(WinRelPosW(525), WinRelPosH(270))
            if (colourSocket = "0xFCAE35") {
            Log("Found Socket")
            socketcount++
            ItemFarmTooltop(itemcount, socketcount, starttime) */
            ;fSlowClick(350, 275, 51) ; Open weapon item
            fSlowClick(630, 275, 51) ; Open armour item
            Sleep(72)
            MouseMove(WinRelPosW(1050), WinRelPosH(624))
            Sleep(1000)

            try {
                found := ImageSearch(&OutX, &OutY,
                    WinRelPosW(190), WinRelPosH(120),
                    WinRelPosW(916), WinRelPosH(491), A_ScriptDir "\Images\QualityPerfect.png")
                If (found) {
                    Log("Found Target")
                    return
                }
                found := ImageSearch(&OutX, &OutY,
                    WinRelPosW(190), WinRelPosH(120),
                    WinRelPosW(916), WinRelPosH(491), A_ScriptDir "\Images\Quality9.png")
                If (found) {
                    Log("Found Target")
                    return
                }

            } catch as exc {
                Log("Error searc failed - " exc.Message)
                MsgBox("Could not conduct the search due to the following error:`n"
                    exc.Message)
            }
            Sleep(50)
            if (WinActive(WW2WindowTitle)) {
                fSlowClick(1015, 56, 72) ; Close item
            }
            Sleep(500)
            ;}
        }
    }
}


ItemFarmTooltop(itemcount, socketcount, starttime) {
    timediff := DateDiff(A_Now, starttime, "Seconds")
    if (itemcount > 0 && socketcount > 0) {
        ratio := itemcount / socketcount
    } else {
        ratio := 0
    }
    ToolTip("Found " itemcount
        " Items`n" socketcount " of which sockets`n"
        ratio " Ratio of socketed`nSeconds Taken " timediff,
        WinRelPosW(20), H / 2 - WinRelPosH(30), 7)
}