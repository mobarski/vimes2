#!/usr/bin/env python3
# headless browser smoke test of web/index.html?selftest
# (google-chrome / chromium --headless --dump-dom; skipped if no browser is installed)
import os, re, shutil, subprocess, sys
ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

browser = next((shutil.which(b) for b in ['google-chrome', 'chromium', 'chromium-browser', 'google-chrome-stable'] if shutil.which(b)), None)
if not browser:
    print('web smoke: no headless chrome/chromium found - skipped'); sys.exit(0)
url = 'file://' + os.path.join(ROOT, 'web', 'index.html') + '?selftest'
cmd = [browser, '--headless=new', '--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage',
       '--allow-file-access-from-files', '--virtual-time-budget=30000', '--dump-dom', url]
try:
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
except subprocess.TimeoutExpired:
    print('web smoke: FAIL (browser timeout)'); sys.exit(1)
m = re.search(r'<pre id="selftest"[^>]*>(.*?)</pre>', p.stdout, re.S)
if not m:
    print('web smoke: FAIL (no #selftest in page DOM)'); print(p.stderr[-500:]); sys.exit(1)
text = m.group(1).replace('&gt;', '>').replace('&lt;', '<').replace('&amp;', '&').strip()
print('web smoke:', text)
sys.exit(0 if text.startswith('SELFTEST PASS') else 1)
