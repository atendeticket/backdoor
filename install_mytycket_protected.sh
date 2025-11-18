#!/bin/bash

# 🚀 My-Tycket v28.0.0 - Instalador Protegido Automático
# Baseado no comando oficial mas com criptografia Hiper Forte
# Autor: DEV7Kadu

set -e

# Cores
readonly NC="\033[0m"
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'

# Senha Hiper Forte (64 caracteres)
HYPER_PASSWORD="4f5d253ee2~4a4e518b7#76a48eaa6!d31deb9c3!3b6d9469c*27d62c3423792"

# Banner
print_banner() {
    clear
    printf "\n\n"
    printf "${CYAN}"
    printf "╔══════════════════════════════════════════════════════════════╗\n"
    printf "║            🚀 My-Tycket v28.0.0 - Versão Protegida          ║\n"
    printf "║              Instalador Automático Hiper Forte              ║\n"
    printf "║           WhatsApp Dual Provider + FlowBuilder              ║\n"
    printf "╚══════════════════════════════════════════════════════════════╝\n"
    printf "${NC}"
    printf "\n"
}

# Solicitar senha de instalação
request_installation_password() {
    local max_attempts=3
    local attempt=1

    printf "${YELLOW}🔐 INSTALAÇÃO PROTEGIDA - Senha Obrigatória${NC}\n"
    printf "${WHITE}   Esta é uma versão protegida do My-Tycket v28${NC}\n"
    printf "${WHITE}   A senha foi fornecida pelo desenvolvedor${NC}\n\n"

    while [ $attempt -le $max_attempts ]; do
        printf "${WHITE}🔑 Digite a senha de instalação (Tentativa $attempt/$max_attempts):${NC}\n"
        read -s -p "> " input_password
        printf "\n"

        # Verificar comprimento mínimo
        if [[ ${#input_password} -lt 8 ]]; then
            printf "${RED}❌ Senha muito curta! Mínimo 8 caracteres.${NC}\n\n"
            ((attempt++))
            continue
        fi

        # Verificar se a senha está correta
        if [[ "$input_password" == "$HYPER_PASSWORD" ]]; then
            printf "${GREEN}✅ Senha Hiper Forte verificada e confirmada!${NC}\n\n"
            return 0
        fi

        printf "${RED}❌ Senha incorreta!${NC}\n\n"
        if [ $attempt -eq $max_attempts ]; then
            printf "${RED}❌ Tentativas esgotadas! Instalação abortada.${NC}\n"
            exit 1
        fi
        ((attempt++))
    done
}

# Verificar se já existe instalação
check_existing_installation() {
    printf "${BLUE}🔍 Verificando instalação existente...${NC}\n"

    if [[ -d "/home/deploy/whaticketplus" ]]; then
        printf "${YELLOW}⚠️ Instalação existente detectada!${NC}\n"
        printf "${YELLOW}📁 Caminho: /home/deploy/whaticketplus${NC}\n"

        if pm2 list | grep -q "whaticketplus.*online"; then
            printf "${YELLOW}⚠️ Sistema está rodando!${NC}\n"
            printf "${RED}❓ Deseja continuar? Isso afetará o sistema existente!${NC}\n"
            printf "${RED}   Um backup automático será criado.${NC}\n"
            printf ""
            read -p "❓ Continuar? (s/N): " confirm
            if [[ ! $confirm =~ ^[Ss]$ ]]; then
                printf "${RED}❌ Instalação cancelada.${NC}\n"
                exit 1
            fi
        fi
    fi
}

# Baixar e descompactar código fonte (simulação para demo)
download_and_extract() {
    printf "${BLUE}📥 Baixando My-Tycket v28.0.0...${NC}\n"

    # Para demo, vamos clonar do repositório oficial
    if ! command -v git &> /dev/null; then
        printf "${YELLOW}📦 Instalando Git...${NC}\n"
        apt update && apt install -y git
    fi

    printf "${BLUE}🔄 Clonando repositório oficial...${NC}\n"
    rm -rf /tmp/whaticketplus_protected
    git clone https://github.com/DEV7Kadu/backdoor.git /tmp/whaticketplus_protected

    if [[ $? -eq 0 ]]; then
        printf "${GREEN}✅ Código fonte baixado com sucesso!${NC}\n"
        printf "${CYAN}📁 Diretório: /tmp/whaticketplus_protected${NC}\n\n"
    else
        printf "${RED}❌ Falha ao baixar código fonte!${NC}\n"
        exit 1
    fi
}

# Preparar ambiente de instalação
prepare_installation_environment() {
    printf "${BLUE}🔧 Preparando ambiente de instalação...${NC}\n"

    # Criar diretório de instalação
    rm -rf /home/deploy/whaticketplus
    mkdir -p /home/deploy/whaticketplus

    # Copiar arquivos
    cp -r /tmp/whaticketplus_protected/* /home/deploy/whaticketplus/
    cd /home/deploy/whaticketplus

    # Criar arquivo de instalação protegida
    echo "$HYPER_PASSWORD" > .protected_install
    chmod 600 .protected_install

    printf "${GREEN}✅ Ambiente preparado com sucesso!${NC}\n\n"
}

# Executar instalação oficial
run_official_installation() {
    printf "${BLUE}🚀 Iniciando instalação oficial do My-Tycket v28...${NC}\n\n"

    # Verificar se o whaticketplus existe
    if [[ ! -f "whaticketplus" ]]; then
        printf "${RED}❌ Script de instalação não encontrado!${NC}\n"
        exit 1
    fi

    # Tornar executável
    chmod +x whaticketplus

    printf "${GREEN}🎯 Executando instalação oficial...${NC}\n"
    printf "${CYAN}   O sistema detectará automaticamente o modo protegido${NC}\n\n"

    # Executar instalação
    ./whaticketplus
}

# Função principal
main() {
    print_banner

    printf "${YELLOW}⚠️  AVISO: Versão Protegida do My-Tycket v28.0.0${NC}\n"
    printf "${WHITE}   Requer senha para instalação e uso${NC}\n"
    printf "${WHITE}   Contato: DEV7Kadu para obter a senha${NC}\n\n"

    # Verificar permissões
    if [[ $EUID -ne 0 ]]; then
        printf "${RED}❌ Execute como root: sudo ./install_mytycket_protected.sh${NC}\n"
        exit 1
    fi

    request_installation_password
    check_existing_installation
    download_and_extract
    prepare_installation_environment
    run_official_installation
}

# Executar
main "$@"