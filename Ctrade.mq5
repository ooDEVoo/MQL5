//+------------------------------------------------------------------+
//|                                                       Ctrade.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <Mql5Book\trade.mqh>


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
//---
   class Ctrade {
      
      protected:
         MqlTradeRequest;
         // função OpenPosition: p = parâmetro, parâmetros obrogatórios são: symbol, type e volume
         bool OpenPosition(string pSymbol, ENUM_ORDER_TYPE pType, double pVolume,
                           double pStop = 0, double pProfit = 0, string pComment = NULL);
         
      public:
         MqlTradeResult;
         
      bool Ctrade :: OpenPosition(string pSymbol, ENUM_ORDER_TYPE pType, double pVolume,
                           double pStop = 0, double pProfit = 0, string pComment = NULL);
                           {
                           }
      ZeroMemory(request);
      ZeroMemory(result);
      
      request.action = TRADE_ACTION_DEAL;
      request.symbol = pSymbol;
      request.type = pType;
      request.sl = pStop;
      request.tp = pProfit;
      request.comment = pComment;
      request.deviation = deviation;
      request.type_filling = fillType;t
      request.magic = magicNumber;
      
      // verificar se ha posição em aberto, acrescentar o tipo e volume nas variáveis
      double positionVol = 0;
      long positionType = WRONG_VALUE; //WRONG_VALUE: atribui à variável um estado neutro
      
      if(PositionSelect(pSymbol) == true) {
         positionVol = PositionGetDouble(POSITION_VOLUME); // retorna volume da posição
         positionType = PositionGetInteger(POSITION_TYPE); // retorna o tipo da posição
         }
         
      if((pType == ORDER_TYPE_BUY && positionType == POSITION_TYPE_SELL ||
         (pType == ORDER_TYPE_SELL && positionType == POSITION_TYPE_BUY)) {
            
            request.volume = pVolume + positionVol;
         }
         else
            request.volume = pVolume;
            
       // atribuir o preço corrente em compra e venda
       if(pType == ORDER_TYPE_BUY) 
         request.price = SymbolInfoDouble(pSymbol, SYMBOL_ASK); // Symbolo escolhido, no preço atual
       
       else if(pType == ORDER_TYPE_SELL) 
         request.price = SymbolInfoDouble(pSymbol, SYMBOL_BID);  // melhor preço de venda
       
       OrderSend(request, result);
      
   };
   
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
