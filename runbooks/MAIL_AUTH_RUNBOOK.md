# Mail Authentication Runbook

Purpose: keep EncryptedGuru mail deliverable while reducing spoofing risk.

## Baseline

- MX: `1 smtp.google.com.`
- SPF: `v=spf1 include:_spf.google.com ~all`
- DKIM: Google Workspace selector at `google._domainkey.encryptedguru.com`
- DMARC: `_dmarc.encryptedguru.com`

## Verification

```sh
dig @1.1.1.1 encryptedguru.com MX
dig @1.1.1.1 encryptedguru.com TXT
dig @1.1.1.1 google._domainkey.encryptedguru.com TXT
dig @1.1.1.1 _dmarc.encryptedguru.com TXT
```

Send test mail from and to:
- `contact@encryptedguru.com`
- `security@encryptedguru.com`
- `ops@encryptedguru.com`
- `alerts@encryptedguru.com`

## DMARC Policy Ladder

1. Start with `p=none`.
2. Review aggregate reports.
3. Move to `p=quarantine` only after all legitimate senders pass alignment.
4. Move to `p=reject` only after quarantine is clean.

## Stop Conditions

- Any expected sender fails SPF and DKIM alignment.
- Aggregate reports show unknown legitimate mail sources.
- Users report bounced mail after policy change.

## Rollback

Return DMARC to `p=none` and retest delivery.
