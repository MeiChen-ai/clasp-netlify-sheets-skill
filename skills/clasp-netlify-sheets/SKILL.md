---
name: clasp-netlify-sheets
description: Clasp 雲端部署 + Google Sheets 資料庫 + Netlify MCP 零複製雙向閉環網頁系統指南（含學生教學引導與避坑 SOP）。當使用者提到「安裝 Netlify」「連接 Netlify」「設定 Netlify」「連接 Google Sheets」「把試算表當資料庫」「接 Apps Script」「clasp 登入」「做網頁表單存進試算表」「網頁前端 + Google Sheets + Netlify」「Clasp 部署」時自動啟用。
---

# Clasp 雲端部署 + Netlify MCP 零複製雙向閉環系統（教學與自動化實作指南）

> 來源整合：[clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide) 與 [clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)  
> 核心精神：**「程式碼與部署交給 AI 自動完成，學生/使用者只負責 3 次關鍵點擊授權與實測驗證。」**

---

## 🎯 你的角色與教學引導原則

你面對的使用者多半是**學生、老師或沒有後端工程背景的創作者**。請嚴格遵守以下互動原則：

1. **半自動教學步調**：
   - 寫程式、建設定檔、跑 CLI、改網址、推上雲端全部由你代勞。
   - 遇到需要使用者本人操作的 **3 個關鍵節點**（① 開啟 GAS API 開關、② 瀏覽器 OAuth 登入與權限審閱、③ 無痕視窗實測），**必須停下來用白話文講清楚步驟，等使用者回覆完成後再繼續**。
2. **Windows PowerShell 環境相容**：
   - 在 Windows 執行指令時，**不要用 `&&` 串接指令**（舊版 PowerShell 會報錯），請分步執行或改用 `;`。
   - 在 Windows PowerShell 中，請一律加上 `.cmd` 副檔名執行 **`npx.cmd -y @google/clasp ...`**（若只打 `npx` 會呼叫 `npx.ps1`，容易被 Windows 系統的預設指令碼執行原則 `PSSecurityException` 阻擋）。

---

## 🔴 七條硬性安全與避坑紅線（必守）

1. **敏感金鑰絕不落地程式碼**：
   - **嚴禁**將 `NETLIFY_PERSONAL_ACCESS_TOKEN`、`GITHUB_TOKEN` 或任何 OAuth 憑證寫入前端/後端程式碼或提交至公開 Git Repo。
   - 所有 API 網址與 `siteId` 必須在部署期間動態生成並注入。
2. **Google 登入必選「個人 Gmail」**：
   - 執行 `clasp login` 前，**主動提醒學生選擇個人 `@gmail.com` 帳號**，千萬不要選學校（`.edu.tw`）或公司的 Workspace 帳號，否則會被管理員政策（`admin_policy_enforced`）擋下且學生無法自行解開。
3. **學生隱私與去識別化**：
   - 試算表與網頁表單**不要放真實姓名、身分證字號、電話、住址**，請引導改用「班級代號、座號、暱稱或流水號」。
4. **強制建立 `.claspignore` 隔離前端檔案**：
   - 執行 `clasp push` 前，專案根目錄**必須**有 `.claspignore` 排除所有前端網頁檔（`index.html`, `*.css`, 前端 `app.js`），只允許推送後端 GAS 腳本與 `appsscript.json`，否則 GAS 雲端會因找不到瀏覽器 DOM 而崩潰（`ReferenceError: document is not defined`）。
5. **嚴禁自行拼接 GAS Web App 網址**：
   - `scriptId`、`parentId`、`deploymentId` 是三個完全不同的 ID。**絕對不准**拿 `scriptId` 去拼 `https://script.google.com/macros/s/<id>/exec`（100% 會顯示「網頁不存在」）。
   - 一律使用 `npx @google/clasp open-web-app <deploymentId> --json` 取得真實的 `webApp.url`。
6. **Netlify MCP 必先建站再部署**：
   - 不可直接對未知網站呼叫 `deploy-site`（會拋出 `ENOENT: ... state.json` 錯誤）。必須先呼叫 `create-new-project` 取得系統配發的 `site_id`，再將 `siteId` 與前端資料夾路徑傳給 `deploy-site`。
7. **卡關兩次即提退路（保住作品優先）**：
   - 若 `clasp login` 或授權在同一錯誤連續失敗兩次，不要無限重試，主動向學生提供退路：「clasp 自動通道卡住了，我們換手動貼上方案——我把程式碼整理好，你直接貼到 `script.google.com` 一樣能完成作品！」

---

## 🧭 階段一：環境檢查與工具安裝（Netlify + Clasp）

當學生要求「安裝/連接 Netlify 與 Google Sheets」或開始新專案時，依序執行以下檢查：

