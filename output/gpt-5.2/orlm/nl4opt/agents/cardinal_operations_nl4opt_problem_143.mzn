% Parameters
int: camel_capacity = 50;          % units per camel caravan trip
int: camel_time = 12;              % hours per camel caravan trip
int: truck_capacity = 150;         % units per desert truck trip
int: truck_time = 5;               % hours per desert truck trip
int: demand = 1500;                % total units to deliver

% Upper bounds based on meeting demand with only one mode
int: max_camels = demand div camel_capacity;  % 1500/50 = 30
int: max_trucks = demand div truck_capacity;  % 1500/150 = 10

% Variables
var 0..max_camels: n_camels;       % number of camel caravan trips organized
var 0..max_trucks: n_trucks;       % number of desert truck trips organized
var 0..(max_camels * camel_time + max_trucks * truck_time): total_hours; % total hours

% Constraints
% Demand satisfaction: total delivered units must meet or exceed the required demand
constraint
  camel_capacity * n_camels + truck_capacity * n_trucks >= demand;

% Preference constraint: require more camel caravans than desert trucks
constraint
  n_camels > n_trucks;

% Total hours definition: total time is the sum of hours spent by each transportation method
constraint
  total_hours = camel_time * n_camels + truck_time * n_trucks;

% Objective
solve minimize total_hours;