# Handoff Record Template

> Reference material for the [`pair-programming`](../SKILL.md) skill.


When transferring work between agent and human (or ending session):

```markdown
## Pairing Session Handoff

**Session**: 2026-01-16 09:00-12:00
**Issue**: #123 - Add user authentication
**Mode**: Full pairing / Minimal

### Completed

- [x] Implemented JWT token generation
- [x] Added login endpoint
- [x] Unit tests for auth service (87% coverage)

### In Progress

- [ ] Integration tests (started, 2 of 5 done)
- [ ] Error handling for token expiry

### Blocked / Needs Discussion

- [ ] Token refresh strategy - need to decide between sliding vs fixed expiry
- [ ] Rate limiting approach - waiting on architecture decision

### Context for Next Session

The auth service is in `src/Auth/`. Tests are in `tests/Auth/`.
Current approach follows the JWT pattern from `docs/adr/0003-authentication.md`.
Main question: Should we use refresh tokens or just re-authenticate?

### Files Modified

- `src/Auth/TokenService.cs` - New file
- `src/Auth/LoginHandler.cs` - New file
- `src/Api/Endpoints/AuthEndpoints.cs` - Added login route
- `tests/Auth/TokenServiceTests.cs` - New file

### PR Status

PR #456 - Draft, not ready for review
CI: Passing (unit tests only, integration pending)
```

### Handoff Commands

```bash
# Agent posts handoff record
gh issue comment N --body "$(cat handoff-record.md)"

# Add handoff label
gh issue edit N --add-label "pair-programming:handoff"

# Remove active label
gh issue edit N --remove-label "pair-programming:active"
```
