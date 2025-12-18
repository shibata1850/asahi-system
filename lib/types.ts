export interface Customer {
  id: string
  code: string
  name: string
  name_kana: string
  postal_code: string
  address: string
  phone: string
  email: string
  contact_person: string
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface Supplier {
  id: string
  code: string
  name: string
  name_kana: string
  postal_code: string
  address: string
  phone: string
  email: string
  contact_person: string
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface Project {
  id: string
  customer_id: string
  code: string
  name: string
  status: 'active' | 'completed' | 'canceled'
  start_date: string | null
  end_date: string | null
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface Quote {
  id: string
  quote_number: string
  customer_id: string
  project_id: string | null
  issue_date: string
  expiry_date: string | null
  subtotal: number
  tax: number
  total: number
  status: 'draft' | 'sent' | 'accepted' | 'rejected'
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface QuoteItem {
  id: string
  quote_id: string
  line_number: number
  item_name: string
  description: string
  quantity: number
  unit_price: number
  amount: number
  created_at: string
  updated_at: string
}

export interface SalesOrder {
  id: string
  order_number: string
  customer_id: string
  project_id: string | null
  quote_id: string | null
  order_date: string
  delivery_date: string | null
  total_amount: number
  status: 'pending' | 'processing' | 'completed' | 'canceled'
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface Invoice {
  id: string
  invoice_number: string
  customer_id: string
  project_id: string | null
  sales_order_id: string | null
  issue_date: string
  due_date: string | null
  subtotal: number
  tax: number
  total: number
  status: 'draft' | 'sent' | 'paid' | 'overdue'
  payment_date: string | null
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface InvoiceItem {
  id: string
  invoice_id: string
  line_number: number
  item_name: string
  description: string
  quantity: number
  unit_price: number
  amount: number
  created_at: string
  updated_at: string
}

export interface DeliveryNote {
  id: string
  delivery_number: string
  customer_id: string
  project_id: string | null
  sales_order_id: string | null
  delivery_date: string
  subtotal: number
  tax: number
  total: number
  notes: string
  created_at: string
  updated_at: string
  created_by: string | null
  updated_by: string | null
}

export interface DeliveryNoteItem {
  id: string
  delivery_note_id: string
  line_number: number
  item_name: string
  description: string
  quantity: number
  unit_price: number
  amount: number
  created_at: string
  updated_at: string
}

export interface InvoiceDeliveryLog {
  id: string
  invoice_id: string
  delivery_method: 'email' | 'post' | 'fax' | 'hand'
  recipient_email: string
  delivered_at: string
  delivered_by: string | null
  notes: string
  created_at: string
}
