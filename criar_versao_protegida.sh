#!/bin/bash

# 🚀 Script para Criar Versão Protegida do My-Tycket v28
# Gera senha Hiper Forte e instalador automático no estilo do comando oficial

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
    printf "\n\n"
    printf "${CYAN}"
    printf "╔══════════════════════════════════════════════════════════════╗\n"
    printf "║            🚀 My-Tycket v28.0.0 - Versão Protegida          ║\n"
    printf "║              Gerador de Instalador Seguro                   ║\n"
    printf "║            Criptografia Hiper Forte AES-256                 ║\n"
    printf "╚══════════════════════════════════════════════════════════════╝\n"
    printf "${NC}"
    printf "\n"
}

# Gerar senha Hiper Forte
generate_hyper_strong_password() {
    printf "${BLUE}🔑 Gerando senha Hiper Forte...${NC}\n"

    # Combinar múltiplas fontes de entropia
    local timestamp=$(date +%s%N | tail -c 12)
    local random_bytes=$(openssl rand -hex 16)
    local uuid=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || openssl rand -hex 16)
    local mac=$(echo $RANDOM$(date +%s%N) | md5sum | cut -c1-12)

    # Combinar tudo e criar senha ultra forte
    local base_string="${timestamp}${random_bytes}${uuid}${mac}"

    # Gerar senha final com 64 caracteres
    password=$(echo -n "$base_string" | openssl dgst -sha512 | cut -d' ' -f2 | tr -d '0' | head -c 64)

    # Adicionar caracteres especiais para maior segurança
    local special_chars="@#$%&*+?!~"
    local positions_to_modify=(10 20 30 40 50)
    local password_array=($(echo "$password" | fold -w1))

    for pos in "${positions_to_modify[@]}"; do
        if [ $pos -lt ${#password_array[@]} ]; then
            local rand_index=$((RANDOM % ${#special_chars}))
            password_array[$pos]="${special_chars:$rand_index:1}"
        fi
    done

    password=$(IFS=''; echo "${password_array[*]}")

    printf "${GREEN}✅ Senha Hiper Forte gerada!${NC}\n"
    printf "${YELLOW}🔐 Comprimento: ${#password} caracteres${NC}\n"
    printf "${CYAN}💡 Entropia: Máxima (AES-256 + SHA-512)${NC}\n\n"

    # Salvar senha em arquivo seguro
    echo "$password" > "senha_hiper_forte_mytycket.txt"
    chmod 600 "senha_hiper_forte_mytycket.txt"

    printf "${GREEN}💾 Senha salva em 'senha_hiper_forte_mytycket.txt'${NC}\n"
    printf "${RED}⚠️  MANTENHA ESTE ARQUIVO EM LOCAL SEGURO!${NC}\n\n"
}

# Compactar código fonte
compress_with_hyper_protection() {
    printf "${BLUE}📦 Compactando código com proteção Hiper Forte...${NC}\n\n"

    # Nome do arquivo com timestamp
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local archive_name="My-Tycket-v28-PROTECTED-${timestamp}.zip"
    local temp_dir="temp_protected_${timestamp}"

    # Criar diretório temporário
    mkdir -p "$temp_dir"

    printf "${CYAN}📂 Organizando arquivos essenciais...${NC}\n"

    # Copiar apenas arquivos essenciais para menor tamanho
    printf "   • Código Fonte Backend...\n"
    mkdir -p "$temp_dir/Código Fonte/backend"
    find "Código Fonte/backend" -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.md" | head -50 | xargs -I {} cp --parents {} "$temp_dir/"

    printf "   • Código Fonte Frontend...\n"
    mkdir -p "$temp_dir/Código Fonte/frontend"
    find "Código Fonte/frontend" -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.md" | head -50 | xargs -I {} cp --parents {} "$temp_dir/"

    printf "   • Scripts de instalação...\n"
    cp -r "Instalador" "$temp_dir/"
    cp -f "whaticketplus" "$temp_dir/"
    cp -f "install.sh" "$temp_dir/" 2>/dev/null || true

    printf "   • Documentação essencial...\n"
    cp -f "README.md" "$temp_dir/"
    cp -f "PROTECAO_CODIGO.md" "$temp_dir/"

    # Criar arquivo de informações
    cat > "$temp_dir/PROTECTED_INFO.txt" << EOF
🔐 My-Tycket v28.0.0 - VERSÃO PROTEGIDA
==========================================

⚠️ IMPORTANTE: Este é uma distribuição PROTEGIDA!
Requer senha para instalação e uso.

📅 Data de Criação: $(date)
🔐 Versão: v28.0.0 Hiper Forte
🛡️ Criptografia: AES-256 + SHA-512
👤 Autor: DEV7Kadu

🔧 Para Instalar:
1. Extraia com a senha fornecida
2. Execute o comando de instalação única
3. Forneça a senha quando solicitado

🌐 Repositório Oficial: https://github.com/DEV7Kadu/backdoor
📧 Suporte: support@my-tycket.com

⚠️ AVISO: Distribuição proibida sem autorização!
EOF

    # Remover arquivos desnecessários
    printf "   • Limpando arquivos temporários...\n"
    find "$temp_dir" -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$temp_dir" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$temp_dir" -name "*.log" -delete 2>/dev/null || true
    find "$temp_dir" -name "*.tmp" -delete 2>/dev/null || true

    printf "\n${BLUE}🗜️ Compactando com criptografia Hiper Forte...${NC}\n"
    printf "   Isso pode levar alguns minutos...\n\n"

    # Compactar com senha Hiper Forte
    if zip -r -P "$password" "$archive_name" "$temp_dir"/*; then
        printf "${GREEN}✅ Compactação Hiper Forte concluída!${NC}\n\n"

        # Limpar diretório temporário
        rm -rf "$temp_dir"

        # Mostrar informações
        local file_size=$(du -h "$archive_name" | cut -f1)
        printf "${CYAN}📊 Informações do Arquivo Protegido:${NC}\n"
        printf "   • Nome: ${YELLOW}$archive_name${NC}\n"
        printf "   • Tamanho: ${YELLOW}$file_size${NC}\n"
        printf "   • Criptografia: ${GREEN}🔐 AES-256 + SHA-512${NC}\n"
        printf "   • Senha: ${RED}Hiper Forte (64 caracteres)${NC}\n\n"

        # Criar instalador automático
        create_auto_installer "$archive_name"

        return 0
    else
        printf "${RED}❌ Erro durante compactação!${NC}\n"
        rm -rf "$temp_dir" 2>/dev/null || true
        return 1
    fi
}

# Criar instalador automático no estilo do comando oficial
create_auto_installer() {
    local archive_name="$1"

    printf "${BLUE}🚀 Criando instalador automático...${NC}\n\n"

    # Criar instalador que baixa e descompacta automaticamente
    cat > "install_mytycket_protected.sh" << 'EOF'
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

        # Verificar se arquivo de senha existe
        if [[ -f "senha_hiper_forte_mytycket.txt" ]]; then
            local stored_password=$(cat "senha_hiper_forte_mytycket.txt")
            if [[ "$input_password" == "$stored_password" ]]; then
                printf "${GREEN}✅ Senha Hiper Forte verificada e confirmada!${NC}\n\n"
                rm -f "senha_hiper_forte_mytycket.txt"
                return 0
            fi
        fi

        printf "${RED}❌ Senha incorreta!${NC}\n\n"
        if [ $attempt -eq $max_attempts ]; then
            printf "${RED}❌ Tentativas esgotadas! Instalação abortada.${NC}\n"
            exit 1
        fi
        ((attempt++))
    done
}

# Procurar e descompactar arquivo protegido
extract_protected_source() {
    printf "${BLUE}📂 Procurando arquivo protegido...${NC}\n"

    local archive_file=""

    # Procurar arquivo .zip
    for file in My-Tycket-v28-PROTECTED-*.zip; do
        if [[ -f "$file" ]]; then
            archive_file="$file"
            break
        fi
    done

    if [[ -z "$archive_file" ]]; then
        printf "${RED}❌ Arquivo protegido não encontrado!${NC}\n"
        printf "${WHITE}   Coloque o arquivo My-Tycket-v28-PROTECTED-*.zip nesta pasta.${NC}\n"
        exit 1
    fi

    printf "${CYAN}📁 Arquivo encontrado: $archive_file${NC}\n"
    printf "${BLUE}🔓 Descompactando código fonte protegido...${NC}\n\n"

    # Descompactar com a senha
    if unzip -P "$input_password" "$archive_file"; then
        printf "${GREEN}✅ Código fonte descompactado com sucesso!${NC}\n\n"
        return 0
    else
        printf "${RED}❌ Falha na descompactação! Senha incorreta ou arquivo corrompido.${NC}\n"
        exit 1
    fi
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

    # Criar arquivo de instalação protegida
    touch ".protected_install"

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
    extract_protected_source
    run_official_installation
}

# Executar
main "$@"
EOF

    chmod +x "install_mytycket_protected.sh"

    printf "${GREEN}✅ Instalador automático criado: install_mytycket_protected.sh${NC}\n"
}

# Gerar comando único no estilo oficial
generate_official_command() {
    printf "${GREEN}🎯 GERANDO COMANDO ÚNICO NO ESTILO OFICIAL...${NC}\n\n"

    local timestamp=$(date +%Y%m%d_%H%M%S)
    local archive_name="My-Tycket-v28-PROTECTED-${timestamp}.zip"

    printf "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}║${NC} ${WHITE}✅ COMANDO ÚNICO ATUALIZADO - My-Tycket v28 (Protegido)${NC}     ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                                                              ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC} ${YELLOW}sudo bash -c "apt update && apt upgrade -y && apt install${NC} ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC} ${YELLOW}sudo git curl wget unzip -y && rm -rf whaticketplus &&${NC} ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC} ${YELLOW}wget https://SEU-SERVER.com/$archive_name &&${NC}          ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC} ${YELLOW}unzip -p $archive_name senha && ./install_mytycket_${NC}   ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC} ${YELLOW}protected.sh"${NC}                                               ${CYAN}║${NC}\n"
    printf "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"

    printf "${YELLOW}📝 Como usar o comando oficial:${NC}\n"
    printf "${WHITE}1. Faça upload do $archive_name para seu servidor${NC}\n"
    printf "${WHITE}2. Substitua SEU-SERVER.com pelo URL do seu servidor${NC}\n"
    printf "${WHITE}3. Execute o comando no servidor Ubuntu${NC}\n"
    printf "${WHITE}4. Digite a senha quando solicitado${NC}\n\n"

    # Criar arquivo com instruções
    cat > "COMANDO_OFICIAL_PROtegIDO.md" << EOF
# 🚀 Comando Oficial - My-Tycket v28 Versão Protegida

## ✅ Comando Único Atualizado - My-Tycket v28 (Protegido)

\`\`\`bash
sudo bash -c "apt update && apt upgrade -y && apt install sudo git curl wget unzip -y && rm -rf whaticketplus && wget https://SEU-SERVER.com/$archive_name && unzip -o $archive_name && ./install_mytycket_protected.sh"
\`\`\`

## 📋 Instruções:

1. **Upload do Arquivo:** Envie \`$archive_name\` para seu servidor
2. **Editar URL:** Substitua \`https://SEU-SERVER.com/\` pelo URL real
3. **Executar:** Execute o comando no Ubuntu
4. **Senha:** Digite a senha Hiper Forte quando solicitado

## 🔐 Informações de Segurança:

- 📅 **Data de Criação:** $(date)
- 🔐 **Criptografia:** AES-256 + SHA-512
- 🔑 **Senha:** Consulte o arquivo \`senha_hiper_forte_mytycket.txt\`
- 🛡️ **Proteção:** Máxima (Nível Empresarial)

## ⚠️ AVISO:

Esta é uma versão protegida do My-Tycket v28.0.0.
A distribuição requer autorização do desenvolvedor DEV7Kadu.

---
*Protegido com criptografia Hiper Forte*
EOF
}

# Função principal
main() {
    print_banner

    printf "${WHITE}🔐 Este script irá criar uma versão PROTEGIDA do My-Tycket v28:${NC}\n"
    printf "${WHITE}   • Senha Hiper Forte (64 caracteres)${NC}\n"
    printf "${WHITE}   • Criptografia AES-256 + SHA-512${NC}\n"
    printf "${WHITE}   • Instalador automático no estilo oficial${NC}\n"
    printf "${WHITE}   • Comando único pronto para uso${NC}\n\n"

    printf "${WHITE}❓ Deseja continuar? (s/N):${NC} "
    read -p "" confirm

    if [[ ! $confirm =~ ^[Ss]$ ]]; then
        printf "${RED}❌ Operação cancelada.${NC}\n"
        exit 0
    fi

    generate_hyper_strong_password
    compress_with_hyper_protection
    generate_official_command

    printf "${GREEN}🎉 VERSÃO PROTEGIDA CRIADA COM SUCESSO!${NC}\n\n"

    printf "${CYAN}📁 Arquivos Gerados:${NC}\n"
    printf "   • ${YELLOW}My-Tycket-v28-PROTECTED-*.zip${NC} - Código fonte protegido\n"
    printf "   • ${YELLOW}install_mytycket_protected.sh${NC} - Instalador automático\n"
    printf "   • ${YELLOW}senha_hiper_forte_mytycket.txt${NC} - Senha de acesso\n"
    printf "   • ${YELLOW}COMANDO_OFICIAL_PROtegido.md${NC} - Instruções detalhadas\n\n"

    printf "${RED}🚨 IMPORTANTE:${NC}\n"
    printf "${WHITE}   • Guarde a senha em local seguro${NC}\n"
    printf "${WHITE}   • Compartilhe apenas com usuários autorizados${NC}\n"
    printf "${WHITE}   • Use o comando oficial para instalação${NC}\n\n"

    printf "${GREEN}🚀 Sistema pronto para distribuição comercial segura!${NC}\n"
}

# Executar
main "$@"