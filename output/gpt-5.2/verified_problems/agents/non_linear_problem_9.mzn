% Parameters
int: P;                              % Number of warehouses to open
int: num_customers;                  % Number of customers
int: num_warehouses;                 % Number of candidate warehouses

set of int: Customers = 1..num_customers;     % Customer index set
set of int: Warehouses = 1..num_warehouses;   % Warehouse index set

array[Customers] of float: Demand;            % Demand of each customer
array[Customers, Warehouses] of float: Distance; % Distance from customer to warehouse


% Variables
array[Warehouses] of var bool: open;              % open[w] = true if warehouse w is opened
array[Customers, Warehouses] of var bool: assign; % assign[c,w] = true if customer c served by warehouse w
array[Customers] of var float: service_cost;      % Demand-weighted distance cost for each customer

% Bounds / domain-related constraints
constraint P >= 0 /\ P <= num_warehouses;

% Nonnegativity assumptions for input-based quantities (safe bounds for linear expressions)
constraint forall(c in Customers)(Demand[c] >= 0.0);
constraint forall(c in Customers, w in Warehouses)(Distance[c,w] >= 0.0);

% service_cost is a sum of nonnegative terms -> can be bounded below by 0
constraint forall(c in Customers)(service_cost[c] >= 0.0);


% Constraints

%-------------------------------
% Facility opening cardinality
%-------------------------------
% Open exactly P warehouses
constraint sum(w in Warehouses)(bool2int(open[w])) = P;

%-------------------------------
% Customer assignment uniqueness
%-------------------------------
% Each customer is served by exactly one warehouse
constraint
  forall(c in Customers)(
    sum(w in Warehouses)(bool2int(assign[c,w])) = 1
  );

%-------------------------------
% Assignment implies facility open
%-------------------------------
% Customers can only be assigned to warehouses that are opened
constraint
  forall(c in Customers, w in Warehouses)(
    bool2int(assign[c,w]) <= bool2int(open[w])
  );

%-------------------------------
% Service cost definition (demand-weighted distance)
%-------------------------------
% Define per-customer service cost as the demand-weighted distance to the chosen warehouse
constraint
  forall(c in Customers)(
    service_cost[c] =
      Demand[c] * sum(w in Warehouses)(Distance[c,w] * bool2int(assign[c,w]))
  );


% Objective
solve minimize sum(c in Customers)(service_cost[c]);