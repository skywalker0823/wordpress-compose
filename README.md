* wordpress+mariaDB+nginx with docker-compose

1. 最終簡化為腳本sh 會自動幫環境安裝 git與 docker compose
2. 啟動腳本-> 詢問資訊與數量(開頭詢問數量並入變數)建立 .env -> 檢查 git -> clone repo -> 安裝 compose -> 啟動 (穿插檢查 dig 指向是否設置)

# 使用方式
1. 確保環境有安裝 docker-compose