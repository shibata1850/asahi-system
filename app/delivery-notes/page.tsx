'use client'

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { DashboardLayout } from '@/components/dashboard-layout'
import { Card } from '@/components/ui/card'

export default function DeliveryNotesPage() {
  const { user, loading } = useAuth()
  const router = useRouter()

  useEffect(() => {
    if (!loading && !user) {
      router.push('/login')
    }
  }, [user, loading, router])

  if (loading || !user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">読み込み中...</div>
      </div>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h2 className="text-3xl font-bold text-slate-900">納品書</h2>
          <p className="text-slate-600 mt-2">納品書の作成・管理</p>
        </div>
        <Card className="p-8 text-center">
          <p className="text-slate-600">納品書管理機能は実装中です</p>
        </Card>
      </div>
    </DashboardLayout>
  )
}
