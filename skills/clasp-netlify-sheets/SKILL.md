---
name: clasp-netlify-sheets
description: AntiGravity 專用：Clasp 雲端部署 + Google Sheets 雙分頁自動建表資料庫 + Netlify MCP 零複製雙向閉環網頁系統指南（含第 8 週「B1/B2 單字兩段式提示練習網」與第 9 週「個人英文弱點前後測練習器 My Own English」標準範本、學生 3 次點擊教學引導與避坑 SOP）。當使用者提到「安裝 Netlify」「連接 Netlify」「設定 Netlify」「連接 Google Sheets」「把試算表當資料庫」「接 Apps Script」「clasp 登入」「做網頁表單存進試算表」「網頁前端 + Google Sheets + Netlify」「Clasp 部署」時自動啟用。
---

# AntiGravity × Clasp 雲端部署 + Google Sheets 自動建表 + Netlify MCP 零複製雙向閉環系統

> 來源整合：[clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide) 與 [clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)  
> 適用環境：**Google AntiGravity**（搭配課程 Cockpit 設計卡產生的 Prompt，不需 `AGENTS.md`）  
> 核心精神：**「程式碼、Google Sheets 分頁/欄位建立、題庫寫入與 Netlify 部署全部交給 AI 自動完成！學生完全不用手動開 Google 試算表建表格，只需負責 3 次瀏覽器點擊授權與實測驗證。」**

---

## 🎯 你的角色與分工原則（必守）

你面對的使用者是**英文系學生或老師（預設無後端工程背景）**。請嚴格遵守以下互動與自動化原則：

| 🙋‍♀️ 學生唯一要做的事（免手動建表） | 🤖 AntiGravity Agent 全自動完成的事 |
| :--- | :--- |
| ① 點開 `script.google.com/home/usersettings` 開啟 GAS API 開關（並準備 Netlify Token）<br>② 瀏覽器 `clasp login` 選個人 `@gmail.com` 並勾選 **全選 (Select all)**<br>③ 在 GAS 編輯器點一次 `▷ 執行 (Run)` ➔ **進階** ➔ **前往專案（不安全）** ➔ **允許** | 自動建立本地檔案與 `.claspignore`、自動建立 Google Sheets 試算表與雙分頁（題庫表＋作答紀錄表）、自動將學生設計卡上的 5 題內容預塞進試算表、抓取真實 `/exec` 網址注入前端、透過 Netlify MCP 自動建站與部署 |

1. **禁止叫學生自己去開 Google Sheets 手動建表格或填欄位**：所有試算表建立、分頁命名、欄位標題與初始 5 題題庫，一律寫在 `gas_code.js` 的 `setupSheet()` / `getOrCreateSpreadsheet()` 中，在學生點一下 `Run` 時瞬間自動生成！
2. **已登入環境自動跳過（Week 9 極速部署）**：每一步開始前先檢查狀態（如執行 `npx.cmd -y @google/clasp show-authorized-user --json` 與 `netlify-user-services-reader`）。若學生在第 8 週已完成 Clasp 與 Netlify 授權，第 9 週**直接跳過階段一**，10 分鐘內完成新試算表與新網站部署！
3. **Windows PowerShell 環境相容**：
   - 在 Windows 執行指令時，**不要用 `&&` 串接指令**（舊版 PowerShell 會報錯），請分步執行或改用 `;`。
   - 在 Windows PowerShell 中，請一律加上 `.cmd` 副檔名執行 **`npx.cmd -y @google/clasp ...`**（避免呼叫 `npx.ps1` 觸發 `PSSecurityException` 阻擋）。

---

## 🔴 七條硬性安全與避坑紅線（必守）

1. **敏感金鑰絕不落地程式碼**：
   - **嚴禁**將 `NETLIFY_PERSONAL_ACCESS_TOKEN`、`GITHUB_TOKEN` 或任何 OAuth 憑證寫入前端/後端程式碼或提交至公開 Git Repo。
2. **Google 登入必選「個人 Gmail」**：
   - 執行 `clasp login` 前，**主動提醒學生選擇個人 `@gmail.com` 帳號**，千萬不要選學校（`.edu.tw`）或公司的 Workspace 帳號，否則會被管理員政策（`admin_policy_enforced`）擋下。
3. **學生隱私與去識別化**：
   - 試算表與網頁表單**不要放真實全名、身分證字號、電話、住址**，一律改用「英文暱稱 (`Nickname`)、班級代號或座號」。
