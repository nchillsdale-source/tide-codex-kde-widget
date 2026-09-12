pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: view
    property var selected: null
    property var localTokens: null
    property bool showLocalTokens: false
    property double now: Date.now()/1000
    property var windows: []
    property var series: []
    property font textFont: Kirigami.Theme.defaultFont
    property real textScale: 1
    property bool showLabels: true
    property bool showValue: true
    property bool showBars: true
    property int refreshSeconds: 180
    property color accent: "#78c3ee"
    readonly property bool hasTrend: series.length >= 8
    function stamp(t) { return new Date(t*1000).toLocaleTimeString(Qt.locale(),"hh:mm"); }
    ColumnLayout {
        anchors.fill: parent; spacing: 10
        RowLayout {
            visible: view.showLabels || view.showValue
            Layout.fillWidth: true
            ColumnLayout {
                visible: view.showLabels; Layout.fillWidth: true; spacing: 4
                TideText { baseFont: view.textFont; Layout.fillWidth: true; text: "USAGE OVERVIEW"; color: "#cbd9e6"; sizeScale: .8*view.textScale; font.letterSpacing: 1 }
                TideText { baseFont: view.textFont; Layout.fillWidth: true; text: view.selected ? view.selected.window + " · remaining" : "Awaiting usage data"; color: "#91a5b8"; sizeScale: .75*view.textScale; wrapMode: Text.WordWrap }
            }
            TideText { baseFont: view.textFont; visible: view.showValue; text: view.selected ? Math.round(view.selected.remaining)+"%" : "—"; color: "#edf5fc"; sizeScale: 2.35*view.textScale }
        }
        TideText {
            visible: view.showLabels; baseFont: view.textFont; Layout.fillWidth: true
            text: view.hasTrend ? "Remaining over time · this session" : "Collecting history · " + view.series.length + "/8 readings"
            color: "#a9becf"; sizeScale: .75*view.textScale
        }
        Item {
            Layout.fillWidth: true; Layout.fillHeight: true; Layout.minimumHeight: 80
            Canvas {
                id: plot
                anchors.fill: parent
                anchors.leftMargin: view.showLabels ? 33*view.textScale : 4
                anchors.bottomMargin: view.showLabels ? 18*view.textScale : 4
                antialiasing: true
                property string points: JSON.stringify(view.series)
                onPointsChanged: requestPaint()
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
                onPaint: {
                    var ctx=getContext("2d");ctx.reset();
                    var w=width-4,h=height-4;
                    ctx.lineWidth=1;ctx.strokeStyle="#334354";
                    for(var k=0;k<3;k++){var y=2+k*h/2;ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(w,y);ctx.stroke();}
                    if(!view.series.length)return;
                    var start=view.series[0].time,end=view.series[view.series.length-1].time;
                    var span=Math.max(1,end-start);
                    var last=null;
                    ctx.lineWidth=2;ctx.strokeStyle=view.accent;
                    for(var i=0;i<view.series.length;i++) {
                        var p=view.series[i],x=view.series.length===1?w/2:(p.time-start)/span*w,yy=2+(100-p.remaining)/100*h;
                        if(view.hasTrend && last && p.time-last.time<=Math.max(60,view.refreshSeconds*2.2)) {ctx.beginPath();ctx.moveTo(last.x,last.y);ctx.lineTo(x,yy);ctx.stroke();}
                        if(view.series.length<30 || i===view.series.length-1){ctx.fillStyle=view.accent;ctx.beginPath();ctx.arc(x,yy,2.5,0,Math.PI*2);ctx.fill();}
                        last={x:x,y:yy,time:p.time};
                    }
                }
                Connections { target: view; function onAccentChanged(){plot.requestPaint();} function onRefreshSecondsChanged(){plot.requestPaint();} }
            }
            Repeater {
                model: view.showLabels ? [100,50,0] : []
                TideText {
                    required property int modelData
                    baseFont: view.textFont; text: modelData+"%"; color: "#8298ac"; sizeScale: .65*view.textScale
                    y: 2+(100-modelData)/100*(plot.height-4)-height/2
                }
            }
            RowLayout {
                visible: view.showLabels; anchors.left: plot.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                TideText { baseFont: view.textFont; text: view.series.length ? view.stamp(view.series[0].time) : "First successful update"; color: "#8298ac"; sizeScale: .65*view.textScale }
                Item { Layout.fillWidth: true }
                TideText { visible: view.series.length>1; baseFont: view.textFont; text: view.series.length ? view.stamp(view.series[view.series.length-1].time) : ""; color: "#8298ac"; sizeScale: .65*view.textScale }
            }
        }
        TideText { visible: view.showLabels && view.showBars; baseFont: view.textFont; text: "ALLOWANCE WINDOWS · % REMAINING"; color: "#a9becf"; sizeScale: .68*view.textScale; Layout.fillWidth: true; wrapMode: Text.WordWrap }
        Flickable {
            visible: view.showBars && view.windows.length>0
            Layout.fillWidth: true; Layout.preferredHeight: Math.min(135*view.textScale,rows.height)
            clip: true; contentHeight: rows.height
            Column {
                id: rows; width: parent.width; spacing: 10
                Repeater {
                    model: view.windows
                    Column {
                        id: bar
                        required property var modelData
                        width: rows.width; spacing: 4
                        RowLayout {
                            visible: view.showLabels; width: parent.width
                            TideText { baseFont: view.textFont; Layout.fillWidth: true; text: bar.modelData.name+" · "+bar.modelData.window; elide: Text.ElideRight; color: "#aabfd0"; sizeScale: .7*view.textScale }
                            TideText { baseFont: view.textFont; text: Math.round(bar.modelData.remaining)+"%"; color: "#e3edf7"; sizeScale: .7*view.textScale }
                        }
                        Rectangle {
                            width: parent.width; height: 6; color: "#2b3a49"
                            Rectangle { width: parent.width*Math.max(0,Math.min(100,bar.modelData.remaining))/100; height: 6; color: view.accent }
                        }
                    }
                }
            }
        }
        TokenUsageView {
            visible: view.showLocalTokens
            Layout.fillWidth: true
            staleAfter: Math.max(420, view.refreshSeconds*2+60)
            usage: view.localTokens; textFont: view.textFont; textScale: view.textScale; now: view.now
        }
    }
}
