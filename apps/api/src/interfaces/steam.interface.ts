export interface SteamUserData {
    steamid: string;
    personaname: string;
    profileurl: string;
    avatar: string;
    avatarmedium: string;
    avatarfull: string;
    personastate: number;
    communityvisibilitystate: number;
    profilestate: number;
    lastlogoff: number;
    commentpermission: number;
}

export interface SteamApiResponse {
    response: {
        players: SteamUserData[];
    };
}

export interface AuthSession {
    nonce: string;
    timestamp: number;
    userId?: string;
}

export interface AuthResponse {
    success: boolean;
    user?: {
        id: string;
        steamId: string;
        name: string;
        avatar: string;
        email: string;
    };
    tokens?: {
        access_token: string;
        refresh_token: string;
        expires_in: number;
    };
    error?: string;
}
