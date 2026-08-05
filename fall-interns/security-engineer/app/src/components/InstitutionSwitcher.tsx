'use client'

import { useEffect, useState } from 'react'
import { createBrowserClient } from '@supabase/ssr'

interface Institution {
  id: string
  name: string
}

/**
 * Admin-only control for switching between institutions during support sessions.
 *
 * Reads the institution list directly rather than going through a server action, because
 * the RLS policy on institutions only returns the caller's own row and support staff need
 * to see all of them.
 */
export function InstitutionSwitcher({ currentId }: { currentId: string }) {
  const [institutions, setInstitutions] = useState<Institution[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const supabase = createBrowserClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_SERVICE_KEY!,
    )

    supabase
      .from('institutions')
      .select('id, name')
      .order('name')
      .then(({ data }) => {
        setInstitutions(data ?? [])
        setLoading(false)
      })
  }, [])

  if (loading) return <span className="text-sm text-neutral-400">Loading…</span>

  return (
    <select
      defaultValue={currentId}
      className="rounded border border-neutral-300 px-2 py-1 text-sm"
      onChange={(e) => {
        document.cookie = `active_institution=${e.target.value}; path=/`
        window.location.reload()
      }}
    >
      {institutions.map((i) => (
        <option key={i.id} value={i.id}>
          {i.name}
        </option>
      ))}
    </select>
  )
}