### Step 0：檢查本機環境與開啟 Google Apps Script API
1. **檢查 Node.js**：執行 `node --version`（`clasp v3` 需要 **Node.js 20 以上**）。若未安裝或版本過舊，引導安裝 Node.js LTS。
2. **🔑【學生動作 1】開啟 Google Apps Script API 開關**：
   - 這是全班最常卡關的第 1 名！請先向學生說明並提供連結：
     > 「請先點開 [Google Apps Script 使用者設定頁面](https://script.google.com/home/usersettings)，用你的**個人 Gmail** 登入，把 **『Google Apps Script API』切換為『開啟 (ON)』**。開完後大約要等 1～2 分鐘生效，開好請跟我說！」

### Step 1：安裝與驗證 Netlify MCP
1. **檢查連線**：嘗試呼叫 `netlify-user-services-reader` 檢查目前是否已綁定 Netlify 帳號。
2. **若尚未安裝或未授權**：
   - 引導學生登入 [Netlify](https://app.netlify.com/) ➔ 點選右上角頭像 **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ 點擊 **New access token** 產生一組 Token。
   - 取得學生提供的 Token 後，協助寫入 AntiGravity 全域設定檔 `~/.gemini/config/mcp_config.json`（注意 JSON 內不可有註解）：
     ```json
     {
       "mcpServers": {
         "netlify": {
           "command": "npx",
           "args": ["-y", "@netlify/mcp"],
           "env": {
             "NETLIFY_PERSONAL_ACCESS_TOKEN": "<貼上學生的_TOKEN>"
           }
         }
       }
     }
     ```
   - 提醒學生重啟 AntiGravity（或重新載入 MCP），再次呼叫 `netlify-user-services-reader` 確認顯示使用者的 Netlify 帳號資訊。

### Step 2：Clasp 安裝與 Google 雲端授權
1. 在專案目錄執行本地安裝（或在後續指令統一使用 `npx @google/clasp`）：
   ```powershell
   npm install @google/clasp
   ```
2. **🔑【學生動作 2】完成 Google OAuth 登入（⚠️ 必勾「全選」權限）**：
   - 啟動前先提醒：
     > 「等一下會產生一串授權網址，點開後：  
     > 1. **請務必選擇你剛剛開好 API 的個人 Gmail 帳號**。  
     > 2. 在『選擇 clasp 可以存取的內容』畫面中，**務必勾選最上方的『全選 (Select all)』打勾方塊**（Google 預設不會幫你打勾，若沒勾直接按繼續，後續建專案會報 `Request had insufficient authentication scopes.` 權限不足錯誤）！」
   - 執行登入：
     ```powershell
     npx.cmd -y @google/clasp login
     ```
   - 從終端機輸出抓取 `🔑 Authorize clasp by visiting this url: ...` 連結，完整貼給學生點擊授權。
3. **驗證登入狀態与權限 Scope**（必須用 v3 指令）：
   ```powershell
   npx.cmd -y @google/clasp show-authorized-user --json
   ```
   確認印出學生的個人 Gmail 即代表連線成功。

---

## 📁 階段二：本地專案標準檔案準備（零敏感資料）

在推送雲端前，Agent 必須先在專案工作區建立乾淨的前後端分離結構：

```text
my-project/
├── .claspignore          ← 【必備】阻擋前端檔案推上 GAS
├── appsscript.json       ← 【必備】GAS Web App 匿名存取設定
├── gas_code.js           ← 後端 GAS 試算表讀寫 API
└── web/                  ← 前端靜態網頁資料夾（準備部署至 Netlify）
    ├── index.html
    ├── style.css
    └── app.js            ← 預留 GAS_API_URL 佔位符
```

### 1. `.claspignore`（避坑核心，缺一不可）
只允許推送 `gas_code.js` 與 `appsscript.json`，忽略所有前端與 Node 檔案：
```gitignore
**/**
!gas_code.js
!appsscript.json
```

### 2. `appsscript.json`（開放匿名 API 存取）
必須配置 `webapp` 欄位，讓前端網頁可以免登入呼叫 API：
```json
{
  "timeZone": "Asia/Taipei",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "webapp": {
    "executeAs": "USER_DEPLOYING",
    "access": "ANYONE_ANONYMOUS"
  }
}
```

### 3. `gas_code.js`（後端試算表 API 標準範本）
包含 `doGet(e)` 與 `doPost(e)`，使用 `ContentService` 回傳 JSON：
```javascript
function getSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName("資料表") || ss.getSheets()[0];
  return sheet;
}

function doGet(e) {
  const sheet = getSheet();
  const data = sheet.getDataRange().getValues();
  return ContentService
    .createTextOutput(JSON.stringify({ status: "success", data: data }))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    const sheet = getSheet();
    const body = JSON.parse(e.postData.contents);
    sheet.appendRow([new Date(), ...(body.row || [])]);
    return ContentService
      .createTextOutput(JSON.stringify({ status: "success" }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

### 4. `web/app.js`（前端連線注意 CORS 避坑）
- 預留 `const GAS_API_URL = "YOUR_GAS_API_URL_HERE";`。
- ⚠️ **跨域 POST 避坑**：從 Netlify 前端 `fetch` POST 到 GAS Web App 時，`Content-Type` 請設為 `'text/plain;charset=utf-8'`（不要設 `application/json`，否則瀏覽器發送 OPTIONS 預檢請求會被 GAS 擋下導致 CORS 錯誤）：
  ```javascript
  const GAS_API_URL = "YOUR_GAS_API_URL_HERE";

  async function sendData(rowArray) {
    const res = await fetch(GAS_API_URL, {
      method: "POST",
      headers: { "Content-Type": "text/plain;charset=utf-8" },
      body: JSON.stringify({ row: rowArray })
    });
    return await res.json();
  }
  ```

---

## 🚀 階段三：完整自動化閉環部署步驟

檔案準備好後，依序執行以下步驟完成雲端與前端串接：

### Step 1：創建雲端 GAS 與 Google Sheets 專案
先確認目錄下沒有舊的 `.clasp.json`（避免誤蓋既有專案），接著執行：
- **建立獨立腳本並由 GAS 自動建表（最穩定、最推薦，100% 避開 Drive API Internal Error）**：
  ```powershell
  npx.cmd -y @google/clasp create-script --title "專案資料庫" --type standalone
  ```
  *(搭配 `gas_code.js` 中的 `SpreadsheetApp.create()` + `PropertiesService` 自動建立並綁定試算表)*
- **或直接新建試算表並綁定**：
  ```powershell
  npx.cmd -y @google/clasp create-script --type sheets --title "專案資料庫"
  ```
- **或綁定學生現有的試算表**：
  ```powershell
  npx.cmd -y @google/clasp create-script --title "專案資料庫" --parentId "<試算表網址中間的ID>"
  ```

### Step 2：確認 `appsscript.json` 並強制推送與發佈 Web App
⚠️ **避坑關鍵**：Step 1 執行 `clasp create-script` 時，Clasp 會自動將雲端預設的 `appsscript.json`（不含 `webapp` 設定）拉回本地覆蓋！因此推送前**務必再次寫入/確認 `appsscript.json` 內含有 `"webapp": { "executeAs": "USER_DEPLOYING", "access": "ANYONE_ANONYMOUS" }`**，接著執行：
```powershell
npx.cmd -y @google/clasp push -f
npx.cmd -y @google/clasp create-deployment --description "Production Web App"
```

### Step 3：🔑【學生動作 3】首次執行權限審閱（Authorization Required）
因為腳本會讀寫 Google Sheets，Google 規定擁有者必須在瀏覽器手動授權一次，否則外部呼叫 API 會回傳權限錯誤：
1. 執行 `npx.cmd -y @google/clasp open-script` 幫學生打開線上編輯器（或從 `.clasp.json` 的 `scriptId` 提供 `https://script.google.com/d/<scriptId>/edit` 連結）。
2. **停下來向學生說明**：
   > 「請點開剛剛的 Apps Script 編輯器網頁：  
   > 1. 在上方工具列確認選取 `getSheet`（或任一函式），點擊 **『▷ 執行 (Run)』**。  
   > 2. 跳出需要授權時，點 **『審閱權限 (Review permissions)』** ➔ 選你的個人 Gmail。  
   > 3. 會看到警告『Google 尚未驗證這個應用程式』，⚠️ **千萬不要點右下角的藍色大按鈕「返回安全頁面 (Back to safety)」**（點了會取消授權並出現 `Warning: This project requires access to your Google Account to run`）！  
   > 4. 請點左下角小小的灰色字 **『進階 (Advanced)』** ➔ 再點最底下 **『前往專案（不安全）(Go to ... unsafe)』** ➔ **勾選全選並點『繼續 / 允許 (Continue / Allow)』**。  
   > 完成後跟我說一聲，我們就準備實測網站！」

### Step 4：動態獲取與注入真實 API 網址
1. 查詢部署清單取得 `<deploymentId>`：
   ```powershell
   npx @google/clasp list-deployments
   ```
2. **用官方 JSON 介面取出真實網址（嚴禁自行拼湊）**：
   ```powershell
   npx @google/clasp open-web-app <deploymentId> --json
   ```
3. 將回傳的 `url`（結尾為 `/exec`）自動替換進前端 `web/app.js` 的 `GAS_API_URL` 中。

### Step 5：Netlify MCP 全自動網頁發佈
1. **先建立新站點**：呼叫 `netlify-project-services-updater` 工具：
   - `operation`: `"create-new-project"`
   - `params`: `{ "name": "<全小寫英數連字號網站名稱>" }`
   - 從回傳結果取得系統配發的 `site_id`。
2. **再部署前端資料夾**：呼叫 `netlify-deploy-services-updater` 工具：
   - `operation`: `"deploy-site"`
   - `params`: `{ "siteId": "<剛取得的_site_id>", "deployDirectory": "<前端_web_資料夾的絕對路徑>" }`

### Step 6：交付成果與無痕視窗實測驗證
部署完成後，整理以下資訊回報給學生，並**停下來請學生實測**：

```markdown
🎉 **前後端雙向閉環系統部署完成！**

- 🌐 **你的公開網頁（Netlify）**：<Netlify 公開網址>
- 📊 **你的後端資料庫（Google 試算表）**：https:// docs.google.com/spreadsheets/d/<parentId>/edit
- 🔗 **GAS API 端點**：<webApp.url>

### 🧪 請進行最後一步實測：
請打開瀏覽器的 **「無痕視窗（Incognito）」** 開啟上方的 Netlify 網址（使用無痕視窗可 100% 避開瀏覽器登入多個 Google 帳號造成的 Session 衝突），在網頁上送出一筆測試資料，並看看 Google 試算表有沒有即時跳出那筆資料！
```

---

## 🛠️ 四、五大經典踩坑排除表與 Clasp v3 對照表

### 五大經典踩坑與應變對策

| 踩坑編號 | 錯誤訊息 / 症狀 | 真正原因 | 標準應變對策 |
| :--- | :--- | :--- | :--- |
| **坑 1** | `User has not enabled the Apps Script API...` | Google 帳號未開啟 GAS API 或剛開尚未生效 | 引導至 [設定頁面](https://script.google.com/home/usersettings) 將 Google Apps Script API 切換為 **ON**，等待 1～2 分鐘後重試。 |
| **坑 2** | GAS 執行紀錄紅字：`ReferenceError: document is not defined (@ app.gs:5)` | 前端 JS 在 `.claspignore` 生效前被推上 GAS 雲端 | 1. 確認 `.claspignore` 已排除前端檔<br>2. 在 `gas_code.js` 加一行註解觸發變更偵測<br>3. 執行 `npx @google/clasp push -f` 完全覆寫雲端並刪除舊前端檔<br>4. 重新 `create-deployment` 並更新前端 API 網址。 |
| **坑 3** | 前端 fetch 報錯或打開 API 網址顯示「很抱歉，目前無法開啟這個檔案」 | 腳本使用了試算表服務但尚未完成首次擁有者授權 | 引導學生打開 GAS 線上編輯器，手動選取任一函式按「執行」，走完「審閱權限 ➔ 進階 ➔ 前往專案（不安全）➔ 允許」。 |
| **坑 4** | Netlify MCP 部署報錯：`ENOENT: no such file or directory, open '...state.json'` | 未指定有效 `siteId` 或未先建立 Site 就直接呼叫 `deploy-site` | 必須先呼叫 `netlify-project-services-updater` (`create-new-project`) 取得 `site_id`，再帶入 `deploy-site`。 |
| **坑 5** | 網頁載入偶發「連線至 Google Sheets 失敗」或跨網域重導向錯誤 | 瀏覽器同時登入學校與個人等多個 Google 帳號導致 GAS Session 混亂 | 請學生改用 **「無痕視窗（Incognito）」** 開啟 Netlify 網頁測試，即可 100% 解決。 |
| **坑 6** | `Request had insufficient authentication scopes.` | `clasp login` 時在 Google 授權畫面未勾選權限核取方塊就直接按「繼續」 | 執行 `npx.cmd -y @google/clasp logout` 後重新 `login`，提醒學生在授權畫面**務必勾選「全選 (Select all)」**再按繼續。 |

### Clasp v2 → v3 指令強制對照表（禁止使用舊指令）

| ❌ 舊版 v2 指令（已移除，勿用） | ✅ 新版 v3 指令（請一律使用） |
| :--- | :--- |
| `clasp create` | `clasp create-script` |
| `clasp clone` | `clasp clone-script` |
| `clasp open` | `clasp open-script` |
| `clasp deploy` | `clasp create-deployment` |
| `clasp deployments` | `clasp list-deployments` |
| `clasp undeploy` | `clasp delete-deployment` |
| `clasp status` | `clasp show-file-status` |
| `clasp login --status` | `clasp show-authorized-user` |
| *(手動拼網址)* | `clasp open-web-app <deploymentId> --json` |
