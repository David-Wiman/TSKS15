[signal, melody_id, freq_offset] =  SignalGenerator(1, 100, 3); % (number of signals, SNR, number of tones)
%[melody_id_guess, pitch] = SingleToneClassifier(signal);
[melody_id_guess, pitch] = TripleToneClassifier(signal)