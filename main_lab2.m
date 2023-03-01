clear
clc
warning('off')

% Constants
time_step = 0.1;
t = [-15:time_step:15];
sample_freq = 1/0.1;
sigma_squared = 0.001;
SNR = -10*log10(sigma_squared);

% Signals
s1 = exp(-0.1*t.^2);
s2 = exp(-0.1*t.^2).*cos(t);

% Normalize
E1 = sum(abs(s1.^2));
E2 = sum(abs(s2).^2);
s1 = s1/sqrt(E1);
s2 = s2/sqrt(E2);

% Noise
e = sqrt(sigma_squared)*randn(size(t));

% Observed signal
delay = 0;
x = exp(-0.1*(t-delay).^2).*cos(t-delay);
Ex = sum(abs(x.^2));
x = x/sqrt(Ex) + e;

% Plot
figure(1)
plot(t,s1);
title('S1(t)')
xlabel('Time [s]');
ylabel('Amplitude');

figure(2)
plot(t,s2);
title('S2(t)')
xlabel('Time [s]');
ylabel('Amplitude');

figure(3)
plot(t,x);
title('x(t)')
xlabel('Time [s]');
ylabel('Amplitude');


% Maximum likelihood estimator
ML_sum = [];
for T = [-5:time_step:5]
    delayed_s2 = exp(-0.1*(t-T).^2).*cos(t-T);
    E_delayed_s2 = sum(abs(delayed_s2.^2));
    delayed_s2 = delayed_s2/sqrt(E_delayed_s2);
    ML_sum = [ML_sum ; sum(x.*delayed_s2)];
end
[~,T_hat_ML_index] = max(ML_sum);
T_hat_ML = (T_hat_ML_index - 51)*time_step; % Remove 51 samples to compensate for [-5:5]

% Cramer-Rao lower bound
s1_CRB_vector = [];
s2_CRB_vector = [];
sigma_squared_vector = [0.01:0.01:1];
for sigma_squared = sigma_squared_vector
    s1_CRB_denominator = sum((diff(s1)/time_step).^2);
    s1_CRB = sigma_squared./s1_CRB_denominator;
    s1_CRB_vector = [s1_CRB_vector ; s1_CRB];
    
    s2_CRB_denominator = sum((diff(s2)/time_step).^2);
    s2_CRB = sigma_squared./s2_CRB_denominator;
    s2_CRB_vector = [s2_CRB_vector ; s2_CRB];
end

% Plot CRB as function of SNR
figure(4)
SNR_vector = -10*log10(sigma_squared_vector);
semilogy(SNR_vector, sqrt(s1_CRB_vector));
hold on
semilogy(SNR_vector, sqrt(s2_CRB_vector));

%% Monte Carlo
s1_RMSE_vector = [];
s2_RMSE_vector = [];
for sigma_squared = sigma_squared_vector
    s1_RMSE_vector_inner = [];
    s2_RMSE_vector_inner = [];
    for i = [1:500]
        e = sqrt(sigma_squared)*randn(size(t));
        SNR = -10*log10(sigma_squared);

        random_delay =  10*rand - 5; % in range [-5,5]
        x1 = exp(-0.1*(t-random_delay).^2);
        x2 = exp(-0.1*(t-random_delay).^2).*cos(t-random_delay);
        Ex1 = sum(abs(x1.^2));
        Ex2 = sum(abs(x2.^2));
        x1 = x1/sqrt(Ex1) + e;
        x2 = x2/sqrt(Ex2) + e;

        s1_ML_sum = [];
        s2_ML_sum = [];
        for T = [-5:time_step:5]
            delayed_s1 = exp(-0.1*(t-T).^2);
            E_delayed_s1 = sum(abs(delayed_s1.^2));
            delayed_s1 = delayed_s1/sqrt(E_delayed_s1);
            
            delayed_s2 = exp(-0.1*(t-T).^2).*cos(t-T);
            E_delayed_s2 = sum(abs(delayed_s2.^2));
            delayed_s2 = delayed_s2/sqrt(E_delayed_s2);
            
            s1_ML_sum = [s1_ML_sum ; sum(x1.*delayed_s1)];
            s2_ML_sum = [s2_ML_sum ; sum(x2.*delayed_s2)];
        end
        [~,s1_T_hat_ML_index] = max(s1_ML_sum);
        [~,s2_T_hat_ML_index] = max(s2_ML_sum);
        s1_T_hat_ML = (s1_T_hat_ML_index - 51)*time_step;
        s2_T_hat_ML = (s2_T_hat_ML_index - 51)*time_step;

        s1_RMSE_vector_inner = [s1_RMSE_vector_inner ; (s1_T_hat_ML - random_delay).^2];
        s2_RMSE_vector_inner = [s2_RMSE_vector_inner ; (s2_T_hat_ML - random_delay).^2];
    end
    s1_RMSE_vector = [s1_RMSE_vector ; sqrt(mean(s1_RMSE_vector_inner))];
    s2_RMSE_vector = [s2_RMSE_vector ; sqrt(mean(s2_RMSE_vector_inner))];
end

% Plot
semilogy(SNR_vector, s1_RMSE_vector);
semilogy(SNR_vector, s2_RMSE_vector);
title('CRB & RMSE')
xlabel('SNR [dB]');
ylabel('CRB^1^/^2');
legend('s1 CRB^1^/^2','s2 CRB^1^/^2','s1 RMSE', 's2 RMSE')

% a) s2 is the most appropriate, more resistant to noise, clearer peak.

% b) If the signal takes more than 15 seconds to return, the car infront is
% VERY far away. 99% of the energy is within [-15,15].

% c) The noise samples has mean 0 and variance 0.001.
