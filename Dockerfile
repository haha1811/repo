# 使用 Ubuntu 20.04 作為基底映像檔
FROM ubuntu:20.04

# 設定環境變數，使得安裝軟體時不會出現互動式的選項。
ENV DEBIAN_FRONTEND=noninteractive

# 執行更新並安裝所需軟體包
RUN apt-get update && apt-get install -y apache2

# 將本機的 index.html 複製到 Docker 容器中的 Apache 網頁根目錄
COPY index.html /var/www/html/index.html

# 開放 80 端口，供 HTTP 流量進入
EXPOSE 80

# 啟動 Apache 伺服器並在前景模式中運行，確保容器持續運行
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
