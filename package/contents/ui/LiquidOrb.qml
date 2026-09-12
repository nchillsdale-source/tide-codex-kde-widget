import QtQuick
import "FishPainter.js" as FishPainter
import "FrameClock.js" as FrameClock
import "StylePainter.js" as StylePainter

Canvas {
    id: orb
    antialiasing: true
    property int displayStyle: 0
    property bool styleAnimate: true
    property real styleSpeed: 1
    property real styleOpacity: 0.85
    property bool styleDetail: true
    property color raceColor: "#ef4b4b"
    property real stylePhase: 0
    property real value: 0
    property color accent: "#6af7df"
    property bool active: true
    property bool hasData: true
    property bool showFish: true
    property int fishCount: 3
    property real fishScale: 1.25
    property real fishSpeed: 0.8
    property int fishStyle: 0
    property bool animateFish: true
    property bool animateWater: true
    property bool showBubbles: true
    property real waveStrength: 1
    property int frameRate: 30
    property int frameMode: 0
    readonly property int frameCap: FrameClock.cap(frameMode, frameRate)
    property var frameBudget: ({budget: 0, elapsed: 0})
    onFrameCapChanged: frameBudget = ({budget: 0, elapsed: 0})
    property bool showRing: true
    property bool showTicks: true
    property bool showGlow: true
    property real glowStrength: 0.6
    property real waterOpacity: 0.35
    property real glassOpacity: 0
    property real fishPhase: 0
    property string paintSettings: JSON.stringify([displayStyle, styleOpacity, styleDetail, raceColor, showFish, fishCount, fishScale, fishStyle, showBubbles, waveStrength, showRing, showTicks, showGlow, glowStrength, waterOpacity, glassOpacity])
    onPaintSettingsChanged: requestPaint()
    property real phase: 0
    property real fill: value
    Behavior on fill { NumberAnimation { duration: 1400; easing.type: Easing.InOutCubic } }
    onFillChanged: requestPaint()
    onAccentChanged: requestPaint()
    onHasDataChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    FrameAnimation {
        id: frameClock
        running: orb.displayStyle !== 2 && orb.active && orb.visible && (orb.displayStyle === 0 ? (orb.animateWater || (orb.showFish && orb.animateFish)) : orb.styleAnimate)
        onRunningChanged: orb.frameBudget = ({budget: 0, elapsed: 0})
        onTriggered: {
            var dt = FrameClock.step(orb.frameBudget, frameTime, orb.frameCap);
            if (dt <= 0) return;
            if (orb.displayStyle !== 0 && orb.styleAnimate) orb.stylePhase += dt*orb.styleSpeed;
            if (orb.displayStyle === 0 && orb.animateWater) orb.phase += dt*0.9;
            if (orb.displayStyle === 0 && orb.animateFish) orb.fishPhase += dt*0.9*orb.fishSpeed;
            orb.requestPaint();
        }
    }
    onPaint: {
        var ctx = getContext("2d"); ctx.reset();
        if (displayStyle !== 0) {
            StylePainter.paint(ctx,width,displayStyle,fill,stylePhase,hasData,styleOpacity,styleDetail,showGlow,showTicks,accent,showRing,raceColor);
            return;
        }
        var c = width/2, r = width*0.405;
        var glow = ctx.createRadialGradient(c,c,r*0.65,c,c,r*1.22);
        glow.addColorStop(0,"transparent"); glow.addColorStop(0.76,"#12484e"); glow.addColorStop(1,"transparent");
        if (showGlow) {ctx.globalAlpha=glowStrength/0.6;ctx.fillStyle=glow; ctx.fillRect(0,0,width,height);ctx.globalAlpha=1;}
        ctx.strokeStyle="#2c4656"; ctx.lineWidth=1;
        if(showRing) {ctx.beginPath(); ctx.arc(c,c,r*1.11,0,Math.PI*2); ctx.stroke();}
        for(var i=0;showTicks && i<60;i++) {
            var a=i*Math.PI/30, rr=r*1.11;
            ctx.strokeStyle=i%5===0?"#668698":"#2d4654";
            ctx.beginPath(); ctx.moveTo(c+Math.cos(a)*rr,c+Math.sin(a)*rr);
            ctx.lineTo(c+Math.cos(a)*(rr+(i%5===0?5:2)),c+Math.sin(a)*(rr+(i%5===0?5:2))); ctx.stroke();
        }
        if(showRing) {ctx.strokeStyle=accent; ctx.lineWidth=2; ctx.beginPath(); ctx.arc(c,c,r*1.11,-Math.PI/2,-Math.PI/2+Math.PI*2*fill); ctx.stroke();}
        ctx.save(); ctx.beginPath(); ctx.arc(c,c,r,0,Math.PI*2); ctx.clip();
        var bg=ctx.createLinearGradient(0,c-r,0,c+r); bg.addColorStop(0,"#0b1927"); bg.addColorStop(1,"#183c50");
        ctx.globalAlpha=glassOpacity;ctx.fillStyle=bg; ctx.fillRect(c-r,c-r,2*r,2*r);ctx.globalAlpha=1;
        if(hasData) {
            var surface=c+r-2*r*fill;
            for(var layer=0;layer<3;layer++) {
                var amp=(3+layer*1.8)*waveStrength;
                ctx.beginPath();
                for(var x=c-r;x<=c+r+2;x+=2) {
                    var y=surface+Math.sin((x-c)/r*3.8+phase*(layer%2===0?1:-0.7)+layer*1.7)*amp+Math.sin(x/r*7-phase)*2*waveStrength;
                    if(x===c-r) ctx.moveTo(x,y); else ctx.lineTo(x,y);
                }
                ctx.lineTo(c+r,c+r);ctx.lineTo(c-r,c+r);ctx.closePath();
                var water=ctx.createLinearGradient(0,surface,0,c+r);
                water.addColorStop(0,layer===2?accent:layer===1?"#397eaa":"#315c99");
                water.addColorStop(0.22,layer===2?"#258b9e":"#174a71"); water.addColorStop(1,"#102b57");
                ctx.globalAlpha=(layer===2?0.85:0.55)*waterOpacity; ctx.fillStyle=water; ctx.fill();
            }
            // Conservative wave clearance and spherical boundary keep fins submerged.
            var safeTop = Math.max(c-r+16, surface+11*waveStrength+16);
            var safeBottom = c+r-16;
            var depth = safeBottom-safeTop;
            if (showFish && depth > 5) {
                var count = Math.max(1,Math.min(10,fishCount));
                for (var f=0; f<count; f++) {
                    var t = fishPhase*(0.35+(f%4)*0.06)+f*2.3;
                    var fy = safeTop + depth*(0.15+0.7*(f+0.5)/count) + Math.sin(t*1.7)*Math.min(4,depth*0.06);
                    var halfWidth = Math.sqrt(Math.max(0,r*r-(fy-c)*(fy-c)));
                    var size = Math.min(width/280*fishScale*0.8,depth/38,(halfWidth-8)/34);
                    if (size < 0.15) continue;
                    var travel = Math.max(0,halfWidth-30*size-6);
                    var fx = c+Math.sin(t)*travel;
                    var heading = Math.cos(t);
                    // A narrow silhouette at each turn suggests a fish turning in depth.
                    var yaw = (heading>=0?1:-1)*Math.max(0.07,Math.min(1,Math.abs(heading)*3));
                    ctx.save();ctx.translate(fx,fy);ctx.scale(size*yaw,size);
                    ctx.rotate(Math.sin(t*1.7)*0.06);
                    FishPainter.paint(ctx,f,fishPhase,fishStyle);
                    ctx.restore();
                }
            }
            ctx.globalAlpha=0.25;
            for(var b=0;showBubbles && b<9;b++) {
                var bx=c+Math.sin(b*13.1)*r*0.8, by=c+r-((phase*12+b*27)%(2*r));
                if(by>surface+11*waveStrength+4) {ctx.beginPath();ctx.arc(bx,by,1+b%3,0,Math.PI*2);ctx.strokeStyle="#b9fff4";ctx.lineWidth=0.7;ctx.stroke();}
            }
        }
        ctx.globalAlpha=1;
        var sheen=ctx.createLinearGradient(c-r,0,c+r,0); sheen.addColorStop(0,"#4068a1ae"); sheen.addColorStop(0.23,"transparent"); sheen.addColorStop(0.8,"transparent"); sheen.addColorStop(1,"#25447790");
        ctx.globalAlpha=glassOpacity;ctx.fillStyle=sheen;ctx.fillRect(c-r,c-r,2*r,2*r);ctx.restore();
        ctx.strokeStyle="#7298a9";ctx.lineWidth=1;ctx.beginPath();ctx.arc(c,c,r,0,Math.PI*2);ctx.stroke();
        ctx.strokeStyle="#70c6d1da";ctx.lineWidth=2;ctx.beginPath();ctx.arc(c,c,r-4,Math.PI*1.12,Math.PI*1.42);ctx.stroke();
    }
}
