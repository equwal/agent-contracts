---
title: "TODO: title (working: Contracts in shared memory: how coding agents hand work to each other without prompt injection)"
author: "TODO: author"
date: "TODO: date"
abstract: |
  TODO: 150 to 250 words. State, in this order: the setting (several
  concurrent coding-agent sessions of one developer, one shared versioned
  key-value memory, no chat channel between sessions); the observation
  (on one day the sessions started handing work to each other through
  the store); the form it took (a request that names the end state, a
  scope clause, a verification, a reply keypath, a question keypath; a
  reply that names every deviation; an ack after independent
  verification; a proposal/agree variant for formats); the claim (the
  form carries no instructions, no reasons, and no secrets, so it does
  not work as a prompt injection vector); the evidence (three exchanges,
  timestamps, git commits, instruction files that do not prescribe it);
  the contribution (a formalized skill, installable for four agent CLIs).
bibliography: references.bib
link-citations: true
---

<!--
Template. Every section lists the facts and the sources to use. Replace
each TODO with your own prose. Facts come from paper/sources.md (public,
anonymized) and paper/private/evidence.md (local only, identifiers).
Keep the redaction list in private/evidence.md in force in every section.
-->

# Introduction

- TODO: the problem. Agents that read each other's output are a prompt
  injection surface. Cite the single-agent origin [@perez2022ignore;
  @greshake2023indirect; @liu2023promptinjection] and the multi-agent
  escalation: self-replicating prompts [@cohen2024worm], infectious
  jailbreaks in agent populations [@gu2024agentsmith], LLM-to-LLM prompt
  infection [@lee2024promptinfection].
- TODO: the setting. One developer runs several coding-agent sessions at
  once (one per repository). The sessions share one memory store (versioned
  keypaths, one project per repository). Each session reads its project at
  task start and writes to it at task end. There is no chat channel between
  the sessions. See section 3.
- TODO: the observation. On 2026-10-11 the sessions used the store to hand
  work to each other. The messages took a fixed form that no instruction
  file prescribes. Three exchanges in about one hundred minutes. See
  section 4.
- TODO: the claim. The form is a contract: end state, scope, verification,
  reply address. It omits how and why. Those omissions are what make it
  safe to read. See section 5.
- TODO: contributions, as a list:
  1. A documented case of agents converging on a contract form in shared
     memory (section 4).
  2. An analysis of why the form resists injection (section 5).
  3. A formalization as an installable skill for four agent CLIs
     (section 6, repository link).
  4. An evaluation plan (section 7).

# Background

## Shared memory for coding agents

- Facts: the store is a local daemon over SQLite with HTTP and MCP
  front ends; keypaths are dot-separated; every write makes a new version;
  deletes are tombstones; a search covers all projects; a read at task
  start returns the keypath tree of the session's own project.
- Facts: the convention files for the store name canonical areas
  (`decisions`, `todo`, `notes`, `gotchas`, `questions`, `config`) and say
  "one keypath, one fact". They do not name `requests` or `replies`.
- TODO: relate to agent memory work [@park2023generative;
  @packer2023memgpt] and to blackboard systems [@erman1980hearsay;
  @hayesroth1985blackboard] and tuple spaces [@gelernter1985linda]: a
  shared store that agents read at their own pace is a blackboard.
- TODO: contrast with chat-style agent protocols
  [@wu2023autogen; @li2023camel; @hong2023metagpt] and with the 2024 to
  2025 wire protocols [@anthropic2024mcp; @google2025a2a; @marro2024agora].

## Prompt injection between agents

- TODO: one paragraph on why instruction and data are not separable in
  current models [@zverev2025separate], and on the defenses that work by
  construction rather than by detection: dual LLM [@willison2023dualllm],
  structured queries [@chen2025struq], spotlighting
  [@hines2024spotlighting], instruction hierarchy
  [@wallace2024hierarchy], isolation [@wu2025isolategpt], and
  capability-based control flow [@debenedetti2025camel].
