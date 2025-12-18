# 開発ガイド

このドキュメントでは、統合販売管理システムの追加開発に関する情報を提供します。

## 現在の実装状況

### 完成している機能
- ✅ 認証システム（ログイン/ログアウト）
- ✅ ダッシュボード
- ✅ 得意先CRUD（一覧、新規作成、編集、削除）
- ✅ 仕入先CRUD（一覧のみ実装済み）
- ✅ データベーススキーマ（全テーブル作成済み）
- ✅ レスポンシブ対応レイアウト

### 未実装の機能
以下の機能は、プレースホルダーページのみ作成されています。実装が必要です：

- ⏳ 仕入先の新規作成・編集ページ
- ⏳ 案件CRUD
- ⏳ 見積CRUD（明細行含む）
- ⏳ 受注CRUD
- ⏳ 請求CRUD（明細行含む）
- ⏳ 納品書CRUD（明細行含む）
- ⏳ 請求送付ログCRUD

## 追加実装の手順

### 1. 基本的なCRUDページの実装

得意先の実装パターン（`app/customers/`）を参考にしてください。

**必要なファイル構成：**
```
app/
  [entity]/
    page.tsx          # 一覧ページ
    new/
      page.tsx        # 新規作成ページ
    [id]/
      page.tsx        # 編集ページ
```

**実装のポイント：**
1. `useAuth()` フックで認証状態を確認
2. Supabaseクライアントでデータ取得・更新
3. `DashboardLayout` でレイアウトを統一
4. `created_by` / `updated_by` にユーザーIDを設定

### 2. 明細行を持つドキュメント（見積、請求、納品書）の実装

これらのドキュメントは、ヘッダと明細行の2つのテーブルで構成されます。

**実装パターン：**

```typescript
// 見積の場合
const [quote, setQuote] = useState<Quote>()
const [items, setItems] = useState<QuoteItem[]>([])

// ヘッダの保存
const { data: quoteData } = await supabase
  .from('quotes')
  .insert({ ...quoteData })
  .select()
  .single()

// 明細行の保存
const itemsToInsert = items.map((item, index) => ({
  quote_id: quoteData.id,
  line_number: index + 1,
  ...item
}))

await supabase
  .from('quote_items')
  .insert(itemsToInsert)
```

**金額計算の実装：**

```typescript
// 明細行の金額 = 数量 × 単価
const amount = quantity * unit_price

// 小計 = 全明細行の金額の合計
const subtotal = items.reduce((sum, item) => sum + item.amount, 0)

// 消費税 = 小計 × 0.10（10%固定）
const tax = Math.floor(subtotal * 0.10)

// 合計 = 小計 + 消費税
const total = subtotal + tax
```

### 3. リレーションの表示

外部キーで関連するデータを表示する場合：

```typescript
// Supabaseのクエリで結合
const { data } = await supabase
  .from('projects')
  .select(`
    *,
    customer:customers(id, name)
  `)

// または、個別に取得
const { data: customers } = await supabase
  .from('customers')
  .select('id, name')

// selectで使用
<select>
  {customers.map(customer => (
    <option key={customer.id} value={customer.id}>
      {customer.name}
    </option>
  ))}
</select>
```

### 4. 請求送付ログの実装

請求一覧または詳細ページから、送付ログを登録できるようにします。

```typescript
const handleDelivery = async (invoiceId: string) => {
  const { error } = await supabase
    .from('invoice_delivery_logs')
    .insert({
      invoice_id: invoiceId,
      delivery_method: 'email',
      recipient_email: customerEmail,
      delivered_by: user.id,
      delivered_at: new Date().toISOString(),
    })
}
```

## データベーススキーマ

全テーブルはマイグレーションで作成済みです。スキーマの詳細は、Supabaseダッシュボードで確認できます。

### 主要なテーブル

- `customers` - 得意先
- `suppliers` - 仕入先
- `projects` - 案件
- `quotes` + `quote_items` - 見積
- `sales_orders` - 受注
- `invoices` + `invoice_items` - 請求
- `delivery_notes` + `delivery_note_items` - 納品書
- `invoice_delivery_logs` - 請求送付ログ

## UI/UXのベストプラクティス

### レスポンシブデザイン

- カード表示：モバイルでは1列、タブレットで2列、デスクトップで3列
- フォーム：モバイルでは1列、デスクトップで2列グリッド
- ナビゲーション：モバイルではハンバーガーメニュー

### フォームバリデーション

```typescript
// 必須項目
<Input required />

// メールアドレス
<Input type="email" />

// 数値
<Input type="number" min={0} />
```

### ローディング状態

```typescript
const [loading, setLoading] = useState(false)

// API呼び出し前
setLoading(true)

// API呼び出し後
setLoading(false)

// ボタン
<Button disabled={loading}>
  {loading ? '保存中...' : '保存'}
</Button>
```

### エラーハンドリング

```typescript
const { error } = await supabase.from('table').insert(data)

if (error) {
  console.error('Error:', error)
  alert('エラーが発生しました: ' + error.message)
  return
}
```

## テストとデバッグ

### ローカルでの確認

```bash
# 開発サーバー起動
npm run dev

# 型チェック
npm run typecheck

# ビルド
npm run build
```

### Supabaseデータの確認

1. Supabaseダッシュボードにログイン
2. Table Editor でデータを確認
3. SQL Editor でクエリを実行

### デバッグのコツ

- ブラウザの開発者ツール > Console でエラーを確認
- Network タブで API リクエスト/レスポンスを確認
- Supabase Dashboard > Logs で SQL エラーを確認

## デプロイ前のチェックリスト

- [ ] 全ページでログイン状態のチェックが実装されている
- [ ] フォームにバリデーションが設定されている
- [ ] エラーハンドリングが適切に実装されている
- [ ] レスポンシブデザインが正しく動作する
- [ ] `npm run build` が成功する
- [ ] 環境変数が正しく設定されている

## よくある問題と解決方法

### RLSエラーが出る

原因：Row Level Securityポリシーで許可されていない操作を実行している

解決：
1. Supabase Dashboard > Authentication で認証状態を確認
2. Table Editor > Policies でポリシーを確認
3. 必要に応じてポリシーを追加

### データが表示されない

原因：
- クエリが間違っている
- RLSで制限されている
- データが存在しない

解決：
1. ブラウザの Network タブでレスポンスを確認
2. Supabase Dashboard の Table Editor でデータを直接確認
3. SQL Editor で同じクエリを実行してみる

### ビルドエラー

原因：型エラー、importミス

解決：
```bash
# 型チェック
npm run typecheck

# エラーメッセージを確認して修正
```

## 今後の拡張案

- [ ] CSVエクスポート機能
- [ ] PDF出力機能（見積書、請求書）
- [ ] メール送信機能（Supabase Edge Functions使用）
- [ ] ダッシュボードの統計情報
- [ ] 検索・フィルター機能の拡充
- [ ] 案件の進捗管理
- [ ] ユーザー管理機能
- [ ] 権限管理（閲覧のみ、編集可能など）

## サポート

問題が発生した場合は、以下を確認してください：

1. このドキュメント
2. README.md
3. Supabase公式ドキュメント: https://supabase.com/docs
4. Next.js公式ドキュメント: https://nextjs.org/docs
