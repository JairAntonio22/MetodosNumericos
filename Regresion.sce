clear



///////////////////////////////////////////////////////
//    Regresión_1.sce
//
//    Este programa obtiene las ecuaciones de regresiones
//    del tipo lineal, cuadratica, exponencial y potencial
//    utilizando datos proporcionados por el usuario.
//
//    Bernardo Salazar & Jair Antonio
//
//    23 / Abril  / 2020    version 1.0
//////////////////////////////////////////////////////



////////////////////////////////////////////////////////
//    PedirValores
//
//    Es una funcion que pide los datos para hacer la
//    regresion primero en general y luego especifica
//    las abscisas y ordenadas.
//
//    Parametros: Ningun valor
//
//    Regresa:
//      mMat
/////////////////////////////////////////////////////
function mMat = PedirValores()
    n = 0
    
    while n <= 0 
        n = input("Introduce los valores a procesar: ")
    end
    
    for i = 1 : n
        mMat(1, i) = input("Introduce un valor en x en [" + string(i) + "]: ")
        mMat(2, i) = input("Introduce un valor en y en [" + string(i) + "]: ")
    end
    
endfunction



////////////////////////////////////////////////////////
//    MatrizLineal
//
//    Es una funcion que obtiene la matriz con la cual
//    se va a obtener la ecuacion de regresion 
//    lineal utilizando la matriz proporcionada.
//
//    Parametros: mDatos
//
//    Regresa:
//      mMatriz
/////////////////////////////////////////////////////
function [vCoefs, dR2] = RegresionLineal(mDatos)
    // Obtenemos las columnas
    iNumDatos = size(mDatos, 2)
    
    // Asignamos n
    mMatriz(1, 1) = iNumDatos
    
    // Extendemos la matriz
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        // suma x
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i) 
        // suma x^2
        mMatriz(2, 2) = mMatriz(2, 2) + mDatos(1, i)^2
        // suma y
        mMatriz(1, 3) = mMatriz(1, 3) + mDatos(2, i)
        // suma x*y
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i) * mDatos(2, i)
    end
    
    // Se pasa el valor de suma de x a otro espacio que tambien lo usa
    mMatriz(2, 1) = mMatriz(1, 2)
    
    // Se resuelve la matriz
    mMatriz = ResolverGaussJordan(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs(1) = mMatriz(1, 3)
    vCoefs(2) = mMatriz(2, 3)
    
    dPromedio = 0
    
    // Se calcula las ys con gorros
    for i = 1 : iNumDatos
        vYconGorro(i) = vCoefs(1) + vCoefs(2)*mDatos(1, i)
        dPromedio = dPromedio + mDatos(2, i)
    end
    
    dPromedio = dPromedio / iNumDatos
    
    // Variables para guardar las sumatorias de calculo de r2
    dNumerador = 0
    dDenominador = 0
    
    // Realiza las sumatorias para el calculo de la r2
    for i = 1 : iNumDatos
        dNumerador = dNumerador + (vYconGorro(i) - dPromedio)^2
        dDenominador = dDenominador + (mDatos(2, i) - dPromedio)^2
    end
    
    dR2 = dNumerador / dDenominador
    
endfunction



////////////////////////////////////////////////////////
//    MatrizCuadratica
//
//    Es una funcion que obtiene la matriz con la cual
//    se va a obtener la ecuacion de regresion 
//    cuadratica utilizando la matriz proporcionada.
//
//    Parametros: mDatos
//
//    Regresa:
//      mMatriz
/////////////////////////////////////////////////////
function [vCoefs, dR2] = RegresionCuadratica(mDatos)
    // Obtenemos las columnas
    iNumDatos = size(mDatos, 2)
    
    // Asignamos n
    mMatriz(1, 1) = iNumDatos
    
    // Extendemos la matriz 
    mMatriz(3, 4) = 0
    
    for i = 1 : iNumDatos
        // suma x
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i)^1 
        // suma x^2
        mMatriz(1, 3) = mMatriz(1, 3) + mDatos(1, i)^2
        // suma x^3
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i)^3
        // suma x^4
        mMatriz(3, 3) = mMatriz(3, 3) + mDatos(1, i)^4
        // suma y
        mMatriz(1, 4) = mMatriz(1, 4) + mDatos(2, i)
        // suma x*y
        mMatriz(2, 4) = mMatriz(2, 4) + mDatos(1, i)^1 * mDatos(2, i)
        // suma x^2*y
        mMatriz(3, 4) = mMatriz(3, 4) + mDatos(1, i)^2 * mDatos(2, i)
    end
    
    // Se pasa el valor de suma de x a otro espacio que tambien lo usa
    mMatriz(2, 1) = mMatriz(1, 2) 
    
    // Se pasa el valor de suma de x^2 a otro espacio que tambien lo usa
    mMatriz(2, 2) = mMatriz(1, 3)
    mMatriz(3, 1) = mMatriz(1, 3) 
    
    // Se pasa el valor de suma de x^3 a otro espacio que tambien lo usa
    mMatriz(3, 2) = mMatriz(2, 3) 
    
    // Se resuelve la matriz
    mMatriz = ResolverMontante(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs(1) = mMatriz(1, 4)
    vCoefs(2) = mMatriz(2, 4)
    vCoefs(3) = mMatriz(3, 4)
    
    dPromedio = 0
    
    // Se calcula las ys con gorros
    for i = 1 : iNumDatos
        vYconGorro(i) = vCoefs(1) + vCoefs(2)*mDatos(1, i) + vCoefs(3)*(mDatos(1, i)^2)
        dPromedio = dPromedio + mDatos(2, i)
    end
    
    dPromedio = dPromedio / iNumDatos
    
    // Variables para guardar las sumatorias de calculo de r2
    dNumerador = 0
    dDenominador = 0
    
    // Realiza las sumatorias para el calculo de la r2
    for i = 1 : iNumDatos
        dNumerador = dNumerador + (vYconGorro(i) - dPromedio)^2
        dDenominador = dDenominador + (mDatos(2, i) - dPromedio)^2
    end
    
    dR2 = dNumerador / dDenominador
    
endfunction



////////////////////////////////////////////////////////
//    MatrizExponencial
//
//    Es una funcion que obtiene la matriz con la cual
//    se va a obtener la ecuacion de regresion 
//    exponencial utilizando la matriz proporcionada.
//
//    Parametros: mDatos
//
//    Regresa:
//      mMatriz
/////////////////////////////////////////////////////
function [vCoefs, dR2] = RegresionExponencial(mDatos)
    // Obtenemos las columnas
    iNumDatos = size(mDatos, 2)
    
    // Asignamos n
    mMatriz(1, 1) = iNumDatos
    
    // Extendemos la matriz
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        // suma x
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i) 
        // suma x^2
        mMatriz(2, 2) = mMatriz(2, 2) + mDatos(1, i)^2 
        // suma log(y)
        mMatriz(1, 3) = mMatriz(1, 3) + log(mDatos(2, i)) 
        // suma x log(y)
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i) * log(mDatos(2, i)) 
    end
    
    // Se pasa el valor de suma de x a otro espacio que tambien lo usa
    mMatriz(2, 1) = mMatriz(1, 2) 
    
    // Se resuelve la matriz
    mMatriz = ResolverGaussJordan(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs(1) = exp(mMatriz(1, 3))
    vCoefs(2) = mMatriz(2, 3)
    
    dPromedioLog = 0
    
    // Se calcula las ys con gorros
    for i = 1 : iNumDatos
        vYconGorro(i) = vCoefs(1)*exp(vCoefs(2)*mDatos(1, i))
        dPromedioLog = dPromedioLog + log(mDatos(2, i))
    end
    
    dPromedioLog = dPromedioLog / iNumDatos
    
    // Variables para guardar las sumatorias de calculo de r2
    dNumerador = 0
    dDenominador = 0
    
    // Realiza las sumatorias para el calculo de la r2
    for i = 1 : iNumDatos
        dNumerador = dNumerador + (log(mDatos(2, i)) - log(vYconGorro(i)))^2
        dDenominador = dDenominador + (log(mDatos(2, i)) - dPromedioLog)^2
    end
    
    dR2 = 1 - dNumerador / dDenominador

endfunction



////////////////////////////////////////////////////////
//    MatrizPotencia
//
//    Es una funcion que obtiene la matriz con la cual
//    se va a obtener la ecuacion de regresion 
//    potencia utilizando la matriz proporcionada.
//
//    Parametros: mDatos
//
//    Regresa:
//      mMatriz
/////////////////////////////////////////////////////
function [vCoefs, dR2] = RegresionPotencia(mDatos)
    // Obtenemos las columnas
    iNumDatos = size(mDatos, 2)
    
    // Asignamos n
    mMatriz(1, 1) = iNumDatos
    
    // Extendemos la matriz
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        // suma ln(x)
        mMatriz(1, 2) = mMatriz(1, 2) + log(mDatos(1, i))
        // suma ln(x)^2
        mMatriz(2, 2) = mMatriz(2, 2) + log(mDatos(1, i))^2
        // suma ln(y)
        mMatriz(1, 3) = mMatriz(1, 3) + log(mDatos(2, i))
        // suma ln(x)*ln(y)
        mMatriz(2, 3) = mMatriz(2, 3) + log(mDatos(1, i)) * log(mDatos(2, i))
    end
    
    // Se pasa el valor de suma de x a otro espacio que tambien lo usa
    mMatriz(2, 1) = mMatriz(1, 2)
    
    // Se resuelve la matriz
    mMatriz = ResolverMontante(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs(1) = exp(mMatriz(1, 3))
    vCoefs(2) = mMatriz(2, 3)
    
    dPromedioLog = 0
    
    // Se calcula las ys con gorros
    for i = 1 : iNumDatos
        vYconGorro(i) = vCoefs(1)*mDatos(1, i)^vCoefs(2)
        dPromedioLog = dPromedioLog + log(mDatos(2, i))
    end
    
    dPromedioLog = dPromedioLog / iNumDatos
    
    // Variables para guardar las sumatorias de calculo de r2
    dNumerador = 0
    dDenominador = 0
    
    // Realiza las sumatorias para el calculo de la r2
    for i = 1 : iNumDatos
        dNumerador = dNumerador + (log(mDatos(2, i)) - log(vYconGorro(i)))^2
        dDenominador = dDenominador + (log(mDatos(2, i)) - dPromedioLog)^2
    end
    
    dR2 = 1 - dNumerador / dDenominador
    
endfunction



//////////////////////////////////////////////////////
//    ResolverMontante
//    
//    Resuelve el sistema de ecuaciones dado con el
//    metodo de Montante
//    
//    Parametros: mMatrix
//    
//    Regresa: mResultado
/////////////////////////////////////////////////////
function mResultado = ResolverMontante(mMatrix)
    // Asignacion de pivote
    iPivotAnterior = 1
    
    // Obtiene las dimensiones de la matriz
    [iReng, iCol] = size(mMatrix)
    
    // Iteracion sobre la matriz
    for i = 1 : iReng
        for k = 1 : iReng
            
            // Si no se esta sobre la diagonal
            if (i ~= k) then
                
                // Iteracion de acuerdo a Montante
                for j = i + 1 : iCol
                    // Calcula determinate
                    mMatrix(k,j) = (mMatrix(i,i) * mMatrix(k,j) ...
                     - mMatrix(k,i) * mMatrix(i,j))
                    
                    // Divide resulta entre el pivote anterior
                    mMatrix(k,j) = mMatrix(k,j) / iPivotAnterior
                end
                
                // Llena con 0 la columna 
                mMatrix(k,i) = 0
                
            end
        end
        
        // Asigna nuevo pivote
        iPivotAnterior = mMatrix(i,i)
    end
    
    // Asigna la diagonal de la matriz con el valor del pivote
    for i = 1 : (iReng - 1)
        mMatrix(i,i) = iPivotAnterior 
    end
    
    // Divide el vector de resultado entre el pivote
    for i = 1 : iReng
       mMatrix(i, i) = mMatrix(i, i) / iPivotAnterior
       mMatrix(i, iCol) = mMatrix(i, iCol) / iPivotAnterior
    end
    
    // Regresa matriz
    mResultado = mMatrix
    
endfunction



//////////////////////////////////////////////////////
//    ResolverGaussJordan
//    
//    Resuelve el sistema de ecuaciones dado con el
//    metodo de Gauss-Jordan
//    
//    Parametros: mMatrix
//    
//    Regresa: mResultado
/////////////////////////////////////////////////////
function mResultado = ResolverGaussJordan(mMatrix)
    // Obtener renglon y columna
    [iRenglon, iColumna]= size(mMatrix)
    
    // Iterar sobre la matriz
    for i = 1 : iRenglon
        // Asignacion de pivote
        iPivote = mMatrix(i, i)
        
        // Dividir renglon por pivote
        for j = 1 : iColumna
            mMatrix(i, j) = mMatrix(i, j) / iPivote
        end
        
        // Iterar el resto de la matriz
        for k = 1 : iRenglon
            iFactor = 1;
            
            if (i ~= k) then
                iFactor = -mMatrix(k, i)
                
                for j = 1 : iColumna
                    mMatrix(k, j) = mMatrix(k, j) + iFactor * mMatrix(i, j)
                end
            end
        end
    end
    
    // Regresa matriz
    mResultado = mMatrix
    
endfunction

// Main
sUser = " " 

while (sUser <> "n" & sUser <> "N")
   // Pide renglon y columna de matriz
    mDatos = PedirValores()
    
    // Regresion lineal
    [vCoefsLineales, dR2Lineal] = RegresionLineal(mDatos)
    disp(string(vCoefsLineales(1)) + " " + string(vCoefsLineales(2)) ...
        + " " + string(dR2Lineal))
    
    
    // Regresion cuadratica
    [vCoefsCuadraticos, dR2Cuadratico] = RegresionCuadratica(mDatos)
    disp(string(vCoefsCuadraticos(1)) + " " + string(vCoefsCuadraticos(2)) ...
        + " " + string(vCoefsCuadraticos(3)) + " " + string(dR2Cuadratico))
    
    
    // Regresion exponencial
    [vCoefsExponenciales, dR2Exponencial] = RegresionExponencial(mDatos)
    disp(string(vCoefsExponenciales(1)) + " " + string(vCoefsExponenciales(2)) ...
        + " " + string(dR2Exponencial))
    
    
    // Regresion potencia
    [vCoefsPotencia, dR2Potencia] = RegresionPotencia(mDatos)
    disp(string(vCoefsPotencia(1)) + " " + string(vCoefsPotencia(2)) ...
        + " " + string(dR2Potencia))
    
    /*
    sUser = input("Desea continuar? de no ser asi pulse n: ", "string") 
    */
    
    sUser = " " 
    
end    
