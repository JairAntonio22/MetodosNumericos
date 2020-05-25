clear



//////////////////////////////////////////////////////
//    ValorMedio
//    
//    Dado un vector de datos, estima cual es el valor
//    medio
//    
//    Parametros: vDatos, dX
//    
//    Regresa: dResultado
/////////////////////////////////////////////////////
function dResultado = ValorMedio(vDatos)
    // Se incializan variables para calculo del valor esperado
    dEsperado = 0
    dTotal = 0
    
    for i = 1 : size(datos)
        // Suma de terminos para valor esperado
        dEsperado = dEsperado + i*datos(i)/dTotal
        
        //Suma de valores 
        dTotal = dTotal + size(i)
    end
    
    // Se asigna el resultado al cociente del valor esperado entre el total
    dResultado = dEsperado/dTotal
    
endfunction



//////////////////////////////////////////////////////
//    InterpolacionLagrange
//    
//    Dado un vector de datos y una x, encuentra el valor
//    x evaluado en un polinomio de Lagrange
//    
//    Parametros: vDatos, dX
//    
//    Regresa: dResultado
/////////////////////////////////////////////////////
function dResultado = InterpolacionLagrange(vDatos, dX)
    // Se inicializa la sumatoria de terminos
    dSuma = 0
    
    // Ciclo que lleva el control de la suma de terminos
    for j = 1 : size(datos)
        dTermino = datos(i)
        
        // Ciclo que lleva el calculo de los terminos individuales
        for m = 1 : size(datos)
            if (m <> j) then
                // Acumulacion de terminos del producto
                dTermino = dTermino*(dX - m)/(j - m)
            end
        end
        
        // Acumulacion de terminos de la sumatoria
        dSuma = dSuma + dTermino
    end
    
    dResultado = dSuma
    
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



////////////////////////////////////////////////////////
//    RegresionLineal
//
//    Es una funcion que calcula los coefiecientes de
//    la regresion lineal y tambien calcula su r^2
//
//    Parametros: mDatos
//
//    Regresa:
//      vCoefs
//      dR2
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
    mMatriz = ResolverMontante(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs = mMatriz(:,3)
    
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
//    RegresionCuadratico
//
//    Es una funcion que calcula los coefiecientes de
//    la regresion cuadratica y tambien calcula su r^2
//
//    Parametros: mDatos
//
//    Regresa:
//      vCoefs
//      dR2
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
    vCoefs = mMatriz(:,4)
    
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
//    RegresionExponencial
//
//    Es una funcion que calcula los coefiecientes de
//    la regresion exponencial y tambien calcula su r^2
//
//    Parametros: mDatos
//
//    Regresa:
//      vCoefs
//      dR2
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
    mMatriz = ResolverMontante(mMatriz)
    
    // Se guarda el vector con los coeficientes de la regresion
    vCoefs = mMatriz(:,3)
    vCoefs(1) = exp(vCoefs(1))
    
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
//    RegresionPotencial
//
//    Es una funcion que calcula los coefiecientes de
//    la regresion potencial y tambien calcula su r^2
//
//    Parametros: mDatos
//
//    Regresa:
//      vCoefs
//      dR2
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
    vCoefs = mMatriz(:,3)
    vCoefs(1) = exp(vCoefs(1))
    
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



// Main
sUser = " " 

while (sUser <> "n" & sUser <> "N")
    
end    