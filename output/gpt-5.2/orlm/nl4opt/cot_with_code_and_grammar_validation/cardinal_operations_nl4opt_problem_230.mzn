% Parameters
int: container_cap = 30;
int: truck_cap = 40;
int: min_oil = 2000;
int: min_containers = 15;

% Variables
var 0..ceil(min_oil div container_cap) + ceil(min_oil div truck_cap): C; % number of containers
var 0..ceil(min_oil div truck_cap): T;                                  % number of trucks

% Constraints
constraint C >= min_containers;

constraint container_cap * C + truck_cap * T >= min_oil;

% trucks at most half containers: T <= C/2  <=>  2T <= C
constraint 2 * T <= C;

% Objective
solve minimize C + T;