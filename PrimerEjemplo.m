%Conectar al dispositivo (requiere MATLAB Mobile en el móvil)
m = mobiledev;
m.AccelerationSensorEnabled = 1;
m.Logging = 1;

disp('Mueve el teléfono para recolectar datos...');
pause(5);

% Leer los datos y graficar
[accel, time] = accellog(m);
plot(time, accel);
title('Datos del Acelerómetro en Tiempo Real');
