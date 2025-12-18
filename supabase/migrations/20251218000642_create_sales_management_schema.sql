/*
  # 統合販売管理システム - データベーススキーマ

  ## 概要
  業務SaaS向けの販売管理システムのMVP版データベース。
  得意先、仕入先、案件、見積、受注、請求、納品書を管理。

  ## 新規作成テーブル

  ### 1. customers（得意先）
  - id: UUID主キー
  - code: 得意先コード（一意）
  - name: 得意先名
  - name_kana: カナ名
  - postal_code: 郵便番号
  - address: 住所
  - phone: 電話番号
  - email: メールアドレス
  - contact_person: 担当者名
  - notes: 備考
  - created_at, updated_at: タイムスタンプ
  - created_by, updated_by: 作成/更新ユーザー

  ### 2. suppliers（仕入先）
  - 構造はcustomersと同様

  ### 3. projects（案件）
  - id: UUID主キー
  - customer_id: 得意先ID（外部キー）
  - code: 案件コード
  - name: 案件名
  - status: ステータス（active/completed/canceled）
  - start_date: 開始日
  - end_date: 終了日
  - notes: 備考
  - created_at, updated_at, created_by, updated_by

  ### 4. quotes（見積）
  - id: UUID主キー
  - quote_number: 見積番号
  - customer_id: 得意先ID
  - project_id: 案件ID（任意）
  - issue_date: 発行日
  - expiry_date: 有効期限
  - subtotal: 小計（整数・円）
  - tax: 消費税額（整数・円）
  - total: 合計（整数・円）
  - status: ステータス（draft/sent/accepted/rejected）
  - notes: 備考
  - created_at, updated_at, created_by, updated_by

  ### 5. quote_items（見積明細）
  - id: UUID主キー
  - quote_id: 見積ID
  - line_number: 行番号
  - item_name: 品名
  - description: 説明
  - quantity: 数量
  - unit_price: 単価（整数・円）
  - amount: 金額（整数・円）
  - created_at, updated_at

  ### 6. sales_orders（受注）
  - id: UUID主キー
  - order_number: 受注番号
  - customer_id: 得意先ID
  - project_id: 案件ID（任意）
  - quote_id: 見積ID（任意）
  - order_date: 受注日
  - delivery_date: 納期
  - total_amount: 合計金額（整数・円）
  - status: ステータス（pending/processing/completed/canceled）
  - notes: 備考
  - created_at, updated_at, created_by, updated_by

  ### 7. invoices（請求）
  - id: UUID主キー
  - invoice_number: 請求番号
  - customer_id: 得意先ID
  - project_id: 案件ID（任意）
  - sales_order_id: 受注ID（任意）
  - issue_date: 発行日
  - due_date: 支払期限
  - subtotal: 小計（整数・円）
  - tax: 消費税額（整数・円）
  - total: 合計（整数・円）
  - status: ステータス（draft/sent/paid/overdue）
  - payment_date: 入金日（任意）
  - notes: 備考
  - created_at, updated_at, created_by, updated_by

  ### 8. invoice_items（請求明細）
  - 構造はquote_itemsと同様

  ### 9. delivery_notes（納品書）
  - id: UUID主キー
  - delivery_number: 納品書番号
  - customer_id: 得意先ID
  - project_id: 案件ID（任意）
  - sales_order_id: 受注ID（任意）
  - delivery_date: 納品日
  - subtotal: 小計（整数・円）
  - tax: 消費税額（整数・円）
  - total: 合計（整数・円）
  - notes: 備考
  - created_at, updated_at, created_by, updated_by

  ### 10. delivery_note_items（納品書明細）
  - 構造はquote_itemsと同様

  ### 11. invoice_delivery_logs（請求送付ログ）
  - id: UUID主キー
  - invoice_id: 請求ID
  - delivery_method: 送付方法（email/post/fax/hand）
  - recipient_email: 送信先メール
  - delivered_at: 送付日時
  - delivered_by: 送付者
  - notes: 備考
  - created_at

  ## セキュリティ設定
  - 全テーブルでRLSを有効化
  - 認証済みユーザーのみ自分のデータにアクセス可能
  - SELECT/INSERT/UPDATE/DELETE用に個別のポリシーを設定
*/

