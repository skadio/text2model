% Engineered laminate planks and carpets production planning (weekly)

% Parameters (embedded data)
int: demand_laminate_min = 15000;
int: demand_carpet_min   = 5000;
int: total_shipping_min  = 50000;

int: laminate_max = 40000;
int: carpet_max   = 20000;

% Use integer profits in cents to keep the model purely integer/linear
int: profit_laminate_cents = 210; % $2.10 per sq ft
int: profit_carpet_cents   = 330; % $3.30 per sq ft

% Decision variables (square feet produced)
var demand_laminate_min..laminate_max: x_laminate;
var demand_carpet_min..carpet_max:     x_carpet;

% Constraints
constraint x_laminate + x_carpet >= total_shipping_min;

% Objective: maximize total profit (in cents)
var int: total_profit_cents = profit_laminate_cents * x_laminate
                           + profit_carpet_cents   * x_carpet;

solve maximize total_profit_cents;

output [
  "laminate_sqft=", show(x_laminate), "\n",
  "carpet_sqft=", show(x_carpet), "\n",
  "total_sqft=", show(x_laminate + x_carpet), "\n",
  "profit_dollars=", show(total_profit_cents div 100), ".", show(total_profit_cents mod 100), "\n"
];