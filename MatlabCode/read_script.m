Fs = 50e3;

% Paths and naming
base_path = 'C:\Users\Steven Hess\Documents\rezuktsreal\';
base_prefix = 'July 16_ 2025_';
file_nums = 9:23;

% Group names
original_group_names = {
    'Grounded Doors Closed', 
    'Grounded Doors Open', 
    'Ungrounded Doors Closed', 
    'Ungrounded Doors Open', 
    'No Cage'
};

% Generate filenames
filenames = cell(1, numel(file_nums));
for i = 1:numel(file_nums)
    num_str = sprintf('%02d', file_nums(i));
    filenames{i} = fullfile(base_path, [base_prefix, num_str, '_epks.txt']);
end

% Precompute noise for each group (using all trials)
group_noise = zeros(1, 5);
group_trials = cell(1, 5);

for g = 1:5
    group_std = zeros(1, 3);
    trials = cell(1, 3);
    for t = 1:3
        idx = (g - 1) * 3 + t;
        [~, avg, ~] = read_epks(filenames{idx}, Fs);
        trials{t} = avg;
        group_std(t) = std(avg);
    end
    group_noise(g) = mean(group_std);
    group_trials{g} = trials;
end

% Sort groups by average noise ascending (cleanest first)
[~, sort_idx] = sort(group_noise);
sorted_group_names = original_group_names(sort_idx);

group_colors = lines(5);

% Plot one figure per trial (Trial 1, Trial 2, Trial 3)
for trial_num = 1:3
    figure; hold on;
    for plot_order = 5:-1:1  % plot noisiest first, cleanest last
        g = sort_idx(plot_order);
        color = group_colors(g, :);
        
        idx = (g - 1) * 3 + trial_num;
        [times, ~, ~] = read_epks(filenames{idx}, Fs);
        y = group_trials{g}{trial_num} * 1e3;  % convert to mV
        
        % Clip y to [-50, 50] mV
        y(y < -50) = -50;
        y(y > 50) = 50;
        
        plot(times * 1e3, y, ...
             'Color', color, ...
             'DisplayName', [original_group_names{g} ' - Trial ' num2str(trial_num)]);
    end
    xlabel('Time (ms)');
    ylabel('Potential (mV)');
    ylim([-55 55]);
    title(['Evoked Potentials - Trial ' num2str(trial_num) ' (Groups ordered by noise)']);
    legend('Location', 'eastoutside');
    grid on;
end
