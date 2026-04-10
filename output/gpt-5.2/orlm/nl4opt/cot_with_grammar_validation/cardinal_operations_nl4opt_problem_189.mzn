% Parameters
int: vitD_orange = 10;
int: vitC_orange = 8;
int: vitD_apple  = 12;
int: vitC_apple  = 6;

int: min_orange_boxes = 3;
int: apple_ratio = 3;          % apple_boxes >= 3 * orange_boxes
int: max_vitC = 300;

% Variables
var 0..(max_vitC div vitC_orange): orange_boxes;
var 0..(max_vitC div vitC_apple):  apple_boxes;

var 0..(vitD_orange*(max_vitC div vitC_orange) + vitD_apple*(max_vitC div vitC_apple)): total_vitD;

% Constraints
constraint orange_boxes >= min_orange_boxes;

constraint apple_boxes >= apple_ratio * orange_boxes;

constraint vitC_orange * orange_boxes + vitC_apple * apple_boxes <= max_vitC;

constraint total_vitD = vitD_orange * orange_boxes + vitD_apple * apple_boxes;

% Objective
solve maximize total_vitD;