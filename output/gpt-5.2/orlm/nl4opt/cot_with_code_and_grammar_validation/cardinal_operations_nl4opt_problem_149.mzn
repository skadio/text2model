% Parameters
int: budget = 2000;
int: max_space = 200;

int: cost_long = 300;
int: space_long = 10;
int: seats_long = 6;

int: cost_short = 100;
int: space_short = 4;
int: seats_short = 2;

% Variables
var 0..(budget div cost_long): long_desks;
var 0..(budget div cost_short): short_desks;

% Constraints
constraint cost_long * long_desks + cost_short * short_desks <= budget;
constraint space_long * long_desks + space_short * short_desks <= max_space;

% Objective
solve maximize seats_long * long_desks + seats_short * short_desks;