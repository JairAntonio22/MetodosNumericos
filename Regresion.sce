clear
clc

///////////////////////////////////////////////////////
//    Regresión_1.sce
//
//    Este programa resuelve ecuaciones lineales de n
//    variables usando una implementación del método
//    de Montante
//
//    Bernardo Salazar & Jair Antonio
//
//    16 / Abril  / 2020    version 1.0
//////////////////////////////////////////////////////



//////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
function mDatos = CargarValores(nombreDelArchivo)
    fDatos = file("open", nombreDelArchivo, "unknown")
    mDatos = read(fDatos, 2, 11)
    file("close", fDatos)
    
endfunction



//////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
function mMatriz = MatrizLineal(mDatos)
    iNumDatos = size(mDatos, 2)
    
    mMatriz(1, 1) = iNumDatos
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i) // sum x
        mMatriz(2, 2) = mMatriz(2, 2) + mDatos(1, i)^2 // sum x^2
        
        mMatriz(1, 3) = mMatriz(1, 3) + mDatos(2, i) // sum y
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i) * mDatos(2, i)   // sum x y
    end
    
    mMatriz(2, 1) = mMatriz(1, 2) // sum x
    
endfunction



//////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
function mMatriz = MatrizCuadratica(mDatos)
    iNumDatos = size(mDatos, 2)
    
    mMatriz(1, 1) = iNumDatos
    mMatriz(3, 4) = 0
    
    for i = 1 : iNumDatos
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i)^1 // sum x
        mMatriz(1, 3) = mMatriz(1, 3) + mDatos(1, i)^2 // sum x^2
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i)^3 // sum x^3
        mMatriz(3, 3) = mMatriz(3, 3) + mDatos(1, i)^4 // sum x^3
                
        mMatriz(1, 4) = mMatriz(1, 4) + mDatos(2, i) // sum y
        mMatriz(2, 4) = mMatriz(2, 4) + mDatos(1, i)^1 * mDatos(2, i)   // sum x y
        mMatriz(3, 4) = mMatriz(3, 4) + mDatos(1, i)^2 * mDatos(2, i)   // sum x^2 y
    end
    
    mMatriz(2, 1) = mMatriz(1, 2) // sum x
    
    mMatriz(2, 2) = mMatriz(1, 3) // sum x^2
    mMatriz(3, 1) = mMatriz(1, 3) // sum x^2
    
    mMatriz(3, 2) = mMatriz(2, 3) // sum x^3
        
endfunction



//////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
function mMatriz = MatrizExponencial(iReng, iCol)
    iNumDatos = size(mDatos, 2)
    
    mMatriz(1, 1) = iNumDatos
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        mMatriz(1, 2) = mMatriz(1, 2) + mDatos(1, i) // sum x
        mMatriz(2, 2) = mMatriz(2, 2) + mDatos(1, i)^2 // sum x^2
        
        mMatriz(1, 3) = mMatriz(1, 3) + log(mDatos(2, i)) // sum log(y)
        mMatriz(2, 3) = mMatriz(2, 3) + mDatos(1, i) * log(mDatos(2, i)) // sum x log(y)
    end
    
    mMatriz(2, 1) = mMatriz(1, 2) // sum x

    
endfunction



//////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
function mMatriz = MatrizPotencia(mDatos)
    iNumDatos = size(mDatos, 2)
    
    mMatriz(1, 1) = iNumDatos
    mMatriz(2, 3) = 0
    
    for i = 1 : iNumDatos
        mMatriz(1, 2) = mMatriz(1, 2) + log(mDatos(1, i)) // sum ln(x)
        mMatriz(2, 2) = mMatriz(2, 2) + log(mDatos(1, i))^2 // sum log(x)^2
        
        mMatriz(1, 3) = mMatriz(1, 3) + log(mDatos(2, i)) // sum log(y)
        mMatriz(2, 3) = mMatriz(2, 3) + log(mDatos(1, i)) * log(mDatos(2, i)) // sum log(x) log(y)
    end
    
    mMatriz(2, 1) = mMatriz(1, 2) // sum x
    
endfunction



//////////////////////////////////////////////////////
//    ResolverMontante
//    
//    Resuelve el sistema de ecuaciones dado con el
//    método de Montante
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
//    método de Gauss-Jordan
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

/*
while (sUser <> "n" & sUser <> "N")
    
    
end*/

// Pide renglon y columna de matriz
    mDatos = CargarValores("Datos.txt")
    
    // Regresion lineal
    mMatriz = MatrizLineal(mDatos)
    mResultado = ResolverGaussJordan(mMatriz)
    
    disp("y = " + string(mResultado(1, 3)) + " + "...
        + string(mResultado(2, 3)) + " * x")
    
    // Regresion cuadratica
    mMatriz = MatrizCuadratica(mDatos)
    mResultado = ResolverMontante(mMatriz)
    
    disp("y = " + string(mResultado(1, 4)) + " + "...
        + string(mResultado(2, 4)) + " * x " + string(mResultado(3, 4)) + " * x^2")
    
    // Regresion exponencial
    mMatriz = MatrizExponencial(mDatos)
    mResultado = ResolverGaussJordan(mMatriz)
    
    disp("y = " + string(exp(mResultado(1, 3))) + " * e ^ "...
        + string(mResultado(2, 3)) + " * x")
    
    // Regresion potencia
    mMatriz = MatrizPotencia(mDatos)
    mResultado = ResolverMontante(mMatriz)
    
    disp("y = " + string(exp(mResultado(1, 3))) + " * x ^ "...
        + string(mResultado(2, 3)))
    
    //sUser = input("Desea continuar? ", "string")
