# Google Docs MCP Server

FastMCP server with 45 tools for Google Docs, Sheets, and Drive.

## Tool Categories

| Category | Count | Examples |
|----------|-------|----------|
| Docs | 5 | `readGoogleDoc`, `appendToGoogleDoc`, `insertText`, `deleteRange`, `listDocumentTabs` |
| Formatting | 3 | `applyTextStyle`, `applyParagraphStyle`, `formatMatchingText` |
| Structure | 7 | `insertTable`, `insertPageBreak`, `insertImageFromUrl`, `insertLocalImage`, `editTableCell`*, `findElement`*, `fixListFormatting`* |
| Comments | 7 | `listComments`, `getComment`, `addComment`, `suggestEdits`, `replyToComment`, `resolveComment`, `deleteComment` |
| Sheets | 8 | `readSpreadsheet`, `writeSpreadsheet`, `appendSpreadsheetRows`, `clearSpreadsheetRange`, `createSpreadsheet`, `listGoogleSheets` |
| Drive | 15 | `listGoogleDocs`, `searchDriveFiles`, `downloadFile`, `getDocumentInfo`, `createFolder`, `moveFile`, `copyFile`, `createDocument` |

*Not fully implemented

## Known Limitations

- **deleteFile DISABLED:** File deletion is disabled for safety. Use `moveFile` instead, or delete via drive.google.com
- **Comment anchoring:** Programmatically created comments (including `suggestEdits`) appear in "All Comments" but aren't visibly anchored to text in the UI
- **suggestEdits vs true Suggestions:** `suggestEdits` uses comments to propose changes — it does not use Google Docs' native suggestion mode (the API doesn't support creating suggestions programmatically)
- **Resolved status:** May not persist in Google Docs UI (Drive API limitation)
- **editTableCell:** Not implemented (complex cell index calculation)
- **fixListFormatting:** Experimental, may not work reliably
- **downloadFile size threshold:** Files over 25MB (configurable via `maxDownloadSizeMB`) return a download URL instead of base64 content. Native Google Docs/Sheets files cannot be downloaded — use `readGoogleDoc` or `readSpreadsheet` instead

## Parameter Patterns

- **Document ID:** Extract from URL: `docs.google.com/document/d/DOCUMENT_ID/edit`
- **Text targeting:** Use `textToFind` + `matchInstance` OR `startIndex`/`endIndex`
- **Colors:** Hex format `#RRGGBB` or `#RGB`
- **Alignment:** `START`, `END`, `CENTER`, `JUSTIFIED` (not LEFT/RIGHT)
- **Indices:** 1-based, ranges are [start, end)
- **Tabs:** Optional `tabId` parameter (defaults to first tab)

## Source Files (for implementation details)

| File | Contains |
|------|----------|
| `src/types.ts` | Zod schemas, hex color validation, style parameter definitions |
| `src/googleDocsApiHelpers.ts` | `findTextRange`, `executeBatchUpdate`, style request builders |
| `src/googleSheetsApiHelpers.ts` | A1 notation parsing, range operations |
| `src/server.ts` | All 45 tool definitions with full parameter schemas |

## See Also

- `README.md` - Setup instructions and usage examples
- `SAMPLE_TASKS.md` - 15 example workflows
