if (Get-Printer -Name "Nome da Impressora" -ErrorAction SilentlyContinue) {
    Write-Output "Instalada"
    Exit 0
} else {
    Exit 1
}
