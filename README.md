
# Budget Calculator (Salesforce DX)

This repository contains a Salesforce Classic/Lightning hybrid application that provides a small budgeting tool built on top of Salesforce custom objects. The UI uses a Visualforce page (`BudgetApp.page`) with embedded Vue 3 + Bootstrap for client-side interactivity and Apex RemoteActions in `BudgetAppController` to read and mutate data.

This README helps contributors and maintainers get the project running locally, run tests, and deploy to orgs.

## Quick project summary

- Project name: `budget-calculator` (see `sfdx-project.json`).
- UI: Visualforce page `force-app/main/default/pages/BudgetApp.page` using Vue 3 and Bootstrap (CDN).
- Apex controllers: `force-app/main/default/classes/BudgetAppController.cls` (main RemoteAction API), `BudgetAPI_Onload.cls` (REST resource), helper classes and tests are in `force-app/main/default/classes/`.
- Metadata: custom objects and fields under `force-app/main/default/objects/` (Category__c, Expense__c, Expense_Report__c, Income__c, etc.).

## Folder layout (high level)

- `force-app/main/default/` — Salesforce metadata (pages, classes, objects, layouts, flexipages, etc.)
	- `pages/BudgetApp.page` — main Visualforce page with Vue app
	- `classes/` — Apex controllers and tests (e.g., `BudgetAppController.cls`, `BudgetAPI_Onload.cls`, `RegisterMonthScript.cls`)
	- `objects/` — custom object definitions and fields
	- `layouts/`, `flexipages/`, `applications/` — UI metadata
- `.sf/`, `sfdx-project.json` — Salesforce DX and sfdx config
- `package.json` — dev tooling (LWC Jest, ESLint, Prettier, lint-staged, husky)

## Prerequisites

- Node.js + npm (only required for running the local dev tooling such as `sfdx-lwc-jest`, eslint, prettier). Recommended Node LTS (16/18/20). Check `package.json` for devDependencies.
- Salesforce CLI (sfdx) installed and authenticated to your target org(s): https://developer.salesforce.com/tools/sfdxcli
- Java (only if running some Salesforce CLI plugins that require it) — not strictly required for basic sfdx usage.

## Setup (local)

1. Install dependencies for dev tooling (optional but recommended if you run tests / lint):

```bash
cd /path/to/budget-calculator
npm install
```

2. Authenticate to an org (example for dev hub / sandbox / personal org):

```bash
# Web login
sfdx auth:web:login -a my-org-alias

# Or use device login
sfdx auth:device:login -a my-org-alias
```

3. Deploy metadata to an org (use `--checkonly` for validation):

```bash
# Deploy all metadata to the authenticated org aliased as 'my-org-alias'
sfdx force:source:deploy -p force-app -u my-org-alias

# Validate only
sfdx force:source:deploy -p force-app -u my-org-alias --checkonly
```

4. Open the Visualforce page (after deploying) in the target org: navigate to Setup → Visualforce Pages → `BudgetApp` or open the page URL `/apex/BudgetApp` in the org.

## Running tests & lint

- Unit tests for Apex: use the Salesforce CLI to run Apex tests in an org:

```bash
# Run all Apex tests in org
sfdx force:apex:test:run -u my-org-alias --resultformat human --wait 10

# Or run specific class
sfdx force:apex:test:run -u my-org-alias -n ChangePasswordControllerTest -w 10
```

- LWC Jest (only relevant if this project contains LWC unit tests):

```bash
npm test
# or
npm run test:unit
```

- Lint and formatting (JS + metadata):

```bash
npm run prettier
npm run prettier:verify
npm run lint
```

Note: `package.json` includes `sfdx-lwc-jest`, Prettier with Apex/XML plugin, ESLint configs for LWC/Aura, and pre-commit hooks via Husky.

## Important files to know

- `force-app/main/default/pages/BudgetApp.page` — Visualforce page: includes client-side Vue 3 application, modals for creating/editing expenses and categories, totals and category listing.
- `force-app/main/default/classes/BudgetAppController.cls` — Apex RemoteAction endpoints used by the Visualforce page: `getOnloadModel`, `upsertExpense`, `upsertCategory`, `deleteExpense`, `selectExpenseReport`.
- `force-app/main/default/classes/BudgetAPI_Onload.cls` — REST endpoint (annotated `@RestResource`) that returns similar model data for external integrations.
- `force-app/main/default/classes/RegisterMonthScript.cls` — helper script used to seed example data for a month (useful in scratch orgs/testing).

## How the app works (brief)

- On page load the Vue `created()` lifecycle calls `BudgetAppController.getOnloadModel()` to fetch the model that contains expense report folders, reports, categories with nested expenses, and incomes.
- The page renders categories and expenses, uses modals to add/edit expenses and categories, and calls Apex RemoteActions (e.g., `upsertExpense`) to persist changes and refresh the onload model.
- `BudgetAppController` returns an OnloadModel (an inner Apex class) constructed from SOQL queries on custom objects.

## Common developer tasks

- Seed test data: use `RegisterMonthScript` in the anonymous Apex runner to create demo records for a month.
- Add a new category: update `Category__c` metadata or insert via UI/anonymous Apex.
- Debugging client-side code: open browser devtools on `/apex/BudgetApp` and inspect the Vue app state.

## Known TODOs / limitations (from `BudgetApp.page` comments)

- Add error handling when the active expense report doesn't exist (Apex side).
- Add client-side input validation and accessibility improvements.
- Improve styling and alignment of tables (there are TODOs in the page markup).
- Fix some date/time handling edge cases between Salesforce Datetime and the HTML5 `datetime-local` input.

## Contribution guidelines

- Follow the existing repo patterns for formatting: run `npm run prettier` before committing.
- Apex changes should include unit tests and maintain deployment coverage requirements.
- Keep client-side scripts simple; the Visualforce page currently embeds Vue via CDN (consider migrating to LWC for future refactor).

## Troubleshooting

- If `sfdx force:source:deploy` fails, inspect the error message; often it's caused by missing required fields or validation rules in the target org. Use `--verbose` and `--loglevel DEBUG` for more details.
- If the page appears blank or the Vue app doesn't mount, check the browser console for JS errors and ensure `BudgetAppController` is deployed and accessible.

## Next steps / suggestions

- Consider migrating the UI to Lightning Web Components for better alignment with modern Salesforce development patterns.
- Add automated Playwright/Cypress UI tests (if you migrate to an SPA hosted outside VF) or Selenium-based tests for Visualforce flows.

---

If you want, I can:

- Add a short deployment script (shell) that deploys to a named org alias and opens the page.
- Seed demo data via an Apex script and provide commands to run it using `sfdx force:apex:execute`.

Tell me which of the above you'd like and I'll add it.

```
