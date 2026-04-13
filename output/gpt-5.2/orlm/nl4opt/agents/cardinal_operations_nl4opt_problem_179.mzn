% Parameters
int: total_budget = 600000;          % Total amount available to invest ($)
int: max_apartment_invest = 200000;  % Maximum allowed investment in apartments ($)
float: apt_return = 0.10;            % Apartment return rate
float: town_return = 0.15;           % Townhouse return rate

% Variables
var 0..max_apartment_invest: invest_apartments; % Dollars invested in apartments
var 0..total_budget: invest_townhouses;         % Dollars invested in townhouses
var float: profit;                              % Total profit ($)

% Constraints
% Budget allocation: invest all available funds across apartments and townhouses
constraint
  invest_apartments + invest_townhouses = total_budget;

% Minimum apartment investment relative to townhouse investment:
% apartments must be at least half as much as townhouses
constraint
  2 * invest_apartments >= invest_townhouses;

% Profit definition based on respective return rates
constraint
  profit = apt_return * int2float(invest_apartments)
         + town_return * int2float(invest_townhouses);

% Objective
solve maximize profit;