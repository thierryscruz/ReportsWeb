# ReportsWeb

<p align="center">
  <img src="static/img/logo.png" alt="ReportsWeb Logo" width="180"/>
</p>

<p align="center">
  <strong>Plataforma moderna de relatórios web — substitui Crystal Reports com zero custo de licença</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flask-3.1-000000?style=for-the-badge&logo=flask&logoColor=white"/>
  <img src="https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white"/>
  <img src="https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white"/>
  <img src="https://img.shields.io/badge/IIS-0078D6?style=for-the-badge&logo=windows&logoColor=white"/>
</p>

---

## ✨ O que é o ReportsWeb?

O **ReportsWeb** é uma plataforma web desenvolvida em **Python/Flask** para substituir relatórios legados do **Crystal Reports** sem custo de licença. O sistema permite que administradores criem e configurem relatórios interativos via interface drag-and-drop, conectando-se a bancos de dados **Oracle** ou **SQL Server** existentes da empresa.

O executável é gerado com **PyInstaller** e publicado no **IIS** via `HttpPlatformHandler`, sem necessidade de instalar Python no servidor do cliente.

---

## 🚀 Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| 📊 **28 relatórios pré-configurados** | Estrutura pronta, basta inserir o SQL |
| 🖱️ **Designer drag-and-drop** | Reordene e configure colunas visualmente |
| 🔍 **Filtros dinâmicos** | Texto, data, select com SQL, checkbox |
| 📥 **Exportação Excel** | Export direto para `.xlsx` com um clique |
| 🖨️ **Impressão formatada** | Layout de impressão dedicado com logo da empresa |
| 👥 **Multi-usuário** | Controle de acesso com perfis ADMIN e USUARIO |
| 🔌 **Multi-banco** | Oracle e SQL Server via variáveis de ambiente |
| 🔒 **Código protegido** | Distribuição como executável compilado (sem `.py`) |

---

## 🏗️ Arquitetura

```
ReportsWeb/
├── dist/
│   └── RelAcessoApp/          ← Pasta entregue ao cliente
│       ├── RelAcessoApp.exe   ← Executável principal (Flask + Waitress)
│       ├── web.config         ← Configuração IIS + credenciais do banco
│       ├── instance/          ← Banco SQLite interno (usuários, config)
│       └── logs/              ← Logs do IIS
│
└── examples/
    └── sqlserver/             ← Exemplos prontos para SQL Server
        ├── 01_schema.sql      ← DDL — cria as tabelas
        ├── 02_seed_data.sql   ← Dados fictícios para demonstração
        ├── 03_reports_queries.sql ← SQLs dos 28 relatórios
        └── README.md          ← Guia de uso
```

---

## ⚙️ Configuração (web.config)

Toda a configuração de banco de dados é feita via variáveis de ambiente no `web.config`, **sem alterar o executável**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <system.webServer>
    <handlers>
      <add name="HttpPlatformHandler" path="*" verb="*"
           modules="httpPlatformHandler" resourceType="Unspecified" />
    </handlers>
    <httpPlatform processPath=".\RelAcessoApp.exe"
                  stdoutLogEnabled="true"
                  stdoutLogFile=".\logs\flask.log">
      <environmentVariables>
        <environmentVariable name="PORT" value="%HTTP_PLATFORM_PORT%" />

        <!-- Escolha: 'oracle' ou 'sqlserver' -->
        <environmentVariable name="DB_TYPE" value="sqlserver" />

        <!-- SQL Server -->
        <environmentVariable name="MSSQL_SERVER"   value="localhost" />
        <environmentVariable name="MSSQL_DATABASE" value="ReportsWebDemo" />
        <environmentVariable name="MSSQL_USER"     value="sa" />
        <environmentVariable name="MSSQL_PASSWORD" value="SUA_SENHA" />

        <!-- Oracle (alternativo) -->
        <!-- <environmentVariable name="ORA_USER"     value="RELATORIO" /> -->
        <!-- <environmentVariable name="ORA_PASSWORD" value="SUA_SENHA" /> -->
        <!-- <environmentVariable name="ORA_DSN"      value="servidor:1521/SID" /> -->
      </environmentVariables>
    </httpPlatform>
  </system.webServer>
</configuration>
```

---

## 📦 Implantação no IIS (passo a passo)

1. **Instale o [HttpPlatformHandler](https://www.iis.net/downloads/microsoft/httpplatformhandler)** no servidor
2. **Copie** a pasta `dist\RelAcessoApp` para o servidor (ex: `C:\inetpub\wwwroot\Relatorios`)
3. **Crie** as pastas `instance\` e `logs\` ao lado do `.exe`
4. **Configure** o `web.config` com as credenciais do banco de dados
5. **No IIS Manager**: Adicionar Site ou Aplicativo apontando para a pasta copiada
6. **Acesse** `http://servidor/` e faça login com `admin` / `admin123`
7. **Troque a senha** do admin imediatamente após o primeiro acesso

---

## 🗄️ Exemplos SQL Server

Quer testar rapidamente? Temos exemplos completos prontos:

👉 **[Ver exemplos SQL Server](./examples/sqlserver/README.md)**

Os exemplos incluem um banco de demonstração de **Vendas e Estoque** com:
- Schema completo (tabelas, índices, constraints)
- ~5.000 registros fictícios para demonstração
- SQL dos 28 relatórios adaptados para SQL Server

---

## 🔐 Segurança

- Senhas de usuários armazenadas com **bcrypt** (hash + salt)
- Credenciais de banco via **variáveis de ambiente** (nunca no executável)
- Sessões gerenciadas pelo **Flask-Login**
- Banco interno SQLite separado dos dados de negócio

---

## 📋 Pré-requisitos do Servidor

| Requisito | Versão |
|---|---|
| Windows Server | 2016+ |
| IIS | 8.5+ |
| HttpPlatformHandler | 1.2+ |
| SQL Server | 2014+ / Azure SQL |
| .NET Framework | 4.6+ (para HttpPlatformHandler) |

> O Python **não** precisa ser instalado no servidor — tudo está embutido no executável.

---

## 📄 Licença

Este projeto é distribuído como software proprietário. O código-fonte não está disponível publicamente.
Os exemplos SQL na pasta `examples/` são de uso livre (MIT).

---

## 👤 Autor

**Thierry Santos Cruz**
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/thieryscruz)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/thieryscruz)