4. **強制建立 `.claspignore` 隔離前端檔案**：
   - 執行 `clasp push` 前，專案根目錄**必須**有 `.claspignore` 排除所有前端網頁檔（`web/**`, `index.html`, `*.css`, 前端 `app.js`），只允許推送 `gas_code.js` 與 `appsscript.json`，否則 GAS 雲端會因找不到瀏覽器 DOM 而崩潰（`ReferenceError: document is not defined`）。
5. **嚴禁自行拼接 GAS Web App 網址**：
   - `scriptId`、`parentId`、`deploymentId` 是三個完全不同的 ID。**絕對不准**拿 `scriptId` 去拼 `https://script.google.com/macros/s/<id>/exec`。
   - 一律使用 `npx.cmd -y @google/clasp open-web-app <deploymentId> --json` 取得真實的 `webApp.url`。
6. **Netlify MCP 必先建站再部署**：
   - 必須先呼叫 `netlify-project-services-updater` (`create-new-project`) 取得系統配發的 `site_id`，再將 `siteId` 與前端資料夾路徑傳給 `netlify-deploy-services-updater` (`deploy-site`)。
7. **卡關兩次即提退路（保住作品優先）**：
   - 若 `clasp login` 或授權在同一錯誤連續失敗兩次，不要無限重試，主動向學生提供退路：「clasp 自動通道卡住了，我們換手動貼上方案——我把程式碼整理好，你直接貼到 `script.google.com` 一樣能完成作品！」

---

## 🧭 階段一：環境檢查與工具安裝（若 Week 8 已做過則自動跳過！）

