# Changelog

Todas as mudanças notáveis deste projeto são registradas aqui.
Formato de versão: MAJOR.MINOR.PATCH.

## v2.10.0
- Todas as tabelas (Histórico, Agenda, Documentos, Categorias, Prestadores) agora têm paginação padronizada, com botões Primeira / Anterior / Próxima / Última.
- Nova opção em Configurações para escolher a quantidade de itens exibidos por página (10, 25, 50, 100, 200 ou todos), aplicada a todas as tabelas.

## v2.9.0
- Categorias e Prestadores, na aba Configurações, agora são exibidos como tabelas (com cabeçalho "Nome" e coluna de ações), no mesmo padrão usado nas outras listas do app (Agenda, Documentos), em vez da lista de caixinhas anterior.

## v2.8.1
- Corrigido bug de fuso horário na Agenda: ao editar um agendamento, o campo de data/hora era preenchido com os dígitos brutos do horário UTC salvo no banco (sem converter para horário local), e ao gravar de novo esse valor errado era reinterpretado como local — resultado: cada edição avançava o horário em 3 horas.

## v2.8.0
- Botão **Gravar registro / Salvar edição** ganhou atalho `Alt+S`, funcionando mesmo com o foco em qualquer campo do formulário.
- Corrigida uma falha em `showStatus()`: a mensagem de confirmação (ex. "Registro gravado.") era escrita na região `aria-live` antes dela ficar visível, o que podia fazer o NVDA não anunciar o sucesso do lançamento mesmo tendo sido gravado.
- Removido texto redundante na introdução ("Uso do plano empresarial:") e nas legendas das tabelas de Agenda e Documentos, que apenas descreviam funcionalidades já visíveis nos próprios botões/caixas de verificação.

### Correções (mesma versão, sem funcionalidade nova)
- Reaplicada a checagem de módulo habilitado (`profiles_modulos`) em `entrarNoApp()`, perdida numa regressão acidental para a base da v2.7.0.
- Corrigido erro "Could not find the table 'public.prestadores'" ao adicionar/editar/remover categoria ou prestador: essas três funções chamavam `supabase.from(tabela)` sem o prefixo `saude_` usado em todo o resto do app.
- Trocado `accesskey="s"` por um atalho `Alt+S` via `keydown`: o `accesskey` sempre move o foco do leitor de tela para o botão antes de ativá-lo; o novo atalho grava sem mover o foco.
- O anúncio de sucesso ("Registro gravado." / "Edição salva.") ainda não estava sendo lido pelo NVDA mesmo depois da correção anterior. Criada uma região `aria-live` separada, permanentemente visível (nunca com `display:none`), só para esse anúncio — a caixinha visual de status seguia escondendo/mostrando ao mesmo tempo em que o texto mudava, o que o NVDA não captava de forma confiável.

## v2.7.0
- Lista de Documentos passou de cartões para **tabela** (colunas: Arquivo, Descrição, Ações), no mesmo padrão do Histórico e da Agenda.
- Removida a linha redundante "Pertence ao agendamento/procedimento" — essa informação já está na descrição.

## v2.6.0
- Botão **Editar** em cada agendamento na aba Agenda: preenche o formulário com os dados existentes, entra em modo edição ("Salvar edição" / "Cancelar edição") e atualiza o registro em vez de duplicar.
- Botão **Editar** (renomear) nas listas de Categorias e Prestadores, na aba Configurações.

## v2.5.1
- Campo "Usuário" (titular/dependente) também passou a ser lembrado entre lançamentos na mesma seção do navegador, junto com data, mês de referência, categoria e prestador.

## v2.5.0
- Data, mês de referência, categoria e prestador do formulário de Novo procedimento agora são lembrados entre lançamentos, enquanto a aba do navegador continuar aberta (usa `sessionStorage`).
- Novo campo de **anexo** na aba Novo procedimento: o documento enviado junto fica vinculado ao procedimento gravado.
- Documentos enviados pela aba Novo procedimento ou pela Agenda têm a descrição preenchida automaticamente informando a qual lançamento/evento pertencem, e a aba Documentos mostra esse vínculo.
- Adicionada coluna `procedimento_id` na tabela `documentos` (migração incluída no `schema.sql`, segura para rodar de novo).
- Filtro de vínculo na aba Documentos passou a considerar tanto agendamentos quanto procedimentos ("Vinculado a um lançamento" / "Avulso").

## v2.4.0
- Botão **Editar** em cada linha do Histórico: preenche o formulário de Novo procedimento com os dados existentes, muda para o modo edição ("Salvar edição" / "Cancelar edição") e grava como atualização (não cria duplicado).
- As métricas do Histórico agora somam apenas os **itens filtrados exibidos**, não mais o total geral de todos os registros.
- Adicionado o card **"Total do procedimento"** nas métricas, mostrando o valor de custo além da coparticipação.

## v2.3.0
- Novo campo **"Mês de referência"** em Novo procedimento (mês/ano da cobrança no extrato do plano, separado da data do procedimento em si).
- Coluna "Mês ref." adicionada na tabela do Histórico.
- Novo filtro por mês de referência na aba Histórico.
- Adicionada coluna `mes_referencia` na tabela `procedimentos` (migração incluída no `schema.sql`, segura para rodar de novo).

## v2.2.0
- Adicionado filtro na aba **Agenda**: por data, categoria, prestador, status (agendado/realizado) e busca livre.
- Adicionado filtro na aba **Documentos**: busca livre (nome do arquivo, descrição, categoria do agendamento vinculado) e filtro por vínculo (vinculado a um agendamento ou avulso).

## v2.1.2
- Corrigido bug em que a mensagem "Documento adicionado" (sucesso) aparecia mesmo quando o envio do arquivo falhava por trás — ela sobrescrevia a mensagem de erro real na mesma caixinha antes que desse pra lê-la. Agora o sucesso só é mostrado se o upload de fato funcionou.
- Mesmo ajuste no anexo enviado pela aba Agenda: se o agendamento for gravado mas o anexo falhar, o aviso deixa isso claro em vez de dizer que deu tudo certo.

## v2.1.1
- Corrigido "permission denied for table documentos" (e possíveis erros semelhantes nas outras tabelas): faltavam os `GRANT` de tabela para o role `authenticated` — o RLS por si só não é suficiente, o Postgres também exige a permissão de acesso à tabela.
- Mensagens de erro agora ficam fixas na tela até serem fechadas, com `role="alert"` (leitura imediata por leitor de tela) e botão "Copiar mensagem".
- Removida a repetição de "Logado como e-mail" — mostrado uma vez no topo, sem instrução de login ficar aparecendo depois de autenticado.

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
