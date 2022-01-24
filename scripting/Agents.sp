#pragma semicolon 1
#define DEBUG
#pragma tabsize 0
#define PLUGIN_AUTHOR "SniffRx"
#define PLUGIN_VERSION "1.9.3"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <clientprefs>
#include <vip_core>
#include <modelch>

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "[VIP] Special Skins(Agents)",
	author = PLUGIN_AUTHOR,
	description = "[VIP] Агенты/[VIP] Agents",
	version = PLUGIN_VERSION,
	url = "github.com/SniffRx"
};
Handle g_sDataSkin;//Terrorist
Handle g_sDataSKIN_CT;//CT
Handle g_iAgentPatchSLOT1;
Handle g_iAgentPatchSLOT2;
Handle g_iAgentPatchSLOT3;
Handle g_iAgentPatchSLOT4;
Handle g_iAgentPatchSLOT5;
int LocalPatch[MAXPLAYERS + 1] = -1;

#define VIP_Agents				"Agents"
#define VIP_Agents_M			"VIP_Agents_M"

public void OnPluginStart()
{

	if(VIP_IsVIPLoaded())
	VIP_OnVIPLoaded();

	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}

	HookEvent("player_spawn", OnPlayerSpawn);

	g_sDataSkin = RegClientCookie("ss_skin_t", "", CookieAccess_Private);
	g_sDataSKIN_CT = RegClientCookie("ss_skin_ct", "", CookieAccess_Private);
	g_iAgentPatchSLOT1 = RegClientCookie("ss_patch_slot1", "", CookieAccess_Private);
	g_iAgentPatchSLOT2 = RegClientCookie("ss_patch_slot2", "", CookieAccess_Private);
	g_iAgentPatchSLOT3 = RegClientCookie("ss_patch_slot3", "", CookieAccess_Private);
	g_iAgentPatchSLOT4 = RegClientCookie("ss_patch_slot4", "", CookieAccess_Private);
	g_iAgentPatchSLOT5 = RegClientCookie("ss_patch_slot5", "", CookieAccess_Private);
	
	LoadTranslations("agents_selector.phrases");
	AutoExecConfig(true, "AgentsSelector");
}

public Action OnPlayerSpawn(Event eEvent, const char[] sName, bool bDontBroadcast)
{
	new client = GetClientOfUserId(eEvent.GetInt("userid"));
	if (client)
	{
		if(IsValidClient(client) && VIP_IsClientVIP(client) && VIP_IsClientFeatureUse(client, VIP_Agents))
		{
			int iSize = GetEntPropArraySize(client, Prop_Send, "m_vecPlayerPatchEconIndices");
			for(int i = 0; i < iSize; i++)
			{
				int PatchID = GetPatchInSlot(client, i);
				if(PatchID)	
					SetEntProp(client, Prop_Send, "m_vecPlayerPatchEconIndices", PatchID, 4, i);
			}
		}
	}
}

public void VIP_OnVIPLoaded()
{
	VIP_RegisterFeature(VIP_Agents_M, BOOL, SELECTABLE, OnSelectItem);//, OnDisplayItem, OnDrawItem);
	VIP_RegisterFeature(VIP_Agents, BOOL);
}

