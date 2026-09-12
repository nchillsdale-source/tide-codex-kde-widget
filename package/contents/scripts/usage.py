#!/usr/bin/env python3
"""Read-only Codex app-server client. Never creates a model turn or exports credentials."""
import json
import math
import os
import selectors
import shutil
import subprocess
import time


def normalize(result):
    buckets = result.get('rateLimitsByLimitId')
    if not buckets:
        single = result.get('rateLimits') or {}
        buckets = {single.get('limitId') or 'codex': single}
    windows = []
    for key, bucket in buckets.items():
        if not isinstance(bucket, dict):
            continue
        for slot in ('primary', 'secondary'):
            w = bucket.get(slot)
            if not isinstance(w, dict):
                continue
            used, minutes = w.get('usedPercent'), w.get('windowDurationMins')
            if isinstance(used, bool) or not isinstance(used, (int, float)) or not math.isfinite(used):
                continue
            label = 'Weekly' if minutes == 10080 else '5-hour' if minutes == 300 else (str(minutes) + '-min' if minutes else 'Allowance')
            windows.append({'id': key + '/' + slot, 'name': 'Codex & Work' if key == 'codex' else (bucket.get('limitName') or key), 'window': label, 'remaining': max(0, min(100, 100-used)), 'resetsAt': w.get('resetsAt'), 'main': key == 'codex'})
    windows.sort(key=lambda w: (not w['main'], w['remaining']))
    credit = (buckets.get('codex') or {}).get('credits') or {}
    resets = result.get('rateLimitResetCredits') or {}
    return {'ok': True, 'updatedAt': int(time.time()), 'windows': windows, 'credits': credit.get('balance'), 'resetCredits': resets.get('availableCount')}


def fetch():
    exe = shutil.which('codex')
    if not exe and os.path.isfile('/usr/lib/chatgpt/resources/codex'):
        exe = '/usr/lib/chatgpt/resources/codex'
    if not exe:
        return {'ok': False, 'error': 'Codex CLI not found. Install Codex and sign in.'}
    proc = subprocess.Popen([exe, 'app-server', '--stdio'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, bufsize=0)
    sel = selectors.DefaultSelector()
    sel.register(proc.stdout, selectors.EVENT_READ)
    buffer = b''
    deadline = time.monotonic() + 35
    def send(obj):
        proc.stdin.write((json.dumps(obj)+'\n').encode())
        proc.stdin.flush()
    def receive(req_id):
        nonlocal buffer
        while time.monotonic() < deadline:
            while b'\n' in buffer:
                line, buffer = buffer.split(b'\n', 1)
                try:
                    msg = json.loads(line)
                except (ValueError, UnicodeError):
                    continue
                if msg.get('id') == req_id:
                    return msg
            if sel.select(max(0, deadline-time.monotonic())):
                data = os.read(proc.stdout.fileno(), 65536)
                if not data:
                    raise RuntimeError('Codex connection closed. Check your Codex sign-in.')
                buffer += data
        raise TimeoutError('Update timed out. Check connection and Codex sign-in.')
    try:
        send({'id': 1, 'method': 'initialize', 'params': {'clientInfo': {'name': 'tide_usage', 'title': 'Tide Usage Widget', 'version': '1.0.0'}, 'capabilities': {}}})
        if 'error' in receive(1):
            raise RuntimeError('Codex initialization failed. Update your Codex installation.')
        send({'method': 'initialized', 'params': {}})
        send({'id': 2, 'method': 'account/rateLimits/read', 'params': {}})
        msg = receive(2)
        if 'error' in msg:
            raise RuntimeError('Usage unavailable. Open Codex and check your sign-in or connection.')
        return normalize(msg.get('result') or {})
    finally:
        sel.close()
        proc.terminate()
        try:
            proc.wait(timeout=3)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait()
        proc.stdin.close()
        proc.stdout.close()


if __name__ == '__main__':
    try:
        result = fetch()
    except (OSError, RuntimeError, TimeoutError) as e:
        result = {'ok': False, 'error': str(e) if not isinstance(e, OSError) else 'Unable to start Codex usage reader.'}
    print(json.dumps(result))
