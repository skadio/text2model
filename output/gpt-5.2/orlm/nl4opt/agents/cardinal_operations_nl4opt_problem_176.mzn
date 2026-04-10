% Parameters
int: freight_capacity = 5;        % tons per freight trip
int: air_capacity = 3;            % tons per air trip
int: freight_cost = 300;          % $ per freight trip
int: air_cost = 550;              % $ per air trip

int: min_total_tons = 200;        % at least this many tons must be transported
int: budget = 20000;              % maximum total budget in $
int: min_freight_trips = 5;       % at least this many freight trips
int: min_air_percent = 30;        % at least this percent of transported tons must be by air


% Variables
var int: freight_trips;           % number of freight trips to schedule
var int: air_trips;               % number of air trips to schedule

% Derived decision variables (kept explicit)
var int: freight_tons;            % tons moved by freight
var int: air_tons;                % tons moved by air
var int: total_tons;              % total tons moved
var int: total_cost;              % total cost in $
var int: total_trips;             % total number of trips


% Constraints

%-----------------------------%
% Domain / non-negativity     %
%-----------------------------%
constraint freight_trips >= min_freight_trips;   % minimum required freight trips
constraint air_trips >= 0;                       % cannot schedule negative air trips

%-----------------------------%
% Trip-to-tons linkage        %
%-----------------------------%
constraint freight_tons = freight_capacity * freight_trips;   % tons moved by freight
constraint air_tons = air_capacity * air_trips;               % tons moved by air
constraint total_tons = freight_tons + air_tons;              % total tons moved

%-----------------------------%
% Cost and total trips linkage%
%-----------------------------%
constraint total_cost = freight_cost * freight_trips + air_cost * air_trips; % total cost
constraint total_trips = freight_trips + air_trips;                           % total trips

%-----------------------------%
% Demand and budget limits    %
%-----------------------------%
constraint total_tons >= min_total_tons;   % must transport at least the required tons
constraint total_cost <= budget;           % must respect the budget

%-----------------------------%
% Air share requirement       %
%-----------------------------%
% At least min_air_percent% of transported tons must be by air:
% air_tons / total_tons >= min_air_percent/100  <=>  100*air_tons >= min_air_percent*total_tons
constraint 100 * air_tons >= min_air_percent * total_tons;


% Objective
solve minimize total_trips;