clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Gren_Walk_005.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Grenada Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	11/09/2020
**	Date Modified: 	11/09/2020
**  Algorithm Task: Walkscore Computation by ED


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Set Overall data size to number of EDs
set obs 287 // number of EDs in Grenada

*Create identifier
egen id = seq()

*Create inital variable for walkscore java script output
gen s = fileread("https://www.walkscore.com/score/773WX6WV+4G") 

*Follow up of additional EDs using Google plus codes
replace s = fileread("https://www.walkscore.com/score/774W263Q+RX") in 2
replace s = fileread("https://www.walkscore.com/score/774W263C+XR") in 3
replace s = fileread("https://www.walkscore.com/score/774W265W+42") in 4
replace s = fileread("https://www.walkscore.com/score/774W267Q+Q9") in 5
replace s = fileread("https://www.walkscore.com/score/774W266F+Q3") in 6
replace s = fileread("https://www.walkscore.com/score/774W268M+9X") in 7
replace s = fileread("https://www.walkscore.com/score/774W275P+99") in 8
replace s = fileread("https://www.walkscore.com/score/774W26PW+3J") in 9
replace s = fileread("https://www.walkscore.com/score/774W2787+J7") in 10
replace s = fileread("https://www.walkscore.com/score/774W2763+9H") in 11
replace s = fileread("https://www.walkscore.com/score/774W2749+27") in 12
replace s = fileread("https://www.walkscore.com/score/774W278V+22") in 13
replace s = fileread("https://www.walkscore.com/score/774W269Q+7H") in 14
replace s = fileread("https://www.walkscore.com/score/774W269W+M7") in 15
replace s = fileread("https://www.walkscore.com/score/774W26CV+86") in 16
replace s = fileread("https://www.walkscore.com/score/774W277F+66") in 17
replace s = fileread("https://www.walkscore.com/score/774W578C+Q2") in 18
replace s = fileread("https://www.walkscore.com/score/774W583V+WJ") in 19
replace s = fileread("https://www.walkscore.com/score/774W27FC+3H") in 20
replace s = fileread("https://www.walkscore.com/score/774W27F6+9W") in 21
replace s = fileread("https://www.walkscore.com/score/774W26GX+72") in 22
replace s = fileread("https://www.walkscore.com/score/774W27H9+7P") in 23
replace s = fileread("https://www.walkscore.com/score/774W27FG+W2") in 24
replace s = fileread("https://www.walkscore.com/score/774W27Q3+W9") in 25
replace s = fileread("https://www.walkscore.com/score/774W27F4+Q4") in 26
replace s = fileread("https://www.walkscore.com/score/774W28F8+F6") in 27
replace s = fileread("https://www.walkscore.com/score/774W27J8+P3") in 28
replace s = fileread("https://www.walkscore.com/score/774W28H2+4C") in 29
replace s = fileread("https://www.walkscore.com/score/774W26MX+QG") in 30
replace s = fileread("https://www.walkscore.com/score/774W27M3+8V") in 31
replace s = fileread("https://www.walkscore.com/score/774W27Q6+6J") in 32
replace s = fileread("https://www.walkscore.com/score/774W26FP+CH") in 33
replace s = fileread("https://www.walkscore.com/score/774W27V4+VQ") in 34
replace s = fileread("https://www.walkscore.com/score/774W28Q4+4F") in 35
replace s = fileread("https://www.walkscore.com/score/774W27GH+8H") in 36
replace s = fileread("https://www.walkscore.com/score/774W27HM+9G") in 37
replace s = fileread("https://www.walkscore.com/score/774W26QX+RF") in 38
replace s = fileread("https://www.walkscore.com/score/774W27P9+PR") in 39
replace s = fileread("https://www.walkscore.com/score/774W27R4+P7") in 40
replace s = fileread("https://www.walkscore.com/score/774W28JM+CC") in 41
replace s = fileread("https://www.walkscore.com/score/774W27QF+C7") in 42
replace s = fileread("https://www.walkscore.com/score/774W3744+V2") in 43
replace s = fileread("https://www.walkscore.com/score/774W27V2+54") in 44
replace s = fileread("https://www.walkscore.com/score/774W27V4+J3") in 45
replace s = fileread("https://www.walkscore.com/score/774W27RG+QP") in 46
replace s = fileread("https://www.walkscore.com/score/774W27V9+X7") in 47
replace s = fileread("https://www.walkscore.com/score/774W27VF+7J") in 48
replace s = fileread("https://www.walkscore.com/score/774W27WM+92") in 49
replace s = fileread("https://www.walkscore.com/score/774W27V6+J6") in 50
replace s = fileread("https://www.walkscore.com/score/774W27MV+73") in 51
replace s = fileread("https://www.walkscore.com/score/774W27PW+HJ") in 52
replace s = fileread("https://www.walkscore.com/score/774W375H+JC") in 53
replace s = fileread("https://www.walkscore.com/score/774W27VQ+67") in 54
replace s = fileread("https://www.walkscore.com/score/774W27X5+F6") in 55
replace s = fileread("https://www.walkscore.com/score/774W27XH+94") in 56
replace s = fileread("https://www.walkscore.com/score/774W27W7+FG") in 57
replace s = fileread("https://www.walkscore.com/score/774W362X+M5") in 58
replace s = fileread("https://www.walkscore.com/score/774W363X+4Q") in 59
replace s = fileread("https://www.walkscore.com/score/774W3732+76") in 60
replace s = fileread("https://www.walkscore.com/score/774W363W+38") in 61
replace s = fileread("https://www.walkscore.com/score/774W28R9+6P") in 62
replace s = fileread("https://www.walkscore.com/score/774W27X2+GW") in 63
replace s = fileread("https://www.walkscore.com/score/774W26XW+VH") in 64
replace s = fileread("https://www.walkscore.com/score/774W3724+89") in 65
replace s = fileread("https://www.walkscore.com/score/774W362W+HC") in 66
replace s = fileread("https://www.walkscore.com/score/774W3723+V2") in 67
replace s = fileread("https://www.walkscore.com/score/774W3722+HC") in 68
replace s = fileread("https://www.walkscore.com/score/774W28QR+GH") in 69
replace s = fileread("https://www.walkscore.com/score/774W28W2+83") in 70
replace s = fileread("https://www.walkscore.com/score/774W3734+H6") in 71
replace s = fileread("https://www.walkscore.com/score/774W28X3+W3") in 72
replace s = fileread("https://www.walkscore.com/score/774W363W+F8") in 73
replace s = fileread("https://www.walkscore.com/score/774W3732+F4") in 74
replace s = fileread("https://www.walkscore.com/score/774W3733+4J") in 75
replace s = fileread("https://www.walkscore.com/score/774W3732+8R") in 76
replace s = fileread("https://www.walkscore.com/score/774W579C+4J") in 77
replace s = fileread("https://www.walkscore.com/score/774W3728+C6") in 78
replace s = fileread("https://www.walkscore.com/score/774W372M+83") in 79
replace s = fileread("https://www.walkscore.com/score/774W363W+QM") in 80
replace s = fileread("https://www.walkscore.com/score/774W363X+JC") in 81
replace s = fileread("https://www.walkscore.com/score/774W28VF+FM") in 82
replace s = fileread("https://www.walkscore.com/score/774W28XH+CH") in 83
replace s = fileread("https://www.walkscore.com/score/774W3742+46") in 84
replace s = fileread("https://www.walkscore.com/score/774W28WX+RV") in 85
replace s = fileread("https://www.walkscore.com/score/774W3932+9W") in 86
replace s = fileread("https://www.walkscore.com/score/774W28V7+VM") in 87
replace s = fileread("https://www.walkscore.com/score/774W364W+58") in 88
replace s = fileread("https://www.walkscore.com/score/774W28R6+V2") in 89
replace s = fileread("https://www.walkscore.com/score/774W364X+Q8") in 90
replace s = fileread("https://www.walkscore.com/score/774W3752+53") in 91
replace s = fileread("https://www.walkscore.com/score/774W3745+98") in 92
replace s = fileread("https://www.walkscore.com/score/774W3749+92") in 93
replace s = fileread("https://www.walkscore.com/score/774W3756+5X") in 94
replace s = fileread("https://www.walkscore.com/score/774W385W+C9") in 95
replace s = fileread("https://www.walkscore.com/score/774W3934+JX") in 96
replace s = fileread("https://www.walkscore.com/score/774W384M+PV") in 97
replace s = fileread("https://www.walkscore.com/score/774W386W+7C") in 98
replace s = fileread("https://www.walkscore.com/score/774W3956+M4") in 99
replace s = fileread("https://www.walkscore.com/score/774W374Q+P9") in 100
replace s = fileread("https://www.walkscore.com/score/774W685Q+X6") in 101
replace s = fileread("https://www.walkscore.com/score/774W3769+M2") in 102
replace s = fileread("https://www.walkscore.com/score/774W37F9+24") in 103
replace s = fileread("https://www.walkscore.com/score/774W368X+3F") in 104
replace s = fileread("https://www.walkscore.com/score/774W3778+X3") in 105
replace s = fileread("https://www.walkscore.com/score/774W3982+43") in 106
replace s = fileread("https://www.walkscore.com/score/774W47FG+7Q") in 107
replace s = fileread("https://www.walkscore.com/score/774W378J+VF") in 108
replace s = fileread("https://www.walkscore.com/score/774W3799+X2") in 109
replace s = fileread("https://www.walkscore.com/score/774W387Q+88") in 110
replace s = fileread("https://www.walkscore.com/score/774W3873+9X") in 111
replace s = fileread("https://www.walkscore.com/score/774W376W+67") in 112
replace s = fileread("https://www.walkscore.com/score/774W3877+MH") in 113
replace s = fileread("https://www.walkscore.com/score/774W37FM+84") in 114
replace s = fileread("https://www.walkscore.com/score/774W49HF+32") in 115
replace s = fileread("https://www.walkscore.com/score/774W3795+W9") in 116
replace s = fileread("https://www.walkscore.com/score/774W3998+G4") in 117
replace s = fileread("https://www.walkscore.com/score/774W38FV+6Q") in 118
replace s = fileread("https://www.walkscore.com/score/774W37HG+3V") in 119
replace s = fileread("https://www.walkscore.com/score/774W388F+GP") in 120
replace s = fileread("https://www.walkscore.com/score/774W37F3+Q8") in 121
replace s = fileread("https://www.walkscore.com/score/774W49MC+RX") in 122
replace s = fileread("https://www.walkscore.com/score/774W37H2+VV") in 123
replace s = fileread("https://www.walkscore.com/score/774W36JV+WC") in 124
replace s = fileread("https://www.walkscore.com/score/774W37HV+GF") in 125
replace s = fileread("https://www.walkscore.com/score/774W49QC+M6") in 126
replace s = fileread("https://www.walkscore.com/score/774W37JH+J4") in 127
replace s = fileread("https://www.walkscore.com/score/774W36MW+QR") in 128
replace s = fileread("https://www.walkscore.com/score/774W36JR+HR") in 129
replace s = fileread("https://www.walkscore.com/score/774W37MG+JC") in 130
replace s = fileread("https://www.walkscore.com/score/774W36PX+CX") in 131
replace s = fileread("https://www.walkscore.com/score/774W37J8+36") in 132
replace s = fileread("https://www.walkscore.com/score/774W38MR+32") in 133
replace s = fileread("https://www.walkscore.com/score/774W6994+2R") in 134
replace s = fileread("https://www.walkscore.com/score/774W39M7+H8") in 135
replace s = fileread("https://www.walkscore.com/score/774W39MC+PV") in 136
replace s = fileread("https://www.walkscore.com/score/774W69C6+XQ") in 137
replace s = fileread("https://www.walkscore.com/score/774W37Q3+HV") in 138
replace s = fileread("https://www.walkscore.com/score/774W38RW+94") in 139
replace s = fileread("https://www.walkscore.com/score/774W4926+G6") in 140
replace s = fileread("https://www.walkscore.com/score/774W36RV+JQ") in 141
replace s = fileread("https://www.walkscore.com/score/774W39V7+VH") in 142
replace s = fileread("https://www.walkscore.com/score/774W4965+55") in 143
replace s = fileread("https://www.walkscore.com/score/774W37R9+WV") in 144
replace s = fileread("https://www.walkscore.com/score/774W487G+8F") in 145
replace s = fileread("https://www.walkscore.com/score/774W39W9+XH") in 146
replace s = fileread("https://www.walkscore.com/score/774W38WR+P6") in 147
replace s = fileread("https://www.walkscore.com/score/774W4939+93") in 148
replace s = fileread("https://www.walkscore.com/score/774W37RV+M5") in 149
replace s = fileread("https://www.walkscore.com/score/774W4948+M8") in 150
replace s = fileread("https://www.walkscore.com/score/774W472H+FQ") in 151
replace s = fileread("https://www.walkscore.com/score/774W4724+PW") in 152
replace s = fileread("https://www.walkscore.com/score/774W38Q7+PX") in 153
replace s = fileread("https://www.walkscore.com/score/774W4999+R4") in 154
replace s = fileread("https://www.walkscore.com/score/774W484W+7X") in 155
replace s = fileread("https://www.walkscore.com/score/774W49CF+M4") in 156
replace s = fileread("https://www.walkscore.com/score/774W483J+VH") in 157
replace s = fileread("https://www.walkscore.com/score/774W49FF+8P") in 158
replace s = fileread("https://www.walkscore.com/score/774W476H+J8") in 159
replace s = fileread("https://www.walkscore.com/score/774W485Q+VH") in 160
replace s = fileread("https://www.walkscore.com/score/774W4968+R5") in 161
replace s = fileread("https://www.walkscore.com/score/774W48CR+F9") in 162
replace s = fileread("https://www.walkscore.com/score/774W47CF+39") in 163
replace s = fileread("https://www.walkscore.com/score/774W478J+29") in 164
replace s = fileread("https://www.walkscore.com/score/774W4989+3V") in 165
replace s = fileread("https://www.walkscore.com/score/774W499F+PR") in 166
replace s = fileread("https://www.walkscore.com/score/774W4793+37") in 167
replace s = fileread("https://www.walkscore.com/score/774W4992+6G") in 168
replace s = fileread("https://www.walkscore.com/score/774W4856+VF") in 169
replace s = fileread("https://www.walkscore.com/score/774W48CJ+PG") in 170
replace s = fileread("https://www.walkscore.com/score/774W49F8+QV") in 171
replace s = fileread("https://www.walkscore.com/score/774W49GH+JW") in 172
replace s = fileread("https://www.walkscore.com/score/774W49HG+9C") in 173
replace s = fileread("https://www.walkscore.com/score/774W47F3+C5") in 174
replace s = fileread("https://www.walkscore.com/score/774W49FG+WP") in 175
replace s = fileread("https://www.walkscore.com/score/774W49GP+JX") in 176
replace s = fileread("https://www.walkscore.com/score/774W49FV+WQ") in 177
replace s = fileread("https://www.walkscore.com/score/774W49GP+3F") in 178
replace s = fileread("https://www.walkscore.com/score/774W49GJ+8Q") in 179
replace s = fileread("https://www.walkscore.com/score/774W48CP+FC") in 180
replace s = fileread("https://www.walkscore.com/score/774W49G7+MJ") in 181
replace s = fileread("https://www.walkscore.com/score/774W47J7+42") in 182
replace s = fileread("https://www.walkscore.com/score/774W47GJ+8V") in 183
replace s = fileread("https://www.walkscore.com/score/774W49JJ+CV") in 184
replace s = fileread("https://www.walkscore.com/score/774W48HX+47") in 185
replace s = fileread("https://www.walkscore.com/score/774W49J5+G8") in 186
replace s = fileread("https://www.walkscore.com/score/774W373J+H4") in 187
replace s = fileread("https://www.walkscore.com/score/774W48HC+89") in 188
replace s = fileread("https://www.walkscore.com/score/774W49PP+MR") in 189
replace s = fileread("https://www.walkscore.com/score/774W49XM+WH") in 190
replace s = fileread("https://www.walkscore.com/score/774W48W5+2M") in 191
replace s = fileread("https://www.walkscore.com/score/774W49Q4+9W") in 192
replace s = fileread("https://www.walkscore.com/score/774W49QJ+XF") in 193
replace s = fileread("https://www.walkscore.com/score/774W48PG+WH") in 194
replace s = fileread("https://www.walkscore.com/score/774W48WM+G9") in 195
replace s = fileread("https://www.walkscore.com/score/774W49V9+MR") in 196
replace s = fileread("https://www.walkscore.com/score/774W49VJ+QX") in 197
replace s = fileread("https://www.walkscore.com/score/774W575G+R2") in 198
replace s = fileread("https://www.walkscore.com/score/774W49V6+X3") in 199
replace s = fileread("https://www.walkscore.com/score/774W5769+QG") in 200
replace s = fileread("https://www.walkscore.com/score/774W574P+9V") in 201
replace s = fileread("https://www.walkscore.com/score/774W3743+M7") in 202
replace s = fileread("https://www.walkscore.com/score/774W5927+WH") in 203
replace s = fileread("https://www.walkscore.com/score/774W577F+P3") in 204
replace s = fileread("https://www.walkscore.com/score/774W47WJ+VW") in 205
replace s = fileread("https://www.walkscore.com/score/774W47PH+JR") in 206
replace s = fileread("https://www.walkscore.com/score/774W592F+M2") in 207
replace s = fileread("https://www.walkscore.com/score/774W596H+75") in 208
replace s = fileread("https://www.walkscore.com/score/774W5789+4R") in 209
replace s = fileread("https://www.walkscore.com/score/774W594P+GG") in 210
replace s = fileread("https://www.walkscore.com/score/774W578C+7H") in 211
replace s = fileread("https://www.walkscore.com/score/774W5968+HW") in 212
replace s = fileread("https://www.walkscore.com/score/774W5789+9F") in 213
replace s = fileread("https://www.walkscore.com/score/774W579F+5W") in 214
replace s = fileread("https://www.walkscore.com/score/774W576X+8J") in 215
replace s = fileread("https://www.walkscore.com/score/774W598F+XR") in 216
replace s = fileread("https://www.walkscore.com/score/774W598R+F9") in 217
replace s = fileread("https://www.walkscore.com/score/774W598M+PJ") in 218
replace s = fileread("https://www.walkscore.com/score/774W5982+67") in 219
replace s = fileread("https://www.walkscore.com/score/774W59CC+FF") in 220
replace s = fileread("https://www.walkscore.com/score/774W58R2+PG") in 221
replace s = fileread("https://www.walkscore.com/score/774W59F3+C9") in 222
replace s = fileread("https://www.walkscore.com/score/774W59FQ+GG") in 223
replace s = fileread("https://www.walkscore.com/score/774W57CM+M2") in 224
replace s = fileread("https://www.walkscore.com/score/774W694F+FQ") in 225
replace s = fileread("https://www.walkscore.com/score/774W59G5+V3") in 226
replace s = fileread("https://www.walkscore.com/score/774W59MC+G9") in 227
replace s = fileread("https://www.walkscore.com/score/774W59H9+C9") in 228
replace s = fileread("https://www.walkscore.com/score/774W57WW+94") in 229
replace s = fileread("https://www.walkscore.com/score/774W59MP+29") in 230
replace s = fileread("https://www.walkscore.com/score/774W58HV+W8") in 231
replace s = fileread("https://www.walkscore.com/score/774W59QH+P2") in 232
replace s = fileread("https://www.walkscore.com/score/774W57VV+9W") in 233
replace s = fileread("https://www.walkscore.com/score/774W58F6+WQ") in 234
replace s = fileread("https://www.walkscore.com/score/774W57VV+QH") in 235
replace s = fileread("https://www.walkscore.com/score/774W57MP+CX") in 236
replace s = fileread("https://www.walkscore.com/score/774W57WV+49") in 237
replace s = fileread("https://www.walkscore.com/score/774W59WH+63") in 238
replace s = fileread("https://www.walkscore.com/score/774W59RR+R8") in 239
replace s = fileread("https://www.walkscore.com/score/774W693M+H7") in 240
replace s = fileread("https://www.walkscore.com/score/774W59W8+H7") in 241
replace s = fileread("https://www.walkscore.com/score/774W58RM+53") in 242
replace s = fileread("https://www.walkscore.com/score/774W58V6+7X") in 243
replace s = fileread("https://www.walkscore.com/score/774W58WX+8F") in 244
replace s = fileread("https://www.walkscore.com/score/774W6936+P8") in 245
replace s = fileread("https://www.walkscore.com/score/774W685M+W2") in 246
replace s = fileread("https://www.walkscore.com/score/774W682F+VG") in 247
replace s = fileread("https://www.walkscore.com/score/774W6966+5R") in 248
replace s = fileread("https://www.walkscore.com/score/774W683R+VG") in 249
replace s = fileread("https://www.walkscore.com/score/774W6953+FV") in 250
replace s = fileread("https://www.walkscore.com/score/774W6879+FV") in 251
replace s = fileread("https://www.walkscore.com/score/774W6846+CF") in 252
replace s = fileread("https://www.walkscore.com/score/774W687F+WJ") in 253
replace s = fileread("https://www.walkscore.com/score/774W6997+85") in 254
replace s = fileread("https://www.walkscore.com/score/774W6982+C4") in 255
replace s = fileread("https://www.walkscore.com/score/774W69F5+9R") in 256
replace s = fileread("https://www.walkscore.com/score/774W69F6+PJ") in 257
replace s = fileread("https://www.walkscore.com/score/774WFGMW+V9") in 258
replace s = fileread("https://www.walkscore.com/score/774W689R+C9") in 259
replace s = fileread("https://www.walkscore.com/score/774WGH53+MP") in 260
replace s = fileread("https://www.walkscore.com/score/774WGH87+6R") in 261
replace s = fileread("https://www.walkscore.com/score/774W699H+7G") in 262
replace s = fileread("https://www.walkscore.com/score/774W69CP+9G") in 263
replace s = fileread("https://www.walkscore.com/score/774W68GW+QQ") in 264
replace s = fileread("https://www.walkscore.com/score/774W68FM+J5") in 265
replace s = fileread("https://www.walkscore.com/score/774WFG4P+H4") in 266
replace s = fileread("https://www.walkscore.com/score/774WFG39+3Q") in 267
replace s = fileread("https://www.walkscore.com/score/774W47J2+4V") in 268
replace s = fileread("https://www.walkscore.com/score/774WFG8W+5H") in 269
replace s = fileread("https://www.walkscore.com/score/774WFG8G+F4") in 270
replace s = fileread("https://www.walkscore.com/score/774WFH85+7M") in 271
replace s = fileread("https://www.walkscore.com/score/774WFGFV+6H") in 272
replace s = fileread("https://www.walkscore.com/score/774WFG96+XP") in 273
replace s = fileread("https://www.walkscore.com/score/774WFHG6+J9") in 274
replace s = fileread("https://www.walkscore.com/score/774WFGGM+4P") in 275
replace s = fileread("https://www.walkscore.com/score/774WFGHV+JC") in 276
replace s = fileread("https://www.walkscore.com/score/774WFHM2+49") in 277
replace s = fileread("https://www.walkscore.com/score/774W27QJ+9C") in 278
replace s = fileread("https://www.walkscore.com/score/774WFHV3+MG") in 279
replace s = fileread("https://www.walkscore.com/score/774WFHR8+43") in 280
replace s = fileread("https://www.walkscore.com/score/774WGH39+JG") in 281
replace s = fileread("https://www.walkscore.com/score/774W49PH+RM") in 282
replace s = fileread("https://www.walkscore.com/score/774WGJ99+G5") in 283
replace s = fileread("https://www.walkscore.com/score/774W3763+C9") in 284
replace s = fileread("https://www.walkscore.com/score/774W26HX+J8") in 285
replace s = fileread("https://www.walkscore.com/score/774W372F+M2") in 286
replace s = fileread("https://www.walkscore.com/score/774WGJ96+FM") in 287


*Remove unneccessary string prior to walk score estimate
gen last = substr(s, strpos(s, "This location has a Walk Score of") + 33, .)

*Split remaining string into seperate variables to obtain walk score into one variable
split last

*Remove unncessary variables not needed for analysis
keep id last1

*Destring walk score estimate. 
destring last1, replace

*Rename variable
rename last1 walkscore


browse

/*
split s, parse(-)
keep s s378
gen state8 = substr(s378, 46, 2)
destring state7, replace
browse
