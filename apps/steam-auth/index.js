const express = require('express');
const app = express();

/**
 * Endpoint chamado pela Steam
 */
app.get('/auth/steam/callback', (req, res) => {
    // Aqui você NORMALMENTE validaria o OpenID antes
    // (check_authentication)
    // Por enquanto vamos apenas redirecionar

    const params = new URLSearchParams(req.query).toString();

    const redirectUrl = `ghub://onboarding/callback?action=callback&source=steam&${params}`;

    console.log('Redirecting to:', redirectUrl);

    res.redirect(302, redirectUrl);
});

app.listen(3000, () => {
    console.log('Servidor rodando em http://localhost:3000');
});
