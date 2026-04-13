% Parameters (with values embedded)
int: n = 2;
set of int: P = 1..n;

int: MEATIES = 1;
int: YUMMIES = 2;

array[P] of float: price = [2.80, 2.00];                 % $/package
array[P] of float: cereal_req = [2.0, 3.0];              % lb/package
array[P] of float: meat_req = [3.0, 1.5];                % lb/package
array[P] of float: blend_pack_cost = [0.25, 0.20];       % $/package

float: cereal_unit_cost = 0.20;                          % $/lb
float: meat_unit_cost = 0.50;                            % $/lb

float: cereal_avail = 400000.0;                          % lb/month (max purchasable)
float: meat_avail = 300000.0;                            % lb/month (max purchasable)

int: meaties_capacity = 90000;                           % packages/month

% Variables
array[P] of var int: x;                                  % packages produced (and sold)
var float: cereal_used;
var float: meat_used;
var float: profit;

% Constraints
constraint forall(p in P)(x[p] >= 0);

constraint x[MEATIES] <= meaties_capacity;

constraint cereal_used = sum(p in P)(cereal_req[p] * int2float(x[p]));
constraint meat_used   = sum(p in P)(meat_req[p]   * int2float(x[p]));

constraint cereal_used <= cereal_avail;
constraint meat_used   <= meat_avail;

constraint profit =
    sum(p in P)(price[p] * int2float(x[p]))
  - cereal_unit_cost * cereal_used
  - meat_unit_cost * meat_used
  - sum(p in P)(blend_pack_cost[p] * int2float(x[p]));

% Objective
solve maximize profit;