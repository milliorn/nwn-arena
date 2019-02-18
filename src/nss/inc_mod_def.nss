//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "x3_inc_string"

//  Check for Traps being set in NO PvP area
void CheckForTraps(object oArea, object oPC);

//  This is used to check prohibited names on PC names
//  This will need to be refactored to a Switch/Case if possible in the future
int NameChecker(object oPC);

// Print the GP Value of an item into the items Description field
void PrintGPValue(object oItem);

//  Display a message and destroy the duped item if detected
void PurifyItem(object oItem, object oPC, int nIsEntering);

//  Cycle through all items that can be crafted in the radial menu
void PurifyAllItems(object oPC, int nIsEntering = FALSE, int nDeleteTempVars = FALSE);

//  Random message in the PK string
string PVP_GetRandomShoutString();

//  Raises oPlayer from death, removing any negative effects and providing a visual effect.
void Raise(object oPlayer);

//  Used on newly created PC's to strip inventory and gold then assign default
//  inventory and gold
void StripPC(object oPC);

void CheckForTraps(object oArea, object oPC)
{
    object oTrap = GetNearestTrapToObject(oPC, FALSE);
    string sName = GetName(oPC),
           sAccount = GetPCPlayerName(oPC),
           sCDKEY = GetPCPublicCDKey(oPC, TRUE),
           sIP = GetPCIPAddress(oPC);

    if (GetIsObjectValid(oTrap) && GetTrapCreator(oTrap) == oPC)
    {
        ClearAllActions(FALSE);

        SetTrapActive(oTrap, FALSE);
        SetTrapDetectable(oTrap, FALSE);
        SetTrapDetectDC(oTrap, 0);
        SetTrapDisabled(oTrap);
        SetTrapDisarmable(oTrap, TRUE);
        SetTrapDisarmDC(oTrap, 0);
        SetTrapRecoverable(oTrap, TRUE);

        SpeakString(StringToRGBString("TRAP set in a NO PVP zone - ", STRING_COLOR_RED) +
        "Player: " + StringToRGBString(sName, STRING_COLOR_WHITE) +
        " Account: " + StringToRGBString(sAccount, STRING_COLOR_WHITE) +
        " ID: " + StringToRGBString(sCDKEY, STRING_COLOR_WHITE), TALKVOLUME_SHOUT);
    }
}

int NameChecker(object oPC)
{
    string sName = GetStringUpperCase(GetName(oPC));
    string sAccount = GetStringUpperCase(GetPCPlayerName(oPC));

    if (FindSubString(sName, "SERVER")      >= 0  ||
        FindSubString(sName, "IDIOT")       >= 0  ||
        FindSubString(sName, "WANKER")      >= 0  ||
        FindSubString(sName, "MASTURBAT")   >= 0  ||
        FindSubString(sName, "SODOM")       >= 0  ||
        FindSubString(sName, "PUSSY")       >= 0  ||
        FindSubString(sName, "RETARD")      >= 0  ||
        FindSubString(sName, "DILDO")       >= 0  ||
        FindSubString(sName, "DOUCHE")      >= 0  ||
        FindSubString(sName, "DUMBASS")     >= 0  ||
        FindSubString(sName, "PISS")        >= 0  ||
        FindSubString(sName, "NIGGER")      >= 0  ||
        FindSubString(sName, "WHORE")       >= 0  ||
        FindSubString(sName, "DICKH")       >= 0  ||
        FindSubString(sName, "CUNT")        >= 0  ||
        FindSubString(sName, "COCK")        >= 0  ||
        FindSubString(sName, "MOTHERFUCK")  >= 0  ||
        FindSubString(sName, "BITCH")       >= 0  ||
        FindSubString(sName, "FUCK")        >= 0  ||
        FindSubString(sName, "SHIT")        >= 0  ||
        FindSubString(sName, "ASSHOLE")     >= 0  ||
        FindSubString(sName, "FAGGOT")      >= 0  ||
        FindSubString(sAccount, "SERVER")      >= 0  ||
        FindSubString(sAccount, "PENIS")       >= 0  ||
        FindSubString(sAccount, "IDIOT")       >= 0  ||
        FindSubString(sAccount, "WANKER")      >= 0  ||
        FindSubString(sAccount, "MASTURBAT")   >= 0  ||
        FindSubString(sAccount, "SODOM")       >= 0  ||
        FindSubString(sAccount, "PUSSY")       >= 0  ||
        FindSubString(sAccount, "RETARD")      >= 0  ||
        FindSubString(sAccount, "DILDO")       >= 0  ||
        FindSubString(sAccount, "DOUCHE")      >= 0  ||
        FindSubString(sAccount, "DUMBASS")     >= 0  ||
        FindSubString(sAccount, "PISS")        >= 0  ||
        FindSubString(sAccount, "NIGGER")      >= 0  ||
        FindSubString(sAccount, "WHORE")       >= 0  ||
        FindSubString(sAccount, "DICKH")       >= 0  ||
        FindSubString(sAccount, "CUNT")        >= 0  ||
        FindSubString(sAccount, "COCK")        >= 0  ||
        FindSubString(sAccount, "MOTHERFUCK")  >= 0  ||
        FindSubString(sAccount, "BITCH")       >= 0  ||
        FindSubString(sAccount, "FUCK")        >= 0  ||
        FindSubString(sAccount, "SHIT")        >= 0  ||
        FindSubString(sAccount, "ASSH")        >= 0  ||
        FindSubString(sAccount, "FAGGOT")      >= 0)
    {
        return TRUE;
    }

    else
    {
        return FALSE;
    }
}

