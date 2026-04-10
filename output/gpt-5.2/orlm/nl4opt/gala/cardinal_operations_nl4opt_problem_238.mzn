% Inventory optimization (LP as an integer linear program)
% Decision variables: number of phones and laptops to stock

int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;     % sq ft
int: space_laptop = 4;    % sq ft
int: total_space = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget = 6000;

% At least 80% of all items are laptops:
% laptops >= 0.8*(phones + laptops)  <=>  5*laptops >= 4*(phones + laptops)  <=>  laptops >= 4*phones
int: laptop_ratio_num = 4;  % laptops >= 4*phones

% Upper bounds derived from constraints (for tighter search)
int: max_phones = min(total_space div space_phone, budget div cost_phone);    % min(400, 15) = 15
int: max_laptops = min(total_space div space_laptop, budget div cost_laptop);% min(100, 60) = 60

var 0..max_phones: phones;
var 0..max_laptops: laptops;

% Constraints
constraint space_phone * phones + space_laptop * laptops <= total_space;
constraint cost_phone * phones + cost_laptop * laptops <= budget;
constraint laptops >= laptop_ratio_num * phones;

% Objective: maximize profit
var int: total_profit = profit_phone * phones + profit_laptop * laptops;

solve maximize total_profit;

output [
  "phones = ", show(phones), "\n",
  "laptops = ", show(laptops), "\n",
  "profit = ", show(total_profit), "\n",
  "space_used = ", show(space_phone * phones + space_laptop * laptops), " / ", show(total_space), "\n",
  "budget_used = ", show(cost_phone * phones + cost_laptop * laptops), " / ", show(budget), "\n"
];