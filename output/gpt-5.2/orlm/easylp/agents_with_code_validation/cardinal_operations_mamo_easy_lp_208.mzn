% Parameters
int: total_investment_limit = 1000;        % Maximum total investment units across X, Y, Z
int: min_staff_investment = 200;           % Minimum investment units for medical staff (X)
int: min_facility_investment = 150;        % Minimum investment units for facilities (Y)
int: min_tech_investment = 100;            % Minimum investment units for technology (Z)

int: cost_per_staff_unit = 10;             % Cost per unit invested in staff
int: cost_per_facility_unit = 15;          % Cost per unit invested in facilities
int: cost_per_tech_unit = 20;              % Cost per unit invested in technology


% Variables
var min_staff_investment..total_investment_limit: staff_investment;          % X
var min_facility_investment..total_investment_limit: facility_investment;    % Y
var min_tech_investment..total_investment_limit: tech_investment;            % Z

% Total cost (integer dollars); upper bound is a safe linear bound
var 0..(cost_per_staff_unit * total_investment_limit
      + cost_per_facility_unit * total_investment_limit
      + cost_per_tech_unit * total_investment_limit): total_cost;


% Constraints
% Budget constraint: total investment units across all areas cannot exceed the limit
constraint
  staff_investment + facility_investment + tech_investment
  <= total_investment_limit;

% Minimum investment requirements (already enforced by variable domains, restated for clarity)
constraint staff_investment >= min_staff_investment;
constraint facility_investment >= min_facility_investment;
constraint tech_investment >= min_tech_investment;

% Total cost definition: linear cost based on per-unit costs
constraint
  total_cost =
      cost_per_staff_unit * staff_investment
    + cost_per_facility_unit * facility_investment
    + cost_per_tech_unit * tech_investment;


% Objective
solve minimize total_cost;