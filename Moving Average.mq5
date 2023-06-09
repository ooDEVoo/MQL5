//+------------------------------------------------------------------+
//|                                               Moving Average.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

      // -- Input Variables - 
      // Estas são as variáveis que seram visíveis para o usuário
      
      input double tradeVolume = 0.1;
      input int stopLoss = 1000;
      input int takeProfit = 1000;
      input int MAperiod = 10;
      
      // -- Global Variables -
      // Estas variáveis serão visualizadas dentro do nosso programa
      
      bool glBuyPlaced, glSellPlaced;  // gl: prefixo de Global
      

int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- Instruções de Trade

   MqlTradeRequest request;  // MqlTradeRequest: objeto que contém os parâmetros da ordem
   MqlTradeResult result;    // MqlTradeResult:  objeto que retorna os resultados de uma solicitação de ordem
   ZeroMemory(request);
   
   // -- Moving Average
   
   double ma[];      // array para guardar os valores do indicador de média móvel
   ArraySetAsSeries(ma, true);
   
   int maHandle=iMA(_Symbol,0,MAperiod,MODE_SMA,0,PRICE_CLOSE);
   CopyBuffer(maHandle,0,0,1,ma);
   
   // -- Close Price
   
   double close[];     // array para guardar os preços de fechamento da média móvel
   ArraySetAsSeries(close,true);    
   CopyClose(_Symbol,0,0,1,close);
   
   // -- Current position irformation
   
   bool openPosition = PositionSelect(_Symbol); // retorna o valor de true se uma posição estiver aberta
                                                // no símbolo corrente, o resultado é armazenado na variável 
                                                // openPosition
   
   long positionType = PositionGetInteger(POSITION_TYPE); //retorna o tipo da posição corrente BUY or SELL
   
   double currentVolume = 0;
   if (openPosition == true) {                             // se a tiver posição em aberto, guarda o valor volume 
      currentVolume = PositionGetDouble(POSITION_VOLUME);  // corrente na variável cuurentVolume
   }
   
   // -- Open Buy market order
   
   if(close[0] > ma[0] && glBuyPlaced == false
      && (positionType != POSITION_TYPE_BUY || openPosition == false)) {
      
      request.action = TRADE_ACTION_DEAL;
      request.type = ORDER_TYPE_BUY;
      request.symbol = _Symbol;
      request.volume = tradeVolume + currentVolume;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      request.sl = 0;
      request.tp = 0;
      request.deviation = 50;
      
      bool sent = OrderSend(request, result);
      
      }
      
      // -- Modify SL/TP
      
      if(resul.retcode == TRADE_RETCODE_PLACED || result.retcode == TRADE_RETCODE_DONE) {
         
         request.action = TRADE_ACTION_SLTP;
         
         PositionSelect(_Symbol);
         double positionOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         
         if(stopLoss > 0) {
            request.sl = positionOpenPrice - (stopLoss * _Point);
         }
         if(takeProfit > 0) {
            request.tp = positionOpenPrice + (takeProfit * _Point);
         }
      }
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
