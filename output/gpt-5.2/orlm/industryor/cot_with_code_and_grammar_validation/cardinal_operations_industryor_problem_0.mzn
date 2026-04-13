int: W = 8;
set of int: Weeks = 1..W;

int: initial_skilled = 50;
int: total_new_to_train = 50;

int: hours_normal = 40;
int: hours_overtime = 60;

int: prodI_per_hour = 10;
int: prodII_per_hour = 6;

int: max_trainees_per_trainer = 3;
int: training_duration = 2;

int: wage_skilled_normal = 360;
int: wage_skilled_overtime = 540;
int: wage_trainee_in_training = 120;
int: wage_new_after_training = 240;

float: penalty_I = 0.5;
float: penalty_II = 0.6;

array[Weeks] of int: demandI  = [10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000];
array[Weeks] of int: demandII = [ 6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000];

int: max_backlogI  = sum(w in Weeks)(demandI[w]);
int: max_backlogII = sum(w in Weeks)(demandII[w]);

int: max_prodI_week  = (initial_skilled + total_new_to_train) * hours_overtime * prodI_per_hour;
int: max_prodII_week = (initial_skilled + total_new_to_train) * hours_overtime * prodII_per_hour;

array[Weeks] of var 0..initial_skilled: trainers;
array[Weeks] of var 0..total_new_to_train: trainees;
array[Weeks] of var 0..total_new_to_train: trained_cum;

array[Weeks] of var 0..(initial_skilled + total_new_to_train): workforce_active;
array[Weeks] of var 0..(initial_skilled + total_new_to_train): skilled_overtime;
array[Weeks] of var 0..(initial_skilled + total_new_to_train): skilled_normal;

array[Weeks] of var 0..max_prodI_week: prodI;
array[Weeks] of var 0..max_prodII_week: prodII;

array[Weeks] of var 0..max_backlogI: backlogI;
array[Weeks] of var 0..max_backlogII: backlogII;

var float: total_cost;

constraint trained_cum[1] = 0;
constraint trained_cum[2] = 0;
constraint forall(w in 3..W)(
  trained_cum[w] = trained_cum[w - 1] + trainees[w - training_duration]
);

constraint trained_cum[W] = total_new_to_train;

constraint forall(w in Weeks)(
  trainees[w] <= max_trainees_per_trainer * trainers[w]
);

constraint forall(w in Weeks)(
  trainees[w] <= total_new_to_train - trained_cum[w]
);

constraint forall(w in Weeks)(
  workforce_active[w] = (initial_skilled - trainers[w]) + trained_cum[w]
);

constraint forall(w in Weeks)(
  skilled_overtime[w] <= workforce_active[w]
);
constraint forall(w in Weeks)(
  skilled_normal[w] = workforce_active[w] - skilled_overtime[w]
);

constraint forall(w in Weeks)(
  3 * prodI[w] + 5 * prodII[w]
  <= 30 * hours_normal * skilled_normal[w]
   + 30 * hours_overtime * skilled_overtime[w]
);

constraint backlogI[1] >= demandI[1] - prodI[1];
constraint backlogI[1] >= 0;
constraint backlogII[1] >= demandII[1] - prodII[1];
constraint backlogII[1] >= 0;

constraint forall(w in 2..W)(
  backlogI[w] >= backlogI[w - 1] + demandI[w] - prodI[w]
);
constraint forall(w in 2..W)(
  backlogI[w] >= 0
);

constraint forall(w in 2..W)(
  backlogII[w] >= backlogII[w - 1] + demandII[w] - prodII[w]
);
constraint forall(w in 2..W)(
  backlogII[w] >= 0
);

constraint forall(w in Weeks)(trainers[w] <= initial_skilled);

constraint total_cost =
  sum(w in Weeks)(
      int2float(wage_skilled_normal) * int2float(skilled_normal[w])
    + int2float(wage_skilled_overtime) * int2float(skilled_overtime[w])
    + int2float(wage_trainee_in_training) * int2float(trainees[w])
    + int2float(wage_new_after_training) * int2float(trained_cum[w])
    + penalty_I  * int2float(backlogI[w])
    + penalty_II * int2float(backlogII[w])
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "trainers=", show(trainers), "\n",
  "trainees=", show(trainees), "\n",
  "trained_cum=", show(trained_cum), "\n",
  "workforce_active=", show(workforce_active), "\n",
  "skilled_overtime=", show(skilled_overtime), "\n",
  "prodI=", show(prodI), "\n",
  "prodII=", show(prodII), "\n",
  "backlogI=", show(backlogI), "\n",
  "backlogII=", show(backlogII), "\n"
];