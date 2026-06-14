# DNS Change Runbook

Purpose: change EncryptedGuru DNS without losing web, mail, or recovery access.

## Preconditions

- Confirm domain registrar access.
- Confirm Cloudflare access.
- Confirm Google Workspace admin or recovery access.
- Record current DNS state before edits.

## Current Baseline

- Web is served through Cloudflare.
- Apex redirects to `https://www.encryptedguru.com/`.
- Google Workspace MX is `1 smtp.google.com.`.
- SPF is `v=spf1 include:_spf.google.com ~all`.
- DMARC exists at `_dmarc.encryptedguru.com`.
- DKIM exists at `google._domainkey.encryptedguru.com`.

## Change Procedure

1. Write the intended change, reason, rollback, and verifier.
2. Export or screenshot current DNS records.
3. Change one record group at a time.
4. Verify with public resolvers:

```sh
dig @1.1.1.1 encryptedguru.com A
dig @1.1.1.1 www.encryptedguru.com A
dig @1.1.1.1 encryptedguru.com MX
dig @1.1.1.1 encryptedguru.com TXT
dig @1.1.1.1 _dmarc.encryptedguru.com TXT
dig @1.1.1.1 google._domainkey.encryptedguru.com TXT
```

5. Verify web:

```sh
curl -I -L https://encryptedguru.com/
curl -I https://www.encryptedguru.com/
```

6. Verify mail by sending and receiving a test message through the affected alias.

## Rollback

Restore the prior record values captured in preflight. Verify with `dig @1.1.1.1` and `dig @8.8.8.8`.

## Stop Conditions

- Google Workspace MX disappears.
- Apex or `www` stops resolving from public resolvers.
- Cloudflare SSL mode or proxying state becomes unclear.
- Mail delivery fails after an email-authentication change.
