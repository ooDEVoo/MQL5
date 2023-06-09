//+------------------------------------------------------------------+
//|                                               Moving_Average.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <Trade/Trade.mqh> // insere a biblioteca Ctrade, para facilitar as operações de envio de ordens

   // -- INPUTS --
   
input int lote = 100;
input int periodoCurta = 10;
input int periodoLonga = 50;

   // -- VARIÀVEIS GLOBAIS --
 
// - manipuladores das médias móveis
// o manipulador é onde conseguimos obter os dados da média móvel  
int curtaHandle = INVALID_HANDLE;
int longaHandle = INVALID_HANDLE;

// -- ARRAYS para guardar as informações das médias móveis
double mediaCurta[];
double mediaLonga[];
   
// -- declaração da variável Ctrade
CTrade trade; //variável de nome trade, do tipo Ctrade. Faz o uso da biblioteca Ctrade  
   
int OnInit()
  {
//---
   ArraySetAsSeries(mediaCurta, true);  // ArraySetAsSeries: inverte a posição dos indíces do array
   ArraySetAsSeries(mediaLonga, true);  // assim o indice mais atual será o zero
//---
  
  // atribuir as variáveis de média móvel
  // entre parenteses(simbolo atual do ativo, timeframe atual, perodo media movel, deslocamento, tipo da média, tipo de preço)
  curtaHandle = iMA(_Symbol, _Period, periodoCurta, 0,MODE_SMA, PRICE_CLOSE);
  longaHandle = iMA(_Symbol, _Period, periodoLonga, 0,MODE_SMA, PRICE_CLOSE);
  
  
  
  
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      
       // a cada novo tick, se for uma nova barra, execute
      
      
       // função usada para que seja executado o processo uma vez por barra
       // para economizar processamento
      if(isNewBar()) { 
      
           // - obtenção dos dados necessários
           
           
           
         int copiedCurta = CopyBuffer(curtaHandle, 0, 0, 3, mediaCurta);  //CopyBuffer: copia os dados(do manipulador curtaHandle,                 
                                                                          //nº buffer = 0, posisão inicial = 0, qnt de dados a copiar = 3
                                                                            //ultimos 3 candles, os dados serão copiados para a variavel mediaCurta
         int copiedLonga = CopyBuffer(longaHandle, 0, 0, 3, mediaLonga);  
  
         bool sinalCompra = false;
         bool sinalVenda = false;
         
         
         if(copiedCurta == 3 && copiedLonga == 3) {  //se tiver copiado os ultimos 3 candle em ambas as médias
               
               // - SINAL DE COMPRA --
            if(mediaCurta[1] > mediaLonga[1] && mediaCurta[2] < mediaLonga[2]) {
            
               sinalCompra = true;
               
            }
            
               // -- SINAL DE VENDA
               
             if(mediaCurta[1] < mediaLonga[1] && mediaCurta[2] > mediaLonga[2]) {
               
               sinalVenda = true;
            }      
            }
  
            // -- VERIFICAR SE ESTOU POSICIONADO ---
            bool comprado = false;
            bool vendido = false;
            
            if(PositionSelect(_Symbol)) {   // se houver uma posição aberta no simbolo corrente
            
              
              //  se a posição for de compra
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
               
                  comprado = true;
               }
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                  
                  vendido = true;
               }
            
            
            }
            


               // --- LOGICA DE ROTEAMENTO
         
         // se não houver sinal de compra e venda      
         if(!comprado && !vendido) {
         
            if (sinalCompra) {
            
               trade.Buy(lote, _Symbol, 0, 0, 0, "Compra a mercado"); // (lote, simbolo corrente, preco/a mercado, stopo loss, takeProfit, comentario)
            }
            if (sinalVenda) {
            
            trade.Sell(lote, _Symbol, 0, 0, 0, "Venda a mercado");
            }
        
         }
         
         else   {
            if(comprado) { 
            
               if(sinalVenda) {
            
               trade.Sell(lote*2, _Symbol, 0, 0, 0, "Virada de mão compra -> venda");
               }
            }
            
            else if(vendido) {
            
               if(sinalCompra) {
               
               trade.Buy(lote*2, _Symbol, 0, 0, 0, "Virada de mão venda -> compra");
            }
            }
         }  
  
  
  }
  
  }
  
  
  // -----------------------------------------------------------------------------------
  
  // Se houver uma nova barra
  bool isNewBar() {
  
      // memoriza a hora de abertura da ultima barra na variável static
      static datetime last_time = 0;

      // tempo 
      datetime lastbar_time = (datetime)SeriesInfoInteger(Symbol(), Period(), SERIES_LASTBAR_DATE);
      
      if(last_time == 0) {
       
       // seta a hora e sai
       last_time = lastbar_time;
       return false;
      }

      // se a hora for diferente
      if(last_time != lastbar_time) {
         
         // memoriza a hora e retrona verdadeiro
         last_time = lastbar_time;
         return true;
      }
      // se passarmos por esta linha, então a barra não é nova; return false
      return false;
      }
  
  
  
  
  
  
