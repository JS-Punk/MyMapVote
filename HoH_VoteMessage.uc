class HoH_VoteMessage extends LocalMessage;

var localized string RandomVoteMessage;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch(Switch)
    {
        case 1:
            return default.RandomVoteMessage;
    }
    return "";
}

defaultproperties
{
    RandomVoteMessage="Un jugador ha votado por un mapa aleatorio!"
}