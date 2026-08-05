import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'

export const dynamic = 'force-dynamic'

export default async function SubmissionsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return <p className="p-8">Please sign in.</p>

  const { data } = await supabase
    .from('submissions')
    .select('id, grade, created_at, student:profiles!student_id(full_name)')
    .order('created_at', { ascending: false })

  const rows = (data ?? []) as unknown as {
    id: string; grade: number | null; created_at: string; student: { full_name: string } | null
  }[]

  return (
    <div className="mx-auto max-w-3xl p-8">
      <h1 className="mb-6 text-2xl font-semibold">Submissions</h1>
      {rows.length === 0 ? (
        <p className="text-neutral-500">Nothing to show.</p>
      ) : (
        <ul className="divide-y divide-neutral-200">
          {rows.map((s) => (
            <li key={s.id} className="flex items-center justify-between py-3">
              <Link href={`/submissions/${s.id}`} className="underline">
                {s.student?.full_name ?? 'Unknown student'}
              </Link>
              <span className="text-sm text-neutral-500">
                {s.grade === null ? 'Ungraded' : `${s.grade}/100`}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