void PrintGPValue(object oItem)
{
    string sDescribe = GetDescription(oItem, TRUE, TRUE),
           sGoldValue = IntToString(GetGoldPieceValue(oItem));

    if (GetPlotFlag(oItem) == FALSE)
    {
        string sOutput = StringToRGBString("Gold Piece Value: ", "770") +
        StringToRGBString(sGoldValue, STRING_COLOR_WHITE);
        sOutput += "\n";
        sOutput += "\n";
        sOutput += sDescribe;
        SetDescription(oItem, sOutput, TRUE);
    }
}

void PurifyItem(object oItem, object oPC, int nIsEntering)
{
    string sDupeReport;
    if (GetLocalInt(oItem, "CRAFT_DUPLICATE"))
    {
        SendMessageToPC(oPC, StringToRGBString("Destroyed: ", STRING_COLOR_RED) +
        StringToRGBString(GetName(oItem), STRING_COLOR_WHITE) +
        StringToRGBString(": Crafting Duplicate.", STRING_COLOR_ROSE));

        //Note from Loki: The following block of code checks if
        //the function is being run as part of an "OnEnter"
        //script (as indicated by the function argument "nIsEntering".
        //If so, we note this in the log file.  Otherwise we send a
        //slightly shorter message.

        if (nIsEntering)
        sDupeReport = "Crafting Duplicate: '" + GetName(oItem) + "' detected on entering player: "+GetName(oPC)+".  Item destroyed.";
        else sDupeReport="Crafting Duplicate: '" + GetName(oItem) + "' detected on player: " + GetName(oPC) + ".  Item Destroyed.";
        DestroyObject(oItem);
        WriteTimestampedLogEntry(sDupeReport);
        SendMessageToAllDMs(sDupeReport);
    }
}

void PurifyAllItems(object oPC, int nIsEntering = FALSE, int nDeleteTempVars = FALSE)
{
    PurifyItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC),oPC,nIsEntering);
    PurifyItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC),oPC,nIsEntering);
    PurifyItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC),oPC,nIsEntering);
    PurifyItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC),oPC,nIsEntering);

    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        PurifyItem(oItem,oPC,TRUE);
        oItem = GetNextItemInInventory(oPC);
    }

    if (nDeleteTempVars == FALSE) return;

    DeleteLocalInt(oPC, "CRAFT_DUPLICATE");
}

string PVP_GetRandomShoutString()
{
    string sAction;
    switch (Random(24))
    {
        case 0: sAction = "pk'd"; break;
        case 1: sAction = "destroyed"; break;
        case 2: sAction = "crushed"; break;
        case 3: sAction = "eradicated"; break;
        case 4: sAction = "annihilated"; break;
        case 5: sAction = "exterminated"; break;
        case 7: sAction = "neutralized"; break;
        case 8: sAction = "slaughtered"; break;
        case 9: sAction = "gutted"; break;
        case 10: sAction = "smashed"; break;
        case 11: sAction = "wrecked"; break;
        case 12: sAction = "butchered"; break;
        case 13: sAction = "mutilated"; break;
        case 14: sAction = "slayed"; break;
        case 15: sAction = "pulverized"; break;
        case 16: sAction = "eliminated"; break;
        case 17: sAction = "obliterated"; break;
        case 18: sAction = "purged"; break;
        case 19: sAction = "decimated"; break;
        case 20: sAction = "murdered"; break;
        case 21: sAction = "massacred"; break;
        case 22: sAction = "eviscerated"; break;
        case 23: sAction = "crushed"; break;
        case 24: sAction = "assassinated"; break;
    }

    return sAction;
}

void Raise(object oPlayer)
{
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    effect eBad = GetFirstEffect(oPlayer);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);

    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        switch (GetEffectType(eBad))
        {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_NEGATIVELEVEL:
            {
                //Remove effect if it is negative.
                RemoveEffect(oPlayer, eBad);
            }

            eBad = GetNextEffect(oPlayer);
        }
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oPlayer, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPlayer);
}

void StripPC(object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int iGold = GetGold(oPC);
    itemproperty ipSlots = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

    ClearAllActions(FALSE);
    AssignCommand(oPC, TakeGoldFromCreature(iGold, oPC, TRUE));

    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(oPC, 200);
    SetXP(oPC, 1);

    SetTag(oArmor, "sf_sockets");
    SetLocalInt(oArmor, "SOCKET_SLOTS", 8);
    IPSafeAddItemProperty(oArmor, ipSlots);
    SetDescription(oArmor, "Once you find a Socket Gem you wish to use on a Socket " +
    "Item, you may insert it into a Socket Item in two ways.  Inserting the Socket " +
    "Gem into a Socket Item may either be done with the Socket Item equipped or " +
    "on an inventory page.  Right click on the Socket Gem, on the small radial dial " +
    "that appears, select Use : Unique Power, then click on equipped socket item.  " +
    "This grants the item the power of the socket. This works for weapons, clothing " +
    "items and armor.  Most socket gems powers will combine with others of the same "+
    "power - thus creating a powerful and unique item.");
}

/*
void main () {}
