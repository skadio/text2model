% Parameters
int: cal_ramen = 400;
int: pro_ramen = 20;
int: sod_ramen = 100;

int: cal_fries = 300;
int: pro_fries = 10;
int: sod_fries = 75;

int: min_cal = 3000;
int: min_pro = 80;

int: ramen_pct_max_num = 30;  % 30%
int: ramen_pct_max_den = 100;

% Variable upper bounds (safe finite bounds from requirements)
int: max_ramen = max(ceil(min_cal div cal_ramen) + 10, ceil(min_pro div pro_ramen) + 10);
int: max_fries = max(ceil(min_cal div cal_fries) + 10, ceil(min_pro div pro_fries) + 10);

% Variables
var 0..max_ramen: ramen;
var 0..max_fries: fries;

% Constraints
constraint cal_ramen * ramen + cal_fries * fries >= min_cal;
constraint pro_ramen * ramen + pro_fries * fries >= min_pro;

% At most 30% of meals are ramen: ramen / (ramen+fries) <= 0.3
% Avoid division: 100*ramen <= 30*(ramen+fries)
constraint ramen_pct_max_den * ramen <= ramen_pct_max_num * (ramen + fries);

% Objective
var int: total_sodium = sod_ramen * ramen + sod_fries * fries;
solve minimize total_sodium;