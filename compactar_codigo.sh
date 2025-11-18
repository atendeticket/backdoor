#!/bin/bash

# 🗜️ Script para Compactar Código Fonte com Senha
# My-Tycket v28.0.0 - Proteção de Código Fonte
# Autor: DEV7Kadu

set -e

# Cores para output
readonly NC="\033[0m"
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'

# Banner
print_banner() {
    clear
    printf "\n\n"
    printf "${CYAN}"
    printf "╔══════════════════════════════════════════════════════════════╗\n"
    printf "║                🔐 My-Tycket v28.0.0                        ║\n"
    printf "║              Compactador Seguro de Código                   ║\n"
    printf "║            Proteja seu código fonte com senha               ║\n"
    printf "╚══════════════════════════════════════════════════════════════╝\n"
    printf "${NC}"
    printf "\n"
}

# Verificar se zip está instalado
check_dependencies() {
    printf "${BLUE}🔍 Verificando dependências...${NC}\n"

    if ! command -v zip &> /dev/null; then
        printf "${RED}❌ 'zip' não está instalado. Instalando...${NC}\n"
        sudo apt update && sudo apt install -y zip unzip
    fi

    if ! command -v openssl &> /dev/null; then
        printf "${RED}❌ 'openssl' não está instalado. Instalando...${NC}\n"
        sudo apt update && sudo apt install -y openssl
    fi

    printf "${GREEN}✅ Dependências OK!${NC}\n\n"
}

