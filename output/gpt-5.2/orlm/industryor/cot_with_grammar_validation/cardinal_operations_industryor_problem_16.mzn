int: N = 4;
set of int: PARTS = 1..N;

array[PARTS] of int: dist_km = [450, 480, 540, 600];

int: maxHeavy = 28;
int: maxLight = 12;
int: fuelLimit = 10000;

int: SCALE = 1000000;
array[PARTS] of int: pH = [30000, 100000, 50000, 50000];
array[PARTS] of int: pL = [80000, 110000, 120000, 90000];

array[PARTS] of int: qH = [SCALE - pH[i] | i in PARTS];
array[PARTS] of int: qL = [SCALE - pL[i] | i in PARTS];

array[PARTS] of int: fuelH = [(3 * dist_km[i] + 3) div 4 + 100 | i in PARTS];
array[PARTS] of int: fuelL = [(7 * dist_km[i] + 11) div 12 + 100 | i in PARTS];

array[PARTS] of var 0..maxHeavy: xH;
array[PARTS] of var 0..maxLight: xL;

constraint sum(i in PARTS)(xH[i]) <= maxHeavy;
constraint sum(i in PARTS)(xL[i]) <= maxLight;

constraint sum(i in PARTS)(fuelH[i] * xH[i] + fuelL[i] * xL[i]) <= fuelLimit;

array[PARTS] of var float: r;
constraint forall(i in PARTS)(
  r[i] = pow(int2float(qH[i]) / int2float(SCALE), int2float(xH[i]))
       * pow(int2float(qL[i]) / int2float(SCALE), int2float(xL[i]))
);

var float: p0 = product(i in PARTS)(r[i]);

array[PARTS] of var float: p1k;
constraint forall(k in PARTS)(
  p1k[k] = (1.0 - r[k]) * product(i in PARTS where i != k)(r[i])
);
var float: p1 = sum(k in PARTS)(p1k[k]);

var float: psuccess = 1.0 - p0 - p1;

solve maximize psuccess;

output [
  "psuccess=", show(psuccess), "\n",
  "xH=", show(xH), "\n",
  "xL=", show(xL), "\n",
  "fuelUsed=", show(sum(i in PARTS)(fuelH[i] * xH[i] + fuelL[i] * xL[i])), "\n"
];