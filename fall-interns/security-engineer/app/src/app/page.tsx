import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'

export const dynamic = 'force-dynamic'

export default async function HomePage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return (
      <div className="mx-auto max-w-3xl p-8">
        <h1 className="mb-3 text-2xl font-semibold">Coursely</h1>
        <p className="text-neutral-600">
          A course platform for universities. <Link href="/login" className="underline">Sign in</Link> to continue.
        </p>
      </div>
    )
  }

  const { data: sections } = await supabase.from('sections').select('id, code, title')

  return (
    <div className="mx-auto max-w-3xl p-8">
      <h1 className="mb-6 text-2xl font-semibold">Your sections</h1>
      <ul className="space-y-2">
        {(sections ?? []).map((s) => (
          <li key={s.id} className="rounded border border-neutral-200 px-4 py-3">
            <span className="font-medium">{s.code}</span>
            <span className="text-neutral-500"> — {s.title}</span>
          </li>
        ))}
      </ul>
      {(sections ?? []).length === 0 && (
        <p className="text-neutral-500">No sections visible to you.</p>
      )}
    </div>
  )
}
