% Parameters
int: total_budget = 600000;
int: max_apartments = 200000;
int: apt_rate_num = 10;   % percent
int: town_rate_num = 15;  % percent

% Variables
var 0..max_apartments: A;                 % money invested in apartments
var 0..total_budget: T;                   % money invested in townhouses
var 0..(apt_rate_num*max_apartments + town_rate_num*total_budget): profit_scaled; % profit * 100

% Constraints
constraint A + T = total_budget;
constraint A <= max_apartments;
constraint 2 * A >= T;                    % A >= 0.5 * T
constraint profit_scaled = apt_rate_num * A + town_rate_num * T;

% Objective
solve maximize profit_scaled;