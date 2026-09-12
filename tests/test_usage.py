import sys
sys.dont_write_bytecode = True
import importlib.util,unittest
from pathlib import Path
spec=importlib.util.spec_from_file_location('usage',Path(__file__).resolve().parents[1] / 'package/contents/scripts/usage.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class UsageTests(unittest.TestCase):
 def test_missing_is_not_zero(self):
  self.assertEqual(m.normalize({'rateLimits':{'primary':{'usedPercent':None}}})['windows'],[])
 def test_bucket_windows_and_priority(self):
  result=m.normalize({'rateLimitsByLimitId':{'spark':{'primary':{'usedPercent':0,'windowDurationMins':300}},'codex':{'primary':{'usedPercent':2,'windowDurationMins':10080},'secondary':{'usedPercent':40,'windowDurationMins':300}}}})
  self.assertEqual([w['remaining'] for w in result['windows']],[60,98,100])
  self.assertEqual(result['windows'][0]['window'],'5-hour')
 def test_legacy_and_clamping(self):
  self.assertEqual(m.normalize({'rateLimits':{'primary':{'usedPercent':120}}})['windows'][0]['remaining'],0)
 def test_unavailable_credit(self):
  self.assertIsNone(m.normalize({})['credits'])
 def test_nan_is_unknown(self):
  self.assertEqual(m.normalize({'rateLimits':{'primary':{'usedPercent':float('nan')}}})['windows'],[])
if __name__=='__main__': unittest.main()
