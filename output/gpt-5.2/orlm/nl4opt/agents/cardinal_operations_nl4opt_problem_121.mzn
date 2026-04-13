% Parameters
int: budget = 500;                 % Maximum monthly spend ($)
float: cost_carrot = 0.30;         % Cost to buy one carrot ($)
float: cost_cucumber = 0.50;       % Cost to buy one cucumber ($)
float: profit_carrot = 0.75;       % Profit per carrot sold ($)
float: profit_cucumber = 0.80;     % Profit per cucumber sold ($)

int: min_carrots = 300;            % Minimum carrots sold
int: max_carrots = 500;            % Maximum carrots sold

% Ratio: cucumbers <= carrots / 3  =>  3*cucumbers <= carrots
int: ratio_multiplier = 3;

% Variables
var min_carrots..max_carrots: carrots_sold;  % Number of carrots sold
var 0..max_carrots: cucumbers_sold;          % Number of cucumbers sold (bounded using max_carrots)

var float: total_profit;                     % Total profit ($)

% Constraints

% Budget constraint: total purchasing cost must not exceed the monthly budget
constraint
  cost_carrot * int2float(carrots_sold) + cost_cucumber * int2float(cucumbers_sold) <= int2float(budget);

% Sales ratio constraint: cucumbers sold are at most one third of carrots sold
constraint
  ratio_multiplier * cucumbers_sold <= carrots_sold;

% Profit definition: link total_profit to decision variables
constraint
  total_profit =
    profit_carrot * int2float(carrots_sold) +
    profit_cucumber * int2float(cucumbers_sold);

% Objective
solve maximize total_profit;