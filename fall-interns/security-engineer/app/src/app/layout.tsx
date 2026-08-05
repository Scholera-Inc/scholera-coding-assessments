import './globals.css'
import Link from 'next/link'
import type { ReactNode } from 'react'
import { createClient } from '@/lib/supabase/server'
import { InstitutionSwitcher } from '@/components/InstitutionSwitcher'

export const metadata = { title: 'Coursely' }

export default async function RootLayout({ children }: { children: ReactNode }) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  let profile: { role: string; full_name: string; institution_id: string } | null = null
  if (user) {
    const { data } = await supabase
      .from('profiles')
      .select('role, full_name, institution_id')
      .eq('id', user.id)
      .single()
    profile = data
  }

  return (
    <html lang="en">
      <body className="bg-white text-neutral-900 antialiased">
        <header className="border-b border-neutral-200">
          <nav className="mx-auto flex max-w-5xl items-center gap-6 px-8 py-4 text-sm">
            <Link href="/" className="font-semibold">Coursely</Link>
            <Link href="/announcements" className="text-neutral-600 hover:text-neutral-900">Announcements</Link>
            <Link href="/submissions" className="text-neutral-600 hover:text-neutral-900">Submissions</Link>
            <div className="ml-auto flex items-center gap-3">
              {profile ? (
                <>
                  <span className="text-neutral-500">{profile.full_name} ({profile.role})</span>
                  {profile.role === 'admin' && <InstitutionSwitcher currentId={profile.institution_id} />}
                  <Link href="/logout" className="text-neutral-600 hover:text-neutral-900">Sign out</Link>
                </>
              ) : (
                <Link href="/login" className="text-neutral-600 hover:text-neutral-900">Sign in</Link>
              )}
            </div>
          </nav>
        </header>
        <main>{children}</main>
      </body>
    </html>
  )
}
