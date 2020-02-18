function fitness = fun_C(p,y_SVR,y_LSTM)
load SVRTrainData y_period;
w1 = p(1);
w2= p(2);
b = p(3);

y = w1*y_SVR + w2*y_LSTM + b;
E = y - y_period(1:60,1);
N = numel(E);
Q = 0;
for i = 1:N
    if E(i) > 0
        Q = Q + E(i)^2;
%         Q = Q + abs(E(i));
    else
        Q = Q + (E(i)+1-exp(E(i)))^2;
%         Q = Q + 1.3*E(i)^2;
%         Q = Q + abs(E(i));
    end
end
fitness = Q;