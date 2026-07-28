# Controle do Plano de Saúde

App estático (`index.html`) que se conecta direto ao Supabase pelo navegador. Não precisa de build nem backend próprio.

## 1. Configurar o Supabase

1. No painel do projeto `hgvupkekywqezimctzri`, abra **SQL Editor** e rode o conteúdo de `schema.sql` (pode rodar de novo mesmo que já tenha rodado antes — os comandos são seguros para reexecutar).
2. Vá em **Storage > New bucket** e crie um bucket chamado `documentos` (privado).
3. Vá em **Authentication > Users > Add user** e crie seu usuário (e-mail e senha) — é com ele que você vai logar no app. Não existe tela de cadastro público.
4. Confira em **Project Settings > API** se a chave usada no `index.html` (`sb_publishable_...`) continua sendo a chave pública (anon) do projeto.

Agora o acesso exige login: as tabelas e o bucket só aceitam leitura/gravação de usuários autenticados.

## 2. Publicar no GitHub

```
git add .
git commit -m "vX.Y.Z - descrição da mudança"
git push
```

## 3. Hospedar no Cloudflare Workers

1. No painel da Cloudflare, crie um novo projeto do tipo **Workers/Pages** conectado ao repositório `reffehcsoibaf/saude`.
2. Como é um site puramente estático, configure o build sem comando de build (ou "Static Assets"), servindo a raiz do repositório.
3. A cada `git push` na branch principal, a Cloudflare publica a nova versão automaticamente.

## Versionamento

Cada mudança relevante é registrada em `CHANGELOG.md`, seguindo `MAJOR.MINOR.PATCH`. O número da versão atual também aparece no rodapé da página.