int GetPatchInSlot(client, int slot = -1)
{
	int valx = 0;
	switch(slot)
	{
		case 0:
		{
			char Temp[36];
			GetClientCookie(client, g_iAgentPatchSLOT1, Temp, sizeof(Temp));
			valx = StringToInt(Temp);
		}
		case 1:
		{
			char Temp[36];
			GetClientCookie(client, g_iAgentPatchSLOT2, Temp, sizeof(Temp));
			valx = StringToInt(Temp);
		}
		case 2:
		{
			char Temp[36];
			GetClientCookie(client, g_iAgentPatchSLOT3, Temp, sizeof(Temp));
			valx = StringToInt(Temp);
		}	
		case 3:
		{
			char Temp[36];
			GetClientCookie(client, g_iAgentPatchSLOT4, Temp, sizeof(Temp));
			valx = StringToInt(Temp);
		}	
		case 4:
		{
			char Temp[36];
			GetClientCookie(client, g_iAgentPatchSLOT5, Temp, sizeof(Temp));
			valx = StringToInt(Temp);
		}		
		default:
		{
		}
	}
	return valx;
}
SetPatchInSlot(client, int slot = -1, int value)
{
	char Convert[36];
	IntToString(value, Convert, sizeof(Convert));
	switch(slot)
	{
		case 0:
		{
			SetClientCookie(client, g_iAgentPatchSLOT1, Convert);
		}
		case 1:
		{
			SetClientCookie(client, g_iAgentPatchSLOT2, Convert);
		}
		case 2:
		{
			SetClientCookie(client, g_iAgentPatchSLOT3, Convert);
		}	
		case 3:
		{
			SetClientCookie(client, g_iAgentPatchSLOT4, Convert);
		}	
		case 4:
		{
			SetClientCookie(client, g_iAgentPatchSLOT5, Convert);
		}		
		default:
		{
			
		}
	}
}
public Action SpecialSkin_Patches(iClient,args)
{
}

public IsValidClient(client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}

public Action MdlCh_PlayerSpawn(int client, bool custom, char[] model, int model_maxlen, char[] vo_prefix, int prefix_maxlen)
{
	if(!IsValidClient(client) || !VIP_IsClientVIP(client) || !VIP_IsClientFeatureUse(client, VIP_Agents))
		return Plugin_Continue;

	char sCookieModel[192];

	GetClientCookie(client, (GetClientTeam(client) == CS_TEAM_T) ? g_sDataSKIN_CT : g_sDataSkin, sCookieModel, sizeof(sCookieModel));

	if(StrEqual(sCookieModel, ""))
		return Plugin_Continue;

	strcopy(model, model_maxlen, sCookieModel);

	/*char szAuth[32];		GetClientAuthId(client, AuthId_Engine, szAuth, sizeof(szAuth));

	if(GetClientTeam(client) == CS_TEAM_CT && StrEqual(szAuth, "STEAM_1:1:00000"))
		strcopy(vo_prefix, prefix_maxlen, "gendarmerie_fem_epic");

	else*/ if(StrContains(sCookieModel, "tm_balkan_varianth") > -1)
		strcopy(vo_prefix, prefix_maxlen, "balkan_epic");
	else if(StrContains(sCookieModel, "tm_leet_variantf") > -1)
		strcopy(vo_prefix, prefix_maxlen, "leet_epic");
	else if(StrContains(sCookieModel, "tm_professional_varf") > -1)
		strcopy(vo_prefix, prefix_maxlen, "professional_epic");
	else if(StrContains(sCookieModel, "tm_professional_varg") > -1 || StrContains(sCookieModel, "tm_professional_varj") > -1)
		strcopy(vo_prefix, prefix_maxlen, "professional_fem");
	else if(StrContains(sCookieModel, "tm_jungle_raider_variantb") > -1)
		strcopy(vo_prefix, prefix_maxlen, "jungle_male_epic");
	else if(StrContains(sCookieModel, "tm_jungle_raider_variante") > -1)
		strcopy(vo_prefix, prefix_maxlen, "jungle_fem_epic");
	else if(StrContains(sCookieModel, "tm_jungle_raider_variant") > -1)
		strcopy(vo_prefix, prefix_maxlen, "jungle_male");

	else if(StrContains(sCookieModel, "ctm_st6_variantk") > -1 || StrContains(sCookieModel, "ctm_st6_varianti") > -1)
		strcopy(vo_prefix, prefix_maxlen, "ctm_gsg9");
	else if(StrContains(sCookieModel, "ctm_fbi_variantb") > -1)
		strcopy(vo_prefix, prefix_maxlen, "fbihrt_epic");
	else if(StrContains(sCookieModel, "ctm_swat_variante") > -1)
		strcopy(vo_prefix, prefix_maxlen, "swat_epic");
	else if(StrContains(sCookieModel, "ctm_swat_variantf") > -1 || StrContains(sCookieModel, "ctm_swat_variantk") > -1)
		strcopy(vo_prefix, prefix_maxlen, "swat_fem");
	else if(StrContains(sCookieModel, "ctm_gendarmerie_variantc") > -1)
		strcopy(vo_prefix, prefix_maxlen, "gendarmerie_fem_epic");
	else if(StrContains(sCookieModel, "ctm_diver_varianta") > -1)
		strcopy(vo_prefix, prefix_maxlen, "seal_fem");
	else if(StrContains(sCookieModel, "ctm_diver_variantb") > -1)
		strcopy(vo_prefix, prefix_maxlen, "seal_diver_01");
	else if(StrContains(sCookieModel, "ctm_diver_variantc") > -1)
		strcopy(vo_prefix, prefix_maxlen, "seal_diver_02");
	else if(StrContains(sCookieModel, "ctm_gendarmerie_variant") > -1)
		strcopy(vo_prefix, prefix_maxlen, "gendarmerie_male");

	return Plugin_Changed;
}


