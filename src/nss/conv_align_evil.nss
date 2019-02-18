//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-07-2019
//:://////////////////////////////////////////////
#include "x3_inc_string"
void main()
{
    //  Shift PC to Alignment Evil
    object oPC = GetPCSpeaker();
    string sMsg = StringToRGBString("You shifted to a Evil alignment.", STRING_COLOR_ROSE);
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 100, FALSE);
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}
