% Supply chain resource allocation problem (all data embedded)

int: MAX_TOTAL = 100;
int: MIN_BALANCE = 50;      % 2*X + Y >= 50
int: MAX_DIFF = 30;         % |X - Y| <= 30

int: COST_X = 2;
int: COST_Y = 3;

var 0..MAX_TOTAL: X;        % sourcing units
var 0..MAX_TOTAL: Y;        % distribution units

constraint X + Y <= MAX_TOTAL;
constraint 2 * X + Y >= MIN_BALANCE;
constraint abs(X - Y) <= MAX_DIFF;

var int: total_cost = COST_X * X + COST_Y * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];