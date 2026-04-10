% Parameters
int: total_budget = 600000;          % Total amount available to invest ($)
int: max_apartments = 200000;        % Maximum allowed investment in apartments ($)
float: apt_return = 0.10;            % Return rate for apartments
float: th_return  = 0.15;            % Return rate for townhouses

% Variables
var 0..total_budget: invest_apartments;   % Dollars invested in apartments
var 0..total_budget: invest_townhouses;   % Dollars invested in townhouses
var float: profit;                        % Total profit ($)

% Constraints
% Budget allocation: all available money is invested between the two options
constraint
  invest_apartments + invest_townhouses = total_budget;

% Apartments investment upper bound
constraint
  invest_apartments <= max_apartments;

% Minimum apartments relative to townhouses: apartments >= 1/2 of townhouses
constraint
  2 * invest_apartments >= invest_townhouses;

% Profit definition based on returns (cast ints to float)
constraint
  profit = apt_return * int2float(invest_apartments)
         + th_return  * int2float(invest_townhouses);

% Objective
solve maximize profit;