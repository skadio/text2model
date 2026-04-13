% Parameters
int: max_total_people = 100;        % Maximum combined manpower across both projects
int: min_people_X = 20;             % Minimum required people on Project X
int: min_people_Y = 10;             % Minimum required people on Project Y
int: cost_per_person_X = 50;        % Cost per person assigned to Project X (dollars)
int: cost_per_person_Y = 30;        % Cost per person assigned to Project Y (dollars)

% Variables
var min_people_X..max_total_people: people_X;   % Integer people assigned to Project X
var min_people_Y..max_total_people: people_Y;   % Integer people assigned to Project Y
var 0..(max_total_people * max(cost_per_person_X, cost_per_person_Y)): total_cost; % Total cost (dollars)

% Constraints
% Manpower capacity constraint: total assigned people cannot exceed the budgeted maximum
constraint people_X + people_Y <= max_total_people;

% Total cost definition: link total_cost to the chosen allocations and per-person costs
constraint total_cost = people_X * cost_per_person_X + people_Y * cost_per_person_Y;

% Objective
solve minimize total_cost;

% (Optional) Output the optimal allocation and minimum total cost
output [
  "people_X = ", show(people_X), "\n",
  "people_Y = ", show(people_Y), "\n",
  "total_cost = $", show(total_cost), "\n"
];