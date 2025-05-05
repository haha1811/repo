# repo

你這個資料夾是 **用來練習在 GCP 上自動部署簡易網頁服務到 Cloud Run 的完整流程**，內容主要涵蓋以下重點：

---

## 🔍 你這個練習在做什麼？

你是透過 **Cloud Build CI/CD 流程**，當 GitHub 上 `main` 分支有 push 時，自動：

1. **Build**：建構一個 Docker image，內含 Apache 和 `index.html` 網頁。
2. **Push**：將這個映像檔推送到 GCP 的 **Artifact Registry**。
3. **Deploy**：把這個映像檔部署到 **Cloud Run**，並設定為可公開訪問。

---

## 📂 各檔案作用解析

### `cloudbuild.yaml`

Cloud Build 的部署腳本，共 3 個步驟：

1. 建構 Docker 映像檔（v03）
2. 推送映像到 Artifact Registry
3. 將映像部署到 Cloud Run，服務名稱為 `my-repo`

```yaml
images:
  - 'asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03'
```

---

### `Dockerfile`

定義如何產出該網頁服務的映像檔：

* 使用 Ubuntu 20.04 + Apache2
* 複製 `index.html` 到 `/var/www/html/index.html`
* 執行 Apache 作為前景程序

這代表部署後開啟服務網址，就會看到內容類似：

```
AP
V03
```

---

### `index.html`

靜態網頁，顯示：

```
AP
V03
```

這可能是為了測試 **版本更新與部署是否成功**，你可以用這個頁面內容來確認你部署的是哪一版。

---

### `trigger-config.yaml`

這是 Cloud Build 觸發器的設定檔，設定：

* **來源為 GitHub**，帳號是 `haha1811`、Repo 名為 `repo`
* 當 `main` 分支有 push，就會自動觸發部署流程（執行 `cloudbuild.yaml`）

這代表你當初是實作「**CI/CD 自動部署流程**」的練習。

---

## ✅ 結論：這是 Cloud Run 自動部署的 CI/CD 實作練習

你這份練習是完整實作：

* ✅ 使用 GitHub → Cloud Build Trigger → Build → Deploy Cloud Run
* ✅ 展示靜態網頁版本（V03）來驗證部署版本
* ✅ 使用 Artifact Registry 儲存 Docker 映像

---

需要我幫你寫一份這個實作的 `README.md` 記錄（可複製貼上到 HackMD）嗎？還是你想升級這份練習，加入像是版本號自動產生、自動修改 `index.html`、或 Cloud Run 自訂環境變數等功能？




當然可以，以下是一份清楚、結構化、適合貼上 HackMD 的 `README.md`，可作為你這個 Cloud Run 自動部署練習的完整技術紀錄：

---

```markdown
# 🚀 GCP Cloud Run CI/CD 自動部署練習紀錄

本練習示範如何透過 GCP Cloud Build + GitHub Push 自動部署 Docker 映像至 Cloud Run，並呈現版本資訊於靜態網頁中。

---

## 📦 專案結構

```

.
├── cloudbuild.yaml         # Cloud Build 建構與部署流程設定檔
├── Dockerfile              # Docker 映像建構設定（Apache + 靜態網頁）
├── index.html              # 部署網頁內容，含版本資訊
├── trigger-config.yaml     # Cloud Build 觸發器設定檔，連接 GitHub Push 事件
└── README.md               # 本說明檔

````

---

## 📌 實作目標

- ✅ 使用 GitHub Push 觸發 Cloud Build
- ✅ 自動建構 Docker 映像檔
- ✅ 推送映像至 Artifact Registry
- ✅ 自動部署至 Cloud Run（含公開訪問設定）
- ✅ 網頁顯示當前部署版本（例如：`V03`）

---

## 🔧 操作步驟說明

### 1️⃣ 建立 GitHub Repo 並上傳以下檔案
- `cloudbuild.yaml`
- `Dockerfile`
- `index.html`
- `trigger-config.yaml`（僅供建立 Cloud Build 觸發器時參考）

### 2️⃣ 建立 Cloud Build 觸發器

前往 GCP Console → **Cloud Build > Triggers**，選擇：
- **來源倉儲**：GitHub（使用 `haha1811/repo`）
- **條件**：當 `main` 分支有 Push 時觸發
- **建構檔案**：使用 `cloudbuild.yaml`

---

## 🔍 各檔案內容重點

