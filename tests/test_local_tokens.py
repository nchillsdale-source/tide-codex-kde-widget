import datetime as dt
import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'package/contents/scripts'))
from local_tokens import collect

def counts(n):
 return dict(input_tokens=n*8,cached_input_tokens=n*5,output_tokens=n*2,reasoning_output_tokens=n,total_tokens=n*10)
def event(t,n,last=1):
 return json.dumps({'timestamp':dt.datetime.fromtimestamp(t,dt.timezone.utc).isoformat(),'type':'event_msg','payload':{'type':'token_count','info':{'total_token_usage':counts(n),'last_token_usage':counts(last)}}})+'\n'
class TokensTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup);self.home=Path(self.tmp.name);(self.home/'sessions').mkdir();self.now=dt.datetime.now().replace(hour=12,minute=0,second=0,microsecond=0).timestamp()
 def write(self,name,text):
  p=self.home/'sessions'/name;p.write_text(text)
  import os
  os.utime(p,(self.now,self.now))
 def read(self,**kw):return collect(self.home,self.now,**kw)
 def test_repeated_status_and_copied_history(self):
  text=event(self.now-200,1)+event(self.now-199,1)+event(self.now-100,3,2)
  self.write('a.jsonl',text);self.write('copy.jsonl',text)
  r=self.read();self.assertEqual(r['today']['total_tokens'],30);self.assertEqual(r['today']['input_tokens'],24);self.assertEqual(r['today']['cached_input_tokens'],15);self.assertEqual(r['rate'],6)
 def test_midnight_baseline(self):
  midnight=dt.datetime.fromtimestamp(self.now).replace(hour=0).timestamp()
  self.write('a.jsonl',event(midnight-10,5,5)+event(midnight+10,7,2))
  self.assertEqual(self.read()['today']['total_tokens'],20)
 def test_counter_reset_and_truncated_history(self):
  self.write('a.jsonl',event(self.now-200,100,2)+event(self.now-100,1,1))
  r=self.read();self.assertEqual(r['today']['total_tokens'],30);self.assertTrue(r['partial'])
 def test_limits_and_malformed(self):
  self.write('a.jsonl',event(self.now-100,1)+'{"token_count":')
  self.assertTrue(self.read()['partial']);self.assertTrue(self.read(max_bytes=1)['partial'])
 def test_missing_and_future(self):
  self.assertFalse(self.read()['available'])
  self.write('a.jsonl',event(self.now+60,1))
  self.assertEqual(self.read()['today']['total_tokens'],0)
 def test_rate_does_not_count_old_activity(self):
  self.write('a.jsonl',event(self.now-4000,1)+event(self.now-600,3,2))
  r=self.read();self.assertEqual(r['rate'],0);self.assertEqual(sum(r['rates']),4)
if __name__=='__main__':unittest.main()