### Step 0：檢查本機環境與開啟 Google Apps Script API
1. **檢查 Node.js**：執行 `node --version`（`clasp v3` 需要 **Node.js 20 以上**）。
2. **檢查是否已登入 Clasp**：先執行 `npx.cmd -y @google/clasp show-authorized-user --json`。若已印出學生的 `@gmail.com`，代表已開過 API 且已登入，直接跳至 Step 1 檢查 Netlify！
3. **🔑【學生動作 1】開啟 Google Apps Script API 開關（首次使用才需做）**：
   > 「請先點開 [Google Apps Script 使用者設定頁面](https://script.google.com/home/usersettings)，用你的**個人 Gmail** 登入，把 **『Google Apps Script API』切換為『開啟 (ON)』**。開完後大約要等 1～2 分鐘生效，開好請跟我說！」

### Step 1：安裝與驗證 Netlify MCP
1. **檢查連線**：呼叫 `netlify-user-services-reader` 檢查目前是否已綁定 Netlify 帳號（若成功回傳使用者資訊，直接跳過設定）。
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
   - 提醒學生重啟 AntiGravity（或重新載入 MCP），再次呼叫 `netlify-user-services-reader` 確認連線成功。

### Step 2：Clasp Google 雲端授權（首次使用才需做）
1. **🔑【學生動作 2】完成 Google OAuth 登入（⚠️ 必勾「全選」權限）**：
   > 「等一下會產生一串授權網址，點開後：  
   > 1. **請務必選擇你剛剛開好 API 的個人 `@gmail.com` 帳號**。  
   > 2. 在『選擇 clasp 可以存取的內容』畫面中，**務必勾選最上方的『全選 (Select all)』打勾方塊**（Google 預設不會幫你打勾，若沒勾直接按繼續，後續建專案會報 `Request had insufficient authentication scopes.` 權限不足錯誤）！」
2. 執行登入並確認狀態：
   ```powershell
   npx.cmd -y @google/clasp login
   npx.cmd -y @google/clasp show-authorized-user --json
   ```

---

## 📁 階段二：本地專案結構與雙分頁自動建表範本（Week 8 單字 ／ Week 9 個人弱點）

在專案工作區建立乾淨的前後端分離結構：

```text
my-project/
├── .claspignore          ← 【必備】阻擋前端檔案推上 GAS
├── appsscript.json       ← 【必備】GAS Web App 匿名存取設定
├── gas_code.js           ← 後端 GAS 雙分頁自動建表＋題庫預塞＋讀寫 API
└── web/                  ← 前端靜態網頁資料夾（準備部署至 Netlify）
    ├── index.html
    ├── style.css
    └── app.js            ← 預留 GAS_API_URL 佔位符
```

### 1. `.claspignore`（避坑核心，缺一不可）
```gitignore
**/**
!gas_code.js
!appsscript.json
```

### 2. `appsscript.json`（開放匿名 API 存取）
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

### 3A. 【第 8 週範本】B1/B2 單字兩段式提示練習網（`gas_code.js` 自動建雙分頁＋預塞 5 題）
自動建立 Google Sheets 並生出兩個分頁：`Vocab_Bank`（預塞學生的 5 個 B1/B2 單字、挖空例句、Hint 1 搭配詞提示、Hint 2 英英定義與字首、完整例句）與 `Learner_Logs`（記錄同儕測試者暱稱、首次答對題數、按提示次數、自造句）：

```javascript
function getOrCreateSpreadsheet() {
  let ss = SpreadsheetApp.getActiveSpreadsheet();
  if (ss) return ss;
  const props = PropertiesService.getScriptProperties();
  const savedId = props.getProperty("SPREADSHEET_ID");
  if (savedId) {
    try {
      ss = SpreadsheetApp.openById(savedId);
      if (ss) return ss;
    } catch (e) {}
  }
  ss = SpreadsheetApp.create("Week8_B1_B2_Vocab_App_DB");
  props.setProperty("SPREADSHEET_ID", ss.getId());
  return ss;
}

function setupSheet() {
  const ss = getOrCreateSpreadsheet();
  let bankSheet = ss.getSheetByName("Vocab_Bank") || ss.getSheets()[0];
  bankSheet.setName("Vocab_Bank");
  if (bankSheet.getLastRow() === 0) {
    bankSheet.appendRow(["Word", "Level", "Cloze_Sentence", "Distractors_CSV", "Hint1_Collocation", "Hint2_Definition", "Full_Example"]);
    // Agent 自動將學生在 Cockpit 填寫的 5 個單字寫入下方陣列：
    const seedItems = [
      ["tentative", "B2", "The team made a ___ plan because the budget was not final yet.", "permanent,reluctant,decisive", "Often used before 'plan', 'agreement', or 'conclusion' (means not 100% decided).", "Not certain or fixed; temporary (starts with 'ten...').", "The team made a tentative plan because the budget was not final yet."]
    ];
    seedItems.forEach(r => bankSheet.appendRow(r));
  }

  let logSheet = ss.getSheetByName("Learner_Logs");
  if (!logSheet) {
    logSheet = ss.insertSheet("Learner_Logs");
    logSheet.appendRow(["Timestamp", "Tester_Nickname", "First_Try_Score", "Hints_Used_Count", "Hardest_Words", "Learner_Sentence"]);
  }
  Logger.log("Google Sheet Ready: " + ss.getUrl());
  return ss;
}

function doGet(e) {
  try {
    const ss = setupSheet();
    const vocabRows = ss.getSheetByName("Vocab_Bank").getDataRange().getValues();
    const logRows = ss.getSheetByName("Learner_Logs").getDataRange().getValues();
    return ContentService
      .createTextOutput(JSON.stringify({ status: "success", sheetUrl: ss.getUrl(), vocab: vocabRows, logs: logRows }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doPost(e) {
  try {
    const ss = setupSheet();
    const logSheet = ss.getSheetByName("Learner_Logs");
    const body = JSON.parse(e.postData.contents);
    logSheet.appendRow([new Date().toISOString(), ...(body.row || [])]);
    return ContentService
      .createTextOutput(JSON.stringify({ status: "success", sheetUrl: ss.getUrl() }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

### 3B. 【第 9 週範本】個人英文弱點練習器 My Own English（`gas_code.js` 自動建雙分頁＋前後測歷程紀錄）
自動建立 Google Sheets 並生出兩個分頁：`My_Weak_Items`（預塞學生自己過去常錯的 5 個真實句子/口語弱句、提示規則與目標改法）與 `My_Practice_Log`（記錄每一輪 Round 1 起點、Round 2、Round 3 的得分/目標詞命中數與改寫前後句子，供網頁最上方即時繪製「📈 Round 1 Baseline vs. Latest Round 進步對比卡」）：

```javascript
function getOrCreateSpreadsheet() {
  let ss = SpreadsheetApp.getActiveSpreadsheet();
  if (ss) return ss;
  const props = PropertiesService.getScriptProperties();
  const savedId = props.getProperty("SPREADSHEET_ID");
  if (savedId) {
    try {
      ss = SpreadsheetApp.openById(savedId);
      if (ss) return ss;
    } catch (e) {}
  }
  ss = SpreadsheetApp.create("Week9_My_Own_English_Tracker_DB");
  props.setProperty("SPREADSHEET_ID", ss.getId());
  return ss;
}

function setupSheet() {
  const ss = getOrCreateSpreadsheet();
  let itemSheet = ss.getSheetByName("My_Weak_Items") || ss.getSheets()[0];
  itemSheet.setName("My_Weak_Items");
  if (itemSheet.getLastRow() === 0) {
    itemSheet.appendRow(["Item_No", "My_Original_Weak_Sentence", "Flagged_Word", "Hint_Frame", "Target_Words", "Sample_Upgrade"]);
    // Agent 自動將學生在 Cockpit 填寫的 5 筆個人真實弱句寫入下方陣列：
    const seedItems = [
      [1, "Besides, AI makes students lazy.", "Besides / makes", "Use an academic additive transition + a hedging verb (tend to / may lead to).", "Furthermore, tend to", "Furthermore, over-reliance on AI may tend to reduce students' active engagement."]
    ];
    seedItems.forEach(r => itemSheet.appendRow(r));
  }

  let logSheet = ss.getSheetByName("My_Practice_Log");
  if (!logSheet) {
    logSheet = ss.insertSheet("My_Practice_Log");
    logSheet.appendRow(["Timestamp", "Round_Label", "Score_or_Target_Count", "Hints_Used", "Baseline_vs_Revised_Samples"]);
  }
  Logger.log("Google Sheet Ready: " + ss.getUrl());
  return ss;
}
```
*(其餘 `doGet` 與 `doPost` 與 3A 相同，回傳 `items` 與 `logs` 供前端頂部繪製「Round 1 起點 vs. Latest Round 最新一輪」進步對比橫幅！)*

### 4. `web/app.js`（前端連線注意 CORS 避坑）
- 預留 `const GAS_API_URL = "YOUR_GAS_API_URL_HERE";`（同時在前端保留一份內建的 5 題 fallback 陣列，確保讀取期間畫面秒開不空白）。
- ⚠️ **跨域 POST 避坑**：從 Netlify 前端 `fetch` POST 到 GAS Web App 時，`Content-Type` 必須設為 `'text/plain;charset=utf-8'`（不要設 `application/json`，否則瀏覽器發送 OPTIONS 預檢請求會被 GAS 擋下導致 CORS 錯誤）：
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

### Step 1：創建雲端 GAS 專案
先確認目錄下沒有舊的 `.clasp.json`，接著執行獨立腳本建立（搭配 `setupSheet()` 自動建表，100% 避開 Drive API Internal Error）：
```powershell
npx.cmd -y @google/clasp create-script --title "Language_Learning_App_DB" --type standalone
```

### Step 2：確認 `appsscript.json` 並強制推送與發佈 Web App
⚠️ **避坑關鍵**：`clasp create-script` 會將雲端預設的 `appsscript.json`（不含 `webapp` 設定）拉回本地覆蓋！推送前**務必再次寫入/確認 `appsscript.json` 內含有 `"webapp": { "executeAs": "USER_DEPLOYING", "access": "ANYONE_ANONYMOUS" }`**，接著執行：
```powershell
npx.cmd -y @google/clasp push -f
npx.cmd -y @google/clasp create-deployment --description "Production Web App"
```

### Step 3：🔑【學生動作 3】首次執行權限審閱（自動建表＋授權一次完成）
1. 從 `.clasp.json` 的 `scriptId` 提供 `https://script.google.com/d/<scriptId>/edit` 連結給學生。
2. **停下來向學生說明**：
   > 「請點開剛剛的 Apps Script 編輯器網頁：  
   > 1. 在上方工具列選取 **`setupSheet`**，點擊 **『▷ 執行 (Run)』**（這一步會同時幫你自動建好 Google 試算表與分頁！）。  
   > 2. 跳出需要授權時，點 **『審閱權限 (Review permissions)』** ➔ 選你的個人 Gmail。  
   > 3. 看到警告『Google 尚未驗證這個應用程式』時，⚠️ **千萬不要點右下角的藍色大按鈕「返回安全頁面 (Back to safety)」**！  
   > 4. 請點左下角小小的灰色字 **『進階 (Advanced)』** ➔ 再點最底下 **『前往專案（不安全）』** ➔ **勾選全選並點『繼續 / 允許 (Continue / Allow)』**。  
   > 完成後跟我說一聲，我就幫你把網站發佈上線！」

### Step 4：動態獲取與注入真實 API 網址
1. 查詢部署清單取得 `<deploymentId>`：
   ```powershell
   npx.cmd -y @google/clasp list-deployments
   ```
2. **用官方 JSON 介面取出真實網址（嚴禁自行拼湊）**：
   ```powershell
   npx.cmd -y @google/clasp open-web-app <deploymentId> --json
   ```
3. 將回傳的 `url`（結尾為 `/exec`）自動替換進前端 `web/app.js` 的 `GAS_API_URL` 中。

### Step 5：Netlify MCP 全自動網頁發佈
1. **先建立新站點**：呼叫 `netlify-project-services-updater` (`create-new-project`) 取得 `site_id`。
2. **再部署前端資料夾**：呼叫 `netlify-deploy-services-updater` (`deploy-site`) 傳入 `siteId` 與 `web` 資料夾絕對路徑。

### Step 6：交付成果與無痕視窗實測驗證
部署完成後，呼叫一次 `doGet` 取得自動建好的 Google 試算表網址（`sheetUrl`），一併整理回報給學生：

```markdown
🎉 **前後端雙向閉環系統＋Google 試算表自動建表完成！**

- 🌐 **你的公開網頁（Netlify）**：<Netlify 公開網址>
- 📊 **AI 自動幫你建好的 Google 試算表**：<sheetUrl>（已自動建好題庫分頁與作答紀錄分頁 ✅）
- 🔗 **GAS API 端點**：<webApp.url>

### 🧪 請進行最後一步實測：
請打開瀏覽器的 **「無痕視窗（Incognito）」** 開啟上方的 Netlify 網址，試玩一輪並送出，再打開上方的 Google 試算表網址，看看紀錄有沒有即時跳出來！
```

---

## 🛠️ 四、六大經典踩坑排除表與 Clasp v3 對照表

| 踩坑編號 | 錯誤訊息 / 症狀 | 真正原因 | 標準應變對策 |
| :--- | :--- | :--- | :--- |
| **坑 1** | `User has not enabled the Apps Script API...` | Google 帳號未開啟 GAS API 或剛開尚未生效 | 引導至 [設定頁面](https://script.google.com/home/usersettings) 將 Google Apps Script API 切換為 **ON**，等待 1～2 分鐘後重試。 |
| **坑 2** | GAS 執行紀錄紅字：`ReferenceError: document is not defined (@ app.gs:5)` | 前端 JS 在 `.claspignore` 生效前被推上 GAS 雲端 | 1. 確認 `.claspignore` 已排除前端檔<br>2. 在 `gas_code.js` 加一行註解<br>3. 執行 `npx.cmd -y @google/clasp push -f`<br>4. 重新 `create-deployment` 並更新前端 API 網址。 |
| **坑 3** | 前端 fetch 報錯或打開 API 網址顯示「很抱歉，目前無法開啟這個檔案」 | 尚未在 GAS 編輯器手動執行一次 `setupSheet` 授權 | 引導學生打開 GAS 線上編輯器，選取 `setupSheet` 按「執行」，走完「審閱權限 ➔ 進階 ➔ 前往專案（不安全）➔ 允許」。 |
| **坑 4** | Netlify MCP 部署報錯：`ENOENT: no such file or directory, open '...state.json'` | 未先建立 Site 就直接呼叫 `deploy-site` | 必須先呼叫 `netlify-project-services-updater` (`create-new-project`) 取得 `site_id`，再帶入 `deploy-site`。 |
| **坑 5** | 網頁載入偶發「連線至 Google Sheets 失敗」或跨網域重導向錯誤 | 瀏覽器同時登入學校與個人等多個 Google 帳號導致 Session 混亂 | 請學生改用 **「無痕視窗（Incognito）」** 開啟 Netlify 網頁測試，即可 100% 解決。 |
| **坑 6** | `Request had insufficient authentication scopes.` | `clasp login` 時未勾選「全選」就直接按繼續 | 執行 `npx.cmd -y @google/clasp logout` 後重新 `login`，提醒學生在授權畫面**務必勾選「全選 (Select all)」**。 |

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
