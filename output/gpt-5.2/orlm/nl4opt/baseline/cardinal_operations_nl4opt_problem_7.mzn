% Elm Furniture production optimization (all data embedded)

% Data
int: profit_chair = 43;
int: profit_dresser = 52;

float: stain_available = 17.0;
int: wood_available = 11;

float: stain_per_chair = 1.4;
int: wood_per_chair = 2;

float: stain_per_dresser = 1.1;
int: wood_per_dresser = 3;

% Decision variables: number of items to produce (nonnegative integers)
var 0..1000: chairs;
var 0..1000: dressers;

% Constraints
constraint stain_per_chair * chairs + stain_per_dresser * dressers <= stain_available;
constraint wood_per_chair * chairs + wood_per_dresser * dressers <= wood_available;

% Objective: maximize profit
var int: total_profit = profit_chair * chairs + profit_dresser * dressers;
solve maximize total_profit;

output [
  "chairs=", show(chairs), "\n",
  "dressers=", show(dressers), "\n",
  "total_profit=", show(total_profit), "\n"
];