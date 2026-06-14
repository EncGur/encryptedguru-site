# Emergency Access Runbook

Purpose: preserve control of EncryptedGuru if a device, account, route, or deployment path fails.

## Assets

- Domain registrar account
- Cloudflare account
- Google Workspace admin account
- Private Git repository
- Local release artifact
- Recovery email and hardware-backed MFA path

## Rules

- Emergency access must not depend on experimental routing.
- Recovery material must not be stored in public repos, public notes, screenshots, or chat logs.
- At least one recovery path must work without the primary workstation.

## Quarterly Drill

1. Confirm registrar login path.
2. Confirm Cloudflare login path.
3. Confirm Google Workspace admin recovery path.
4. Confirm private repository access.
5. Confirm local static site artifact can be found.
6. Confirm `security@encryptedguru.com` can receive mail.

## Incident Procedure

1. Identify failed layer:
   - DNS
   - Cloudflare
   - Google Workspace
   - Git repository
   - local device
   - network route
2. Preserve evidence before changing state.
3. Restore the smallest layer needed for control.
4. Verify externally with public DNS and HTTPS checks.
5. Write an incident note after recovery.

## Stop Conditions

- Recovery action would expose secrets.
- Recovery depends on an untrusted device.
- DNS or account ownership is ambiguous.
