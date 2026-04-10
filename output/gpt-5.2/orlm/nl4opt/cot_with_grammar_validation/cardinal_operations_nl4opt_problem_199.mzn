% Parameters
int: cost_pi = 1200;
int: cost_beta = 2000;
int: cost_gamma = 4000;

int: reach_pi = 2000;
int: reach_beta = 5000;
int: reach_gamma = 9000;

int: budget = 20000;
int: beta_max = 8;

% Variables
var 0..(budget div cost_pi): x_pi;
var 0..beta_max: x_beta;
var 0..(budget div cost_gamma): x_gamma;

var 0..(budget div min([cost_pi, cost_beta, cost_gamma])): total_ads;

% Constraints
constraint total_ads = x_pi + x_beta + x_gamma;

constraint cost_pi * x_pi + cost_beta * x_beta + cost_gamma * x_gamma <= budget;

% At most one third on Gamma Live: 3*x_gamma <= total_ads
constraint 3 * x_gamma <= total_ads;

% Minimum 20% on Pi TV: 5*x_pi >= total_ads
constraint 5 * x_pi >= total_ads;

% Objective
solve maximize reach_pi * x_pi + reach_beta * x_beta + reach_gamma * x_gamma;