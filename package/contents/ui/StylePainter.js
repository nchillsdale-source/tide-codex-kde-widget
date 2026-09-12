.pragma library

function rounded(ctx,x,y,w,h,r) {
    ctx.beginPath();ctx.moveTo(x+r,y);ctx.lineTo(x+w-r,y);ctx.quadraticCurveTo(x+w,y,x+w,y+r);
    ctx.lineTo(x+w,y+h-r);ctx.quadraticCurveTo(x+w,y+h,x+w-r,y+h);
    ctx.lineTo(x+r,y+h);ctx.quadraticCurveTo(x,y+h,x,y+h-r);
    ctx.lineTo(x,y+r);ctx.quadraticCurveTo(x,y,x+r,y);ctx.closePath();
}
function line(ctx,x1,y1,x2,y2,color,width) {
    ctx.strokeStyle=color;ctx.lineWidth=width;ctx.beginPath();ctx.moveTo(x1,y1);ctx.lineTo(x2,y2);ctx.stroke();
}
function lava(ctx,fill,t,known,opacity,details,glow,ticks) {
    if(glow){var halo=ctx.createRadialGradient(160,180,50,160,180,155);halo.addColorStop(0,"#65301d");halo.addColorStop(1,"transparent");ctx.globalAlpha=.45;ctx.fillStyle=halo;ctx.fillRect(0,0,320,320);}
    ctx.globalAlpha=opacity;
    var steel=ctx.createLinearGradient(74,0,246,0);steel.addColorStop(0,"#34404b");steel.addColorStop(.15,"#10161e");steel.addColorStop(.85,"#151b22");steel.addColorStop(1,"#3f4650");
    rounded(ctx,74,22,172,278,36);ctx.fillStyle=steel;ctx.fill();ctx.strokeStyle="#69747c";ctx.lineWidth=1;ctx.stroke();
    ctx.save();rounded(ctx,87,36,146,250,26);ctx.clip();
    ctx.fillStyle="#150f14";ctx.fillRect(87,36,146,250);
    var surface=286-250*fill;
    if(known && fill>0){
        ctx.beginPath();
        for(var x=87;x<=233;x+=2){var y=surface+Math.sin(x*.06+t*1.5)*3+Math.sin(x*.13-t)*1.5;if(x===87)ctx.moveTo(x,y);else ctx.lineTo(x,y);}
        ctx.lineTo(233,290);ctx.lineTo(87,290);ctx.closePath();
        var molten=ctx.createLinearGradient(0,surface,0,290);molten.addColorStop(0,"#fff1a1");molten.addColorStop(.07,"#ffbd4d");molten.addColorStop(.4,"#ed552c");molten.addColorStop(1,"#651b23");ctx.fillStyle=molten;ctx.fill();
        if(details) {
            // Convection pockets rise and fade instead of popping at loop boundaries.
            var depth=Math.max(0,286-surface);
            for(var pocket=0;pocket<7;pocket++) {
                var life=(t*.09+pocket*.143)%1;
                var py=286-life*depth;
                var px=113+Math.sin(t*.7+pocket*2.4)*36+pocket%2*24;
                var radius=Math.min(24,depth*.15,py-surface-4,282-py);
                if(radius>2){
                    var heat=ctx.createRadialGradient(px,py,1,px,py,radius);
                    heat.addColorStop(0,"#ffdf74");heat.addColorStop(.4,"#ff963d");heat.addColorStop(1,"transparent");
                    ctx.globalAlpha=opacity*Math.sin(life*Math.PI)*.65;ctx.fillStyle=heat;
                    ctx.fillRect(px-radius,py-radius,radius*2,radius*2);
                }
            }
            // Molten seams bend gradually around irregular dark crust plates.
            for(var i=0;i<11;i++) {
                var life=(i/11+t*.025)%1;
                var ry=surface+16+life*Math.max(0,depth-32);
                var rx=108+(i*47)%99+Math.sin(t*.45+i)*4;
                var warp=Math.sin(t*.8+i)*2;
                ctx.globalAlpha=opacity*Math.sin(life*Math.PI);
                ctx.fillStyle="#60241f";ctx.beginPath();ctx.moveTo(rx-10,ry);
                ctx.bezierCurveTo(rx-6,ry-7,rx+2,ry-5+warp,rx+9,ry-2);
                ctx.quadraticCurveTo(rx+5,ry+6,rx-4,ry+5);ctx.closePath();ctx.fill();
                ctx.strokeStyle="#ffbd57";ctx.lineWidth=.8;ctx.beginPath();ctx.moveTo(rx-9,ry+2);
                ctx.bezierCurveTo(rx-3,ry+8,rx+4,ry+7,rx+8,ry+3);ctx.stroke();
            }
            ctx.globalAlpha=opacity;
            for(var e=0;e<10;e++) {var ey=286-((t*22+e*27)%250);if(ey>surface+7){ctx.fillStyle="#ffdf86";ctx.beginPath();ctx.arc(99+(e*39)%121,ey,1+e%2,0,Math.PI*2);ctx.fill();}}
        }
    }
    ctx.restore();ctx.globalAlpha=1;
    rounded(ctx,87,36,146,250,26);ctx.strokeStyle="#d99258";ctx.lineWidth=1;ctx.stroke();
    for(var bolt=0;bolt<4;bolt++){var bx=bolt%2?237:83,by=bolt<2?52:270;ctx.fillStyle="#87939b";ctx.beginPath();ctx.arc(bx,by,2,0,Math.PI*2);ctx.fill();}
}
function trackPoint(a) {return {x:160+116*Math.cos(a)+8*Math.sin(2*a),y:160+105*Math.sin(a)+8*Math.sin(3*a)};}
function trackHeading(a) {
    return Math.atan2(105*Math.cos(a)+24*Math.cos(3*a),-116*Math.sin(a)+16*Math.cos(2*a));
}
function oval(ctx) {
    ctx.beginPath();
    for(var i=0;i<=120;i++){var p=trackPoint(i*Math.PI/60);if(i===0)ctx.moveTo(p.x,p.y);else ctx.lineTo(p.x,p.y);}ctx.closePath();
}
function raceCar(ctx,color,t) {
    // Original top-down open-wheel silhouette: wings, exposed tires, halo and helmet.
    ctx.fillStyle="#080c12";
    for(var x=-1;x<=1;x+=2)for(var y=-1;y<=1;y+=2){rounded(ctx,x*8-3,y*10-5,6,10,1.7);ctx.fill();}
    ctx.fillStyle="#293340";ctx.fillRect(-8,-11,16,2);ctx.fillRect(-8,9,16,2);
    var bodyPaint=ctx.createLinearGradient(-7,0,7,0);bodyPaint.addColorStop(0,color);bodyPaint.addColorStop(.45,"#ffd8ba");bodyPaint.addColorStop(.6,color);bodyPaint.addColorStop(1,"#6c2734");
    ctx.fillStyle=bodyPaint;ctx.beginPath();ctx.moveTo(0,-21);ctx.lineTo(3,-13);ctx.lineTo(5,-4);ctx.lineTo(7,9);ctx.lineTo(4,15);ctx.lineTo(-4,15);ctx.lineTo(-7,9);ctx.lineTo(-5,-4);ctx.lineTo(-3,-13);ctx.closePath();ctx.fill();
    rounded(ctx,-11,-18,22,3,1);ctx.fill();rounded(ctx,-10,15,20,4,1);ctx.fill();
    ctx.fillStyle="#22303c";ctx.fillRect(-5,2,2,6);ctx.fillRect(3,2,2,6);
    line(ctx,-10,-17,10,-17,"#f4d9d0",.5);line(ctx,-9,17,9,17,"#efd6ce",.5);
    line(ctx,0,-18,0,-7,"#fff3d9",1.2);line(ctx,-4,8,-5,13,"#f3ecdf",1);line(ctx,4,8,5,13,"#f3ecdf",1);
    ctx.fillStyle="#111b25";ctx.beginPath();ctx.arc(0,1,4,0,Math.PI*2);ctx.fill();
    ctx.strokeStyle="#c6d1d9";ctx.lineWidth=1.2;ctx.beginPath();ctx.arc(0,0,4,Math.PI,Math.PI*2);ctx.stroke();line(ctx,0,-4,0,-7,"#c6d1d9",1);
    ctx.fillStyle="#ffe09d";ctx.beginPath();ctx.arc(0,1,2,0,Math.PI*2);ctx.fill();
    ctx.fillStyle="#222936";ctx.fillRect(-1.6,0,3.2,1);
}
function motorsport(ctx,fill,t,known,opacity,details,glow,ticks,color,accent) {
    ctx.globalAlpha=opacity;
    oval(ctx);ctx.strokeStyle="#53626c";ctx.lineWidth=29;ctx.stroke();
    // Alternating kerb blocks outside the asphalt.
    if(details)for(var k=0;k<100;k++){var a=k*Math.PI/50,p=trackPoint(a);ctx.save();ctx.translate(p.x,p.y);ctx.rotate(trackHeading(a));ctx.fillStyle=k%2?"#deded9":"#c94344";ctx.fillRect(-3,-13,6,5);ctx.restore();}
    oval(ctx);ctx.strokeStyle="#202a34";ctx.lineWidth=18;ctx.stroke();
    if(details)for(var j=0;j<54;j++){var p1=trackPoint(j*Math.PI/27),p2=trackPoint(j*Math.PI/27+.024);line(ctx,p1.x,p1.y,p2.x,p2.y,"#768590",.8);}
    ctx.globalAlpha=1;
    // Quota is shown by the inner segmented fuel gauge, independent of car motion.
    for(var i=0;i<28;i++){var a0=Math.PI*.18+i*Math.PI*.64/28;ctx.strokeStyle=known&&i/28<fill?accent:"#34434e";ctx.lineWidth=5;ctx.beginPath();ctx.arc(160,156,76,a0,a0+.045);ctx.stroke();}
    if(ticks){line(ctx,97,107,114,107,"#718994",1);line(ctx,206,107,223,107,"#718994",1);}
    // Checkered start/finish strip, drawn at the top of the circuit.
    for(var row=0;row<4;row++)for(var col=0;col<3;col++){ctx.fillStyle=(row+col)%2?"#11161c":"#e7ece9";ctx.fillRect(155+col*3,trackPoint(-Math.PI/2).y-10+row*5,3,5);}
    if(known){
        var a=t*.5-Math.PI/2,p=trackPoint(a);
        var tangent=trackHeading(a);
        if(glow){ctx.shadowColor=color;ctx.shadowBlur=7;}
        ctx.save();ctx.translate(p.x,p.y);ctx.rotate(tangent+Math.PI/2);ctx.scale(.9,.9);raceCar(ctx,color,t);ctx.restore();ctx.shadowBlur=0;
    }
}
function paint(ctx,width,style,fill,t,known,opacity,details,glow,ticks,accent,ring,carColor) {
    ctx.save();ctx.scale(width/320,width/320);
    if(style===1)lava(ctx,fill,t,known,opacity,details,glow,ticks);
    else if(style===3)motorsport(ctx,fill,t,known,opacity,details,glow,ticks,carColor,accent);
    ctx.restore();
}
