.pragma library

function cap(mode, customRate) {
    if (mode === 1) return 60;
    if (mode === 2) return 0; // Every frame delivered by Qt's animation clock.
    if (mode === 3) return Math.max(10, Math.min(240, customRate));
    return 30;
}

// Keep fractional budget so refresh rates such as 144 Hz and 59.94 Hz
// do not introduce drift. Advance motion by real elapsed time, not frame count.
function step(state, seconds, limit) {
    if (!isFinite(seconds) || seconds <= 0) return 0;
    var dt = Math.min(seconds, 0.1); // Avoid a large jump after a stalled frame.
    state.budget += dt;
    state.elapsed += dt;
    var interval = limit > 0 ? 1 / limit : 0;
    if (interval && state.budget + 0.000001 < interval) return 0;
    state.budget = interval ? Math.max(0, state.budget - interval) % interval : 0;
    var advance = state.elapsed;
    state.elapsed = 0;
    return advance;
}
