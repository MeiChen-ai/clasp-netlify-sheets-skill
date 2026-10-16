# 🚀 AntiGravity 零複製全自動網頁與雲端資料庫實作講義
# 🚀 AntiGravity Zero-Copy Web App + Google Sheets + Netlify Classroom Handout

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這是什麼？我們今天要做什麼？
透過這份專屬技能（`/clasp-netlify-sheets`），你**不需要自己寫後端程式碼，也不需要手動複製貼上**：
* **前端畫面（網頁/遊戲）**：自動發佈到 **Netlify**，產生一個全世界都能打開的公開網址。
* **後端資料庫（排行榜/題庫/紀錄）**：自動連接你的 **Google 試算表 (Google Sheets)**。
* **你的任務**：把寫程式交給 AntiGravity AI，你只需要完成 **「1 句安裝指令 ＋ 1 句許願提示詞 ＋ 3 次瀏覽器點擊授權」**！

---

### 二、 Step 1：把技能安裝進你的 AntiGravity（只需做一次）

請打開 **AntiGravity**，直接複製以下**整段話**貼進對話框送出（AI 會自動幫你建立資料夾並下載技能，完全不用自己找路徑）：

#### 💬 複製貼給 AntiGravity 的安裝指令（中文版）：
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets/SKILL.md 下載技能檔，並儲存到我的 ~/.gemini/config/skills/clasp-netlify-sheets/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，請開一個新的對話視窗，輸入 `/` 就能看到 `/clasp-netlify-sheets` 技能！)*

---

### 三、 Step 2：課前 3 分鐘準備（必做！）

1. **準備一個「個人 `@gmail.com`」帳號**：
   * ⚠️ **千萬不要用學校（`.edu.tw`）帳號登入 Google**，學校帳號有管理員限制（`admin_policy_enforced`）會無法建立專案。
