'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createBrowserClient } from '@supabase/ssr'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('TakeHome123!')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setError(null)

    const supabase = createBrowserClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    )
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    setBusy(false)

    if (error) setError(error.message)
    else { router.push('/'); router.refresh() }
  }

  return (
    <form onSubmit={onSubmit} className="mx-auto max-w-sm p-8">
      <h1 className="mb-6 text-2xl font-semibold">Sign in</h1>
      <label className="mb-3 block text-sm">
        Email
        <input
          value={email} onChange={(e) => setEmail(e.target.value)} type="email" required
          className="mt-1 w-full rounded border border-neutral-300 px-3 py-2"
        />
      </label>
      <label className="mb-4 block text-sm">
        Password
        <input
          value={password} onChange={(e) => setPassword(e.target.value)} type="password" required
          className="mt-1 w-full rounded border border-neutral-300 px-3 py-2"
        />
      </label>
      {error && <p className="mb-3 text-sm text-red-600">{error}</p>}
      <button
        type="submit" disabled={busy}
        className="w-full rounded bg-neutral-900 px-4 py-2 text-white disabled:opacity-50"
      >
        {busy ? 'Signing in…' : 'Sign in'}
      </button>
    </form>
  )
}