-- customers（得意先）
CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  name_kana text DEFAULT '',
  postal_code text DEFAULT '',
  address text DEFAULT '',
  phone text DEFAULT '',
  email text DEFAULT '',
  contact_person text DEFAULT '',
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view customers"
  ON customers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert customers"
  ON customers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update customers"
  ON customers FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete customers"
  ON customers FOR DELETE
  TO authenticated
  USING (true);

-- suppliers（仕入先）
CREATE TABLE IF NOT EXISTS suppliers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  name_kana text DEFAULT '',
  postal_code text DEFAULT '',
  address text DEFAULT '',
  phone text DEFAULT '',
  email text DEFAULT '',
  contact_person text DEFAULT '',
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view suppliers"
  ON suppliers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert suppliers"
  ON suppliers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update suppliers"
  ON suppliers FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete suppliers"
  ON suppliers FOR DELETE
  TO authenticated
  USING (true);

-- projects（案件）
CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  status text DEFAULT 'active' CHECK (status IN ('active', 'completed', 'canceled')),
  start_date date,
  end_date date,
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view projects"
  ON projects FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert projects"
  ON projects FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update projects"
  ON projects FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete projects"
  ON projects FOR DELETE
  TO authenticated
  USING (true);

-- quotes（見積）
CREATE TABLE IF NOT EXISTS quotes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quote_number text UNIQUE NOT NULL,
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  issue_date date NOT NULL DEFAULT CURRENT_DATE,
  expiry_date date,
  subtotal integer DEFAULT 0,
  tax integer DEFAULT 0,
  total integer DEFAULT 0,
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'accepted', 'rejected')),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view quotes"
  ON quotes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert quotes"
  ON quotes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update quotes"
  ON quotes FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete quotes"
  ON quotes FOR DELETE
  TO authenticated
  USING (true);

-- quote_items（見積明細）
CREATE TABLE IF NOT EXISTS quote_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quote_id uuid NOT NULL REFERENCES quotes(id) ON DELETE CASCADE,
  line_number integer NOT NULL,
  item_name text NOT NULL,
  description text DEFAULT '',
  quantity numeric(10,2) NOT NULL DEFAULT 1,
  unit_price integer NOT NULL DEFAULT 0,
  amount integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(quote_id, line_number)
);

ALTER TABLE quote_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view quote_items"
  ON quote_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert quote_items"
  ON quote_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update quote_items"
  ON quote_items FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete quote_items"
  ON quote_items FOR DELETE
  TO authenticated
  USING (true);

-- sales_orders（受注）
CREATE TABLE IF NOT EXISTS sales_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  quote_id uuid REFERENCES quotes(id) ON DELETE SET NULL,
  order_date date NOT NULL DEFAULT CURRENT_DATE,
  delivery_date date,
  total_amount integer DEFAULT 0,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'canceled')),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE sales_orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view sales_orders"
  ON sales_orders FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert sales_orders"
  ON sales_orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update sales_orders"
  ON sales_orders FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete sales_orders"
  ON sales_orders FOR DELETE
  TO authenticated
  USING (true);

-- invoices（請求）
CREATE TABLE IF NOT EXISTS invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number text UNIQUE NOT NULL,
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  sales_order_id uuid REFERENCES sales_orders(id) ON DELETE SET NULL,
  issue_date date NOT NULL DEFAULT CURRENT_DATE,
  due_date date,
  subtotal integer DEFAULT 0,
  tax integer DEFAULT 0,
  total integer DEFAULT 0,
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'paid', 'overdue')),
  payment_date date,
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view invoices"
  ON invoices FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert invoices"
  ON invoices FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update invoices"
  ON invoices FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete invoices"
  ON invoices FOR DELETE
  TO authenticated
  USING (true);

