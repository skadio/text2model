% Parameters
int: hours_required = 1000;
int: budget = 40000;

int: hours_staff = 6;
int: pay_staff = 300;

int: hours_sub = 3;
int: pay_sub = 100;

% Variables
var 0..(budget div pay_staff): staff;
var 0..(budget div pay_sub): subs;

% Constraints
constraint hours_staff * staff + hours_sub * subs >= hours_required;
constraint pay_staff * staff + pay_sub * subs <= budget;

% Objective
solve minimize staff + subs;