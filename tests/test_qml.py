"""Offscreen integration checks. Requires PySide6 and KDE QML modules."""
import os, re, json, unittest, xml.etree.ElementTree as ET
from pathlib import Path
os.environ['QT_QPA_PLATFORM']='offscreen'
os.environ['QT_QUICK_BACKEND']='software'
from PySide6.QtCore import QUrl,QMetaObject,QObject
from PySide6.QtGui import QGuiApplication, QColor,QFont
from PySide6.QtQuick import QQuickView,QQuickItem
from PySide6.QtTest import QTest
ROOT=Path(__file__).resolve().parents[1]
UI=ROOT/'package/contents/ui'
app=QGuiApplication.instance() or QGuiApplication([])
def plain(v): return v.toVariant() if hasattr(v,'toVariant') else v
class WidgetTests(unittest.TestCase):
 def load(self,name,w=360,h=550):
  view=QQuickView();view.setColor(QColor('#182634'));view.setSource(QUrl.fromLocalFile(str(UI/name)))
  self.assertNotEqual(view.status(),QQuickView.Error)
  view.setResizeMode(QQuickView.SizeRootObjectToView);view.resize(w,h);view.show();QTest.qWait(100)
  self.addCleanup(view.close)
  return view,view.rootObject()
 def test_configuration_schema_and_pages(self):
  ns={'k':'http://www.kde.org/standards/kcfg/1.0'}
  entries=ET.parse(ROOT/'package/contents/config/main.xml').findall('.//k:entry',ns)
  defaults=json.loads((UI/'Settings.js').read_text().split('var defaults = ')[1].rstrip(';\n'))
  expected={e.attrib['name'] for e in entries};found=set()
  for page in ['Styles','Display','Fonts','Aquarium','Appearance','Updates','Help','About']:
   view,obj=self.load('config'+page+'.qml',640,600)
   aliases=re.findall(r'property (?:alias|string|int|bool) cfg_(\w+):', (UI/('config'+page+'.qml')).read_text())
   for key in aliases:
    self.assertTrue(obj.setProperty('cfg_'+key,defaults[key]),key)
    self.assertEqual(obj.property('cfg_'+key),defaults[key],key)
   found.update(aliases)
  self.assertEqual(found,expected);self.assertEqual(set(defaults),expected)
 def test_main_window_and_meter_only(self):
  view,obj=self.load('Dashboard.qml')
  obj.setProperty('snapshot',{'windows':[
   {'id':'codex/short','name':'Codex & Work','main':True,'window':'5-hour','remaining':40},
   {'id':'codex/week','name':'Codex & Work','main':True,'window':'Weekly','remaining':70},
   {'id':'spark/short','name':'Spark','main':False,'window':'5-hour','remaining':95}]})
  QTest.qWait(50)
  self.assertEqual(obj.property('remaining'),40)
  self.assertEqual(len(plain(obj.property('additional'))),2)
  obj.setProperty('settings',{'mainWindow':1,'meterOnly':True,'fishCount':7,'waterOpacity':22})
  QTest.qWait(50)
  self.assertEqual(obj.property('remaining'),70)
  self.assertTrue(obj.property('meterOnly'))
  visible_labels=[x.property('text') for x in obj.findChildren(QQuickItem) if x.property('text') and x.isVisible()]
  self.assertEqual(visible_labels,[])
  orb=obj.findChild(QQuickItem,'aquarium')
  self.assertEqual(orb.property('fishCount'),7)
  self.assertAlmostEqual(orb.property('waterOpacity'),.22)
 def test_style_switching_and_animation(self):
  import hashlib
  view,obj=self.load('LiquidOrb.qml',320,320)
  obj.setProperty('value',.72);QTest.qWait(1500)
  hashes=[]
  for style in [0,1,3]:
   obj.setProperty('displayStyle',style);QTest.qWait(120)
   image=view.grabWindow()
   hashes.append(hashlib.sha256(bytes(image.constBits())).hexdigest())
  self.assertEqual(len(set(hashes)),3)
  before=obj.property('stylePhase');QTest.qWait(150)
  self.assertGreater(obj.property('stylePhase'),before)
  obj.setProperty('styleAnimate',False);before=obj.property('stylePhase');QTest.qWait(150)
  self.assertEqual(obj.property('stylePhase'),before)
  # Empty and unavailable states must render for every display style too.
  obj.setProperty('value',0);QTest.qWait(1500)
  for style in [0,1,3]:
   obj.setProperty('displayStyle',style);obj.setProperty('hasData',False);QTest.qWait(30)
   self.assertFalse(view.grabWindow().isNull())
  view,page=self.load('configStyles.qml',640,700)
  color=page.findChild(QQuickItem,'carColor')
  for style in range(4):
   page.setProperty('cfg_displayStyle',style)
   self.assertEqual(color.isEnabled(),style==3)
 def test_analytics_history(self):
  view,obj=self.load('Dashboard.qml',360,540)
  obj.setProperty('settings',{'displayStyle':2})
  chart=obj.findChild(QQuickItem,'analytics')
  self.assertTrue(chart.isVisible())
  self.assertFalse(chart.property('hasTrend'))
  def sample(i,reset=9000):
   return {'updatedAt':1000+i*180,'windows':[{'id':'codex/week','name':'Codex & Work','main':True,'window':'Weekly','remaining':94-i*2,'resetsAt':reset}]}
  for i in range(8):obj.setProperty('snapshot',sample(i))
  QTest.qWait(50)
  self.assertEqual(len(plain(obj.property('trendSeries'))),8)
  self.assertTrue(chart.property('hasTrend'))
  obj.setProperty('snapshot',sample(7))
  self.assertEqual(len(plain(obj.property('historySamples'))),8)
  obj.setProperty('snapshot',sample(8,18000))
  self.assertEqual(len(plain(obj.property('trendSeries'))),1)
  self.assertFalse(chart.property('hasTrend'))
  obj.setProperty('settings',{'displayStyle':2,'meterOnly':True})
  QTest.qWait(30)
  self.assertEqual([x.property('text') for x in obj.findChildren(QQuickItem) if x.property('text') and x.isVisible()],[])
  for i in range(9,500):obj.setProperty('snapshot',sample(i,18000))
  self.assertEqual(len(plain(obj.property('historySamples'))),480)
  self.assertFalse(view.grabWindow().isNull())
 def test_custom_font_and_system_fallback(self):
  view,obj=self.load('Dashboard.qml')
  default=obj.property('textFont')
  settings={'useCustomFont':True,'fontFamily':'DejaVu Sans Mono','fontSize':14,'fontWeight':700,'fontItalic':True,'fontStyle':''}
  obj.setProperty('settings',settings);QTest.qWait(30)
  title=next(x for x in obj.findChildren(QQuickItem) if x.property('text')=='T I D E')
  chosen=title.property('font')
  self.assertEqual(chosen.family(),'DejaVu Sans Mono')
  self.assertEqual(chosen.weight(),700);self.assertTrue(chosen.italic())
  self.assertAlmostEqual(chosen.pointSizeF(),14*1.35,places=1)
  obj.setProperty('settings',{'useCustomFont':False});QTest.qWait(30)
  self.assertEqual(obj.property('textFont').family(),default.family())
  view,page=self.load('configFonts.qml',640,650)
  page.setProperty('cfg_useCustomFont',True)
  page.setProperty('cfg_fontFamily','DejaVu Sans Mono')
  page.setProperty('cfg_fontSize',14)
  self.assertTrue(page.findChild(QQuickItem,'chooseFontButton').isEnabled())
  self.assertEqual(page.findChild(QQuickItem,'fontPreview').property('font').family(),'DejaVu Sans Mono')
  picker=page.findChild(QObject,'fontPicker')
  selection=QFont('DejaVu Sans Mono',16);selection.setBold(True);selection.setItalic(True)
  picker.setProperty('selectedFont',selection)
  self.assertTrue(QMetaObject.invokeMethod(picker,'accepted'))
  self.assertEqual(page.property('cfg_fontFamily'),'DejaVu Sans Mono')
  self.assertEqual(page.property('cfg_fontSize'),16)
  self.assertEqual(page.property('cfg_fontWeight'),700)
  self.assertTrue(page.property('cfg_fontItalic'))
  page.setProperty('cfg_useCustomFont',False)
  self.assertFalse(page.findChild(QQuickItem,'chooseFontButton').isEnabled())
 def test_frame_mode_controls(self):
  view,page=self.load('configAquarium.qml',640,650)
  spin=page.findChild(QQuickItem,'customFrameRate')
  for mode in range(4):
   page.setProperty('cfg_frameMode',mode)
   self.assertEqual(spin.isEnabled(),mode==3)
  view,orb=self.load('LiquidOrb.qml',300,300)
  for mode,expected in [(0,30),(1,60),(2,0),(3,75)]:
   orb.setProperty('frameRate',75)
   orb.setProperty('frameMode',mode)
   self.assertEqual(orb.property('frameCap'),expected)
 def test_independent_animation(self):
  view,obj=self.load('LiquidOrb.qml',300,300)
  obj.setProperty('animateWater',False)
  a=obj.property('phase');b=obj.property('fishPhase');QTest.qWait(180)
  self.assertEqual(obj.property('phase'),a);self.assertGreater(obj.property('fishPhase'),b)
  obj.setProperty('active',False);a=obj.property('fishPhase');QTest.qWait(180)
  self.assertEqual(obj.property('fishPhase'),a)
 def test_transparent_water(self):
  view,obj=self.load('LiquidOrb.qml',300,300)
  for k,v in {'showFish':False,'showBubbles':False,'showGlow':False,'glassOpacity':0,'waterOpacity':0,'value':1,'active':False}.items():obj.setProperty(k,v)
  QTest.qWait(1600)
  self.assertEqual(view.grabWindow().pixelColor(150,150).name(),'#182634')
  obj.setProperty('waterOpacity',0.35);QTest.qWait(100)
  dark=view.grabWindow().pixelColor(150,150)
  view.setColor(QColor('#e0e0e0'));QTest.qWait(100)
  light=view.grabWindow().pixelColor(150,150)
  self.assertGreater(light.red()-dark.red(),30)
  self.assertLess(light.red(),224)
if __name__=='__main__':unittest.main()
