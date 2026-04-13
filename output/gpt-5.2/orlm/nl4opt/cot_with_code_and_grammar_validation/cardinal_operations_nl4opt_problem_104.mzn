% Parameters
int: limo_capacity = 12;
int: bus_capacity = 18;
int: min_people = 400;
int: min_limo_percent = 70;

% Variables
var 0..max(0, ceil(int2float(min_people) / int2float(limo_capacity))): limo;
var 0..max(0, ceil(int2float(min_people) / int2float(bus_capacity))): bus;

% Constraints
constraint limo * limo_capacity + bus * bus_capacity >= min_people;

% at least min_limo_percent% of vehicles are limousines:
% 100*limo >= min_limo_percent*(limo+bus)
constraint 100 * limo >= min_limo_percent * (limo + bus);

% Objective
solve minimize (limo + bus);