.pragma library

function body(ctx) {
    ctx.beginPath(); ctx.moveTo(16,0);
    ctx.bezierCurveTo(13,-5,5,-9,-3,-7);
    ctx.bezierCurveTo(-9,-6,-12,-2,-15,0);
    ctx.bezierCurveTo(-10,3,-6,7,1,7);
    ctx.bezierCurveTo(8,7,13,4,16,0); ctx.closePath();
}
function paint(ctx, index, phase, style) {
    var koi = [["#60796b","#f5eed7","#a89b73"], ["#9c561c","#ffd083","#ad762b"], ["#913c30","#ffb58d","#d06e49"]];
    var tropical = [["#11406d","#67dbef","#21829c"], ["#34396f","#b4c5ff","#557bd1"], ["#34633e","#acedd1","#348f82"]];
    var silver = [["#425664","#e0e7e9","#839eab"]];
    var group = style === 1 ? tropical : style === 2 ? silver : koi;
    var color = group[index % group.length];
    var wag = Math.sin(phase*6+index*1.4);
    // Forked caudal fin with flexible rays.
    ctx.globalAlpha=0.8;
    var tailColor=ctx.createLinearGradient(-28,0,-12,0);
    tailColor.addColorStop(0,color[1]);tailColor.addColorStop(1,color[2]);ctx.fillStyle=tailColor;
    ctx.beginPath();ctx.moveTo(-13,0);ctx.bezierCurveTo(-18,-2,-23,-9+wag,-27,-8+wag*2);
    ctx.quadraticCurveTo(-25,-2,-22,wag);ctx.quadraticCurveTo(-26,4,-27,9+wag*2);
    ctx.bezierCurveTo(-22,8+wag,-17,2,-13,0);ctx.closePath();ctx.fill();
    ctx.strokeStyle=color[0];ctx.lineWidth=0.45;ctx.globalAlpha=0.45;
    for (var ray=-2;ray<=2;ray++) {ctx.beginPath();ctx.moveTo(-14,0);ctx.quadraticCurveTo(-19,ray,-25,ray*3+wag*1.5);ctx.stroke();}
    // Dorsal and pelvic fins sit behind the body.
    ctx.fillStyle=color[1];ctx.globalAlpha=0.6;
    ctx.beginPath();ctx.moveTo(-8,-5);ctx.quadraticCurveTo(-3,-13+wag,3,-12);ctx.lineTo(7,-5);ctx.closePath();ctx.fill();
    ctx.beginPath();ctx.moveTo(-5,4);ctx.lineTo(-3,11);ctx.lineTo(3,5);ctx.closePath();ctx.fill();
    ctx.strokeStyle=color[0];ctx.lineWidth=0.5;
    for (var fin=0;fin<4;fin++) {ctx.beginPath();ctx.moveTo(-6+fin*3,-5);ctx.lineTo(-3+fin*2,-11+fin);ctx.stroke();}
    // Countershading and a bright belly make the body read as rounded.
    ctx.globalAlpha=1;
    var shade=ctx.createLinearGradient(0,-8,0,8);
    shade.addColorStop(0,color[0]);shade.addColorStop(0.38,color[1]);shade.addColorStop(0.78,color[2]);shade.addColorStop(1,color[1]);
    body(ctx);ctx.fillStyle=shade;ctx.fill();
    // Keep markings within the body contours without an extra clip stack.
    if (style === 0) {
        ctx.globalAlpha=index%3===0?0.85:0.55;
        ctx.fillStyle=index%3===0?"#e57243":"#634435";
        ctx.beginPath();ctx.moveTo(-7,-3);ctx.bezierCurveTo(-3,-6,1,-1,-3,1);ctx.bezierCurveTo(-7,3,-9,-1,-7,-3);ctx.fill();
        ctx.fillStyle=index%3===0?"#35413d":"#fff1c8";
        ctx.beginPath();ctx.moveTo(3,-5);ctx.bezierCurveTo(9,-4,6,3,2,2);ctx.quadraticCurveTo(-1,-1,3,-5);ctx.fill();
    } else if (style === 1) {
        ctx.strokeStyle=color[0];ctx.lineWidth=2.3;ctx.globalAlpha=0.55;
        for(var stripe=0;stripe<3;stripe++){ctx.beginPath();ctx.moveTo(-6+stripe*5,-4);ctx.quadraticCurveTo(-3+stripe*5,-1,-5+stripe*5,4);ctx.stroke();}
    }
    // Fine staggered scale arcs, clipped to the fish silhouette.
    ctx.globalAlpha=0.2;ctx.strokeStyle="#f5ffff";ctx.lineWidth=0.4;
    for(var row=0;row<4;row++) for(var col=0;col<6;col++) {
        if (col < 2 && (row === 0 || row === 3)) continue;
        ctx.beginPath();ctx.arc(-10+col*3.4+(row%2)*1.7,-4+row*2.6,1.6,-0.9,0.9);ctx.stroke();
    }
    ctx.globalAlpha=0.4;ctx.strokeStyle=color[1];ctx.lineWidth=0.65;
    ctx.beginPath();ctx.moveTo(-11,-1);ctx.quadraticCurveTo(-1,-3,9,-1);ctx.stroke();
    // Operculum, beating pectoral fin, mouth and eye catchlight.
    ctx.globalAlpha=0.7;ctx.strokeStyle=color[0];ctx.lineWidth=0.8;
    ctx.beginPath();ctx.moveTo(8,-4);ctx.quadraticCurveTo(4,0,8,4);ctx.stroke();
    ctx.globalAlpha=0.5;ctx.fillStyle=color[1];ctx.beginPath();ctx.moveTo(4,1);
    ctx.quadraticCurveTo(-3,5+wag*2,0,10+wag*2);ctx.quadraticCurveTo(6,6,4,1);ctx.fill();
    ctx.globalAlpha=1;ctx.fillStyle=color[1];ctx.beginPath();ctx.arc(11,-1.5,2,0,Math.PI*2);ctx.fill();
    ctx.fillStyle="#10242d";ctx.beginPath();ctx.arc(11.4,-1.4,1.25,0,Math.PI*2);ctx.fill();
    ctx.fillStyle="#ffffff";ctx.beginPath();ctx.arc(11.6,-1.9,0.45,0,Math.PI*2);ctx.fill();
    ctx.strokeStyle=color[0];ctx.lineWidth=0.6;ctx.beginPath();ctx.moveTo(14,1);ctx.lineTo(16,0.4);ctx.stroke();
}
