//+------------------------------------------------------------------+
//|                                             Simple_Indicator.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

      // --- PROPRIEDADES --- //
      
#property indicator_buffers 1;   // buffers: estruturas de dados, como arrays, que guardam informações
#property indicator_plots   1;   // numero de plotagem de indicador no gráfico

#property indicator_label1  "incatro trade acoes 1"   // indicator_label1: tem relaçõa com a quantidade de buffers
#property indicator_type1  DRAW_LINE                  // tipo de indicador, no caso, linha
#property indicator_style1 STYLE_SOLID                // estilo da linha
#property indicator_color1 clrBlue                    // cor da linha
#property indicator_width1 3                          // tamanho, expessura da linha(média))

double bufferIndicador[];           // array contendo os dados do indicador



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
         SetIndexBuffer(0, bufferIndicador, INDICATOR_DATA);
         
         ArrayInitialize(bufferIndicador, EMPTY_VALUE);
//---
   return(INIT_SUCCEEDED);
  }

      // -- função de interação para customizar o indicador ----

int OnCalculate(const int rates_total,    //quantidade total de barras
                const int prev_calculated, // numero/valor da ultima barra calculada
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) { 
                
        if(prev_calculated == 0) {     // se o valor da ultima barra for iugual a zero
          
            for(int i = 0; i < rates_total; i++) {
            
               bufferIndicador[i] = (open[i] + close[i]) / 2;
            }
          
          }      
       // retornar o valor de prev_calculated para próxima chamada
       
       return (rates_total);         
                }