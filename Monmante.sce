clear


function [iRenglones,iColumnas] = PidoValores()
    iRenglones = int(input("Cuantos renglones quieres que tenga la matriz?: "))
    iColumnas = int(input("Cuantas columnas quieres que tenga la matriz:? "))
endfunction

function mMatriz_inicial = Matriz_input(iReng, iCol)
    for i = 1 : iReng
        for j = 1 : iCol
            mMatriz_inicial(i,j) = int(input("Da el elemento [" ...
            +  string(i)+ "," + string(j) + "]: "))
        end
    end
endfunction


function [mMatriz_resultado,iPivotAnterior] = GetMatrix(mMatrix, iReng, iCol)
    iPivotAnterior = 1
    iCont = 1
    for i = 1 : iReng
        for k = 1 : iReng
            if (i ~= k) then
                for j = i + 1 : iCol
                    mMatrix(k,j) = (mMatrix(i,i) * mMatrix(k,j) ...
                    - mMatrix(k,i) * mMatrix(i,j)) / iPivotAnterior
                end
                mMatrix(k,i) = 0         
            end
        end
        iPivotAnterior = mMatrix(i,i)
        disp("Usted esta en la iteracion " + string(iCont) + "!!!")
        iCont = iCont + 1
        disp(mMatrix)
    end

    for i = 1 : (iReng - 1)
        mMatrix(i,i) = iPivotAnterior 
    end
    
    disp("Ultima iteracion")
    disp(mMatrix)

    mMatriz_resultado = mMatrix

endfunction


//donde el prefijo a significa arreglo
function aResultado = DisplayMatrix(mMatriz,iPivote,iReng,iCol)
    for i = 1 : iReng
       aResultado(i) = mMatriz(i,iCol) / iPivote 
    end
    
    disp("El vector resultado de su matriz es: ")
    disp(aResultado)
    disp("zaz")
endfunction



//Main
iUserResp = 1
while (iUserResp ~= 0) 
    [iReng, iCol] = PidoValores()
    mMatriz_inicial = Matriz_input(iReng,iCol)
    disp("Su matriz original es: ")
    disp(mMatriz_inicial)
    disp("Procedemos a calcularla")
    [mMatriz_Result,iPivote] = GetMatrix(mMatriz_inicial,iReng,iCol)
    DisplayMatrix(mMatriz_Result,iPivote,iReng,iCol)
    iUserResp = int(input("Si no desea realizar otra matriz teclee 0: "))
end
