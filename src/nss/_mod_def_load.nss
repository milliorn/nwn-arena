//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 2019-01-22
//:://////////////////////////////////////////////
#include "nwnx_chat"
#include "nwnx_time"
#include "nwnx_webhook"
#include "x2_inc_switches"

void main()
{
    object oModule = GetModule();

    //  object oItem;
    object oArea;

    //  Set Module Vars for Combat
    SetLocalInt(oModule, "PLAYER_COUNT", 0);
    SetLocalInt(oModule, "COMBAT_READY", 0);

    //  Chat capture event script
    NWNX_Chat_RegisterChatScript("nwnx_chat_event");

    //  Create a Module Wide Dynamic Weather/Fog/Skybox system
    oArea = GetFirstArea();
    while (GetIsObjectValid(oArea))
    {
        if(GetIsAreaInterior(oArea) != TRUE)
        {
            SetSkyBox(Random(5), oArea);
            SetFogAmount(Random(2), Random(15), oArea);

            switch (Random(16))
            {
                case 0:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_BLACK, oArea); break;
                case 1:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_BLUE, oArea); break;
                case 2:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_BLUE_DARK, oArea); break;
                case 3:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_BROWN, oArea); break;
                case 4:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_BROWN_DARK, oArea); break;
                case 5:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_CYAN, oArea); break;
                case 6:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_GREEN, oArea); break;
                case 7:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_GREEN_DARK, oArea); break;
                case 8:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_GREY, oArea); break;
                case 9:  SetFogColor(FOG_TYPE_ALL, FOG_COLOR_MAGENTA, oArea); break;
                case 10: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_ORANGE, oArea); break;
                case 11: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_ORANGE_DARK, oArea); break;
                case 12: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_RED, oArea); break;
                case 13: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_RED_DARK, oArea); break;
                case 14: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_WHITE, oArea); break;
                case 15: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_YELLOW, oArea); break;
                case 16: SetFogColor(FOG_TYPE_ALL, FOG_COLOR_YELLOW_DARK, oArea); break;
            }
        }

        oArea = GetNextArea();
    }

    oArea = GetFirstArea();
    while (GetIsObjectValid(oArea))
    {
        if(GetIsAreaInterior(oArea) != TRUE)
        {
            switch (d4(1))
            {
                case 1:  SetWeather(oArea, WEATHER_CLEAR); break;
                case 2:  SetWeather(oArea, WEATHER_RAIN); break;
                case 3:  SetWeather(oArea, WEATHER_SNOW); break;
                case 4:  SetWeather(oArea, WEATHER_USE_AREA_SETTINGS); break;
            }
        }
        oArea = GetNextArea();
    }

    SetWeather(GetAreaFromLocation(GetStartingLocation()), WEATHER_USE_AREA_SETTINGS);

    //  Set a var so that it can track real time
    int iRawBootTime = NWNX_Time_GetTimeStamp();
    string sBootTime = NWNX_Time_GetSystemTime();
    string sBootDate = NWNX_Time_GetSystemDate();
    SetLocalInt(oModule, "RAW_BOOT_TIME", iRawBootTime);
    SetLocalString(oModule, "BOOT_TIME", sBootTime);
    SetLocalString(oModule, "BOOT_DATE", sBootDate);

    //  Redis DB Var
    SetLocalString(GetModule(), "SAVE_REDIS", "FALSE");

    //  Make a note in Server log of when this script finishes and send a message
    //  to Discord that the module is loaded.
    string sWebhookUrl = "/api/webhooks/472605187761242152/wqmbKttRf4VdSwhbg6C9fhy2GlQdtX8zCqohWwJesbyq3ImNx_s2AUpr0-E_p8m8VQo6/slack";
    string CurrentTime = NWNX_Time_GetSystemTime();
    string CurrentDate = NWNX_Time_GetSystemDate();
    string sMessage = GetModuleName()+ " server is online: " + CurrentTime + " on: " + CurrentDate + " (GMT)";
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", sWebhookUrl , sMessage , "Server");
    WriteTimestampedLogEntry("***SERVER LOADED***");

    if (GetGameDifficulty() ==  GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty() ==  GAME_DIFFICULTY_DIFFICULT)
    {
        // * Setting the switch below will enable a seperate Use Magic Device Skillcheck for
        // * rogues when playing on Hardcore+ difficulty. This only applies to scrolls
        SetModuleSwitch (MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);

       // * Activating the switch below will make AOE spells hurt neutral NPCS by default
       // SetModuleSwitch (MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
    }

   // * AI: Activating the switch below will make the creaures using the WalkWaypoint function
   // * able to walk across areas
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);

   // * Spells: Activating the switch below will make the Glyph of Warding spell behave differently:
   // * The visual glyph will disappear after 6 seconds, making them impossible to spot
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);

   // * Craft Feats: Want 50 charges on a newly created wand? We found this unbalancing,
   // * but since it is described this way in the book, here is the switch to get it back...
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES, TRUE);

   // * Craft Feats: Use this to disable Item Creation Feats if you do not want
   // * them in your module
   // SetModuleSwitch (MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS, TRUE);

   // * Palemaster: Deathless master touch in PnP only affects creatures up to a certain size.
   // * We do not support this check for balancing reasons, but you can still activate it...
   // SetModuleSwitch (MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH, TRUE);

   // * Epic Spellcasting: Some Epic spells feed on the liveforce of the caster. However this
   // * did not fit into NWNs spell system and was confusing, so we took it out...
   // SetModuleSwitch (MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER, TRUE);

   // * Epic Spellcasting: Some Epic spells feed on the liveforce of the caster. However this
   // * did not fit into NWNs spell system and was confusing, so we took it out...
   // SetModuleSwitch (MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, TRUE);

    // * Spellcasting: Some people don't like caster's abusing expertise to raise their AC
    // * Uncommenting this line will drop expertise mode whenever a spell is cast by a player
    // SetModuleSwitch (MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);


    // * Item Event Scripts: The game's default event scripts allow routing of all item related events
    // * into a single file, based on the tag of that item. If an item's tag is "test", it will fire a
    // * script called "test" when an item based event (equip, unequip, acquire, unacquire, activate,...)
    // * is triggered. Check "x2_it_example.nss" for an example.
    // * This feature is disabled by default.
    SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
/*
   if (GetModuleSwitchValue (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
   {
        // * If Tagbased scripts are enabled, and you are running a Local Vault Server
        // * you should use the line below to add a layer of security to your server, preventing
        // * people to execute script you don't want them to. If you use the feature below,
        // * all called item scrips will be the prefix + the Tag of the item you want to execute, up to a
        // * maximum of 16 chars, instead of the pure tag of the object.
        // * i.e. without the line below a user activating an item with the tag "test",
        // * will result in the execution of a script called "test". If you uncomment the line below
        // * the script called will be "1_test.nss"
        // SetUserDefinedItemEventPrefix("1_");

   }
*/
   // * This initializes Bioware's wandering monster system as used in Hordes of the Underdark
   // * You can deactivate it, making your module load faster if you do not use it.
   // * If you want to use it, make sure you set "x2_mod_def_rest" as your module's OnRest Script
   // SetModuleSwitch (MODULE_SWITCH_USE_XP2_RESTSYSTEM, TRUE);
/*
   if (GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM) == TRUE)
   {

       // * This allows you to specify a different 2da for the wandering monster system.
       // SetWanderingMonster2DAFile("des_restsystem");

       //* Do not change this line.
       WMBuild2DACache();
   }
*/
}
