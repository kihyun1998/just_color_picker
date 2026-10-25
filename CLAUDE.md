# CLAUDE.md

## Agent skills

| Before you… | Read |
|---|---|
| create, read, comment on, label or close an issue | `docs/agents/issue-tracker.md` |
| apply a triage label | `docs/agents/triage-labels.md` |
| name a domain concept, or work in an area an ADR may cover | `docs/agents/domain.md` |

## Territory map

The map is [`docs/map/README.md`](docs/map/README.md). Before designing a change, open the territory it touches and work through its `## Blast radius` and `## Cross-cutting invariants`. After it lands, update the notes it made false. When a fix reveals a fact, ask whether it holds at every site that shares the same assumption; if it does, the fix lands with an invariant note.

## Comments

A comment says what the code is. Why it is this way, what it deliberately leaves out, the trap and the measured value go to the territory note under `docs/map/`. Where none seems to hold it, search the folder and the code symbol first; only then start a new note, named for what the system does there, not for the file. History goes to the commit message. Comments written before this rule still carry the rest: never delete one whose content the map does not yet hold — move it first (`decant`).
