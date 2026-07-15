# --- CONFIGURAÇÕES DA IMPRESSORA ---
$PrinterIP     = "192.168.xx.xx"  # <--- Altere para o IP fixo da sua impressora
$PrinterName   = "nome da impressora"
$DriverName    = "nome do driver da impressora"
$InfPath = "$PSScriptRoot\pasta do driver da impressora\64bit\OEMSETUP.INF"

# 1. Cria a porta TCP/IP local se não existir
$PortName = "IP_$PrinterIP"
if (-not (Get-PrinterPort -Name $PortName -ErrorAction SilentlyContinue)) {
    Add-PrinterPort -Name $PortName -PrinterHostAddress $PrinterIP
}

# 2. Injeta o driver OEMSETUP no repositório do Windows (PNPUtil)
pnputil.exe /add-driver $InfPath /install

# 3. Registra o driver no subsistema de impressão
if (-not (Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue)) {
    Add-PrinterDriver -Name $DriverName
}

# 4. Instala a impressora vinculando Driver e Porta
if (-not (Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue)) {
    Add-Printer -Name $PrinterName -DriverName $DriverName -PortName $PortName
}
