int: N = 4;
set of int: PARTS = 1..N;

int: maxHeavy = 28;
int: maxLight = 12;
int: fuelLimit = 10000;

array[PARTS] of int: dist_km = [450, 480, 540, 600];

array[PARTS] of float: pHeavy = [0.03, 0.10, 0.05, 0.05];
array[PARTS] of float: pLight = [0.08, 0.11, 0.12, 0.09];

function int: ceil_div(int: a, int: b) = (a + b - 1) div b;

function int: fuel_per_trip_heavy(int: d) =
  ceil_div(d, 2) + ceil_div(d, 4) + 100;
function int: fuel_per_trip_light(int: d) =
  ceil_div(d, 3) + ceil_div(d, 4) + 100;

array[PARTS] of int: fuelHeavy = [ fuel_per_trip_heavy(dist_km[i]) | i in PARTS ];
array[PARTS] of int: fuelLight = [ fuel_per_trip_light(dist_km[i]) | i in PARTS ];

int: SCALE = 1000000;

array[PARTS, 0..maxHeavy] of int: qH =
  array2d(PARTS, 0..maxHeavy,
    [ round(SCALE * pow(1.0 - pHeavy[i], h)) | i in PARTS, h in 0..maxHeavy ]);

array[PARTS, 0..maxLight] of int: qL =
  array2d(PARTS, 0..maxLight,
    [ round(SCALE * pow(1.0 - pLight[i], l)) | i in PARTS, l in 0..maxLight ]);

array[PARTS] of var 0..maxHeavy: xH;
array[PARTS] of var 0..maxLight: xL;

array[PARTS] of var 0..SCALE: q;
array[PARTS] of var 0..SCALE: p;

array[PARTS] of var 0..SCALE: a0;
array[PARTS] of var 0..SCALE: a1;

var 0..SCALE: success;

constraint sum(i in PARTS)(xH[i]) <= maxHeavy;
constraint sum(i in PARTS)(xL[i]) <= maxLight;
constraint sum(i in PARTS)(fuelHeavy[i] * xH[i] + fuelLight[i] * xL[i]) <= fuelLimit;

constraint forall(i in PARTS)(
  q[i] = ( qH[i, xH[i]] * qL[i, xL[i]] ) div SCALE /\
  p[i] = SCALE - q[i]
);

constraint a0[1] = q[1];
constraint a1[1] = p[1];

constraint forall(i in 2..N)(
  a0[i] = (a0[i-1] * q[i]) div SCALE /\
  a1[i] = ((a1[i-1] * q[i]) div SCALE) + ((a0[i-1] * p[i]) div SCALE)
);

constraint success = SCALE - a0[N] - a1[N];

solve maximize success;

output [
  "xH=", show(xH), "\n",
  "xL=", show(xL), "\n",
  "fuel used=", show(sum(i in PARTS)(fuelHeavy[i] * xH[i] + fuelLight[i] * xL[i])), "\n",
  "success_scaled=", show(success), " / ", show(SCALE), "\n",
  "success~=", show(int2float(success) / int2float(SCALE)), "\n"
];