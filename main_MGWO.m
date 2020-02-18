clc;clear;close all;

load SVRTrainData y1;
y_SVR = y1;
load LSTMTrainData y1;
y_LSTM = y1;

[p,Convergence_curve,myP] = myGWO(y_SVR,y_LSTM);


