# Implantação de Impressora via Microsoft Intune

Este repositório documenta a estratégia de implantação automatizada e silenciosa da impressora multifuncional em estações Windows 10/11 gerenciadas pelo Microsoft Intune.

A solução foi projetada para cenários onde os notebooks e a impressora compartilham a mesma rede local (LAN/Wi-Fi). Ela cria uma porta TCP/IP local e instala o driver oficial diretamente no dispositivo, eliminando a dependência de servidores de impressão.

## 📂 Organização do Repositório

Para o correto funcionamento do empacotamento, a estrutura de arquivos deve seguir este padrão:

```text
├── README.md                          # Esta documentação explicativa
├── instalar_impressora.ps1               # Script de instalação executado como SYSTEM
├── detectar_impressora.ps1               # Script de validação da instalação para o Intune
├── IntuneWinAppUtil.exe               # Utilitário oficial de empacotamento da Microsoft
└── pasta do driver da impressora/   # Pasta contendo os arquivos oficiais do Driver da impressora
     └── 64bit/
          └── OEMSETUP.INF             # Arquivo de diretivas do driver
```

---

## 📦 Como Gerar o Pacote `.intunewin`

Para gerar o arquivo de instalação aceito pelo Intune de forma automatizada, siga os passos abaixo:

1. Abra o terminal do PowerShell como **Administrador**.
2. Execute o comando de empacotamento silencioso (substitua `SEU_USUARIO` pelo seu nome de usuário real no Windows):

```powershell
\$PastaOrigem  = "C:\Users\SEU_USUARIO\Desktop\Instalar_impressora"
\$ArquivoSetup = "instalar_impressora.ps1"
PastaDestino = PastaOrigem
ToolPath = "PastaOrigem\IntuneWinAppUtil.exe"

Start-Process -FilePath \$ToolPath -ArgumentList "-c `"$PastaOrigem`"", "-s `"$ArquivoSetup`"", "-o `"$PastaDestino`"", "-q" -NoNewWindow -Wait
```

3. Um arquivo chamado **`instalar_impressora.intunewin`** será gerado dentro da pasta.

---

## 🚀 Configuração no Microsoft Intune Admin Center

Crie um novo aplicativo do tipo **Windows app (Win32)**, faça o upload do arquivo `.intunewin` gerado e preencha as etapas conforme abaixo:

### 1. Programa (Program)
* **Install command:** `powershell.exe -ExecutionPolicy Bypass -File instalar_impressora.ps1`
* **Uninstall command:** `powershell.exe -Command "Remove-Printer -Name 'Nome da Impressora'"`
* **Install behavior:** **System** *(Obrigatório: Usuários padrão não possuem privilégios para instalar drivers no repositório do Windows)*

### 2. Requisitos (Requirements)
* **Operating system architecture:** x64
* **Minimum operating system:** Windows 10 21H2 (ou superior)

### 3. Regras de Detecção (Detection Rules)
* **Rules format:** Use a custom detection script
* **Script file:** Selecione o arquivo `detectar_impressora.ps1`
* **Run script as 32-bit process on 64-bit clients:** No
* **Enforce script signature check:** No

### 4. Atribuição (Assignments)
* Vincule o aplicativo como **Required** (Obrigatório) para o grupo de dispositivos ou usuários alvo.
