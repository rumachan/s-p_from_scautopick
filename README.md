# s-p_from_scautopick
S-P estimates from passing multiplexed mseed to scautopick

# Purpose
Given the location scatter for earthquakes near volcanoes, the volcano monitoring team sometimes wonder about how S-P interval might be used to see if any hypocentral 'migration' can be seen. In an ideal situation the quality of 'routine monitoring locations' would be sufficient to provide the necessary data, but at the moment it is not.

# Detail
Previous efforts to look at changes in S-P at volcanoes, such as Raoul Island in 2006, relied on manually picking P- and S-phases.  An alternative is to use get scautopick to make P- and S-picks from multiplaxed mini-seed files, typically a day at a time.

scautopick produces a SC3 XML file, which is parsed to produce a file of P- and S-picks using sc3ml2sp.py via 
parse_xml.sh.This produces a series of text (.dat) files, like WIZ_20190531_sc3_s-p.dat, which contain the S-P data.

# Visualization
- A time-series of S-P versus earthquake origin time
![GitHub Logo](/readme_images/WIZ_S-P_time-series.png)
- A histogram of S-P for all and best (SNR > x) data
![GitHub Logo](/readme_images/WIZ_S-P_histogram.png)

# Maturity
This is not a mature product.
