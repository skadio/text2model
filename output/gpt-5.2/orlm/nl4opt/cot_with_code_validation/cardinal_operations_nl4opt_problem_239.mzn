% Parameters
float: pain_per_pill1 = 0.2;
float: anx_per_pill1  = 0.3;
float: dis_per_pill1  = 0.3;

float: pain_per_pill2 = 0.6;
float: anx_per_pill2  = 0.2;
float: dis_per_pill2  = 0.1;

float: pain_max = 6.0;
float: anx_min  = 3.0;

% Scale to integers (x10) to avoid floating point issues
int: S = 10;

int: pain1 = round(pain_per_pill1 * S);
int: anx1  = round(anx_per_pill1  * S);
int: dis1  = round(dis_per_pill1  * S);

int: pain2 = round(pain_per_pill2 * S);
int: anx2  = round(anx_per_pill2  * S);
int: dis2  = round(dis_per_pill2  * S);

int: pain_max_i = round(pain_max * S);
int: anx_min_i  = round(anx_min  * S);

% Variables
var 0..pain_max_i div min(pain1, pain2): x1; % number of pill 1
var 0..pain_max_i div min(pain1, pain2): x2; % number of pill 2

var 0..(dis1 + dis2) * (pain_max_i div min(pain1, pain2)): total_discharge;

% Constraints
constraint pain1 * x1 + pain2 * x2 <= pain_max_i;
constraint anx1 * x1 + anx2 * x2 >= anx_min_i;

constraint total_discharge = dis1 * x1 + dis2 * x2;

% Objective
solve minimize total_discharge;