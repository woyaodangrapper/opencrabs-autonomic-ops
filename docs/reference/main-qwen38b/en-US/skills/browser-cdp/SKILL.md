---
name: browser-cdp
description: "OCAO browser CDP skill: dynamic web state inspection, UI checks, screenshots, and controlled interaction."
---

# Browser CDP

Keywords: OCAO, browser, CDP, Chrome, scraping, screenshot, DOM, automation, Chinese output.

User-facing output must always be Chinese.

## Route

Use for dynamic pages, UI verification, login flows with approval, DOM inspection, and screenshots. Static facts should use lighter tools first.

## Tools

- `browser_navigate`: `url`, optional `headless`.
- `browser_wait`: `selector`, `timeout_secs`, or `delay_secs`.
- `browser_click`: `selector`.
- `browser_type`: `selector`, `text`.
- `browser_content`: optional `selector`, `text_only`.
- `browser_eval`: `script`.
- `browser_screenshot`: optional `selector`; returns file path.
- `browser_find`: `pattern`, optional `mode`, `limit`.

## Workflow

Navigate -> wait -> inspect -> act -> verify. For UI work, take screenshots. For SPAs, use `browser_eval` only when selector tools are insufficient.

## Safety

Do not enter credentials or perform purchases/posts/destructive external actions without explicit user intent. Screenshots may contain private data; share only as needed.

## Recovery

If Chrome fails, close stale Chrome processes or profile locks, then retry. If state may matter, report before clearing profile data.
