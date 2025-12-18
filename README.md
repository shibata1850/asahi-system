# 統合販売管理システム

Next.js (App Router) + Supabase を使用した業務SaaS向け統合販売管理システムのMVP版です。

## 主な機能

- 認証（Supabase Auth - メール/パスワード）
- 得意先管理（CRUD）
- 仕入先管理（CRUD）
- 案件管理（CRUD）
- 見積管理（ヘッダ + 明細行）
- 受注管理
- 請求管理（ヘッダ + 明細行）
- 納品書管理（ヘッダ + 明細行）
- 請求送付ログ

## 技術スタック

- **フロントエンド**: Next.js 13 (App Router), React, TypeScript
- **UIライブラリ**: Tailwind CSS, shadcn/ui
- **バックエンド/DB**: Supabase (PostgreSQL)
- **認証**: Supabase Auth
- **ホスティング**: Vercel / Netlify

## 環境要件

- Node.js 18以上
- npm または yarn
- Supabaseアカウント

---

## ローカル起動手順

### 1. リポジトリのクローンと依存関係のインストール

```bash
git clone <repository-url>
cd <project-directory>
npm install
```

### 2. 環境変数の設定

`.env.example` をコピーして `.env` を作成し、Supabaseの接続情報を設定します。

```bash
cp .env.example .env
```

`.env` ファイルを編集：

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. 開発サーバーの起動

```bash
npm run dev
```

ブラウザで `http://localhost:3000` にアクセスしてください。

---

## Supabaseセットアップ

### 1. Supabaseプロジェクトの作成

1. [Supabase](https://supabase.com) にアクセスしてアカウントを作成
2. 新しいプロジェクトを作成（dev / stg / prod 用に分けて作成を推奨）
3. プロジェクトダッシュボードから以下の情報を取得：
   - Project URL（`Settings` > `API` > `Project URL`）
   - Anon key（`Settings` > `API` > `Project API keys` > `anon` `public`）

### 2. データベースマイグレーション

このプロジェクトでは、Supabaseの標準マイグレーションシステムを使用しています。

**Supabase CLIを使用する場合**

```bash
# Supabase CLIのインストール
npm install -g supabase

# Supabaseプロジェクトにリンク
supabase link --project-ref <your-project-ref>

# マイグレーションの適用
supabase db push
```

**Supabase Dashboardを使用する場合**

1. Supabaseプロジェクトのダッシュボードにアクセス
2. `SQL Editor` を開く
3. プロジェクト内の `supabase/migrations/` フォルダにあるマイグレーションファイルの内容をコピー
4. SQL Editorに貼り付けて実行

### 3. 初期ユーザーの作成

1. Supabaseダッシュボードの `Authentication` セクションを開く
2. `Users` タブで `Add user` をクリック
3. メールアドレスとパスワードを設定してユーザーを作成

---

## デプロイ

### Vercelへのデプロイ

1. [Vercel](https://vercel.com) にアクセスしてアカウントを作成
2. GitHubリポジトリを連携
3. プロジェクトをインポート
4. 環境変数を設定：
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. デプロイを実行

### Netlifyへのデプロイ

1. [Netlify](https://netlify.com) にアクセスしてアカウントを作成
2. GitHubリポジトリを連携
3. Build settings:
   - Build command: `npm run build`
   - Publish directory: `.next`
4. 環境変数を設定：
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. デプロイを実行

---

## 環境分離（dev / stg / prod）

本番環境への移行を見据えて、環境ごとにSupabaseプロジェクトを分けることを推奨します。

### 環境ごとのセットアップ

1. **開発環境（dev）**
   - ローカル開発用
   - `.env` に開発用Supabaseの接続情報を設定

2. **ステージング環境（stg）**
   - 本番前のテスト用
   - Vercel/Netlifyの環境変数にステージング用Supabaseの接続情報を設定

3. **本番環境（prod）**
   - 本番稼働用
   - Vercel/Netlifyの環境変数に本番用Supabaseの接続情報を設定

### 環境変数の管理

Vercel / Netlifyでは、環境ごとに異なる環境変数を設定できます：

1. プロジェクト設定 > Environment Variables
2. `Development` / `Preview` / `Production` ごとに環境変数を設定

---

## 顧客名義への移管手順（再構築手順）

このシステムを別の顧客環境に移管する際の手順です。

### 1. Supabaseプロジェクトの準備

1. 顧客のSupabaseアカウントで新規プロジェクトを作成
2. Project URL と Anon key を取得

### 2. データベースのセットアップ

1. `supabase/migrations/` フォルダ内のマイグレーションファイルを実行
2. Supabase Dashboard の SQL Editor で実行、またはSupabase CLIで `supabase db push`

### 3. 初期ユーザーの作成

1. Supabase Dashboard > Authentication > Users
2. 管理者ユーザーを作成

### 4. アプリケーションのデプロイ

1. 顧客のVercel/Netlifyアカウントでプロジェクトをインポート
2. 環境変数に顧客のSupabase接続情報を設定：
   ```
   NEXT_PUBLIC_SUPABASE_URL=<顧客のSupabase URL>
   NEXT_PUBLIC_SUPABASE_ANON_KEY=<顧客のAnon Key>
   ```
3. デプロイを実行

### 5. 動作確認

1. デプロイされたURLにアクセス
2. 作成した管理者ユーザーでログイン
3. 各機能の動作を確認

### 6. データ移行（必要な場合）

既存システムからデータを移行する場合：

1. Supabase Dashboard > SQL Editor でデータインポート用SQLを実行
2. または、CSVファイルをSupabaseのTable Editorからインポート

---

## トラブルシューティング

### ログインできない

- Supabaseの接続情報（URL、Anon Key）が正しいか確認
- ユーザーがSupabaseに登録されているか確認
- ブラウザのコンソールでエラーメッセージを確認

### データが表示されない

- データベースマイグレーションが正しく実行されているか確認
- RLS（Row Level Security）ポリシーが正しく設定されているか確認
- ブラウザのネットワークタブでAPIエラーを確認

### ビルドエラー

```bash
# 型チェック
npm run typecheck

# ビルド
npm run build
```

---

## ライセンス

プロプライエタリ

## サポート

問題が発生した場合は、開発チームにお問い合わせください。
