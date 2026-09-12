pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
ColumnLayout {
    id: view
    property var usage: null
    property font textFont: Kirigami.Theme.defaultFont
    property real textScale: 1
    property int staleAfter: 420
    property double now: Date.now()/1000
    readonly property bool available: !!usage && !!usage.available
    readonly property bool stale: available && now-usage.updatedAt>staleAfter
    readonly property var rates: available ? usage.rates || [] : []
    readonly property real peak: Math.max(1,...rates)
    function n(v) { return Number(v || 0).toLocaleString(Qt.locale().name === 'C' ? Qt.locale('en_US') : Qt.locale(), 'f', 0); }
    spacing: 6
    Rectangle { Layout.fillWidth:true; implicitHeight:1; color:'#334354' }
    TideText { baseFont:view.textFont; Layout.fillWidth:true; text:'LOCAL CODEX USAGE' + (view.usage && view.usage.partial ? ' · PARTIAL' : '') + (view.stale ? ' · STALE' : ''); sizeScale:.75*view.textScale; color:'#cbd9e6'; wrapMode:Text.WordWrap }
    TideText { baseFont:view.textFont; Layout.fillWidth:true; visible:!view.available; text:'No local token records available'; sizeScale:.75*view.textScale; color:'#91a5b8'; wrapMode:Text.WordWrap }
    TideText { baseFont:view.textFont; Layout.fillWidth:true; visible:view.available; text:view.available ? view.n(view.usage.today.total_tokens)+' tokens today' : ''; sizeScale:1.15*view.textScale; color:'#edf5fc'; wrapMode:Text.WordWrap }
    TideText {
        baseFont:view.textFont; Layout.fillWidth:true; visible:view.available
        text:view.available ? 'Input '+view.n(view.usage.today.input_tokens)+' · cached '+view.n(view.usage.today.cached_input_tokens)+'\nOutput '+view.n(view.usage.today.output_tokens)+' · reasoning '+view.n(view.usage.today.reasoning_output_tokens) : ''
        sizeScale:.7*view.textScale;color:'#a9becf';wrapMode:Text.WordWrap
    }
    TideText { baseFont:view.textFont; Layout.fillWidth:true; visible:view.available; text:view.available ? view.n(view.usage.rate)+' tokens/min · last 5 min average' : ''; sizeScale:.72*view.textScale; color:'#cbd9e6'; wrapMode:Text.WordWrap }
    RowLayout {
        visible:view.available;Layout.fillWidth:true;Layout.preferredHeight:62*view.textScale;Layout.maximumHeight:62*view.textScale;spacing:6
        ColumnLayout {
            Layout.fillHeight:true
            TideText { baseFont:view.textFont;text:view.n(view.peak);sizeScale:.6*view.textScale;color:'#8298ac' }
            Item { Layout.fillHeight:true }
            TideText { baseFont:view.textFont;text:'0';sizeScale:.6*view.textScale;color:'#8298ac' }
        }
        Row {
            Layout.fillWidth:true;Layout.fillHeight:true;spacing:3
            Repeater {
                model:view.rates
                Item {
                    id: bar
                    required property real modelData
                    width:Math.max(0,(parent.width-33)/12);height:parent.height
                    Rectangle { anchors.bottom:parent.bottom;width:parent.width;height:parent.height*Math.max(0,bar.modelData)/view.peak;color:'#78c3ee' }
                    Rectangle { anchors.bottom:parent.bottom;width:parent.width;height:1;color:'#3a4c5c' }
                }
            }
        }
    }
    TideText { baseFont:view.textFont;Layout.fillWidth:true;visible:view.available;text:'−60 min → latest scan · 5 min bins · tokens/min';sizeScale:.6*view.textScale;color:'#8298ac';wrapMode:Text.WordWrap }
    TideText { baseFont:view.textFont;Layout.fillWidth:true;text:'Local profile, all accounts. Cached is included in input; reasoning in output. Not account-wide or billing usage.';sizeScale:.6*view.textScale;color:'#8298ac';wrapMode:Text.WordWrap }
}
