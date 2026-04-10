% Parameters
% Profits per unit
float: profit_chair   = 43.0;
float: profit_dresser = 52.0;

% Weekly resource availability
float: stain_available = 17.0;  % gallons
int:   oak_available   = 11;    % lengths

% Resource requirements per unit
float: stain_per_chair   = 1.4;
int:   oak_per_chair     = 2;
float: stain_per_dresser = 1.1;
int:   oak_per_dresser   = 3;


% Variables
var 0..oak_available: chairs;    % number of chairs produced (nonnegative integer)
var 0..oak_available: dressers;  % number of dressers produced (nonnegative integer)

var float: total_profit; % objective value (total weekly profit)


% Constraints
% Stain availability constraint (total stain used cannot exceed weekly availability)
constraint
  stain_per_chair * int2float(chairs) +
  stain_per_dresser * int2float(dressers)
  <= stain_available;

% Oak availability constraint (total oak used cannot exceed weekly availability)
constraint
  oak_per_chair * chairs +
  oak_per_dresser * dressers
  <= oak_available;

% Define total profit from production quantities
constraint
  total_profit =
    profit_chair * int2float(chairs) +
    profit_dresser * int2float(dressers);


% Objective
solve maximize total_profit;