//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 2019-01-22
//:://////////////////////////////////////////////
#include "nwnx_chat"
#include "x3_inc_string"

int GetIsPlayer(object oTarget)
{
    if (GetIsPC(oTarget) == TRUE)
    {
        return TRUE;
    }

    else if (GetIsDM(oTarget) == TRUE)
    {
        return TRUE;
    }

    else return FALSE;
}

void main()
{
    if (NWNX_Chat_GetChannel() == 5) return;
    if (GetIsPlayer(OBJECT_SELF) == FALSE) return;
    if (NWNX_Chat_GetSender() == OBJECT_INVALID) return;

    object oNameSender = NWNX_Chat_GetSender();
    string sNameSender = GetName(oNameSender);

    object oNameReceiver = NWNX_Chat_GetTarget();
    string sNameReceiver = GetName(oNameReceiver);

    int iChannel = NWNX_Chat_GetChannel();

    string sChannel;
    string sChat;

    switch (iChannel)
    {
        case 1: sChannel = "PC-Talk"; break;
        case 2: sChannel = "PC-Shout"; break;
        case 3: sChannel = "PC-Whisper"; break;
        case 4: sChannel = "PC-Tell"; break;
        case 5: sChannel = "Server-Message"; break;
        case 6: sChannel = "PC-Party"; break;
        case 14: sChannel = "PC-DM"; break;
        case 17: sChannel = "DM-Talk"; break;
        case 18: sChannel = "DM-Shout"; break;
        case 19: sChannel = "DM-Whisper"; break;
        case 20: sChannel = "DM-Tell"; break;
        case 22: sChannel = "DM-Party"; break;
        case 30: sChannel = "DM-DM"; break;
        default: NWNX_Chat_SkipMessage();break;
    }

    string sMessage = NWNX_Chat_GetMessage();

    sChat = " SENDER: "   + sNameSender +
            " RECEIVER: " + sNameReceiver +
            " CHANNEL: "  + sChannel +
            " MESSAGE: "  + sMessage;

    WriteTimestampedLogEntry(sChat);

    sChat = StringToRGBString("SENDER: ", STRING_COLOR_GREEN)  + sNameSender +
            StringToRGBString(" RECEIVER: ", STRING_COLOR_GREEN) + sNameReceiver +
            StringToRGBString(" CHANNEL: ", STRING_COLOR_GREEN)  + sChannel +
            StringToRGBString(" MESSAGE: ", STRING_COLOR_GREEN)  + StringToRGBString(sMessage, STRING_COLOR_WHITE);

    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (GetPCPublicCDKey(oPC) == "QR4JFL9A")
        {
            NWNX_Chat_SendMessage(5, sChat, OBJECT_SELF, oPC);
        }

        oPC = GetNextPC();
    }
}
