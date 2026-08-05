import { getSubmission } from './actions'

export const dynamic = 'force-dynamic'

export default async function SubmissionPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const result = await getSubmission(id)

  if ('error' in result && result.error) {
    return <p className="p-8 text-neutral-500">{result.error}</p>
  }

  const s = result.submission!

  return (
    <div className="mx-auto max-w-3xl p-8">
      <h1 className="mb-1 text-2xl font-semibold">Submission</h1>
      <p className="mb-6 text-sm text-neutral-500">
        {new Date(s.created_at).toLocaleString()}
      </p>

      <div className="mb-6 rounded border border-neutral-200 p-5">
        <p className="whitespace-pre-wrap">{s.content}</p>
      </div>

      <dl className="space-y-2 text-sm">
        <div className="flex gap-2">
          <dt className="font-medium">Grade</dt>
          <dd>{s.grade === null ? 'Not yet graded' : `${s.grade}/100`}</dd>
        </div>
        {s.feedback && (
          <div className="flex gap-2">
            <dt className="font-medium">Feedback</dt>
            <dd className="text-neutral-700">{s.feedback}</dd>
          </div>
        )}
      </dl>
    </div>
  )
}
