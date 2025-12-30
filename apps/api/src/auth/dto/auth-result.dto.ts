export class AuthResultDto {
    accessToken: string;
    refreshToken: string;
    user: {
        id: string;
        email: string;
        name?: string;
        avatarUrl?: string;
        createdAt: string;
        updatedAt: string;
    };
}