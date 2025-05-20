class HoH_MapVoteFooterX extends MapVoteFooter;

var localized string strLiked, stdDisliked;
var automated GUIButton b_Random;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
    Super.InitComponent(InController, InOwner);
    
    if(ed_Chat != None)
    {
        ed_Chat.SetCaption(Chr(0x1B) $ Chr(1) $ Chr(235) $ Chr(1) $ "F2 Say");
    }

    OnDraw = MyOnDraw;
}

function bool MyOnDraw(canvas C)
{
    local float xl,yl,w,l,t;
    
    t = sb_Background.ActualTop() + sb_Background.ActualHeight() + 5;
    l = sb_Background.ActualLeft() + sb_Background.ActualWidth() - sb_Background.ImageOffset[3];

    // Calcular el ancho base para todos los botones
    b_Close.Style.TextSize(C, MSAT_Blurry, b_Close.Caption, XL, YL, b_Close.FontScale);
    w = XL;
    b_Submit.Style.TextSize(C, MSAT_Blurry, b_Submit.Caption, XL, YL, b_Submit.FontScale);
    if(XL > w) w = XL;
    b_Accept.Style.TextSize(C, MSAT_Blurry, b_Accept.Caption, XL, YL, b_Accept.FontScale);
    if(XL > w) w = XL;
    b_Random.Style.TextSize(C, MSAT_Blurry, "Random Map", XL, YL, b_Random.FontScale);
    if(XL > w) w = XL;

    w = w * 1.2;
    w = ActualWidth(w);

    // Posicionar botones
    l -= w;
    b_Close.WinWidth = w;
    b_Close.WinTop = t;
    b_Close.WinLeft = l;

    l -= w;
    b_Submit.WinWidth = w;
    b_Submit.WinTop = t;
    b_Submit.WinLeft = l;

    l -= w;
    b_Random.WinWidth = w;
    b_Random.WinTop = t;
    b_Random.WinLeft = l;

    l -= w;
    b_Accept.WinWidth = w;
    b_Accept.WinTop = t;
    b_Accept.WinLeft = l;

    // Ajustar chat
    ed_Chat.WinLeft = sb_Background.ActualLeft() + sb_Background.ImageOffset[0];
    ed_Chat.WinWidth = l - ed_Chat.WinLeft - 10;
    ed_Chat.WinHeight = 25;
    ed_Chat.WinTop = t;

    return false;
}
function ReceiveChat(string Msg)
{
	lb_Chat.AddText(Msg);
	lb_Chat.MyScrollText.End();
}
delegate bool OnSendChat( string Text )
{
	local string c;

	if (Text == "") return false;

	if (RecallQueue.Length == 0 || RecallQueue[RecallQueue.Length - 1] != Text) {
		RecallIdx = RecallQueue.Length;
		RecallQueue[RecallIdx] = Text;
	}
	c = Left(Text, 1);

	if (Text == "+") {
		if (HoH_VotingReplicationInfo(PlayerOwner().VoteReplicationInfo).SetMapLike(true)) {
			PlayerOwner().ClientMessage(strLiked);
		}
	}
	else if (Text == "-") {
		if (HoH_VotingReplicationInfo(PlayerOwner().VoteReplicationInfo).SetMapLike(false)) {
			PlayerOwner().ClientMessage(stdDisliked);
		}
	}
	else if (c == ".") {
		PlayerOwner().TeamSay(Mid(Text, 1));
	}
	else if (c == "/") {
		PlayerOwner().ConsoleCommand(Mid(Text, 1));
	}
	else if (c ~= "c" && Left(Text, 4) ~= "cmd ") {
		// legacy cmd
		PlayerOwner().ConsoleCommand(Mid(Text, 4));
	} else {
		PlayerOwner().Say(Text);
	}
	return true;
}
function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_Random)
    {
        SendRandomVote();
        return true;
    }
    return Super.InternalOnClick(Sender);
}

function SendRandomVote()
{
    local HoH_VotingReplicationInfo HVRI;
    
    HVRI = HoH_VotingReplicationInfo(PlayerOwner().VoteReplicationInfo);
    if(HVRI != None)
    {
        HVRI.SendMapVote(-999, 0);
    }
}

defaultproperties
{
    Begin Object Class=GUIButton Name=RandomButton
        StyleName="SquareButton"
        Caption="Random Map"
        OnClick=MapVoteFooter.InternalOnClick
    End Object
    b_Random=RandomButton

    Begin Object Class=AltSectionBackground Name=MapvoteFooterBackground
        bFillClient=true
        bNoCaption=true
        WinHeight=0.81
        bBoundToParent=true
        bScaleToParent=true
        OnPreDraw=MapvoteFooterBackground.InternalPreDraw
    End Object
    sb_Background=MapvoteFooterBackground

    Begin Object Class=GUIScrollTextBox Name=ChatScrollBox
        bNoTeletype=true
        CharDelay=0.0025
        EOLDelay=0
        bVisibleWhenEmpty=true
        StyleName="ServerBrowserGrid"
        WinTop=0.02
        WinLeft=0.01
        WinWidth=0.96
        WinHeight=0.76
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    End Object
    lb_Chat=ChatScrollBox

    Begin Object Class=moEditBox Name=ChatEditbox
        CaptionWidth=0.15
        WinTop=0.968598
        WinLeft=0.005235
        WinWidth=0.900243
        WinHeight=0.106609
        OnKeyEvent=MapVoteFooter.InternalOnKeyEvent
    End Object
    ed_Chat=ChatEditbox

    strLiked="Liked the current map"
    stdDisliked="Disliked the current map"
}