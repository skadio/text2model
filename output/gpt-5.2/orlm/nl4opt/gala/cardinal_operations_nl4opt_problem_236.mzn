% Sandwich store planning (embed all data here)

% Data
int: prod_dinein = 100;
int: emp_dinein  = 8;

int: prod_truck  = 50;
int: emp_truck   = 3;

int: min_sandwiches = 500;
int: max_employees  = 35;

% Decision variables: number of each store type
var 0..ceil(max_employees div emp_dinein): dinein;
var 0..ceil(max_employees div emp_truck):  truck;

% Constraints
constraint prod_dinein * dinein + prod_truck * truck >= min_sandwiches;
constraint emp_dinein * dinein + emp_truck * truck <= max_employees;

% Objective: minimize total number of stores
var 0..1000: total_stores = dinein + truck;
solve minimize total_stores;

output [
  "dinein = ", show(dinein), "\n",
  "truck = ", show(truck), "\n",
  "total_stores = ", show(total_stores), "\n",
  "sandwiches = ", show(prod_dinein*dinein + prod_truck*truck), "\n",
  "employees = ", show(emp_dinein*dinein + emp_truck*truck), "\n"
];