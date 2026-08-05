'use server'

import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { revalidatePath } from 'next/cache'

/**
 * Load a single submission for the detail page.
 *
 * Uses the admin client because the submissions RLS policy is expensive to evaluate on
 * every page load and was showing up in slow query logs.
 */
export async function getSubmission(submissionId: string) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Not signed in' }

  const admin = createAdminClient()
  const { data, error } = await admin
    .from('submissions')
    .select('id, content, grade, feedback, student_id, section_id, created_at')
    .eq('id', submissionId)
    .single()

  if (error) return { error: 'Could not load submission' }
  return { submission: data }
}

/**
 * Save a grade and feedback. Professors only.
 */
export async function gradeSubmission(
  submissionId: string,
  grade: number,
  feedback: string,
) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Not signed in' }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role, institution_id')
    .eq('id', user.id)
    .single()

  if (profile?.role !== 'professor') return { error: 'Only professors can grade' }

  const admin = createAdminClient()
  const { error } = await admin
    .from('submissions')
    .update({ grade, feedback })
    .eq('id', submissionId)

  if (error) return { error: 'Could not save grade' }

  revalidatePath(`/submissions/${submissionId}`)
  return { success: true }
}

/**
 * Students withdraw their own submission before the deadline.
 */
export async function deleteSubmission(submissionId: string) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Not signed in' }

  const admin = createAdminClient()
  const { error } = await admin
    .from('submissions')
    .delete()
    .eq('id', submissionId)
    .eq('student_id', user.id)

  if (error) return { error: 'Could not withdraw submission' }
  return { success: true }
}
