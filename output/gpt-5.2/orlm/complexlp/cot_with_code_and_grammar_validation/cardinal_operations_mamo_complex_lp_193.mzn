% Product mix with overtime (all data embedded)

int: nProd = 2;
set of int: P = 1..nProd;

% Scale hours to 24ths of an hour (LCM of 4, 8, 3)
int: H = 24;

array[P] of int: assembly_u = [6, 8];   % (1/4)*24=6, (1/3)*24=8
array[P] of int: testing_u  = [3, 8];   % (1/8)*24=3, (1/3)*24=8

int: assembly_regular_max_u = 90 * H;   % 2160
int: testing_max_u          = 80 * H;   % 1920
int: overtime_max_u         = 50 * H;   % 1200

% Money in cents
array[P] of int: value_c = [900, 800];
array[P] of int: raw_c   = [120, 90];

% Overtime cost: $9/hour = 900 cents/hour = 900/24 cents per scaled unit
% Total overtime cost in cents = (900 * ot_u) div 24  (exact, since ot_u multiple of 1)
int: overtime_c_per_hour = 900;

% Decision variables
array[P] of var 0..10000: x;          % units produced
var 0..overtime_max_u: ot_u;          % overtime assembly used (in 1/24 hours)

var int: profit_c;

% Constraints
constraint sum(p in P)(assembly_u[p] * x[p]) <= assembly_regular_max_u + ot_u;
constraint sum(p in P)(testing_u[p]  * x[p]) <= testing_max_u;

% Profit (cents)
constraint profit_c =
    sum(p in P)((value_c[p] - raw_c[p]) * x[p])
  - (overtime_c_per_hour * ot_u) div H;

solve maximize profit_c;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " ot_hours=", show(ot_u / H), "\n",
  "profit_dollars_rounded=", show( (profit_c + 50) div 100 ), "\n"
];