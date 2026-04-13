% Parameters
int: hoursA_available = 250;
int: hoursB_available = 150;
int: hoursA_overtime_max = 20;

int: mw_hoursA = 2;
int: mw_hoursB = 1;
int: wh_hoursA = 1;
int: wh_hoursB = 3;

int: mw_inspect_sales_cost = 30;
int: wh_inspect_sales_cost = 50;
int: inspect_sales_budget = 5500;

int: mw_min_sold = 80;
int: wh_min_sold = 50;

int: hour_cost_A = 80;
int: hour_cost_B = 20;

% Variables
var mw_min_sold..1000: mw;  % microwave ovens produced/sold per month
var wh_min_sold..1000: wh;  % water heaters produced/sold per month

var hoursA_available..hoursA_available + hoursA_overtime_max: hoursA_used;
var hoursB_available..hoursB_available: hoursB_used;

var 0..hoursA_overtime_max: overtimeA;

var 0..1000000: total_cost;

% Constraints
constraint hoursA_used = mw_hoursA * mw + wh_hoursA * wh;
constraint hoursB_used = mw_hoursB * mw + wh_hoursB * wh;

% Fully utilize base capacity and allow limited overtime in A
constraint hoursA_used = hoursA_available + overtimeA;
constraint hoursB_used = hoursB_available;

% Inspection and sales budget
constraint mw_inspect_sales_cost * mw + wh_inspect_sales_cost * wh <= inspect_sales_budget;

% Total cost (workshop time costs only; inspection/sales cost is a budget constraint)
constraint total_cost = hour_cost_A * hoursA_used + hour_cost_B * hoursB_used;

% Objective
solve minimize total_cost;