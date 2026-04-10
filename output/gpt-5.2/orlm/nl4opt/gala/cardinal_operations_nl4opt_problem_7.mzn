% Elm Furniture production planning (maximize profit)
% Data embedded as required.

% Profit per unit
int: profit_chair = 43;
int: profit_dresser = 52;

% Resource availability
float: stain_available = 17.0;   % gallons
int: oak_available = 11;         % lengths

% Resource use per unit
float: stain_per_chair = 1.4;
int:   oak_per_chair   = 2;

float: stain_per_dresser = 1.1;
int:   oak_per_dresser   = 3;

% Upper bounds derived from resources (safe tight bounds)
int: max_chairs   = min(floor(stain_available / stain_per_chair), oak_available div oak_per_chair);
int: max_dressers = min(floor(stain_available / stain_per_dresser), oak_available div oak_per_dresser);

% Decision variables: number of each product (integers)
var 0..max_chairs: chairs;
var 0..max_dressers: dressers;

% Resource constraints
constraint stain_per_chair * chairs + stain_per_dresser * dressers <= stain_available + 1e-9;
constraint oak_per_chair * chairs + oak_per_dresser * dressers <= oak_available;

% Objective: maximize profit
var int: total_profit = profit_chair * chairs + profit_dresser * dressers;
solve maximize total_profit;

output [
  "chairs=", show(chairs), "\n",
  "dressers=", show(dressers), "\n",
  "total_profit=", show(total_profit), "\n",
  "stain_used=", show(stain_per_chair * chairs + stain_per_dresser * dressers), "\n",
  "oak_used=", show(oak_per_chair * chairs + oak_per_dresser * dressers), "\n"
];