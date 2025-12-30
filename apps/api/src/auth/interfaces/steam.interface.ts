export interface SteamSession {
    sessionId: string;
    returnUrl: string;
    createdAt: Date;
    authenticated: boolean;
    steamId?: string;
    userInfo?: SteamUserInfo;
}

export interface SteamUserInfo {
    steamid: string;
    personaname: string;
    avatar: string;
    avatarmedium: string;
    avatarfull: string;
    profileurl: string;
    realname?: string;
}