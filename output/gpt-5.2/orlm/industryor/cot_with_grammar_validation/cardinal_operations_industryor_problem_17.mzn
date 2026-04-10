% Parameters
int: weekly_hours = 110;
int: max_overtime = 10;

int: rate_m_per_hour = 1000;

int: min_curtain_m = 70000;
int: min_clothing_m = 45000;

float: profit_curtain = 2.5;
float: profit_clothing = 1.5;

% Variables
var 0..weekly_hours: regular_hours;
var 0..max_overtime: overtime_hours;
var 0..(weekly_hours + max_overtime): total_hours;

var 0..(rate_m_per_hour * (weekly_hours + max_overtime)): curtain_m;
var 0..(rate_m_per_hour * (weekly_hours + max_overtime)): clothing_m;

% Constraints
constraint total_hours = regular_hours + overtime_hours;

% p1: Fully utilize 110 regular hours
constraint regular_hours = weekly_hours;

% Production rate (1000 m/hour), split between the two fabric types
constraint curtain_m + clothing_m = rate_m_per_hour * total_hours;

% p3: Minimum sales requirements
constraint curtain_m >= min_curtain_m;
constraint clothing_m >= min_clothing_m;

% p2: Overtime limit already enforced by bounds (0..max_overtime)

% Objective
% p4: Minimize overtime as much as possible
solve minimize overtime_hours;