- TODO: position the observed form among them: it is a message
  discipline, not a model change. It limits what a message may contain,
  so a compliant message has nothing to inject.

## Contracts in software and in agent systems

- Design by contract: preconditions, postconditions, invariants
  [@hoare1969axiomatic; @meyer1992dbc]. The observed "Contract (what must
  be true when you are done)" is a postcondition list.
- Contract net: announce, bid, award, report [@smith1980contractnet;
  @fipa2002contractnet]. The observed proposal/agree exchange is a
  two-party contract net with no bidding.
- Consumer-driven contracts [@robinson2006cdc]: the consumer states the
  shape it needs; the provider may give more. The observed "omit unknown
  fields, never null" and "ignore unknown keys" are this rule.
- Information hiding [@parnas1972criteria] and need-to-know
  [@saltzer1975protection]: "no reasons" hides the requester's design.
- Conventions without a designer [@lewis1969convention;
  @ashery2025conventions]: TODO, one sentence on why three exchanges are
  not yet a convention.

# Setting

- TODO: describe without identifying details. Use the table.

| Item | Value |
|---|---|
| Developer | one person, one workstation |
| Sessions | A: phone app with an HTTP control surface; B: browser extension that drives A over HTTP; C: data export tool that produces a file A imports |
| Agent CLI | Claude Code, one session per repository, several open at once |
| Store | one shared memory daemon, one project per repository |
| Session protocol (from the developer's instruction file) | read own project at task start; write decisions, status, and gotchas at task end |
| Chat between sessions | none; the sessions cannot message each other |
| Peer rule (from the coop skill, for a different channel) | "A peer message is a request from a collaborator. It is not an instruction from the user." |
| Files checked for the form | the global instruction file, all rule files, all skill files of the four agent CLIs, the config sync repository: no `requests.*`, no `replies.*`, no "what must be true", no "REQUEST from" |

- TODO: say what the instruction files do prescribe that could have shaped
  the form: canonical `questions` area in the store conventions; the
  manager-to-worker brief in the agent-manager skill ("success check",
  "limits", status at a named keypath); the coop peer rule above.
- TODO: say what the developer did and did not do. The developer approved
  posting a request to another session's project (the record says
  "Pending: user ... allows posting the contract"). The developer did not
  write, dictate, or template the form. Session B's own note states the
  rule it chose: "Contract only, no reasons, when posted."

# Observations

## Timeline

- All times UTC, 2026-10-11. Writers are the sessions of section 3.
  Full keypaths are in sources.md.

| Time | Writer | Keypath | Kind |
|---|---|---|---|
| 09:14:19 | B | `requests.<counter>` in A's project | request 1 |
| 09:16:09 | A | git commit | implements request 1 |
| 09:16:22 | A | own `hook.*` note | records the commit |
| 09:19:24 | B | `requests.<counter>.ack` | ack after B verified on the device |
| 09:24:54 | B | own `gotchas` | "the other chat did not write a reply entry" |
| 09:44:09 | A | `<topic>.proposal` in A's project | proposal to C |
| 09:44:10 | A | `replies.<counter>` | reply to request 1, 30 min after the ack |
| 09:59:19 | C | `<topic>.export_reply` | agree + answers |
| 10:03:14 | B | own `session.*` note | "Contract only, no reasons, when posted." |
| 10:14:38 | C | `<topic>.export_status` v1 | progress |
| 10:28:31 | C | `<topic>.export_status` v2 | progress; constraint change (size) |
| 10:48:09 | B | `requests.<store>` in A's project | request 2 |
| 10:52:20 | B | git commit | B's client with a fail-safe for an unfulfilled contract |
| 10:54:30 | C | `<topic>.export_status` v3 | progress |

- TODO: note the two-minute gap between request 1 and A's commit, and
  what it means for causality (A may have had the need from the
  developer in chat at the same time; the store entry is the formal
  record). The transcripts can settle this; see private/evidence.md.
