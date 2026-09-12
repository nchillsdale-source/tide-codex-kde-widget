"""Aggregate only token_count metadata; never return conversation text or paths."""
import datetime as dt
import json
import os
import time
from pathlib import Path

FIELDS = ('input_tokens', 'cached_input_tokens', 'output_tokens', 'reasoning_output_tokens', 'total_tokens')
def counters(value):
    if not isinstance(value, dict):
        return None
    if any(type(value.get(k)) is not int or value[k] < 0 for k in FIELDS):
        return None
    return {k: value[k] for k in FIELDS}

def collect(home=None, now=None, max_bytes=256*1024*1024, budget=5):
    now = time.time() if now is None else now
    home = Path(home or os.environ.get('CODEX_HOME', Path.home()/'.codex'))
    midnight = dt.datetime.fromtimestamp(now).replace(hour=0, minute=0, second=0, microsecond=0).timestamp()
    totals = dict.fromkeys(FIELDS, 0)
    bins = [0]*12
    seen = set()
    partial = False
    reports = 0
    recognized = 0
    scanned = 0
    started = time.monotonic()
    roots = [home/'sessions', home/'archived_sessions']
    available = any(p.is_dir() for p in roots)
    paths = []
    for root in roots:
        try:
            paths.extend(p for p in root.rglob('*.jsonl') if p.stat().st_mtime >= min(midnight, now-3600))
        except OSError:
            partial = True
    for path in sorted(paths):
        previous = None
        try:
            with path.open('rb') as stream:
                for line in stream:
                    scanned += len(line)
                    if scanned > max_bytes or time.monotonic()-started > budget:
                        partial = True
                        break
                    if b'"token_count"' not in line:
                        continue
                    try:
                        row = json.loads(line)
                        payload = row.get('payload', {})
                        if row.get('type') != 'event_msg' or payload.get('type') != 'token_count':
                            continue
                        info = payload.get('info') or {}
                        total = counters(info.get('total_token_usage'))
                        last = counters(info.get('last_token_usage'))
                        if total is None:
                            continue
                        stamp = dt.datetime.fromisoformat(row['timestamp'].replace('Z','+00:00')).timestamp()
                    except (ValueError, KeyError, TypeError, AttributeError):
                        partial = True
                        continue
                    recognized += 1
                    # Repeated status reports repeat cumulative counters: do not add twice.
                    if previous == total:
                        continue
                    if previous is not None and all(total[k] >= previous[k] for k in FIELDS):
                        delta = {k: total[k]-previous[k] for k in FIELDS}
                    else:
                        # First record or reset: count only its latest request, not inherited history.
                        delta = last
                        if last is None or (previous is None and last != total):
                            partial = True
                    previous = total
                    identity = (stamp, tuple(total[k] for k in FIELDS))
                    if identity in seen or delta is None or stamp > now:
                        continue
                    seen.add(identity)
                    if stamp >= midnight:
                        reports += 1
                        for k in FIELDS:
                            totals[k] += delta[k]
                    if now-3600 <= stamp <= now:
                        bins[min(11, int((stamp-(now-3600))/300))] += delta['total_tokens']
        except OSError:
            partial = True
        if scanned > max_bytes or time.monotonic()-started > budget:
            break
    return {'available': available and recognized > 0, 'partial': partial, 'updatedAt': now, 'today': totals,
            'reports': reports, 'rate': bins[-1]/5, 'rates': [n/5 for n in bins],
            'scope': 'Local Codex logs · all accounts on this profile'}
