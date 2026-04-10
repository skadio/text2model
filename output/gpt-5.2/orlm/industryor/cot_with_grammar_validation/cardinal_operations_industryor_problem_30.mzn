int: P = 3;
set of int: PRODUCTS = 1..P;

int: A = 2;
set of int: AEQ = 1..A;

int: B = 3;
set of int: BEQ = 1..B;

array[AEQ, PRODUCTS] of int: tA = array2d(AEQ, PRODUCTS,
  [ 5, 10,  0,
    7,  9, 12 ]
);

array[BEQ, PRODUCTS] of int: tB = array2d(BEQ, PRODUCTS,
  [ 6,  8,  0,
    4,  0, 11,
    7,  0,  0 ]
);

array[AEQ] of int: availA = [6000, 10000];
array[BEQ] of int: availB = [4000, 7000, 4000];

array[AEQ] of int: costA_cents_per_hour = [5, 3];
array[BEQ] of int: costB_cents_per_hour = [6, 11, 5];

array[PRODUCTS] of int: raw_cents = [25, 35, 50];
array[PRODUCTS] of int: price_cents = [125, 200, 280];

int: maxMinA = max([availA[i] * 60 | i in AEQ]);
int: maxMinB = max([availB[j] * 60 | j in BEQ]);
int: minPosTA = min([tA[i,p] | i in AEQ, p in PRODUCTS where tA[i,p] > 0]);
int: minPosTB = min([tB[j,p] | j in BEQ, p in PRODUCTS where tB[j,p] > 0]);

int: maxUnitsA = maxMinA div minPosTA;
int: maxUnitsB = maxMinB div minPosTB;
int: maxUnits = max(maxUnitsA, maxUnitsB);

array[AEQ, PRODUCTS] of var 0..maxUnits: xA;
array[BEQ, PRODUCTS] of var 0..maxUnits: xB;
array[PRODUCTS] of var 0..maxUnits: y;

var int: profit_cents;

constraint
  forall(i in AEQ, p in PRODUCTS where tA[i,p] = 0) (xA[i,p] = 0);

constraint
  forall(j in BEQ, p in PRODUCTS where tB[j,p] = 0) (xB[j,p] = 0);

constraint
  forall(p in PRODUCTS) (sum(i in AEQ)(xA[i,p]) = y[p]);

constraint
  forall(p in PRODUCTS) (sum(j in BEQ)(xB[j,p]) = y[p]);

constraint
  forall(i in AEQ) (
    sum(p in PRODUCTS)(tA[i,p] * xA[i,p]) <= availA[i] * 60
  );

constraint
  forall(j in BEQ) (
    sum(p in PRODUCTS)(tB[j,p] * xB[j,p]) <= availB[j] * 60
  );

constraint
  profit_cents =
    sum(p in PRODUCTS)(price_cents[p] * y[p])
    - sum(p in PRODUCTS)(raw_cents[p] * y[p])
    - sum(i in AEQ)((sum(p in PRODUCTS)(tA[i,p] * xA[i,p]) * costA_cents_per_hour[i]) div 60)
    - sum(j in BEQ)((sum(p in PRODUCTS)(tB[j,p] * xB[j,p]) * costB_cents_per_hour[j]) div 60);

solve maximize profit_cents;

output [
  "profit_cents=", show(profit_cents), "\n",
  "y=", show(y), "\n",
  "xA=", show(xA), "\n",
  "xB=", show(xB), "\n"
];