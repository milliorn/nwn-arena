//:://////////////////////////////////////////////
//:: Created By: Milliorn
//:: Date: January 22nd, 2019
//:://////////////////////////////////////////////
#include "inc_mod_def"
#include "x2_inc_itemprop"
#include "x2_inc_switches"
#include "x3_inc_string"

void main()
{
    object  oPC = GetModuleItemAcquiredBy(),
            oFrom = GetModuleItemAcquiredFrom(),
            oItem = GetModuleItemAcquired();

    //  Set the Gold Piece value in the items Description
    PrintGPValue(oItem);

    //  Clear all Temp Item Properties so they don't become permanent
    IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);

    //  Identify the Acquired Item
    SetIdentified(oItem, TRUE);

    //  Remove stolen flags
    SetStolenFlag(oItem, FALSE);

    //  Fix Barter Exploit that clones items
    if (GetIsPC(oFrom) && GetIsPC(oPC))
    {
        string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);

        ExportSingleCharacter(oFrom);
        FloatingTextStringOnCreature(sSave, oFrom, FALSE);
        ExecuteScript("ws_saveall_sub", oFrom);

        ExportSingleCharacter(oPC);
        FloatingTextStringOnCreature(sSave, oPC, FALSE);
        ExecuteScript("ws_saveall_sub", oPC);
    }

     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }
}
