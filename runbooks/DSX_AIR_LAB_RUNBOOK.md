# DSX Air Lab Runbook

Purpose: keep NVIDIA DSX Air work bounded, repeatable, and safe to summarize
publicly.

## Operating Rule

DSX Air is a simulation lab. It is not a production VPS, not a credential store,
and not a place for uncontrolled long-running services.

## Preflight

- Define the learning question before starting a lab.
- Record the intended topology at a high level.
- Confirm the stop condition.
- Confirm what must stay private:
  - account URLs
  - screenshots with user/account identifiers
  - raw configs
  - private IP plans if they reveal live systems
  - credentials, tokens, keys, cookies, or recovery details

## Session Template

```text
Date:
Question:
Topology:
Nodes:
Resource notes:
Change made:
Expected result:
Observed result:
Failure mode:
Rollback:
Public-safe lesson:
Stop condition met:
```

## First Experiment Queue

1. Inventory a minimal topology.
2. Verify baseline reachability.
3. Separate management, lab, public-service, and recovery paths in the model.
4. Run one deliberate failure drill.
5. Reduce the lesson into a public-safe note under `/labs/dsx-air/`.

## Verification

A lab note is complete only when it has:

- a learning objective
- a topology summary
- observed behavior
- rollback path
- public/private reduction decision

## Stop Conditions

- Resource usage is unclear.
- Account state or billing becomes unclear.
- A screenshot or config contains sensitive material.
- The lab starts becoming a production dependency.
- The rollback path is not known.

