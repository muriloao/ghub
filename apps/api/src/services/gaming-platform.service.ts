import { Injectable } from '@nestjs/common';
import { GamingPlatformDto, PlatformsListResponseDto } from '../dto/gaming-platform.dto';

@Injectable()
export class GamingPlatformService {
    private readonly platforms: GamingPlatformDto[] = [
        {
            id: 'steam',
            name: 'steam',
            displayName: 'Steam',
            description: 'A maior plataforma de distribuição digital de jogos para PC',
            logoUrl: 'https://store.steampowered.com/public/shared/images/header/logo_steam.svg',
            colorScheme: {
                primary: '#1b2838',
                secondary: '#66c0f4',
            },
            endpoints: {
                baseUrl: 'https://api.steampowered.com',
                auth: 'https://steamcommunity.com/openid/login',
                userProfile: 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/',
                gameLibrary: 'https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/',
                achievements: 'https://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/',
                friendsList: 'https://api.steampowered.com/ISteamUser/GetFriendList/v0001/',
                gameStats: 'https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/',
            },
            authConfig: {
                type: 'openid',
                clientIdRequired: false,
                secretRequired: true,
                redirectUri: 'ghub://steam-auth',
                scopes: [],
            },
            features: {
                gameLibrary: true,
                achievements: true,
                friendsList: true,
                gameStats: true,
                screenshots: false,
                gameTime: true,
            },
            isEnabled: true,
            comingSoon: false,
            priority: 1,
        },
        {
            id: 'epic',
            name: 'epic_games',
            displayName: 'Epic Games',
            description: 'Plataforma da Epic Games com jogos gratuitos semanais',
            logoUrl: 'https://cdn2.unrealengine.com/Fortnite+Esports%2Fstatic%2Fimages%2FEpic_Games_logo.svg',
            colorScheme: {
                primary: '#0078f3',
                secondary: '#ffffff',
            },
            endpoints: {
                baseUrl: 'https://api.epicgames.dev',
                auth: 'https://www.epicgames.com/id/api/redirect',
                userProfile: 'https://api.epicgames.dev/epic/id/v1/accounts',
                gameLibrary: 'https://api.epicgames.dev/epic/library/v1/items',
                achievements: 'https://api.epicgames.dev/epic/achievements/v1/player',
            },
            authConfig: {
                type: 'oauth2',
                clientIdRequired: true,
                secretRequired: true,
                redirectUri: 'ghub://epic-auth',
                scopes: ['basic_profile', 'library', 'achievements'],
            },
            features: {
                gameLibrary: true,
                achievements: true,
                friendsList: false,
                gameStats: false,
                screenshots: false,
                gameTime: false,
            },
            isEnabled: false,
            comingSoon: true,
            priority: 2,
        },
        {
            id: 'xbox',
            name: 'xbox_live',
            displayName: 'Xbox Live',
            description: 'Rede online da Microsoft para jogos Xbox e PC',
            logoUrl: 'https://logos-world.net/wp-content/uploads/2020/11/Xbox-Logo.png',
            colorScheme: {
                primary: '#107c10',
                secondary: '#ffffff',
            },
            endpoints: {
                baseUrl: 'https://xbl.io/api/v2',
                auth: 'https://login.microsoftonline.com/consumers/oauth2/v2.0/authorize',
                userProfile: 'https://profile.xboxlive.com/users/me/profile/settings',
                gameLibrary: 'https://titlehub.xboxlive.com/users/xuid({xuid})/titles/titlehistory/decoration/detail,image',
                achievements: 'https://achievements.xboxlive.com/users/xuid({xuid})/achievements',
                friendsList: 'https://social.xboxlive.com/users/me/people',
                gameStats: 'https://userstats.xboxlive.com/users/xuid({xuid})/stats',
            },
            authConfig: {
                type: 'oauth2',
                clientIdRequired: true,
                secretRequired: true,
                redirectUri: 'ghub://xbox-auth',
                scopes: ['Xboxlive.signin', 'Xboxlive.offline_access'],
            },
            features: {
                gameLibrary: true,
                achievements: true,
                friendsList: true,
                gameStats: true,
                screenshots: false,
                gameTime: true,
            },
            isEnabled: false,
            comingSoon: true,
            priority: 3,
        },
        {
            id: 'playstation',
            name: 'playstation_network',
            displayName: 'PlayStation Network',
            description: 'Rede online da Sony para jogos PlayStation',
            logoUrl: 'https://gmedia.playstation.com/is/image/GMCTNS/ps-logo-and-wordmark-copyright-white-01-en-14sep21',
            colorScheme: {
                primary: '#003791',
                secondary: '#ffffff',
            },
            endpoints: {
                baseUrl: 'https://us-prof.np.community.playstation.net/userProfile/v1/users',
                auth: 'https://id.sonyentertainmentnetwork.com/signin/',
                userProfile: 'https://us-prof.np.community.playstation.net/userProfile/v1/users/me/profile2',
                gameLibrary: 'https://us-prof.np.community.playstation.net/userProfile/v1/users/me/gameList',
                achievements: 'https://us-prof.np.community.playstation.net/userProfile/v1/users/me/trophyList',
            },
            authConfig: {
                type: 'oauth2',
                clientIdRequired: true,
                secretRequired: true,
                redirectUri: 'ghub://playstation-auth',
                scopes: ['psn:mobile.v1', 'psn:clientapp'],
            },
            features: {
                gameLibrary: true,
                achievements: true,
                friendsList: false,
                gameStats: false,
                screenshots: false,
                gameTime: false,
            },
            isEnabled: false,
            comingSoon: true,
            priority: 4,
        },
    ];

    getAllPlatforms(): PlatformsListResponseDto {
        // Ordena por prioridade e filtra apenas plataformas habilitadas ou em breve
        const sortedPlatforms = this.platforms
            .sort((a, b) => a.priority - b.priority);

        return {
            platforms: sortedPlatforms,
            totalCount: sortedPlatforms.length,
            lastUpdated: new Date().toISOString(),
        };
    }

    getEnabledPlatforms(): PlatformsListResponseDto {
        const enabledPlatforms = this.platforms
            .filter(platform => platform.isEnabled)
            .sort((a, b) => a.priority - b.priority);

        return {
            platforms: enabledPlatforms,
            totalCount: enabledPlatforms.length,
            lastUpdated: new Date().toISOString(),
        };
    }

    getPlatformById(id: string): GamingPlatformDto | null {
        return this.platforms.find(platform => platform.id === id) || null;
    }

    getAvailablePlatforms(): PlatformsListResponseDto {
        const availablePlatforms = this.platforms
            .filter(platform => platform.isEnabled || platform.comingSoon)
            .sort((a, b) => a.priority - b.priority);

        return {
            platforms: availablePlatforms,
            totalCount: availablePlatforms.length,
            lastUpdated: new Date().toISOString(),
        };
    }
}