% Financial planning: allocate between Stocks and Bonds (integer units)
% Data embedded in model

int: total_investment = 20000;        % dollars
int: stock_cost = 10;                % dollars per unit
int: bond_cost  = 5;                 % dollars per unit

int: min_diversification_value = 10000; % constraint: 3*stocks$ + 2*bonds$ >= 10000
int: max_difference = 5000;            % dollars: |stocks$ - bonds$| <= 5000

% Decision variables: number of units (whole numbers)
var 0..total_investment div stock_cost: x; % stock units
var 0..total_investment div bond_cost : y; % bond units

% Dollar amounts invested in each option
var 0..total_investment: S = stock_cost * x;
var 0..total_investment: B = bond_cost  * y;

% Use all investment
constraint S + B = total_investment;

% Diversification condition
constraint 3*S + 2*B >= min_diversification_value;

% Difference condition
constraint abs(S - B) <= max_difference;

% Objective: minimize total cost (which equals total invested dollars)
var int: total_cost = S + B;
solve minimize total_cost;

output [
  "stock_units=", show(x), "\n",
  "bond_units=", show(y), "\n",
  "stocks_$=", show(S), "\n",
  "bonds_$=", show(B), "\n",
  "minimum_total_cost_$=", show(total_cost), "\n"
];