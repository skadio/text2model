% Parameters
int: regular_hours = 110;
int: max_overtime = 10;

int: rate_m_per_hour = 1000;

int: min_curtain_m = 70000;
int: min_clothing_m = 45000;

float: profit_curtain_per_m = 2.5;
float: profit_clothing_per_m = 1.5;

% Variables
var 0..regular_hours + max_overtime: hours_total;
var 0..max_overtime: overtime_hours;

var 0..regular_hours + max_overtime: hours_curtain;
var 0..regular_hours + max_overtime: hours_clothing;

var 0..(regular_hours + max_overtime) * rate_m_per_hour: curtain_m;
var 0..(regular_hours + max_overtime) * rate_m_per_hour: clothing_m;

var float: profit;

% Constraints
constraint hours_total = regular_hours + overtime_hours;             % p1, p2 structure
constraint overtime_hours <= max_overtime;                           % p2

constraint hours_curtain + hours_clothing = hours_total;             % time allocation

constraint curtain_m = rate_m_per_hour * hours_curtain;
constraint clothing_m = rate_m_per_hour * hours_clothing;

constraint curtain_m >= min_curtain_m;                               % p3
constraint clothing_m >= min_clothing_m;                             % p3

constraint profit = profit_curtain_per_m * curtain_m
                  + profit_clothing_per_m * clothing_m;

% Objective
solve minimize overtime_hours;                                       % p4