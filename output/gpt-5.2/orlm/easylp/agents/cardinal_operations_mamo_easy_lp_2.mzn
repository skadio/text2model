% Parameters
int: minImpact = 100;                 % Minimum required impact points
int: advImpactPerDollar = 4;          % Impact points per $1 spent on advertising
int: promoImpactPerDollar = 5;        % Impact points per $1 spent on promotion
int: advCoeff = 2;                    % Coefficient used in effectiveness formula for advertising spend
int: promoCoeff = 3;                  % Coefficient used in effectiveness formula for promotion spend
int: maxAdvOverPromo = 50;            % Advertising cannot exceed promotion by more than this amount ($)

% Variables
var 0..100000: advSpend;              % Integer dollars spent on advertising
var 0..100000: promoSpend;            % Integer dollars spent on promotion
var 0..200000: totalSpend;            % Total dollars spent (advSpend + promoSpend)
var 0..1000000: impactPoints;         % Total impact points achieved

% Constraints
% Compute total spending as the sum of advertising and promotion
constraint totalSpend = advSpend + promoSpend;

% Compute total impact points from per-dollar impact contributions
constraint impactPoints = advImpactPerDollar * advSpend + promoImpactPerDollar * promoSpend;

% Enforce minimum required impact points (from per-dollar impacts)
constraint impactPoints >= minImpact;

% Balanced strategy: advertising cannot exceed promotion by more than maxAdvOverPromo
constraint advSpend - promoSpend <= maxAdvOverPromo;

% Also enforce the effectiveness expression using given coefficients (as stated in the description)
constraint advCoeff * advSpend + promoCoeff * promoSpend >= minImpact;

% Objective
solve minimize totalSpend;