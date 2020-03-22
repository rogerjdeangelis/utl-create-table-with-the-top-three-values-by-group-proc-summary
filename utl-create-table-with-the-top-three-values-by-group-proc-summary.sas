Create-table-with-the-top-three-values-by-group-proc-summary;

gihub
https://tinyurl.com/sxslpea
https://github.com/rogerjdeangelis/utl-create-table-with-the-top-three-values-by-group-proc-summary

SAS Forum
https://tinyurl.com/uckrv7v
https://communities.sas.com/t5/SAS-Programming/Summation-of-the-first-5-highest-observations/m-p/633758

  Two solutions

       a. proc summary
       b. hash
          Paul Dorfman
          sashole@bellsouth.net

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

data have;
input gvkey fy TA ;
cards4;
1311 1995 3311.662
1311 1995 1599.234
1311 1995 564.76
1311 1995 560.047
1311 1995 656.226
1700 1996 577.841
1700 1996 1696.431
1700 1996 1081.963
1700 1996 1727.069
1700 1996 4182.832
1700 1996 2068.554
1700 1996 841.204
1700 1996 .
84578 1995 1312.852
84578 1995 1131.176
84578 1995 3700.925
84578 1995 1099.786
84578 1995 848.657
84578 1995 1067.566
;;;;
run;quit;

                                    |   RULES
                                    |
Up to 40 obs WORK.HAVE total obs=19 |   GVKEY     FY       TA_1       TA_2       TA_3
                                    |
Obs    GVKEY     FY        TA       |    1311    1995    3311.66    1599.23     656.23
                                    |
  1     1311    1995    3311.66     |
  2     1311    1995    1599.23     |
  3     1311    1995     564.76     |
  4     1311    1995     560.05     |
  5     1311    1995     656.23     |
                                    |   GVKEY     FY       TA_1       TA_2       TA_3
  6     1700    1996     577.84     |    1700    1996    4182.83    2068.55    1727.07
  7     1700    1996    1696.43     |
  8     1700    1996    1081.96     |
  9     1700    1996    1727.07     |
 10     1700    1996    4182.83     |
 11     1700    1996    2068.55     |
 12     1700    1996     841.20     |
 13     1700    1996        .       |
                                    |   GVKEY     FY       TA_1       TA_2       TA_3
 14    84578    1995    1312.85     |   84578    1995    3700.93    1312.85    1131.18
 15    84578    1995    1131.18     |
 16    84578    1995    3700.93     |
 17    84578    1995    1099.79     |
 18    84578    1995     848.66     |
 19    84578    1995    1067.57     |

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

* SAME for means ans hash;

Up to 40 obs from WANT total obs=3

Obs    GVKEY     FY       TA_1       TA_2       TA_3

 1      1311    1995    3311.66    1599.23     656.23
 2      1700    1996    4182.83    2068.55    1727.07
 3     84578    1995    3700.93    1312.85    1131.18

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
 ___ _   _ _ __ ___  _ __ ___   __ _ _ __ _   _
/ __| | | | '_ ` _ \| '_ ` _ \ / _` | '__| | | |
\__ \ |_| | | | | | | | | | | | (_| | |  | |_| |
|___/\__,_|_| |_| |_|_| |_| |_|\__,_|_|   \__, |
                                          |___/
;

proc means data=have nway noprint ;
class gvkey fy;
var ta;
output out=want(drop=_:) idgroup ( max(ta) out[3] (ta)=) /autolabel autoname;
run;

* if you want it long and skinny
proc transpose data=want;
by gvkey fy;
run;quit;

Up to 40 obs WORK.DATA1 total obs=9

Obs    GVKEY     FY     _NAME_      COL1

 1      1311    1995     TA_1     3311.66
 2      1311    1995     TA_2     1599.23
 3      1311    1995     TA_3      656.23
 4      1700    1996     TA_1     4182.83
 5      1700    1996     TA_2     2068.55
 6      1700    1996     TA_3     1727.07
 7     84578    1995     TA_1     3700.93
 8     84578    1995     TA_2     1312.85
 9     84578    1995     TA_3     1131.18

*_               _
| |__   __ _ ___| |__
| '_ \ / _` / __| '_ \
| | | | (_| \__ \ | | |
|_| |_|\__,_|___/_| |_|

;

data want (drop = ta) ;
  if _n_ = 1 then do ;
    dcl hash h (ordered:"D") ;
    h.definekey ("TA") ;
    h.definedone () ;
    dcl hiter hi ("h") ;
  end ;
  do until (last.fy) ;
    set have ;
    by gvkey fy ;
    h.ref() ;
  end ;
  array TA_ [3] ;
  do _n_ = 1 to dim (ta_) while (hi.next() = 0) ;
    ta_[_n_] = ta ;
  end ;
  _n_ = hi.first() ;
  _n_ = hi.prev() ;
  h.clear() ;
run ; quit ;



