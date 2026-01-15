export interface EpicUserData {
    displayName: string;
    email: string;
    avatar?: string;
    locale: string;
}

export interface EpicConnectionSession {
    sessionId: string;
    state: string;
    status: 'pending' | 'success' | 'error';
    timestamp: number;
    expiresAt: number;
    error?: string;
    epicAccountId?: string;
    userData?: EpicUserData;
}

export interface EpicTokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number;
    refresh_token: string;
    account_id: string;
    client_id: string;
    scope: string;
}

export interface EpicUserProfile {
    id: string;
    displayName: string;
    email: string;
    preferredLanguage?: string;
    country?: string;
}

export interface EpicConnectionStart {
    sessionId: string;
    authUrl: string;
}

export interface EpicCallbackResult {
    redirectUrl: string;
}

export interface EpicConnectionStatus {
    platform: 'epic';
    status: 'pending' | 'success' | 'error';
    epicAccountId?: string;
    userData?: EpicUserData;
    error?: string;
}

export interface EpicOAuthConfig {
    clientId: string;
    clientSecret: string;
    redirectUri: string;
    scopes: string[];
}
