---
name: clasp-netlify-sheets-en
description: AntiGravity Edition: Automated Clasp + Google Sheets Two-Tab Auto-Creation + Netlify MCP zero-copy closed-loop web system guide (including built-in templates for Week 8 B1/B2 Vocabulary Two-Step Hint App and Week 9 Design Your Own English App (student-designed app, generic two-tab template), with student-friendly 3-click guidance and pitfall prevention SOP). Activate automatically when the user says "install Netlify", "connect Netlify", "setup Netlify", "connect Google Sheets", "use Google Sheets as database", "connect Apps Script", "clasp login", "build a web form saved to Google Sheets", "frontend + Google Sheets + Netlify", or "Clasp deployment".
---

# AntiGravity × Clasp Cloud Deployment + Auto-Created Google Sheets + Netlify MCP Zero-Copy Closed-Loop System (English Edition)

> Adapted from [clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide) and [clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)  
> Target Environment: **Google AntiGravity** (driven by prompts copied from the course Cockpit Design Card—no `AGENTS.md` required)  
> Core Philosophy: **"The AI Agent writes all code, automatically creates the Google Sheet and its two tabs (Question Bank + Learner Logs), pre-fills the student's 5 items, and deploys to Netlify! The student never manually creates spreadsheets—only 3 simple browser clicks to authorize and test."**

---

## 🎯 Your Role & Division of Labor (Mandatory)

Your user is an **English-major student or educator without a backend engineering background**:

| 🙋‍♀️ The Student Only Does (Zero Manual Sheet Creation) | 🤖 The AntiGravity Agent Handles Everything Else |
| :--- | :--- |
| ① Turn ON the GAS API switch at `script.google.com/home/usersettings` (and provide Netlify Token once)<br>② Sign in with personal `@gmail.com` during `clasp login` and check **Select all**<br>③ Click `▷ Run` (`setupSheet`) once in the GAS Editor ➔ **Advanced** ➔ **Go to project (unsafe)** ➔ **Allow** | Creating local files & `.claspignore`, auto-creating the Google Sheet & two tabs (`Vocab_Bank` + `Learner_Logs` for Week 8, or `Items` + `Practice_Log` for Week 9), pre-seeding the student's 5 items into Tab 1, injecting the real `/exec` URL, and deploying to Netlify via Netlify MCP |

1. **Never Ask the Student to Manually Create a Google Sheet or Type Column Headers**: All spreadsheet creation, tab naming, column headers, and initial 5 items must be embedded inside `setupSheet()` in `gas_code.js` so that everything is created automatically the moment the student clicks `▷ Run`.
2. **Idempotent / Fast-Track for Week 9**: Always check `npx.cmd -y @google/clasp show-authorized-user --json` and `netlify-user-services-reader` first. If the student already authenticated in Week 8, **skip Phase 1 completely in Week 9** and go straight to creating the new Week 9 project!
3. **Windows PowerShell Compatibility**:
   - On Windows PowerShell, **never chain commands with `&&`**; run commands separately or use `;`.
   - Always invoke `npx` with the `.cmd` extension on Windows: **`npx.cmd -y @google/clasp ...`** (avoids `npx.ps1` `PSSecurityException` blocks).

---

## 🔴 Seven Hard Safety & Pitfall Red Lines (Mandatory)

1. **Never Hardcode Secrets in Source Code**:
   - **NEVER** write `NETLIFY_PERSONAL_ACCESS_TOKEN`, `GITHUB_TOKEN`, or any OAuth credentials into frontend/backend code or commit them to a Git repository.
2. **Always Use a Personal `@gmail.com` Account**:
   - Before running `clasp login`, **proactively remind the student to choose their personal `@gmail.com` account**, NOT a school (`.edu`) or company Google Workspace account (`admin_policy_enforced`).
3. **Student Privacy & De-identification**:
   - Do **not** collect real full names, national ID numbers, phone numbers, or home addresses in Google Sheets. Use **Tester Nickname (`Nickname`), Class Code, or Seat Number** instead.
