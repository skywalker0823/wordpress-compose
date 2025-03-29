* wordpress+mariaDB+nginx with docker-compose

# 前置條件
1. 域名指向本機 example.com -> a(www & @) record -> host_ip
2. 安裝 docker 與 docker-compose 可看官方文件安裝 or chatgpt
    * CentOS -> https://docs.docker.com/engine/install/centos/

3. 開啟 80 port(http)
4. clone https://github.com/skywalker0823/wordpress-compose.git

# 使用方式
cd wordpress-compose
1. 執行 setup.sh
   - 依照輸入指示自動帶入到以下檔案中
   - 會自動建立並帶入參數 nginx.conf, .env, init.sql
    * nginx.conf nginx的設定檔
    * .env 環境變數，資料庫相關資訊都會在這裡
    * init.sql 資料庫初始化的sql
2. 執行 docker-compose up -d
3. 若無錯誤，開啟瀏覽器，檢查是否成功