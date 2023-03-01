error_prob = zeros(9,1);
i = 1;
for SNR = [-50:3:-20]
    nr_of_error = 0;
    total_nr = 0;
    while nr_of_error < 50
        [signal, melody_id, freq_offset] = SignalGenerator(1, SNR, 1); % (number of signals, SNR, number of tones)
        [melody_id_guess, pitch] = SingleToneClassifier(signal);
        if (melody_id ~= melody_id_guess) || (freq_offset ~= pitch) % error in melody id OR pitch
            nr_of_error = nr_of_error + 1;
        end
        total_nr = total_nr + 1;
        if total_nr > 150
            break; % run until 50 errors or 150 total tries
        end
    end
    error_prob(i) = nr_of_error/total_nr;
    i = i + 1;
end
plot([-50:3:-20], error_prob,'r');
hold on
xlabel('SNR [dB]');
ylabel('Error probability')

error_prob = zeros(9,1);
i = 1;
for SNR = [-50:3:-20]
    nr_of_error = 0;
    total_nr = 0;
    while nr_of_error < 50
        [signal, melody_id, freq_offset] = SignalGenerator(1, SNR, 3); % (number of signals, SNR, number of tones)
        [melody_id_guess, pitch] = SingleToneClassifier(signal);
        if (melody_id ~= melody_id_guess) || (freq_offset ~= pitch) % error in melody id OR pitch
            nr_of_error = nr_of_error + 1;
        end
        total_nr = total_nr + 1;
        if total_nr > 150
            break; % run until 50 errors or 150 total tries
        end
    end
    error_prob(i) = nr_of_error/total_nr;
    i = i + 1;
end
plot([-50:3:-20], error_prob,'g');
hold on
xlabel('SNR [dB]');
ylabel('Error probability')

error_prob = zeros(9,1);
i = 1;
for SNR = [-50:3:-20]
    nr_of_error = 0;
    total_nr = 0;
    while nr_of_error < 50
        [signal, melody_id, freq_offset] = SignalGenerator(1, SNR, 1); % (number of signals, SNR, number of tones)
        [melody_id_guess, pitch] = TripleToneClassifier(signal);
        if (melody_id ~= melody_id_guess) || (freq_offset ~= pitch) % error in melody id OR pitch
            nr_of_error = nr_of_error + 1;
        end
        total_nr = total_nr + 1;
        if total_nr > 150
            break; % run until 50 errors or 150 total tries
        end
    end
    error_prob(i) = nr_of_error/total_nr;
    i = i + 1;
end
plot([-50:3:-20], error_prob,'b');
hold on
xlabel('SNR [dB]');
ylabel('Error probability')

error_prob = zeros(9,1);
i = 1;
for SNR = [-50:3:-20]
    nr_of_error = 0;
    total_nr = 0;
    while nr_of_error < 50
        [signal, melody_id, freq_offset] = SignalGenerator(1, SNR, 3); % (number of signals, SNR, number of tones)
        [melody_id_guess, pitch] = TripleToneClassifier(signal);
        if (melody_id ~= melody_id_guess) || (freq_offset ~= pitch) % error in melody id OR pitch
            nr_of_error = nr_of_error + 1;
        end
        total_nr = total_nr + 1;
        if total_nr > 150
            break; % run until 50 errors or 150 total tries
        end
    end
    error_prob(i) = nr_of_error/total_nr;
    i = i + 1;
end
plot([-50:3:-20], error_prob,'y');
xlabel('SNR [dB]');
ylabel('Error probability')



