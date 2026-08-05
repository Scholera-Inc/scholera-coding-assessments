import { createClient } from '@/lib/supabase/server'

export const dynamic = 'force-dynamic'

interface Announcement {
  id: string
  title: string
  body: string
  created_at: string
  author: { full_name: string } | null
}

export default async function AnnouncementsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return <p className="p-8">Please sign in.</p>
  }

  const { data } = await supabase
    .from('announcements')
    .select('id, title, body, created_at, author:profiles!author_id(full_name)')
    .order('created_at', { ascending: false })

  const announcements = (data ?? []) as unknown as Announcement[]

  if (announcements.length === 0) {
    return <p className="p-8 text-neutral-500">No announcements yet.</p>
  }

  return (
    <div className="mx-auto max-w-3xl p-8">
      <h1 className="mb-6 text-2xl font-semibold">Announcements</h1>

      <ul className="space-y-6">
        {announcements.map((a) => (
          <li key={a.id} className="rounded-lg border border-neutral-200 p-5">
            <h2 className="text-lg font-medium">{a.title}</h2>
            <p className="mb-3 text-sm text-neutral-500">
              {a.author?.full_name ?? 'Unknown'} — {new Date(a.created_at).toLocaleDateString()}
            </p>

            {/*
              Professors compose announcements in a rich text editor, so the body arrives
              as HTML and has to be rendered as markup rather than escaped text.
            */}
            <div
              className="prose prose-sm"
              dangerouslySetInnerHTML={{ __html: a.body }}
            />
          </li>
        ))}
      </ul>
    </div>
  )
}
