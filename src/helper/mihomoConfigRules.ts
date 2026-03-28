export type RuleFormModel = {
  originalIndex: string
  raw: string
}

export type ParsedRuleEntry = {
  index: number
  lineNo: number
  raw: string
  type: string
  payload: string
  target: string
  provider: string
}

type SectionRange = { start: number; end: number }

const normalizeText = (value: string) => String(value || '').replace(/\r\n/g, '\n')
const escapeRegExp = (value: string) => String(value || '').replace(/[.*+?^${}()|[\]\\]/g, '\\$&')

const findTopLevelSectionRange = (lines: string[], section: string): SectionRange | null => {
  const start = lines.findIndex((line) => new RegExp(`^${escapeRegExp(section)}:\\s*(?:#.*)?$`).test(line || ''))
  if (start < 0) return null
  let end = lines.length
  for (let i = start + 1; i < lines.length; i += 1) {
    const line = String(lines[i] || '')
    if (!line.trim().length || /^\s*#/.test(line)) continue
    if (!/^\s/.test(line)) {
      end = i
      break
    }
  }
  return { start, end }
}

const parseRuleBody = (line: string) => {
  const body = String(line || '').replace(/^\s{2}-\s*/, '').replace(/\s+#.*$/, '').trim()
  const parts = body.split(',').map((part) => part.trim()).filter(Boolean)
  const type = parts[0] || ''
  const payload = type === 'MATCH' ? '' : (parts[1] || '')
  const provider = /^RULE-SET/i.test(type) ? payload : ''
  const target = type === 'MATCH' ? (parts[1] || '') : /^RULE-SET/i.test(type) ? (parts[2] || '') : (parts[2] || parts[parts.length - 1] || '')
  return { raw: body, type, payload, target, provider }
}

const parseRulesRaw = (value: string) => {
  const normalized = normalizeText(value)
  const lines = normalized.length ? normalized.split('\n') : []
  const range = findTopLevelSectionRange(lines, 'rules')
  const entries: ParsedRuleEntry[] = []
  if (!range) return { lines, range, entries }
  let index = 0
  for (let i = range.start + 1; i < range.end; i += 1) {
    const line = String(lines[i] || '')
    if (!/^\s{2}-\s*/.test(line)) continue
    const parsed = parseRuleBody(line)
    entries.push({ index, lineNo: i + 1, ...parsed })
    index += 1
  }
  return { lines, range, entries }
}

const insertRulesSectionIfMissing = (lines: string[], blockLine: string) => {
  const preferredAnchors = ['hosts']
  let insertAt = lines.findIndex((line) => preferredAnchors.some((key) => new RegExp(`^${escapeRegExp(key)}:\\s*(?:#.*)?$`).test(String(line || ''))))
  if (insertAt < 0) insertAt = lines.length
  const sectionLines = ['rules:', blockLine]
  if (insertAt > 0 && String(lines[insertAt - 1] || '').trim().length) sectionLines.unshift('')
  lines.splice(insertAt, 0, ...sectionLines)
}

export const emptyRuleForm = (): RuleFormModel => ({ originalIndex: '', raw: 'MATCH,DIRECT' })

export const ruleFormFromEntry = (entry: ParsedRuleEntry): RuleFormModel => ({ originalIndex: String(entry.index), raw: entry.raw })

export const parseRulesFromConfig = (value: string): ParsedRuleEntry[] => parseRulesRaw(value).entries

export const upsertRuleInConfig = (value: string, form: RuleFormModel) => {
  const normalized = normalizeText(value)
  const nextRaw = String(form.raw || '').trim()
  if (!nextRaw) return normalized
  const parsed = parseRulesRaw(normalized)
  const lines = [...parsed.lines]
  const ruleLine = `  - ${nextRaw}`
  const originalIndex = Number.parseInt(String(form.originalIndex || ''), 10)
  if (!parsed.range) {
    insertRulesSectionIfMissing(lines, ruleLine)
  } else {
    const ruleLines = parsed.entries.map((entry) => entry.lineNo - 1)
    if (Number.isFinite(originalIndex) && originalIndex >= 0 && originalIndex < ruleLines.length) lines[ruleLines[originalIndex]] = ruleLine
    else lines.splice(parsed.range.end, 0, ruleLine)
  }
  let joined = lines.join('\n').replace(/\n{3,}/g, '\n\n').trimEnd()
  return joined ? `${joined}\n` : ''
}

export const removeRuleFromConfig = (value: string, ruleIndex: number) => {
  const normalized = normalizeText(value)
  const parsed = parseRulesRaw(normalized)
  const lines = [...parsed.lines]
  const target = parsed.entries.find((entry) => entry.index === ruleIndex)
  if (!target) return normalized
  lines.splice(target.lineNo - 1, 1)
  if (parsed.range) {
    const remaining = parseRulesRaw(lines.join('\n')).entries
    if (!remaining.length) {
      const lines2 = lines.join('\n').split('\n')
      const range2 = findTopLevelSectionRange(lines2, 'rules')
      if (range2) lines2.splice(range2.start, Math.max(1, range2.end - range2.start), 'rules: []')
      let joined = lines2.join('\n').replace(/\n{3,}/g, '\n\n').trimEnd()
      return joined ? `${joined}\n` : ''
    }
  }
  let joined = lines.join('\n').replace(/\n{3,}/g, '\n\n').trimEnd()
  return joined ? `${joined}\n` : ''
}
