# Google Docs MCP - Personal/Work Account Separation

This server is configured to run as **two separate instances** with distinct Google accounts to maintain clear separation between personal and work content.

## Architecture

```
google-docs-mcp/
├── dist/                    # Shared compiled code
├── credentials/
│   ├── personal/            # Personal Google account credentials
│   │   ├── credentials.json # OAuth client config
│   │   └── token.json       # Auth token (auto-generated)
│   └── work/                # Work Google account credentials
│       ├── credentials.json # OAuth client config
│       └── token.json       # Auth token (auto-generated)
```

## Safety Measures

### 0. File Deletion Disabled (Both Accounts)
The `deleteFile` tool is **disabled by default** for BOTH personal and work accounts. Both server instances share the same compiled code (`dist/server.js`), so this safety measure applies universally.

If called, it returns a safety error explaining alternatives:
- Use `moveFile` to relocate files
- Use `copyFile` to create backups
- Delete manually via drive.google.com

This prevents accidental permanent deletion. Document content changes (via `deleteRange`) are still allowed since Google Docs version history provides protection.

To re-enable deletion (not recommended), modify the `deleteFile` tool in `src/server.ts` and rebuild with `npm run build`.

### 1. Separate OAuth Credentials
Each account uses its own Google Cloud Project OAuth credentials. This means:
- Personal account can only access personal Google Drive
- Work account can only access work Google Drive
- **No possibility of cross-account access at the API level**

### 2. Distinct MCP Server Names
When tools appear in Claude, they are clearly prefixed:
- `google-docs-personal__readGoogleDoc` - Personal account tools
- `google-docs-work__readGoogleDoc` - Work account tools

This makes it obvious which account you're operating on.

### 3. Disabled by Default
Both servers are set to `status: "pending_setup"` and won't be deployed until you:
1. Set up credentials for each account
2. Change status to `"active"` in the registry
3. Run the deployment script

## Setup Instructions

### Step 1: Create Google Cloud Projects

You need **two separate Google Cloud Projects** (one for personal, one for work):

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (e.g., "Claude Docs - Personal")
3. Enable these APIs:
   - Google Docs API
   - Google Sheets API
   - Google Drive API
4. Configure OAuth consent screen (External, add yourself as test user)
5. Create OAuth 2.0 Desktop Client credentials
6. Download the JSON and rename to `credentials.json`

Repeat for your work account with a separate project.

### Step 2: Place Credentials

```bash
# Personal account
cp ~/Downloads/client_secret_xxx.json \
   ~/Developer/the-lodge/mcp-servers/google-docs-mcp/credentials/personal/credentials.json

# Work account
cp ~/Downloads/client_secret_yyy.json \
   ~/Developer/the-lodge/mcp-servers/google-docs-mcp/credentials/work/credentials.json
```

### Step 3: Authorize Each Account

Run authorization for each account separately:

```bash
cd ~/Developer/the-lodge/mcp-servers/google-docs-mcp

# Personal account
GOOGLE_CREDENTIALS_PATH=./credentials/personal/credentials.json \
GOOGLE_TOKEN_PATH=./credentials/personal/token.json \
node dist/server.js

# Follow the OAuth flow, then Ctrl+C after "Token stored"

# Work account
GOOGLE_CREDENTIALS_PATH=./credentials/work/credentials.json \
GOOGLE_TOKEN_PATH=./credentials/work/token.json \
node dist/server.js

# Follow the OAuth flow, then Ctrl+C after "Token stored"
```

### Step 4: Activate in Registry

Edit `config/mcp-configs/mcp_servers_registry.json`:
- Change `"status": "pending_setup"` to `"status": "active"` for each server you want to enable

### Step 5: Deploy Configuration

```bash
./scripts/deploy_mcp_configs.sh --backup
```

## Usage Guidelines

### When to Use Personal Account
- Personal documents, notes, journals
- Side projects unrelated to work
- Family/personal scheduling documents
- Personal financial tracking

### When to Use Work Account
- PBS Wisconsin project documents
- Work meeting notes and agendas
- Team collaboration documents
- Any content that belongs to your employer

### Red Flags (Stop and Think!)
Before any operation, ask yourself:
- Am I about to copy work content to personal Drive?
- Am I about to share personal content with work colleagues?
- Does this document contain employer-owned intellectual property?

## Enabling/Disabling at Runtime

You can toggle servers on/off in Claude Code using @-mentions:
- `@google-docs-personal` - Toggle personal account
- `@google-docs-work` - Toggle work account

Or use the `/mcp` command to enable/disable servers.

## Troubleshooting

### "credentials.json not found"
Ensure you've placed the OAuth client config in the correct directory.

### "Token expired" or re-auth prompts
Delete the token.json file and re-run the authorization step.

### Wrong account accessed
Verify the server name prefix in the tool call. If you see `google-docs-personal__` but expected work, you're using the wrong server instance.