4. **Always Create `.claspignore` to Isolate Frontend Files**:
   - Before running `clasp push`, the project root **must** contain a `.claspignore` file that excludes all frontend files (`web/**`, `index.html`, `*.css`, frontend `app.js`) and **only** allows pushing `gas_code.js` and `appsscript.json`.
5. **Never Manually Construct the GAS Web App URL**:
   - Always retrieve the real `webApp.url` via `npx.cmd -y @google/clasp open-web-app <deploymentId> --json`.
6. **Netlify MCP: Create Project First, Deploy Second**:
   - Always call `netlify-project-services-updater` (`create-new-project`) first to get `site_id`, then pass `siteId` and `deployDirectory` to `netlify-deploy-services-updater` (`deploy-site`).
7. **Offer a Fallback After Two Consecutive Failures**:
   - If `clasp login` fails twice in a row with the same error, offer the manual backup route (`script.google.com`).

---

## 🧭 Phase 1: Environment Check & One-Time Setup (Skipped Automatically in Week 9 if Already Logged In!)

### Step 0: Check Node.js, Clasp Auth & Google Apps Script API
1. **Check Node.js**: Run `node --version` (requires **Node.js 20+**).
2. **Check Existing Clasp Login**: Run `npx.cmd -y @google/clasp show-authorized-user --json`. If a personal `@gmail.com` is already logged in, skip to Step 1!
3. **🔑 [Student Action 1] Turn ON the Google Apps Script API Switch (First-time only)**:
   > "Please open the **[Google Apps Script User Settings page](https://script.google.com/home/usersettings)**, sign in with your **personal `@gmail.com` account**, and switch **'Google Apps Script API'** to **'ON'**. Wait 1–2 minutes and let me know once it's on!"

### Step 1: Verify or Configure Netlify MCP
1. **Check Connection**: Call `netlify-user-services-reader` (`get-user`). If already connected, skip to Step 2 (or Phase 2).
2. **If Not Connected**:
   - Guide the student to log in at [Netlify](https://app.netlify.com/) ➔ **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ **New access token**.
   - Save the token into `~/.gemini/config/mcp_config.json` and ask the student to restart AntiGravity once.

### Step 2: Clasp Login & Google Cloud OAuth (First-time only)
1. **🔑 [Student Action 2] Complete Google OAuth Login (⚠️ MUST Check "Select all")**:
   > "When you open the Google sign-in link:  
   > 1. **Choose your personal `@gmail.com` account**.  
   > 2. On the permissions screen, **you MUST check the 'Select all' checkbox at the top** before clicking **Continue**!"
2. Run:
   ```powershell
   npx.cmd -y @google/clasp login
   npx.cmd -y @google/clasp show-authorized-user --json
   ```

---

## 📁 Phase 2: Local Project Structure & Auto-Created Two-Tab Google Sheets Templates (Week 8 & Week 9)

Create a clean frontend/backend separation in the project workspace:

```text
my-project/
├── .claspignore          ← [Required] Blocks frontend files from being pushed to GAS
├── appsscript.json       ← [Required] GAS Web App anonymous access manifest
├── gas_code.js           ← Backend GAS script (auto-creates 2 tabs + seeds 5 items + GET/POST API)
└── web/                  ← Frontend static web directory (deployed to Netlify)
    ├── index.html
    ├── style.css
    └── app.js            ← Contains GAS_API_URL placeholder
```

### 1. `.claspignore`
```gitignore
**/**
!gas_code.js
!appsscript.json
```

### 2. `appsscript.json`
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

### 3A. [Week 8 Template] B1/B2 Vocabulary Two-Step Hint App (`gas_code.js` Auto-Creates `Vocab_Bank` & `Learner_Logs`)
Automatically creates a Google Sheet with Tab 1 `Vocab_Bank` (pre-seeded with the student's 5 B1/B2 target words, cloze sentences, Hint 1 collocation clues, Hint 2 definitions, and full examples) and Tab 2 `Learner_Logs` (recording peer testers' nickname, first-try score, hints used, and pushed-output sentence):

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
    // Pre-fill the 5 vocabulary items from the student's Cockpit Design Card prompt:
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

### 3B. [Week 9 Template] Design Your Own English App (`gas_code.js` Auto-Creates `Items` & `Practice_Log`)
In Week 9 students choose their own learner, English skill and app type (1 of 6). The Cockpit design card prompt contains `Learner & Problem`, `App Idea` (app type, Feedback Rule, Record & Progress), `Auto-Create Google Sheets`, `My 5 Practice Items` (starting with a `Format:` line) and `Deployment`.

> ⚠️ **The student's prompt wins**: tab names, columns, app flow, feedback rule and progress display always follow the student's prompt. This template only shows how to build the tabs. Do **not** reuse the old Week 9 `My_Weak_Items` / `My_Practice_Log` or Round 1–3 design.

**Choose the `Items` columns from the `Format:` line** (split each item line on `->` or `|`; for Choose the best reply, the reply marked with `*` is correct):

| App type | Item format (the "Format:" line) | Suggested `Items` columns |
| :--- | :--- | :--- |
| Fix the error | `wrong sentence -> correct sentence` | `Item_No, Wrong_Sentence, Correct_Sentence` |
| Rewrite it better | `weak sentence -> target words (joined with +)` | `Item_No, Weak_Sentence, Target_Words` |
| Fill the gap | `sentence with ___ \| answer` | `Item_No, Gap_Sentence, Answer` (the agent adds 3 distractors of the same word type) |
| Match the pairs | `left item \| right item` | `Item_No, Left, Right` |
| Choose the best reply | `situation \| *best reply \| other reply \| other reply` | `Item_No, Situation, Best_Reply, Other_1, Other_2` |
| Say it aloud | `target sentence` | `Item_No, Target_Sentence` |

**`Practice_Log`**: append one row per finished 5-item session with `Timestamp, Nickname, Score, Hints_Used, Learner_Answers`, plus any columns the student's Record & Progress rule needs (e.g. seconds, wrong matches). The page reads past rows for the same nickname and shows "first session vs. latest session" at the top.

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
  ss = SpreadsheetApp.create("Week9_Own_English_App_DB");
  props.setProperty("SPREADSHEET_ID", ss.getId());
  return ss;
}

