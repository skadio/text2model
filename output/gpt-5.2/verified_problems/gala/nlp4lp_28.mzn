include "globals.mzn";

/*************************************************************
  Dynamic multi-industry production / investment planning

  Indices
    I = industries (also equal to K in the given data format)
    T = years 0..K (year 0 is current; decisions for years 1..K)

  Data (provided in .dzn):
    int: K;                                  % planning horizon length; also #industries
    array[1..K, 1..K] of float: InputOne;    % input from industry i per unit of output of industry j (type 1)
    array[1..K] of float: ManpowerOne;       % manpower per unit output of industry j (type 1)
    array[1..K, 1..K] of float: InputTwo;    % input from industry i per unit of output of industry j (type 2)
    array[1..K] of float: ManpowerTwo;       % manpower per unit output of industry j (type 2)
    array[1..K] of float: Stock;             % initial stock at start of year 1 (end of year 0)
    array[1..K] of float: Capacity;          % initial production capacity in year 0 (usable in year 1)
    float: ManpowerLimit;                    % yearly manpower limit

  Model interpretation:
    - Produce x[t,j] in year t (t=1..K).
    - Goods produced in year t can be:
        * consumed as intermediate inputs for year t+1 production
        * invested as capacity-increase inputs for year t+2 (permanent)
        * kept as end-of-year stock
    - Capacity constraint binds production each year.
    - Stocks carry over year to year.
    - Objective: maximize total production in last two years (years K-1 and K).
*************************************************************/

int: I = K;
set of int: IND = 1..I;
set of int: Y = 1..K;

/* Scaling to keep a pure linear MIP with integer variables.
   All flows are represented as integers in "pounds * SCALE". */
int: SCALE = 1000;

array[IND,IND] of int: a =
  array2d(IND, IND, [ round(InputOne[i,j] * SCALE) | i in IND, j in IND ]);
array[IND,IND] of int: b =
  array2d(IND, IND, [ round(InputTwo[i,j] * SCALE) | i in IND, j in IND ]);

array[IND] of int: mp =
  [ round((ManpowerOne[j] + ManpowerTwo[j]) * SCALE) | j in IND ];

array[IND] of int: stock0 = [ round(Stock[i] * SCALE) | i in IND ];
array[IND] of int: cap0   = [ round(Capacity[i] * SCALE) | i in IND ];

int: mpLimit = round(ManpowerLimit * SCALE);

/* Decision variables (all scaled integers) */
array[Y,IND] of var 0..int_max: x;                 % production
array[Y,IND] of var 0..int_max: s;                 % end-of-year stock

/* Intermediate inputs used: prod in year t+1 uses inputs from year t.
   cons[t,i] = amount of good i from year t used as intermediate in year t+1. */
array[Y,IND] of var 0..int_max: cons;

/* Investment inputs: inv[t,i] = amount of good i from year t used for capacity build effective in t+2. */
array[Y,IND] of var 0..int_max: inv;

/* Capacity available each year (scaled). cap[t,i] is capacity in year t (usable for production x[t,i]). */
array[0..K,IND] of var 0..int_max: cap;

/* Manpower used each year */
array[Y] of var 0..int_max: mpUsed;

/* Initialize capacity in year 0 */
constraint forall(i in IND)( cap[0,i] = cap0[i] );

/* Capacity evolution:
   Investment inputs in year (t-2) create permanent capacity for year t onward.
   Here, we model a simple rule:
      1 unit of investment good i in year (t-2) adds 1 unit of capacity to industry i in year t.
   (i.e., inv[t-2,i] adds to cap[t,i].) */
constraint forall(t in 1..K, i in IND)(
  cap[t,i] = cap[t-1,i] + ( if t >= 2 then inv[t-1,i] else 0 endif )
);

/* Production limited by capacity */
constraint forall(t in Y, i in IND)(
  x[t,i] <= cap[t,i]
);

/* Intermediate input requirements:
   cons[t,i] must cover inputs needed for production in year t+1.
   For last year K, no year K+1 production => cons[K,i] = 0. */
constraint forall(i in IND)(
  cons[K,i] = 0
);
constraint forall(t in 1..K-1, i in IND)(
  cons[t,i] = sum(j in IND)( (a[i,j] + b[i,j]) * x[t+1,j] ) div SCALE
);

/* Stock balance each year:
   available at year t = (stock at start of year t) + production x[t]
   used in year t = cons[t] (for t+1) + inv[t] + ending stock s[t]
   Stock at start of year 1 is stock0; for t>1 it's s[t-1]. */
constraint forall(i in IND)(
  stock0[i] + x[1,i] = cons[1,i] + inv[1,i] + s[1,i]
);
constraint forall(t in 2..K, i in IND)(
  s[t-1,i] + x[t,i] = cons[t,i] + inv[t,i] + s[t,i]
);

/* Manpower constraints per year */
constraint forall(t in Y)(
  mpUsed[t] = sum(j in IND)( mp[j] * x[t,j] ) div SCALE
);
constraint forall(t in Y)(
  mpUsed[t] <= mpLimit
);

/* Objective: maximize total production in the last two years */
var 0..int_max: obj =
  (if K >= 2 then sum(i in IND)(x[K,i] + x[K-1,i]) else sum(i in IND)(x[K,i]) endif);

solve maximize obj;

/* Output in original (unscaled) units */
function string: show_float_val(var int: v) =
  show(v) ++ " (scaled), " ++ show( (float(v)) / float(SCALE) );

output [
  "Objective (last two years total production) = ", show_float_val(obj), "\n\n",
  "Production x[t,i]:\n",
  concat([ "Year " ++ show(t) ++ ": " ++
           show([ (float(x[t,i]))/float(SCALE) | i in IND ]) ++ "\n"
         | t in Y ]),
  "\nEnd stocks s[t,i]:\n",
  concat([ "Year " ++ show(t) ++ ": " ++
           show([ (float(s[t,i]))/float(SCALE) | i in IND ]) ++ "\n"
         | t in Y ]),
  "\nManpower used per year:\n",
  concat([ "Year " ++ show(t) ++ ": " ++ show((float(mpUsed[t]))/float(SCALE)) ++ "\n"
         | t in Y ])
];