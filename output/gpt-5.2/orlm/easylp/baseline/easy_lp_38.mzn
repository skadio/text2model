% Investment allocation problem (all data embedded)

int: BUDGET = 100000;

int: MIN_X = 10000;
int: MIN_Y = 5000;

int: RISK_LHS_X = 3;
int: RISK_LHS_Y = -1;
int: RISK_MIN = 20000;

int: COST_X = 5000;
int: COST_Y = 4000;

% Decision variables (whole-dollar investments)
var 0..BUDGET: x;
var 0..BUDGET: y;

constraint x + y <= BUDGET;
constraint x >= MIN_X;
constraint y >= MIN_Y;
constraint RISK_LHS_X * x + RISK_LHS_Y * y >= RISK_MIN;

var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

% Round total cost to nearest hundred dollars
function int: round_nearest_100(int: v) =
  if v >= 0 then
    100 * ((v + 50) div 100)
  else
    -100 * (((-v) + 50) div 100)
  endif;

output [
  "x = $", show(x), "\n",
  "y = $", show(y), "\n",
  "total_cost = $", show(total_cost), "\n",
  "total_cost_rounded_nearest_100 = $", show(round_nearest_100(total_cost)), "\n"
];