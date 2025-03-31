# WordPress 多站點 Docker-Compose 部署

## 目標

使用 Docker-Compose 建立多個 WordPress 網站，透過 Nginx 反向代理並使用 MariaDB 作為資料庫，確保環境隔離與快速建置。

GitHub Repository: [https://github.com/skywalker0823/wordpress-compose.git](https://github.com/skywalker0823/wordpress-compose.git)

---

## 1. 前置準備

### 必要條件
- 確保 VM 主機開啟 80 port
- SSH 私鑰
- 網站域名數個
- 資料庫資訊（名稱、使用者、密碼）
- 安裝 Docker 與 Docker-Compose

### 安裝 Docker 與 Docker-Compose（RHEL/CentOS）可參考腳本執行

```bash
# 移除舊版本
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

# 安裝 Docker
sudo yum install -y docker

# 啟用 Docker Engine
sudo systemctl start docker
sudo systemctl enable docker

# 安裝 Docker-Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 備用: docker-compose for CentOS7 安裝, CentOS7是熱門老版本, 應該很多資訊
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 若出現找不到 docker-compose 指令，執行以下指令：
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 驗證安裝
docker --version
docker-compose --version
```

---

## 2. DNS 設置

1. 進入 DNSPOD 或其他 DNS 供應商後台
2. 設定 A 記錄，將域名指向 VM 主機 IP（@ & www）
3. 測試是否指向成功：

```bash
dig your-domain.com
```

應顯示剛剛設置的 IP。

---

## 3. 建置 WordPress 多站點環境

```bash
git clone https://github.com/skywalker0823/wordpress-compose.git
cd wordpress-compose
sh setup.sh  # 輸入對應參數
docker-compose up -d
```

---

## 4. 確認部署成功

1. 存取設定的域名，檢查是否成功
2. 透過 `docker ps -a` 查看容器狀態，確認 `Up time` 是否持續增加

```bash
docker ps -a
```

---

## 目錄與檔案說明

| 檔案名稱     | 內容說明 |
|--------------|----------|
| `nginx.conf` | Nginx 設定檔 |
| `.env`       | 環境變數檔案，包含資料庫資訊 |
| `init.sql`   | 資料庫初始化 SQL |

---

## 重建環境

如需重建環境，建議全部刪除後重新部署。

```bash
docker-compose down -v  # 移除所有容器與資料卷
docker-compose up -d    # 重新啟動
```

---

## 參考資料

- [Docker 官方文件](https://docs.docker.com/)
- [Docker-Compose 官方文件](https://docs.docker.com/compose/)
- [CentOS Docker 安裝指南](https://docs.docker.com/engine/install/centos/)
- CentOS 7 Source
```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.vpnforgame.net/centos/7/CentOS-Base.repo

curl -o /etc/yum.repos.d/epel.repo http://mirrors.vpnforgame.net/epel/7/epel.repo

yum clean all

yum makecache
```
