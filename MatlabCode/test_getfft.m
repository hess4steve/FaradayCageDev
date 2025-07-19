

% an example for getfft

fsig = 5;
fn = 60;
Fsamp = 200; % Hz
t = linspace(0, 1, Fsamp);
ysig = sin(2*pi*fsig*t);
yn = 0.2*sin(2*pi*fn*t);
y = ysig + yn;


figure; plot(t, y); title('signal in time');

[myfft, freq] = getfft(y, Fsamp);