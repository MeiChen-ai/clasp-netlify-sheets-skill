---
name: clasp-netlify-sheets-en
description: Automated Clasp + Google Sheets Database + Netlify MCP zero-copy closed-loop web system guide (with student-friendly guidance and pitfall prevention SOP). Activate automatically when the user says "install Netlify", "connect Netlify", "setup Netlify", "connect Google Sheets", "use Google Sheets as database", "connect Apps Script", "clasp login", "build a web form saved to Google Sheets", "frontend + Google Sheets + Netlify", or "Clasp deployment".
---

# Clasp Cloud Deployment + Netlify MCP Zero-Copy Closed-Loop Web System (English Student Edition)

> Adapted from [clasp-netlify-mcp-guide](https://github.com/mathruffian-dot/clasp-netlify-mcp-guide) and [clasp-gas-skill](https://github.com/mathruffian-dot/clasp-gas-skill)  
> Core Philosophy: **"The AI Agent writes all the code and runs all deployment commands; the student only performs 3 simple browser clicks to authorize and test."**

---

## 🎯 Your Role & Student Guidance Principles

Your user is likely a **student, educator, or creator without a backend engineering background**, using an **English-only computer environment**:

1. **Pure English & ASCII-Safe Naming**:
   - Communicate 100% in clear, encouraging, jargon-free **English**.
   - Use **ASCII-only English names** for all folders, files, Google Apps Script titles (e.g., `"Project_Database"`), and Google Sheets tab names (e.g., `"Data"`, `"Leaderboard"`). Do not use non-ASCII characters in CLI arguments.
2. **Semi-Automated Pacing (Stop at the 3 Student Action Nodes)**:
   - You (the Agent) handle all code generation, configuration files, CLI execution, URL injection, and cloud deployment automatically.
   - Whenever you reach one of the **3 Student Action Nodes** (① Turning on the GAS API switch, ② Browser OAuth login & permission checkboxes, ③ First-run script authorization & Incognito testing), **STOP and explain the exact browser buttons to click in plain English, then wait for the student's reply before continuing**.
3. **Windows PowerShell Compatibility**:
   - On Windows PowerShell, **never chain commands with `&&`** (legacy PowerShell throws a syntax error); run commands separately or use `;`.
   - Always invoke `npx` with the `.cmd` extension on Windows: **`npx.cmd -y @google/clasp ...`** (running bare `npx` invokes `npx.ps1`, which is frequently blocked by Windows PowerShell `ExecutionPolicy` / `PSSecurityException`).

---

## 🔴 Seven Hard Safety & Pitfall Red Lines (Mandatory)

1. **Never Hardcode Secrets in Source Code**:
   - **NEVER** write `NETLIFY_PERSONAL_ACCESS_TOKEN`, `GITHUB_TOKEN`, or any OAuth credentials into frontend/backend code or commit them to a Git repository.
   - Store MCP tokens exclusively in `~/.gemini/config/mcp_config.json` or local environment variables.
2. **Always Use a Personal `@gmail.com` Account**:
   - Before running `clasp login`, **proactively remind the student to choose their personal `@gmail.com` account**, NOT a school (`.edu`) or company Google Workspace account. Managed accounts are blocked by `admin_policy_enforced`, which students cannot bypass on their own.
3. **Student Privacy & De-identification**:
   - Do **not** collect real full names, national ID numbers, phone numbers, or home addresses in Google Sheets. Use **Class Code, Seat Number, Nickname, or Student ID** instead.
4. **Always Create `.claspignore` to Isolate Frontend Files**:
   - Before running `clasp push`, the project root **must** contain a `.claspignore` file that excludes all frontend files (`index.html`, `*.css`, frontend `app.js`) and **only** allows pushing `gas_code.js` and `appsscript.json`. Pushing frontend DOM code to GAS causes `ReferenceError: document is not defined`.
5. **Never Manually Construct the GAS Web App URL**:
   - `scriptId`, `parentId`, and `deploymentId` are three completely different IDs. **NEVER** build a URL like `https://script.google.com/macros/s/<scriptId>/exec` yourself (it will 100% result in a 404 Page Not Found).
   - Always retrieve the real `webApp.url` via `npx.cmd -y @google/clasp open-web-app <deploymentId> --json`.
6. **Netlify MCP: Create Project First, Deploy Second**:
   - Never call `deploy-site` without a valid `siteId` (causes `ENOENT: no such file or directory, open '...state.json'`). Always call `netlify-project-services-updater` (`create-new-project`) first to get the `site_id`, then pass `siteId` and `deployDirectory` to `netlify-deploy-services-updater` (`deploy-site`).
7. **Offer a Fallback After Two Consecutive Failures**:
   - If `clasp login` or CLI authorization fails twice in a row with the same error, do not loop endlessly. Offer the manual fallback: *"The automated clasp channel is blocked on this computer. Let's switch to the manual backup route—I'll prepare the code so you can paste it directly into `script.google.com` and still finish your project!"*

---

## 🧭 Phase 1: Environment Check & Tool Setup (Netlify + Clasp)

When a student asks to set up Netlify & Google Sheets or start a new project, run these checks in order:

### Step 0: Check Node.js & Enable Google Apps Script API
1. **Check Node.js**: Run `node --version` (`clasp v3` requires **Node.js 20+**). If missing or outdated, help the student install Node.js LTS.
2. **🔑 [Student Action 1] Turn ON the Google Apps Script API Switch**:
   - This is the #1 blocker for beginners! Provide this link and instruction:
     > "Please open the **[Google Apps Script User Settings page](https://script.google.com/home/usersettings)**, sign in with your **personal `@gmail.com` account**, and switch **'Google Apps Script API'** to **'ON'**. It takes about 1–2 minutes to take effect. Let me know once you've turned it on!"

### Step 1: Verify or Configure Netlify MCP
1. **Check Connection**: Call `netlify-user-services-reader` (`get-user`) to check if Netlify is already connected.
2. **If Not Connected**:
   - Guide the student to log in at [Netlify](https://app.netlify.com/) ➔ Click their profile avatar (top-right) ➔ **User settings** ➔ **Applications** ➔ **Personal access tokens** ➔ Click **New access token** and copy the token.
   - Write the token into AntiGravity's global config `~/.gemini/config/mcp_config.json` (ensure valid JSON with no comments):
     ```json
     {
       "mcpServers": {
         "netlify": {
           "command": "npx",
           "args": ["-y", "@netlify/mcp"],
           "env": {
             "NETLIFY_PERSONAL_ACCESS_TOKEN": "<PASTE_STUDENT_TOKEN_HERE>"
           }
         }
       }
     }
     ```
   - Ask the student to restart AntiGravity (or reload MCP) and verify with `netlify-user-services-reader`.

### Step 2: Clasp Login & Google Cloud OAuth
1. **🔑 [Student Action 2] Complete Google OAuth Login (⚠️ MUST Check "Select all")**:
   - Before running the command, warn the student:
     > "I am going to generate a Google sign-in link for you. When you open it:  
     > 1. **Choose your personal `@gmail.com` account** (do NOT choose a school `.edu` account).  
     > 2. On the screen that says *'Select what clasp – The Apps Script CLI can access'*, **you MUST check the 'Select all' checkbox at the top** before clicking **Continue**! (Google leaves those boxes unchecked by default—if you don't check 'Select all', creating projects will fail with `Request had insufficient authentication scopes.`)"
   - Run login:
     ```powershell
     npx.cmd -y @google/clasp login
     ```
   - Copy the full `🔑 Authorize clasp by visiting this url: ...` URL from the terminal output and present it as a clickable link for the student.
2. **Verify Login Status** (use the v3 command):
   ```powershell
   npx.cmd -y @google/clasp show-authorized-user --json
   ```
   Confirm that the student's personal Gmail address is displayed.

---

## 📁 Phase 2: Local Project File Structure (Zero Secrets)

Create a clean frontend/backend separation in the project workspace using ASCII-only filenames:

```text
my-project/
├── .claspignore          ← [Required] Blocks frontend files from being pushed to GAS
├── appsscript.json       ← [Required] GAS Web App anonymous access manifest
├── gas_code.js           ← Backend GAS script for Google Sheets GET/POST API
└── web/                  ← Frontend static web directory (deployed to Netlify)
    ├── index.html
    ├── style.css
    └── app.js            ← Contains GAS_API_URL placeholder
```

### 1. `.claspignore` (Mandatory Pitfall Prevention)
Exclude all frontend and local files; only allow `gas_code.js` and `appsscript.json`:
```gitignore
**/**
!gas_code.js
!appsscript.json
```

### 2. `appsscript.json` (Allow Anonymous Web App Access)
Configure `webapp` so the Netlify frontend can call the API without login redirects:
```json
{
  "timeZone": "UTC",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "webapp": {
    "executeAs": "USER_DEPLOYING",
    "access": "ANYONE_ANONYMOUS"
  }
}
```

### 3. `gas_code.js` (Self-Initializing Google Sheets Backend Template)
Automatically creates or opens a Google Sheet using `PropertiesService` so it works reliably with `--type standalone`:
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

  ss = SpreadsheetApp.create("Project_Database");
  props.setProperty("SPREADSHEET_ID", ss.getId());
  Logger.log("Created Google Sheet: " + ss.getUrl());
  return ss;
}

function getSheet() {
  const ss = getOrCreateSpreadsheet();
  let sheet = ss.getSheetByName("Data") || ss.getSheets()[0];
  sheet.setName("Data");
  if (sheet.getLastRow() === 0) {
    sheet.appendRow(["Timestamp", "ClassCode", "SeatNo", "Value", "Note"]);
  }
  Logger.log("Spreadsheet URL: " + ss.getUrl());
  return sheet;
}

function doGet(e) {
  try {
    const ss = getOrCreateSpreadsheet();
    const sheet = getSheet();
    const data = sheet.getDataRange().getValues();
    return ContentService
      .createTextOutput(JSON.stringify({ status: "success", sheetUrl: ss.getUrl(), data: data }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doPost(e) {
  try {
    const ss = getOrCreateSpreadsheet();
    const sheet = getSheet();
    const body = JSON.parse(e.postData.contents);
    sheet.appendRow([new Date().toISOString(), ...(body.row || [])]);
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

### 4. `web/app.js` (CORS-Safe Frontend Connection)
- Keep a placeholder: `const GAS_API_URL = "YOUR_GAS_API_URL_HERE";`.
- ⚠️ **CORS Preflight Prevention**: When sending a `POST` request from Netlify to a GAS Web App, always set `Content-Type` to `'text/plain;charset=utf-8'` (do NOT use `application/json`, which triggers a browser `OPTIONS` preflight request that GAS rejects):
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

## 🚀 Phase 3: End-to-End Automated Deployment Steps

### Step 1: Create the Cloud GAS Project
First confirm there is no existing `.clasp.json` in the folder, then run:
- **Standalone script with auto-created Google Sheet (Most reliable, 100% avoids Drive API Internal Errors)**:
  ```powershell
  npx.cmd -y @google/clasp create-script --title "Project_Database" --type standalone
  ```
- **Or bind to an existing Google Sheet**:
  ```powershell
  npx.cmd -y @google/clasp create-script --title "Project_Database" --parentId "<SPREADSHEET_ID>"
  ```

### Step 2: Re-verify `appsscript.json`, Force Push & Create Deployment
⚠️ **Critical Pitfall**: Running `clasp create-script` downloads a default `appsscript.json` from Google Cloud and overwrites your local file (removing the `"webapp"` block)! Always **rewrite `appsscript.json` with the `"webapp"` settings AFTER `create-script` and BEFORE `push -f`**:
```powershell
npx.cmd -y @google/clasp push -f
npx.cmd -y @google/clasp create-deployment --description "Production Web App"
```

### Step 3: Dynamically Retrieve & Inject the Real API URL
1. Get the `<deploymentId>` from the output above (or run `npx.cmd -y @google/clasp list-deployments`).
2. **Fetch the official Web App URL via JSON output (never guess or concatenate URLs)**:
   ```powershell
   npx.cmd -y @google/clasp open-web-app <deploymentId> --json
   ```
3. Replace `"YOUR_GAS_API_URL_HERE"` in `web/app.js` with the returned `url` (ending in `/exec`).

### Step 4: Full-Auto Frontend Deployment via Netlify MCP
1. **Create a new Netlify site**: Call `netlify-project-services-updater`:
   - `operation`: `"create-new-project"`
   - `params`: `{ "name": "<lowercase-hyphenated-site-name>" }`
   - Extract the returned `site_id` (`id`).
2. **Deploy the `web` folder**: Call `netlify-deploy-services-updater`:
   - `operation`: `"deploy-site"`
   - `params`: `{ "siteId": "<site_id>", "deployDirectory": "<ABSOLUTE_PATH_TO_WEB_FOLDER>" }`

### Step 5: 🔑 [Student Action 3] First-Run Authorization & Incognito Test
Because the script accesses Google Sheets, Google requires the project owner to manually authorize it once in the browser editor:

1. Provide the student with the direct Apps Script Editor link (`https://script.google.com/d/<scriptId>/edit`) and the live Netlify URL, then **STOP and explain**:
   > "🎉 **Your frontend and backend are deployed! Just one final 30-second authorization step:**  
   > 1. Open your **[Apps Script Editor](https://script.google.com/d/<scriptId>/edit)** (make sure you are signed in with your personal `@gmail.com` account).  
   > 2. In the top toolbar, make sure **`getSheet`** is selected in the dropdown, then click **`▷ Run`**.  
   > 3. A popup will say *'Authorization required'* ➔ Click **`Review permissions`** ➔ Select your personal Gmail account.  
   > 4. When you see *'Google hasn't verified this app'*:  
   >    - ❌ **Do NOT click** the big blue **`Back to safety`** button (that cancels authorization)!  
   >    - ✅ Click the small grey **`Advanced`** link at the bottom-left ➔ Click **`Go to Project_Database (unsafe)`** at the bottom.  
   > 5. Check **`Select all`** and click **`Continue` / `Allow`**.  
   > 6. Finally, open an **Incognito / Private browser window** and visit your live site: **`<Netlify_URL>`** to test submitting data!"

---

## 🛠️ Phase 4: Top 6 Pitfalls Troubleshooting & Clasp v3 Reference

### Top 6 Classroom Pitfalls

| # | Symptom / Error Message | Root Cause | Standard Solution |
| :--- | :--- | :--- | :--- |
| **1** | `User has not enabled the Apps Script API...` | GAS API switch is OFF or still propagating | Have the student turn ON **Google Apps Script API** at <https://script.google.com/home/usersettings> and wait 1–2 minutes. |
| **2** | GAS Execution Log: `ReferenceError: document is not defined (@ app.gs:5)` | Frontend JS was pushed to GAS before `.claspignore` was set | 1. Verify `.claspignore` excludes frontend files.<br>2. Add a comment to `gas_code.js` to trigger file change detection.<br>3. Run `npx.cmd -y @google/clasp push -f` to overwrite remote files.<br>4. Run `create-deployment` again and update `GAS_API_URL`. |
| **3** | `Warning: This project requires access to your Google Account to run.` | Student hasn't run the script once in the editor, or clicked the blue "Back to safety" button | Open the GAS Editor, click `▷ Run`, click `Review permissions` ➔ small grey `Advanced` (NOT the blue button) ➔ `Go to ... (unsafe)` ➔ `Select all` ➔ `Continue`. |
| **4** | Netlify MCP error: `ENOENT: no such file or directory, open '...state.json'` | Called `deploy-site` without creating a project first | Call `netlify-project-services-updater` (`create-new-project`) first to get `site_id`, then pass `siteId` to `deploy-site`. |
| **5** | Random CORS / Auth errors when loading the web app | Multiple Google accounts logged into the same browser session | Open the Netlify URL in an **Incognito / Private window** to isolate the browser session. |
| **6** | `Request had insufficient authentication scopes.` | Student didn't check the permission boxes ("Select all") during `clasp login` | Run `npx.cmd -y @google/clasp logout`, then `npx.cmd -y @google/clasp login` again, and remind the student to check **"Select all"** on the consent page. |

### Clasp v2 → v3 Command Mapping (Never Use v2 Commands)

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
