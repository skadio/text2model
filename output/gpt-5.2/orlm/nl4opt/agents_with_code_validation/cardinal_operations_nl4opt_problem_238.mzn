% Parameters
int: profit_phone = 120;          % Profit per phone ($)
int: profit_laptop = 40;          % Profit per laptop ($)

int: space_phone = 1;             % Floor space per phone (sq ft)
int: space_laptop = 4;            % Floor space per laptop (sq ft)
int: total_space = 400;           % Total available floor space (sq ft)

int: cost_phone = 400;            % Store cost per phone ($)
int: cost_laptop = 100;           % Store cost per laptop ($)
int: max_budget = 6000;           % Maximum total spending ($)

int: laptop_share_percent = 80;   % At least this % of all items must be laptops

% Helpful derived constants (avoid fractional constraints)
int: laptop_share_num = laptop_share_percent;      % 80
int: laptop_share_den = 100;                       % 100

% Variables
var 0..total_space: num_phones;                      % Number of phones stocked (nonnegative)
var 0..(total_space div space_laptop): num_laptops;  % Number of laptops stocked (nonnegative)

% Safe explicit bound for profit:
% max profit per sq ft is max(120/1, 40/4)=120, so total_profit <= 120*400 = 48000
var 0..(profit_phone * total_space): total_profit;   % Total profit ($)

% Constraints

% Link total_profit to decision variables (profit accounting)
constraint
  total_profit = profit_phone * num_phones + profit_laptop * num_laptops;

% Floor space capacity constraint
constraint
  space_phone * num_phones + space_laptop * num_laptops <= total_space;

% Budget (spending) capacity constraint
constraint
  cost_phone * num_phones + cost_laptop * num_laptops <= max_budget;

% Laptop share constraint: num_laptops / (num_phones + num_laptops) >= 80/100
% Cross-multiplied to avoid fractions:
% 100*num_laptops >= 80*(num_phones + num_laptops)
constraint
  laptop_share_den * num_laptops >= laptop_share_num * (num_phones + num_laptops);

% Objective
solve maximize total_profit;

output [
  "num_phones=", show(num_phones), "\n",
  "num_laptops=", show(num_laptops), "\n",
  "total_profit=", show(total_profit), "\n"
];