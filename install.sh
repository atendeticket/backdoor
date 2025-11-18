#!/bin/bash

# WhatiTicket Plus - Script de Instalação Automática v3.0.2
# Instalação direta sem menus - Com todas as correções

echo "🚀 WhatiTicket Plus - Instalação Automática v3.0.2"
echo "=================================================="
echo ""

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Este script precisa ser executado como root (sudo)"
   echo "   Use: sudo ./install.sh"
   exit 1
fi

# Verificar se o instalador unificado existe
INSTALLER_PATH="$(dirname "$0")/Instalador/install_unificado"

if [[ ! -f "$INSTALLER_PATH" ]]; then
    echo "❌ Instalador não encontrado em: $INSTALLER_PATH"
    echo "Por favor, verifique se o arquivo existe."
    exit 1
fi

# Dar permissão de execução se necessário
if [[ ! -x "$INSTALLER_PATH" ]]; then
    echo "🔧 Dando permissão de execução ao instalador..."
    chmod +x "$INSTALLER_PATH"
fi

# Configurar variáveis de ambiente para instalação automática
export AUTO_INSTALL_MODE=true
export INSTALL_MODE=standard
export SKIP_MENUS=true
export INSTALL_CHOICE=1

echo "📋 Modo: Instalação Automática (Sem Interação)"
echo "🔧 Todas as correções v3.0.2 já aplicadas:"
echo "   ✅ URL Duplicada Corrigida"
echo "   ✅ SSL Autoassinado com Fallback"
echo "   ✅ ESLint Frontend Resolvido"
echo "   ✅ Scripts de Manutenção Incluídos"
echo ""

# Executar o instalador unificado em modo automático
echo "🚀 Iniciando instalação automática..."
echo "   (Serão usadas configurações padrão seguras)"
echo ""

# Usar expect ou here document para automação robusta
if command -v expect >/dev/null 2>&1; then
    # Usar expect se disponível (mais robusto)
    expect << EOF
spawn $INSTALLER_PATH
expect "Selecione o modo de instalação:"
send "1\r"
expect eof
EOF
else
    # Fallback: criar arquivo temporário com input
    echo "1" > /tmp/install_input.txt
    "$INSTALLER_PATH" "$@" < /tmp/install_input.txt
    rm -f /tmp/install_input.txt
fi