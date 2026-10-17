# 🚀 AntiGravity 零複製全自動網頁與 Google 試算表資料庫實作講義（Weeks 8–9 專用）
# 🚀 AntiGravity Zero-Copy Web App + Google Sheets + Netlify Classroom Handout (Weeks 8–9 Edition)

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這是什麼？我們今天要做什麼？
透過 **`/clasp-netlify-sheets`** 技能，你**完全不需要自己寫後端程式碼，也不需要手動去開 Google Sheets 建表格**：
* **前端畫面（互動練習網頁）**：自動發佈到 **Netlify**，產生一個全世界都能打開的公開網址。
* **後端資料庫（雙分頁 Google 試算表）**：由 AI 自動在你的 Google 雲端硬碟建立 **Google Sheets**、自動生出兩個分頁（題庫表＋作答紀錄表），並自動把你的 5 題教材填進去！
* **你的任務**：把寫程式與建試算表全部交給 AntiGravity AI，你只需要完成 **「1 句安裝指令 ＋ 從 Cockpit 複製貼上 Prompt（不需 `AGENTS.md`）＋ 3 次瀏覽器點擊授權」**！

---

### 二、 Step 1：把技能安裝進你的 AntiGravity（只需做一次）

請打開 **AntiGravity**，直接複製以下**整段話**貼進對話框送出（AI 會自動幫你建立資料夾並下載技能，完全不用自己找路徑）：

#### 💬 複製貼給 AntiGravity 的安裝指令（中文版）：
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets/SKILL.md 下載技能檔，並儲存到我的 ~/.gemini/config/skills/clasp-netlify-sheets/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，請開一個新的對話視窗，輸入 `/` 就能看到 `/clasp-netlify-sheets` 技能！)*

---

### 三、 Step 2：課前 3 分鐘準備（第 8 週做一次即可，第 9 週免重做！）

1. **準備一個「個人 `@gmail.com`」帳號**：
   * ⚠️ **千萬不要用學校（`.edu.tw`）帳號登入 Google**，學校帳號有管理員限制（`admin_policy_enforced`）會無法建立專案。
