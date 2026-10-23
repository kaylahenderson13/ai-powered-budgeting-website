# AI Financial Auditor & Budgeting Assistant — Capstone Starter

This is a functional starter implementation, **not yet a deployed website**. It supports email/password accounts, private saved income/expense/debt-payment entries, a monthly dashboard, calculated budgeting tips, charts, deletions, and an AI Q&A route. AI only works after deploying the Edge Function with an OpenAI API key. Use **fictional sample data** for the capstone, not real account numbers or personal details.

## 1. Start a local website

Install Node.js (current LTS), unzip the project, open the folder in VS Code, and use a terminal:

```bash
npm install
cp .env.example .env
npm run dev
```

On Windows, copy `.env.example` to `.env` using File Explorer (or `copy .env.example .env`). Edit the variables as described below and open the local URL that Vite prints.

## 2. Create your Supabase project

1. Create a project at https://supabase.com/dashboard.
2. In **SQL Editor**, run `supabase/schema.sql` to create the `entries` table and access policies. (Run the CREATE POLICY statements once.)
3. In Project Settings / API Keys, copy the project URL and the public publishable key (or legacy anon key) to `.env`. **Never use the secret/service-role key in `.env` or frontend code.**
4. In Authentication, configure email/password sign-in, your site URL and permitted redirect URLs. For email confirmation, verify the address before signing in. Do not disable authentication or RLS.
5. Restart `npm run dev`, create a test account, and enter fictional records. Sign out/in to verify records remain saved.

## 3. Enable real AI questions

The Edge Function uses OpenAI Responses API. The service secret stays in Supabase, *never in the webpage*. This requires an OpenAI API account, possible usage charges, and Supabase CLI.

```bash
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase secrets set OPENAI_API_KEY=YOUR_OPENAI_API_KEY OPENAI_MODEL=gpt-5-mini APP_ORIGIN=http://localhost:5173
npx supabase functions deploy ask-ai
```

For a deployed site, change `APP_ORIGIN` to your production site's exact origin and redeploy (or update the function environment). The function authenticates the caller and reads **only that user's records**, subject to row-level security. It sends their entry amounts, categories, descriptions, and dates to the AI provider to answer; tell test users this and do not use sensitive information. For production, implement AI rate limits, monitoring, provider privacy review, consent and a data deletion feature.

If Supabase changes environment-variable names, verify the current dashboard/CLI documentation. The function uses `SUPABASE_URL` and `SUPABASE_ANON_KEY`, which should be available in the Supabase function environment. Ensure auth token verification stays enabled.

## 4. Build and deploy

```bash
npm run build
```

Host the frontend with Vercel or Netlify, with the **public** `VITE_` environment variables set at the host. Configure Supabase permitted site/redirect URLs and production `APP_ORIGIN`. GitHub Pages can host the built frontend, but it cannot privately host the AI function: Supabase hosts that function.

## Features, measurement, and honest limitations

- **F01** Sign up/in and return to saved data: verify two accounts cannot read one another's entries.
- **F02** Add categorized income, expenses, debt payments: test valid values, bad values, and deletions.
- **F03** Monthly budget totals: confirm income minus expenses minus debt-payment entries.
- **F04** Charts and rule-based budget tips: compare with a manually calculated sample budget.
- **F05** AI asks a question about own recorded amounts: compare AI suggestions with source entries, and verify it admits missing information.
- **NF01** RLS enabled: unauthorized queries cannot access rows.
- **NF02** No banking credentials, bank syncing, or live financial advice.
- **NF03** API key only on server: verify key does not appear in browser bundle.

**Important:** A debt entry here represents a debt *payment*, not the total outstanding balance. Savings entries are not a separate savings-account ledger. Monthly totals cover entries dated in the current calendar month, not auto-repeating transactions. No CSV import, edit feature, multi-month budgeting, password recovery interface, consent screen, AI request quotas, persistent chat history, or deployed production security audit yet. Financial entries should be fictional in classroom tests. This is a capstone MVP, not a production finance service.
