export class GamingPlatformDto {
    id: string;
    name: string;
    displayName: string;
    description: string;
    logoUrl: string;
    colorScheme: {
        primary: string;
        secondary: string;
    };
    endpoints: {
        baseUrl: string;
        auth: string;
        userProfile: string;
        gameLibrary: string;
        achievements: string;
        friendsList?: string;
        gameStats?: string;
    };
    authConfig: {
        type: 'oauth2' | 'openid';
        clientIdRequired: boolean;
        secretRequired: boolean;
        redirectUri: string;
        scopes: string[];
    };
    features: {
        gameLibrary: boolean;
        achievements: boolean;
        friendsList: boolean;
        gameStats: boolean;
        screenshots: boolean;
        gameTime: boolean;
    };
    isEnabled: boolean;
    comingSoon: boolean;
    priority: number;
}

export class PlatformsListResponseDto {
    platforms: GamingPlatformDto[];
    totalCount: number;
    lastUpdated: string;
}