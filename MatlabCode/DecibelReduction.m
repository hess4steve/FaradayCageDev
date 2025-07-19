Fs = 50e3;

base_path = 'C:\Users\Steven Hess\Documents\rezuktsreal\';
base_prefix = 'July 16_ 2025_';
file_nums = 9:23;

group_names = {
    'Grounded Doors Closed', 
    'Grounded Doors Open', 
    'Ungrounded Doors Closed', 
    'Ungrounded Doors Open', 
    'No Cage'
};

filenames = cell(1, numel(file_nums));
for i = 1:numel(file_nums)
    num_str = sprintf('%02d', file_nums(i));
    filenames{i} = fullfile(base_path, [base_prefix, num_str, '_epks.txt']);
end

group_noise = zeros(1,5);

for g = 1:5
    std_vals = zeros(1,3);
    for t = 1:3
        idx = (g - 1) * 3 + t;
        [~, avg, ~] = read_epks(filenames{idx}, Fs);
        avg = avg(:);
        std_vals(t) = std(avg);
    end
    group_noise(g) = mean(std_vals);
end

% Compute noise reduction in dB relative to max noise
max_noise = max(group_noise);
noise_reduction_db = 20 * log10(max_noise ./ group_noise);

% Sort by noise ascending (lowest noise last)
[~, sort_idx] = sort(group_noise);

group_colors = lines(5);

figure;
b = bar(noise_reduction_db(sort_idx), 'FaceColor', 'flat');
for i = 1:5
    b.CData(i,:) = group_colors(sort_idx(i), :);
end

set(gca, 'XTick', 1:5, 'XTickLabel', group_names(sort_idx), 'XTickLabelRotation', 45);
ylabel('Noise Reduction (dB)');
title('Noise Reduction by Group (relative to noisiest)');
grid on;
