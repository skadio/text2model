% Parameters
int: budget = 80;                 % Maximum total investment allowed
int: min_score = 100;             % Minimum required efficiency score
int: solar_score_coeff = 3;       % Score contribution per unit Solar investment
int: wind_score_coeff  = 2;       % Score contribution per unit Wind investment

int: solar_unit_cost = 10;        % Cost per unit Solar investment
int: wind_unit_cost  = 20;        % Cost per unit Wind investment

int: solar_max = 50;              % Upper limit for Solar investment
int: wind_max  = 40;              % Upper limit for Wind investment

% Variables
var 0..solar_max: solar_invest;   % Integer units invested in Solar
var 0..wind_max:  wind_invest;    % Integer units invested in Wind
var 0..(solar_unit_cost*solar_max + wind_unit_cost*wind_max): total_cost; % Total cost to minimize

% Constraints
% Budget constraint: total investment cannot exceed the available budget
constraint solar_invest + wind_invest <= budget;

% Minimum efficiency score constraint: 3*Solar + 2*Wind must meet or exceed min_score
constraint solar_score_coeff * solar_invest + wind_score_coeff * wind_invest >= min_score;

% Climatic/regional constraint: Solar investment must be at least Wind investment
constraint solar_invest >= wind_invest;

% Total cost definition: link total_cost to the investments and unit costs
constraint total_cost = solar_unit_cost * solar_invest + wind_unit_cost * wind_invest;

% Objective
solve minimize total_cost;

% (Optional) Output: includes the minimum total cost (already an integer)
output [
  "solar_invest = ", show(solar_invest), "\n",
  "wind_invest  = ", show(wind_invest), "\n",
  "total_cost   = ", show(total_cost), "\n"
];