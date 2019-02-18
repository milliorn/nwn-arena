//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-07-2019
//:://////////////////////////////////////////////
#include "x3_inc_string"
void main()
{
    //  Shift the PC to Alignment Good
    object oPC = GetPCSpeaker();
    string sMsg = StringToRGBString("You shifted to a Good alignment.", STRING_COLOR_ROSE);
    AdjustAlignment(oPC, ALIGNMENT_GOOD, 100, FALSE);
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}
