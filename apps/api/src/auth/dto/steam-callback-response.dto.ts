export class SteamCallbackResponseDto {
    authenticated: boolean;
    accessToken?: string;
    refreshToken?: string;
    user?: {
        id: string;
        email: string;
        name?: string;
        avatarUrl?: string;
        createdAt: string;
        updatedAt: string;
    };
    message?: string;
}