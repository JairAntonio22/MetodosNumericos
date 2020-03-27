clear
//Jair acuerdate de nombrarlo como Montante_1.sce
///////////////////////////////////////////////////////
//    Montante_1.sce
//
//    
//    
//    
//
//    Bernardo Salazar & Jair Antonio Bautista
//
//    29 / Febrero  / 2020    version 1.0
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
//  PidoValores
//
//  
//
//   Parametros:
//     Ningun valor
//   Regresa:
//     iRenglones       
//     iColumnas
/////////////////////////////////////////////////////
function [iRenglones,iColumnas] = PidoValores()
    iRenglones = int(input("Cuantos renglones quieres que tenga la matriz?: "))
    iColumnas = int(input("Cuantas columnas quieres que tenga la matriz:? "))
endfunction

//////////////////////////////////////////////////////
//  MatrizInput
//
//  
//
//   Parametros:
//     iReng
//      iCol
//   Regresa:
//      matMatrizInicial
/////////////////////////////////////////////////////
function matMatrizInicial = MatrizInput(iReng, iCol)
    for i = 1 : iReng
        for j = 1 : iCol
            matMatrizInicial(i,j) = int(input("Da el elemento [" ...
            +  string(i)+ "," + string(j) + "]: "))
        end
    end
endfunction

//////////////////////////////////////////////////////
//  GetMatrix
//
//  
//
//   Parametros:
//     matMatrix
//      iReng
//      iCol
//   Regresa:
//      matMatrizResultado
//      iPivotAnterior
/////////////////////////////////////////////////////
function [matMatrizResultado,iPivotAnterior] = GetMatrix(matMatrix, iReng, iCol)
    iPivotAnterior = 1
    iCont = 1
    for i = 1 : iReng
        for k = 1 : iReng
            if (i ~= k) then
                for j = i + 1 : iCol
                    matMatrix(k,j) = (matMatrix(i,i) * matMatrix(k,j) ...
                    - matMatrix(k,i) * matMatrix(i,j)) / iPivotAnterior
                end
                matMatrix(k,i) = 0         
            end
        end
        iPivotAnterior = matMatrix(i,i)
        disp("Usted esta en la iteracion " + string(iCont) + "!!!")
        iCont = iCont + 1
        disp(matMatrix)
    end

    for i = 1 : (iReng - 1)
        matMatrix(i,i) = iPivotAnterior 
    end
    
    disp("Ultima iteracion")
    disp(matMatrix)

    matMatrizResultado = matMatrix
endfunction

//////////////////////////////////////////////////////
//  DisplayMatrix
//
//  
//
//   Parametros:
//     matMatriz
//      iPivote
//      iReng
//      iCol
//   Regresa:
//      arrResultado
/////////////////////////////////////////////////////
function arrResultado = DisplayMatrix(matMatriz,iPivote,iReng,iCol)
    for i = 1 : iReng
       arrResultado(i) = matMatriz(i,iCol) / iPivote 
    end
    
    disp("El vector resultado de su matriz es: ")
    disp(arrResultado)
    disp("zaz")
endfunction

// Main
iUserResp = 1
while (iUserResp ~= 0) 
    [iReng, iCol] = PidoValores()
    matMatrizInicial = MatrizInput(iReng,iCol)
    disp("Su matriz original es: ")
    disp(matMatrizInicial)
    disp("Procedemos a calcularla")
    [matMatrizResult,iPivote] = GetMatrix(matMatrizInicial,iReng,iCol)
    arrResultado = DisplayMatrix(matMatrizResult,iPivote,iReng,iCol)
    iUserResp = int(input("Si no desea realizar otra matriz teclee 0: "))
end
