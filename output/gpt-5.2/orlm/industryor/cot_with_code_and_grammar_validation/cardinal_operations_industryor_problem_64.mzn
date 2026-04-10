% Parameters
int: a_hours_per_mw = 2;
int: b_hours_per_mw = 1;
int: a_hours_per_wh = 1;
int: b_hours_per_wh = 3;

int: inspect_cost_mw = 30;
int: inspect_cost_wh = 50;
int: inspect_budget = 5500;

int: a_hours_available = 250;
int: b_hours_available = 150;
int: a_overtime_max = 20;

int: mw_min = 80;
int: wh_min = 50;

int: a_hours_max = a_hours_available + a_overtime_max;

% Variables
var int: mw; % microwave ovens produced/sold per month
var int: wh; % water heaters produced/sold per month

var 0..a_overtime_max: a_overtime;
var 0..a_hours_max: a_hours_used;
var 0..b_hours_available: b_hours_used;

% Constraints
constraint mw >= mw_min;
constraint wh >= wh_min;

constraint inspect_cost_mw * mw + inspect_cost_wh * wh <= inspect_budget;

constraint a_hours_used = a_hours_per_mw * mw + a_hours_per_wh * wh;
constraint b_hours_used = b_hours_per_mw * mw + b_hours_per_wh * wh;

% Fully utilize workshop hours (at least available hours); allow limited overtime in A
constraint a_hours_used >= a_hours_available;
constraint b_hours_used = b_hours_available;

constraint a_overtime = a_hours_used - a_hours_available;
constraint a_hours_used <= a_hours_max;

% Objective
solve satisfy;