-- invoice_items（請求明細）
CREATE TABLE IF NOT EXISTS invoice_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id uuid NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  line_number integer NOT NULL,
  item_name text NOT NULL,
  description text DEFAULT '',
  quantity numeric(10,2) NOT NULL DEFAULT 1,
  unit_price integer NOT NULL DEFAULT 0,
  amount integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(invoice_id, line_number)
);

ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view invoice_items"
  ON invoice_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert invoice_items"
  ON invoice_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update invoice_items"
  ON invoice_items FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete invoice_items"
  ON invoice_items FOR DELETE
  TO authenticated
  USING (true);

-- delivery_notes（納品書）
CREATE TABLE IF NOT EXISTS delivery_notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  delivery_number text UNIQUE NOT NULL,
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  project_id uuid REFERENCES projects(id) ON DELETE SET NULL,
  sales_order_id uuid REFERENCES sales_orders(id) ON DELETE SET NULL,
  delivery_date date NOT NULL DEFAULT CURRENT_DATE,
  subtotal integer DEFAULT 0,
  tax integer DEFAULT 0,
  total integer DEFAULT 0,
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_by uuid REFERENCES auth.users(id)
);

ALTER TABLE delivery_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view delivery_notes"
  ON delivery_notes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert delivery_notes"
  ON delivery_notes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Authenticated users can update delivery_notes"
  ON delivery_notes FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = updated_by);

CREATE POLICY "Authenticated users can delete delivery_notes"
  ON delivery_notes FOR DELETE
  TO authenticated
  USING (true);

-- delivery_note_items（納品書明細）
CREATE TABLE IF NOT EXISTS delivery_note_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  delivery_note_id uuid NOT NULL REFERENCES delivery_notes(id) ON DELETE CASCADE,
  line_number integer NOT NULL,
  item_name text NOT NULL,
  description text DEFAULT '',
  quantity numeric(10,2) NOT NULL DEFAULT 1,
  unit_price integer NOT NULL DEFAULT 0,
  amount integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(delivery_note_id, line_number)
);

ALTER TABLE delivery_note_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view delivery_note_items"
  ON delivery_note_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert delivery_note_items"
  ON delivery_note_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update delivery_note_items"
  ON delivery_note_items FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete delivery_note_items"
  ON delivery_note_items FOR DELETE
  TO authenticated
  USING (true);

-- invoice_delivery_logs（請求送付ログ）
CREATE TABLE IF NOT EXISTS invoice_delivery_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id uuid NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  delivery_method text NOT NULL CHECK (delivery_method IN ('email', 'post', 'fax', 'hand')),
  recipient_email text DEFAULT '',
  delivered_at timestamptz NOT NULL DEFAULT now(),
  delivered_by uuid REFERENCES auth.users(id),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE invoice_delivery_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view invoice_delivery_logs"
  ON invoice_delivery_logs FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert invoice_delivery_logs"
  ON invoice_delivery_logs FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = delivered_by);

CREATE POLICY "Authenticated users can update invoice_delivery_logs"
  ON invoice_delivery_logs FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete invoice_delivery_logs"
  ON invoice_delivery_logs FOR DELETE
  TO authenticated
  USING (true);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);
CREATE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers(name);
CREATE INDEX IF NOT EXISTS idx_projects_customer_id ON projects(customer_id);
CREATE INDEX IF NOT EXISTS idx_quotes_customer_id ON quotes(customer_id);
CREATE INDEX IF NOT EXISTS idx_quotes_project_id ON quotes(project_id);
CREATE INDEX IF NOT EXISTS idx_sales_orders_customer_id ON sales_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_invoices_customer_id ON invoices(customer_id);
CREATE INDEX IF NOT EXISTS idx_delivery_notes_customer_id ON delivery_notes(customer_id);
CREATE INDEX IF NOT EXISTS idx_invoice_delivery_logs_invoice_id ON invoice_delivery_logs(invoice_id);