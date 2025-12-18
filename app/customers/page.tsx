'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { DashboardLayout } from '@/components/dashboard-layout'
import { supabase } from '@/lib/supabase'
import { Customer } from '@/lib/types'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Card } from '@/components/ui/card'
import { Plus, Search, Pencil, Trash2 } from 'lucide-react'
import Link from 'next/link'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"

export default function CustomersPage() {
  const { user, loading: authLoading } = useAuth()
  const router = useRouter()
  const [customers, setCustomers] = useState<Customer[]>([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [deleteId, setDeleteId] = useState<string | null>(null)

  useEffect(() => {
    if (!authLoading && !user) {
      router.push('/login')
    }
  }, [user, authLoading, router])

  useEffect(() => {
    if (user) {
      fetchCustomers()
    }
  }, [user])

  const fetchCustomers = async () => {
    setLoading(true)
    const { data, error } = await supabase
      .from('customers')
      .select('*')
      .order('updated_at', { ascending: false })

    if (error) {
      console.error('Error fetching customers:', error)
    } else {
      setCustomers(data || [])
    }
    setLoading(false)
  }

  const handleDelete = async () => {
    if (!deleteId) return

    const { error } = await supabase
      .from('customers')
      .delete()
      .eq('id', deleteId)

    if (error) {
      console.error('Error deleting customer:', error)
    } else {
      fetchCustomers()
    }
    setDeleteId(null)
  }

  const filteredCustomers = customers.filter(customer =>
    customer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    customer.code.toLowerCase().includes(searchQuery.toLowerCase())
  )

  if (authLoading || !user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">読み込み中...</div>
      </div>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <h2 className="text-3xl font-bold text-slate-900">得意先</h2>
            <p className="text-slate-600 mt-2">得意先の登録・管理</p>
          </div>
          <Link href="/customers/new">
            <Button>
              <Plus className="w-4 h-4 mr-2" />
              新規登録
            </Button>
          </Link>
        </div>

        <Card className="p-4">
          <div className="flex items-center gap-2">
            <Search className="w-5 h-5 text-slate-400" />
            <Input
              placeholder="得意先名、コードで検索..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="border-0 focus-visible:ring-0"
            />
          </div>
        </Card>

        {loading ? (
          <div className="text-center py-8">読み込み中...</div>
        ) : filteredCustomers.length === 0 ? (
          <Card className="p-8 text-center">
            <p className="text-slate-600">
              {searchQuery ? '該当する得意先が見つかりません' : '得意先が登録されていません'}
            </p>
          </Card>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {filteredCustomers.map((customer) => (
              <Card key={customer.id} className="p-6">
                <div className="space-y-3">
                  <div>
                    <div className="text-xs text-slate-500 mb-1">{customer.code}</div>
                    <h3 className="text-lg font-semibold text-slate-900">{customer.name}</h3>
                    {customer.name_kana && (
                      <div className="text-sm text-slate-500">{customer.name_kana}</div>
                    )}
                  </div>
                  {customer.contact_person && (
                    <div className="text-sm text-slate-600">
                      担当: {customer.contact_person}
                    </div>
                  )}
                  {customer.email && (
                    <div className="text-sm text-slate-600">{customer.email}</div>
                  )}
                  {customer.phone && (
                    <div className="text-sm text-slate-600">{customer.phone}</div>
                  )}
                  <div className="flex gap-2 pt-2">
                    <Link href={`/customers/${customer.id}`} className="flex-1">
                      <Button variant="outline" size="sm" className="w-full">
                        <Pencil className="w-4 h-4 mr-2" />
                        編集
                      </Button>
                    </Link>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => setDeleteId(customer.id)}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              </Card>
            ))}
          </div>
        )}
      </div>

      <AlertDialog open={!!deleteId} onOpenChange={() => setDeleteId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>得意先を削除</AlertDialogTitle>
            <AlertDialogDescription>
              この得意先を削除してもよろしいですか？この操作は取り消せません。
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>キャンセル</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete}>削除</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </DashboardLayout>
  )
}