2. **【關鍵點擊 1】打開 Google Apps Script API 開關**：
   * 點開 👉 **[https://script.google.com/home/usersettings](https://script.google.com/home/usersettings)**
   * 確認右上角是你的**個人 Gmail**，把 **「Google Apps Script API」切換為「開啟 (ON)」**（開完約需 1～2 分鐘生效）。
3. **綁定 Netlify 權杖（只需設定一次，若已綁定可跳過）**：
   * 登入 [https://app.netlify.com/](https://app.netlify.com/) ➔ 點右上角頭像 **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ 點 **New access token** 產生一組 `nfp_...` 開頭的代碼。
   * **不用自己改設定檔！** 直接把下面這句話貼進 AntiGravity 對話框，AI 就會自動幫你寫進設定檔：
     ```text
     /clasp-netlify-sheets 這是我的 Netlify Token：nfp_請換成你的代碼 ，請幫我寫入 ~/.gemini/config/mcp_config.json 設定好 Netlify MCP。
     ```
   * ⚠️ **AI 設定完成後，請把 AntiGravity 軟體「關閉並重新打開一次」**，讓 Netlify 工具正式載入生效！
4. **省額度秘訣**：將 AntiGravity 模型切換為 **Gemini Flash**（反應最快、免費版額度最耐用）。

---

### 四、 Step 3：第 8 週與第 9 週專用「一桿進洞」Prompt 範本（直接貼給 AntiGravity，不需 `AGENTS.md`）

在課堂上，你可以直接在課程 **Teaching Cockpit 的 Design Card（設計卡）** 填好 5 格後按 **【📋 Copy Prompt for Antigravity】**，或是直接複製以下第 8 週／第 9 週範本修改 `【...】` 後貼給 AntiGravity：

#### 📘 第 8 週範本：做「B1 / B2 單字兩段式提示練習網＋Google Sheets 自動建表」
```text
/clasp-netlify-sheets 請幫我建立並部署一個「CEFR B1/B2 單字兩段式提示微學習網頁 (B1/B2 Vocabulary Microlearning Web App)」，連接 Google Sheets 與 Netlify！

1. 網頁互動設計（一次顯示 1 題，共 5 題）：
- 主題與程度：【例如：B2 Academic Reporting Verbs (5 words)】
- 開始畫面請測試者輸入「英文暱稱 (Tester Nickname)」（不收真實姓名）。
- 每題顯示一句挖空例句（___）與 4 個選項，搭配兩段式提示回饋（Feedback Loop）：
  * 第 1 次答錯 ➔ 不公布答案，顯示【Hint 1：搭配詞線索 (Collocation Clue / Elicitation)】。
  * 第 2 次答錯 ➔ 顯示【Hint 2：英英定義＋字首提示 (Definition + First Letter)】。
  * 答對後 ➔ 顯示完整例句（Recast）＋「🔊 Listen」發音按鈕（使用瀏覽器 window.speechSynthesis）。
- 結尾產出任務（Pushed Output）：5 題答完後，請學習者挑 1 個剛剛按過提示的單字造出一個完整句子，按下 Submit 送出。

2. 自動建立 Google Sheets 雙分頁（請在 gas_code.js 的 setupSheet 自動建表，不要叫我手動建試算表）：
- 分頁 1 `Vocab_Bank`：自動預先填入我下方的 5 個單字題目（Word, Level, Cloze_Sentence, Distractors_CSV, Hint1_Collocation, Hint2_Definition, Full_Example）。
- 分頁 2 `Learner_Logs`：當同儕測試者按 Submit 時，自動記錄 `[Timestamp, Tester_Nickname, First_Try_Score, Hints_Used_Count, Hardest_Words, Learner_Sentence]`。

3. 我的 5 個單字與兩段式提示：
- 單字 1：【例如：tentative | The team made a ___ plan because the budget was not final yet. | 選項：tentative, permanent, reluctant, decisive | Hint 1: Often used before 'plan', 'agreement', or 'conclusion' | Hint 2: Not certain or fixed; temporary (starts with 'ten...')】
- 單字 2～5：【依序填入另外 4 個單字，或請 AI 依主題幫我補齊另外 4 個同主題 B1/B2 單字】

4. 請依 clasp-netlify-sheets 流程建立 .claspignore、引導我點 3 次授權、注入真實 /exec 網址並部署到 Netlify！
```

#### 🎯 第 9 週範本：做「個人英文弱點練習器 (My Own English)＋前後測進步對比卡」
```text
/clasp-netlify-sheets 請幫我建立並部署一個我個人的「AI for My Own English 英文弱點前後測練習網頁」，連接 Google Sheets 與 Netlify！

1. 我要解決的個人英文弱點與練習方式：
- 我的具體弱點：【例如：寫英文報告常過度使用 besides, so, a lot of 等口語轉折詞，缺乏學術緩和語氣 (hedging verbs)】
- 練習模式：【二選一：Type A 常犯文法/易混淆字改錯快篩 ／ Type B 把我的口語弱句改寫成學術句】
- 提示規則（Hint Rule）：【例如：把句子裡太口語的字標紅，點 Hint 按鈕時提示我要用上的 2 個目標學術字（如 Furthermore + tend to），但絕對不要直接幫我寫出整句答案！】
- 網頁頂部「📈 Round 1 (起點) vs. Latest Round (最新一輪) 進步對比卡」：網頁載入時自動從 Google Sheets 的 `My_Practice_Log` 讀取紀錄，在最上方並列顯示我第 1 輪與最新一輪的得分/目標字命中數與改寫前後句子對照！

2. 自動建立 Google Sheets 雙分頁（請在 gas_code.js 的 setupSheet 自動建表，不要叫我手動建試算表）：
- 分頁 1 `My_Weak_Items`：自動預先填入我下方的 5 個個人真實錯句/弱句。
- 分頁 2 `My_Practice_Log`：每次我完成一輪練習（Round 1, Round 2, Round 3）按送出時，自動記錄 `[Timestamp, Round_Label, Score_or_Target_Count, Hints_Used, Baseline_vs_Revised_Samples]` 並即時更新網頁頂部的進步對比卡。

3. 我自己的 5 個真實錯句／口語弱句：
- 第 1 句：【例如：Besides, AI makes students lazy. -> 目標必用詞：Furthermore, tend to】
- 第 2～5 句：【填入另外 4 句自己過去作業真實寫錯或太口語的句子】

4. 請依 clasp-netlify-sheets 流程建立 .claspignore、引導我在 GAS 點一次 Run 授權新試算表、注入真實 /exec 網址並部署到 Netlify！
```

---

### 五、 Step 4：執行過程中，AI 停下來請你點的瀏覽器授權動作

1. **【關鍵點擊 2】Clasp 登入 Google 帳號（⚠️ 必勾「全選」，第 8 週做過則第 9 週免做！）**：
   * 點開 AI 給你的 Google 授權網址 ➔ 選你的**個人 `@gmail.com` 帳號**。
   * 在「選擇 clasp 可以存取的內容」頁面，**務必把最上方的「全選 (Select all)」打勾 ✅**，再按「繼續」！（*沒勾全選會導致權限不足報錯*）。
2. **【關鍵點擊 3】Apps Script 首次執行授權（⚠️ 別點藍色大按鈕，一步同時完成自動建表！）**：
   * 點開 AI 給你的 **Apps Script 線上編輯器網址** ➔ 上方工具列選 `setupSheet`，按 **「▷ 執行 (Run)」**。
   * 點 **「審閱權限 (Review permissions)」** ➔ 選你的個人 Gmail。
   * 看到「Google 尚未驗證這個應用程式」警告時：
     * ❌ **千萬不要點**右下角那個顯眼的藍色大按鈕「返回安全頁面 (Back to safety)」！
     * ✅ 請點左下角小小的灰色字 **「進階 (Advanced)」** ➔ 點最底下 **「前往專案（不安全）」** ➔ **勾選「全選」並按「繼續 / 允許」**。
3. **【最終實測】開「無痕視窗」玩你的作品！**
   * 打開瀏覽器的 **無痕視窗 (Incognito)** 進入 AI 給你的 `https://xxx.netlify.app` 網址測試送出，再點開 AI 自動幫你建好的 Google 試算表網址，看看題庫分頁與作答紀錄分頁是不是都已經自動排好並收到紀錄了！

---
---

## 🌍 Part 2: English Student Handout (For Non-Chinese Environments)

### 1. What Is This & What Will We Build?
With the **`/clasp-netlify-sheets-en`** skill in **AntiGravity**, you can build and deploy a cloud-connected language learning web app **without writing backend code and without manually creating Google Sheets**:
* **Frontend (Interactive Web App)**: Automatically hosted on **Netlify** with a live public URL.
* **Backend Database (Auto-Created Two-Tab Google Sheet)**: The AI automatically creates a **Google Sheet** in your Google Drive, sets up both tabs (**Question Bank + Learner Logs**), and pre-fills your 5 items!
* **Your Job**: Let the AntiGravity AI write all the code and build the spreadsheet—you only need **1 install prompt + 1 prompt copied from your Cockpit Design Card (no `AGENTS.md` needed) + 3 simple browser clicks**!

---

### 2. Step 1: Install the Skill into AntiGravity (One-Time Setup)

Open **AntiGravity**, copy the entire block below, and paste it directly into the chat box (the AI will automatically create the folders and install the English skill for you):

#### 💬 Copy & Paste This Install Prompt into AntiGravity (English Edition):
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets-en/SKILL.md and save it as my global AntiGravity skill at ~/.gemini/config/skills/clasp-netlify-sheets-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 After installation, open a new chat and type `/` to see `/clasp-netlify-sheets-en`!)*

---

### 3. Step 2: 3-Minute Pre-Flight Checklist (Do Once in Week 8—Skipped in Week 9!)

1. **Prepare a Personal `@gmail.com` Account**:
   * ⚠️ **Do NOT use a school (`.edu`) or company Google Workspace account!** School accounts are blocked by administrator policies (`admin_policy_enforced`).
2. **[Key Click 1] Turn ON the Google Apps Script API Switch**:
   * Open 👉 **[https://script.google.com/home/usersettings](https://script.google.com/home/usersettings)**
   * Make sure you are signed into your **personal `@gmail.com` account**, and switch **"Google Apps Script API"** to **"ON"** (wait 1–2 minutes for it to take effect).
3. **Connect Your Netlify Personal Access Token (One-Time Setup)**:
   * Log in at [https://app.netlify.com/](https://app.netlify.com/) ➔ Click your top-right avatar **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ Click **New access token** to generate a token (`nfp_...`).
   * **You do NOT need to edit any config files manually!** Simply copy & paste this sentence into the AntiGravity chat box:
     ```text
     /clasp-netlify-sheets-en Here is my Netlify Token: nfp_PASTE_YOUR_TOKEN_HERE . Please save it into my ~/.gemini/config/mcp_config.json to configure the Netlify MCP server.
     ```
   * ⚠️ **After the AI saves the config, completely close and restart AntiGravity once** so the Netlify tools load!
4. **Quota-Saving Tip**: Switch your AntiGravity model selector to **Gemini Flash** (fastest speed and saves your free-tier quota!).

---

### 4. Step 3: Week 8 & Week 9 Ready-to-Use Prompts (Paste Directly into AntiGravity—No `AGENTS.md` Needed)

Fill out your 5-field **Design Card** in the course Teaching Cockpit and click **【📋 Copy Prompt for Antigravity】**, or copy and customize one of the templates below:

#### 📘 Week 8 Template: CEFR B1 / B2 Vocabulary Two-Step Hint Web App + Auto-Created Google Sheet
```text
/clasp-netlify-sheets-en Please build and deploy a "CEFR B1/B2 Vocabulary Microlearning Web App" connected to Google Sheets and Netlify!

1. Interactive Web App Flow (1 question card at a time, 5 questions total):
- Topic & Level: [e.g., B2 Academic Reporting Verbs (5 words)]
- Ask for Tester Nickname on the start screen (no real names for privacy).
- For each word, show a context sentence with a blank (___) and 4 choices, using a Two-Step Feedback Loop:
  * 1st wrong try -> Do NOT reveal the answer. Unlock and show Hint 1 (Collocation / Elicitation clue).
  * 2nd wrong try -> Unlock and show Hint 2 (English definition + first-letter clue).
  * Correct -> Show the full sentence (Recast) + a "🔊 Listen" button (browser window.speechSynthesis).
- Final Pushed Output Task: After all 5 words, ask the learner to pick 1 word they needed a hint for and write one complete original sentence before clicking Submit.

2. Auto-Create Two-Tab Google Sheet (Create automatically via setupSheet in gas_code.js—do NOT ask me to create the spreadsheet manually):
- Tab 1 `Vocab_Bank`: Pre-fill my 5 vocabulary items below (Word, Level, Cloze_Sentence, Distractors_CSV, Hint1_Collocation, Hint2_Definition, Full_Example).
- Tab 2 `Learner_Logs`: When a peer tester clicks Submit, log `[Timestamp, Tester_Nickname, First_Try_Score, Hints_Used_Count, Hardest_Words, Learner_Sentence]`.

3. My 5 Vocabulary Items:
- Word 1: [e.g., tentative | The team made a ___ plan because the budget was not final yet. | Choices: tentative, permanent, reluctant, decisive | Hint 1: Often used before 'plan', 'agreement', or 'conclusion' | Hint 2: Not certain or fixed; temporary (starts with 'ten...')]
- Words 2–5: [Enter your other 4 words, or ask the AI to generate 4 matching B1/B2 words for this topic]

4. Please follow the clasp-netlify-sheets-en SOP: create .claspignore, guide me through the authorization clicks, inject the real /exec URL, and deploy to Netlify!
```

#### 🎯 Week 9 Template: "AI for My Own English" Personal Weakness Tracker + Baseline vs. Latest Progress Card
```text
/clasp-netlify-sheets-en Please build and deploy my personal "AI for My Own English — Personal Weakness Tracker Web App" connected to Google Sheets and Netlify!

1. My Specific English Weakness & Practice Flow:
- My Target Weakness: [e.g., Overusing informal connectors ('besides', 'so', 'a lot of') instead of academic transitions and hedging verbs]
- Practice Mode: [Choose: Type A Error-Correction Quick Drill OR Type B Rewrite My Informal Sentences into Academic Prose]
- My Hint Rule: [e.g., Highlight my informal word in red and show 2 target academic words to include when I click Hint, without rewriting the whole sentence for me!]
- Top Progress Banner ("📈 Round 1 Baseline vs. Latest Round"): On load, read past rounds from Google Sheets Tab 2 (`My_Practice_Log`) via doGet and display a side-by-side comparison of Round 1 vs. Latest Round (target words used, hints needed, and before/after sentences).

2. Auto-Create Two-Tab Google Sheet (Create automatically via setupSheet in gas_code.js—do NOT ask me to create the spreadsheet manually):
- Tab 1 `My_Weak_Items`: Pre-fill my 5 personal weak sentences/items below.
- Tab 2 `My_Practice_Log`: Every time I finish a practice round (Round 1, Round 2, Round 3), append `[Timestamp, Round_Label, Score_or_Target_Count, Hints_Used, Baseline_vs_Revised_Samples]` and refresh the top progress banner.

3. My 5 Real Weak Sentences / Items:
- Item 1: [e.g., Besides, AI makes students lazy. -> Target words to use: 'Furthermore' + 'tend to']
- Items 2–5: [Enter 4 more real weak sentences from your past essays or speaking notes]

4. Please follow the clasp-netlify-sheets-en SOP: create .claspignore, pause for my GAS Run -> Advanced -> Allow click, inject the real /exec URL, and deploy to Netlify!
```

---

### 5. Step 4: The Browser Authorization Clicks During Deployment

1. **[Key Click 2] Clasp Google Login (⚠️ MUST Check "Select all" — Done Once in Week 8, Skipped in Week 9!)**:
   * Click the Google OAuth link provided by the AI ➔ Select your **personal `@gmail.com` account**.
   * On the permissions screen, **you MUST check the "Select all" checkbox at the top ✅** before clicking **Continue**!
2. **[Key Click 3] First-Run Apps Script Authorization (⚠️ Do NOT Click the Blue Button — Auto-Creates Your Google Sheet!)**:
   * Open the **Apps Script Editor link** provided by the AI ➔ Select `setupSheet` in the top toolbar and click **`▷ Run`**.
   * Click **`Review permissions`** ➔ Choose your personal Gmail.
   * When you see *"Google hasn't verified this app"*:
     * ❌ **Do NOT click** the big blue **`Back to safety`** button on the right!
     * ✅ Click the small grey **`Advanced`** link on the bottom-left ➔ Click **`Go to ... (unsafe)`** at the bottom ➔ Check **`Select all`** and click **`Continue` / `Allow`**.
3. **[Final Test] Test in an Incognito Window!**
   * Open your live `https://xxx.netlify.app` link in an **Incognito / Private browser window**, complete a round, and open your auto-created Google Sheet link to see your tabs and logged rows!
