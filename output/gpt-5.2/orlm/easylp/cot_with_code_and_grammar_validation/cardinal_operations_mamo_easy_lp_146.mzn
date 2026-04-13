% Parameters
int: max_tanks = 20;
int: max_aircrafts = 15;

int: c1_tanks = 3;
int: c1_aircrafts = 2;
int: c1_rhs = 10;

int: c2_tanks = 4;
int: c2_aircrafts = 1;
int: c2_rhs = 30;

int: support_tank = 5;
int: support_aircraft = 7;

% Variables
var 0..max_tanks: tanks;
var 0..max_aircrafts: aircrafts;

var 0..(support_tank * max_tanks + support_aircraft * max_aircrafts): total_support;

% Constraints
constraint c1_tanks * tanks + c1_aircrafts * aircrafts >= c1_rhs;
constraint c2_tanks * tanks + c2_aircrafts * aircrafts <= c2_rhs;

constraint total_support = support_tank * tanks + support_aircraft * aircrafts;

% Objective
solve minimize total_support;