
%
% function [myfft, f] = getfft(mysignal, Fs)
%
function [myfft, f] = getfft(mysignal, Fs)

L = length(mysignal);

NFFT = 2^nextpow2(L);
Y = fft(mysignal,NFFT)/L;

myfft = 2*abs(Y(1:NFFT/2+1));
f = Fs/2 * linspace(0,1,NFFT/2+1);

figure; plot(f, myfft);
xlabel('frequency (Hz)');
ylabel('signal');


fprintf('This is the single-sided amplitude spectrum of v(t)\n');
fprintf('Input: v(t)\n');
fprintf('Output: |V(f)|\n');