public bool:OnSelectItem(client, const String:sFeatureName[])
{
	new args;
    SpecialSkin3(client, args);
    return false; // always false !!!
}

public Action SpecialSkin3(client,args)
{
	new Handle:menu = CreateMenu(AgencySELECTOR, MenuAction_Select  | MenuAction_End);
	char Wrapper[255];
	SetMenuTitle(menu, "%t", "MenuTitle_AgentType");
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentReset");
	AddMenuItem(menu, "Reset", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickPatch_TITLE");
	AddMenuItem(menu, "Patch", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentDist1");
	AddMenuItem(menu, "DeservedAGENCY1", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentDist2");
	AddMenuItem(menu, "DeservedAGENCY2", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentExceptional1");
	AddMenuItem(menu, "NomineeSDX1", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentExceptional2");
	AddMenuItem(menu, "NomineeSDX2", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentSuperior1");
	AddMenuItem(menu, "PerfectAGNT1", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_AgentSuperior2");
	AddMenuItem(menu, "PerfectAGNT2", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_Master1");
	AddMenuItem(menu, "MasterAGENT1", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_Master2");
	AddMenuItem(menu, "MasterAGENT2", Wrapper);
	//Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_New");
	//AddMenuItem(menu, "NewAGENT", Wrapper);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);	
}
public AgencySELECTOR(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			if (StrEqual(item, "DeservedAGENCY1"))
			{
				SelectorMENUGEN(param1, 1);
			}
			else if (StrEqual(item, "DeservedAGENCY2"))
			{
				SelectorMENUGEN(param1, 2);
			}
			else if (StrEqual(item, "NomineeSDX1"))
			{
				SelectorMENUGEN(param1, 3);
			}
			else if (StrEqual(item, "NomineeSDX2"))
			{
				SelectorMENUGEN(param1, 4);
			}
			else if (StrEqual(item, "PerfectAGNT1"))
			{
				SelectorMENUGEN(param1, 5);
			}
			else if (StrEqual(item, "PerfectAGNT2"))
			{
				SelectorMENUGEN(param1, 6);
			}
			else if (StrEqual(item, "MasterAGENT1"))
			{
				SelectorMENUGEN(param1, 7);
			}
			else if (StrEqual(item, "MasterAGENT2"))
			{
				SelectorMENUGEN(param1, 8);
			}
			/*else if (StrEqual(item, "NewAGENT"))
			{
				SelectorMENUGEN(param1, 5);
			}*/
			else if(StrEqual(item, "Reset"))
			{
				SetClientCookie(param1, g_sDataSkin, "");
				SetClientCookie(param1, g_sDataSKIN_CT, "");
				PrintToChat(param1, "%t", "Agents_Reseted");
			}else if(StrEqual(item, "Patch"))
			{
				ShowSelectionPatches(param1);
			}
			//VIP_SendClientVIPMenu(param1);
		}
		case MenuAction_End: CloseHandle(menu);
		/*case MenuAction_Cancel:
		{
			if(param2 == MenuCancel_ExitBack)
			{
				VIP_SendClientVIPMenu(param1);
			}
		}*/
	}
}
ShowSelectionPatches(client)
{
	new Handle:menu = CreateMenu(MAINER_PATCH, MenuAction_Select | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, " \n ");
	char Wrapper[1024];
	Format(Wrapper, sizeof(Wrapper), "%t\n ", "MenuTitle_PickPatch_Reset");
	AddMenuItem(menu, "RESET", Wrapper);
	
	//Valve
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_PAYBACK");
	AddMenuItem(menu, "4567", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_BRAVO");
	AddMenuItem(menu, "4563", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_PHOENIX");
	AddMenuItem(menu, "4568", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_BREAKOUT");
	AddMenuItem(menu, "4564", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_VANGUARD");
	AddMenuItem(menu, "4570", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_BLOODHOUND");
	AddMenuItem(menu, "4562", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_WILDFIRE");
	AddMenuItem(menu, "4560", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_HYDRA");
	AddMenuItem(menu, "4566", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SHATTERED");
	AddMenuItem(menu, "4569", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_DANGERZONE");
	AddMenuItem(menu, "4565", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_EZPZ");
	AddMenuItem(menu, "4555", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CHICKENLOVER");
	AddMenuItem(menu, "4552", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CRAZYBANANA");
	AddMenuItem(menu, "4550", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CLUTCH");
	AddMenuItem(menu, "4553", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_KOI");
	AddMenuItem(menu, "4558", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LONGEVITY");
	AddMenuItem(menu, "4559", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_VIGILANCE");
	AddMenuItem(menu, "4561", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_RAGE");
	AddMenuItem(menu, "4556", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_DRAGON");
	AddMenuItem(menu, "4554", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_BOSS");
	AddMenuItem(menu, "4551", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_HOWL");
	AddMenuItem(menu, "4557", Wrapper);
	
	//BROKEN FANG
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SILVER");
	AddMenuItem(menu, "4571", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_GOLDNOVA");
	AddMenuItem(menu, "4572", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_GOLDNOVAMASTER");
	AddMenuItem(menu, "4575", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_MASTERGUARDIAN");
	AddMenuItem(menu, "4576", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_MASTERGUARDIANELITE");
	AddMenuItem(menu, "4578", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_DMG");
	AddMenuItem(menu, "4579", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LEGENDARYEAGLE");
	AddMenuItem(menu, "4580", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LEGENDARYEAGLEMASTER");
	AddMenuItem(menu, "4581", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SUPREME");
	AddMenuItem(menu, "4582", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_GLOBALELITE");
	AddMenuItem(menu, "4583", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_DMGTWO");
	AddMenuItem(menu, "4584", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LEGENDARYEAGLE2");
	AddMenuItem(menu, "4585", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LEGENDARYEAGLEMASTERTWO");
	AddMenuItem(menu, "4586", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SILVERTWO");
	AddMenuItem(menu, "4587", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SUPREMEMASTER");
	AddMenuItem(menu, "4588", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_GLOBALELITETWO");
	AddMenuItem(menu, "4697", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_MASTERGUARDIANTHREE");
	AddMenuItem(menu, "4699", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_GOLDNOVAFOUR");
	AddMenuItem(menu, "4700", Wrapper);
    
	//Half-Alyx
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_ALYX");
	AddMenuItem(menu, "4589", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_HEADCRABGREEN");
	AddMenuItem(menu, "4591", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_VORT");
	AddMenuItem(menu, "4592", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_HEADCRABTEAL");
	AddMenuItem(menu, "4593", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LAMBDACOPPER");
	AddMenuItem(menu, "4594", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_HEARTS");
	AddMenuItem(menu, "4595", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_COMBINE");
	AddMenuItem(menu, "4596", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_BLACKMESA");
	AddMenuItem(menu, "4597", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CMB");
	AddMenuItem(menu, "4598", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_LAMBDAORANGE");
	AddMenuItem(menu, "4599", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_C17");
	AddMenuItem(menu, "4600", Wrapper);

	//Riptide
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_ABANDONHOPE");
	AddMenuItem(menu, "4937", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_ANCHOR");
	AddMenuItem(menu, "4938", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CRUISING");
	AddMenuItem(menu, "4939", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_FROGSKELETON");
	AddMenuItem(menu, "4940", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_MADSUSHI");
	AddMenuItem(menu, "4941", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_PINKSQUID");
	AddMenuItem(menu, "4942", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_PIRANHA");
	AddMenuItem(menu, "4943", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SIREN");
	AddMenuItem(menu, "4944", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SKULLCROSSWORDS");
	AddMenuItem(menu, "4945", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_SUNSETWAVE");
	AddMenuItem(menu, "4946", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_FISHGO");
	AddMenuItem(menu, "4947", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_CTHULHU");
	AddMenuItem(menu, "4948", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "ITEM_MEALTIME");
	AddMenuItem(menu, "4949", Wrapper);
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public MAINER_PATCH(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "RESET"))
			{
				SetPatchInSlot(param1, 1, 0);
				SetPatchInSlot(param1, 2, 0);
				SetPatchInSlot(param1, 3, 0);
				SetPatchInSlot(param1, 4, 0);
				SetPatchInSlot(param1, 5, 0);
				PrintToChat(param1, "%t", "MenuTitle_PatchAllReset");
				return;
			}
			int PatchID = StringToInt(item);
			LocalPatch[param1] = PatchID;
			ProcessSelection(param1);
		}
		case MenuAction_Cancel:
 		{
 			SpecialSkin3(param1, 0);
 		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
ProcessSelection(client)
{
	new Handle:menu = CreateMenu(MAINER_PATCH_SLOT, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, " \n");//2 lazy 2 define.
	char Wrapper[1024];
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForSlot", "1");
	AddMenuItem(menu, "0", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForSlot", "2");
	AddMenuItem(menu, "1", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForSlot", "3");
	AddMenuItem(menu, "2", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForSlot", "4");
	AddMenuItem(menu, "3", Wrapper);	
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForSlot", "5");
	AddMenuItem(menu, "4", Wrapper);
	Format(Wrapper, sizeof(Wrapper), "%t", "MenuTitle_PickForAllSlots");
	AddMenuItem(menu, "ALL", Wrapper);	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public MAINER_PATCH_SLOT(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			int Slot = StringToInt(item);
			if(StrEqual(item, "ALL"))
			{
				SetPatchInSlot(param1, 0, LocalPatch[param1]);
				SetPatchInSlot(param1, 1, LocalPatch[param1]);
				SetPatchInSlot(param1, 2, LocalPatch[param1]);
				SetPatchInSlot(param1, 3, LocalPatch[param1]);
				SetPatchInSlot(param1, 4, LocalPatch[param1]);
				PrintToChat(param1, "%t", "MenuTitle_PatchInstalled");
				return;
			}
			PrintToChat(param1, "%t", "MenuTitle_PatchInstalled");
			SetPatchInSlot(param1, Slot, LocalPatch[param1]);
		}
 		case MenuAction_Cancel:
 		{
 			SpecialSkin3(param1, 0);
 			//ShowSelectionPatches(param1);
 		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
SelectorMENUGEN(client, int type)
{
	new Handle:menu = CreateMenu(XCGSelector, MenuAction_Select | MenuAction_Cancel | MenuAction_End);
	SetMenuTitle(menu, "%t", "MenuTitle_PickIt");
	char Wrapper[1024];
	switch(type)
	{
		case 8://Мастерские (T)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_21");
			AddMenuItem(menu, "21", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_22");
			AddMenuItem(menu, "22", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_38");
			AddMenuItem(menu, "38", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_39");
			AddMenuItem(menu, "39", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_40");
			AddMenuItem(menu, "40", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_41");
			AddMenuItem(menu, "41", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_42");
			AddMenuItem(menu, "42", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_61");
			AddMenuItem(menu, "61", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_62");
			AddMenuItem(menu, "62", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_63");
			AddMenuItem(menu, "63", Wrapper);
		}
		case 7://Мастерские (CT)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_19");
			AddMenuItem(menu, "19", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_20");
			AddMenuItem(menu, "20", Wrapper);
			// Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_22");
			// AddMenuItem(menu, "22", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_37");
			AddMenuItem(menu, "37", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_51");
			AddMenuItem(menu, "51", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_52");
			AddMenuItem(menu, "52", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_53");
			AddMenuItem(menu, "53", Wrapper);
		}
		case 6://Превосходные агенты (T)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_14");
			AddMenuItem(menu, "14", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_16");
			AddMenuItem(menu, "16", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_17");
			AddMenuItem(menu, "17", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_34");
			AddMenuItem(menu, "34", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_35");
			AddMenuItem(menu, "35", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_36");
			AddMenuItem(menu, "36", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_58");
			AddMenuItem(menu, "58", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_59");
			AddMenuItem(menu, "59", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_60");
			AddMenuItem(menu, "60", Wrapper);
		}
		case 5://Превосходные агенты (CT)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_15");
			AddMenuItem(menu, "15", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_16");
			AddMenuItem(menu, "16", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_32");
			AddMenuItem(menu, "32", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_33");
			AddMenuItem(menu, "33", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_49");
			AddMenuItem(menu, "49", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_50");
			AddMenuItem(menu, "50", Wrapper);
		}
		case 4://Исключительные агенты (T)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_9");
			AddMenuItem(menu, "9", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_11");
			AddMenuItem(menu, "11", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_12");
			AddMenuItem(menu, "12", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_13");
			AddMenuItem(menu, "13", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_30");
			AddMenuItem(menu, "30", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_31");
			AddMenuItem(menu, "31", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_56");
			AddMenuItem(menu, "56", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_57");
			AddMenuItem(menu, "57", Wrapper);
		}
		case 3://Исключительные агенты (CT)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_8");
			AddMenuItem(menu, "8", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_10");
			AddMenuItem(menu, "10", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_27");
			AddMenuItem(menu, "27", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_28");
			AddMenuItem(menu, "28", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_29");
			AddMenuItem(menu, "29", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_46");
			AddMenuItem(menu, "46", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_47");
			AddMenuItem(menu, "47", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_48");
			AddMenuItem(menu, "48", Wrapper);
		}
		case 2://Заслуженные агенты (T)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_4");
			AddMenuItem(menu, "4", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_5");
			AddMenuItem(menu, "5", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_6");
			AddMenuItem(menu, "6", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_25");
			AddMenuItem(menu, "25", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_26");
			AddMenuItem(menu, "26", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_54");
			AddMenuItem(menu, "54", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_55");
			AddMenuItem(menu, "55", Wrapper);
		}
		case 1://Заслуженные агенты (CT)
		{
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_1");
			AddMenuItem(menu, "1", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_2");
			AddMenuItem(menu, "2", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_3");
			AddMenuItem(menu, "3", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_7");
			AddMenuItem(menu, "7", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_23");
			AddMenuItem(menu, "23", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_24");
			AddMenuItem(menu, "24", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_43");
			AddMenuItem(menu, "43", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_44");
			AddMenuItem(menu, "44", Wrapper);
			Format(Wrapper, sizeof(Wrapper), "%t", "AgentSID_45");
			AddMenuItem(menu, "45", Wrapper);
		}
		default:
		{
			//PrintToChat(client, "Not found.");
			CloseHandle(menu);
		}
	}
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public XCGSelector(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			int SPICK = StringToInt(item);
			char ModelName[255];
			if(SPICK > 0)
			{
				int team = 0;
				switch(SPICK)
				{
					case 23:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_variantj.mdl";
					}
					case 24:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_varianth.mdl";
					}
					case 25:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_varianti.mdl";
					}
					case 26:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantl.mdl";
					}
					case 27:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_variantg.mdl";
					}
					case 28:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_varianti.mdl";
					}
					case 29:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantj.mdl";
					}
					case 30:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varj.mdl";
					}
					case 31:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varh.mdl";
					}
					case 32:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_variantf.mdl";
					}
					case 33:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantl.mdl";
					}
					case 34:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_vari.mdl";
					}
					case 35:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varg.mdl";
					}
					case 36:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantk.mdl";
					}
					case 37:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_variante.mdl";
					}
					case 38:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf.mdl";
					}
					case 39:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf1.mdl";
					}
					case 40:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf2.mdl";
					}
					case 41:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf3.mdl";
					}
					case 42:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf4.mdl";
					}
					case 6:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_varianth.mdl";
					}
					case 12:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantg.mdl";
					}
					case 5:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantf.mdl";
					}
					case 17:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_varianti.mdl";
					}
					case 4:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_variantg.mdl";
					}
					case 11:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_varianth.mdl";
					}
					case 14:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantj.mdl";
					}
					case 9:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianti.mdl";
					}
					case 21:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianth.mdl";
					}					
					case 18:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantg.mdl";
					}
					case 13:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantf.mdl";
					}
					case 16:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantm.mdl";
					}
					case 19:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_varianti.mdl";
					}
					case 10:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantg.mdl";
					}
					case 7:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_sas_variantf.mdl";
					}
					case 15:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_varianth.mdl";
					}
					case 8:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantg.mdl";
					}
					case 20:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantb.mdl";
					}
					case 22:
					{
						team = 2;//T
						ModelName = "models/player/custom_player/legacy/tm_leet_variantf.mdl";
					}
					case 3:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantf.mdl";
					}
					case 1:
					{
						team = 1;//CT
						ModelName = "models/player/custom_player/legacy/ctm_st6_variante.mdl";
					}
					case 2:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantk.mdl";
					}
					case 43:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl";
					}
					case 44:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantn.mdl";
					}
					case 45:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_sas_variantg.mdl";
					}
					case 46:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl";
					}
					case 47:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl";
					}
					case 48:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_swat_variantk.mdl";
					}
					case 49:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_diver_variantc.mdl";
					}
					case 50:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl";
					}
					case 51:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_diver_variantb.mdl";
					}
					case 52:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_diver_varianta.mdl";
					}
					case 53:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl";
					}
					case 54:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl";
					}
					case 55:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_variantj.mdl";
					}
					case 56:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl";
					}
					case 57:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl";
					}
					case 58:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl";
					}
					case 59:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantc.mdl";
					}
					case 60:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_professional_varf5.mdl";
					}
					case 61:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl";
					}
					case 62:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl";
					}
					case 63:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_jungle_raider_variante.mdl";
					}					
				}
				//PrintToChatAll("%s", ModelName);
				
				if(team == 1)
				{
					SetClientCookie(param1, g_sDataSkin, ModelName);
					PrintToChat(param1, "%t", "Agent_PickedCT");
				}else if(team == 2)
				{
					PrintToChat(param1, "%t", "Agent_PickedT");
					SetClientCookie(param1, g_sDataSKIN_CT, ModelName);
				}

				// CloseHandle(menu);
			}
		}

 		case MenuAction_Cancel:
 		{
 			SpecialSkin3(param1, 0);
 		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
public void OnPluginEnd() 
{
	VIP_UnregisterFeature(VIP_Agents);
}