# Gerar senha segura ou usar senha fornecida
generate_password() {
    local use_custom=false
    local custom_password=""

    printf "${WHITE}🔐 Escolha uma opção para a senha:${NC}\n"
    printf "${YELLOW}1)${NC} Gerar senha automática (recomendado)\n"
    printf "${YELLOW}2)${NC} Digitar senha manualmente\n\n"
    read -p "Digite sua escolha (1 ou 2): " choice

    case $choice in
        1)
            # Gerar senha segura automática
            password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
            printf "${GREEN}🔑 Senha gerada automaticamente:${NC}\n"
            printf "${CYAN}$password${NC}\n\n"

            printf "${WHITE}💾 Deseja salvar a senha em um arquivo? (s/N):${NC} "
            read -p "" save_password

            if [[ $save_password =~ ^[Ss]$ ]]; then
                echo "$password" > "senha_instalacao.txt"
                printf "${GREEN}✅ Senha salva em 'senha_instalacao.txt'${NC}\n"
                printf "${RED}⚠️  MANTENHA ESTE ARQUIVO EM LOCAL SEGURO!${NC}\n\n"
            fi
            ;;
        2)
            while true; do
                printf "${WHITE}🔑 Digite a senha para compactação (mín. 8 caracteres):${NC}\n"
                read -s -p "> " password
                printf "\n"

                if [[ ${#password} -lt 8 ]]; then
                    printf "${RED}❌ Senha muito curta! Mínimo 8 caracteres.${NC}\n"
                    continue
                fi

                printf "${WHITE}🔑 Confirme a senha:${NC}\n"
                read -s -p "> " password_confirm
                printf "\n\n"

                if [[ "$password" == "$password_confirm" ]]; then
                    printf "${GREEN}✅ Senha confirmada!${NC}\n\n"
                    break
                else
                    printf "${RED}❌ Senhas não conferem! Tente novamente.${NC}\n\n"
                fi
            done
            ;;
        *)
            printf "${RED}❌ Opção inválida! Usando senha automática.${NC}\n"
            password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
            ;;
    esac
}

# Compactar código fonte
compress_source() {
    printf "${BLUE}📦 Iniciando compactação do código fonte...${NC}\n\n"

    # Nome do arquivo compactado
    local archive_name="my-tycket-v28-src-$(date +%Y%m%d_%H%M%S).zip"
    local temp_dir="temp_compress_$(date +%s)"

    # Criar diretório temporário
    mkdir -p "$temp_dir"

    printf "${CYAN}📂 Organizando arquivos para compactação...${NC}\n"

    # Copiar arquivos essenciais para o diretório temporário
    printf "   • Copiando código fonte...\n"
    cp -r "Código Fonte" "$temp_dir/"

    printf "   • Copiando instalador...\n"
    cp -r "Instalador" "$temp_dir/"

    printf "   • Copiando scripts principais...\n"
    cp -f "install.sh" "$temp_dir/" 2>/dev/null || true
    cp -f "whaticketplus" "$temp_dir/" 2>/dev/null || true

    printf "   • Copiando documentação...\n"
    cp -f "*.md" "$temp_dir/" 2>/dev/null || true

    printf "   • Removendo arquivos desnecessários...\n"
    # Remover node_modules e outros arquivos grandes
    find "$temp_dir" -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$temp_dir" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$temp_dir" -name "*.log" -delete 2>/dev/null || true
    find "$temp_dir" -name "*.tmp" -delete 2>/dev/null || true

    # Criar arquivo com informações
    cat > "$temp_dir/INFO.txt" << EOF
🔐 My-Tycket v28.0.0 - Código Fonte Protegido
=================================================

Data de Compactação: $(date)
Versão: v28.0.0
Autor: DEV7Kadu

⚠️ IMPORTANTE: Este arquivo está protegido por senha!
Use a senha fornecida durante a instalação.

Para instalar:
1. Extraia o arquivo com a senha
2. Execute o script de instalação
3. Forneça a senha quando solicitado

🔧 Repositório Oficial: https://github.com/DEV7Kadu/backdoor
EOF

    printf "\n${BLUE}🗜️ Compactando com senha...${NC}\n"
    printf "   Isso pode levar alguns minutos...\n\n"

    # Compactar com senha usando zip
    if zip -r -P "$password" "$archive_name" "$temp_dir"/*; then
        printf "${GREEN}✅ Compactação concluída com sucesso!${NC}\n\n"

        # Limpar diretório temporário
        rm -rf "$temp_dir"

        # Mostrar informações do arquivo
        local file_size=$(du -h "$archive_name" | cut -f1)
        printf "${CYAN}📊 Informações do arquivo:${NC}\n"
        printf "   • Nome: ${YELLOW}$archive_name${NC}\n"
        printf "   • Tamanho: ${YELLOW}$file_size${NC}\n"
        printf "   • Proteção: ${GREEN}🔐 Senha ativa${NC}\n\n"

        # Criar script de instalação modificado
        create_secure_installer "$archive_name"

        printf "${GREEN}🎉 Código fonte protegido com sucesso!${NC}\n"
        printf "${WHITE}📝 Arquivo criado: ${YELLOW}$archive_name${NC}\n"
        printf "${WHITE}🔐 Senha: ${CYAN}$password${NC}\n\n"

        printf "${RED}⚠️  AVISO IMPORTANTE:${NC}\n"
        printf "${WHITE}   • Guarde a senha em local seguro!${NC}\n"
        printf "${WHITE}   • Não compartilhe o arquivo .zip com terceiros!${NC}\n"
        printf "${WHITE}   • Mantenha backup da senha!${NC}\n\n"

    else
        printf "${RED}❌ Erro durante compactação!${NC}\n"
        rm -rf "$temp_dir" 2>/dev/null || true
        exit 1
    fi
}

# Criar instalador seguro
create_secure_installer() {
    local archive_name="$1"

    cat > "install_secure.sh" << 'EOF'
#!/bin/bash

# 🔐 Instalador Seguro - My-Tycket v28.0.0
# Requer senha para descompactação do código fonte

set -e

# Cores
readonly NC="\033[0m"
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'

# Banner
print_banner() {
    clear
    printf "\n\n"
    printf "${CYAN}"
    printf "╔══════════════════════════════════════════════════════════════╗\n"
    printf "║                🔐 My-Tycket v28.0.0                        ║\n"
    printf "║              Instalador Seguro Protegido                    ║\n"
    printf "║           Código Fonte Criptografado por Senha               ║\n"
    printf "╚══════════════════════════════════════════════════════════════╝\n"
    printf "${NC}"
    printf "\n"
}

# Solicitar senha
request_password() {
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        printf "${WHITE}🔐 Digite a senha para descompactação (Tentativa $attempt/$max_attempts):${NC}\n"
        read -s -p "> " password
        printf "\n"

        # Verificar senha (aqui você implementaria a verificação real)
        # Por enquanto, apenas aceitamos a senha
        if [[ ${#password} -ge 8 ]]; then
            printf "${GREEN}✅ Senha aceita!${NC}\n\n"
            echo "$password"
            return 0
        else
            printf "${RED}❌ Senha inválida!${NC}\n"
            if [ $attempt -eq $max_attempts ]; then
                printf "${RED}❌ Número máximo de tentativas atingido!${NC}\n"
                exit 1
            fi
            ((attempt++))
        fi
    done
}

# Descompactar código
extract_source() {
    local password="$1"
    local archive_file=""

    # Procurar arquivo .zip
    for file in *.zip; do
        if [[ -f "$file" ]]; then
            archive_file="$file"
            break
        fi
    done

    if [[ -z "$archive_file" ]]; then
        printf "${RED}❌ Nenhum arquivo .zip encontrado!${NC}\n"
        printf "${WHITE}   Coloque o arquivo .zip na mesma pasta que este script.${NC}\n"
        exit 1
    fi

    printf "${BLUE}📂 Descompactando arquivo: ${YELLOW}$archive_file${NC}\n"

    # Tentar descompactar com senha
    if unzip -P "$password" "$archive_file"; then
        printf "${GREEN}✅ Código fonte descompactado com sucesso!${NC}\n\n"

        # Continuar com instalação normal
        if [[ -f "whaticketplus" ]]; then
            printf "${BLUE}🚀 Iniciando instalação...${NC}\n"
            chmod +x whaticketplus
            ./whaticketplus
        else
            printf "${RED}❌ Script de instalação não encontrado!${NC}\n"
            exit 1
        fi
    else
        printf "${RED}❌ Senha incorreta ou arquivo corrompido!${NC}\n"
        exit 1
    fi
}

# Main
main() {
    print_banner

    printf "${YELLOW}⚠️  AVISO: Este instalador requer senha para acesso ao código fonte.${NC}\n"
    printf "${WHITE}   Certifique-se de ter a senha fornecida pelo desenvolvedor.${NC}\n\n"

    password=$(request_password)
    extract_source "$password"
}

main "$@"
EOF

    chmod +x "install_secure.sh"
    printf "${GREEN}✅ Instalador seguro criado: install_secure.sh${NC}\n\n"
}

# Função principal
main() {
    print_banner

    printf "${YELLOW}🔐 Este script irá compactar todo o código fonte com senha.${NC}\n"
    printf "${WHITE}   Isso protege seu código e requer senha para instalação.${NC}\n\n"

    printf "${WHITE}❓ Deseja continuar? (s/N):${NC} "
    read -p "" confirm

    if [[ ! $confirm =~ ^[Ss]$ ]]; then
        printf "${RED}❌ Operação cancelada pelo usuário.${NC}\n"
        exit 0
    fi

    check_dependencies
    generate_password
    compress_source

    printf "${GREEN}🎉 Processo concluído!${NC}\n"
    printf "${WHITE}📁 Arquivos criados:${NC}\n"
    printf "   • ${YELLOW}*.zip${NC} - Código fonte compactado e protegido\n"
    printf "   • ${YELLOW}install_secure.sh${NC} - Instalador que solicita senha\n"
    printf "   • ${YELLOW}senha_instalacao.txt${NC} - Senha (se optou por salvar)\n\n"
}

# Executar
main "$@"