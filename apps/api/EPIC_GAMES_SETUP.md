# Epic Games Integration - Setup Guide

## 🚨 Erro "invalid client - client has no application associated"

Este erro ocorre quando a configuração no Epic Games Developer Portal não está correta.

## ✅ Como configurar corretamente:

### 1. **Acesse o Epic Games Developer Portal**
- URL: https://dev.epicgames.com/portal/
- Faça login com sua conta Epic Games

### 2. **Crie uma Organização (se necessário)**
- Clique em "Create Organization"
- Preencha os dados da organização

### 3. **Crie um Product**
- Clique em "Create Product"  
- Tipo: **"Games"**
- Nome: "GHub Mobile App"
- Descrição: "Gaming platform integration app"

### 4. **Configure Epic Account Services**
- No dashboard do produto, vá para **"Product Settings"**
- Na seção **"Epic Account Services"**, clique em **"Create Client"**

### 5. **Configurações do Client**

#### **Client Type:**
- Selecione **"Public Client"** (para aplicações mobile/web)

#### **Redirect URLs:**
- Adicione EXATAMENTE estas URLs:
  ```
  http://192.168.68.102:3000/auth/epic/callback
  ghub://epic-auth
  ```

#### **Permissions/Scopes:**
- Marque **"basic_profile"**
- Adicione qualquer outro scope necessário

### 6. **Configuração de Sandbox**
- No menu lateral, vá para **"Epic Account Services" → "Sandboxes"**
- Certifique-se que o sandbox está **ativo**
- Associe o client ao sandbox

### 7. **Obter Credenciais**
- Vá para **"Epic Account Services" → "Clients"**
- Copie o **Client ID** (deve começar com `xyza`)
- Clique em **"Generate Secret"** e copie o **Client Secret**

### 8. **Configurar Variáveis de Ambiente**

#### **Backend (.env):**
```dotenv
# Epic Games Configuration
EPIC_CLIENT_ID=seu_client_id_aqui_comeca_com_xyza
EPIC_CLIENT_SECRET=seu_client_secret_aqui
EPIC_CALLBACK_URL=http://192.168.68.102:3000/auth/epic/callback
```

#### **Mobile (.env):**
```dotenv
# Epic Games Configuration
EPIC_CLIENT_ID=mesmo_client_id_do_backend
EPIC_CLIENT_SECRET=mesmo_client_secret_do_backend
```

## 🔍 Verificações importantes:

### **Client ID deve:**
- Começar com `xyza`
- Ter exatamente 32 caracteres
- Ser copiado diretamente do Developer Portal

### **Redirect URLs devem ser EXATOS:**
- `http://192.168.68.102:3000/auth/epic/callback` (backend)
- `ghub://epic-auth` (mobile deep link)

### **Sandbox deve estar:**
- ✅ Ativo/Enabled
- ✅ Associado ao client
- ✅ Com permissões adequadas

## 🐛 Troubleshooting:

### Se ainda der erro "invalid client":

1. **Verificar Client ID:**
   ```bash
   # No backend, verificar logs:
   curl http://192.168.68.102:3000/auth/epic/start
   ```

2. **Verificar Redirect URL:**
   - Deve ser EXATAMENTE igual no Developer Portal e no .env

3. **Verificar Sandbox:**
   - Epic Games usa sandboxes, certifique-se que está ativo

4. **Aguardar propagação:**
   - Mudanças no Developer Portal podem levar alguns minutos

## 📝 URLs importantes:

- **Developer Portal:** https://dev.epicgames.com/portal/
- **Documentação OAuth:** https://dev.epicgames.com/docs/epic-account-services/auth
- **Client Management:** https://dev.epicgames.com/portal/[org]/[product]/epic-account-services/clients

---

⚠️ **IMPORTANTE:** O Client ID deve estar associado a um Product ativo com Epic Account Services configurado corretamente.