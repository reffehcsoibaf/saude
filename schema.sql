-- Schema do app "Controle do Plano de Saúde"
-- Execute este script no SQL Editor do Supabase (projeto hgvupkekywqezimctzri)

create extension if not exists pgcrypto;

-- Listas gerenciáveis --------------------------------------------------
create table if not exists categorias (
  id uuid primary key default gen_random_uuid(),
  nome text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists prestadores (
  id uuid primary key default gen_random_uuid(),
  nome text not null unique,
  created_at timestamptz not null default now()
);

-- Procedimentos (aba Histórico) -----------------------------------------
create table if not exists procedimentos (
  id uuid primary key default gen_random_uuid(),
  data date not null,
  mes_referencia date,
  usuario text not null check (usuario in ('titular','dependente')),
  categoria text not null,
  prestador text not null,
  cobranca_tipo text not null check (cobranca_tipo in ('percentual','fixo','isento')),
  valor_procedimento numeric(10,2) not null default 0,
  valor_coparticipacao numeric(10,2) not null default 0,
  observacoes text,
  pago boolean not null default false,
  created_at timestamptz not null default now()
);

alter table procedimentos add column if not exists mes_referencia date;

-- Agenda ------------------------------------------------------------------
create table if not exists agenda (
  id uuid primary key default gen_random_uuid(),
  data_hora timestamptz not null,
  categoria text not null,
  prestador text not null,
  endereco text,
  observacoes text,
  realizado boolean not null default false,
  created_at timestamptz not null default now()
);

-- Documentos ----------------------------------------------------------------
create table if not exists documentos (
  id uuid primary key default gen_random_uuid(),
  nome_arquivo text not null,
  descricao text,
  storage_path text not null,
  agenda_id uuid references agenda(id) on delete set null,
  created_at timestamptz not null default now()
);

-- Storage: crie manualmente um bucket chamado "documentos" (privado)
-- em Storage > New bucket no painel do Supabase.

-- Permissões de tabela (GRANT) -----------------------------------------------
-- O RLS controla QUAIS linhas cada policy libera, mas o Postgres também exige
-- permissão de acesso à tabela em si. Sem isso dá "permission denied for table".
grant usage on schema public to authenticated;
grant select, insert, update, delete on categorias, prestadores, procedimentos, agenda, documentos to authenticated;

-- RLS -----------------------------------------------------------------------
-- Este app agora exige login (Supabase Auth). Só usuários autenticados
-- conseguem ler e gravar. Crie o(s) usuário(s) em Authentication > Users
-- (não há tela de cadastro público no app).
alter table categorias enable row level security;
alter table prestadores enable row level security;
alter table procedimentos enable row level security;
alter table agenda enable row level security;
alter table documentos enable row level security;

drop policy if exists "anon full access" on categorias;
drop policy if exists "anon full access" on prestadores;
drop policy if exists "anon full access" on procedimentos;
drop policy if exists "anon full access" on agenda;
drop policy if exists "anon full access" on documentos;
drop policy if exists "authenticated full access" on categorias;
drop policy if exists "authenticated full access" on prestadores;
drop policy if exists "authenticated full access" on procedimentos;
drop policy if exists "authenticated full access" on agenda;
drop policy if exists "authenticated full access" on documentos;

create policy "authenticated full access" on categorias for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "authenticated full access" on prestadores for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "authenticated full access" on procedimentos for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "authenticated full access" on agenda for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "authenticated full access" on documentos for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Políticas do bucket de arquivos (Storage) ----------------------------------
-- Necessárias para o upload/leitura/remoção de anexos funcionar.
-- Rode isso depois de criar o bucket "documentos".
drop policy if exists "authenticated read documentos" on storage.objects;
drop policy if exists "authenticated upload documentos" on storage.objects;
drop policy if exists "authenticated update documentos" on storage.objects;
drop policy if exists "authenticated delete documentos" on storage.objects;

create policy "authenticated read documentos"
  on storage.objects for select
  using (bucket_id = 'documentos' and auth.role() = 'authenticated');

create policy "authenticated upload documentos"
  on storage.objects for insert
  with check (bucket_id = 'documentos' and auth.role() = 'authenticated');

create policy "authenticated update documentos"
  on storage.objects for update
  using (bucket_id = 'documentos' and auth.role() = 'authenticated');

create policy "authenticated delete documentos"
  on storage.objects for delete
  using (bucket_id = 'documentos' and auth.role() = 'authenticated');

-- Categorias sugeridas (pode editar/apagar depois pela aba Configurações)
insert into categorias (nome) values
  ('Consulta'), ('Exame'), ('Internação'), ('Cirurgia'), ('Micro-cirurgia'),
  ('Terapia'), ('Limpeza'), ('Extração'), ('Análise'),
  ('Fisioterapia'), ('Psicoterapia'), ('Nutricionista'), ('Vacina'),
  ('Fonoaudiologia'), ('Odontologia'), ('Pronto-socorro'), ('Retorno')
on conflict (nome) do nothing;
