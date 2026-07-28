# Changelog

Todas as mudanças notáveis deste projeto são registradas aqui.
Formato de versão: MAJOR.MINOR.PATCH.

## v2.1.0
- Adicionada tela de login (Supabase Auth, e-mail e senha) — o app não abre mais sem autenticação.
- Políticas de acesso (RLS) das tabelas alteradas de "acesso anônimo" para "somente usuários autenticados".
- Adicionadas políticas de Storage para o bucket `documentos` (leitura, upload, edição e remoção), corrigindo o erro de permissão negada ao anexar arquivos.
- Botão "Sair" para encerrar a sessão.

## v2.0.0
- Migração completa de armazenamento local para **Supabase** (Postgres + Storage).
- App reorganizado em **5 abas** com navegação por teclado (Alt+1 a Alt+5): Novo procedimento, Histórico, Agenda, Documentos, Configurações.
- Aba **Novo procedimento**: campos data, usuário, categoria (combobox + botão de adicionar), prestador (combobox + botão de adicionar), cobrança (20%/fixo/isento), valor, coparticipação, observações.
- Aba **Histórico**: filtros por data, categoria, prestador, usuário, status (pago/em aberto) e busca livre; tabela com checkbox por linha para marcar pagamento.
- Nova aba **Agenda**: agendamento de consultas/exames com data e hora, categoria, prestador, endereço, anexo de documento e observações; checkbox para marcar como realizado.
- Nova aba **Documentos**: repositório de arquivos (exames, atestados, receitas) com adicionar, editar descrição e remover; documentos anexados pela Agenda aparecem vinculados ao respectivo evento.
- Nova aba **Configurações**: gerenciamento (remoção) de categorias e prestadores; exportação de backup em Excel (.xlsx) e importação de planilha de backup.
- Categorias sugeridas na criação do banco: Consulta, Exame, Internação, Cirurgia, Micro-cirurgia, Terapia, Limpeza, Extração, Análise, Fisioterapia, Psicoterapia, Nutricionista, Vacina, Fonoaudiologia, Odontologia, Pronto-socorro, Retorno.
- Reformulação de acessibilidade: rótulos `<label>` associados a cada campo com nomes curtos e diretos, `role="tablist"`/`tab`/`tabpanel`, `aria-live` para mensagens de status, link "pular para o conteúdo", textos alternativos em ícones de botão, tabelas com `<caption>` e cabeçalhos `<th scope>`.

## v1.3.0
- Reorganização da interface em três abas: Novo procedimento, Extrato, Filtros.

## v1.2.0
- Campo "Cobrança" com três modos: percentual (20%, editável), valor fixo e isento (trava o valor em zero).
- Histórico passa a exibir o tipo de cobrança aplicado em cada registro.

## v1.1.0
- Remoção do conceito de reembolso (plano não oferece reembolso).
- Adição do campo "Para quem" (titular ou dependente) em cada registro.
- Cálculo automático de coparticipação de 20% sobre o valor do procedimento.
- Métricas separadas de coparticipação por titular e por dependente.

## v1.0.0
- Primeira versão do app: registro de consultas, exames e procedimentos com data, prestador, descrição, valor pago, status de reembolso e valor reembolsado.
- Armazenamento local persistente (por usuário).
- Métricas de totais e histórico filtrável por tipo e status.
