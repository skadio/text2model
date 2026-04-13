% Parameters (with values embedded)
int: vitD_orange = 10;
int: vitC_orange = 8;
int: vitD_apple  = 12;
int: vitC_apple  = 6;

int: min_orange = 3;
int: apple_ratio = 3;         % apple >= 3 * orange
int: max_vitC = 300;

% Upper bounds from vitamin C limit
int: max_orange_ub = max_vitC div vitC_orange; % 300/8 = 37
int: max_apple_ub  = max_vitC div vitC_apple;  % 300/6 = 50

% Variables
var 0..max_orange_ub: orange_boxes;
var 0..max_apple_ub: apple_boxes;

% Constraints
constraint orange_boxes >= min_orange;
constraint apple_boxes >= apple_ratio * orange_boxes;

constraint vitC_orange * orange_boxes + vitC_apple * apple_boxes <= max_vitC;

% Objective
var int: total_vitD = vitD_orange * orange_boxes + vitD_apple * apple_boxes;

solve maximize total_vitD;