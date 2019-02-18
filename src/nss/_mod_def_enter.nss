//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 2019-01-22
//:://////////////////////////////////////////////
#include "inc_mod_def"
#include "nwnx_webhook"
#include "nwnx_admin"
#include "nwnx_player"
#include "x3_inc_string"

void main()
{
    object  oPC = GetEnteringObject();

    string sName = GetName(oPC),
           sAccount = GetPCPlayerName(oPC),
           sCDKEY = GetPCPublicCDKey(oPC, TRUE),
           sIP = GetPCIPAddress(oPC),
           sBIC = NWNX_Player_GetBicFileName(oPC);

    string sLogin = "Player: " + sName +
           " - Account: " + sAccount +
           " - ID: " + sCDKEY +
           " - IP: " + sIP +
           " - BIC: " + sBIC;

    //  Verify PC Name isn't banned for being offensive
    if (NameChecker(oPC) == TRUE)
    {
        //  Write to Server log
        WriteTimestampedLogEntry(sLogin);

        //  Send message to online DM's
        SendMessageToAllDMs(StringToRGBString("Prohibited Name: ", STRING_COLOR_RED) + sLogin);

        //  Disable GUI with a warning message
        PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0 , "Offensive Names are Prohibited!");
        //  Delete .BIC file
        DelayCommand(6.0, NWNX_Administration_DeletePlayerCharacter(oPC, FALSE));
        return;
    }

    //  Document how many players are online and send a webhook
    int iPCTotal = 0;

    object oPlayer = GetFirstPC();
    while (oPlayer != OBJECT_INVALID)
    {
        iPCTotal++;
        oPlayer = GetNextPC();
    }

    //Send a message to Discord of the client logging in.
    string sOnline = " with " + IntToString(iPCTotal) + " players online.";
    string sWebhookUrl = "/api/webhooks/472605187761242152/wqmbKttRf4VdSwhbg6C9fhy2GlQdtX8zCqohWwJesbyq3ImNx_s2AUpr0-E_p8m8VQo6/slack";
    string sPCName = "Player: " + GetName(oPC) + " - Account: " + GetPCPlayerName(oPC);
    string sMessage = sPCName + " - logged in" + sOnline;
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", sWebhookUrl, sMessage , "Server");

    //  Load Server Journal Entries
    //AddJournalQuestEntry("", 1, oPC, TRUE, TRUE, FALSE);

    //  Check for duped items from the radial crafting menu
    PurifyAllItems(oPC, TRUE, TRUE);

    //  Run DM Verification code
    if (GetIsDM(oPC))
    {
        string sDMLogin = "Player: " + sName +
                        " - Account: " + sAccount +
                        " - ID: " + sCDKEY +
                        " - IP: " + sIP;

        if (sCDKEY == "QR4JFL9A" || //milliorn
            sCDKEY == "QRMXQ6GM")   //milliorn
        {
            SendMessageToAllDMs(StringToRGBString("DM Login -", STRING_COLOR_GREEN) +
            " Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
            " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
            " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE) +
            " IP: " + StringToRGBString(sIP, STRING_COLOR_WHITE));

            WriteTimestampedLogEntry("Verified DM Login: " + sDMLogin);
            return;
        }

        else
        {
            SendMessageToAllDMs(StringToRGBString("Illegal DM Login -", STRING_COLOR_RED) +
            " Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
            " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
            " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE) +
            " IP: " + StringToRGBString(sIP, STRING_COLOR_WHITE));

            WriteTimestampedLogEntry("Illegal DM login attempt: " + sDMLogin);
            BootPC(oPC);
            return;
        }
    }

    //  Redundant DM check to break the script if its a DM.
    if (GetIsDM(oPC)) return;

    //  Only show IP of login to DM channel
    SendMessageToAllDMs(GetPCIPAddress(oPC));
    WriteTimestampedLogEntry(sLogin);

    //  Check if new and do a new player strip down
    if (GetXP(oPC) == 0)
    {
        StripPC(oPC);
    }

    //  Notify Server on Shout of a Login.
    SpeakString("LOGIN -" +
                " Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
                " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
                " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE) +
                " BIC: " + StringToRGBString(sBIC, STRING_COLOR_WHITE), TALKVOLUME_SHOUT);

    //  If PC logs in make sure they start at the starting location regardless of location.
    if (GetLocation(oPC) != GetStartingLocation()) JumpToLocation(GetStartingLocation());

    //  Automated visual upon PC entering the module casted on the starting location.
    DelayCommand(1.9, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), GetStartingLocation()));
}
