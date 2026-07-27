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

-- Storage: crie manualmente um bucket chamado "documentos" (pode ser privado)
-- em Storage > New bucket no painel do Supabase.

-- RLS -----------------------------------------------------------------------
-- Este app usa a chave "publishable" (anon), sem login de usuário.
-- Isso significa que QUALQUER pessoa com a URL do site e a anon key
-- consegue ler e gravar nessas tabelas. Para uso pessoal (URL não divulgada)
-- isso costuma ser aceitável, mas fique ciente do risco.
alter table categorias enable row level security;
alter table prestadores enable row level security;
alter table procedimentos enable row level security;
alter table agenda enable row level security;
alter table documentos enable row level security;

create policy "anon full access" on categorias for all using (true) with check (true);
create policy "anon full access" on prestadores for all using (true) with check (true);
create policy "anon full access" on procedimentos for all using (true) with check (true);
create policy "anon full access" on agenda for all using (true) with check (true);
create policy "anon full access" on documentos for all using (true) with check (true);

-- Categorias sugeridas (pode editar/apagar depois pela aba Configurações)
insert into categorias (nome) values
  ('Consulta'), ('Exame'), ('Internação'), ('Cirurgia'), ('Micro-cirurgia'),
  ('Terapia'), ('Limpeza'), ('Extração'), ('Análise'),
  ('Fisioterapia'), ('Psicoterapia'), ('Nutricionista'), ('Vacina'),
  ('Fonoaudiologia'), ('Odontologia'), ('Pronto-socorro'), ('Retorno')
on conflict (nome) do nothing;
