% Parameters
int: staff_hours = 6;
int: staff_pay = 300;
int: sub_hours = 3;
int: sub_pay = 100;

int: required_hours = 1000;
int: budget = 40000;

% Variables
var 0..(budget div staff_pay): staff;
var 0..(budget div sub_pay): subs;

% Constraints
constraint staff * staff_hours + subs * sub_hours >= required_hours;
constraint staff * staff_pay + subs * sub_pay <= budget;

% Objective
solve minimize staff + subs;