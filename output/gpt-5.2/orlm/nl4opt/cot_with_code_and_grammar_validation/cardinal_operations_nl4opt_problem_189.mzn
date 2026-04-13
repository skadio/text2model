% Parameters
int: vitD_orange = 10;
int: vitC_orange = 8;
int: vitD_apple  = 12;
int: vitC_apple  = 6;

int: min_orange = 3;
int: apple_to_orange_ratio = 3; % apple >= 3 * orange
int: max_vitC = 300;

% Variables
var 0..max_vitC: orange;
var 0..max_vitC: apple;

% Constraints
constraint orange >= min_orange;
constraint apple >= apple_to_orange_ratio * orange;

constraint vitC_orange * orange + vitC_apple * apple <= max_vitC;

% Objective
solve maximize vitD_orange * orange + vitD_apple * apple;