function setupSheet() {
  const ss = getOrCreateSpreadsheet();
  let itemSheet = ss.getSheetByName("Items") || ss.getSheets()[0];
  itemSheet.setName("Items");
  if (itemSheet.getLastRow() === 0) {
    // Replace the headers and the 5 seed items with the student's Format line and items (Fix the error shown here):
    itemSheet.appendRow(["Item_No", "Prompt", "Answer"]);
    const seedItems = [
      [1, "He don't like group projects.", "He doesn't like group projects."]
    ];
    seedItems.forEach(r => itemSheet.appendRow(r));
  }

  let logSheet = ss.getSheetByName("Practice_Log");
  if (!logSheet) {
    logSheet = ss.insertSheet("Practice_Log");
    logSheet.appendRow(["Timestamp", "Nickname", "Score", "Hints_Used", "Learner_Answers"]);
  }
  Logger.log("Google Sheet Ready: " + ss.getUrl());
  return ss;
}
```
*(`doGet` and `doPost` are the same as 3A: `doGet` returns `items` and `logs` (filterable by nickname); `doPost` appends one row to `Practice_Log`.)*

### 4. `web/app.js` (CORS-Safe Frontend Connection)
- Keep a placeholder `const GAS_API_URL = "YOUR_GAS_API_URL_HERE";` (and include the 5 items as a built-in local fallback array so the UI loads instantaneously).
- ⚠️ **CORS Preflight Prevention**: Always set `Content-Type` to `'text/plain;charset=utf-8'` on POST requests to GAS.

---

## 🚀 Phase 3: End-to-End Automated Deployment Steps

### Step 1: Create the Cloud GAS Project
Confirm there is no existing `.clasp.json` in the folder, then run:
```powershell
npx.cmd -y @google/clasp create-script --title "Language_Learning_App_DB" --type standalone
```

### Step 2: Re-verify `appsscript.json`, Force Push & Create Deployment
⚠️ **Critical Pitfall**: Always rewrite `appsscript.json` with the `"webapp"` block AFTER `create-script` and BEFORE `push -f`:
```powershell
npx.cmd -y @google/clasp push -f
npx.cmd -y @google/clasp create-deployment --description "Production Web App"
```

### Step 3: 🔑 [Student Action 3] First-Run Authorization (`setupSheet` Auto-Creates the Google Sheet!)
Provide the student with the direct Apps Script Editor link (`https://script.google.com/d/<scriptId>/edit`), then **STOP and explain**:
> "Please open your **[Apps Script Editor](https://script.google.com/d/<scriptId>/edit)**:  
> 1. In the top toolbar dropdown, select **`setupSheet`** and click **`▷ Run`** (this automatically creates your Google Sheet and both tabs!).  
> 2. Click **`Review permissions`** ➔ Choose your personal `@gmail.com` account.  
> 3. On the *'Google hasn't verified this app'* screen, **do NOT click the blue 'Back to safety' button**! Click small grey **`Advanced`** (bottom-left) ➔ **`Go to ... (unsafe)`** ➔ Check **`Select all`** and click **`Continue` / `Allow`**.  
> Reply **'Done'** once finished!"

