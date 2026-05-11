# Release plan — v1.2.191

1. Update UI source to version 1.2.191.
2. Add provider hosting due-date UI column.
3. Persist manual dates via users-db sync.
4. Keep panel Internet URL, panel SSH URL and subscription URL logic untouched.
5. Provide a compact source check script.

Acceptance criteria:
- Provider rows have visible provider name and aligned URL columns.
- Hosting payment date can be filled manually per provider.
- Date is saved automatically by existing users-db sync.
- Runtime agent status remains healthy.
