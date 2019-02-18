//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////
#include "inc_mod_def"
#include "x2_inc_switches"
#include "x2_inc_itemprop"

void main()
{
    object oItem = GetModuleItemLost(),
           oPC = GetModuleItemLostBy(),
           oArea = GetArea(oPC);

    IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);

    PrintGPValue(oItem);

    if (GetLocalInt(oArea, "NO_PVP") == TRUE)
    {
        CheckForTraps(oArea, oPC);
    }

    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
    }
}