2. **【關鍵點擊 1】打開 Google Apps Script API 開關**：
   * 點開 👉 **[https://script.google.com/home/usersettings](https://script.google.com/home/usersettings)**
   * 確認右上角是你的**個人 Gmail**，把 **「Google Apps Script API」切換為「開啟 (ON)」**（開完約需 1～2 分鐘生效）。
3. **準備 Netlify 權杖（若尚未綁定 Netlify MCP）**：
   * 登入 [https://app.netlify.com/](https://app.netlify.com/) ➔ 點右上角頭像 **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ 點 **New access token** 產生一組 `nfp_...` 開頭的代碼，交給 AntiGravity 幫你綁定。
4. **省額度秘訣**：將 AntiGravity 模型切換為 **Gemini Flash**（反應最快、免費版額度最耐用）。

---

### 四、 Step 3：填空式「一桿進洞」許願 Prompt（直接修改括號內容）

把你想做的作品一次講清楚，最省免費版額度！請複製以下其中一個範本貼給 AntiGravity：

#### 🎮 範本 A：做「互動學習小遊戲＋雲端排行榜」
```text
/clasp-netlify-sheets 請幫我做一個練習【填入主題，例如：國中英文單字 / 化學元素週期表 / 台灣歷史年代】的【填入遊戲類型，例如：迷宮追逐遊戲 / 打地鼠遊戲 / 太空射擊問答 / 翻牌記憶遊戲】。
需求：
1. 畫面要有計分、生命值與關卡顯示，支援鍵盤與手機觸控按鈕操作。
2. 用 Google Sheets 當資料庫，包含「單字題庫」分頁（預先幫我塞 10 題）與「排行榜」分頁（只記錄班級代號、座號、總分、闖關數，不收真實姓名）。
3. 請自動幫我推上 Google Apps Script 並部署到 Netlify！
```

#### 📋 範本 B：做「班級實用網頁工具＋即時統計」
```text
/clasp-netlify-sheets 請幫我做一個【填入工具名稱，例如：課堂即時簽到與心情牆 / 專題分組投票系統 / 讀書進度打卡板】網頁。
需求：
1. 使用者只需填寫「班級代號、座號」與表單內容即可送出（不收真實姓名）。
2. 資料即時寫入 Google Sheets，並在網頁上同步顯示最新紀錄列表。
3. 請自動幫我推上 Google Apps Script 並部署到 Netlify！
```

---

### 五、 Step 4：執行過程中，AI 停下來請你點的 2 個授權動作

AI 跑指令時會在兩個地方停下來等你，請照著點：

1. **【關鍵點擊 2】Clasp 登入 Google 帳號（⚠️ 必勾「全選」）**：
   * 點開 AI 給你的 Google 授權網址 ➔ 選你的**個人 `@gmail.com` 帳號**。
   * 在「選擇 clasp 可以存取的內容」頁面，**務必把最上方的「全選 (Select all)」打勾 ✅**，再按「繼續」！（*沒勾全選會導致權限不足報錯*）。
2. **【關鍵點擊 3】Apps Script 首次執行授權（⚠️ 別點藍色大按鈕）**：
   * 點開 AI 給你的 **Apps Script 線上編輯器網址** ➔ 上方工具列選 `getSheet`，按 **「▷ 執行 (Run)」**。
   * 點 **「審閱權限 (Review permissions)」** ➔ 選你的個人 Gmail。
   * 看到「Google 尚未驗證這個應用程式」警告時：
     * ❌ **千萬不要點**右下角那個顯眼的藍色大按鈕「返回安全頁面 (Back to safety)」！
     * ✅ 請點左下角小小的灰色字 **「進階 (Advanced)」** ➔ 點最底下 **「前往專案（不安全）」** ➔ **勾選「全選」並按「繼續 / 允許」**。
3. **【最終實測】開「無痕視窗」玩你的作品！**
   * 打開瀏覽器的 **無痕視窗 (Incognito)** 進入 AI 給你的 `https://xxx.netlify.app` 網址，過關上傳分數，再去 Google 試算表看看資料有沒有即時跳出來！

---
---

## 🌍 Part 2: English Student Handout (For Non-Chinese Environments)

### 1. What Is This & What Will We Build?
With the **`/clasp-netlify-sheets-en`** skill, you can build and deploy a full-stack web game or web app **without manually copying and pasting backend code**:
* **Frontend (Web App / Game)**: Automatically hosted on **Netlify** with a live public URL.
* **Backend Database (Leaderboard / Question Bank / Records)**: Automatically connected to your **Google Sheets**.
* **Your Job**: Let the AntiGravity AI write all the code and run the deployment commands—you only need **1 install prompt + 1 wish prompt + 3 simple browser clicks**!

---

### 2. Step 1: Install the Skill into AntiGravity (One-Time Setup)

Open **AntiGravity**, copy the entire block below, and paste it directly into the chat box (the AI will automatically create the folders and install the English skill for you):

#### 💬 Copy & Paste This Install Prompt into AntiGravity (English Edition):
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets-en/SKILL.md and save it as my global AntiGravity skill at ~/.gemini/config/skills/clasp-netlify-sheets-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 After installation, open a new chat and type `/` to see `/clasp-netlify-sheets-en`!)*

---

### 3. Step 2: 3-Minute Pre-Flight Checklist (Must Do!)

1. **Prepare a Personal `@gmail.com` Account**:
   * ⚠️ **Do NOT use a school (`.edu`) or company Google Workspace account!** School accounts are blocked by administrator policies (`admin_policy_enforced`).
2. **[Key Click 1] Turn ON the Google Apps Script API Switch**:
   * Open 👉 **[https://script.google.com/home/usersettings](https://script.google.com/home/usersettings)**
   * Make sure you are signed into your **personal `@gmail.com` account**, and switch **"Google Apps Script API"** to **"ON"** (wait 1–2 minutes for it to take effect).
3. **Prepare Your Netlify Personal Access Token (if not connected yet)**:
   * Log in at [https://app.netlify.com/](https://app.netlify.com/) ➔ Click your top-right avatar **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ Click **New access token** to generate a token (`nfp_...`) and give it to AntiGravity when asked.
4. **Quota-Saving Tip**: Switch your AntiGravity model selector to **Gemini Flash** (fastest speed and saves your free-tier quota!).

---

### 4. Step 3: Fill-in-the-Blank Wish Prompts (One-Shot Prompts)

Giving clear requirements in your very first message saves 70%+ of your free quota! Copy one of the templates below, fill in the brackets `[...]`, and send it to AntiGravity:

#### 🎮 Template A: Interactive Learning Game + Cloud Leaderboard
```text
/clasp-netlify-sheets-en Please build a [Game Type, e.g., Maze Chase Game / Whack-a-Mole / Space Quiz Shooter / Memory Card Game] to practice [Topic, e.g., B2 English Vocabulary / World Capitals / Mental Math].
Requirements:
1. Include a live Score, Lives (Hearts), and Stage display, supporting both keyboard and on-screen touch buttons.
2. Use Google Sheets as the database with two tabs: a "VocabBank" tab (pre-filled with 10 sample items) and a "Leaderboard" tab (recording only ClassCode, SeatNo, Score, and Stage—no real names).
3. Please push the backend to Google Apps Script and deploy the frontend to Netlify automatically!
```

#### 📋 Template B: Classroom Web Tool + Live Dashboard
```text
/clasp-netlify-sheets-en Please build a [Tool Name, e.g., Live Class Check-In & Mood Board / Project Voting App / Study Tracker] web application.
Requirements:
1. Users submit their ClassCode, SeatNo, and form input (do not collect real names).
2. Save submissions directly to Google Sheets and display the latest records live on the page.
3. Please push the backend to Google Apps Script and deploy the frontend to Netlify automatically!
```

---

### 5. Step 4: The 2 Browser Authorization Clicks During Deployment

The AI will pause twice and ask you to click a link in your browser:

1. **[Key Click 2] Clasp Google Login (⚠️ MUST Check "Select all")**:
   * Click the Google OAuth link provided by the AI ➔ Select your **personal `@gmail.com` account**.
   * On the screen *"Select what clasp – The Apps Script CLI can access"*, **you MUST check the "Select all" checkbox at the top ✅** before clicking **Continue**! *(Leaving them unchecked causes `Request had insufficient authentication scopes.`)*
2. **[Key Click 3] First-Run Apps Script Authorization (⚠️ Do NOT Click the Blue Button!)**:
   * Open the **Apps Script Editor link** provided by the AI ➔ Select `getSheet` in the top toolbar and click **`▷ Run`**.
   * Click **`Review permissions`** ➔ Choose your personal Gmail.
   * When you see *"Google hasn't verified this app"*:
     * ❌ **Do NOT click** the big blue **`Back to safety`** button on the right!
     * ✅ Click the small grey **`Advanced`** link on the bottom-left ➔ Click **`Go to Project_Database (unsafe)`** at the bottom ➔ Check **`Select all`** and click **`Continue` / `Allow`**.
3. **[Final Test] Test in an Incognito Window!**
   * Open your live `https://xxx.netlify.app` link in an **Incognito / Private browser window** (prevents multi-account Google session conflicts), submit a score, and watch it appear live in your Google Sheet!

---

## 💻 進階：終端機一鍵安裝腳本 / Advanced: CLI One-Click Install

**Windows (PowerShell):**
```powershell
git clone https://github.com/MeiChen-ai/clasp-netlify-sheets-skill.git
.\clasp-netlify-sheets-skill\scripts\install.ps1
```

**macOS / Linux:**
```bash
git clone https://github.com/MeiChen-ai/clasp-netlify-sheets-skill.git
bash ./clasp-netlify-sheets-skill/scripts/install.sh
```
