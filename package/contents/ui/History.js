.pragma library
function append(history, snapshot) {
    if (!snapshot || !isFinite(snapshot.updatedAt) || snapshot.updatedAt <= 0 || !snapshot.windows || !snapshot.windows.length) return history;
    var next=history.slice();
    var sample={time:snapshot.updatedAt, windows:JSON.parse(JSON.stringify(snapshot.windows))};
    if (next.length && sample.time < next[next.length-1].time) return history;
    if (next.length && sample.time === next[next.length-1].time) next[next.length-1]=sample;
    else next.push(sample);
    return next.slice(-480);
}
function key(w) { return w.id || w.name+"/"+w.window; }
function series(history, selected) {
    if (!selected) return [];
    var rows=[];
    for(var i=0;i<history.length;i++) {
        var matches=history[i].windows.filter(function(w){return key(w)===key(selected) && w.resetsAt===selected.resetsAt;});
        if(matches.length && typeof matches[0].remaining === "number" && isFinite(matches[0].remaining))
            rows.push({time:history[i].time, remaining:Math.max(0,Math.min(100,matches[0].remaining))});
    }
    return rows;
}
