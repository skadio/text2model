% Parameters
int: cap_trailer = 50;
int: cost_trailer = 500;
int: cap_tanker = 30;
int: cost_tanker = 200;

int: min_volume = 1000;
int: budget = 3750;

% Variables
var 0..(budget div cost_trailer): x_trailer;
var 0..(budget div cost_tanker): x_tanker;

% Constraints
constraint cap_trailer * x_trailer + cap_tanker * x_tanker >= min_volume;
constraint cost_trailer * x_trailer + cost_tanker * x_tanker <= budget;
constraint x_trailer < x_tanker;

% Objective
solve minimize x_trailer + x_tanker;