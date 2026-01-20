# Example: Quick Review Output

## Sample Code

```python
def login(username, password):
    # Check credentials
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    user = db.execute(query)

    if user:
        session_token = generate_token(username)
        log.info(f"User {username} logged in with password {password}")
        return {"token": session_token, "expires": "2030-12-31"}
    else:
        return {"error": "Invalid credentials"}

def generate_token(username):
    import random
    return str(random.randint(1000, 9999))
```

---

## Quick Review Output

### Critical (fix now)

**1. SQL Injection Vulnerability (Line 3)**
```python
query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
```
Using string interpolation for SQL queries allows injection attacks. An attacker can input `' OR '1'='1` as username to bypass authentication.

**Fix:** Use parameterized queries
```python
query = "SELECT * FROM users WHERE username=? AND password=?"
user = db.execute(query, (username, password))
```

**2. Password Logged in Plain Text (Line 7)**
```python
log.info(f"User {username} logged in with password {password}")
```
Logging passwords exposes credentials in log files. This violates basic security practices.

**Fix:** Remove password from log statement
```python
log.info(f"User {username} logged in successfully")
```

---

### P1 (time bombs)

**3. No Rate Limiting**

No protection against brute force attacks. An attacker can try unlimited password combinations.

**Impact:** Account takeover via brute force becomes trivial.

**Fix:** Add rate limiting middleware
```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@limiter.limit("5 per minute")
def login(username, password):
    ...
```

**4. Weak Token Generation (Line 11-12)**
```python
def generate_token(username):
    import random
    return str(random.randint(1000, 9999))
```
Using `random` instead of `secrets` makes tokens predictable. 4-digit tokens have only 9,000 possibilities.

**Impact:** Token prediction allows session hijacking.

**Fix:** Use cryptographically secure tokens
```python
import secrets

def generate_token(username):
    return secrets.token_urlsafe(32)
```

**5. Hardcoded Expiration (Line 8)**
```python
return {"token": session_token, "expires": "2030-12-31"}
```
10-year session timeout is a security risk. Stolen tokens remain valid indefinitely.

**Fix:** Use reasonable timeout (e.g., 1 hour)
```python
from datetime import datetime, timedelta
expires = datetime.now() + timedelta(hours=1)
return {"token": session_token, "expires": expires.isoformat()}
```

---

### P2 (technical debt)

**6. Missing Input Validation**

No validation that username/password are non-empty or meet format requirements.

**Fix:** Add validation before database query
```python
if not username or not password:
    return {"error": "Username and password required"}
if len(username) > 255:
    return {"error": "Username too long"}
```

**7. No Password Hashing**

Storing passwords in plain text (implied by `password='{password}'` query).

**Fix:** Hash passwords with bcrypt or argon2
```python
import bcrypt

# On registration
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

# On login
if bcrypt.checkpw(password.encode(), user.password_hash):
    ...
```

---

### P3 (nitpicks)

**8. Import Inside Function**

`import random` should be at module level for performance.

**Fix:** Move to top of file

---

### Summary

**Critical security flaws:** SQL injection and password logging must be fixed immediately. This code would fail any security audit and is exploitable in production.

**Top recommendation:** Replace SQL string formatting with parameterized queries, remove password from logs, and add rate limiting before deploying.

---

## Verification Review (After Fixes)

### Original Finding: SQL Injection Vulnerability

- **Status:** ✅ Fixed
- **Assessment:** Now using parameterized query with `?` placeholders. SQL injection no longer possible.
- **Remaining Work:** None

### Original Finding: Password Logged in Plain Text

- **Status:** ✅ Fixed
- **Assessment:** Password removed from log statement. Only username logged now.
- **Remaining Work:** None

### Original Finding: No Rate Limiting

- **Status:** ⚠️ Partially Fixed
- **Assessment:** Added `@limiter.limit("5 per minute")` decorator, but no tests to verify it works. Rate limiting logic looks correct but needs validation.
- **Remaining Work:** Add integration test to confirm rate limiting blocks 6th attempt

### Original Finding: Weak Token Generation

- **Status:** ✅ Fixed
- **Assessment:** Switched to `secrets.token_urlsafe(32)` for cryptographically secure 32-byte tokens. Good fix.
- **Remaining Work:** None

### Original Finding: Hardcoded Expiration

- **Status:** ✅ Fixed
- **Assessment:** Now uses `timedelta(hours=1)` for reasonable timeout. Expires value properly formatted as ISO string.
- **Remaining Work:** None

---

### Summary

**Critical issues resolved:** SQL injection and password logging are fixed correctly.

**P1 status:** Token generation and expiration fixed. Rate limiting implemented but needs testing before considering fully resolved.

**Recommendation:** Add rate limiting test, then ready to deploy.
