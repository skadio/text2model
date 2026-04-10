% Parameters
int: max_hours_per_year = 3000;          % Maximum available hours per machine per year

float: mixer_hours_bread  = 1.0;         % Mixer hours needed per loaf of bread
float: oven_hours_bread   = 3.0;         % Oven hours needed per loaf of bread
float: mixer_hours_cookie = 0.5;         % Mixer hours needed per batch of cookies
float: oven_hours_cookie  = 1.0;         % Oven hours needed per batch of cookies

int: profit_bread  = 5;                  % Profit per loaf of bread ($)
int: profit_cookie = 3;                  % Profit per batch of cookies ($)

% Variables
var int: bread_loaves;                   % Number of loaves of bread produced
var int: cookie_batches;                 % Number of cookie batches produced
var int: total_profit;                   % Total profit ($)

% Constraints

% Non-negativity / integrality of production decisions
constraint bread_loaves >= 0;
constraint cookie_batches >= 0;

% Stand mixer capacity (hours per year)
constraint
  mixer_hours_bread * int2float(bread_loaves) +
  mixer_hours_cookie * int2float(cookie_batches)
  <= int2float(max_hours_per_year);

% Oven capacity (hours per year)
constraint
  oven_hours_bread * int2float(bread_loaves) +
  oven_hours_cookie * int2float(cookie_batches)
  <= int2float(max_hours_per_year);

% Define total profit from production quantities
constraint
  total_profit = profit_bread * bread_loaves + profit_cookie * cookie_batches;

% Objective
solve maximize total_profit;