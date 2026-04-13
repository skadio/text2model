% Parameters
int: demand = 1500;                 % total units of goods to deliver

int: camel_capacity = 50;           % units per camel caravan trip
int: camel_time = 12;               % hours per camel caravan trip

int: truck_capacity = 150;          % units per desert truck trip
int: truck_time = 5;                % hours per desert truck trip

% Upper bounds derived from meeting demand using only that mode (ceil division)
int: max_camels = (demand + camel_capacity - 1) div camel_capacity;
int: max_trucks = (demand + truck_capacity - 1) div truck_capacity;

% Variables
var 0..max_camels: n_camels;        % number of camel caravan trips organized
var 0..max_trucks: n_trucks;        % number of desert truck trips organized

% Total hours upper bound based on max possible hours using the computed max trips
var 0..(camel_time * max_camels + truck_time * max_trucks): total_hours;

% Constraints
% Demand satisfaction: total delivered goods must meet or exceed the required demand
constraint camel_capacity * n_camels + truck_capacity * n_trucks >= demand;

% Preference constraint: use strictly more camel caravans than desert trucks
constraint n_camels > n_trucks;

% Linking constraint: total hours equals the sum of hours spent by each transport method
constraint total_hours = camel_time * n_camels + truck_time * n_trucks;

% Objective
solve minimize total_hours;