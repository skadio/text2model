% Parameters
% Budget and scoring requirements
int: max_total_investment = 80;              % Total investment limit (Solar + Wind)
int: min_score = 100;                       % Minimum required score

% Score coefficients
int: score_per_solar = 3;                   % Score contribution per unit Solar investment
int: score_per_wind  = 2;                   % Score contribution per unit Wind investment

% Cost coefficients
int: cost_per_solar = 10;                   % Cost per unit Solar investment
int: cost_per_wind  = 20;                   % Cost per unit Wind investment

% Per-project upper bounds
int: max_solar = 50;                        % Max Solar investment
int: max_wind  = 40;                        % Max Wind investment


% Variables
var 0..max_solar: solar_investment;         % Integer units invested in Solar
var 0..max_wind:  wind_investment;          % Integer units invested in Wind

var 0..(cost_per_solar*max_solar + cost_per_wind*max_wind): total_cost;  % Total cost to minimize


% Constraints
% Link total_cost to decision variables (cost accounting)
constraint
  total_cost = cost_per_solar * solar_investment + cost_per_wind * wind_investment;

% Budget constraint: total investment cannot exceed the available budget
constraint
  solar_investment + wind_investment <= max_total_investment;

% Minimum score/efficiency requirement
constraint
  score_per_solar * solar_investment + score_per_wind * wind_investment >= min_score;

% Climatic/priority condition: Solar investment must be at least Wind investment
constraint
  solar_investment >= wind_investment;


% Objective
solve minimize total_cost;