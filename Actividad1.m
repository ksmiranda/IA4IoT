%% 1. RECOLECCIÓN DE DATOS (Dataset)
% Definimos dos gestos: 'Circulo' y 'Sacudida'
gestos = {'Circulo', 'Sacudida'};
dataset = table();

for g = 1:length(gestos)
    input(['Presiona Enter y realiza el gesto: ', gestos{g}], 's');
    
    m.Logging = 1; % Empieza a grabar
    pause(3);      % Tienen 3 segundos para hacer el movimiento
    m.Logging = 0; % Para de grabar
    
    [accel, time] = accellog(m);
    
    % --- EXTRACCIÓN DE CARACTERÍSTICAS (Feature Engineering) ---
    % Calculamos valores que resumen el movimiento
    feat_mean = mean(accel); % Promedio en X, Y, Z
    feat_std  = std(accel);  % Desviación (qué tanto se movió)
    feat_max  = max(accel);  % Pico máximo de fuerza
    
    % Guardamos en una tabla
    nueva_fila = table({gestos{g}}, feat_mean(1), feat_mean(2), feat_mean(3), ...
                 feat_std(1), feat_std(2), feat_std(3), ...
                 'VariableNames', {'Clase', 'MeanX', 'MeanY', 'MeanZ', 'StdX', 'StdY', 'StdZ'});
    dataset = [dataset; nueva_fila];
    
    discardlogs(m); % Limpiar memoria del sensor
    disp('¡Datos guardados!');
end

disp('--- Dataset Completo ---');
disp(dataset);

%% 2. ENTRENAMIENTO (IA)
% En un taller real usaríamos la App Classification Learner, 
% pero para hacerlo rápido, entrenaremos un modelo simple (KNN) aquí:
modelo = fitcknn(dataset, 'Clase', 'NumNeighbors', 1);
disp('IA Entrenada con éxito.');

%% 3. PREDICCIÓN EN TIEMPO REAL (IoT Inferencia)
disp('Iniciando modo detección en vivo...');
for i = 1:5
    pause(1);
    disp('¡MUEVE EL TELÉFONO AHORA!');
    m.Logging = 1; pause(2); m.Logging = 0;
    
    [accel_live, ~] = accellog(m);
    
    % Extraemos las mismas características que en el entrenamiento
    test_feat = [mean(accel_live), std(accel_live)]; 
    
    % La IA decide qué gesto es
    resultado = predict(modelo, test_feat);
    
    fprintf('Resultado de la IA: %s\n', char(resultado));
    discardlogs(m);
end
