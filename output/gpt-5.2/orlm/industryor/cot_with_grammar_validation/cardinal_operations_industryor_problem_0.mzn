int: W = 8;
set of int: WEEKS = 1..W;

array[WEEKS] of int: demandI  = [10000,10000,12000,12000,16000,16000,20000,20000];
array[WEEKS] of int: demandII = [ 6000, 7200, 8400,10800,10800,12000,12000,12000];

int: initial_skilled = 50;
int: target_new_trained_by_end = 50;

int: hours_normal = 40;
int: hours_overtime = 60;

int: prodI_per_hour  = 10;
int: prodII_per_hour = 6;

int: skilled_can_train_per_2weeks = 3;

int: wage_skilled_normal = 360;
int: wage_skilled_overtime = 540;
int: wage_trainee = 120;
int: wage_new_worker = 240;

int: train_duration = 2;

float: penI  = 0.5;
float: penII = 0.6;

int: max_workers_total = initial_skilled + target_new_trained_by_end;

array[WEEKS] of var 0..max_workers_total: skilled_overtime;
array[WEEKS] of var 0..max_workers_total: skilled_normal;
array[WEEKS] of var 0..max_workers_total: in_training;
array[WEEKS] of var 0..max_workers_total: new_workers;

array[WEEKS] of var 0..max_workers_total: trainers;
array[WEEKS] of var 0..max_workers_total: start_training;

array[WEEKS] of var 0..max_workers_total: new_overtime;
array[WEEKS] of var 0..max_workers_total: new_normal;

array[WEEKS] of var 0..10000000: total_hours;
array[WEEKS] of var 0..10000000: hours_I;
array[WEEKS] of var 0..10000000: hours_II;

array[WEEKS] of var 0..100000000: prodI;
array[WEEKS] of var 0..100000000: prodII;

array[WEEKS] of var 0..100000000: backlogI;
array[WEEKS] of var 0..100000000: backlogII;

var int: wage_cost_int;
var float: penalty_cost;
var float: total_cost;

constraint forall(t in WEEKS) (
  skilled_overtime[t] + skilled_normal[t] + trainers[t] <= initial_skilled
);

constraint forall(t in WEEKS) (
  start_training[t] <= skilled_can_train_per_2weeks * trainers[t]
);

constraint forall(t in WEEKS where t < W) (
  start_training[t] <= skilled_can_train_per_2weeks * trainers[t+1]
);

constraint in_training[1] = start_training[1];
constraint forall(t in 2..W) (
  in_training[t] = start_training[t] + start_training[t-1]
);

constraint new_workers[1] = 0;
constraint (if W >= 2 then new_workers[2] = 0 else true endif);
constraint forall(t in 3..W) (
  new_workers[t] = new_workers[t-1] + start_training[t-2]
);

constraint new_workers[W] = target_new_trained_by_end;

constraint forall(t in WEEKS) (
  new_overtime[t] + new_normal[t] = new_workers[t]
);

constraint forall(t in WEEKS) (
  total_hours[t] =
    hours_overtime * (skilled_overtime[t] + new_overtime[t]) +
    hours_normal  * (skilled_normal[t]  + new_normal[t])
);

constraint forall(t in WEEKS) (
  hours_I[t] + hours_II[t] = total_hours[t]
);

constraint forall(t in WEEKS) (
  prodI[t] = prodI_per_hour * hours_I[t]
);

constraint forall(t in WEEKS) (
  prodII[t] = prodII_per_hour * hours_II[t]
);

constraint backlogI[1] = max(0, demandI[1] - prodI[1]);
constraint backlogII[1] = max(0, demandII[1] - prodII[1]);

constraint forall(t in 2..W) (
  backlogI[t] = max(0, backlogI[t-1] + demandI[t] - prodI[t])
);

constraint forall(t in 2..W) (
  backlogII[t] = max(0, backlogII[t-1] + demandII[t] - prodII[t])
);

constraint backlogI[1] >= demandI[1] - prodI[1];
constraint backlogI[1] >= 0;
constraint backlogII[1] >= demandII[1] - prodII[1];
constraint backlogII[1] >= 0;

constraint forall(t in 2..W) (
  backlogI[t] >= backlogI[t-1] + demandI[t] - prodI[t]
);
constraint forall(t in 2..W) (backlogI[t] >= 0);

constraint forall(t in 2..W) (
  backlogII[t] >= backlogII[t-1] + demandII[t] - prodII[t]
);
constraint forall(t in 2..W) (backlogII[t] >= 0);

constraint wage_cost_int =
  sum(t in WEEKS)(
    wage_skilled_overtime * skilled_overtime[t] +
    wage_skilled_normal  * skilled_normal[t] +
    wage_skilled_normal  * trainers[t] +
    wage_trainee         * in_training[t] +
    wage_skilled_overtime * new_overtime[t] +
    wage_new_worker       * new_normal[t]
  );

constraint penalty_cost =
  sum(t in WEEKS)(
    penI  * int2float(backlogI[t]) +
    penII * int2float(backlogII[t])
  );

constraint total_cost = int2float(wage_cost_int) + penalty_cost;

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "wage_cost=", show(wage_cost_int), "\n",
  "penalty_cost=", show(penalty_cost), "\n",
  "skilled_normal=", show(skilled_normal), "\n",
  "skilled_overtime=", show(skilled_overtime), "\n",
  "trainers=", show(trainers), "\n",
  "start_training=", show(start_training), "\n",
  "in_training=", show(in_training), "\n",
  "new_workers=", show(new_workers), "\n",
  "new_normal=", show(new_normal), "\n",
  "new_overtime=", show(new_overtime), "\n",
  "hours_I=", show(hours_I), "\n",
  "hours_II=", show(hours_II), "\n",
  "prodI=", show(prodI), "\n",
  "prodII=", show(prodII), "\n",
  "backlogI=", show(backlogI), "\n",
  "backlogII=", show(backlogII), "\n"
];