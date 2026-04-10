% Parameters (with values embedded)
int: H_regular = 110;                 % regular weekly production hours
int: H_overtime_max = 10;             % maximum allowed overtime hours
int: rate = 1000;                     % meters per hour for both fabrics

int: minCurtain_m = 70000;            % minimum weekly sales (meters)
int: minClothing_m = 45000;

float: profitCurtain = 2.5;           % yuan per meter
float: profitClothing = 1.5;

% Variables
var 0..(H_regular + H_overtime_max): hCurtain;   % hours producing curtain fabric
var 0..(H_regular + H_overtime_max): hClothing;  % hours producing clothing fabric
var 0..H_overtime_max: overtime;                 % overtime hours

var 0..rate*(H_regular + H_overtime_max): mCurtain;   % meters produced/sold
var 0..rate*(H_regular + H_overtime_max): mClothing;

% Constraints
% p1: fully utilize 110 regular hours (total hours = regular + overtime)
constraint hCurtain + hClothing = H_regular + overtime;

% p2: overtime limit
constraint overtime <= H_overtime_max;

% Production (meters = rate * hours)
constraint mCurtain = rate * hCurtain;
constraint mClothing = rate * hClothing;

% p3: minimum sales requirements
constraint mCurtain >= minCurtain_m;
constraint mClothing >= minClothing_m;

% Objective
% p4: minimize overtime as much as possible
solve minimize overtime;