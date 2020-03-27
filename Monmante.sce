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


function mMatriz_resultado = GetMatrix(mMatrix, iReng, iCol)
    iPivotAnterior = 1
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
        disp(mMatrix)
    end

    for i = 1 : (iReng - 1)
        mMatrix(i,i) = iPivotAnterior 
    end

    disp(mMatrix)

    for i = 1 : iReng
        X(i) = mMatrix(i,iCol) / iPivotAnterior
    end

    disp(X)

endfunction


function DisplayMatrix(mMatriz)
endfunction



//Main

[iReng, iCol] = PidoValores()
mMatriz_inicial = Matriz_input(iReng,iCol)
disp(GetMatrix(mMatriz_inicial,iReng,iCol))

