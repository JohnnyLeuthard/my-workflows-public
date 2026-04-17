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

---

## Identifying Accounts with Scheduled Tasks

When the user asks for "scheduled tasks attached to accounts" (or similar), filter on the **Task Scheduling** property family — NOT on `LastTask`.

### Why `LastTask` is wrong

`LastTask` lives in the CPM/Password Management property family and records the **last CPM task executed** against the account (e.g. `ChangeTask`, `VerifyTask`, `ReconcileTask`). It is task history. Its presence — and its value — say nothing about whether the account currently has a scheduled task definition. Filtering on `LastTask IS NOT NULL` (or matching `LastTask = 'ChangeTask'`) returns accounts that have ever been touched by CPM, which is not the same population.

### Correct indicator properties

Presence of any of these indicates a scheduled task is attached to the account:

- `TaskName` — most reliable; named task definition
- `TaskDefinitionId` — the task's definition ID
- `TaskScheduleType` — schedule type (e.g. recurring, one-time)

Use the EAV pivot pattern with `IS NOT NULL AND <> ''`:

```sql
HAVING MAX(CASE WHEN op.CAObjectPropertyName = 'TaskName'
                THEN op.CAObjectPropertyValue END) IS NOT NULL
   AND MAX(CASE WHEN op.CAObjectPropertyName = 'TaskName'
                THEN op.CAObjectPropertyValue END) <> ''
```

If the user asks for a richer view, also pivot `TaskScheduleType`, `TaskNextScheduleDate`, `TaskLastRunDate`, `TaskStatus` for the SELECT list, but keep the `HAVING` filter on a presence indicator (`TaskName` / `TaskDefinitionId`).

### Quick rule

> `Task*` properties (Task Scheduling section) = scheduled task definition.
> `LastTask` (CPM section) = history of the last CPM action. Never use as a scheduled-task filter.