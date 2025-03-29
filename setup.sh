#!/bin/bash

# 詢問要建立幾個 WordPress 實例
read -p "請輸入要建立幾個 WordPress 站台 (1-5): " wp_count

# 建立 .env 文件
echo "MYSQL_ROOT_PASSWORD=rootpassword" > .env

# 初始化 init.sql
echo "-- 資料庫初始化腳本" > init.sql

# 為每個 WordPress 實例收集資訊並寫入設定
for (( i=1; i<=$wp_count; i++ ))
do
    echo "設定第 $i 個 WordPress 站台:"
    read -p "請輸入資料庫名稱 (預設: wordpress$i): " db_name
    db_name=${db_name:-wordpress$i}
    
    read -p "請輸入資料庫使用者名稱 (預設: user$i): " db_user
    db_user=${db_user:-user$i}
    
    read -p "請輸入資料庫密碼 (預設: password$i): " db_password
    db_password=${db_password:-password$i}
    
    # 寫入 .env
    echo "DB_NAME_$i=$db_name" >> .env
    echo "DB_USER_$i=$db_user" >> .env
    echo "DB_PASSWORD_$i=$db_password" >> .env
    echo "WORDPRESS_PORT_$i=808$i" >> .env

    # 寫入 init.sql
    cat >> init.sql << EOL
-- 資料庫 $i
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'%' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%';

EOL
done

# 添加 FLUSH PRIVILEGES 到 init.sql
echo "FLUSH PRIVILEGES;" >> init.sql

# 生成 docker-compose.yaml
cat > docker-compose.yaml << 'EOL'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
EOL

# 動態生成 WordPress 服務配置
for (( i=1; i<=$wp_count; i++ ))
do
    echo "      - wordpress$i" >> docker-compose.yaml
done

echo "    restart: always" >> docker-compose.yaml

# 為每個 WordPress 實例添加服務配置
for (( i=1; i<=$wp_count; i++ ))
do
    cat >> docker-compose.yaml << EOL

  wordpress$i:
    image: wordpress
    restart: always
    ports:
      - \${WORDPRESS_PORT_$i}:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: \${DB_USER_$i}
      WORDPRESS_DB_PASSWORD: \${DB_PASSWORD_$i}
      WORDPRESS_DB_NAME: \${DB_NAME_$i}
    volumes:
      - wordpress$i:/var/www/html
EOL
done

# 添加資料庫服務配置
cat >> docker-compose.yaml << 'EOL'

  db:
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME_1}
      MYSQL_USER: ${DB_USER_1}
      MYSQL_PASSWORD: ${DB_PASSWORD_1}
    volumes:
      - db:/var/lib/mariadb
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

volumes:
EOL

# 添加 volumes 配置
for (( i=1; i<=$wp_count; i++ ))
do
    echo "  wordpress$i:" >> docker-compose.yaml
done
echo "  db:" >> docker-compose.yaml

# 生成 nginx.conf
> nginx.conf

# 收集域名
declare -a domains
for (( i=1; i<=$wp_count; i++ ))
do
    read -p "請輸入第 $i 個 WordPress 的域名 (預設: domain$i.com): " domain_name
    domains[$i]=${domain_name:-domain$i.com}
    
    cat >> nginx.conf << EOL
server {
    listen 80;
    server_name ${domains[$i]};

    location / {
        proxy_pass http://wordpress$i;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

EOL
done

echo "設定完成！請檢查 .env、docker-compose.yaml、nginx.conf 和 init.sql 檔案。"
chmod +x setup.sh
