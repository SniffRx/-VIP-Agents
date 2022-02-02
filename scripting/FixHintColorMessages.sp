UserMsg g_TextMsg, g_HintText;

static char g_sSpace[2048];

public Plugin myinfo =
{
	name = "Fix Hint Color Messages",
	description = "Исправляет форматирование для PrintHintText и PrintCenterText",
	author = "Phoenix (˙·٠●Феникс●٠·˙)",
	version = "1.1.0",
	url = "zizt.ru hlmod.ru"
};

public void OnPluginStart()
{
	for(int i = 0; i < sizeof g_sSpace - 1; i++)
	{
		g_sSpace[i] = ' ';
	}
	
	g_TextMsg = GetUserMessageId("TextMsg");
	g_HintText = GetUserMessageId("HintText");
	
	HookUserMessage(g_TextMsg, TextMsgHintTextHook, true);
	HookUserMessage(g_HintText, TextMsgHintTextHook, true);
}

Action TextMsgHintTextHook(UserMsg msg_id, Protobuf msg, const int[] players, int playersNum, bool reliable, bool init)
{
	static char sBuf[sizeof g_sSpace];
	
	if(msg_id == g_HintText)
	{
		msg.ReadString("text", sBuf, sizeof sBuf);
	}
	else if(msg.ReadInt("msg_dst") == 4)
	{
		msg.ReadString("params", sBuf, sizeof sBuf, 0);
	}
	else
	{
		return Plugin_Continue;
	}
	
	if(StrContains(sBuf, "</font>") != -1 || StrContains(sBuf, "</span>") != -1)
	{
		DataPack hPack = new DataPack();
		
		hPack.WriteCell(playersNum);
		
		for(int i = 0; i < playersNum; i++)
		{
			hPack.WriteCell(players[i]);
		}
		
		hPack.WriteString(sBuf);
		
		hPack.Reset();
		
		RequestFrame(TextMsgFix, hPack);
		
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

void TextMsgFix(DataPack hPack)
{
	int iCount = 0, iCountAll = hPack.ReadCell();
	
	static int iPlayers[MAXPLAYERS+1];
	
	for(int i = 0, u; i < iCountAll; i++)
	{
		u = hPack.ReadCell();
		
		if(IsClientInGame(u))
		{
			iPlayers[iCount++] = u;
		}
	}
	
	if(iCount != 0)
	{
		static char sBuf[sizeof g_sSpace];
		
		hPack.ReadString(sBuf, sizeof sBuf);
		
		Protobuf hMessage = view_as<Protobuf>(StartMessageEx(g_TextMsg, iPlayers, iCount, USERMSG_RELIABLE|USERMSG_BLOCKHOOKS));
		
		if(hMessage)
		{
			hMessage.SetInt("msg_dst", 4);
			hMessage.AddString("params", "#SFUI_ContractKillStart");
			
			Format(sBuf, sizeof sBuf, "</font>%s%s", sBuf, g_sSpace);
			hMessage.AddString("params", sBuf);
			
			hMessage.AddString("params", NULL_STRING);
			hMessage.AddString("params", NULL_STRING);
			hMessage.AddString("params", NULL_STRING);
			hMessage.AddString("params", NULL_STRING);
			
			EndMessage();
		}
	}
	
	delete hPack;
}