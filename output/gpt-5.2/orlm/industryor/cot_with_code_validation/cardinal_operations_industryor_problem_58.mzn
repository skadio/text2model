% Candy production profit maximization
% Use finite-domain integers (scaled) to avoid Float::linear limits in Gecode.

int: P = 3; % products: 1=A, 2=B, 3=C
int: R = 3; % raw materials: 1=A, 2=B, 3=C

set of int: Products = 1..P;
set of int: Raw = 1..R;

% Scale: 1 unit = 1 kg (keep integer kg). Money in cents to keep integer arithmetic.
int: MONEY = 100;

array[Raw] of int: raw_cost_c = [200, 150, 100];        % Yuan/kg -> cents/kg
array[Raw] of int: raw_limit = [2000, 2500, 1200];      % kg/month

array[Products] of int: proc_fee_c   = [50, 40, 30];    % cents/kg product
array[Products] of int: sell_price_c = [340, 285, 225]; % cents/kg product

% Variables
array[Products, Raw] of var 0..max(raw_limit): x;   % kg of raw r used in product p
array[Products] of var 0..sum(raw_limit): y;        % kg produced of product p

% Product totals
constraint forall(p in Products)(
  y[p] = sum(r in Raw)(x[p,r])
);

% Raw material availability
constraint forall(r in Raw)(
  sum(p in Products)(x[p,r]) <= raw_limit[r]
);

% Composition constraints
% Product A (p=1): A >= 60%, B >= 15%
constraint 100 * x[1,1] >= 60 * y[1];
constraint 100 * x[1,2] >= 15 * y[1];

% Product C (p=3): A <= 20%, B <= 60%, C <= 50%
constraint 100 * x[3,1] <= 20 * y[3];
constraint 100 * x[3,2] <= 60 * y[3];
constraint 100 * x[3,3] <= 50 * y[3];

% Objective: maximize profit (in cents)
var int: profit_c =
  sum(p in Products)(
    (sell_price_c[p] - proc_fee_c[p]) * y[p]
    - sum(r in Raw)(raw_cost_c[r] * x[p,r])
  );

solve maximize profit_c;

output [
  "y (kg) A,B,C = ", show([y[p] | p in Products]), "\n",
  "profit (Yuan) = ", show(profit_c div MONEY), ".", show((profit_c mod MONEY) div 10), show(profit_c mod 10), "\n",
  "x (kg) by product (rows A,B,C) and raw (cols A,B,C):\n",
  concat([ concat([ show(x[p,r]) ++ (if r<R then " " else "\n" endif) | r in Raw]) | p in Products ])
];