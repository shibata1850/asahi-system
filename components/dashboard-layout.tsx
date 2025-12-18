'use client'

import { useState } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'
import {
  Users,
  Building2,
  FolderKanban,
  FileText,
  ShoppingCart,
  Receipt,
  Package,
  Send,
  Menu,
  LogOut,
  LayoutDashboard
} from 'lucide-react'

interface NavItem {
  name: string
  href: string
  icon: React.ReactNode
}

const navItems: NavItem[] = [
  { name: 'ダッシュボード', href: '/dashboard', icon: <LayoutDashboard className="w-5 h-5" /> },
  { name: '得意先', href: '/customers', icon: <Users className="w-5 h-5" /> },
  { name: '仕入先', href: '/suppliers', icon: <Building2 className="w-5 h-5" /> },
  { name: '案件', href: '/projects', icon: <FolderKanban className="w-5 h-5" /> },
  { name: '見積', href: '/quotes', icon: <FileText className="w-5 h-5" /> },
  { name: '受注', href: '/sales-orders', icon: <ShoppingCart className="w-5 h-5" /> },
  { name: '請求', href: '/invoices', icon: <Receipt className="w-5 h-5" /> },
  { name: '納品書', href: '/delivery-notes', icon: <Package className="w-5 h-5" /> },
  { name: '送付ログ', href: '/delivery-logs', icon: <Send className="w-5 h-5" /> },
]

function NavLinks({ onItemClick }: { onItemClick?: () => void }) {
  const pathname = usePathname()
  const { signOut } = useAuth()

  return (
    <nav className="flex-1 space-y-1 px-3">
      {navItems.map((item) => {
        const isActive = pathname === item.href
        return (
          <Link
            key={item.href}
            href={item.href}
            onClick={onItemClick}
            className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
              isActive
                ? 'bg-slate-900 text-white'
                : 'text-slate-700 hover:bg-slate-100'
            }`}
          >
            {item.icon}
            {item.name}
          </Link>
        )
      })}
      <button
        onClick={() => signOut()}
        className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-100 w-full mt-4"
      >
        <LogOut className="w-5 h-5" />
        ログアウト
      </button>
    </nav>
  )
}

export function DashboardLayout({ children }: { children: React.ReactNode }) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-64 lg:flex-col">
        <div className="flex flex-col flex-1 bg-white border-r border-slate-200">
          <div className="flex items-center h-16 px-6 border-b border-slate-200">
            <h1 className="text-lg font-bold text-slate-900">販売管理</h1>
          </div>
          <div className="flex flex-col flex-1 overflow-y-auto py-4">
            <NavLinks />
          </div>
        </div>
      </div>

      <div className="lg:pl-64">
        <div className="sticky top-0 z-10 flex h-16 bg-white border-b border-slate-200 lg:hidden">
          <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" className="ml-2">
                <Menu className="h-6 w-6" />
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="w-64 p-0">
              <div className="flex items-center h-16 px-6 border-b border-slate-200">
                <h1 className="text-lg font-bold text-slate-900">販売管理</h1>
              </div>
              <div className="flex flex-col flex-1 overflow-y-auto py-4">
                <NavLinks onItemClick={() => setMobileMenuOpen(false)} />
              </div>
            </SheetContent>
          </Sheet>
          <div className="flex items-center flex-1 justify-center lg:justify-start">
            <h1 className="text-lg font-bold text-slate-900">販売管理</h1>
          </div>
        </div>

        <main className="p-4 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  )
}
