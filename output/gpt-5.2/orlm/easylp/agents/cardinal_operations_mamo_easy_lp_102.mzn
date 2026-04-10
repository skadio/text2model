% Parameters
int: max_total_people   = 100;  % Maximum total manpower available for both projects
int: min_people_X       = 20;   % Minimum required people for Project X
int: min_people_Y       = 10;   % Minimum required people for Project Y
int: cost_per_person_X  = 50;   % Cost per person assigned to Project X (dollars)
int: cost_per_person_Y  = 30;   % Cost per person assigned to Project Y (dollars)

% Variables
var min_people_X..max_total_people: people_X;  % Integer people assigned to Project X
var min_people_Y..max_total_people: people_Y;  % Integer people assigned to Project Y
var 0..(cost_per_person_X * max_total_people + cost_per_person_Y * max_total_people): total_cost; % Total cost (dollars)

% Constraints
% Manpower capacity constraint: total people assigned across both projects cannot exceed the limit
constraint people_X + people_Y <= max_total_people;

% Minimum staffing constraints (redundant with variable domains but kept for clarity/maintainability)
constraint people_X >= min_people_X;
constraint people_Y >= min_people_Y;

% Total cost definition constraint
constraint total_cost = cost_per_person_X * people_X + cost_per_person_Y * people_Y;

% Objective
solve minimize total_cost;