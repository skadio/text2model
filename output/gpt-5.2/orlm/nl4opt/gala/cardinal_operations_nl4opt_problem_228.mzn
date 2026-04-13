% Investment optimization (linear integer model)

int: budget = 3000;

% Decision variables: dollars invested in each company
var 0..budget: clothing;
var 0..budget: tech;

% Constraints
constraint clothing + tech = budget;
constraint clothing >= 4 * tech;
constraint tech <= 500;

% Profit in cents to avoid floating point:
% clothing earns 7% => 7 cents per dollar
% tech earns 10%    => 10 cents per dollar
var 0..100000000: profit_cents = 7 * clothing + 10 * tech;

solve maximize profit_cents;

output [
  "Clothing investment = $", show(clothing), "\n",
  "Tech investment     = $", show(tech), "\n",
  "Profit              = $", show(profit_cents div 100), ".", 
                         if (profit_cents mod 100) < 10 then "0" else "" endif,
                         show(profit_cents mod 100), "\n"
];