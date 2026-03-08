# Nirai — Logout + Portal Switch (Test Cases)

This checklist covers edge cases for the **Logout** flow and **switching between Client/Vendor portals** (and setting a default portal).

## A. Logout — Client portal
- Logged-in user taps **Settings → Logout**
  - Expected: returns to Client **Auth** flow; back button does not return to logged-in screens.
- Guest user taps **Settings → Logout**
  - Expected: returns to Client **Auth** flow; guest state cleared.
- Logout while on a deep screen (Vendor Profile, Silent Bell, Request Detail)
  - Expected: stack cleared; lands in Client Auth.
- Logout while offline
  - Expected: still logs out locally; no crash.

## B. Logout — Vendor portal
- Logged-in vendor taps **Settings → Logout**
  - Expected: returns to Vendor **Auth** flow; back button does not return to logged-in screens.
- Logout while on a deep screen (Tracking Settings, Vendor Profile, Request Detail)
  - Expected: stack cleared; lands in Vendor Auth.
- Logout while offline
  - Expected: still logs out locally; no crash.

## C. Portal switch — Unified app (apps/nirai)
> Switching is exposed in Settings only when running inside the unified app.

- Client Settings → **Portal → Switch to Vendor**
  - Expected: app resets navigation and shows Vendor portal.
- Vendor Settings → **Portal → Switch to Client**
  - Expected: app resets navigation and shows Client portal.
- Switch portals while in a deep screen
  - Expected: navigation resets; no leftover back stack from the prior portal.

## D. Default portal
- Client Settings → **Portal → Set Vendor as default**
  - Expected: next app launch opens Vendor portal.
- Vendor Settings → **Portal → Set Client as default**
  - Expected: next app launch opens Client portal.
- Change default, then switch role immediately
  - Expected: default changes persist; current role changes immediately.

## E. Persistence + cold start
- Close browser/app completely and reopen
  - Expected: opens the saved default portal.

## F. Regression checks
- Client request lifecycle still works: Silent Bell → Request Detail → History → Repeat
- Vendor request lifecycle still works: Pending → Accept → Arriving → Fulfilled
- Offline banners still show/hide correctly in both portals