### Step 4: Dynamically Retrieve & Inject the Real API URL
```powershell
npx.cmd -y @google/clasp list-deployments
npx.cmd -y @google/clasp open-web-app <deploymentId> --json
```
Replace `"YOUR_GAS_API_URL_HERE"` in `web/app.js` with the returned `url` (ending in `/exec`).

### Step 5: Full-Auto Frontend Deployment via Netlify MCP
1. Call `netlify-project-services-updater` (`create-new-project`) to get `site_id`.
2. Call `netlify-deploy-services-updater` (`deploy-site`) with `siteId` and the absolute path to `web/`.

### Step 6: Deliver Completion Card & Incognito Test
Fetch the `GAS_API_URL` once via `GET` to retrieve the auto-created `sheetUrl`, and present both the live **Netlify URL** and the **Google Sheet URL** to the student!

---

## 🛠️ Phase 4: Top 6 Pitfalls Troubleshooting & Clasp v3 Reference

| # | Symptom / Error Message | Root Cause | Standard Solution |
| :--- | :--- | :--- | :--- |
| **1** | `User has not enabled the Apps Script API...` | GAS API switch is OFF or still propagating | Turn ON **Google Apps Script API** at <https://script.google.com/home/usersettings> and wait 1–2 minutes. |
| **2** | `ReferenceError: document is not defined` | Frontend JS pushed to GAS before `.claspignore` was set | Verify `.claspignore`, touch `gas_code.js`, run `npx.cmd -y @google/clasp push -f`, and redeploy. |
| **3** | `Warning: This project requires access to your Google Account to run.` | Student hasn't run `setupSheet` once in the editor | Open GAS Editor, select `setupSheet`, click `▷ Run` ➔ `Review permissions` ➔ `Advanced` ➔ `Go to ... (unsafe)` ➔ `Allow`. |
| **4** | Netlify MCP error: `ENOENT: ... state.json` | Called `deploy-site` without creating a project first | Call `create-new-project` first to get `site_id`, then pass `siteId` to `deploy-site`. |
| **5** | Random CORS / Auth errors when loading the web app | Multiple Google accounts logged into the same browser | Open the Netlify URL in an **Incognito / Private window**. |
| **6** | `Request had insufficient authentication scopes.` | Student didn't check "Select all" during `clasp login` | Run `npx.cmd -y @google/clasp logout`, re-run `login`, and check **"Select all"**. |

### Clasp v2 → v3 Command Mapping

| ❌ Legacy v2 Command (Removed) | ✅ Modern v3 Command (Use This) |
| :--- | :--- |
| `clasp create` | `clasp create-script` |
| `clasp clone` | `clasp clone-script` |
| `clasp open` | `clasp open-script` |
| `clasp deploy` | `clasp create-deployment` |
| `clasp deployments` | `clasp list-deployments` |
| `clasp undeploy` | `clasp delete-deployment` |
| `clasp status` | `clasp show-file-status` |
| `clasp login --status` | `clasp show-authorized-user` |
| *(Manual URL string building)* | `clasp open-web-app <deploymentId> --json` |
