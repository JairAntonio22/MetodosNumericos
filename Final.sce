clear



//////////////////////////////////////////////////////
//    getValores
//    
//    Dado un archivo de Excel, se lee la matriz a Scilab
//    para su manejo
//    
//    Parametros: Ninguno
//    
//    Regresa: mCrearMatriz
/////////////////////////////////////////////////////
function mCrearMatriz = getValores()
    //Probar que el archivo se lea
    bCiclo = %T
    while bCiclo do
        try
            sNombre = input("Introduzca el nombre del archivo (con extension xls): ",'string') 
            //lee el archivo de Excel (libro)
            fLibro = readxls(sNombre+".xls")
              
            bCiclo = %F
        catch
            disp("Error archivo no encontrado!")
            bCiclo = %T
        end
    end
    
    iHoja = -1
    while (iHoja <= 0)
        iHoja = input("Introduzca la hoja de su excel: ")    
    end
    
    //lee la hoja donde está la matriz
    fHoja = fLibro(iHoja)
    //extraer los valores
    mCrearMatriz = fHoja(:,:)    
endfunction



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
function [dResultado,bBandera] = ValorMedio(vDatos)
    // Se incializan variables para calculo del valor esperado
    dEsperado = 0
    dTotal = 0
    
    dValor = vDatos(1)
    for j = 2 : size(vDatos,1)
        if (dValor ~= vDatos(j)) then
            dValor = vDatos(j)
            break
        end
    end
    
    bBandera = %T
    if (dValor == vDatos(1)) then
        bBandera = %F
    end
    
    for i = 1 : size(vDatos,1)
        // Suma de terminos para valor esperado
        dEsperado = dEsperado + i*vDatos(i)
        
        //Suma de valores 
        dTotal = dTotal + vDatos(i)
        
        if (vDatos(i) < 0)then
            bBandera = %F
            break
        end
    end
    
    // Se asigna el resultado al cociente del valor esperado entre el total
    dResultado = dEsperado/dTotal
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



////////////////////////////////////////////////////////
//    
//    Main
//    
/////////////////////////////////////////////////////
sUser = " " 
while (sUser <> "n" & sUser <> "N")
    mMatriz = getValores()
    disp(mMatriz)
    iIndice = 1 
    for i = 1 : size(mMatriz,2)
        vVector = flipdim(mMatriz(:,i),dim=1)
        disp(vVector)
        [dValorMedio,bBandera] = ValorMedio(vVector)
        if (bBandera)then
            mDatos(1,iIndice) = i
            mDatos(2,iIndice) = dValorMedio
            iIndice = iIndice + 1
        end  
        
    end
    if (size(mDatos,2) ~= 0) then
        // Regresion lineal
        [vCoefsL, dR2L] = RegresionLineal(mDatos)
        vRs2(1) = dR2L
    
        // Regresion cuadratica
        [vCoefsC, dR2C] = RegresionCuadratica(mDatos)
        vRs2(2) = dR2C
    
        // Regresion exponencial
        [vCoefsE, dR2E] = RegresionExponencial(mDatos)
        vRs2(3) = dR2E
    
        // Regresion potencia
        [vCoefsP, dR2P] = RegresionPotencia(mDatos)
        vRs2(4) = dR2P
    
        // Reporte de resultados
        disp("I) Modelos:")
    
        disp("    Lineal: y = " + string(vCoefsL(1)) + " + " + ...
            string(vCoefsL(2)) + " * x")
        disp("         R^2 =" + string(dR2L))
    
        disp("    Cuadratica: y = " + string(vCoefsC(1)) + " + " + ...
            string(vCoefsC(2)) + " * x + " +  string(vCoefsC(3)) + " * x^2")
        disp("         R^2 =" + string(dR2C))
    
        disp("    Exponencial: y = " + string(vCoefsE(1)) + " * e ^ (" + ...
            string(vCoefsE(2)) + " * x)")
        disp("         R^2 =" + string(dR2E))
    
        disp("    Potencial: y = " + string(vCoefsP(1)) + " *  x ^ (" + ...
            string(vCoefsP(2)) + ")")
        disp("         R^2 =" + string(dR2P))
    
        //Graficas 
        clf(); //Eliminas la grafica previa en memoria
        xtitle("Estimacion de comportamiento del calor");
        xname("Proyecto Final Metodos Numericos");
        iCol = size(mMatriz,2) 
        iReng = size(mMatriz,1)  
        iDominio = linspace(1,iCol,15)
        //Pone la cuadricula a la grafica
        xgrid(303030,0.5,7)
    
        //Grafica de puntos
        iXPuntos = mDatos(1,:)
        iYPuntos = mDatos(2,:)
        plot(iXPuntos,iYPuntos,'or') // circulo negro
    
        // Imprimir sensores
        for i = 1 : iCol 
            for j = 1 : iReng
                plot(i,j,'*b') // asterisco azul 
            end
        end
    
        // Elige el la mayor R^2
        [value, index] = max(vRs2)
    
        replot([0,0,iCol+1,iReng+1])
        select index
        case 1 then
            disp("El mejor modelo sera el lineal")
            vFuncionLineal = vCoefsL(1) + (vCoefsL(2)* iDominio)
            plot(iDominio,vFuncionLineal,'r') // rojo
            legend(['Puntos de calor';'Sensores'],pos = 4)
        case 2 then
            disp("El mejor modelo sera el cuadratico")
            vFuncionCuadratica = vCoefsC(1) + (vCoefsC(2)*iDominio) + ...
            (vCoefsC(3)*(iDominio^2))
            plot(iDominio,vFuncionCuadratica,'r') // rojo
            legend(['Puntos de calor';'Sensores'],pos = 4)
        case 3 then
            disp("El mejor modelo sera el exponencial")
            vFuncionExponencial = vCoefsE(1) * exp(vCoefsE(2) * iDominio)
            plot(iDominio,vFuncionExponencial,'b')
            legend(['Puntos de calor';'Sensores'],pos = 4)
        case 4 then
            disp("El mejor modelo sera el potencial")
            vFuncionPotencia = vCoefsP(1) * iDominio ^ vCoefsP(2)
            plot(iDominio,vFuncionPotencia,'r')
            legend(['Puntos de calor';'Sensores'],pos = 4)
        end
    else
        disp("Datos no Validos!!!")
    end
    
    sUser = input("Si no desea realizar otra lectura de calor teclee N: ",'string')
end    
