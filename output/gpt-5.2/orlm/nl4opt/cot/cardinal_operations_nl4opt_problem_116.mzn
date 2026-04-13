% Parameters (with values embedded)
int: cap_tube = 50;          % cubic meters per high-pressure tube trailer trip
int: cost_tube = 500;        % dollars per tube trailer trip
int: cap_tanker = 30;        % cubic meters per liquefied hydrogen tanker trip
int: cost_tanker = 200;      % dollars per tanker trip
int: demand = 1000;          % minimum cubic meters to transport
int: budget = 3750;          % maximum dollars available

% Conservative upper bounds for trips (from budget limits)
int: max_tube = budget div cost_tube;        % 7
int: max_tanker = budget div cost_tanker;    % 18

% Variables
var 0..max_tube: x_tube;        % number of tube trailer trips
var 0..max_tanker: x_tanker;    % number of tanker trips
var 0..(max_tube + max_tanker): total_trips;

% Constraints
constraint cap_tube * x_tube + cap_tanker * x_tanker >= demand;
constraint cost_tube * x_tube + cost_tanker * x_tanker <= budget;
constraint x_tube < x_tanker;
constraint total_trips = x_tube + x_tanker;

% Objective
solve minimize total_trips;