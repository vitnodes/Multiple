#!/bin/bash

# Визначення кольорів для тексту
ORANGE='\033[0;33m'
TEAL='\033[0;36m'
LIME='\033[1;32m'
INDIGO='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Банер
cat << "EOF"
 /$$    /$$ /$$$$$$$  /$$   /$$ /$$   /$$ /$$$$$$$ 
| $$   | $$| $$__  $$| $$  | $$| $$  | $$| $$__  $$
| $$   | $$| $$  \ $$| $$  | $$| $$  | $$| $$  \ $$
|  $$ / $$/| $$  | $$| $$$$$$$$| $$  | $$| $$$$$$$ 
 \  $$ $$/ | $$  | $$| $$__  $$| $$  | $$| $$__  $$
  \  $$$/  | $$  | $$| $$  | $$| $$  | $$| $$  \ $$
   \  $/   | $$$$$$$/| $$  | $$|  $$$$$$/| $$$$$$$/
    \_/    |_______/ |__/  |__/ \______/ |_______/ 
                                                  
                                                  
EOF

# Головне меню
echo -e "\n${WHITE}╔════════════════════════╗${RESET}"
echo -e "${WHITE}║      МЕНЮ УПРАВЛІННЯ    ║${RESET}"
echo -e "${WHITE}╚════════════════════════╝${RESET}\n"

echo -e "${TEAL}[1]${RESET} ➜ Встановлення ноди"
echo -e "${TEAL}[2]${RESET} ➜ Перевірка статусу"
echo -e "${TEAL}[3]${RESET} ➜ Видалення ноди\n"

echo -e "${LIME}Оберіть опцію (1-3):${RESET} "
read choice

case $choice in
    1)
        echo -e "\n${INDIGO}▶ Починаємо встановлення ноди...${RESET}"

        # Оновлення системи
        echo -e "${TEAL}📦 Оновлення системних пакетів...${RESET}"
        sudo apt update && sudo apt upgrade -y

        # Визначення архітектури
        echo -e "${TEAL}🔍 Визначення архітектури системи...${RESET}"
        ARCH=$(uname -m)
        if [[ "$ARCH" == "x86_64" ]]; then
            CLIENT_URL="https://github.com/vitnodes/Multiple/blob/main/Multiple"
        elif [[ "$ARCH" == "aarch64" ]]; then
            CLIENT_URL="https://github.com/vitnodes/Multiple/blob/main/Multiple"
        else
            echo -e "${ORANGE}⚠ Непідтримувана архітектура: $ARCH${RESET}"
            exit 1
        fi

        # Завантаження клієнта
        echo -e "${TEAL}📥 Завантаження клієнта...${RESET}"
        wget $CLIENT_URL -O multipleforlinux.tar

        # Розпаковка
        echo -e "${TEAL}📂 Розпаковка файлів...${RESET}"
        tar -xvf multipleforlinux.tar
        cd multipleforlinux

        # Налаштування прав
        echo -e "${TEAL}🔧 Налаштування прав доступу...${RESET}"
        chmod +x ./multiple-cli
        chmod +x ./multiple-node

        # Налаштування PATH
        echo -e "${TEAL}⚙️ Налаштування змінних середовища...${RESET}"
        echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
        source ~/.bash_profile

        # Запуск ноди
        echo -e "${TEAL}🚀 Запуск ноди...${RESET}"
        nohup ./multiple-node > output.log 2>&1 &

        # Введення даних
        echo -e "${LIME}Введіть Account ID:${RESET}"
        read IDENTIFIER
        echo -e "${LIME}Введіть PIN:${RESET}"
        read PIN

        # Прив'язка акаунта
        echo -e "${TEAL}🔗 Прив'язка акаунта...${RESET}"
        ./multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100

        # Завершення
        echo -e "\n${LIME}✅ Встановлення успішно завершено!${RESET}"
        echo -e "\n${WHITE}Для перевірки статусу використовуйте:${RESET}"
        echo -e "${TEAL}cd ~/multipleforlinux && ./multiple-cli status${RESET}\n"
        
        sleep 2
        cd ~/multipleforlinux && ./multiple-cli status
        ;;

    2)
        echo -e "\n${INDIGO}🔍 Перевірка статусу ноди...${RESET}"
        cd ~/multipleforlinux && ./multiple-cli status
        ;;

    3)
        echo -e "\n${INDIGO}🗑 Видалення ноди...${RESET}"
        pkill -f multiple-node
        cd ~
        rm -rf multipleforlinux
        echo -e "${LIME}✅ Нода успішно видалена!${RESET}\n"
        ;;
        
    *)
        echo -e "${ORANGE}⚠ Помилка: оберіть число від 1 до 3${RESET}"
        ;;
esac
