% Parameters
int: cost_pi = 1200;
int: reach_pi = 2000;

int: cost_beta = 2000;
int: reach_beta = 5000;
int: beta_max = 8;

int: cost_gamma = 4000;
int: reach_gamma = 9000;

int: budget = 20000;

% Variables
var 0..(budget div cost_pi): x_pi;
var 0..beta_max: x_beta;
var 0..(budget div cost_gamma): x_gamma;

var 0..(budget div min(cost_pi, min(cost_beta, cost_gamma))): total;

% Constraints
constraint total = x_pi + x_beta + x_gamma;

% Budget
constraint cost_pi * x_pi + cost_beta * x_beta + cost_gamma * x_gamma <= budget;

% Mix constraints:
% At most a third on Gamma Live: x_gamma <= total/3  ->  3*x_gamma <= total
constraint 3 * x_gamma <= total;

% At least 20% on Pi TV: x_pi >= 0.2*total -> 5*x_pi >= total
constraint 5 * x_pi >= total;

% Objective
solve maximize reach_pi * x_pi + reach_beta * x_beta + reach_gamma * x_gamma;