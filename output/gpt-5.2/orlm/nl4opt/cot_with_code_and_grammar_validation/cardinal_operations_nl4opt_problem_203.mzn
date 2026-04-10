% Parameters
int: lab_newspapers = 7;
int: lab_treats = 5;
int: gold_newspapers = 10;
int: gold_treats = 6;

int: total_treats = 1500;
int: min_gold = 50;
int: max_lab_percent = 60;

% Upper bounds for search (safe bounds from treat limit)
int: max_lab = total_treats div lab_treats;
int: max_gold = total_treats div gold_treats;

% Variables
var 0..max_lab: L;          % number of labradors
var 0..max_gold: G;         % number of golden retrievers
var 0..(lab_newspapers*max_lab + gold_newspapers*max_gold): total_newspapers;

% Constraints
constraint lab_treats * L + gold_treats * G <= total_treats;
constraint G >= min_gold;

% At most 60% labradors:  L <= 0.6*(L+G)  <=>  10*L <= 6*(L+G)  <=>  4*L <= 6*G  <=>  2*L <= 3*G
constraint 2 * L <= 3 * G;

constraint total_newspapers = lab_newspapers * L + gold_newspapers * G;

% Objective
solve maximize total_newspapers;