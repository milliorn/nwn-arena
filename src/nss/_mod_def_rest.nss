//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: January 26, 2019
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "x3_inc_string"

void main()
{
    object oPC = GetLastPCRested();
    string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);

    AssignCommand(oPC,ClearAllActions(TRUE));

    switch(GetLastRestEventType())
    {
        case REST_EVENTTYPE_REST_STARTED:
        {
            FadeToBlack(oPC, FADE_SPEED_SLOWEST);
            break;
        }
        case REST_EVENTTYPE_REST_CANCELLED:
        {
            FadeFromBlack(oPC, FADE_SPEED_SLOWEST);
            FloatingTextStringOnCreature(sSave, oPC, FALSE);
            ExportSingleCharacter(oPC);
            ExecuteScript("ws_saveall_sub", oPC);
            break;
        }
        case REST_EVENTTYPE_REST_FINISHED:
        {
            FadeFromBlack(oPC, FADE_SPEED_SLOWEST);
            FloatingTextStringOnCreature(sSave, oPC, FALSE);
            ExportSingleCharacter(oPC);
            ExecuteScript("ws_saveall_sub", oPC);
            break;
        }
    }
}
