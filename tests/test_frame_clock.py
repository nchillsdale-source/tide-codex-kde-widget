"""Deterministic tests of the same frame scheduler used by the widget."""
import os,unittest,json
from pathlib import Path
os.environ.setdefault('QT_QPA_PLATFORM','offscreen')
from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QJSEngine
app=QCoreApplication.instance() or QCoreApplication([])
class ClockTests(unittest.TestCase):
 def setUp(self):
  self.js=QJSEngine()
  path=Path(__file__).resolve().parents[1]/'package/contents/ui/FrameClock.js'
  result=self.js.evaluate(path.read_text().replace('.pragma library',''))
  self.assertFalse(result.isError())
 def run_clock(self,hz,mode,custom=30):
  return json.loads(self.js.evaluate('''JSON.stringify((function(){
   var state={budget:0,elapsed:0},frames=0,motion=0;
   for(var i=0;i<%d;i++){var dt=step(state,1/%s,cap(%d,%d));if(dt>0){frames++;motion+=dt;}}
   return {frames:frames,motion:motion};
  })())'''%(round(hz*10),hz,mode,custom)).toString())
 def test_caps_across_displays(self):
  for hz in [30,59.94,60,120,144,165,240]:
   for mode,custom,target in [(0,30,30),(1,30,60),(2,30,hz),(3,25,25),(3,240,240)]:
    with self.subTest(hz=hz,mode=mode,custom=custom):
     result=self.run_clock(hz,mode,custom)
     self.assertAlmostEqual(result['frames'],min(hz,target)*10,delta=1.1)
     self.assertAlmostEqual(result['motion'],10,delta=.06)
 def test_long_stall_does_not_jump(self):
  value=self.js.evaluate('step({budget:0,elapsed:0},5,30)').toNumber()
  self.assertLessEqual(value,.1)
 def test_custom_bounds(self):
  self.assertEqual(self.js.evaluate('cap(3,1)').toNumber(),10)
  self.assertEqual(self.js.evaluate('cap(3,1000)').toNumber(),240)
if __name__=='__main__':unittest.main()
