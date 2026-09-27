# bookzin-site

O site do Bookzin (https://bookzin.com.br): HTML simples, sem build, publicado pelo GitHub Pages —
o mesmo jeito do site do Max IPTV. Montado em 23/09/2026, antes do domínio existir. Domínio `bookzin.com.br` comprado pelo Edu em 27/09/2026 (no Registro.br, no nome dele).

| página | pra quê |
|---|---|
| `/` | apresentação do app |
| `/privacidade/` | política de privacidade — a App Store exige a URL (texto: `legal/` no repositório do app) |
| `/suporte/` | ajuda e contato — a App Store exige a URL de suporte |
| `/club/CODIGO` | convite do clube (é o `404.html`: o GitHub Pages manda pra ele todo endereço que não existe) |

## ⚠️ Antes de publicar

1. **Preencher os campos em amarelo** (`<mark class="pendente">`), que só o Edu sabe:
   responsável (nome ou razão social + CPF/CNPJ), e-mail de contato, data de vigência, idade
   mínima (sugestão: 13) e os prazos de cópia de segurança do Supabase. Estão em
   `privacidade/index.html` e `suporte/index.html` (`grep -rn pendente`).
2. **Domínio**: o `CNAME` diz `bookzin.com.br`. Se for outro, trocar ali e em todo `https://bookzin.com.br`.
3. "Esqueci minha senha" (em `/suporte/`) só funciona pra todo mundo depois do SMTP próprio no
   Supabase — o e-mail embutido só escreve pra quem é do projeto.

## Publicar

1. Repositório público `BookzinOficial/bookzin-site` com estes arquivos.
2. GitHub → Settings → Pages → branch `main`, pasta `/`.
3. No DNS do domínio — **Registro.br → bookzin.com.br → DNS → Editar zona** (o domínio usa o
   DNS do próprio Registro.br, não precisa de Cloudflare): quatro registros A do GitHub Pages
   (185.199.108.153, .109.153, .110.153, .111.153) e CNAME `www` → `bookzinoficial.github.io`.
   Depois, em Pages, marcar "Enforce HTTPS".

## Depois

- **Convite do clube com link https**: o app hoje manda só o código (o WhatsApp não deixa
  clicável um `bookzin://`). Com o site no ar, a mensagem (`mensagemDoConvite`, no contrato)
  pode levar `https://bookzin.com.br/club/CODIGO`.
- **Abrir o app direto pelo link** (Universal Links): precisa do Developer Program — arquivo
  `/.well-known/apple-app-site-association` aqui e o "Associated Domains" no app.
- `og.png` sai de `swift tools/GerarOG.swift`.
