function [new_melody_id_guess, pitch] = TripleToneClassifier(signal)

    y = signal; % vector with 12 notes, 43392 samples total
    K = 3616; % number of samples per note
    NR_OF_TONES = 6; % each tone split into cos and sin
    
    %% Copy Paste %%
    note_duration = 0.4;
    pause_duration = 0.01;
    sampling_freq = 8820;

    Nr_samples_note = floor(note_duration*sampling_freq);
    Nr_pause_note = floor(pause_duration*sampling_freq);

    notes_char = {'C@','C#@','D@','D#@','E@','F@','F#@','G@','G#@','A@','A#@','B@'};
    notes_freq_1 = 440.*(2.^((-9:2)./12));
    notes_txt = {...
        'C4', 'C4', 'G4', 'G4', 'A4', 'A4', 'G4', 'G4', 'F4', 'F4', 'E4', 'E4';...
        'G4', 'G4', 'A4', 'E4', 'G4', 'G4', 'C5', 'D5', 'E5', 'E5', 'E5', 'D5';...
        'G3', 'B3', 'D4', 'B4', 'G4', 'D4', 'G3', 'C4', 'E4', 'C5', 'G4', 'E4';...
        'G4', 'G4', 'G4', 'B4', 'A4', 'A4', 'A4', 'C5', 'B4', 'G4', 'A4', 'F#4';...
        'A3', 'D4', 'A3', 'E4', 'A3', 'F4', 'A3', 'G4', 'A3', 'F4', 'A3', 'E4';...
        'B3', 'D#4', 'G4', 'D#5', 'B4', 'G4', 'C4', 'E4', 'G4', 'E5', 'C5', 'G4';...
        'D3', 'A3', 'C4', 'F#4', 'D4', 'C4', 'D3', 'G3', 'C4', 'E4', 'C4', 'G3';...
        'E4', 'E4', 'F4', 'G4', 'G4', 'F4', 'E4', 'D4', 'C4', 'C4', 'D4', 'E4';...
        'E4', 'F4', 'G4', 'E4', 'G4', 'E4', 'G4', 'E4', 'G4', 'D5', 'C5', 'E4';...
        'E5', 'D#5', 'E5', 'D#5', 'E5', 'B4', 'D5', 'C5', 'A4', 'E3', 'A3', 'C4'};

    [N_melodies,N_notes_per_melody] = size(notes_txt);

    freq_notes = zeros([N_melodies,N_notes_per_melody]);

    for n_scale = 1:8
        notes_char_t = strrep(notes_char,'@',num2str(n_scale));
        for i_notes = 1:12
            ind  = strfind(notes_txt,notes_char_t{i_notes});
            freq_notes((~cellfun('isempty', ind))) = notes_freq_1(i_notes).*2.^(n_scale - 4 );
        end
    end
    %% End Copy Paste %%
    
    % create frequency matrix, 20x12
    f = freq_notes;
    f_1 = f*0.975;
    f_2 = f*1.025;
    f = [f_1;f_2];
    f = f./8820;
    
    H = ones(20,12,K,NR_OF_TONES); % allocate space
    for n = 1:12
        for j = 1:20
            % for each pair of j and n (each frequency), gives a 3616x2 matrix with cos and
            % sin
            H(j,n,:,:) = [ cos(2*pi*(0:K-1)'*f(j,n)), sin(2*pi*(0:K-1)'*f(j,n)), cos(2*pi*(0:K-1)'*f(j,n)*3), sin(2*pi*(0:K-1)'*f(j,n)*3), cos(2*pi*(0:K-1)'*f(j,n)*5), sin(2*pi*(0:K-1)'*f(j,n)*5)];
        end
    end
    
    % add the sum for each j in a vector
    for j = 1:20
        current_sum = 0;
        for n = 1:12
            current_sum = current_sum + norm( squeeze( squeeze( (H(j,n,:,:))))'*y(1+(n-1)*K:n*K) )^2;
        end
        j_hat(j) = current_sum;
    end

    % argmax of the different sums
    [~,melody_id_guess] = max(j_hat);
    
    if melody_id_guess > 10
        new_melody_id_guess = melody_id_guess - 10;
        pitch = 1.025;
    end
    
    if melody_id_guess <= 10
        new_melody_id_guess = melody_id_guess;
        pitch = 0.975;
    end
end