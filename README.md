* For creating multiple wordpress sites with different domains and content.
* wordpress+mariaDB+nginx with docker-compose

# 前置條件
1. DNS record(optional) example.com -> a(www & @) record -> host_ip
2. Install docker 與 docker-compose from official docs or chatgpt
    * CentOS -> https://docs.docker.com/engine/install/centos/
3. Open port 80 for http
4. git clone https://github.com/skywalker0823/wordpress-compose.git
5. 自備域名,db名稱,db使用者名稱,db密碼

# 使用方式
cd wordpress-compose
1. 執行 setup.sh
   - 將會自動建立對應檔案並將參數帶入
   - 會自動建立並帶入參數 nginx.conf, .env, init.sql
    * nginx.conf nginx的設定檔
    * .env 環境變數，資料庫相關資訊都會在這裡
    * init.sql 資料庫初始化的sql
2. 執行 docker-compose up -d
3. docker ps -a 查看運行狀況 若 Up time 都持續增加大致上沒啥問題
3. 開啟瀏覽器，檢查是否成功

* PS:如要重建 建議全部刪掉比較快 🙂