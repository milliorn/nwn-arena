//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 01-25-2019
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "inc_mod_def"

void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();

    //  Set the Gold Piece value in the items Description
    PrintGPValue(oItem);

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }
}
