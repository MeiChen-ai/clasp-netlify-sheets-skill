# 🚀 AntiGravity 零複製全自動網頁與 Google 試算表資料庫實作講義（Weeks 8–9 專用）
# 🚀 AntiGravity Zero-Copy Web App + Google Sheets + Netlify Classroom Handout (Weeks 8–9 Edition)

> 🌐 **[中文版課堂講義請往下捲動](#-第一部分中文版學生實作講義-traditional-chinese)** ｜ **[Click Here for English Classroom Handout](#-part-2-english-student-handout-for-non-chinese-environments)**

> 📌 **來源致謝與改編說明 (Credits & Attribution)**
> * **中文說明**：本技能與課堂講義改編並參考自 **[mathruffian-dot/clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide)** 與 **[mathruffian-dot/clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)**（原作者：三師爸 `mathruffian-dot`）。在此基礎上，為「生成式 AI 與語言學習」課程（第 8–9 週）擴充了中英雙語版本、`setupSheet()` 雙分頁 Google Sheets 全自動建表、以及課堂專用的教學鷹架與避坑引導。
> * **English**: Adapted from and based on **[mathruffian-dot/clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide)** and **[mathruffian-dot/clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)** by `mathruffian-dot`. Customized into a bilingual (Traditional Chinese & English) edition for the *GenAI and Language Learning* course (Weeks 8–9) with automatic two-tab Google Sheets creation (`setupSheet()`), pedagogical scaffolding templates, and student-friendly authorization guidance.

---

## 🇹🇼 第一部分：中文版學生實作講義 (Traditional Chinese)

### 一、 這是什麼？我們今天要做什麼？
透過 **`/clasp-netlify-sheets`** 技能，你**完全不需要自己寫後端程式碼，也不需要手動去開 Google Sheets 建表格**：
* **前端畫面（互動練習網頁）**：自動發佈到 **Netlify**，產生一個全世界都能打開的公開網址。
* **後端資料庫（雙分頁 Google 試算表）**：由 AI 自動在你的 Google 雲端硬碟建立 **Google Sheets**、自動生出兩個分頁（題庫表＋作答紀錄表），並自動把你的 5 題教材填進去！
* **你的任務**：把寫程式與建試算表全部交給 AntiGravity AI，你只需要完成 **「1 句安裝指令 ＋ 從 Cockpit 複製貼上 Prompt ＋ 3 次瀏覽器點擊授權」**！

---

### 二、 Step 0：先建一個新的專案資料夾（每個 App 一個）

AntiGravity 只會在**你目前打開的專案資料夾**裡建立網頁、Apps Script 與設定檔，所以每做一個新 App，都請先：

1. 建立一個**新的空資料夾**，用**英文名稱、不要有空格**（整個路徑最好也不要有中文）。例如第 8 週放在「文件」裡的 `my-vocab-app`；第 9 週**不要沿用第 8 週的資料夾**，另建 `my-english-app`。
2. 在 AntiGravity 選 **New Project**，選這個資料夾。
3. 開一個**新的對話（New Conversation）**，再進行下面的安裝、準備與貼範本。

做完後，網頁檔案與 `.clasp.json` 等設定都會在這個資料夾裡；之後要修改這個 App，也是打開同一個資料夾。

---

### 三、 Step 1：如何安裝？（只需做一次，支援 Antigravity / OpenCode / Claude Code / Codex）

你**完全不需要自己開終端機找資料夾路徑**！只要打開你正在使用的 AI Agent（**Google Antigravity** 或 **OpenCode**），複製下方對應的一段話貼進對話框，AI 就會自動幫你把技能全部安裝好。

#### 💬 複製貼給 AI Agent 自動安裝

##### 選項 1：通用一鍵安裝指令（同時安裝技能到 Antigravity / OpenCode / Claude Code / Codex）
直接複製以下**整段話**貼給你的 **Antigravity** 或 **OpenCode**：
```text
請幫我把 https://github.com/MeiChen-ai/clasp-netlify-sheets-skill.git 完整 clone 到暫存資料夾，並執行裡面的安裝腳本（或將 skills/ 底下的 clasp-netlify-sheets 與 clasp-netlify-sheets-en 完整資料夾複製到 ~/.gemini/config/skills/、~/.config/opencode/skills/、~/.agents/skills/ 與 ~/.claude/skills/，若資料夾不存在請自動建立）。
```

##### 選項 2：如果你只用 Google Antigravity
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets/SKILL.md 下載技能檔，並儲存到我的 ~/.gemini/config/skills/clasp-netlify-sheets/SKILL.md（若資料夾不存在請自動建立）。
```

##### 選項 3：如果你只用 OpenCode
```text
請幫我從 https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets/SKILL.md 下載技能檔，並同時儲存到我的 ~/.config/opencode/skills/clasp-netlify-sheets/SKILL.md 與 ~/.agents/skills/clasp-netlify-sheets/SKILL.md（若資料夾不存在請自動建立）。
```

*(💡 裝完後，請開一個新的對話視窗，輸入 `/` 就能看到 `/clasp-netlify-sheets` 技能！)*

---

### 四、 Step 2：課前 3 分鐘準備（第 8 週做一次即可，第 9 週免重做！）

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

### 五、 Step 3：第 8 週與第 9 週專用「一桿進洞」Prompt 範本（直接貼給 AntiGravity）

在課堂上，你可以直接在課程 **Teaching Cockpit 的 Design Card（設計卡）** 填好 5 格後按 **【📋 Copy Prompt for Antigravity and Padlet】**，或是直接複製以下第 8 週／第 9 週範本修改 `【...】` 後貼給 AntiGravity：

#### 📘 第 8 週範本：做「B1 / B2 單字兩段式提示練習網＋Google Sheets 自動建表」
```text
/clasp-netlify-sheets 請幫我建立並部署一個 B1/B2 單字微學習網頁 App（B1/B2 Vocabulary Microlearning Web App），連接 Google Sheets 與 Netlify。

1. 網頁功能（What the Web App Does）：
- 標題與程度：【例如：B2 Words for team projects】（5 個單字）
- 開始畫面請測試者輸入暱稱（Tester Nickname，不用真名）。
- 一次顯示 1 題單字克漏字（共 5 題），4 個選項（目標字＋3 個同詞性的字）。
- 回饋（Feedback Loop）：
  * 第 1 次答錯 ➔ 顯示 Hint 1（搭配詞線索），不公布答案。
  * 第 2 次答錯 ➔ 顯示 Hint 2（英英定義＋字首）。
  * 答對 ➔ 顯示完整例句＋「🔊 Listen」按鈕（瀏覽器 speechSynthesis）。
- 結尾任務（Final Step）：【例如：挑 1 個剛剛需要提示的單字，自己寫一個完整句子】然後按 Submit 送出。

2. 自動建立 Google Sheets 雙分頁（請在 gas_code.js 的 setupSheet 自動建表，不要叫我手動建試算表）：
- 分頁 1 `Vocab_Bank`：預先填入下方 5 個單字（`Word`, `Cloze_Sentence`, `Hint1`, `Hint2`）。
- 分頁 2 `Learner_Logs`：測試者按 Submit 時，記錄 `[Timestamp, Nickname, First_Try_Score, Hints_Used_Count, Learner_Sentence]`。

3. 我的 5 個單字（My 5 Vocabulary Items）：
- Item 1: Word: 【tentative】 | Cloze_Sentence: 【The team made a ___ plan because the budget was not final yet.】 | Hint1: 【Often used before 'plan', 'agreement' or 'conclusion'; it means not 100% decided.】 | Hint2: 【Not certain or fixed; may change later. Starts with 'ten...'.】
- Item 2～5：【依同樣格式再寫 4 個單字】

4. 請依 clasp-netlify-sheets 流程建立 .claspignore、用中文引導我完成 3 次授權點擊、注入真實 /exec 網址並部署到 Netlify！
```

#### 🎯 第 9 週範本：設計你自己的英文學習 App（Design Your Own English App）
第 9 週由你自己決定**學習者、英文技能與 App 類型**。6 種 App 類型與題目格式：

| App 類型 | 題目格式（Format 行） | `Items` 建議欄位 |
| :--- | :--- | :--- |
| Fix the error | `wrong sentence -> correct sentence` | `Item_No, Wrong_Sentence, Correct_Sentence` |
| Rewrite it better | `weak sentence -> target words (joined with +)` | `Item_No, Weak_Sentence, Target_Words` |
| Fill the gap | `sentence with ___ \| answer` | `Item_No, Gap_Sentence, Answer`（另由 Agent 產生 3 個同詞性干擾選項） |
| Match the pairs | `left item \| right item` | `Item_No, Left, Right` |
| Choose the best reply | `situation \| *best reply \| other reply \| other reply` | `Item_No, Situation, Best_Reply, Other_1, Other_2` |
| Say it aloud | `target sentence` | `Item_No, Target_Sentence` |

```text
/clasp-netlify-sheets 請幫我建立並部署我的英文微學習網頁 App，連接 Google Sheets 與 Netlify。我第 8 週已設定好 clasp 與 Netlify，請沿用，並在這個資料夾建立新的 Apps Script 專案與新的 Google Sheet。

1. 學習者與問題（Learner & Problem）：【例如：寫信給教授語氣太隨便的大一學生（B1）】

2. App 點子（App Idea）：【一句話：一個幫助……練習……的 App】
- App 類型：【6 選 1，例如：Choose the best reply——顯示情境與 3 個回覆，學習者選最合適的一個】
- 開始畫面請學習者輸入暱稱（不用真名）；一次顯示 1 題，每次 5 題，2–8 分鐘可完成。
- 回饋規則（Feedback Rule）：【例如：選錯時先說明為什麼太隨便，再讓學習者重選；第 2 次錯才顯示最佳回覆】學習者至少嘗試一次前，絕不顯示答案。
- 紀錄與進度（Record & Progress）：【例如：記錄第一次就答對的題數；頁面頂部顯示同一暱稱「第一次 vs. 最新一次」的成績】

3. 自動建立 Google Sheets 雙分頁（請在 gas_code.js 的 setupSheet 自動建表，不要叫我手動建試算表）：
- 分頁 1 `Items`：預先填入下方 5 題。
- 分頁 2 `Practice_Log`：每完成一次練習，記錄 `[Timestamp, Nickname, Score, Hints_Used, Learner_Answers]`，以及我的紀錄規則需要的欄位。

4. 我的 5 題（My 5 Practice Items）：
Format: 【依 App 類型填格式，例如：situation | *best reply | other reply | other reply】
- 第 1 題：【例如：Asking for an extension | *Would it be possible to submit the report on Friday? | Can I give it to you later? | I need more time, OK?】
- 第 2～5 題：【依同樣格式再寫 4 題】

5. 請依 clasp-netlify-sheets 流程建立 .claspignore、引導我在 GAS 點一次 setupSheet 的 Run 授權、注入真實 /exec 網址並部署到 Netlify！
```

---

### 六、 Step 4：執行過程中，AI 停下來請你點的瀏覽器授權動作

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
* **Your Job**: Let the AntiGravity AI write all the code and build the spreadsheet—you only need **1 install prompt + 1 prompt copied from your Cockpit Design Card + 3 simple browser clicks**!

---

### 2. Step 0: Make a New Project Folder (One per App)

AntiGravity creates your web page, Apps Script files and settings **only in the project folder you have open**. So for every new app:

1. Create a **new, empty folder** with an **English name and no spaces** (avoid Chinese characters anywhere in the path), e.g. `my-vocab-app` in Documents for Week 8. In Week 9, **do not reuse your Week 8 folder**: make another one, e.g. `my-english-app`.
2. In AntiGravity, choose **New Project** and pick this folder.
3. Start a **new conversation**, then install, prepare and paste your prompt as described below.

Your web files and settings such as `.clasp.json` are saved in this folder. To change the app later, open the same folder again.

---

### 3. Step 1: One-Time Installation (Supports Antigravity, OpenCode, Claude Code & Codex)

You do **not** need to manually hunt for hidden skill folders! Simply open your AI Agent (**Google Antigravity** or **OpenCode**), copy one of the blocks below, and paste it directly into the chat box.

#### 💬 Copy & Paste One Prompt to Your AI Agent

##### Option 1: Universal Install Prompt (Installs the Skill to Antigravity, OpenCode, Claude Code & Codex)
Copy and paste this entire block into **Antigravity** or **OpenCode**:
```text
Please clone https://github.com/MeiChen-ai/clasp-netlify-sheets-skill.git into a temporary folder and run its installer script (or copy `clasp-netlify-sheets` and `clasp-netlify-sheets-en` from `skills/` into `~/.gemini/config/skills/`, `~/.config/opencode/skills/`, `~/.agents/skills/`, and `~/.claude/skills/`, creating the directories if they do not exist).
```

##### Option 2: Google Antigravity Only
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets-en/SKILL.md and save it as my global AntiGravity skill at ~/.gemini/config/skills/clasp-netlify-sheets-en/SKILL.md (automatically create the directories if they do not exist).
```

##### Option 3: OpenCode Only
```text
Please download the skill file from https://raw.githubusercontent.com/MeiChen-ai/clasp-netlify-sheets-skill/main/skills/clasp-netlify-sheets-en/SKILL.md and save it to both ~/.config/opencode/skills/clasp-netlify-sheets-en/SKILL.md and ~/.agents/skills/clasp-netlify-sheets-en/SKILL.md (automatically create the directories if they do not exist).
```

*(💡 After installation, open a new chat and type `/` to see `/clasp-netlify-sheets-en`!)*

---

### 4. Step 2: 3-Minute Pre-Flight Checklist (Do Once in Week 8—Skipped in Week 9!)

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

### 5. Step 3: Week 8 & Week 9 Ready-to-Use Prompts (Paste Directly into AntiGravity)

Fill out your 5-field **Design Card** in the course Teaching Cockpit and click **【📋 Copy Prompt for Antigravity and Padlet】**, or copy and customize one of the templates below:

#### 📘 Week 8 Template: CEFR B1 / B2 Vocabulary Two-Step Hint Web App + Auto-Created Google Sheet
```text
/clasp-netlify-sheets-en Please build and deploy a B1/B2 Vocabulary Microlearning Web App connected to Google Sheets and Netlify.

1. What the Web App Does:
- Title & Level: [e.g., B2 Words for team projects] (5 words)
- Ask for Tester Nickname on the start screen (no real names).
- Show 1 vocabulary cloze question at a time (5 questions total) with 4 choices (the target word + 3 words of the same part of speech).
- Feedback Loop:
  * 1st wrong try -> Show Hint 1 (Collocation clue). Do NOT reveal the answer.
  * 2nd wrong try -> Show Hint 2 (Definition + first letter).
  * Correct -> Show full sentence + a "🔊 Listen" button (browser speechSynthesis).
- Final Step: [e.g., Pick 1 word you needed a hint for and write one complete sentence of your own.] Then the learner clicks Submit.

2. Auto-Create Google Sheets (Do NOT ask me to create the sheet manually):
- Automatically create a Google Sheet with 2 tabs via `gas_code.js`:
  * Tab 1 `Vocab_Bank`: Pre-fill my 5 vocabulary items below (`Word`, `Cloze_Sentence`, `Hint1`, `Hint2`).
  * Tab 2 `Learner_Logs`: When a tester clicks Submit, log `[Timestamp, Nickname, First_Try_Score, Hints_Used_Count, Learner_Sentence]`.

3. My 5 Vocabulary Items:
Item 1: Word: [tentative] | Cloze_Sentence: [The team made a ___ plan because the budget was not final yet.] | Hint1: [Often used before 'plan', 'agreement' or 'conclusion'; it means not 100% decided.] | Hint2: [Not certain or fixed; may change later. Starts with 'ten...'.]
Items 2-5: [4 more words in the same format]

4. Deployment:
- Follow the `clasp-netlify-sheets-en` skill SOP (create `.claspignore`, guide me in English through the 3 authorization clicks, inject real `/exec` URL, and deploy to Netlify).
```

#### 🎯 Week 9 Template: Design Your Own English App
In Week 9 you choose **your own learner, English skill and app type**. The 6 app types and their item formats:

| App type | Item format (the "Format:" line) | Suggested `Items` columns |
| :--- | :--- | :--- |
| Fix the error | `wrong sentence -> correct sentence` | `Item_No, Wrong_Sentence, Correct_Sentence` |
| Rewrite it better | `weak sentence -> target words (joined with +)` | `Item_No, Weak_Sentence, Target_Words` |
| Fill the gap | `sentence with ___ \| answer` | `Item_No, Gap_Sentence, Answer` (the agent adds 3 distractors of the same word type) |
| Match the pairs | `left item \| right item` | `Item_No, Left, Right` |
| Choose the best reply | `situation \| *best reply \| other reply \| other reply` | `Item_No, Situation, Best_Reply, Other_1, Other_2` |
| Say it aloud | `target sentence` | `Item_No, Target_Sentence` |

```text
/clasp-netlify-sheets-en Please build and deploy my English microlearning web app connected to Google Sheets and Netlify. I already set up clasp and Netlify in Week 8, so reuse that setup and create a NEW Apps Script project and a NEW Google Sheet in this folder.

1. Learner & Problem: [e.g., First-year university students (B1) who write emails to professors that sound too casual.]

2. App Idea: [One sentence: an app that helps ... practise ...]
- App type: [1 of 6, e.g., Choose the best reply. Show a situation and 3 possible replies. The learner picks the most suitable one.]
- Ask for a nickname on the start screen (no real names). Show 1 item at a time, 5 items per session. One session should take 2-8 minutes.
- Feedback Rule: [e.g., Wrong choice: explain why that reply sounds too casual, then let the learner choose again. Show the best reply only after the 2nd wrong try.] Never show the answer before the learner has tried at least once.
- Record & Progress: [e.g., Save first-try score. Show first vs. latest session for this nickname at the top of the page.]

3. Auto-Create Google Sheets (Do NOT ask me to create the sheet manually):
- Tab 1 `Items`: Pre-fill my 5 items below.
- Tab 2 `Practice_Log`: When a session ends, append `[Timestamp, Nickname, Score, Hints_Used, Learner_Answers]` plus anything my Record & Progress rule needs.

4. My 5 Practice Items:
Format: [the format for your app type, e.g., situation | *best reply | other reply | other reply]
- Item 1: [e.g., Asking for an extension | *Would it be possible to submit the report on Friday? | Can I give it to you later? | I need more time, OK?]
- Items 2-5: [4 more items in the same format]

5. Deployment: Follow the clasp-netlify-sheets-en skill SOP (create .claspignore, guide me through the setupSheet Run -> Advanced -> Allow click, inject the real /exec URL, and deploy to Netlify).
```

---

### 6. Step 4: The Browser Authorization Clicks During Deployment

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