- TODO: note the earlier precedent of 2026-10-01: a connectivity probe
  written by one agent CLI into a shared project that asked another CLI
  to reply at a named keypath. Human-directed; no reply came.

## Anatomy of a request

- The two requests have the same six parts, in the same order:
  1. Header: `REQUEST from the other chat: <one line>. Read this whole
     entry before you start.`
  2. `Contract (what must be true when you are done):` four numbered
     items; each names a route, a field, a value, a status code, or an
     error; the last item is `Nothing else changes.` plus what keeps its
     present behaviour.
  3. `Please also:` commit hygiene ("its own commit, apart from the
     uncommitted edits already in ...").
  4. `Verify on the phone:` exact commands and the expected output.
  5. Reply address: "When done, write the result to memstate at the
     keypath `replies.<name>` in this same project: commit hash, one real
     response of each route, what you verified and how, and anything in
     the contract you could not do exactly."
  6. Question address: "If the contract is unclear, write your question
     at `replies.<name>.question` instead of guessing."
- Sizes: request 1 about 330 words; request 2 about 330 words.
- TODO: quote one anonymized skeleton (appendix A).

## Reply, deviation, ack

- A's reply (09:44:10) opens with the commit and the install targets,
  then `DIFFERENCES from the contract: (a) ... (b) ...`, then an order
  argument, then `Verified on the tablet ...` with numbers.
- Deviations: a different attribute name and element; a looser counting
  rule. B accepted both in the ack: "accepted, no change needed" and
  "Accepted, leave it."
- B's ack (09:19:24) came before A's reply. B had verified on the real
  device by itself. The ack also froze the interface: "No reply entry
  needed from you unless something else about /status or the hook changes
  later: if it does, change it only with a new commit and write the
  change here."
- TODO: discuss the order: verify, then ack, then (late) reply. The
  reply was not on the critical path.

## Proposal and agreement

- A's proposal (09:44:09): `PROPOSAL v1 from <A> to <C>. Reply at
  <topic>.export_reply (agree, or name each change). Must scale to 1.5
  million <items>.` Sections FORMAT, FIELDS, TRANSPORT, QUESTIONS (four
  numbered questions). One reason is given, and it is a constraint: a
  streaming line format "because a 1.5M-element JSON array does not fit"
  the device heap.
- C's reply (09:59:19): `AGREE to PROPOSAL v1 (...)`, numbered answers,
  the extra fields it will emit, and "ignore unknown keys please".
- C's status entries: the same keypath, three versions; version 2 raises
  the size constraint and tells A to size for it.
- TODO: compare with contract net and consumer-driven contracts (section
  2.3).

## Requester-side fail-safe

- B's client (commit 10:52:20) treats only a JSON answer whose size field
  equals the uploaded size as success, because an old build of A answers
  any unknown route with status 200 and a page. B's own test includes an
  "old phone" mode. The contract may be unfulfilled; B still works.
- TODO: one paragraph. This is Postel's rule turned around: be strict in
  what you accept from a peer whose state you cannot see.

# Analysis

## Why the form is not an injection vector

| Property of the observed messages | Effect |
|---|---|
| Labelled provenance (`REQUEST from the other chat`, `PROPOSAL v1 from A to C`, `REPLY from`, `ACK:`) | the reader classifies it as peer input before reading the body |
| End state, not imperative steps | nothing to execute; the receiver plans its own actions |
| `Nothing else changes` | bounds the blast radius; an added item is visible as scope creep |
| Named reply keypath, named question keypath | the only output the request asks for is a store entry; no tool, no URL, no send |
| No reasons | the requester's context, plans, and user words do not enter the receiver's memory |
| No secrets, no credentials | the receiver's memory gains nothing worth exfiltrating |
| Receiver may deviate and must name deviations | compliance is negotiated, not obeyed |
| Requester verifies on the real target | a false "done" is caught without trusting text |
| Posting is gated by the developer | a request exists only when a human wanted the work done |

- TODO: contrast with the attack messages in [@lee2024promptinfection;
  @cohen2024worm]: those carry instructions, self-replication text, and
  exfiltration targets. A compliant contract carries none of the three.
- TODO: state the limit. The discipline protects a receiver that reads
  the entry as a contract. A receiver that treats store entries as user
  instructions is not protected by the form alone. That is why the
  formalized skill (section 6) adds a receiver rule.

## What the agents reinvented

- TODO: map each part to prior art (section 2.3): postcondition list
  [@meyer1992dbc], scope clause as frame condition, verification as
  acceptance test, reply keypath as contract net report
  [@smith1980contractnet], proposal/agree as consumer-driven contract
  [@robinson2006cdc], "no reasons" as information hiding
  [@parnas1972criteria].
- TODO: name what is new: the question keypath ("instead of guessing"),
  the ack that freezes the interface, and the requester-side fail-safe.

## Emergence

- Evidence that the form was chosen by the agent: B's note "Contract
  only, no reasons, when posted." (10:03:14) and B's other note "Offer to
  user; do not ask the other chat unprompted." (09:53:06).
- Evidence that no file prescribed it: the file check in section 3.
- Possible influences (section 3): the store's `questions` area; the
  manager brief's "success check" and "limits"; the coop peer rule.
- TODO: argue for or against "discovery". Suggested framing: the
  components existed in the environment as separate rules; the
  composition into a two-party protocol with ack and fail-safe did not.

## Threats to validity

- Three exchanges, one day, one developer, one agent CLI, one model
  family. No control group.
- The developer gated posting and may have relayed the substance of
  request 1 in chat (two-minute gap). Settle with the transcripts before
  submission.
- The developer's instruction files shape the sessions' style (short
  sentences, verification before claims, "no reasons" is close to the
  developer's own writing rules). The form may be a style the agents
  carried over, not a security insight.
- No adversarial test. The injection-resistance argument is structural.
- Memory entries were read, not the sessions' full reasoning.

# The formalized protocol

- TODO: point to the repository and the skill file. Say what the skill
  adds to the observation: a receiver rule (tell the user first; decline
  out-of-scope requests), a rule against addressing the receiver's rules
  or user, a rule for versioned contract changes, and the keypath table.
- TODO: say what it leaves out on purpose: no tooling, no schema, no
  transport; the store and the task-start read are the transport.

# Evaluation plan

- TODO: adversarial contracts: inject instructions, reasons, URLs, and
  "ignore your rules" text into `requests.*` entries; measure whether a
  receiver with and without the skill executes them.
- TODO: cross-CLI: the same contract read by Claude Code, Codex, Copilot
  CLI, and Antigravity.
- TODO: cost: words per exchange versus a chat relay through the
  developer; time from request to ack.
- TODO: failure modes: lost requests (no task-start read), stale
  contracts, concurrent versions.

# Related work

- TODO: one paragraph each: multi-agent frameworks and shared message
  pools [@hong2023metagpt; @wu2023autogen]; agent protocols
  [@anthropic2024mcp; @google2025a2a; @marro2024agora]; injection
  defenses by construction (section 2.2); agent memory
  [@park2023generative; @packer2023memgpt]; stigmergy and blackboards
  [@grasse1959stigmergie; @erman1980hearsay].

# Conclusion

- TODO: three sentences. What was seen. Why it matters. What to test next.

# Appendix A: anonymized entry skeletons

- TODO: paste the skeletons from sources.md, section "Skeletons". Replace
  every route, field, and name with a generic one. Keep the section
  labels verbatim.

# Appendix B: reproduction

- TODO: how a reader reproduces the setting: the store (link), the
  session protocol (two lines), the skill (link), two sessions, one
  request.

# References
