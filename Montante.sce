
clear



///////////////////////////////////////////////////////
//    Montante_1.sce
//
//    Este programa resuelve ecuaciones lineales de n
//    variables usando una implementación del método
//    de Montante
//
//    Bernardo Salazar & Jair Antonio
//
//    29 / Febrero  / 2020    version 1.0
//////////////////////////////////////////////////////



//////////////////////////////////////////////////////
//    PidoValores
//
//    Es una funcion que pide y valida los valores del 
//    renglón y columna para una matriz
//
//    Parametros: Ningun valor
//
//    Regresa:
//      iRenglones
//      iColumnas
/////////////////////////////////////////////////////
function [iRenglones,iColumnas] = PidoValores()
    iRenglones = -1
    iColumnas = -1
    
    // Pide y valida valores de renglon y columna
    while (iRenglones <= 0)
        iRenglones = int(input("Cuantos renglones quieres que tenga la matriz?: "))
    end
    
    while (iColumnas <= 0)
        iColumnas = int(input("Cuantas columnas quieres que tenga la matriz:? "))
    end
    
endfunction



//////////////////////////////////////////////////////
//    MatrizInput
//
//    Es una función que pide los valores para llenar
//    una matriz
//
//    Parametros:
//      iReng       Renglones de la matriz
//      iCol
//
//    Regresa: mMatrix
/////////////////////////////////////////////////////
function mMatrix = MatrixInput(iReng, iCol)
    // Iteración sobre la matriz para inicializar valores
    for i = 1 : iReng
        for j = 1 : iCol
            mMatrix(i,j) = int(input("Da el elemento [" ...
            +  string(i)+ "," + string(j) + "]: "))
        end
    end
    
endfunction



//////////////////////////////////////////////////////
//    Resolver
//    
//    Resuelve el sistema de ecuaciones dado con el
//    método de Montante
//    
//    Parametros: mMatrix
//    
//    Regresa: mResultado
/////////////////////////////////////////////////////
function mResultado = Resolver(mMatrix)
    // Asignacion de pivote
    iPivotAnterior = 1
    
    // Obtiene las dimensiones de la matriz
    [iReng, iCol] = size(mMatrix)
    
    // Contador de iteraciones
    iCont = 1
    
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
        
        // Imprime iteración actual
        disp("Usted esta en la iteracion " + string(iCont) + "!!!")
        disp(mMatrix)
        
        // Incremento de contador de iteraciones
        iCont = iCont + 1
    end
    
    // Asigna la diagonal de la matriz con el valor del pivote
    for i = 1 : (iReng - 1)
        mMatrix(i,i) = iPivotAnterior 
    end
    
    // Despliega ultima iteracion
    disp("Ultima iteracion")
    disp(mMatrix)
    
    // Divide el vector de resulta entre el pivote
    for i = 1 : iReng
       mMatrix(i, iCol) = mMatrix(i, iCol) / iPivotAnterior
    end
    
    // Regresa matriz
    mResultado = mMatrix
endfunction

//////////////////////////////////////////////////////
//    DisplayMatrix
//    
//    Imprime los resultados de la matriz
//    
//    Parametros:
//      MAT 
//   Regresa:
//      Ningun Valor
/////////////////////////////////////////////////////
function DisplayMatrix(MAT)
    [r, c] = size(MAT)
    for i = 1 : r
        sLinea = ""
        for j = 1 : c
            if j == c
                sLinea = sLinea + string(MAT(i,j)) 
            else
                sLinea = sLinea + string(MAT(i,j)) + " , "
            end
        end
        disp(sLinea)
    end
endfunction



// Main
sUser = " " 

while (sUser <> "n" & sUser <> "N")
    // Pide renglon y columna de matriz
    [iReng, iCol] = PidoValores()
    
    // Inicializa matriz
    mMatrix = MatrixInput(iReng,iCol)
    
    // Imprime matriz de entrada
    disp("Matriz original: ")
    DisplayMatrix(mMatrix)
    
    // Resuelve sistema de ecuaciones
    disp("Procedemos a calcularla")
    mMatrix = Resolver(mMatrix)
    
    // Imprime resultados
    DisplayMatrix(mMatrix)
    
    // Pregunta si se desea volver a ejecutar el programa
    sUser = input("Si no desea realizar otra matriz teclee N: ",'string')
end
