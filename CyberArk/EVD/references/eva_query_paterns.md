# EAV Query Patterns — CAObjectProperties

> On-demand reference. Load when writing any query that pivots CAObjectProperties columns.

---

## Join Strategy

Never use multiple JOINs (one per property). A missing property row will silently drop accounts or cause row multiplication.

Always use:

- Single `JOIN CAObjectProperties` (no property name filter on the JOIN)
- `GROUP BY` on the `CAFiles` key columns
- `MAX(CASE WHEN op.CAObjectPropertyName = '...' THEN op.CAObjectPropertyValue END)` to pivot each property
- `HAVING` to filter on pivoted property values

---

## Boolean-Style Properties (e.g. CPMDisabled)

Some properties do not store `'yes'` / `'no'`. Presence of any value means the condition is true.

| State    | Stored value           | Meaning            | SQL filter              |
|----------|------------------------|--------------------|-------------------------|
| Disabled | Any non-empty string   | Condition is true  | `IS NOT NULL AND <> ''` |
| Active   | NULL or absent row     | Condition is false | *(default — no filter)* |

**Never match a specific string value** (e.g. `'yes'`, `'(CPM)MaxRetries'`).

Always use:
```sql
HAVING MAX(CASE WHEN op.CAObjectPropertyName = 'CPMDisabled'
                THEN op.CAObjectPropertyValue END) IS NOT NULL
   AND MAX(CASE WHEN op.CAObjectPropertyName = 'CPMDisabled'
                THEN op.CAObjectPropertyValue END) <> ''
```