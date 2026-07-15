# ============================================================
#  altere as variáveis abaixo de acordo com o seu PC e arquivos antes de executar
# ============================================================

$appInstaller = "C:\Users\seu_usuario\Downloads\SeuApp_Setup.exe"         
$intuneUtil   = "C:\Users\seu_usuario\Downloads\IntuneWinAppUtil.exe"       
$tempDir      = "C:\Temp\seu_aplicativo"
$outputDir    = "C:\Temp\Output"                                            
$cmdScript    = "install_seu_aplicativo.cmd"                               
$exePath      = "C:\Program Files\seu_aplicativo\seu_aplicativo.exe"                                          

# ============================================================
#  não precisa alterar nada a partir daqui 
# ============================================================

# limpa execuções anteriores caso tenha

Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$outputDir\$cmdScript.intunewin" -Force -ErrorAction SilentlyContinue

# cria estrutura de pastas

New-Item -ItemType Directory -Path $tempDir   -Force
New-Item -ItemType Directory -Path $outputDir -Force

# copia o instalador para a pasta de trabalho

Copy-Item $appInstaller "$tempDir\" -Force

# faz o script de instalação .cmd silenciosa 

@"
@echo off
start /wait SeuApp_Setup.exe /S
timeout /t 60 /nobreak
if exist "$exePath" (
    exit /b 0
) else (
    exit /b 1
)
"@ | Set-Content -Path "$tempDir\$cmdScript" -Encoding ASCII

# verifica os arquivos na pasta

Get-ChildItem $tempDir

# vai gerar o pacote .intunewin

& $intuneUtil -c $tempDir -s $cmdScript -o $outputDir

## valida se os arquivos foram criados

Get-ChildItem $OutputDirectory
