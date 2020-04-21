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
//    16 / Abril  / 2020    version 1.0
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
        mMat(1, i) = input("Introduce un valor en x en [" + string(i) ...
        + "]: ")
        mMat(2, i) = input("Introduce un valor en y en [" + string(i) ...
        + "]: ")
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
function mMatriz = MatrizLineal(mDatos)
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
function mMatriz = MatrizCuadratica(mDatos)
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
function mMatriz = MatrizExponencial(mDatos)
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
function mMatriz = MatrizPotencia(mDatos)
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
    mMat = PedirValores()
    
    // Regresion lineal
    mMatriz = MatrizLineal(mDatos)
    mResultado = ResolverGaussJordan(mMatriz)
    
    // Desplegamos la ecuacion de regresion lineal
    disp("y = " + string(mResultado(1, 3)) + " + "...
        + string(mResultado(2, 3)) + " * x")
    
    // Regresion cuadratica
    mMatriz = MatrizCuadratica(mDatos)
    mResultado = ResolverMontante(mMatriz)
    
    // Desplegamos la ecuacion de regresion cuadratica
    disp("y = " + string(mResultado(1, 4)) + " + "...
        + string(mResultado(2, 4)) + " * x " + string(mResultado(3, 4)) + " * x^2")
    
    // Regresion exponencial
    mMatriz = MatrizExponencial(mDatos)
    mResultado = ResolverGaussJordan(mMatriz)
    
    // Desplegamos la ecuacion de regresion exponencial
    disp("y = " + string(exp(mResultado(1, 3))) + " * e ^ "...
        + string(mResultado(2, 3)) + " * x")
    
    // Regresion potencia
    mMatriz = MatrizPotencia(mDatos)
    mResultado = ResolverMontante(mMatriz)
    
    // Desplegamos la ecuacion de regresion potencia
    disp("y = " + string(exp(mResultado(1, 3))) + " * x ^ "...
        + string(mResultado(2, 3)))
    
    sUser = input("Desea continuar? de no ser asi pulse n: ", "string") 
    
end    
