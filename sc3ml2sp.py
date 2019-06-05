#!/usr/bin/env python

import xml.etree.ElementTree as ET
import re
from datetime import datetime
import pandas as pd

tree = ET.ElementTree(file='scautopick_dump.xml')
root = tree.getroot()
rt = str(root.tag)[:-8]	#should be {http://geofon.gfz-potsdam.de/ns/seiscomp3-schema/0.7}

#picks, get every phase pick, p+s
phase = []
pick = []
sminp = []
for elem in tree.iter(tag=rt+'pick'):
  obs = str(elem.attrib).split()
  match = re.search('S-AIC', obs[1])
  if not match: #P phase
    ps = 'P'
    pspick = obs[1][1:19]
    pdt = datetime.strptime(pspick, '%Y%m%d.%H%M%S.%f')
    sp = -1
  else: #S phase
    ps = 'S'
    pspick = obs[1][1:19]
    sdt = datetime.strptime(pspick, '%Y%m%d.%H%M%S.%f')
    sp = (sdt - pdt).total_seconds()
  #pspick = obs[1][1:19]
  #pdt = datetime.strptime(pspick, '%Y%m%d.%H%M%S.%f')
  phase.append(ps)
  pick.append(pdt)
  sminp.append(sp)
d = {'sminusp': sminp, 'phase': phase, 'dt': pick}
dfpick = pd.DataFrame(data=d)

#signal/noise
snr = []
for elem in tree.iter(tag=rt+'snr'):
  snr.append(elem.text)
pick = []
for elem in tree.iter(tag=rt+'pickID'):
  #pickid.append(elem.text)
  pspick = elem.text[:18]
  pdt = datetime.strptime(pspick, '%Y%m%d.%H%M%S.%f')
  pick.append(pdt)
d = {'dt': pick, 'snr': snr}
dfsnr = pd.DataFrame(data=d)

#merge dataframes on pick time
df = pd.merge(dfpick, dfsnr, on='dt')
#keep only rows with s phase
dfsp = df[df.phase == 'S']
#get odd rows (pick snr), discarding amplitude snr
dfsp = dfsp[::2]
#format datetime
dfsp['dtout'] = dfsp['dt'].apply(lambda x: x.strftime('%Y-%m-%dT%H:%M:%S'))
#output
dfsp[['dtout','sminusp','snr']].to_csv('scautopick.sp', sep=' ', index=False, header=False)