### ✅ `cloudbuild.yaml`

```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03']
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: 'gcloud'
    args: [
      'run', 'deploy', 'my-repo',
      '--image', 'asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03',
      '--region', 'asia-east1',
      '--allow-unauthenticated',
      '--port', '80'
    ]

images:
  - 'asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03'
````

### ✅ `Dockerfile`

```dockerfile
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apache2
COPY index.html /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

### ✅ `index.html`

```html
AP
V03
```

此檔案為展示內容，部署後開啟網址即可看到「AP」與版本號 `V03`，可作為版本驗證用途。

---

## 🌐 Cloud Run 設定

* 部署服務名稱：`my-repo`
* 映像路徑：`asia-east1-docker.pkg.dev/lab-dev-421508/my-repo/ap:v03`
* 區域：`asia-east1`
* 權限：`--allow-unauthenticated`（公開可訪問）

---

## ✅ 成功部署後

你可以透過 Cloud Run 服務網址打開後，看到如下畫面代表成功：

```
AP
V03
```

如需升級版本，只要更新 `index.html`、修改 `v03` 為新版本，再 Push 一次即可自動重建部署。

---

## 🧠 延伸建議

| 項目          | 說明                                   |
| ----------- | ------------------------------------ |
| 🔁 自動版本編號   | 可使用 `SHORT_SHA` 或時間戳記自動替換版本號         |
| 🧪 加入健康檢查   | 可在部署後加入 Cloud Run 健康檢查機制             |
| 🌍 網域綁定     | 可綁定自有網域，搭配 HTTPS                     |
| 🔐 IAM 最小權限 | 建議為 Cloud Build 與 Cloud Run 指定最小必要權限 |
| 📄 自動產出版本頁面 | 使用 `sed` 自動寫入 `index.html` 版本資訊      |

---

## 🙋‍♂️ 作者註記

此專案作為 GCP Cloud Run 實戰練習，讓你熟悉：

* Docker 建構流程
* Artifact Registry 推送操作
* Cloud Build 自動部署流程
* Cloud Run 無伺服器架構部署實作

```

---

需要我幫你補一張 Cloud Run 架構圖（📦 Docker → 🔧 Cloud Build → ☁️ Cloud Run）來搭配這份說明嗎？
```



[![GCP Cloud Build 跨專案部署 | Use Cloud Build to deploy service to different ...](https://tse1.mm.bing.net/th?id=OIP.GUiS7Ij274UutiYeICMXdAHaFq\&cb=iwp1\&pid=Api)](https://andy51002000.blogspot.com/2020/05/gcp-cloud-build-use-cloud-build-to.html)

當然可以，以下是一張簡潔的 GCP Cloud Run 自動部署架構圖，展示了從原始碼提交到服務部署的整個流程：

---

### 🖼️ Cloud Run 自動部署架構圖

```plaintext
┌────────────┐
│  GitHub    │
│  (main 分支)│
└─────┬──────┘
      │ Push
      ▼
┌──────────────┐
│ Cloud Build  │
│ (Trigger)    │
└─────┬────────┘
      │
      ▼
┌──────────────────────────────┐
│ 步驟 1: 建構 Docker 映像檔    │
│ 步驟 2: 推送至 Artifact Registry │
│ 步驟 3: 部署至 Cloud Run        │
└─────┬────────────────────────┘
      │
      ▼
┌──────────────────────────────┐
│ Cloud Run 服務               │
│ (公開網址，提供 Web 服務)     │
└──────────────────────────────┘
```

---

### 🔧 流程說明

1. **GitHub Push**：當你將程式碼推送到 GitHub 的 `main` 分支時，會觸發 Cloud Build。

2. **Cloud Build**：根據 `cloudbuild.yaml` 的設定，執行以下步驟：

   * **建構映像檔**：使用 Dockerfile 建構映像檔。
   * **推送映像檔**：將建構好的映像檔推送到 Artifact Registry。
   * **部署至 Cloud Run**：使用 `gcloud run deploy` 將映像檔部署到 Cloud Run。

3. **Cloud Run 服務**：部署完成後，Cloud Run 會提供一個公開的網址，供使用者訪問你的 Web 服務。

---

這張架構圖清楚地展示了從程式碼提交到服務部署的自動化流程，適合用於技術文件、簡報或團隊分享。如果你需要更詳細的圖示或有其他需求，歡迎隨時告訴我！


