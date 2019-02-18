//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 2019-01-22
//:://////////////////////////////////////////////
#include "inc_mod_def"
#include "nwnx_webhook"
#include "nwnx_player"
#include "x3_inc_string"

void main()
{
    object  oPC     = GetExitingObject(),
            oModule = GetModule();

    int     nHP     = GetCurrentHitPoints(oPC),
            nPCT    = (nHP * 100) / GetMaxHitPoints(oPC),
            iPCTotal = 0;

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


    //  Log the client exiting the server
    WriteTimestampedLogEntry(sLogin + " has logged off.");

    // Count players left online
    object oPlayer = GetFirstPC();
    while (oPlayer != OBJECT_INVALID)
    {
        iPCTotal++;
        oPlayer = GetNextPC();
    }

    iPCTotal = iPCTotal--;

    //  Send a message to Discord Channel of the client logging out
    string sOnline = " with " + IntToString(iPCTotal) + " players online.";
    string sWebhookUrl = "/api/webhooks/472605187761242152/wqmbKttRf4VdSwhbg6C9fhy2GlQdtX8zCqohWwJesbyq3ImNx_s2AUpr0-E_p8m8VQo6/slack";
    string sPCName = "Player: " + sName + " - Account: " + sAccount + " - BIC: " + sBIC;
    string sMessage = sPCName + " - logged out" + sOnline;

    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", sWebhookUrl , sMessage , "Server");

    //  If we are a DM we break the script
    if (GetIsDM(oPC))
    {
        SendMessageToAllDMs(StringToRGBString("DM Logout: ", STRING_COLOR_ROSE) +
        " Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
        " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
        " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE) +
        " IP: " + StringToRGBString(sIP, STRING_COLOR_WHITE));
        return;
    }
    // Less than 100% Hitpoints, Consider a Death Log
    if (nPCT < 100 && GetIsInCombat(oPC))
    {
        object oAttacker = GetLastHostileActor(oPC);

        effect eDam = EffectDamage(nHP + 20, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);

        string sMsg = StringToRGBString(GetName(oAttacker, TRUE) + " autokilled " + GetName(oPC) +
        " for possible deathlog while in combat.", STRING_COLOR_RED);

        SpeakString(sMsg, TALKVOLUME_SHOUT);
        AssignCommand(oAttacker, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
    }

    //  Notify Server on Shout of a Logout.
    SpeakString("LOGOUT -" +
                " Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
                " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
                " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE) +
                " BIC: " + StringToRGBString(sBIC, STRING_COLOR_WHITE), TALKVOLUME_SHOUT);
}
